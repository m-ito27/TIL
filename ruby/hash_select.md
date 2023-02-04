## hashでselectを使って条件に一致するhashだけ取り出す時

```ruby
hash = {1=> ['a', 'b'], 2=> ['c', 'd'], 3=> ['a', 'c']}

hash.select{ |key, value| value.include?('a') }
=> {1=>["a", "b"], 3=>["a", "c"]}
```
