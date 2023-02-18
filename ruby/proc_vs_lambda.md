## procとlambdaの違い

### 1.returnの動作

lambdaはlambdaから戻るが、
ProcはProcが定義されたスコープから戻る

```ruby
def double(callable_object)
  callable_object.call * 2
end

l = lambda { return 10 }
p double(l)
# => 20
```

```ruby
def another_double
  p = Proc.new { return 10 } # Procが定義されたanother_doubleメソッドから戻る
  result = p.call # 実行されない
  return result * 2　# 実行されない
end

p another_double
# => 10
```

### 2.引数の厳格さ

procは合わせてくれるが、lambdaは厳格

```ruby
pr = Proc.new { |a, b| [a, b] }
p pr.call(1, 2, 3)
# => [1,2]
p pr.call(1)
# => [1, nil]

l = ->(a, b) { [a, b] }
p l.call(1, 2, 3)
# => ArgumentError
```
