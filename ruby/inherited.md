## inheritedメソッドはClassのインスタンスメソッド

クラス継承されたときに呼び出される

```ruby
class String
  def self.inherited(subclass)
    puts "#{self} は #{subclass} に継承された"
  end
end

class MyString < String; end

# => String は MyString に継承された
```
