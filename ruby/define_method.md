## define_methodの使い方

動的メソッド。
ブロックがメソッドの本体

```ruby
class MyClass
  define_method :my_method do |my_arg|
    my_arg * 3
  end
end

obj = MyClass.new
p obj.my_method(2)
# => 6
```
