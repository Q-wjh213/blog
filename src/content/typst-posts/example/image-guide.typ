#import "/typ/templates/blog.typ": main, note, tip, important, warning, caution, image

#main(
  title: "Typst 图片支持使用指南",
  desc: "如何在 Typst 博客中使用相对路径图片",
  date: "2025-06-04",
  tags: ("typst", "图片", "教程"),
  category: "tutorial",
  draft: true,
)[

= Typst 图片支持功能

本文档介绍如何在 Typst 博客系统中使用图片，特别是相对路径图片的支持功能。

== 使用方法

=== 基本语法

在 Typst 文档中，您可以使用以下语法来插入图片：

```typst
#image("图片路径", alt: "图片描述")
```

=== 支持的路径类型

==== 1. 相对路径（推荐）

将图片文件放在与 `.typ` 文件相同的目录中，然后使用相对路径引用：

```typst
#image("./my-image.png", alt: "我的图片")
```

或者子目录中的图片：

```typst
#image("./images/screenshot.jpg", alt: "截图")
```

==== 2. 绝对路径

```typst
#image("/src/assets/images/banner.png", alt: "横幅图片")
```

==== 3. 网络图片

```typst
#image("https://example.com/image.jpg", alt: "网络图片")
```

== 图片参数

`image` 函数支持以下参数：

- `src`: 图片路径（必需）
- `alt`: 图片描述（推荐，用于无障碍访问）
- `width`: 图片宽度（可选）
- `height`: 图片高度（可选）
- `class`: CSS 类名（可选）

=== 示例

#image("https://cdn.luogu.com.cn/upload/image_hosting/fvmh5y9j.png", alt: "示例图片")
```typst
// 基本用法
#image("./example.png", alt: "示例图片")
#image("https://cdn.luogu.com.cn/upload/image_hosting/fvmh5y9j.png", alt: "示例图片")

// 指定尺寸
#image("./photo.jpg", alt: "照片", width: 300, height: 200)

// 添加自定义样式类
#image("./logo.svg", alt: "Logo", class: "logo-image")
```

== 实际示例

下面是一个实际的图片示例：

#image("./luotianyi-banner.png", alt: "洛天依横幅图片")

#tip[
图片会自动适应容器宽度，并保持宽高比。在移动设备上也能很好地显示。
]

== 最佳实践

#note[
=== 文件组织建议

1. 将图片文件放在与 `.typ` 文档相同的目录中
2. 对于复杂项目，可以创建 `images/` 子目录
3. 使用有意义的文件名
4. 始终为图片添加 `alt` 属性以提高可访问性
]

#important[
=== 性能优化

- 使用适当的图片格式（PNG 用于图标，JPEG 用于照片）
- 压缩图片以减少文件大小
- 考虑使用现代格式如 WebP（如果需要）
]

== 支持的图片格式

- PNG
- JPEG/JPG  
- SVG
- WebP
- GIF

== 故障排除

如果图片无法显示，请检查：

1. 文件路径是否正确
2. 图片文件是否存在
3. 文件权限是否正确
4. 图片格式是否受支持

#caution[
确保图片文件名中没有特殊字符或空格，建议使用连字符 `-` 或下划线 `_`。
]

== 总结

通过这个图片支持功能，您可以：

- 轻松在 Typst 博客中插入图片
- 使用相对路径管理项目图片
- 获得响应式的图片显示效果
- 保持良好的可访问性

现在您可以在 Typst 博客中自由使用图片了！

]