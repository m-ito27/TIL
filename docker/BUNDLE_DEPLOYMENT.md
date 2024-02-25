DockerでRailsを立ち上げていた時、`Gemfile`にgemを追加して、以下を実行したらエラーになった。

```
$ docker-compose run web bundle install
Creating docker_rails7_web_run ... done
You are trying to install in deployment mode after changing
your Gemfile. Run `bundle install` elsewhere and add the
updated Gemfile.lock to version control.

The dependencies in your gemfile changed

You have added to the Gemfile:
* mailcatcher
ERROR: 16
```

`Dockerfile`をみてみると、`BUNDLE_DEPLOYMENT="1"`という設定を書いてしまっていて、これが原因だった。開発環境のため、その部分を削除してOK.

```Dockerfile
ENV RAILS_ENV="development" \
    BUNDLE_DEPLOYMENT="1" \
    ...
```

デプロイモードというみたい。

以下、ChatGPTに聞いた。

```
BUNDLE_DEPLOYMENT='1'という設定は、Dockerfile内でBundlerを「デプロイメントモード」で実行することを指定しています。これは、BundlerがGemfileとGemfile.lockの間の一貫性を厳格に扱うようになることを意味し、以下のような挙動を引き起こします：

一貫性の強制:
デプロイメントモードでは、BundlerはGemfile.lockに記載されている通りの正確なgemのバージョンをインストールします。もしGemfile.lockに記載されているバージョンと一致しないgemがGemfileに指定されていた場合、Bundlerはエラーを発生させます。

システムのgemを使用しない:
このモードでは、Bundlerはシステムにインストールされているgemを使用せず、明示的にGemfile.lockで指定されたバージョンのgemを使用します。

キャッシュの生成:
bundle installが実行されると、使用されている全てのgemのキャッシュが生成されます。これにより、将来的に同じgemを再インストールする際に、ダウンロードせずに済むようになります。

デプロイメントモードは、本番環境やCI/CDパイプラインなど、アプリケーションが一貫した環境で実行されることが重要な場合に特に有効です。しかし、開発環境で頻繁にgemを追加または更新する場合、このモードが原因でエラーが発生することがあります。開発中には、BUNDLE_DEPLOYMENTを0に設定するか、環境変数から削除することが一般的です。
```
