## method_missingを使うときは、respond_to_missing?もオーバーライドする

```ruby
class MyClassA
  def hello
    'hello'
  end
end

class MyClassB
  def initialize
    @myclass_a = MyClassA.new
  end

  def method_missing(name)
    @myclass_a.send(name)
  end
end

myclass_b = MyClassB.new
p myclass_b.hello
# => 'hello'
```

これだと、respond_to?でfalseになる問題がある。

```ruby
p myclass_b.respond_to?(:hello)
# => false
```

なので、respond_to_missing?もオーバーライドしてあげる

class MyClassA
  def hello
    'hello'
  end
end

class MyClassB
  def initialize
    @myclass_a = MyClassA.new
  end
  def method_missing(name)
    @myclass_a.send(name)
  end

  def respond_to_missing?(method, include_private = false)
    @myclass_a.respond_to?(method) || super
  end
end

myclass_b = MyClassB.new
p myclass_b.hello
# => 'hello'
p myclass_b.respond_to?(:hello)
# => true
```

## method_missingを使う際に気をつけること

- 受け付ける種類が決まっているなら限定すること
- 扱えない呼び出しを受け取った時にはBasicObject#method_missingを呼び出すこと

## ブランクスレート

実はどこかにメソッドがある場合、method_missingにたどり着かない問題がある
=> BasicObjectを継承するなどして、不要なメソッドを含まないようにする方法がある

## 可能であれば動的メソッドを使い、仕方がなければゴーストメソッドを使う
