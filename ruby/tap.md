## tapはselfを引数としてブロックを評価する

```ruby
array = [1, 2, 3]
array.tap { |a| p a } # => [1, 2, 3]
array.map { |a| a * a }.tap { |b| p b } # => [1, 4, 9]
```
