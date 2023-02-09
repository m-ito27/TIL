## 削除時の外部キーの取り扱い

Userが複数のTaskを持っている１対多。

普通にやると、userを削除できない。（Taskが外部キーでuser_idを持ってるから。）
dependent: :destoryにすると、一緒に消えてしまうが、userが消されてもtaskは消したくないとき、
Userモデルでdependent: :nullifyをつけてあげると、taskのuser_idにnilが入るので、userだけを削除できる。

```ruby
class User < ApplicationRecord
  has_many :tasks, dependent: :nullify
end
```
