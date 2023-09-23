## 二分探索できる

bsearch_indexもある

```ruby
ary = (1..100).to_a
ary.bsearch { |num| num > 50 }
# => 51
ary.bsearch_index { |num| num > 50 }
# => 50
```

bsearchは範囲にも使える

```ruby
(1..100).bsearch { |num| num > 50 }
# => 51
```
