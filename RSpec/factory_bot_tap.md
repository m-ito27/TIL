## FactoryBotで孫にあたるレコードの条件を指定する場合

tapを使うことで定義できる。

```ruby
let(:parent) do
  create(:parent).tap do |parent|
    parent.child.grandchild.name = 'sample'
  end
end
```
