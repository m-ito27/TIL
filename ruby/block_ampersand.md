## &でブロックを受け取る

毎回わからなくなるので、、、。
他のメソッドにブロックに渡したいときなどに使える

```ruby
def math(a, b)
  yield(a, b)
end

def do_math(a, b, &operation)
  math(a, b, &operation)
end

p do_math(2, 3) { |x, y| x * y }
# => 6
```

```ruby
def my_method(&the_proc)
  the_proc
end

p = my_method { |name| "Hello, #{name} !" }
p p.class
# => Proc
p p.call('Bill')
# => Hello, Bill
```

```ruby
def my_method_b(greeting)
  "#{greeting}, #{yield}!"
end

my_proc = proc { 'Jim' }
p my_method_b('Hello', &my_proc)
# => Hello, Jim
```
