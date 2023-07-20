## railsガイドより:ルーティングでredirectを使うと、任意のパスを他のパスにリダイレクトできます。

```ruby
get '/stories', to: redirect('/articles')
```

パスにマッチする動的セグメントを再利用してリダイレクトすることもできます。

```ruby
get '/stories/:name', to: redirect('/articles/%{name}')
```

リダイレクトにブロックを渡すこともできます。このリダイレクトは、シンボル化されたパスパラメータとrequestオブジェクトを受け取ります。

```ruby
get '/stories/:name', to: redirect { |path_params, req| "/articles/#{path_params[:name].pluralize}" }
get '/stories', to: redirect { |path_params, req| "/articles/#{req.subdomain}" }
```
