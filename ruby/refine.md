## refineを使うと、オープンクラスをした時の影響をコントロールしやすい

```ruby
module StringExtensions
  refine String do
    def reverse
      'esrever'
    end
  end
end

module StringStuff
  using StringExtensions
  p 'my_string'.reverse
  # => "esrever"
end

p 'my_string'.reverse
# => "gnirts_ym"
```
