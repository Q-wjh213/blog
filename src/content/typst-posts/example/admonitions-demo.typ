#import "/typ/templates/blog.typ": main, note, tip, important, warning, caution

#main(
  title: "Typst 警告框示例",
  desc: "演示各种警告框样式的使用方法", // 改为普通字符串
  date: "2025-06-03",
  tags: ("Demo", "Typst", "警告框"),
  category: "demo",
  draft: true,
)[

= Typst 警告框功能演示

本文档演示了与 Markdown 对应的各种警告框样式在 Typst 中的实现。

== 基本警告框类型

=== Note（注意）
#note[
  这是一个注意事项，用于突出显示用户在浏览时应该注意的信息。
]

=== Tip（提示）
#tip[
  这是一个可选的提示信息，可以帮助用户更好地使用功能。
]

=== Important（重要）
#important[
  这是用户成功使用功能所必需的关键信息。
]

=== Warning（警告）
#warning[
  这是需要用户立即关注的重要内容，可能存在潜在风险。
]

=== Caution（小心）
#caution[
  这表示某个操作可能产生的负面后果。
]

== 自定义标题

您也可以为警告框设置自定义标题：

#note(title: "自定义标题")[
  这是一个带有自定义标题的注意事项。
]

#tip(title: "专业提示")[
  使用自定义标题可以让信息更加明确和具体。
]

== 自定义图标

还可以自定义图标：

#warning(title: "系统警告", icon: "🔥")[
  这是一个使用自定义图标的警告信息。
]

#important(title: "必读", icon: "📖")[
  重要的使用说明，请仔细阅读。
]

== 复杂内容

警告框可以包含复杂的内容，如列表、代码等：

#tip(title: "使用方法")[
  要使用这些警告框函数，请按照以下步骤：

  1. 导入模板文件
  2. 选择合适的警告框类型
  3. 添加内容和可选的标题、图标

  示例代码：
  ```typst
  #note[这是一个简单的注意事项]
  #tip(title: "自定义标题")[提示内容]
  ```
]

]