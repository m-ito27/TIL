crondでローカルマシンの定期実行を設定できる。

```shell
$ crontab -e
```

たとえば以下のようにすると、毎日16:00にxxx.shを実行する。

```shell
00 16 * * * /Users/UseName/develop/xxx.sh >> /Users/UseName/develop/xxx.log 2>&1
```

たとえば以下のようにすると、crondでrubyプログラムを実行できる

```bash
#!/bin/bash
export PATH="$HOME/.rbenv/bin:$PATH"
export PATH="$HOME/.rbenv/shims:$PATH"
eval "$(rbenv init - zsh)"

cd /Users/UserName/xxx

rbenv local 3.1.2

bundle install

ruby app.rb
```
