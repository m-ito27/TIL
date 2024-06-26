## ActiveSupport



### truncate

#### 実装してみた

```ruby
class String
  def truncate(num, omission: '...')
    omission_count = omission.size

    if size <= num # そのまま表示できる場合
      self
    else # 「...」など表示する場合
      display_str_count = num - omission_count # 表示する文字数
      display_str_count = 0 if display_str_count <= 0 # 表示する文字数がないときは0で固定
      self[...display_str_count] + omission
    end
  end
end
```

- omissionオプションだけ考慮
- `...`など、省略記号の文字数を考慮しながら、省略が不要な場合、省略が必要な場合で分岐
- 省略が必要な場合、何文字目まで表示するかは範囲演算子を使ってみた
  - ただし、truncateの第一引数の数字が省略記号の数を下回る場合の考慮が冗長になってしまった

#### 実際の実装

```ruby
def truncate(truncate_to, options = {})
  return dup unless length > truncate_to

  omission = options[:omission] || "..."
  length_with_room_for_omission = truncate_to - omission.length
  stop = \
    if options[:separator]
      rindex(options[:separator], length_with_room_for_omission) || length_with_room_for_omission
    else
      length_with_room_for_omission
    end

  +"#{self[0, stop]}#{omission}"
end
```

- そのままの文字列を返す場合に`dup`を使っている
- 省略する際に、文字を表示する部分は範囲演算子ではなく`string[a, b]`を使っている
  - こうすることで、自分の実装で冗長になった箇所が解決されている

```ruby
'abc'[0,-1]
#=> nil
'abc'[0..-1]
#=> "abc"
```


