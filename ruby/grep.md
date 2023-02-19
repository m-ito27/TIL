## grepで()内にマッチした要素全てに対してブロックが評価される

マッチした文字列は$1に格納されるのを利用して以下のような処理ができる

grepの後eachなどが要らないことに驚き。

```ruby
p ['abc', 'acb', 'ccc'].grep(/(a.*)/) { "Match: #{$1}" }
# => ["Match: abc", "Match: acb"]
```