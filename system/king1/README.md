# 旅行社管理系统 (Travel Agency Management System)

## 项目简介

这是一个数据驱动的旅行社精细化管理系统，使用 Java Spring Boot 作为后端，Vue 3 作为前端，实现了完整的旅行社业务管理功能。

## 技术栈

### 后端
- Java 17+
- Spring Boot 2.7.15
- MyBatis-Plus 3.5.3
- Spring Security
- JWT 认证
- MySQL 8.0

### 前端
- Vue 3
- Element Plus
- Vue Router
- Axios
- ECharts
- Pinia

## 系统功能

1. **用户权限管理**：基于 RBAC 权限控制
2. **CRM 客户管理**：客户信息管理、跟进记录
3. **景区管理**：景区信息维护
4. **旅游路线管理**：路线规划、报价
5. **资源调度**：车辆、导游等资源管理
6. **订单处理**：订单管理、状态跟踪
7. **财务管理**：收支统计、报表
8. **数据可视化**：销售趋势、客户分布

## 项目结构

```
├── database/           # 数据库脚本
├── frontend/           # 前端项目
│   ├── src/            # 前端源代码
│   ├── index.html      # 入口页面
│   ├── package.json    # 依赖配置
│   └── vite.config.js  # Vite 配置
└── travel-agency/      # 后端项目
    ├── src/            # 后端源代码
    ├── pom.xml         # Maven 配置
    └── application.yml # 应用配置
```

## 快速开始

### 1. 环境要求

- JDK 17+
- Maven 3.8+
- Node.js 16+
- MySQL 8.0+

### 2. 数据库配置

1. 创建数据库 `travel_agency`
2. 执行 `database/schema.sql` 脚本初始化表结构和测试数据

### 3. 后端启动

```bash
# 进入后端目录
cd travel-agency

# 编译并启动
mvn spring-boot:run
```

后端服务默认运行在 `http://localhost:8080/api`

### 4. 前端启动

```bash
# 进入前端目录
cd frontend

# 安装依赖
npm install

# 启动开发服务器
npm run dev
```

或者使用内置的 HTTP 服务器：

```bash
# 进入前端目录
cd frontend

# 启动 HTTP 服务器
node server.js
```

前端服务默认运行在 `http://127.0.0.1:3002/`

### 5. 登录信息

- **用户名**：admin
- **密码**：123456

## API 文档

后端 API 文档可通过 Swagger UI 访问：
`http://localhost:8080/api/swagger-ui.html`

## 部署指南

### 生产环境部署

1. **后端部署**：
   - 执行 `mvn clean package` 构建 jar 包
   - 使用 `java -jar target/travel-agency-1.0.0.jar` 启动服务

2. **前端部署**：
   - 执行 `npm run build` 构建静态文件
   - 将 `dist` 目录部署到 Nginx 或其他 Web 服务器

### Docker 部署

（可选）使用 Docker 容器化部署：

1. 构建后端镜像
2. 构建前端镜像
3. 使用 Docker Compose 启动服务

## 项目特点

- **模块化设计**：清晰的分层架构
- **前后端分离**：独立开发和部署
- **响应式界面**：适配不同设备
- **数据可视化**：直观的数据分析
- **安全认证**：JWT 令牌验证
- **权限控制**：基于角色的访问控制

## 许可证

MIT License

## 联系方式

如有问题或建议，请联系项目维护者。