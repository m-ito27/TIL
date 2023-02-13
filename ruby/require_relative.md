## require_relativeはファイルからの相対位置

myclass_a.rbとmyclass_bが同じ階層の別ファイルにあるとき、
require_relativeとrequireの違いは以下の感じになる。

```ruby
require_relative 'myclass_b' # require_relativeならこっち。相対位置
require './myclass_b' # require ならこっち。

class MyClassA
  def initialize
  end
end
```

```ruby
class MyClassB
end
```
