### TracePointでrubyの処理をトレースできる。

使い方の一例

```ruby
TracePoint.new(:call, :return) { |tp|
  puts "#{tp.event} #{tp.method_id} on #{tp.defined_class}"
}.enable do
  def foo
    bar
  end

  def bar
    100
  end

  foo
end
```

実行すると、以下のように表示される。
```
call foo on Object
call bar on Object
return bar on Object
return foo on Object
```
