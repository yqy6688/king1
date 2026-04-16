<template>
  <div class="login-container">
    <el-card class="login-card" shadow="hover">
      <template #header>
        <div class="login-title">
          <h2>旅行社管理系统</h2>
          <p>欢迎回来，请登录</p>
        </div>
      </template>
      <el-form :model="loginForm" :rules="rules" ref="loginFormRef" size="large">
        <el-form-item prop="username">
          <el-input v-model="loginForm.username" placeholder="请输入用户名" clearable />
        </el-form-item>
        <el-form-item prop="password">
          <el-input v-model="loginForm.password" type="password" placeholder="请输入密码" show-password @keyup.enter="login" />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" :loading="loading" @click="login" class="login-btn">
            {{ loading ? '登录中...' : '登 录' }}
          </el-button>
        </el-form-item>
      </el-form>
    </el-card>
  </div>
</template>

<script setup>
import { ref, reactive } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import request from '@/utils/request'

const router = useRouter()
const loginFormRef = ref(null)
const loading = ref(false)

const loginForm = reactive({
  username: '',
  password: ''
})

const rules = {
  username: [{ required: true, message: '请输入用户名', trigger: 'blur' }],
  password: [{ required: true, message: '请输入密码', trigger: 'blur' }]
}

const login = async () => {
  if (!loginFormRef.value) return
  await loginFormRef.value.validate(async (valid) => {
    if (valid) {
      loading.value = true
      try {
        const res = await request.post('/login', loginForm)
        localStorage.setItem('token', res.data.token)
        localStorage.setItem('user', JSON.stringify(res.data.user))
        ElMessage.success('登录成功')
        router.push('/home/dashboard')
      } catch (error) {
        // request.js 会自动提示错误，这里只需捕获即可
      } finally {
        loading.value = false
      }
    }
  })
}
</script>

<style scoped>
.login-container {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100vh;
  background: linear-gradient(135deg, #4361ee 0%, #3a0ca3 100%);
}
.login-card {
  width: 420px;
  border-radius: 12px;
  padding: 10px;
}
.login-title {
  text-align: center;
  color: #333;
}
.login-title h2 { margin-bottom: 5px; }
.login-title p { color: #888; font-size: 14px; margin: 0; }
.login-btn { width: 100%; border-radius: 6px; font-weight: bold; }
</style>