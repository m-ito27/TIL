`pmset`を使うことで、PCの定期起動などを制御できる。

たとえば以下は、PCを毎日15:59:50秒にスリープ状態だったら解除するもの.

```bash
$ sudo pmset repeat wake MTWRFSU 15:59:50
```

以下のコマンドで登録状況の確認ができる。

```bash
$ pmset -g sched
Repeating power events:
  wake at 3:59PM every day
Scheduled power events:
  ...
```

repeatを全部リセットするコマンド

```bash
$ sudo pmset repeat cancel
```
