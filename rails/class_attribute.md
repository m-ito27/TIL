## class_attributeで親クラスに影響を与えないかたちで変数の定義ができる

https://techracho.bpsinc.jp/hachi8833/2017_10_19/46488

```ruby
class Parent
  class_attribute :foo
end
class Child < Parent
end
class Grandchild < Child
end
Parent.foo = 100
Child.foo #=> 100      // 値は継承される
Child.foo = 200
Child.foo #=> 200
Parent.foo #=> 100     // 値を再定義しても親クラスには影響しない
Grandchild.foo #=> 200 // 再定義した値はその子クラスに継承される
```
