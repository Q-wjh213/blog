#import "/typ/templates/blog.typ": main, note, tip, important, warning, caution, image
#show: main.with(
title: [C++ 算法竞赛中好用的函数],
desc: [],
date: "2025-06-06",
tags: ("cpp","语法糖"),
category: "其它",
draft: true,
)

+ 归并排序

  `inplace_merge` 函数可以在 $O(n)$ 的时间内将两个有序数组合并成一个有序数组。它的使用方法如下：
  ```cpp
  inplace_merge(begin,middle,end,cmp);
  ```
  将 `[begin,middle)` 和 `[middle,end)` 进行归并排序，使用 `cmp` 作为比较函数。归并后存入 `begin`。(要保证 `[begin,middle)` 和 `[middle,end)` 已经是有序的)

+ 求前缀和

  `partial_sum` 函数可以在 $O(n)$ 的时间内求出前缀和。它的使用方法如下：
  ```cpp
  partial_sum(begin,end,out,op);
  ```
  将 `[begin,end)` 的前缀和存入 `out`，使用 `op` 作为操作符。(可以原地求前缀和)

+ 初始化并查集

  `iota` 函数可以在 $O(n)$ 的时间内初始化并查集。它的使用方法如下：
  ```cpp
  iota(begin,end,value);
  ```
  将 `[begin,end)` 初始化为 `value` 开始的连续整数。

+ 求序列和

  `accumulate` 函数可以在 $O(n)$ 的时间内求出序列的和。它的使用方法如下：
  ```cpp
  accumulate(begin,end,init,op);
  ```
  将 `[begin,end)` 的元素求和，初始值为 `init`，使用 `op` 作为操作符。(注意：如果和超过了 `int`，你需要在初始值中使用 `0ll` 来避免溢出 `int`)

+ 数数

  `count` 函数可以在 $O(n)$ 的时间内统计某个元素出现的次数。它的使用方法如下：
  ```cpp
  count(begin,end,value);
  ```
  将 `[begin,end)` 中等于 `value` 的元素个数返回。

// @pid 4512 
