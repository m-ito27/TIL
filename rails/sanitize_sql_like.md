## sanitize_sql_like で%や_のワイルドカードを検索対象に含められる

```ruby
Book.all

[#<Book:0x00000001087ac188 id: 1, title: "book01", content: "updated!", user_id: 1, created_at: Mon, 10 Apr 2023 13:52:15.546272000 UTC +00:00, updated_at: Sat, 10 Jun 2023 11:08:04.754182000 UTC +00:00>,
 #<Book:0x00000001087ac0c0 id: 2, title: "book01", content: "content", user_id: 1, created_at: Mon, 10 Apr 2023 13:52:18.842499000 UTC +00:00, updated_at: Mon, 10 Apr 2023 13:52:18.842499000 UTC +00:00>,
 #<Book:0x00000001087a4078 id: 3, title: "book01", content: "content", user_id: 1, created_at: Mon, 10 Apr 2023 13:52:25.375490000 UTC +00:00, updated_at: Mon, 10 Apr 2023 13:52:25.375490000 UTC +00:00>,
 #<Book:0x00000001087a4370 id: 4, title: "title%desu_ne", content: nil, user_id: 1, created_at: Sun, 09 Jul 2023 06:55:57.829531000 UTC +00:00, updated_at: Sun, 09 Jul 2023 06:55:57.829531000 UTC +00:00>,
 #<Book:0x00000001087a7f70 id: 5, title: "titledesune", content: nil, user_id: 1, created_at: Sun, 09 Jul 2023 07:01:20.072695000 UTC +00:00, updated_at: Sun, 09 Jul 2023 07:01:20.072695000 UTC +00:00>]

Book.where("title LIKE ? ESCAPE '\\'", "%title%%")
  # Book Load (0.6ms)  SELECT "books".* FROM "books" WHERE (title LIKE '%title%%' ESCAPE '\')

[#<Book:0x00000001082c5778 id: 4, title: "title%desu_ne", content: nil, user_id: 1, created_at: Sun, 09 Jul 2023 06:55:57.829531000 UTC +00:00, updated_at: Sun, 09 Jul 2023 06:55:57.829531000 UTC +00:00>,
 #<Book:0x00000001082c56b0 id: 5, title: "titledesune", content: nil, user_id: 1, created_at: Sun, 09 Jul 2023 07:01:20.072695000 UTC +00:00, updated_at: Sun, 09 Jul 2023 07:01:20.072695000 UTC +00:00>]

# %がワイルドカードと扱われ、titledesuneのbookも検索結果に含まれてしまう

safe_input = ActiveRecord::Base.sanitize_sql_like('title%')
 #=> "title\\%"

Book.where("title LIKE ? ESCAPE '\\'", "%#{safe_input}%")
  # Book Load (0.5ms)  SELECT "books".* FROM "books" WHERE (title LIKE '%title\%%' ESCAPE '\')


=> [#<Book:0x0000000108626fc0 id: 4, title: "title%desu_ne", content: nil, user_id: 1, created_at: Sun, 09 Jul 2023 06:55:57.829531000 UTC +00:00, updated_at: Sun, 09 Jul 2023 06:55:57.829531000 UTC +00:00>]
```

参考: https://techracho.bpsinc.jp/hachi8833/2021_12_06/114096#2-1
参考: https://qiita.com/QWYNG/items/3ea4a55fd1867ff20041
