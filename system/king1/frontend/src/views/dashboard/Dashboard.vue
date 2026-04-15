<template>
  <div class="dashboard-container">
    <el-card class="overview-card">
      <template #header>
        <span>经营仪表盘</span>
      </template>
      <div class="overview-stats">
        <div class="stat-item">
          <div class="stat-value">{{ stats.orderCount }}</div>
          <div class="stat-label">订单量</div>
        </div>
        <div class="stat-item">
          <div class="stat-value">{{ stats.revenue }}</div>
          <div class="stat-label">营收</div>
        </div>
        <div class="stat-item">
          <div class="stat-value">{{ stats.customerCount }}</div>
          <div class="stat-label">客户数</div>
        </div>
        <div class="stat-item">
          <div class="stat-value">{{ stats.profit }}</div>
          <div class="stat-label">利润</div>
        </div>
      </div>
    </el-card>

    <div class="chart-row">
      <el-card class="chart-card">
        <template #header>
          <span>销售趋势分析</span>
        </template>
        <div ref="salesChartRef" class="chart-container"></div>
      </el-card>
      <el-card class="chart-card">
        <template #header>
          <span>热门线路TOP10</span>
        </template>
        <div ref="routeChartRef" class="chart-container"></div>
      </el-card>
    </div>

    <div class="chart-row">
      <el-card class="chart-card">
        <template #header>
          <span>景点热度排行</span>
        </template>
        <div ref="scenicChartRef" class="chart-container"></div>
      </el-card>
      <el-card class="chart-card">
        <template #header>
          <span>客户画像分析</span>
        </template>
        <div ref="customerChartRef" class="chart-container"></div>
      </el-card>
    </div>

    <div class="chart-row">
      <el-card class="chart-card full-width">
        <template #header>
          <span>财务报表可视化</span>
        </template>
        <div ref="financeChartRef" class="chart-container"></div>
      </el-card>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted } from 'vue'
import * as echarts from 'echarts'

const stats = ref({
  orderCount: 128,
  revenue: '¥128,000',
  customerCount: 86,
  profit: '¥32,000'
})

const salesChartRef = ref(null)
const routeChartRef = ref(null)
const scenicChartRef = ref(null)
const customerChartRef = ref(null)
const financeChartRef = ref(null)

let salesChart = null
let routeChart = null
let scenicChart = null
let customerChart = null
let financeChart = null

const initSalesChart = () => {
  if (!salesChartRef.value) return
  salesChart = echarts.init(salesChartRef.value)
  const option = {
    title: {
      text: '销售趋势',
      left: 'center'
    },
    tooltip: {
      trigger: 'axis'
    },
    legend: {
      data: ['订单量', '营收'],
      bottom: 0
    },
    xAxis: {
      type: 'category',
      data: ['1月', '2月', '3月', '4月', '5月', '6月']
    },
    yAxis: [
      {
        type: 'value',
        name: '订单量',
        position: 'left'
      },
      {
        type: 'value',
        name: '营收(万元)',
        position: 'right'
      }
    ],
    series: [
      {
        name: '订单量',
        type: 'bar',
        data: [120, 132, 101, 134, 90, 230]
      },
      {
        name: '营收',
        type: 'line',
        yAxisIndex: 1,
        data: [12, 13.2, 10.1, 13.4, 9, 23]
      }
    ]
  }
  salesChart.setOption(option)
}

const initRouteChart = () => {
  if (!routeChartRef.value) return
  routeChart = echarts.init(routeChartRef.value)
  const option = {
    title: {
      text: '热门线路TOP10',
      left: 'center'
    },
    tooltip: {
      trigger: 'axis',
      axisPointer: {
        type: 'shadow'
      }
    },
    xAxis: {
      type: 'category',
      data: ['北京经典5日游', '上海迪士尼3日游', '杭州西湖2日游', '黄山4日游', '张家界3日游', '三亚5日游', '九寨沟4日游', '西安3日游', '厦门2日游', '桂林3日游'],
      axisLabel: {
        rotate: 45
      }
    },
    yAxis: {
      type: 'value',
      name: '订单量'
    },
    series: [
      {
        name: '订单量',
        type: 'bar',
        data: [35, 30, 25, 20, 18, 15, 12, 10, 8, 5],
        itemStyle: {
          color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
            { offset: 0, color: '#83bff6' },
            { offset: 0.5, color: '#188df0' },
            { offset: 1, color: '#188df0' }
          ])
        }
      }
    ]
  }
  routeChart.setOption(option)
}

