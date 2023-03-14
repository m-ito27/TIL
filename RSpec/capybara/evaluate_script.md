## evaluate_scriptでJSの実行ができる

```ruby
it '' do
  page.evaluate_script('$(".xxx").removeClass("yyy")')
end
```
