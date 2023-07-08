## rubyでescapeするのはhtml_escapeメソッド

```ruby
require 'erb'

p ERB::Util.html_escape('<h1>Hello, World</h1>')
# => "&lt;h1&gt;Hello, World&lt;/h1&gt;"

p '<h1>Hello, World</h1>'
# => "<h1>Hello, World</h1>"
```
