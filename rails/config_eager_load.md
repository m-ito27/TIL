## Railsで`config.eager_load = false`と設定していると、クラスを先読みしないようになる（実際に使われるタイミングまで読み込まない）。

```ruby
class Sample < User; end
```

この設定で、`subclasses`がうまく効かないことがある。
```ruby
User.subclasses
# => []
```

そこで、

```ruby
config.eager_load = true
```

このようにすると、先読みが有効になる。

```ruby
User.subclasses
# => [Sample]
```
