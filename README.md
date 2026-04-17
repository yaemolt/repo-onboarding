# repo-onboarding

`repo-onboarding` 是一个面向代码仓库学习场景的技能仓库，用来把任意项目整理成可持续跟进的“仓库导览工作区”。

它的核心目标不是一次性输出代码解读，而是帮助用户按层次理解项目：

- 先快速扫描仓库根目录、`README` 和顶层构建文件
- 自动初始化 `RepoOnboarding/` 学习目录
- 生成整体架构说明、学习进度和推荐阅读路径
- 在用户选择模块后，继续生成模块级学习文档
- 再逐步下钻到文件、函数或类，持续更新学习导航

## 仓库功能

- 提供 `repo-onboarding` 技能说明，定义渐进式仓库导览流程
- 提供初始化脚本，自动创建学习工作区目录与默认模板
- 提供一组 Markdown 模板，用于生成：
  - 架构总览
  - 学习进度
  - 学习路径
  - 模块概览
- 提供代理配置，方便在支持的环境中以统一入口调用该技能

## 目录结构

```text
.
├── SKILL.md
├── agents/
│   └── openai.yaml
├── scripts/
│   └── init-repo-onboarding-workspace.sh
└── templates/
    ├── architecture.md
    ├── learning-path.md
    ├── module-overview.md
    └── progress.md
```

## 工作方式

当这个技能被用于某个目标仓库时，会先确认目标仓库根目录，然后执行初始化脚本，在目标仓库下创建如下目录：

```text
<repo-root>/RepoOnboarding/
├── Architecture/
│   └── architecture.md
├── Modules/
└── Progress/
    ├── learning-path.md
    └── progress.md
```

随后按照以下节奏推进：

1. 做轻量级初扫，只看根目录、`README` 和顶层依赖文件
2. 生成总体架构文档
3. 更新学习进度和推荐阅读路径
4. 由用户选择下一个要学习的模块
5. 继续生成模块、文件、函数层面的说明文档

## 适用场景

- 新成员快速熟悉已有代码仓库
- 接手历史项目时建立结构化学习路径
- 做技术分享或内部培训时生成导览材料
- 在复杂仓库中逐层建立“从入口到细节”的认知地图

## 初始化脚本

仓库自带脚本：

```bash
scripts/init-repo-onboarding-workspace.sh <repo-root>
```

这个脚本会在目标仓库下创建 `RepoOnboarding/` 目录，并复制默认模板，避免手工搭建学习工作区。

## 总结

这个仓库本质上是一个“代码仓库教学与导览技能包”。它把一次性的仓库讲解，变成可沉淀、可追踪、可逐步深入的学习流程。
