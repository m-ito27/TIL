## string#linesで、改行で分割できる

引数に`chomp: true`を指定することで、改行文字を除くこともできる。

```ruby
"abc\ndef".lines
#=> ["abc\n", "def"]

"abc\ndef".lines(chomp: true)
#=> ["abc", "def"]
```
