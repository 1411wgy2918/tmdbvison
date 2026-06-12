# TMDB 数据源使用指南

## 功能概述

Kazumi 现已支持 TMDB（The Movie Database）作为第二数据源，用户可以在 Bangumi 和 TMDB 之间自由切换，查看不同数据库的动漫内容推荐和搜索。

## 功能特性

### 1. 首页数据源切换

- 在首页顶部添加了 SegmentedButton 数据源切换按钮
- 支持 Bangumi 和 TMDB 两种数据源
- 切换后自动刷新内容列表
- 标签列表根据数据源自动更新

### 2. 搜索页面数据源切换

- 搜索页面顶部添加了数据源切换按钮
- 切换数据源后自动重新搜索
- 搜索结果来自选中的数据源

### 3. TMDB 数据支持

- 热门动漫推荐
- 评分最高动漫
- 正在播出动漫
- 关键词搜索
- 分类筛选

## 配置 TMDB

### 获取 TMDB API Key

1. 访问 [TMDB 官网](https://www.themoviedb.org/)
2. 注册或登录账号
3. 进入设置页面：[https://www.themoviedb.org/settings/api](https://www.themoviedb.org/settings/api)
4. 点击"Create"创建 API Key
5. 选择"Developer"类型
6. 填写基本信息（用途、网站等）
7. 提交后获得 API Key（v3 auth）

### 在 Kazumi 中配置

1. 打开设置 → Bangumi 配置
2. 点击右上角的 TMDB 图标
3. 输入 TMDB API Key
4. 点击保存按钮验证
5. 验证成功后即可使用

### 设置默认数据源

1. 打开设置 → TMDB 配置
2. 点击"默认数据源"选项
3. 选择启动时默认使用的数据源（Bangumi 或 TMDB）
4. 下次启动应用时将自动使用选中的数据源

## 使用方式

### 首页切换数据源

1. 打开应用首页
2. 在顶部标签选择器下方看到 SegmentedButton
3. 点击"Bangumi"或"TMDB"切换数据源
4. 内容列表自动刷新

### 搜索时切换数据源

1. 打开搜索页面
2. 在搜索框上方看到数据源切换按钮
3. 选择需要的数据源
4. 输入关键词进行搜索

### 使用 TMDB 标签

TMDB 数据源提供以下标签：
- **Popular** - 热门动漫
- **Top Rated** - 评分最高
- **On The Air** - 正在播出
- **Anime** - 动漫分类
- 其他分类标签

## 注意事项

1. **API Key 安全**
   - API Key 保存在本地，不会上传
   - 不要在公开场合分享您的 API Key
   - 如怀疑泄露，可在 TMDB 官网重置

2. **速率限制**
   - TMDB API 有请求频率限制（约 40 请求/10 秒）
   - 避免频繁切换数据源
   - 如遇 429 错误，请稍后再试

3. **数据差异**
   - TMDB 以英文为主，部分番剧中文名称可能缺失
   - Bangumi 更专注于日本动漫
   - 两个数据源的评分和分类体系不同

4. **网络要求**
   - 需要能访问 TMDB API（https://api.themoviedb.org）
   - 如网络受限，请配置代理后使用

## 故障排查

### TMDB 无法加载

1. 检查 API Key 是否正确
2. 验证网络连接
3. 检查是否能访问 TMDB 网站
4. 尝试重新验证 API Key

### 搜索无结果

1. 确认当前数据源
2. 尝试切换回 Bangumi 搜索
3. 检查搜索关键词
4. TMDB 可能对某些关键词支持不佳

### 评分显示异常

- TMDB 评分范围 0-10
- Bangumi 评分范围 0-100（显示时可能不同）
- 已做转换处理，但可能存在差异

## 技术实现

### 文件结构

```
lib/
├── modules/bangumi/
│   ├── data_source_type.dart         # 数据源枚举
│   └── tmdb_item.dart                # TMDB 数据模型
├── request/
│   ├── clients/
│   │   └── tmdb_client.dart          # TMDB HTTP 客户端
│   ├── apis/
│   │   └── tmdb_api.dart             # TMDB API 服务
│   └── config/
│       └── api_endpoints.dart        # API 端点配置（已更新）
├── services/data_source/
│   └── data_source_resolver_pool.dart # 数据源解析器池
├── pages/
│   ├── popular/
│   │   ├── popular_controller.dart   # 首页控制器（已更新）
│   │   └── popular_page.dart         # 首页 UI（已更新）
│   ├── search/
│   │   ├── search_controller.dart    # 搜索控制器（已更新）
│   │   └── search_page.dart          # 搜索页面（已更新）
│   └── settings/
│       └── tmdb_settings.dart        # TMDB 设置页面
└── utils/
    └── constants.dart                # 常量定义（已更新）
```

### 核心组件

1. **DataSourceType** - 数据源枚举类型
2. **TMDBItem** - TMDB 数据模型，支持转换为 BangumiItem
3. **TMDBClient** - 封装 Dio 的 HTTP 客户端
4. **TMDBApi** - TMDB API 服务层
5. **DataSourceResolverPool** - 数据源路由和分发

### 数据转换

TMDB 数据通过 `toBangumiItem()` 方法转换为应用统一的 BangumiItem 格式，确保 UI 组件兼容：
- 字段映射（标题、简介、评分等）
- 图片 URL 转换
- 日期和星期转换
- 类型标签转换

## 未来计划

- [ ] TMDB 番剧详情页面
- [ ] TMDB 剧集信息
- [ ] 更多 TMDB 分类筛选
- [ ] 数据源混合推荐
- [ ] 观看历史跨数据源同步
- [ ] 追番列表跨数据源支持

## 参考资料

- [TMDB API 文档](https://developer.themoviedb.org/reference/intro/getting-started)
- [TMDB 图片指南](https://developer.themoviedb.org/docs/image-basics)
- [Bangumi API 文档](https://github.com/bangumi/api)
