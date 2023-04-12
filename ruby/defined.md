## defined?で定数や変数が定義されているかわかる

```ruby
ruby = 'Ruby'

p defined?(ruby)  # => "local-variable"
p defined?(rails) # => nil
```
