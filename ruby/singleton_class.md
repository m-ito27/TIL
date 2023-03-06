## 特異クラスは、特異メソッドが住む場所

```ruby
class C; end

class D < C; end

obj = D.new
p obj.singleton_class # objの特異クラス #<Class:#<D:0x000000010233a178>>
# => #<Class:#<D:0x000000010233a178>>
p obj.singleton_class.superclass # オブジェクトの特異クラスのスーパークラスは、オブジェクトのクラス。（obj.class）
# => D
p obj.class
# => D

p D.singleton_class # クラスの特異クラス #<Class:D>
# => #<Class:D>
p D.singleton_class.superclass # クラスの特異クラスのスーパークラスは、クラスのスーパークラス（C）の特異クラス
# => #<Class:C>
```

クラスメソッドは、クラスの特異クラスにある特異メソッド

```ruby
class C
  class << self
    def a_class_method
      'C.a_class_method'
    end
  end

  def self.b_class_method
    'C.b_class_method'
  end
end

class D < C; end

p C.singleton_methods.grep(/a_/)
# => [:a_class_method]
p C.singleton_methods.grep(/b_/)
# => [:b_class_method]
p D.a_class_method
# => "C.a_class_method"
p D.b_class_method
# => "C.b_class_method"
```
