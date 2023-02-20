## Class.newの引数に指定したクラスはnewしたクラスのスーパークラスになる

```ruby
c = Class.new(String)

p c.superclass
# => String
```
