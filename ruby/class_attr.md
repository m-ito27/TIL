## クラスのアトリビュートを追加したいときは、得意クラスにアトリビュートを定義すれば良い

```ruby
class MyClass
  class << self
    attr_accessor :c
  end
end

MyClass.c = 'ruby'
p MyClass.c
# => 'ruby'
```
