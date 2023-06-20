## public_sendではprivate methodは呼び出せないので、public_methodで事足りるときはこちらが良さそう

```ruby
class Sample
  def pub_method
    p 'public'
  end

  def pub_method2
    public_send(:pub_method)
  end

  def pub_method3
    public_send(:pri_method)
  end

  private

  def pri_method
    p 'private'
  end
end

sample = Sample.new

sample.send(:pub_method) # => 'public'
sample.send(:pub_method2) # => 'public'
sample.send(:pub_method3) # => NoMethodError
sample.send(:pri_method) # => 'private'


sample.public_send(:pub_method) # => 'public'
sample.public_send(:pub_method2) # => 'public'
sample.public_send(:pub_method3) # => NoMethodError
sample.public_send(:pri_method) # => NoMethodError
```
