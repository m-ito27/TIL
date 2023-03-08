## 前に新しいメソッドの名前、後ろに元の名前

```ruby
class MyClass
  def my_method; 'my_method'; end
  alias_method :m, :my_method
  alias_method :m2, :m
end


obj = MyClass.new
p obj.my_method
# => 'my_method'
p obj.m
# => 'my_method'
p obj.m2
# => 'my_method'
```

```ruby
class MyClass2
  def my_method; 'my_method'; end

  def m; 'bye'; end
  alias_method :m2, :m
  alias_method :m, :my_method
end

obj = MyClass2.new
p obj.my_method
# => 'my_method'
p obj.m
# => 'my_method'
p obj.m2
# => 'bye'
```