const initScenicChart = () => {
  if (!scenicChartRef.value) return
  scenicChart = echarts.init(scenicChartRef.value)
  const option = {
    title: {
      text: '景点热度排行',
      left: 'center'
    },
    tooltip: {
      trigger: 'item'
    },
    legend: {
      orient: 'vertical',
      left: 'left'
    },
    series: [
      {
        name: '访问次数',
        type: 'pie',
        radius: '50%',
        data: [
          { value: 1000000, name: '故宫博物院' },
          { value: 900000, name: '西湖' },
          { value: 800000, name: '长城' },
          { value: 700000, name: '上海外滩' },
          { value: 600000, name: '颐和园' },
          { value: 500000, name: '黄山' }
        ],
        emphasis: {
          itemStyle: {
            shadowBlur: 10,
            shadowOffsetX: 0,
            shadowColor: 'rgba(0, 0, 0, 0.5)'
          }
        }
      }
    ]
  }
  scenicChart.setOption(option)
}

const initCustomerChart = () => {
  if (!customerChartRef.value) return
  customerChart = echarts.init(customerChartRef.value)
  const option = {
    title: {
      text: '客户年龄分布',
      left: 'center'
    },
    tooltip: {
      trigger: 'axis'
    },
    xAxis: {
      type: 'category',
      data: ['18-25岁', '26-35岁', '36-45岁', '46-55岁', '56岁以上']
    },
    yAxis: {
      type: 'value',
      name: '客户数量'
    },
    series: [
      {
        name: '客户数量',
        type: 'line',
        data: [15, 30, 25, 10, 6],
        smooth: true,
        itemStyle: {
          color: '#5470c6'
        },
        areaStyle: {
          color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
            { offset: 0, color: 'rgba(84, 112, 198, 0.5)' },
            { offset: 1, color: 'rgba(84, 112, 198, 0.1)' }
          ])
        }
      }
    ]
  }
  customerChart.setOption(option)
}

const initFinanceChart = () => {
  if (!financeChartRef.value) return
  financeChart = echarts.init(financeChartRef.value)
  const option = {
    title: {
      text: '财务收支分析',
      left: 'center'
    },
    tooltip: {
      trigger: 'axis'
    },
    legend: {
      data: ['收入', '支出'],
      bottom: 0
    },
    xAxis: {
      type: 'category',
      data: ['1月', '2月', '3月', '4月', '5月', '6月']
    },
    yAxis: {
      type: 'value',
      name: '金额(万元)'
    },
    series: [
      {
        name: '收入',
        type: 'bar',
        data: [12, 15, 18, 20, 25, 30]
      },
      {
        name: '支出',
        type: 'bar',
        data: [8, 10, 12, 14, 16, 18]
      },
      {
        name: '利润',
        type: 'line',
        data: [4, 5, 6, 6, 9, 12],
        itemStyle: {
          color: '#91cc75'
        }
      }
    ]
  }
  financeChart.setOption(option)
}

const handleResize = () => {
  salesChart?.resize()
  routeChart?.resize()
  scenicChart?.resize()
  customerChart?.resize()
  financeChart?.resize()
}

onMounted(() => {
  initSalesChart()
  initRouteChart()
  initScenicChart()
  initCustomerChart()
  initFinanceChart()
  window.addEventListener('resize', handleResize)
})

onUnmounted(() => {
  window.removeEventListener('resize', handleResize)
  salesChart?.dispose()
  routeChart?.dispose()
  scenicChart?.dispose()
  customerChart?.dispose()
  financeChart?.dispose()
})
</script>

<style scoped>
.dashboard-container {
  padding: 20px;
}

.overview-card {
  margin-bottom: 20px;
}

.overview-stats {
  display: flex;
  justify-content: space-around;
  flex-wrap: wrap;
}

.stat-item {
  text-align: center;
  padding: 20px;
  background: #f5f7fa;
  border-radius: 8px;
  flex: 1;
  margin: 0 10px;
  min-width: 150px;
}

.stat-value {
  font-size: 24px;
  font-weight: bold;
  color: #1890ff;
  margin-bottom: 8px;
}

.stat-label {
  font-size: 14px;
  color: #666;
}

.chart-row {
  display: flex;
  margin-bottom: 20px;
  gap: 20px;
}

.chart-card {
  flex: 1;
  min-width: 400px;
}

.full-width {
  flex: 2;
  min-width: 820px;
}

.chart-container {
  width: 100%;
  height: 400px;
}

@media screen and (max-width: 1200px) {
  .chart-row {
    flex-direction: column;
  }
  
  .chart-card {
    min-width: 100%;
  }
  
  .full-width {
    min-width: 100%;
  }
}
</style>
