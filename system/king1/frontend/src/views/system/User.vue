<template>
  <div class="user-container">
    <el-card>
      <template #header>
        <div class="card-header">
          <span>用户管理</span>
          <el-button type="primary" @click="handleAdd">新增用户</el-button>
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

    <el-dialog v-model="dialogVisible" title="新增用户" width="500px">
      <el-form :model="form" label-width="80px">
        <el-form-item label="用户名">
          <el-input v-model="form.username" placeholder="请输入登录账号" />
        </el-form-item>
        <el-form-item label="密码">
          <el-input v-model="form.password" placeholder="不填则默认为 123456" type="password" show-password />
        </el-form-item>
        <el-form-item label="真实姓名">
          <el-input v-model="form.name" placeholder="请输入员工姓名" />
        </el-form-item>
        <el-form-item label="手机号">
          <el-input v-model="form.phone" placeholder="请输入手机号" />
        </el-form-item>
        <el-form-item label="部门">
          <el-input v-model="form.department" placeholder="请输入所在部门" />
        </el-form-item>
      </el-form>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="dialogVisible = false">取 消</el-button>
          <el-button type="primary" @click="saveUser">确 定</el-button>
        </span>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import request from '@/utils/request'

const userList = ref([])
const tableLoading = ref(false)

// 控制弹窗显示隐藏的变量
const dialogVisible = ref(false)
// 表单数据绑定
const form = reactive({
  username: '',
  password: '',
  name: '',
  phone: '',
  department: ''
})

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

// 点击新增按钮触发
const handleAdd = () => {
  // 清空上一次填写的表单内容
  Object.assign(form, { username: '', password: '', name: '', phone: '', department: '' })
  dialogVisible.value = true
}

// 提交保存用户
const saveUser = async () => {
  if (!form.username) {
    ElMessage.warning('用户名不能为空')
    return
  }
  try {
    // 调用刚才我们在后端写的那个 POST 接口
    await request.post('/sys/user', form)
    ElMessage.success('新增用户成功！')
    dialogVisible.value = false
    loadUsers() // 重新刷新列表
  } catch (error) {
    console.error(error)
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