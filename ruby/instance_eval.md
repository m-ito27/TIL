## instance_eval

- オブジェクトのコンテキストでブロックを評価
- レシーバをselfにしてから評価

```ruby
class MyClass
  def initialize
    @v = 1
  end

  def hello
    'hello'
  end

  private

  def bye
    'bye'
  end
end

obj = MyClass.new

obj.instance_eval do
  p self
  p hello
  p bye
  p @v
end
```

```shell
$ ruby instance_eval.rb
#<MyClass:0x0000000102bb24e0 @v=1>
"hello"
"bye"
1
```

## instance_evalとinstance_exec

- instance_execは、ブロックに引数を渡せる。
- instance_evalで以下はうまく機能しない

```ruby
class C
  def initialize
    @x = 1
  end
end

class D
  def twisted_method
    @y = 2
    C.new.instance_eval { "@x: #{@x}, @y: #{@y}"} # @yはスコープから抜け落ちる
  end
end

p D.new.twisted_method
# => "@x: 1, @y: "
```

これがinstance_execを使えば、、、

```ruby
class C
  def initialize
    @x = 1
  end
end

class D
  def twisted_method
    @y = 2
    C.new.instance_exec(@y) {|y| "@x: #{@x}, @y: #{y}"}
  end
end

p D.new.twisted_method
# => "@x: 1, @y: 2"
```

ちなみに、上のコードでinstance_execをinstance_evalに帰ると、ArgumentErrorを起こす（引数は取れない）