// 使用CDN加载的全局变量
const { createApp } = Vue
const { createRouter, createWebHistory } = VueRouter

// 导入组件
import App from './App.vue'
import router from './router'

const app = createApp(App)
app.use(router)
app.use(ElementPlus)
app.mount('#app')
