## psych

rubyの標準ライブラリ。
YAMLのテキストをrubyオブジェクトにしたり（もしくはその逆）できる

```irb
irb(main):001:0> require 'psych'
=> true

irb(main):002:0" yaml_data = <<~YAML
irb(main):003:0"   name: John
irb(main):004:0"   age: 30
irb(main):005:0"   email: john@example.com
irb(main):006:0> YAML
=> "name: John\nage: 30\nemail: john@example.com\n"

irb(main):007:0>
=> "name: John\nage: 30\nemail: john@example.com\n"

irb(main):008:0> Psych.load(yaml_data)
=> {"name"=>"John", "age"=>30, "email"=>"john@example.com"}

irb(main):009:0> ruby_hash = Psych.load(yaml_data)
=> {"name"=>"John", "age"=>30, "email"=>"john@example.com"}

irb(main):010:0> yaml_data = Psych.dump(ruby_hash)
=> "---\nname: John\nage: 30\nemail: john@example.com\n"

irb(main):011:0> ruby_hash = Psych.load(yaml_data)
=> {"name"=>"John", "age"=>30, "email"=>"john@example.com"}
```
