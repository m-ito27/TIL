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
