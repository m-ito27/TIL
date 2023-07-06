## Capybaraで親要素のクラスに基づいて子要素を見つける場合、CSSセレクタを利用することで実現できる

例えば、親クラスに'sample'を持ち、その子要素としてspan（テキストは'aaa')を取得したい場合

```ruby
span_with_sample_parent = page.find('.sample span', text: 'aaa')
```

これは、'sample'というクラスを持つ要素の中でテキストが'aaa'であるspan要素を見つけるという意味になります。

