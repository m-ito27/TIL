> rubyにおいて、phpでいうuse_only_cookieにあたるメソッドはなんですか？

PHPのsession.use_only_cookiesの設定は、PHPのセッション管理がクッキーのみに依存することを強制します。これは、セッションIDがURLパラメーターを通じて漏れることを防ぎ、セッションハイジャック攻撃を防ぐための重要なセキュリティ対策となります。

Ruby on Railsでは、デフォルトでクッキーベースのセッションストアが使用されます。これは、config/initializers/session_store.rbに設定されています。RailsではセッションIDはクッキーに保存され、URLパラメーターでのセッションIDの利用は許可されていません。そのため、PHPのsession.use_only_cookiesに相当する設定は必要ありません。

ただし、セッションのセキュリティを高めるためには以下のような設定を行うことが推奨されています：

config/initializers/session_store.rbで、:secureオプションをtrueに設定し、HTTPS経由でのみクッキーが送信されるようにします。
```ruby
Rails.application.config.session_store :cookie_store, key: '_application_session', secure: Rails.env.production?
```

config/initializers/session_store.rbで、:httponlyオプションをtrueに設定し、JavaScriptからクッキーにアクセスできないようにします。これにより、クロスサイトスクリプティング（XSS）攻撃からセッションクッキーを保護します。
```ruby
Rails.application.config.session_store :cookie_store, key: '_application_session', httponly: true
```

これらの設定により、Railsのセッション管理はセキュアに行われます。
