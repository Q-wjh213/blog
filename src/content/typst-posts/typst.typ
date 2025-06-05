#import "/typ/templates/blog.typ": main, note, tip, important, warning, caution, image

#show: main.with(
  title: "Typst 博客功能测试",
  //desc: "测试各种Typst功能", 
  date: "2025-06-04",
  tags: ("typst",),
  category: "blog",
  draft: false,
)

= Typst 博客测试

博客基于 #link("https://github.com/saicaca/fuwari/")[fuwari] 和 #link("https://github.com/OverflowCat/astro-typst")[astro-typst] 搭建，同时使用了 #link("https://github.com/Myriad-Dreamin/tylant")[tylant] 的实现。对于 Typst 迁移实现全部使用 copilot 实现，可能存在着大量的 bug。

不过仍然只支持 Typst 的一个很小的子集。

#warning(title: "已知 bug")[
  + 暗黑模式下，提示框中的公式显示不正常。
  + 公式会重叠，目前暂时采用加大行间距解决。
  + 公式大小过大，移动端兼容性差，公式可能会超出页面边界。
]

== 公式

- 行内公式
  
  已知 $sum_(i=1)^n a_i=S$，求出 $sum_(i=1)^n a_i/3$

- 块级公式

  $ f(x)=cases(1\,x in QQ,0\,"else") $

== 列表

#table(
  columns: 4,
  [a],[b],[c],[d],
  [e],[f],[g],[h],
)

== 提示框

#note[
  这是一个提示框，内容可以是任何文本。你可以在这里添加更多信息或说明。
]
#tip[
  这是一个提示框，内容可以是任何文本。你可以在这里添加更多信息或说明。
]
#important[
  这是一个提示框，内容可以是任何文本。你可以在这里添加更多信息或说明。
]
#warning[
  这是一个提示框，内容可以是任何文本。你可以在这里添加更多信息或说明。
]
#caution[
  这是一个提示框，内容可以是任何文本。你可以在这里添加更多信息或说明。
]

== 图片

#image("/luotianyi-banner.png", alt: "洛天依横幅")

```typst
#image("/luotianyi-banner.png", alt: "洛天依横幅")
```

#note[
  图片渲染存在一些问题，比如不支持相对路径。

  在使用图床时，`typst` 的 `pdf` 文件将无法正常渲染，但是 `html` 可以，这是 typst 自身的限制。
]

== 强调

*粗体*  _斜体_

== 代码块

```cpp
#include<bits/stdc++.h>
using namespace std;
signed main(){
  int a,b;
  cin>>a>>b;
  cout<<a+b;
  return 0;
}
```

行内代码：`#include<bits/stdc++.h>`，现在不支持行内代码高亮。

剩下的功能待支持。

