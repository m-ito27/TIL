## 外部サイトからzipファイルのダウンロードをする方法

open-apiを使うことで可能になる。
ググると、URI.openのところが単にopenになっている記事が多いが、それだと
`No such file or directory @ rb_sysopen - http://www.post.japanpost.jp/zipcode/dl/kogaki/zip/ken_all.zip (Errno::ENOENT)`
が発生してうまくいかなかった。

```ruby
require 'open-uri'

url = 'http://www.post.japanpost.jp/zipcode/dl/kogaki/zip/ken_all.zip'
filename = 'ken_all.zip'

File.open(filename, "wb") do |file|
  file.write URI.open(url).read
end
```
