## methodオブジェクトを作成するメソッド: method

Object#methodで、メソッドオブジェクトを作成できる。
methodオブジェクトは、callで使える。

```ruby
class MyClass
  def my_method
    'Hello'
  end
end

p m = MyClass.new.method(:my_method)
# => #<Method: MyClass#my_method() Object_method.rb:2>
p m.call
# => "Hello"
```
