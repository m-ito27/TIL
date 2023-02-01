## 配列から重複しているものをカウントする

例）['a', 'a', 'c'] => [['a', 2], ['b', 1]]

```ruby
ary = ['a', 'a', 'c']
ary.group_by(&:itself).map { |key, value| [key, value.count] }
```

group_byがやっていること

```ruby
ary.group_by(&:itself)
=> {"a"=>["a", "a"], "c"=>["c"]}
```

