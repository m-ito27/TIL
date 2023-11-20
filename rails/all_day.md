## 「その日一日」の範囲を取得できる

timeでもdateでも使える

```ruby
now = Time.current
#=> Mon, 20 Nov 2023 09:53:51.889665000 UTC +00:00
now.all_day
#=> Mon, 20 Nov 2023 00:00:00.000000000 UTC +00:00..Mon, 20 Nov 2023 23:59:59.999999999 UTC +00:00
```

```ruby
today = Date.today
#=> Mon, 20 Nov 2023
today.all_day
#=> Mon, 20 Nov 2023 00:00:00.000000000 UTC +00:00..Mon, 20 Nov 2023 23:59:59.999999999 UTC +00:00
```
