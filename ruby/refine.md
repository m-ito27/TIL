## refineを使うと、オープンクラスをした時の影響をコントロールしやすい

Refinementsが有効なコードは、リファインされた側のクラスのコードよりも優先される。
当然インクルードやプリペンドよりも優先。

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
