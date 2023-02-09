## null制約を外す

`change_column_null`を使えばよい

```ruby
# NULL制約をOFFにする（NULLを許容する）
class ChangeColumnNullFromTasks < ActiveRecord::Migration[6.0]
  def change
    change_column_null :tasks, :user_id, true
  end
end
```
