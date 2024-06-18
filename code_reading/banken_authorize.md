# Banken gemのauthorize!を読む

Rails 7.1.3.3
banken 1.0.3

## まとめ

- 全体的に非常にシンプルなコードで特に難しいことはしていない
- Loyaltyを探すのは`LoyaltyFinder`という専用のクラスで担っている
- エラーは`StandardError`を継承し、`new`の引数にメッセージを渡している（独自のエラーを定義する方法を知らなかったので勉強になった）

## authorize!メソッドについて

```ruby:banken-1.0.3/lib/banken.rb
module Banken
  def authorize!(record=nil)
    @_banken_authorization_performed = true

    loyalty = loyalty(record)
    unless loyalty.public_send(banken_query_name)
      raise NotAuthorizedError.new(controller: banken_controller_name, query: banken_query_name, loyalty: loyalty)
    end

    true
  end
end
```

### `@_banken_authorization_performed` ってなんだ？

- Rails7の環境では関係なさそう
- Rails3まで？あった`hide_action`というのに関連していた

### Loyaltyの見つけ方は？

- `authorize!`メソッドの中で以下が実行される

```ruby
loyalty = loyalty(record)
```

- loyaltyメソッドは以下

```ruby:banken-1.0.3/lib/banken.rb
module Banken
  def loyalty(record=nil, controller_name=nil)
    controller_name = banken_controller_name unless controller_name
    Banken.loyalty!(controller_name, banken_user, record)
  end
end
```

- 少なくとも`authorize!`メソッドから呼ばれる場合は`controller_name`は`nil`になりそう
- `banken_controller_name`メソッドでは`params[:controller]`でコントローラ名とってきているだけ
- `Banken.loyalty!`の中身は以下

```ruby
module Banken
  class << self
    def loyalty!(controller_name, user, record=nil)
      LoyaltyFinder.new(controller_name).loyalty!.new(user, record)
    end
  end
end
```

- `LoyaltyFinder`でコントローラ名に対応したloyaltyを探している
- `LoyaltyFinder`の`loyalty!`メソッドと関連メソッドは以下

```ruby
module Banken
  class LoyaltyFinder

    SUFFIX = "Loyalty"

    def loyalty!
      loyalty || raise(NotDefinedError, "unable to find loyalty `#{loyalty_name}` for `#{controller_name}`")
    end

    def loyalty
      loyalty_name.constantize
    rescue NameError
      nil
    end

    private

    def loyalty_name
      "#{controller_name.camelize}#{SUFFIX}"
    end
  end
end
```

- コントローラ名を`camelize`したものと`Loyalty`という文字列をくっつけたものをLoyaltyにする、極めてシンプルな実装方法
- 上記の文字列を`constantize`でクラスの形式にして返すまで行っている

## 実際の認証方法

- bankenの`authorize!`メソッドの中で以下が実行されている

```ruby
loyalty.public_send(banken_query_name)

def banken_action_name
  params[:action]
end

def banken_query_name
  "#{banken_action_name}?"
end
```

- `params`からアクション名を取り出し、`?`を文字列結合しているだけのシンプルな方法

### NotAuthorizedErrorの中身は？

- bankenの`authorize!`メソッドの中で権限がなかった場合、以下が定義されている

```ruby
raise NotAuthorizedError.new(controller: banken_controller_name, query: banken_query_name, loyalty: loyalty)
```

- `NotAuthorizedError`についてのコードは以下

```ruby:banken-1.0.3/lib/banken/error.rb
module Banken
  class Error < StandardError; end

  class NotAuthorizedError < Error
    attr_reader :controller, :query, :loyalty

    def initialize(options={})
      if options.is_a? String
        message = options
      else
        @controller = options[:controller]
        @query      = options[:query]
        @loyalty    = options[:loyalty]

        message = options.fetch(:message) { "not allowed to #{query} of #{controller} by #{loyalty.inspect}" }
      end

      super(message)
    end
  end
end
```

- 権限がない場合、引数の`options`はHashで渡ってくる
- `"not allowed to ..."`の文字列を作成した上で、親クラスである`StandardError`の`new`の引数として渡している
- `StandardError`の`new`に引数で文字列を渡すと、それがエラーメッセージになる

```ruby:rails console
e = StandardError.new('No!!')
e.message
#=> "No!!"
```
