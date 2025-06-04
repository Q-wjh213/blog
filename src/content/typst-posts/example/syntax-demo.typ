#import "/typ/templates/blog.typ": main, note, tip, important, warning, caution

// 演示：admonitions-demo.typ 使用字符串语法，test.typ 使用内容块语法
#main(
  title: [语法兼容性测试],
  desc: [这个文件使用内容块语法 `[内容]` 来定义描述], // 内容块语法
  date: "2025-06-03",
  tags: ("Demo", "Syntax", "兼容性"),
  category: "demo",
  draft: true,
)[

= 双语法支持演示

现在 Typst 博客模板同时支持两种 `desc` 字段语法：

== 字符串语法
```typst
desc: "这是字符串语法"
```

== 内容块语法  
```typst
desc: [这是内容块语法]
```

两种语法都会被正确处理并显示在首页预览中。

#tip[
  推荐使用内容块语法 `[内容]`，因为它更符合 Typst 的设计理念，并且支持更丰富的格式化选项。
]

#note[
  字符串语法 `"内容"` 更简洁，适合简单的描述文本。
]

]