## Module#class_evalは、そこにあるクラスのコンテキストでブロックを評価する

selfとカレントクラスを変更する

```ruby
def add_method_to(a_class)
  a_class.class_eval do
    p self
    def m; 'Hello'; end
  end
end

add_method_to(String)
p 'abc'.m
```

```shell
String
"Hello"
```

class_evalはフラットスコープを持っているので、スコープの外側にある変数も参照できる

```ruby
var = 'aaa'

String.class_eval do
  p var
end

# => 'aaa'
```

