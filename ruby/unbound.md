## UnboundMethodはレシーバを持たないメソッドを表すクラス

```ruby
module MyModule
  def my_method
    66
  end
end

unbound = MyModule.instance_method(:my_method)
p unbound.class
# => UnboundMethod

# define_methodの第2引数はUnboundMethodのインスタンスが指定できる。
String.send :define_method, :another_method, unbound

p 'abc'.another_method
# => 66
```
