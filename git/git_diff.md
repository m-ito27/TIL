## git diffでPR作成前に修正したファイル一覧を表示する

```bash
$ git diff --diff-filter-ASMR --name-only <commitID>
```
commitIDは、git logで作業元となったところのcommitIDを指定。

最後にrubocop かける時などは以下。

```bash
$ git diff --diff-filter-ASMR --name-only <commitID> | xargs -r rubocop |
```
