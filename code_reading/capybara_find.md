## capybaraのfindメソッドを読む

- 目的

`find('h1', text: 'Books')`のように書くと、要素を取得できるが、取得方法と、要素をどのように持っていれば要素ごとに取得できるのかを知りたい。

```ruby
# vendor/bundle/ruby/3.1.0/gems/capybara-3.39.2/lib/capybara/node/finders.rb

def find(*args, **options, &optional_filter_block)
  options[:session_options] = session_options
  count_options = options.slice(*Capybara::Queries::BaseQuery::COUNT_KEYS)
  unless count_options.empty?
    Capybara::Helpers.warn(
      "'find' does not support count options (#{count_options}) ignoring. " \
      "Called from: #{Capybara::Helpers.filter_backtrace(caller)}"
    )
  end
  synced_resolve Capybara::Queries::SelectorQuery.new(*args, **options, &optional_filter_block)
end
```

このうち、以下が実際に見つける処理。

```ruby
synced_resolve Capybara::Queries::SelectorQuery.new(*args, **options, &optional_filter_block)
```

`synced_resolve`を見てみる。

```ruby
# vendor/bundle/ruby/3.1.0/gems/capybara-3.39.2/lib/capybara/node/finders.rb

def synced_resolve(query)
  synchronize(query.wait) do
    binding.irb
    if prefer_exact?(query)
      result = query.resolve_for(self, true)
      result = query.resolve_for(self, false) if result.empty? && query.supports_exact? && !query.exact?
    else
      result = query.resolve_for(self)
    end

    if ambiguous?(query, result)
      raise Capybara::Ambiguous, "Ambiguous match, found #{result.size} elements matching #{query.applied_description}"
    end
    raise Capybara::ElementNotFound, "Unable to find #{query.applied_description}" if result.empty?

    result.first
  end.tap(&:allow_reload!)
end
```

このうち、`result = query.resolve_for(self, true)`で見つけていた。

`resolve_for`を見てみる。

```ruby
def resolve_for(node, exact = nil)
  applied_filters.clear
  @filter_cache.clear
  @resolved_node = node
  @resolved_count += 1

  node.synchronize do
    children = find_nodes_by_selector_format(node, exact).map(&method(:to_element))
    Capybara::Result.new(ordered_results(children), self)
  end
end
```

`find_nodes_by_selector_format`を見てみる。

```ruby
# capybara-3.39.2/lib/capybara/queries/selector_query.rb

def find_nodes_by_selector_format(node, exact)
  hints = {}
  hints[:uses_visibility] = true unless visible == :all
  hints[:texts] = text_fragments unless selector_format == :xpath
  hints[:styles] = options[:style] if use_default_style_filter?
  hints[:position] = true if use_spatial_filter?

  case selector_format
  when :css
    if node.method(:find_css).arity == 1
      node.find_css(css)
    else
      node.find_css(css, **hints)
    end
  when :xpath
    if node.method(:find_xpath).arity == 1
      node.find_xpath(xpath(exact))
    else
      node.find_xpath(xpath(exact), **hints)
    end
  else
    raise ArgumentError, "Unknown format: #{selector_format}"
  end
end
```

`find_css`を追いかけると、以下に辿り着く

```ruby
# capybara-3.39.2/lib/capybara/selenium/extensions/find.rb

def find_by(format, selector, uses_visibility:, texts:, styles:, position:)
  els = find_context.find_elements(format, selector)
  hints = []

  if (els.size > 2) && !ENV['DISABLE_CAPYBARA_SELENIUM_OPTIMIZATIONS']
    els = filter_by_text(els, texts) unless texts.empty?
    hints = gather_hints(els, uses_visibility: uses_visibility, styles: styles, position: position)
  end
  els.map.with_index { |el, idx| build_node(el, hints[idx] || {}) }
end
```
