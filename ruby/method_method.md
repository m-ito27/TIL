## methodメソッド

シンボルで渡した引数のmethodオブジェクトを作成する

以下は、&でメソッドオブジェクトをブロックに変換し、
mapのなかで、aryの配列の要素を1つずつ引数として受け取り実行されている

```ruby
def double(n)
  n * 2
end

p method(:double)
# => #<Method: Object#double(n) sample.rb:1>

p method(:double).call(4)
# => 8

ary = [1, 2, 3]
result = ary.map(&method(:double))

p result
# => [2, 4, 6]
```
