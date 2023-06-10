rails の find メソッドをブロックで使うと引数が無効化？されるので注意
関連記事： https://techracho.bpsinc.jp/hachi8833/2023_06_09/131068

```ruby
irb(main):002:0> Book.all
  Book Load (0.3ms)  SELECT "books".* FROM "books"
=>
[#<Book:0x000000010899d7a8 id: 1, title: "book01", content: "content", user_id: 1, created_at: Mon, 10 Apr 2023 13:52:15.546272000 UTC +00:00, updated_at: Mon, 10 Apr 2023 13:52:15.546272000 UTC +00:00>,
 #<Book:0x0000000108a05c40 id: 2, title: "book01", content: "content", user_id: 1, created_at: Mon, 10 Apr 2023 13:52:18.842499000 UTC +00:00, updated_at: Mon, 10 Apr 2023 13:52:18.842499000 UTC +00:00>,
 #<Book:0x0000000108a05b78 id: 3, title: "book01", content: "content", user_id: 1, created_at: Mon, 10 Apr 2023 13:52:25.375490000 UTC +00:00, updated_at: Mon, 10 Apr 2023 13:52:25.375490000 UTC +00:00>]

irb(main):003:0> Book.find(2)
  Book Load (0.2ms)  SELECT "books".* FROM "books" WHERE "books"."id" = ? LIMIT ?  [["id", 2], ["LIMIT", 1]]
=> #<Book:0x0000000108bfc4b8 id: 2, title: "book01", content: "content", user_id: 1, created_at: Mon, 10 Apr 2023 13:52:18.842499000 UTC +00:00, updated_at: Mon, 10 Apr 2023 13:52:18.842499000 UTC +00:00>

irb(main):004:1* Book.find(2) do |book|
irb(main):005:1*   book.update!(content: 'updated!')
irb(main):006:0> end
  Book Load (0.2ms)  SELECT "books".* FROM "books"
  TRANSACTION (0.1ms)  begin transaction
  User Load (0.4ms)  SELECT "users".* FROM "users" WHERE "users"."id" = ? LIMIT ?  [["id", 1], ["LIMIT", 1]]
  Book Update (1.4ms)  UPDATE "books" SET "content" = ?, "updated_at" = ? WHERE "books"."id" = ?  [["content", "updated!"], ["updated_at", "2023-06-10 11:08:04.754182"], ["id", 1]]
  TRANSACTION (0.6ms)  commit transaction
=> #<Book:0x00000001090a5e88 id: 1, title: "book01", content: "updated!", user_id: 1, created_at: Mon, 10 Apr 2023 13:52:15.546272000 UTC +00:00, updated_at: Sat, 10 Jun 2023 11:08:04.754182000 UTC +00:00>

irb(main):007:0> Book.all
  Book Load (0.2ms)  SELECT "books".* FROM "books"
=>
[#<Book:0x0000000108fec230 id: 1, title: "book01", content: "updated!", user_id: 1, created_at: Mon, 10 Apr 2023 13:52:15.546272000 UTC +00:00, updated_at: Sat, 10 Jun 2023 11:08:04.754182000 UTC +00:00>,
 #<Book:0x0000000108fec168 id: 2, title: "book01", content: "content", user_id: 1, created_at: Mon, 10 Apr 2023 13:52:18.842499000 UTC +00:00, updated_at: Mon, 10 Apr 2023 13:52:18.842499000 UTC +00:00>,
 #<Book:0x0000000108fec0a0 id: 3, title: "book01", content: "content", user_id: 1, created_at: Mon, 10 Apr 2023 13:52:25.375490000 UTC +00:00, updated_at: Mon, 10 Apr 2023 13:52:25.375490000 UTC +00:00>]
```

id:2のレコードではなく、最初のレコードが更新される
