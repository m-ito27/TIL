## capybaraのfindメソッドを読む

### 目的

`find('h1', text: 'Books')`のように書くと、要素を取得できるが、取得方法と、要素をどのように持っていれば要素ごとに取得できるのかを知りたい。

### コードリーディング

```ruby
# capybara-3.39.2/lib/capybara/node/finders.rb

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
# capybara-3.39.2/lib/capybara/node/finders.rb

def synced_resolve(query)
  synchronize(query.wait) do
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
# capybara-3.39.2/lib/capybara/queries/selector_query.rb
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

ここで、`find_context`はChromeドライバーのインスタンスでした。

```ruby
find_context.class
#=> Selenium::WebDriver::Chrome::Driver
```

`find_elements`した結果は、ドライバーの要素のインスタンスのようです。

```ruby
find_context.find_elements(format, selector).first.class
#=> Selenium::WebDriver::Element
```

`find_nodes_by_selector_format`は、cssセレクターで絞ってるのみ。
textでの絞り込みは、`result_for`メソッドのうち、`Capybara::Result.new(ordered_results(children), self)`で行っている。

`Capybara::Result`は、説明にある通り、`Capybara::Node::Element`のコレクションを返すクラスです。

> A {Capybara::Result} represents a collection of {Capybara::Node::Element} on the page. It is possible to interact with this
collection similar to an Array because it implements Enumerable and offers the following Array methods through delegation:

```ruby
# capybara-3.39.2/lib/capybara/result.rb

def initialize(elements, query)
  @elements = elements
  @result_cache = []
  @filter_errors = []
  @results_enum = lazy_select_elements { |node| query.matches_filters?(node, @filter_errors) }
  @query = query
  @allow_reload = false
end
```

このうち、以下が絞り込みの場所。
```
@results_enum = lazy_select_elements { |node| query.matches_filters?(node, @filter_errors) }
```

`matches_filters`を見てみる。

```ruby
# capybara-3.39.2/lib/capybara/queries/selector_query.rb

def matches_filters?(node, node_filter_errors = [])
  return true if (@resolved_node&.== node) && options[:allow_self]

  matches_locator_filter?(node) &&
    matches_system_filters?(node) &&
    matches_spatial_filters?(node) &&
    matches_node_filters?(node, node_filter_errors) &&
    matches_filter_block?(node)
rescue *(node.respond_to?(:session) ? node.session.driver.invalid_element_errors : [])
  false
end
```

例えば、textが存在しなくてテストが失敗する場合、どこが失敗するかというと、`matches_system_filters?(node)`が落ちていた。
このメソッドの中でも色々な観点でテストしていた、、、

```ruby
def matches_system_filters?(node)
  applied_filters << :system

  matches_visibility_filters?(node) &&
    matches_id_filter?(node) &&
    matches_class_filter?(node) &&
    matches_style_filter?(node) &&
    matches_focused_filter?(node) &&
    matches_text_filter?(node) &&
    matches_exact_text_filter?(node)
end
```

このうち、落ちていたのは命名通り`matches_text_filter?(node)`でした。

```ruby
def matches_text_filter?(node)
  value = options[:text]
  return true unless value
  return matches_text_exactly?(node, value) if exact_text == true && !value.is_a?(Regexp)

  regexp = value.is_a?(Regexp) ? value : Regexp.escape(value.to_s)
  matches_text_regexp?(node, regexp)
end
```

`matches_text_regexp?`を見てみる

```ruby
def matches_text_exactly?(node, value)
  regexp = value.is_a?(Regexp) ? value : /\A#{Regexp.escape(value.to_s)}\z/
  matches_text_regexp(node, regexp).then { |m| m&.pre_match == '' && m&.post_match == '' }
end
```

`matches_text_regexp`を見てみる

```ruby
def matches_text_regexp(node, regexp)
  text_visible = visible
  text_visible = :all if text_visible == :hidden
  node.text(text_visible, normalize_ws: normalize_ws).match(regexp)
end
```

`node.text`で要素のテキストを、`regexp`は指定したテキストで比べている。
`match`とあるように、部分一致（要素名が指定したテキストを含む）でも要素を見つけてくれる。

```ruby
node.text(text_visible, normalize_ws: normalize_ws)
#=> 'Books' # HTML上にある要素のテキスト
regexp
#=> find('h1', text: xxx)のxxxの部分
```

nodeは、`Capybara::Node::Element`のインスタンス。
textメソッドで何をしているのかを見てみる。

```ruby
# capybara-3.39.2/lib/capybara/node/element.rb
def text(type = nil, normalize_ws: false)
  type ||= :all unless session_options.ignore_hidden_elements || session_options.visible_text_only
  txt = synchronize { type == :all ? base.all_text : base.visible_text }
  normalize_ws ? txt.gsub(/[[:space:]]+/, ' ').strip : txt
end
```

ここで、`base`は`Capybara::Selenium::ChromeNode`のインスタンス。
```ruby
base
#=> #<Capybara::Selenium::ChromeNode tag="h1" path="/HTML/BODY[1]/H1[1]">
```

この`visible_text`を見てみる。

```ruby
# capybara-3.39.2/lib/capybara/selenium/node.rb

def visible_text
  raise NotImplementedError, 'Getting visible text is not currently supported directly on shadow roots' if shadow_root?

  native.text
end
```

`native`は、`Selenium::WebDriver::Element`のインスタンス。

```ruby
native
#<Selenium::WebDriver::Element:0x2752d60c0325459a id="F179ECD68309B6E745A5B07B5E932EC9_element_2">
```

`Selenium::WebDriver::Element`の`text`メソッドを見てみる。

```ruby
# selenium-webdriver-4.10.0/lib/selenium-webdriver.rb

def text
  bridge.element_text @id
end
```

`bridge`は、`Selenium::WebDriver::Remote::Bridge`クラスのインスタンス。

```ruby
# selenium-webdriver-4.10.0/lib/selenium/webdriver/remote/bridge.rb

def element_text(element)
  execute :get_element_text, id: element
end

private

#
# executes a command on the remote server.
#
# @return [WebDriver::Remote::Response]
#

def execute(command, opts = {}, command_hash = nil)
  verb, path = commands(command) || raise(ArgumentError, "unknown command: #{command.inspect}")
  path = path.dup

  path[':session_id'] = session_id if path.include?(':session_id')

  begin
    opts.each { |key, value| path[key.inspect] = escaper.escape(value.to_s) }
  rescue IndexError
    raise ArgumentError, "#{opts.inspect} invalid for #{command.inspect}"
  end

  WebDriver.logger.debug("-> #{verb.to_s.upcase} #{path}", id: :command)
  http.call(verb, path, command_hash)['value']
end

def commands(command)
  COMMANDS[command]
end
```

これをみると、webdriverのAPIを叩きに行っているのがわかる。
https://w3c.github.io/webdriver/#dfn-get-element-text

> The Get Element Text command intends to return an element’s text “as rendered”

とのことなので、これでテキストを取得しているんですね。


