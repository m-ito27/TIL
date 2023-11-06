require 'benchmark'

execution_time = Benchmark.realtime do
  a = (1..30000).to_a
  b = []
  30000.times do |num|
    b << a.sample
    a - [b]
  end

  p b.sort.find { |num| num > 5000 }

  # p b.sort.bsearch { |num| num > 5000 }
end

puts "実行時間: #{execution_time}秒"
