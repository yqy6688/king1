<template>
  <div class="customer-container">
    <el-card>
      <template #header>
        <div class="card-header">
          <span>客户管理</span>
          <el-button type="primary" @click="addCustomer">新增客户</el-button>
        </div>
      </template>
      <div class="search-form">
        <el-form :inline="true" :model="searchForm" class="demo-form-inline">
          <el-form-item label="客户姓名">
            <el-input v-model="searchForm.name" placeholder="请输入客户姓名" />
          </el-form-item>
          <el-form-item label="手机号">
            <el-input v-model="searchForm.phone" placeholder="请输入手机号" />
          </el-form-item>
          <el-form-item>
            <el-button type="primary" @click="search">查询</el-button>
            <el-button @click="reset">重置</el-button>
          </el-form-item>
        </el-form>
      </div>
      <el-table :data="customerList" style="width: 100%">
        <el-table-column prop="id" label="ID" width="80" />
        <el-table-column prop="name" label="客户姓名" />
        <el-table-column prop="gender" label="性别" width="80">
          <template #default="scope">
            {{ scope.row.gender === 1 ? '男' : '女' }}
          </template>
        </el-table-column>
        <el-table-column prop="phone" label="手机号" />
        <el-table-column prop="email" label="邮箱" />
        <el-table-column prop="levelName" label="客户等级" />
        <el-table-column prop="totalConsumption" label="总消费" />
        <el-table-column prop="orderCount" label="订单数" width="80" />
        <el-table-column label="操作" width="150">
          <template #default="scope">
            <el-button size="small" @click="editCustomer(scope.row)">编辑</el-button>
            <el-button size="small" type="danger" @click="deleteCustomer(scope.row.id)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>

    <!-- 新增/编辑客户对话框 -->
    <el-dialog v-model="dialogVisible" :title="dialogTitle">
      <el-form :model="form" :rules="rules" ref="formRef" label-width="80px">
        <el-form-item label="客户姓名" prop="name">
          <el-input v-model="form.name" placeholder="请输入客户姓名" />
        </el-form-item>
        <el-form-item label="性别" prop="gender">
          <el-radio-group v-model="form.gender">
            <el-radio label="1">男</el-radio>
            <el-radio label="2">女</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="手机号" prop="phone">
          <el-input v-model="form.phone" placeholder="请输入手机号" />
        </el-form-item>
        <el-form-item label="邮箱" prop="email">
          <el-input v-model="form.email" placeholder="请输入邮箱" />
        </el-form-item>
        <el-form-item label="身份证号" prop="idCard">
          <el-input v-model="form.idCard" placeholder="请输入身份证号" />
        </el-form-item>
        <el-form-item label="地址" prop="address">
          <el-input v-model="form.address" placeholder="请输入地址" />
        </el-form-item>
        <el-form-item label="客户等级" prop="levelId">
          <el-select v-model="form.levelId" placeholder="请选择客户等级">
            <el-option v-for="level in levelList" :key="level.id" :label="level.name" :value="level.id" />
          </el-select>
        </el-form-item>
        <el-form-item label="客户来源" prop="source">
          <el-input v-model="form.source" placeholder="请输入客户来源" />
        </el-form-item>
      </el-form>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="dialogVisible = false">取消</el-button>
          <el-button type="primary" @click="saveCustomer">确定</el-button>
        </span>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import axios from 'axios'

const customerList = ref([])
const levelList = ref([
  { id: 1, name: '普通客户' },
  { id: 2, name: '银卡客户' },
  { id: 3, name: '金卡客户' },
  { id: 4, name: '钻石客户' }
])
const searchForm = reactive({
  name: '',
  phone: ''
})
const dialogVisible = ref(false)
const dialogTitle = ref('新增客户')
const formRef = ref(null)
const form = reactive({
  id: null,
  name: '',
  gender: 1,
  phone: '',
  email: '',
  idCard: '',
  address: '',
  levelId: 1,
  source: '',
  totalConsumption: 0,
  orderCount: 0
})

const rules = {
  name: [{ required: true, message: '请输入客户姓名', trigger: 'blur' }],
  phone: [{ required: true, message: '请输入手机号', trigger: 'blur' }]
}

const loadCustomers = async () => {
  try {
    // 模拟数据
    customerList.value = [
      {
        id: 1,
        name: '张三',
        gender: 1,
        phone: '13900139001',
        email: 'zhangsan@example.com',
        idCard: '110101199001011234',
        address: '北京市朝阳区',
        levelId: 2,
        levelName: '银卡客户',
        source: '线下门店',
        totalConsumption: 6500,
        orderCount: 2
      },
      {
        id: 2,
        name: '李四',
        gender: 2,
        phone: '13900139002',
        email: 'lisi@example.com',
        idCard: '110101199002022345',
        address: '上海市浦东新区',
        levelId: 1,
        levelName: '普通客户',
        source: '线上咨询',
        totalConsumption: 2000,
        orderCount: 1
      },
      {
        id: 3,
        name: '王五',
        gender: 1,
        phone: '13900139003',
        email: 'wangwu@example.com',
        idCard: '110101199003033456',
        address: '广州市天河区',
        levelId: 3,
        levelName: '金卡客户',
        source: '老客户介绍',
        totalConsumption: 12000,
        orderCount: 3
      }
    ]
  } catch (error) {
    console.error('加载客户失败:', error)
  }
}

const search = () => {
  // 模拟搜索
  console.log('搜索:', searchForm)
}

const reset = () => {
  searchForm.name = ''
  searchForm.phone = ''
}

const addCustomer = () => {
  form.id = null
  form.name = ''
  form.gender = 1
  form.phone = ''
  form.email = ''
  form.idCard = ''
  form.address = ''
  form.levelId = 1
  form.source = ''
  form.totalConsumption = 0
  form.orderCount = 0
  dialogTitle.value = '新增客户'
  dialogVisible.value = true
}

const editCustomer = (customer) => {
  Object.assign(form, customer)
  dialogTitle.value = '编辑客户'
  dialogVisible.value = true
}

const saveCustomer = async () => {
  try {
    await formRef.value.validate()
    // 模拟保存
    if (form.id) {
      // 编辑
      const index = customerList.value.findIndex(c => c.id === form.id)
      if (index !== -1) {
        customerList.value[index] = { ...form }
      }
    } else {
      // 新增
      const newCustomer = { ...form, id: customerList.value.length + 1 }
      customerList.value.push(newCustomer)
    }
    dialogVisible.value = false
  } catch (error) {
    console.error('保存失败:', error)
  }
}

const deleteCustomer = (id) => {
  customerList.value = customerList.value.filter(c => c.id !== id)
}

onMounted(() => {
  loadCustomers()
})
</script>

<style scoped>
.customer-container {
  padding: 20px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.search-form {
  margin-bottom: 20px;
}

.dialog-footer {
  width: 100%;
  display: flex;
  justify-content: flex-end;
}
</style>
