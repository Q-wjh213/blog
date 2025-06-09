#import "/typ/templates/blog.typ": main, note, tip, important, warning, caution, image
#show: main.with(
title: [后缀数组 SA],
desc: [],
date: "2025-06-03",
tags: ("后缀数组",),
category: "数据结构",
draft: false,
)
= 后缀数组

后缀数组是处理字符串的有力工具，设有长为 $n$ 的字符串 $s$，则 $r k_i$ 表示字符串区间 $[i,n]$ 在所有后缀中的按字典序从小到大排序的排名。而 $s a_i$ 表示排名为 $i$ 的后缀的编号是哪一个。这两个数组显然互逆，即 ```cpp rk[sa[i]]=sa[rk[i]]=i```。借用 #link("https://oi-wiki.org/string/sa/")[OI Wiki] 的一张图来说明后缀数组。

#image("https://oi-wiki.org/string/images/sa1.png")

求后缀数组可使用 *倍增+基数排序* 在 $cal(O)(n log n)$ 的时间复杂度内完成。

= `height` 数组

`height[i]` 表示 `sa[i]` 和 `sa[i-1]` 所对应的后缀的最长公共前缀（即 LCP）。其具有以下性质：

- `height[rk[i]]` $>=$ `height[rk[i]-1]-1`

#note[
  考虑证明：

  为了方便，将把 `height` 简写为 $h$。
  
  $h_(r k_(i-1))="lcp"(s a_(r k_(i-1)),s a_(r k_(i-1) -1))="lcp"(i-1,s a_(r k_(i-1) -1))$

  $h_(r k_(i))="lcp"(s a_(r k_(i)),s a_(r k_(i) -1))="lcp"(i,s a_(r k_(i) -1))$

  当 `height[rk[i]-1]` $<=1$ 时，结论显然成立。

  否则，不妨设 $i-1$ 与 $s a_(r k_(i-1)-1)$ 的 LCP 为 $a A$（其中 $a$ 是字符，$A$ 是字符串），则 $i-1$ 可表示为 $a A B$，$s a_(r k_(i-1)-1)$ 可表示为 $a A C$，因此 $i$ 可表示为 $A B$（少了一个字符）。根据字典序的性质，我们知 后缀 $s a_(r k_(i-1)-1)+1<=$ 后缀 $i$。即 $A C<A B$。

  根据 `height` 数组定义，知 后缀 $s a_(r k_(i) -1)$ 必然在 $A C$ 和 $A B$ 之间，由字典序的排列性质知其必然至少有公共前缀 $A$，而 $A$ 的长度就为 `height[rk[i]-1]-1`。
]