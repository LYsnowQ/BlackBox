# 20260724-hot-progress-summary

## 背景

汇总本阶段热点（Hot）模块可交付进度，便于对接 `hotpage` 分支与协作合并。  
本阶段在 **master 模块化基线** 上完成：业务迁入 Hot HAR、顶部 Banner 真图、第一条新闻真图详情。

## 进度清单

| 项 | 状态 | 文档 |
|----|------|------|
| 热点全部 / 热榜 / 详情 Mock | 已完成 | [20260724-hot-feed-detail.md](./20260724-hot-feed-detail.md) |
| 默认浅色 + 深色调试 | 已完成 | [20260724-hot-light-theme.md](./20260724-hot-light-theme.md) |
| entry → Hot HAR 迁移 + 路由壳 | 已完成 | [20260724-hot-module-migrate.md](./20260724-hot-module-migrate.md) |
| 顶部 Banner 图1–图4 | 已完成 | [20260724-hot-banner-images.md](./20260724-hot-banner-images.md) |
| 第一条新闻「新闻1」配图与头像 | 已完成 | [20260724-hot-news1-images.md](./20260724-hot-news1-images.md) |

## 架构边界（当前）

| 层级 | 职责 |
|------|------|
| `Hot/` HAR | Tab 业务、详情业务、Mock、主题、`HotRoutes`、media 资源 |
| `entry` | `Index` 挂载 `import { Hot } from 'hot'`、详情 `@Entry` 壳、`main_pages`、`AppRoutes`、`oh-package` 依赖 |

关键路径：

- Tab：`Hot/src/main/ets/pages/Hot/Hot.ets`
- 详情业务：`Hot/src/main/ets/pages/Hot/HotNewsDetail.ets`
- 详情壳：`entry/src/main/ets/pages/Hot/HotNewsDetail.ets`
- 模型：`Hot/src/main/ets/model/HotModel.ets`
- 资源：`Hot/src/main/resources/base/media/`

## 资源一览

| 资源前缀 | 用途 |
|----------|------|
| `hot_banner_1~4.jpg` | 全部频道顶部轮播 |
| `hot_news1_img1~6` | 第一条新闻详情游戏卡封面 + 内嵌截图 |
| `hot_news1_avatar.png` | 作者「塔可松」头像 |

## 验证总览

1. `ohpm install`（entry 依赖 `hot`）
2. DevEco 编译运行
3. 热点 → 全部：Banner 四帧轮播；列表首条为 Steam 折扣文
4. 点进首条：头像 + 三组（怪猎 / 街霸6 / 生化4）游戏卡与大图；底栏 837/187/93/20
5. 热榜 / 游戏频道占位仍可用；✉️ 可切换 light/dark 调试

## 已知限制 / 后续

- 除首条与 Banner 外，其余新闻缩略图/详情图仍多为渐变占位
- 详情大图为整页截图，非可交互价格组件
- Banner / 游戏卡点击跳转未接
- 评论区 mock 未按最新截图重做
- 游戏频道（剑星 / Steam 等）仍为待开发占位

## 分支说明

本进度推送目标远端分支：`origin/hotpage`。  
实现基于当前 `master` 模块化结构，与历史 `hotpage` 旧提交可能非 fast-forward，推送时以本阶段可运行代码为准。
