<template>
  <div class="user-container">
    <el-card>
      <template #header>
        <div class="card-header">
          <span>用户管理</span>
          <el-button type="primary" @click="addUser">新增用户</el-button>
        </div>
      </template>
      <el-table :data="userList" style="width: 100%">
        <el-table-column prop="id" label="ID" width="80" />
        <el-table-column prop="username" label="用户名" />
        <el-table-column prop="name" label="真实姓名" />
        <el-table-column prop="phone" label="手机号" />
        <el-table-column prop="email" label="邮箱" />
        <el-table-column prop="department" label="部门" />
        <el-table-column prop="status" label="状态" width="100">
          <template #default="scope">
            <el-tag :type="scope.row.status === 1 ? 'success' : 'danger'">
              {{ scope.row.status === 1 ? '启用' : '禁用' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="150">
          <template #default="scope">
            <el-button size="small" @click="editUser(scope.row)">编辑</el-button>
            <el-button size="small" type="danger" @click="deleteUser(scope.row.id)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>

    <!-- 新增/编辑用户对话框 -->
    <el-dialog v-model="dialogVisible" :title="dialogTitle">
      <el-form :model="form" :rules="rules" ref="formRef" label-width="80px">
        <el-form-item label="用户名" prop="username">
          <el-input v-model="form.username" placeholder="请输入用户名" />
        </el-form-item>
        <el-form-item label="密码" prop="password">
          <el-input v-model="form.password" type="password" placeholder="请输入密码" />
        </el-form-item>
        <el-form-item label="真实姓名" prop="name">
          <el-input v-model="form.name" placeholder="请输入真实姓名" />
        </el-form-item>
        <el-form-item label="手机号" prop="phone">
          <el-input v-model="form.phone" placeholder="请输入手机号" />
        </el-form-item>
        <el-form-item label="邮箱" prop="email">
          <el-input v-model="form.email" placeholder="请输入邮箱" />
        </el-form-item>
        <el-form-item label="部门" prop="department">
          <el-input v-model="form.department" placeholder="请输入部门" />
        </el-form-item>
        <el-form-item label="状态" prop="status">
          <el-switch v-model="form.status" />
        </el-form-item>
      </el-form>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="dialogVisible = false">取消</el-button>
          <el-button type="primary" @click="saveUser">确定</el-button>
        </span>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import axios from 'axios'

const userList = ref([])
const dialogVisible = ref(false)
const dialogTitle = ref('新增用户')
const formRef = ref(null)
const form = reactive({
  id: null,
  username: '',
  password: '',
  name: '',
  phone: '',
  email: '',
  department: '',
  status: 1
})

const rules = {
  username: [{ required: true, message: '请输入用户名', trigger: 'blur' }],
  password: [{ required: true, message: '请输入密码', trigger: 'blur' }],
  name: [{ required: true, message: '请输入真实姓名', trigger: 'blur' }]
}

const loadUsers = async () => {
  try {
    // 模拟数据
    userList.value = [
      {
        id: 1,
        username: 'admin',
        name: '系统管理员',
        phone: '13800138000',
        email: 'admin@example.com',
        department: '总经办',
        status: 1
      },
      {
        id: 2,
        username: 'operator',
        name: '计调员',
        phone: '13800138001',
        email: 'operator@example.com',
        department: '计调部',
        status: 1
      },
      {
        id: 3,
        username: 'sales',
        name: '销售员',
        phone: '13800138002',
        email: 'sales@example.com',
        department: '销售部',
        status: 1
      }
    ]
  } catch (error) {
    console.error('加载用户失败:', error)
  }
}

const addUser = () => {
  form.id = null
  form.username = ''
  form.password = ''
  form.name = ''
  form.phone = ''
  form.email = ''
  form.department = ''
  form.status = 1
  dialogTitle.value = '新增用户'
  dialogVisible.value = true
}

const editUser = (user) => {
  Object.assign(form, user)
  dialogTitle.value = '编辑用户'
  dialogVisible.value = true
}

const saveUser = async () => {
  try {
    await formRef.value.validate()
    // 模拟保存
    if (form.id) {
      // 编辑
      const index = userList.value.findIndex(u => u.id === form.id)
      if (index !== -1) {
        userList.value[index] = { ...form }
      }
    } else {
      // 新增
      const newUser = { ...form, id: userList.value.length + 1 }
      userList.value.push(newUser)
    }
    dialogVisible.value = false
  } catch (error) {
    console.error('保存失败:', error)
  }
}

const deleteUser = (id) => {
  userList.value = userList.value.filter(u => u.id !== id)
}

onMounted(() => {
  loadUsers()
})
</script>

<style scoped>
.user-container {
  padding: 20px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.dialog-footer {
  width: 100%;
  display: flex;
  justify-content: flex-end;
}
</style>
