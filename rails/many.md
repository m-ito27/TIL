## many?で配列やハッシュの要素が複数あるかどうかを判定できる

```ruby
[1, 2].many?
# => true

[1].many?
#=> false

{ a: 1, b: 2 }.many?
#=> true

{ a: 1 }.many?
#=> false
```
