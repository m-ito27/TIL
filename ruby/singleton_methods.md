## 特異メソッド：単一のオブジェクトに特化したメソッドのこと

```ruby
str = 'just a regular string'

def str.title?
  self.upcase == self
end

p str.title?
# => false
p str.methods.grep(/title?/)
# => [:title?]
p str.singleton_methods
# => [:title?]
```
