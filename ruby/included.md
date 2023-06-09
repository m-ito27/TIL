

```ruby
module ModuleA
  def self.included(mod)
    p self
    p mod
  end
end

class MyClass
  include ModuleA
end
```

```shell
$ ruby sample.rb
ModuleA
MyClass
```
