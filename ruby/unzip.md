## zipファイルを解凍する方法

```ruby
$ gem install rubyzip
```

以下がzipファイルを解凍する方法

```
Zip::File.open(zip_name) do |zip_file|
  zip_file.each do |file|
    file.extract(file.name)
  end
end
```
