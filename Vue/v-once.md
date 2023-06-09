## v-once​ディレクティブ

要素やコンポーネントを一度だけレンダリングし、その後の更新はスキップします。

```html
<div id='app'>
  <p v-once>{{message}}</p>  <!-- messageはHello, World!が表示される。v-onceがないとHello, VueJS!になる -->
  <p>{{ sayHi() }}</p>
  <button v-on:click="reverseMessage">メッセージ反転</button>
</div>

<script>
  new Vue({
    el: '#app',
    data: {
      message: 'Hello, World!'
    },
    methods: {
      reverseMessage: function() {
        this.message = this.message.split('').reverse().join('')
      },
      sayHi() {
        this.message = 'Hello, VueJS!'
        return 'Hi'
      }
    }
  })
</script>
```
