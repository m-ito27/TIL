https://tech.crassone.jp/posts/use-merge-with-activerecord-scope-or-condition

## orを使う際の注意

```ruby
class class User < ApplicationRecord
  scope :test, lambda {
    left_joins(:books)
      .where(id: ..5)
      .or(Book.where(id: ..5))
  }
end
```

例えば、上記のように、Userのうちidが5以下 or Bookのうちidが5以下のレコードを取得するスコープがあったとする。

このとき、以下のように書いたときの挙動はどうなるか。

```ruby
User.where(email: 'abc@example.com').test
```

1. 「emailが`abc...`」かつ、「Userのうちidが5以下もしくはBookのうちidが5以下」のレコード

2. 「emailが`abc...`かつUserのうちidが5以下」、「もしくはBookのうちidが5以下」のレコード

答えは、2。
```ruby
User.where(email: 'abc@example.com').test
# =>
# SELECT "users".* FROM "users"
# LEFT OUTER JOIN "books" ON "books"."user_id" = "users"."id"
# WHERE (
#  "users"."email" = "abc@example.com"
#   AND "users"."id" <= 5
#   OR "books"."id" <= 5
#)
```
これは直感に反する。

以下にunscopedとmergeを使うと、1の動きにできる。

```ruby
class class User < ApplicationRecord
  scope :test, lambda {
    merge(
      unscoped
        .left_joins(:books)
        .where(id: ..5)
        .or(Book.where(id: ..5))
    )
  }
end
```

```ruby
User.where(email: 'abc@example.com').test
# =>
# SELECT "users".* FROM "users"
# LEFT OUTER JOIN "books" ON "books"."user_id" = "users"."id"
# WHERE "users"."email" = "abc@example.com"
# AND ("users"."id" <= 5 OR "books"."id" <= 5)
```
