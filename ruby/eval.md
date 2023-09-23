## 文字列 expr を Ruby プログラムとして評価してその結果を返します。第2引数に Binding オブジェクトを与えた場合、そのオブジェクトを生成したコンテキストで文字列を評価します。

```ruby
def create_binding(x)
  a = x
  binding
end

x = 10
bind = create_binding(20)
eval('puts a', bind) # puts aでaにアクセスできている。なぜなら、bindを生成したコンテキスト（create_bindingメソッド）で文字列を評価するから。
# => 20
```
