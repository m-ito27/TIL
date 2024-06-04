## はじめに

先日、Railsガイドを読んでいたら、`sandbox_by_default`という設定がRails7.1から追加されたことを知りました。
本番環境での操作ミスを低減できるので良いなと感じ、早速業務で使っているアプリでもこの設定を有効にしました。

この設定ってどういうコードで実現しているんだろうというのを疑問に思ったので、`sandbox_by_default`のPRを見ながらざっくりRailsのコードリーディングしてみました。

https://github.com/rails/rails/pull/48984

## （まとめ）PRと関連のRailsコードを読んでわかったこと

- Railsでconfigを管理しているのは`Rails::Application::Configuration`クラス
- コンソールでのオプション管理を行うのは`Rails::Command::ConsoleCommand`クラス
  - そのうち、オプションの管理をしているのは`Thor::Options`クラス
- 機能としてはただ単に設定を追加しただけに見えるが、PRを見ると、明示的にオプションをfalseで指定した時にはオプションを優先するといった考慮がされているのがわかった

## コードリーディング内容

### 1. railties/lib/rails/application/configuration.rb への変更

`Rails::Application::Configuration`クラスの`attr_accessor`に`sandbox_by_default`が追加されている。

`Rails::Application::Configuration`クラスって？
=> `config/application.rb`の中に`config.xxx`の形で設定を書くが、この`config`が`Rails::Application::Configuration`クラスのインスタンス。

`initialize`の中で以下を設定し、デフォルトはfalseとして設定する。

```ruby
@sandbox_by_default = false
```

`config.sandbox_by_default = true`とすることで値を設定できるのは、
`Rails::Application::Configuration`クラスのインスタンスのアクセサメソッドが定義されているので、falseをtrueに書き換えているということ。

### 2. railties/lib/rails/commands/console/console_command.rb への変更

#### class_optionへの変更

class_optionとは？の説明はRailsガイドにあった。

https://railsguides.jp/generators.html#%E3%82%B8%E3%82%A7%E3%83%8D%E3%83%AC%E3%83%BC%E3%82%BF%E3%81%AE%E3%82%B3%E3%83%9E%E3%83%B3%E3%83%89%E3%83%A9%E3%82%A4%E3%83%B3%E3%82%AA%E3%83%97%E3%82%B7%E3%83%A7%E3%83%B3

`default: false`というのを見て気づいたが、`--sandbox`（`-s`）のオプションには引数で`boolean`が渡せる。

```bash
rails c -s false
#=> sandboxモードで起動しない

rails c -s true
#=> sandboxモードで起動する
```

疑問: 何も渡さない場合はtrueになるのはなんで？どこで制御している？

1. railsコンソールを起動すると、`class_option`を定義している`Rails::Command::ConsoleCommand`クラスのinitializeメソッドが呼ばれる
  - `vendor/bundle/ruby/3.1.0/gems/railties-7.1.3.3/lib/rails/commands/console/console_command.rb`
  - `local_options`という引数に `["-s", "false"]`や`["-s"]`というかたちで値が渡されている
  - その中でsuperで`Rails::Command::Base`が呼ばれる
    - `vendor/bundle/ruby/3.1.0/gems/thor-1.3.0/lib/thor/base.rb`

```ruby
module Command
  class ConsoleCommand < Base
    # 略
    class_option :sandbox, aliases: "-s", type: :boolean, default: nil,
      desc: "Rollback database modifications on exit."

    def initialize(args = [], local_options = {}, config = {})
      # 略
      super(args, local_options, config) # local_options => ["-s", "false"]や["-s"]
    end
  end
end
```

2. `Rails::Command::Base`のinitializeの中の`opts.parse(array_options)`でオプションのパースを行っている
  - `array_options`には `["-s", "false"]`や`["-s"]`の値が入っている
  - `opts`は`Thor::Options`のインスタンス

```ruby
module Base
  # 略
  def initialize(args = [], local_options = {}, config = {})
    # 略
    if local_options.is_a?(Array)
      array_options = local_options
      hash_options = {}
    else
      # 略
    end

    opts = Thor::Options.new(parse_options, hash_options, stop_on_unknown, disable_required_check, relations)

    self.options = opts.parse(array_options)
    # 略
  end
end
```

3. `opts.parse`の中の`parse_peek(switch, options)`の中で実際にパースしている
  - `vendor/bundle/ruby/3.1.0/gems/thor-1.3.0/lib/thor/parser/options.rb`
  - `parse`の中で`parse_peek`を呼ぶ
  - `parse_peek`の中で`parse_boolean`が呼ばれて、オプションのキー(`--sandbox`)に対する値が渡されているかどうかを見て、値が渡されている場合は値をパースする

```ruby
class Thor
  class Options < Arguments
    def parse(args)
      # 略
      result = parse_peek(switch, option)
      assign_result!(option, result)
      # 略
      assigns
    end

    private

    def parse_peek(switch, option)
      # 略
      send(:"parse_#{option.type}", switch)　# option.typeはbooleanなのでparse_booleanメソッドが呼ばれる
    end

    def parse_boolean(switch)
      if current_is_value?
        if ["true", "TRUE", "t", "T", true].include?(peek)
          shift
          true
        elsif ["false", "FALSE", "f", "F", false].include?(peek) # 'false'という文字をfalseにする
          shift
          false
        else
          @switches.key?(switch) || !no_or_skip?(switch)
        end
      else # 値がない場合は下記の処理をする
        @switches.key?(switch) || !no_or_skip?(switch) # --sandboxがkeyに含まれているのでtrueを返す
      end
    end
  end
end
```

#### sandbox?メソッドへの変更

class_optionの変更にあるように、デフォルト値が`nil`になっている。
つまり、`--sandbox`のオプションを使用せずrailsコンソール起動した場合、Rails7.0までは、`options[:sandbox]`が`false`だったが、Rails7.1からは`nil`を返すことになる。

この修正によって、以下の2点がわかる。
- `rails c --sandbox false`のように「オプションを明示的にfalseで指定した時」と`rails c`のように「オプションを指定しないとき」の区別がつくようになる。
- オプションを明示的で指定したときは、configの設定に関わらずオプションの方を優先するようになる。（`rails c --sandbox false`だとsandboxモードは無効にする。）

```bash
# config.sandbox_by_default = true の設定を書いている時

$ rails c
#=> sandboxモードで起動

$ rails c --sandbox false
#=> sandboxモードは無効
```

ちなみに、この設定は本番環境で間違ってDB更新をすることを避けるために作られているため、`development`と`test`環境では無効となっている。
この制御をするために使われている`Rails.env.local?`もRails7.1から入ったメソッド。

https://techracho.bpsinc.jp/hachi8833/2023_07_26/132429
