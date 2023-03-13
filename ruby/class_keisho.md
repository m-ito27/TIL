## クラスの継承をしているかどうかを判定する方法

- if A < B みたいな形が使える

```ruby
class A; end

class B < A;end

puts 'B < A' if B < A
puts 'A < B' if A < B

# => B < A
```

けど、`ancestors.include?`の方がわかりやすいかも

```ruby
B.ancestors.include?(A) #=> true
```
