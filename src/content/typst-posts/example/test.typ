#import "/typ/templates/blog.typ": main, note, tip, important, warning, caution, image

#main(
  title: "Typst 博客功能测试",
  desc: "测试各种 Typst 功能", 
  date: "2025-06-03",
  tags: ("programming", "typst", "tutorial"),
  category: "test",
  draft: true,
)[

= 第一章 博客测试
这 $a+b=c$ 是第一章的内容，测试基本的 Typst 功能。

== 数学公式测试
$ a^2+b^2=c^2 $

== 列表测试
- 项目1
- 项目2  
- 项目3

== 表格测试
#table(
  align: (center, center, center),
  columns: 3,
  [1],[2],[3],
  [4],[5],[6],
  [7],[8],[9],
  [10],[11],[12],
)


== 代码测试
```cpp
#include <iostream>
using namespace std;
signed main(){
  return 0;
}
```

== 警告框测试

#note[
  这是一个注意事项，用于突出显示重要信息。
]

#tip[
  这是一个提示，为用户提供有用的建议。
]

#warning[
  这是一个警告，提醒用户注意潜在问题。
]

#important[
  这是重要信息，用户必须了解的关键内容。
]

#caution[
  这是小心提醒，避免可能的错误操作。
]

== 外部链接测试

可以访问 #link("https://baidu.com")[百度搜索] 来搜索更多信息。

== 图片测试

使用相对路径的图片：


这张图片展示了相对路径图片支持的功能。

== 总结

这个文档展示了 Typst 在博客系统中的各种功能，包括：
+ 标题层级
+ 数学公式
+ 列表和表格
+ 代码高亮
+ 警告框组件
+ 外部链接
+ 相对路径图片支持

]