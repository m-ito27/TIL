## rails-settings-cached gemのコードリーディング

- 設定の読み出し方、値の更新の仕方などが興味があったので読んでみた
- `rails-settings-cached`のバージョンは2.9.4

### 1.fieldの定義で読み出しと上書きのメソッドを提供している仕組み

#### 簡単なgemの使い方

- ユーザーが以下のように設定ファイルを書くと`Setting.admin_email`のような形で値を設定できる
- `Setting.admin_email = 'abc'`のようにすると値をDBに保存し、今後はその値が使われる

```ruby
class Setting < RailsSettings::Base
  cache_prefix { "v1" }

  field :admin_email, default: "admin@example.com", type: :string
end
```

#### 対応するコード

```ruby :rails-settings-cached-2.9.4/lib/rails-settings/base.rb
def field(key, **opts)
  _define_field(key, **opts)
end

private

def _define_field(key, default: nil, type: :string, readonly: false, separator: nil, validates: nil, **opts)
  key = key.to_s

  raise ProtectedKeyError.new(key) if PROTECTED_KEYS.include?(key)

  field = ::RailsSettings::Fields::Base.generate(
    scope: @scope, key: key, default: default,
    type: type, readonly: readonly, options: opts,
    separator: separator, parent: self
  )
  @defined_fields ||= []
  @defined_fields << field

  define_singleton_method(key) { field.read }

  unless readonly
    define_singleton_method("#{key}=") { |value| field.save!(value: value) }

    if validates
      validates[:if] = proc { |item| item.var.to_s == key }
      send(:validates, key, **validates)
      define_method(:read_attribute_for_validation) { |_key| self.value }
    end
  end

  if type == :boolean
    define_singleton_method("#{key}?") do
      send(key)
    end
  end

  # delegate instance get method to class for support:
  # setting = Setting.new
  # setting.admin_emails
  define_method(key) do
    self.class.public_send(key)
  end
end
```

#### コードリーディグしてわかったこと

- `field = ::RailsSettings::Fields::Base.generate(...)`の定義は以下
  - `type`の定義に応じて、`RailsSettings::Fields::XXX`のインスタンスを作っている

```ruby :rails-settings-cached-2.9.4/lib/rails-settings/fields/base.rb
class << self
  def generate(**args)
    fetch_field_class(args[:type]).new(**args)
  end

  private

  def fetch_field_class(type)
    field_class_name = type.to_s.split("_").map(&:capitalize).join("")
    begin
      const_get("::RailsSettings::Fields::#{field_class_name}")
    rescue StandardError
      ::RailsSettings::Fields::String
    end
  end
end
```

-  `define_singleton_method(key) { field.read }`の部分で、fieldに記載したものを読み出しメソッドにしている
- `define_singleton_method("#{key}=") { |value| field.save!(value: value) }`の部分で、更新用のメソッドを定義している
  - `=`で`field.save!`が呼ばれる仕組み
- ちなみに、真偽値の場合は以下で`?`メソッドも提供するようにしているのもわかる

### 設定値をDB→デフォルト値という順番で読み出す箇所のコード

- 前述の通り、`field.read`を見れば良い

#### 対応するコード

```ruby :rails-settings-cached-2.9.4/lib/rails-settings/fields/base.rb
def read
  return deserialize(default_value) if readonly || saved_value.nil?

  deserialize(saved_value)
end

def deserialize(value)
  raise NotImplementedError
end

def saved_value
  return parent.send(:_all_settings)[key] if table_exists?

  # Fallback to default value if table was not ready (before migrate)
  puts(
    "WARNING: table: \"#{parent.table_name}\" does not exist or not database connection, `#{parent.name}.#{key}` fallback to returns the default value."
  )
  nil
end
```

#### コードリーディグしてわかったこと

- DBに値が保存されている場合（`saved_value`が存在する場合）はその値を引数にして、そうでない場合はデフォルト値を引数にして`deserialize`を呼んでいる
- `deserialize`は、`field`の各クラスに実装されている
  - 例えば、`RailsSettings::Fields::Hash`では、`with_indifferent_access`でkeyに対して文字列でもシンボルでもアクセスできるようにされていることがわかる

```ruby :rails-settings-cached-2.9.4/lib/rails-settings/fields/hash.rb
module RailsSettings
  module Fields
    class Hash < ::RailsSettings::Fields::Base
      def deserialize(value)
        return nil if value.nil?

        return value unless value.is_a?(::String)

        load_value(value).deep_stringify_keys.with_indifferent_access
      end
    end
  end
end
```

- DB設定値（`_all_settings`）からkeyで探し、一致すればそれを返すことになっている

### 値のキャッシュの仕方

- `saved_value`の`parent.send(:_all_settings)[key]`の中身を見れば良い
  - `parent`はユーザー定義の`Setting`クラス

#### 対応するコード

```ruby :rails-settings-cached-2.9.4/lib/rails-settings/base.rb
def _all_settings
  RequestCache.all_settings ||= cache_storage.fetch(cache_key, expires_in: 1.week) do
    vars = unscoped.select("var, value")
    result = {}
    vars.each { |record| result[record.var] = record.value }
    result.with_indifferent_access
  end
end
```

#### コードリーディングしてわかったこと

- Railsのキャッシュの仕組みを使って、キャッシュされたものがなければすべての値をselectで取得し、そこから値を探している

### 「=」でDB保存をしているコード

- 前述の通り、`=`で`field.save!`が呼ばれる仕組み

```ruby :rails-settings-cached-2.9.4/lib/rails-settings/fields/base.rb
def save!(value:)
  serialized_value = serialize(value)
  parent_record = parent.find_by(var: key) || parent.new(var: key)
  parent_record.value = serialized_value
  parent_record.save!
  parent_record.value
end
```

- 値を読み込んで、すでに存在するか判断した上でsaveしているというシンプルな作り
