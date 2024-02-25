ローカルで`mailcatcher`gemを起動して、dockerで起動しているrailsアプリの検証をしたい時、addressが`localhost`では以下のエラーが起きた。

```
/usr/local/bundle/ruby/3.2.0/gems/net-smtp-0.4.0/lib/net/smtp.rb:631:in `initialize': Cannot assign requested address - connect(2) for "localhost" port 1025 (Errno::EADDRNOTAVAIL)
```

そこで、以下のようにaddressを修正して解決。

```ruby
# development.rb

  config.action_mailer.smtp_settings = { address: 'host.docker.internal', port: 1025 }
```

Dockerで動いているRailsアプリではlocalhostはRailsが起動しているコンテナ自身ことを指すため、ローカルマシン上で動いている`mailcatcher`には`localhost`では繋げないのが原因。
`host.docker.internal`でローカルマシンで動いているmailcatcherに接続できるようになる。
