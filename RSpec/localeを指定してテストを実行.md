## ロケールを指定してテストを実行する方法

```ruby
around { |e| I18n.with_locale(:en) { e.run } }
```
