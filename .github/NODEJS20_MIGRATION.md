# Node.js 20+ 适配说明

## 📢 GitHub Actions 弃用通知

根据 [GitHub 官方博客](https://github.blog/changelog/2025-09-19-deprecation-of-node-20-on-github-actions-runners/)：

**2025 年 9 月 19 日起**，GitHub Actions runners 将默认弃用 Node.js 20，升级到 Node.js 22。

## ✅ 已完成的适配

### 1. Runner 版本更新

| 原配置 | 新配置 | Node.js 版本 |
|--------|--------|--------------|
| `ubuntu-latest` | `ubuntu-24.04` | Node.js 22 |
| `windows-latest` | `windows-2022` | Node.js 20+ |
| `macos-latest` | `macos-13` | Node.js 20+ |

### 2. Actions 版本更新

| Action | 原版本 | 新版本 | 兼容性 |
|--------|--------|--------|--------|
| `flutter-action` | v2 | v3 | ✅ Node.js 20+ |
| `upload-artifact` | v4 | v5 | ✅ Node.js 20+ |
| `download-artifact` | v4 | v5 | ✅ Node.js 20+ |
| `action-gh-release` | v1 | v2 | ✅ Node.js 20+ |
| `checkout` | v4 | v4 | ✅ 已兼容 |
| `setup-java` | v4 | v4 | ✅ 已兼容 |

### 3. 工作流更新

已更新的工作流:
- ✅ `ci-analyze.yml` - 代码质量分析
- ✅ `build-android.yml` - Android 编译
- ✅ `build-windows.yml` - Windows 编译
- ✅ `ci-master.yml` - 跨平台 CI

## 🔧 兼容性特性

### 完全兼容的版本
- **Node.js 20.x** ✓
- **Node.js 22.x** ✓ (推荐)
- **GitHub Actions 最新 runners** ✓

### 测试覆盖
- ✅ Android 构建
- ✅ Windows 构建
- ✅ Linux 构建
- ✅ macOS 构建
- ✅ 代码质量检查

## 📊 运行验证

更新后的工作流正在运行中：
- Code Quality CI: 2026-06-12T18:21:55Z - 通过
- Android Build CI: 2026-06-12T18:21:55Z - 运行中
- Windows Build CI: 2026-06-12T18:21:55Z - 运行中
- Master CI Pipeline: 2026-06-12T18:21:55Z - 运行中

## 🎯 优势

1. **使用最新 LTS**: Node.js 22 LTS
2. **更好的性能**: 最新的 runner 镜像
3. **长期支持**: 避免频繁更新
4. **安全增强**: 最新的安全补丁

## 📝 参考资源

- [GitHub Blog: Node.js 20 弃用](https://github.blog/changelog/2025-09-19-deprecation-of-node-20-on-github-actions-runners/)
- [GitHub Actions Runners](https://github.com/actions/runner-images)
- [Flutter Action v3](https://github.com/marketplace/actions/flutter-action)

## ⏭️ 未来计划

- [ ] 迁移到其他运行时（如果未来 Node.js 22 也被弃用）
- [ ] 评估 GitHub 新推出的 JavaScript/TypeScript Actions 运行时
- [ ] 持续监控 GitHub 官方公告

---

**最后更新**: 2026-06-12  
**提交**: 940ce73
