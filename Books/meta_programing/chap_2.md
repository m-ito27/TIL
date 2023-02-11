## レシーバを明示的に指定せずに呼び出すと、selfのメソッドとみなされる

```ruby
module Printable
  def print
    'abc'
  end
end

module Document
  def print_to_screen
    print
  end

  def print
    'def'
  end
end

class Book
  include Document
  include Printable
end

b = Book.new
p b.print_to_screen
# => 'abc'
```

Documentモジュールのprint_to_screenが呼ばれた時点で、selfはbである。
bのクラス探索順は、includeの順番からPrintableの方が先なので、'abc'が表示される
