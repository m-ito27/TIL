## 処理にかかった時間を計測する

```ruby
require 'benchmark'

rows = []
result = Benchmark.realtime do
  # 処理を書く
end
puts "#{result}s"　#処理にかかった内容
```
