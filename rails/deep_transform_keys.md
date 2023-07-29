## ハッシュのキーを再帰的に変換するためのメソッド

このメソッドを使うと、ハッシュのキーを変換するブロックを指定することができます。そして、このメソッドはハッシュのすべてのキー（ネストしたキーも含む）に対してそのブロックを適用します。これにより、すべてのキーを一度に変換することが可能です。

```ruby
hash = { person: { name: 'Bob', age: 20 }, favorites: { color: 'blue', food: 'pizza' } }
new_hash = hash.deep_transform_keys { |key| key.to_s.upcase }
# { 'PERSON' => { 'NAME' => 'Bob', 'AGE' => 20 }, 'FAVORITES' => { 'COLOR' => 'blue', 'FOOD' => 'pizza' } }
```

他にも色々
https://railsdoc.com/page/hash
