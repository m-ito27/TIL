## rubyのブロック

ブロックが定義されると、ローカル束縛を包み込む。

```ruby
def my_method
  x = "Good Bye"
  yield('Mike')
end

x = "Hello"
p my_method { |y| "#{x}, #{y}"} # ブロックが作られたときのxを見ている
# => 'Hello, Mike'
```
