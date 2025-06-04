#import "/typ/templates/blog.typ": main, note, tip, important, warning, caution, image
#show: main.with(
title: [珂朵莉树 ODT],
desc: [],
date: "2025-06-03",
tags: ("ODT",),
category: "数据结构",
draft: false,
)
= 珂朵莉树

珂朵莉树是一种用于维护*区间修改、区间查询*的数据结构，在随机数据下表现良好。事实上它并不是一种单独的数据结构，而是借用 set/map/链表 进行一些暴力维护，下面给出一种使用 map 的实现方法。

#tip[
  *珂朵莉树维护一些什么信息？*

  主要维护连续段，例如我们可以开一个结构体，内有三个参数 `l,r,val`，表示序列 $[l,r]$ 的值为 $"val"$。不难发现如果连续段越少，这个数据结构的复杂度越优，因为我们可以用一整个连续段维护整个区间，具体的复杂度分析待讲完各种操作后再进行说明。
]

== map 的用途

我们可以创建一个 ```cpp map<int,int>M```，key 对应着这个连续段的左端点，而 value 对应这个序列的值。那右端点呢？我们只需要找到下一个左端点是多少，$-1$ 即知道右端点。故我们可以这样初始化：```cpp M[1]=0,M[n+1]=0```，表示初始时整个序列的值都为 0。

== split 操作

想象一下，现在我们要在初始的序列 $[1,n]$ 中更改 $[l,r]$ 为 $x$，我们可以先把 $[1,n]$ 划分成 $[1,l-1],[l,r],[r+1,n]$，然后再把 $[l,r]$ 的 value 更改为 $x$。split 操作便是来解决划分这个问题的。具体而言，现在 $t in [l,r]$，则通过 split 操作，我们可以将 $[l,r]$ 划分为 $[l,t],[t+1,r]$

只需要找到 $"key"<=t$ 的第一个元素 $a$，在 map 中新建一个 key 为 $l$ ，value 为 `a.value` 的元素即可。

```cpp
auto split(int t){
  auto it=prev(M.upper_bound(t));
  return M.insert(it,{t,it->second});
}
```

该函数的返回值为新建元素的迭代器。

#tip[
  这里的 `M.insert()` 传入了两个参数，第一个参数为*提示迭代器*，若插入的元素的 key 刚好大于等于提示迭代器所对应元素的 key，即设提示迭代器为 $a$，插入元素的 key 为 $k$，有\ `(a->first)<=k<=(next(a)->first)`，则插入复杂度为 $cal(O)(1)$，可以减少一些常数。
]

== assign 操作

我们已经完成了 split 操作，接下来我们需要删除原 $[l,r]$ 中的元素，并将这一整个区间的 `val` 修改为 $x$。

```cpp
void assign(int l,int r,int x){
  split(r+1);
  auto it=split(l);
  it->second=x;
  while(it->first!=r+1){
    it=M.erase(it);
  }
  return;
}
```

#tip[
  `map.erase()` 返回的值为删除元素后一个元素的迭代器。
]

== perform 操作

实质是在对区间进行题目要求的操作，如希望求区间和，我们可以类似 assign 操作这样完成：

```cpp
auto perform(int l,int r){
  split(r+1);
  auto it=split(l);
  int res=0;
  while(it->first!=r+1){
    res+=(next(it)->first-it->first)*it->second;
    it++;
  }
  return res;
}
```

= 复杂度分析

设共有 $cal(O)(n)$ 次操作，若在 perform 操作后立刻 assign，则显然区间只会在 split 时最多增加 2。而被 perform 遍历后的区间会立马被删除，即每个区间最多被遍历一遍。所以实际上只有 `map` 的复杂度，即总复杂度 $<=cal(O)(n log n)$（因为最大区间个数不一定为 $n$，有可能更小）。

若不立刻 assign，在数据随机情况下复杂度为 $cal(O)(n log log n)$，否则可能高达 $cal(O)(n^2 log n)$。