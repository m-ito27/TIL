# https://zenn.dev/igaiga/books/rails-practice-note/viewer/ruby_rails_vscode

ローカル環境でRailsを動かしている場合

1. VSCodeへVSCode rdbg Ruby Debugger拡張をインストール

2. `.vscode/launch_json`を作成

```bash
$ code .vscode/launch.json
```

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Debug Rails",
      "type": "rdbg",
      "request": "launch",
      "cwd": "${workspaceRoot}",
      "script": "bin/rails server",
      "args": [],
      "askParameters": true,
      "useBundler": true,
    }
  ]
}
```

3. vscodeの上記メニュー「実行」から「デバッグの開始」

4. デバッグコンソールでデバッグ可能
