rubyで集合を扱うクラス

例えば`^`を使うと、集合の対象差を取得できる。

```ruby
Set[1,2]
#=> #<Set: {1, 2}>
set1 = Set[1,2]
set2 = Set[2,3]

set1 ^ set2
#=> #<Set: {3, 1}>
```