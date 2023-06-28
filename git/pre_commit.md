## git commit 時に今のブランチ名の情報をデフォルトで表示する

.git/hooks/pre-commit でブランチ名を取得する処理を書く


`.git/hooks/pre-commit`
```
BRANCH_NAME=`git symbolic-ref HEAD | sed -e 's:^refs/heads/::'`
sed -i "" "1s/.*/$BRANCH_NAME/" .commit_template.txt
```


x
