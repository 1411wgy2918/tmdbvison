# GitHub Actions CI/CD 工作流配置

## 📋 工作流列表

### 1. Code Quality CI (`ci-analyze.yml`)
**代码质量分析**

触发条件:
- Push 到 master/main
- Pull Request

执行任务:
- Flutter 依赖安装
- Dart 格式检查
- 代码静态分析 (flutter analyze)
- 单元测试运行 (flutter test)

### 2. Android Build CI (`build-android.yml`)
**Android 平台编译**

触发条件:
- Push 到 master/main
- Pull Request
- 版本标签 (v*)
- 手动触发

构建产物:
- APK Debug 版本
- APK Release 版本
- AAB Google Play 包

产物保留: 7 天

自动发布:
- 当 push 版本标签 (v*) 时
- 自动创建 GitHub Release
- 附上 APK 和 AAB 文件

### 3. Windows Build CI (`build-windows.yml`)
**Windows 平台编译**

触发条件:
- Push 到 master/main
- Pull Request
- 版本标签 (v*)
- 手动触发

构建产物:
- Windows Debug 版本
- Windows Release 版本
- ZIP 压缩包

产物保留: 7 天

自动发布:
- 当 push 版本标签 (v*) 时
- 自动创建 GitHub Release
- 附带 Release 文件夹内容

### 4. Master CI Pipeline (`ci-master.yml`)
**综合跨平台 CI**

触发条件:
- Push 到 master/main
- Pull Request
- 版本标签 (v*)
- 手动触发

构建矩阵:
- Android (Ubuntu)
- Linux (Ubuntu)
- Windows (Windows)
- macOS (macOS)

执行流程:
1. 代码质量检查
2. 多平台并行构建
3. 上传所有产物

## 🎯 使用方式

### 常规开发
```bash
git push origin feature-branch
# 自动触发: Code Quality CI (仅 PR 到 master)
```

### 合并到主干
```bash
git push origin master
# 自动触发: 所有 4 个 CI 工作流
```

### 发布新版本
```bash
git tag v1.0.0
git push origin --tags
# 自动触发: 所有构建 + 自动创建 Release
```

### 手动触发
在 GitHub Actions 页面点击 "Run workflow"

## 📦 产物说明

### Android
- `android-apk-debug`: app-debug.apk
- `android-apk-release`: app-release.apk
- `android-appbundle`: app-release.aab

### Windows
- `windows-build`: Windows Release 文件夹
- `windows-release`: 打包的 ZIP 文件

### 保留策略
- 所有构建产物保留 7 天
- Release 产物永久保存

## ⚙️ 配置参数

### Flutter 版本
- 版本：3.44.1
- 渠道：stable
- 启用缓存

### Java 版本 (Android)
- 版本：17
- 发行版：temurin

### 构建环境
- Android: Ubuntu-latest
- Linux: Ubuntu-latest
- Windows: Windows-latest
- macOS: macOS-latest

## 🔧 自定义

### 添加新的构建平台
编辑 `ci-master.yml` 的 matrix 配置:

```yaml
matrix:
  include:
    - os: ubuntu-latest
      platform: ios  # 新增
```

### 修改 Flutter 版本
在所有工作流中修改:
```yaml
with:
  flutter-version: '3.45.0'  # 更新版本号
```

### 产物保留时间
```yaml
uses: actions/upload-artifact@v4
with:
  retention-days: 14  # 修改天数
```

## 📊 监控

### 查看运行状态
https://github.com/1411wgy2918/kazumi/actions

### 查看产物
在 Workflow 页面点击对应的运行 → 下载 artifacts

### 查看日志
每个步骤都有详细日志输出

## 🚨 故障排查

### 构建失败
1. 检查 Flutter 版本兼容性
2. 查看分析错误信息
3. 检查依赖是否完整

### 产物缺失
1. 检查构建路径是否正确
2. 确认构建命令执行成功
3. 查看 `if-no-files-found: ignore` 配置

### 发布失败
1. 检查 GITHUB_TOKEN 权限
2. 确认标签格式 (v*)
3. 查看 release 步骤日志

## 📝 最佳实践

1. **频繁提交前**运行 `flutter analyze` 本地检查
2. **发布版本前**手动触发所有工作流
3. **定期更新** Flutter 版本和 actions 版本
4. **审查产物**确保大小合理
5. **监控运行时间**优化构建速度

## 🔗 相关链接

- [GitHub Actions 文档](https://docs.github.com/cn/actions)
- [Flutter Action](https://github.com/marketplace/actions/flutter-action)
- [Kazumi GitHub Actions](https://github.com/1411wgy2918/kazumi/actions)

---

**最后更新**: 2026-06-12
**提交**: bff19bd
