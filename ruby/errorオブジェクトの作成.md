## エラーオブジェクトを自分で作る

`set_backtrace`でbacktraceを登録できる。

```ruby
error = StandardError.new
error.set_backtrace(['エラー1行目', 'エラー2行目'])
#=> ["エラー1行目", "エラー2行目"]
```
