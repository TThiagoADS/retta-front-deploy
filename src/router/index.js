import { createRouter, createWebHistory } from 'vue-router'
import Home from '@/components/Home.vue'


const routes = [
  {
    path: '/',
    name: 'Home',
    component: Home
  },
]

const router = createRouter({
  history: createWebHistory(),
  routes,
})

router.beforeEach((to, from, next) => {
  const token = localStorage.getItem('authToken')
  if (to.meta.requiresAuth && !token) {
    return next({ name: 'Login' })
  }
  next()
})

export default router
