<template>
  <div class="user-container">
    <el-card>
      <template #header>
        <div class="card-header">
          <span>用户管理</span>
        </div>
      </template>
      <el-table :data="userList" v-loading="tableLoading" border stripe style="width: 100%">
        <el-table-column prop="id" label="ID" width="80" align="center" />
        <el-table-column prop="username" label="用户名" />
        <el-table-column prop="name" label="真实姓名" />
        <el-table-column prop="phone" label="手机号" />
        <el-table-column prop="department" label="部门" />
        <el-table-column prop="status" label="状态" width="100" align="center">
          <template #default="scope">
            <el-tag :type="scope.row.status === 1 ? 'success' : 'danger'">
              {{ scope.row.status === 1 ? '启用' : '禁用' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="150" align="center">
          <template #default="scope">
            <el-button size="small" type="danger" plain @click="deleteUser(scope.row.id)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import request from '@/utils/request'

const userList = ref([])
const tableLoading = ref(false)

const loadUsers = async () => {
  tableLoading.value = true
  try {
    const res = await request.get('/sys/user/list')
    userList.value = res.data
  } catch (error) {
    console.error(error)
  } finally {
    tableLoading.value = false
  }
}

const deleteUser = (id) => {
  ElMessageBox.confirm('确定要删除该用户吗?', '警告', { type: 'warning' }).then(async () => {
    await request.delete(`/sys/user/${id}`)
    ElMessage.success('删除成功')
    loadUsers() 
  }).catch(() => {})
}

onMounted(() => {
  loadUsers()
})
</script>

<style scoped>
.card-header { display: flex; justify-content: space-between; align-items: center; }
</style>