## instance_methods(false)で継承を除いたメソッド一覧がとれる

```ruby
class Greet
  def initialize(text)
    @text = text
  end

  def welcome
    @text
  end
end

p Greet.new('hello').class.instance_methods(false)
=> [:welcome]
```
