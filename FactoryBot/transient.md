## カラム等とは関係ない属性を設定できる。

https://github.com/thoughtbot/factory_bot/blob/main/GETTING_STARTED.md

```ruby
transient do
  default_xxx { false }
end

trait 'sample' do
  default_xxx: { true }
end

after(:build) do |e|
  if e.default_xxx
    ...
  end
end
```
