## Moduleをincludeしたとき、append_featuresメソッドが実際にincludeを行う

append_featuresがincludeをおこなっているので、
例えばオーバーライドすると、includeされなくなる。

```ruby
module M
  def self.append_features(base)
  end
end

class C
  include M
end

p C.ancestors
# => [C, Object, Kernel, BasicObject] ⇦ Mがない
```

superを書くとincludeされることからも理解できる

```ruby
module M
  def self.append_features(base)
    super
  end
end

class C
  include M
end

p C.ancestors
# => [C, M, Object, Kernel, BasicObject]
```
