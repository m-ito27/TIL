## execやsystemでシェルを呼び出すことができる

execとsystemが一番異なる点は、
execメソッドが呼び出されると、現在のRubyプロセスはそこで終了し、指定したコマンドが新たに実行される。

```ruby
puts 'before'
system('ls')
puts 'after'
```

これを記載したファイルを実行すると、
'before'と表示され、
lsコマンドが実行され、今のディレクトリのファイル名が一覧表示される
その後、'after'まで表示される

```ruby
puts 'before'
exec('ls')
puts 'after'
```

一方、これだと'after'が実行されない。
