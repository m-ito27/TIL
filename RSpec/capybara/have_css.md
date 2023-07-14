> label[for='aaa']という要素があることをcapybaraで確認する方法を教えてください

Capybaraでは、CSSセレクタを使用して特定の要素が存在するかどうかを確認することができます。have_cssメソッドを使用して、特定のCSSセレクタを持つ要素が存在することを確認することができます。

以下に、label[for='aaa']という要素が存在するかどうかを確認する例を示します。

```ruby
expect(page).to have_css('label[for="aaa"]')
```

このコードは、label[for='aaa']というCSSセレクタを持つ要素がページ上に存在することを確認します。
