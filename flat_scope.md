## トップレベルで定義した変数を、クラスや、その中のメソッドに持ち込む方法

ブロックを定義するとき、その時点の変数も持ち込むことを利用して、Class.newやdefine_methodを使用する方法がある。

```ruby
my_var = '成功！'

MyClass = Class.new do
  puts "クラス内への持ち運び: #{my_var}"

  define_method :my_method do
    puts "メソッド内への持ち運び: #{my_var}"
  end
end

MyClass.new.my_method

# =>
# クラス内への持ち運び: 成功！
# メソッド内への持ち運び: 成功！
```
