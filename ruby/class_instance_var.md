## クラスインスタンス変数

そのクラスをselfとする場所に配置されたインスタンス変数

```ruby
class MyClass
  @my_var = 2 # クラスインスタンス変数

  def self.read
    @my_var　# クラスインスタンス変数
  end

  def self.write
    @my_var = 4　# クラスインスタンス変数
  end

  def write
    @my_var = 10
  end

  def read
    @my_var
  end
end

p MyClass.read
# => 2
MyClass.write
p MyClass.read
# => 4

p MyClass.new.read
# => nil

obj = MyClass.new
obj.write
p obj.read
# => 10
```
