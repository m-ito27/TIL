## selfに含まれる要素を数え上げた結果をHashで返す

```ruby
['a', 'b', 'a', 'c'].tally
=> {"a"=>2, "b"=>1, "c"=>1}
```

```ruby
count_hash = ['a', 'b', 'a', 'c'].tally
count_hash.each { |key, value| puts "#{key}: #{value}" }
=>
a: 2
b: 1
c: 1
```
