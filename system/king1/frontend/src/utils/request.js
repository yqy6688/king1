import axios from 'axios'
import { ElMessage } from 'element-plus'
import router from '../router'

const service = axios.create({
  baseURL: '/api',
  timeout: 10000
})

// 请求拦截器
service.interceptors.request.use(config => {
  const token = localStorage.getItem('token')
  if (token) {
    config.headers['Authorization'] = 'Bearer ' + token
  }
  return config
}, error => {
  return Promise.reject(error)
})

// 响应拦截器
service.interceptors.response.use(response => {
  const res = response.data
  if (res.code !== 200) {
    ElMessage.error(res.message || '系统错误')
    return Promise.reject(new Error(res.message || 'Error'))
  }
  return res
}, error => {
  if (error.response && error.response.status === 401) {
    ElMessage.warning('登录已过期，请重新登录')
    localStorage.removeItem('token')
    localStorage.removeItem('user')
    router.push('/login')
  } else {
    ElMessage.error('网络请求失败，请检查后端服务')
  }
  return Promise.reject(error)
})

export default service