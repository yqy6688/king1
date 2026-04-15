<template>
  <div class="home-container">
    <el-container>
      <el-header height="60px" class="header">
        <div class="header-left">
          <el-menu :default-active="activeIndex" mode="horizontal" background-color="#001529" text-color="#fff" active-text-color="#ffd04b">
            <el-menu-item index="1">
              <el-icon><House /></el-icon>
              <span>首页</span>
            </el-menu-item>
          </el-menu>
        </div>
        <div class="header-right">
          <el-dropdown>
            <span class="user-info">
              {{ user.name }}
              <el-icon class="el-icon--right"><ArrowDown /></el-icon>
            </span>
            <template #dropdown>
              <el-dropdown-menu>
                <el-dropdown-item @click="logout">退出登录</el-dropdown-item>
              </el-dropdown-menu>
            </template>
          </el-dropdown>
        </div>
      </el-header>
      <el-container>
        <el-aside width="200px" class="sidebar">
          <el-menu
            :default-active="activeMenu"
            class="el-menu-vertical-demo"
            background-color="#001529"
            text-color="#fff"
            active-text-color="#ffd04b"
            router
          >
            <el-sub-menu index="system">
              <template #title>
                <el-icon><Setting /></el-icon>
                <span>系统管理</span>
              </template>
              <el-menu-item index="/home/system/user">用户管理</el-menu-item>
            </el-sub-menu>
            <el-sub-menu index="crm">
              <template #title>
                <el-icon><UserFilled /></el-icon>
                <span>客户管理</span>
              </template>
              <el-menu-item index="/home/crm/customer">客户列表</el-menu-item>
            </el-sub-menu>
            <el-menu-item index="/home/dashboard">
              <el-icon><DataAnalysis /></el-icon>
              <span>数据大屏</span>
            </el-menu-item>
          </el-menu>
        </el-aside>
        <el-main class="main-content">
          <router-view />
        </el-main>
      </el-container>
    </el-container>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { House, Setting, UserFilled, DataAnalysis, ArrowDown } from '@element-plus/icons-vue'

const router = useRouter()
const activeIndex = ref('1')
const activeMenu = ref('/home/dashboard')
const user = ref({ name: '管理员' })

onMounted(() => {
  const userStr = localStorage.getItem('user')
  if (userStr) {
    user.value = JSON.parse(userStr)
  }
})

const logout = () => {
  localStorage.removeItem('token')
  localStorage.removeItem('user')
  router.push('/login')
}
</script>

<style scoped>
.home-container {
  height: 100vh;
  overflow: hidden;
}

.header {
  background-color: #001529;
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 0 20px;
}

.header-left {
  flex: 1;
}

.header-right {
  color: #fff;
  cursor: pointer;
}

.user-info {
  display: flex;
  align-items: center;
}

.sidebar {
  background-color: #001529;
}

.main-content {
  padding: 20px;
  background-color: #f0f2f5;
  overflow-y: auto;
}
</style>
