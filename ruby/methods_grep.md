## methodsメソッドの中身をgrepで絞れる

実際にはArray#grepを使っているということ。

```ruby
array = Array.new
array.methods.grep(/^ea/)
=> [:each_index, :each, :each_with_index, :each_entry, :each_slice, :each_cons, :each_with_object]
```
