hashでkeyが存在する場合はその値を返し、そうでない場合は第二引数やブロックを評価した値を返す

```ruby
hash = { a: 'foo' }

hash.fetch(:a) #引数のkeyがあればその値を返す
#=> "foo"
hash
#=> {:a=>"foo"}

hash.fetch(:a, 'baz') # 引数のkey(:a)があるのでfooを返す。
#=> "foo"
hash
#=> {:a=>"foo"}

hash.fetch(:b) # 第二引数を渡さない場合に、引数のkeyがない場合はエラー
#=> key not found: :b (KeyError)
hash
#=> {:a=>"foo"}

hash.fetch(:b, 'bar') # 値がない場合は第2引数を返す
#=> "bar"
hash
#=> {:a=>"foo"}

hash.fetch(:b) { |key| "#{key}!" } # ブロックを渡すとブロックを評価した値を返す
#=> "b!"
hash
#=> {:a=>"foo"}
```

これを活かして、値のキャッシュができる

```ruby
hash = { a: 'foo' }

hash.fetch(:b) { hash[:b] = true } # bのkeyにtrueが入る
#=> true
hash
#=> {:a=>"foo", :b=>true}
```

```ruby
hash = { a: 'foo', b: false }

hash.fetch(:b) { hash[:b] = true } # すでにbのkeyにはfalseが入っているのでブロックは評価されず、falseが返る
#=> false
```
