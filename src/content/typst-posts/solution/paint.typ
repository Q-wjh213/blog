#import "/typ/templates/blog.typ": main, note, tip, important, warning, caution, image
#show: main.with(
title: [画图 题解],
desc: [],
date: "2025-06-03",
tags: ("cdq 分治",),
category: "题解",
draft: false,
)
= 画图

#note([
  == 题意
  给定 $n$ 个点，他们连接成了一个环，其中 $i$ 与 $i+1$ 连边，$1$ 与 $n$ 连边，接下来给出 $m$ 条边 $u_i,v_i$，你需要回答在连接完这 $m$ 条边后是否存在一种情况使得在平面上，边两两不交（无交点）。
  == 输入格式
  ```
  n m
  u_i v_i
  ...
  u_m v_m
  ```
  == 输出格式
  `Yes` 或 `No`，表示是否存在情况。

  == 数据范围
  $1 <= n,m <= 5 times 10^5$，$1 <= u_i,v_i <= n$。
])

不妨考虑我们如何才能保证边两两不交，发现环内环外在拓扑意义下等价。若只能在环内连边，显然只需要保证连边所对应的区间要么不相交，要么包含。在环外自然与环内类似。所以我们的问题便转化成了：*我们是否能把题目所给定的边分成两组，使得在对应组别内两两不交（这里的相交指的是部分相交，下文同理）*。

这比较类似于种类并查集的运用。我们思考，相交的边肯定不能同时选入一个集合当中，所以不妨我们设节点 $i$ 表示 $i in A$，而设节点 $i+m$ 表示 $i in B$，其中 $A,B$ 是我们要区分出的两个集合。

则若两条边相交，我们可以把他们对应的节点相连到一个连通分量中，表示若该连通分量中的一个条件满足，则剩下的条件必须全部满足。即若边 $i,j$ 有交集，我们可以连以下的两条边 $i <--> j+m,i+m <--> j$ 表示若 $i in A$，则 $j in B$，$i,j$ 交换后同理。

那我们判断能否成立，即是判断我们的选择是否存在冲突，即 $i,i+m$ 是否同时属于一个连通分量中。

不难发现这个关系可以使用并查集维护，如果我们对每条边暴力找与其相交的边，时间复杂度为 $O(n^2)$。

在建边的时候有一个重要性质：我们至多只会建 $2m-1$ 条边，所以我们在想我们能否将已经联通的块统一进行维护，将多个与同一个点连边的点进行合并（不妨设合并后的集合为 $S$），而且要支持新的边和 $S$ 中的元素在较小的时间复杂度内判断是否相交。

发现这件事情是很困难的，因为在一段线段中包含着 $l,r$，我们无法将两维都在同一个数列中排好序，那么当判断相交时我们要在集合 $S$ 中记录较多的信息，发现难以维护。

多维偏序关系通常考虑*树状数组优化/线段树优化/cdq分治*，在这篇题解中我们讲解 cdq 分治。

根据题意，若线段 $i,j$ 相交，则需要满足 $x_i<x_j<y_i<y_j$。我们不妨用分治维护 $y$，这样可以保证序列的左侧的 $max(y)$ 小于等于序列右侧的 $min(y)$。但是我们刚刚讨论的结果是只有 $y_i<y_j$ 时两条线段才可能相交，而在这里却包含了取等情况，我们希望去掉这种情况。

有一些神奇的转化可以解决这个问题，不过我们可以使用一种朴素的想法：我们将 $y$ 相同的节点合并为一个块，显然在块内不可能产生相交线段，所以我们可以对块进行cdq分治，这样对结果是无影响的，时间复杂度也不会升高。只需要用一个 `vector` 记录每一个块的最右侧节点和 1 号节点即可。后续只需要在 `vector` 上进行 cdq 分治即可。

首先我们先对 $y$ 排序。

考虑分治过程，我们保证了分界点右侧的所有 $y$ 大于左侧的所有 $y$，接下来对 $x$ 进行处理。将两侧按 $x$ 进行排序，然后在右侧扫 $x_j$ 的过程中将左侧 $x_i<x_j$ 的点进行添加。

要怎么添加？

在左侧建立一个 `set`，若 $x_i<x_j$ 则将 $y_i$ 添加入 `set` 中，然后从小到大枚举已添加的 $y_i$ 是否大于 $x_j$，若小于等于直接删除，因为 $x_(j+1)>=x_j$，$y_i$ 在之后也不可能产生贡献；若大于，则按之前所述进行连边，并且只保留最大的 $y_i$ 即可，因为从贪心的角度，保留最大的 $y_i$ 可以与尽可能多的 $j$ 连边，同时因为连通性，$y_i$ 稍小的均已与最大的连边，所以删去是无影响的。

最后并查集查询 $i$ 与 $i+m$ 是否在同一集合即可。

cdq 分治外层复杂度 $O(log n)$，内层排序+`set`复杂度 $O(n log n)$，总复杂度 $O(n log^2 n)$。

= 代码
```cpp
#include<bits/stdc++.h>
using namespace std;
#define pr pair<int,int>
#define fi first
#define se second
int const MAX=5e5+10;
int fa[2*MAX];
int find(int ind){
	return fa[ind]==ind?ind:fa[ind]=find(fa[ind]);
}
void merge(int ind1,int ind2){
	if(find(ind1)==find(ind2))return;
	fa[find(ind1)]=find(ind2);
	return;
}
int n,m;
struct node{
	int l,r,ind;
}a[MAX*2];
bool operator<(node t1,node t2){
	return t1.l==t2.l?t1.r<t2.r:t1.l<t2.l;
}
vector<int> id;
void cdq(int l,int r){
	if(l==r)return;
	if(l+1==r)return;
	int mid=(l+r)/2;
	cdq(l,mid);
	cdq(mid,r);
	int indl=id[l]+1;
	int indmid=id[mid]+1;
	sort(a+indl,a+indmid);
	sort(a+indmid,a+id[r]+1);
	vector<pr> V;
	for(int i=indmid;i<=id[r];i++){
		while(indl<=id[mid]&&a[indl].l<a[i].l){
			V.push_back({a[indl].r,a[indl].ind});
			indl++;
		}
		pr ls={0,0};
		for(auto it:V){
			if(it.fi>a[i].l){
				merge(a[i].ind,it.se+m);
				merge(a[i].ind+m,it.se);
				ls=it;
			}
		}
		V.clear();
		if(ls.fi)V.push_back(ls);
	}
	return;
}
signed main(){
	freopen("paint.in","r",stdin);
	freopen("paint.out","w",stdout);
	cin>>n>>m;
	vector<pr> tp;
	for(int i=1;i<=m;i++){
		int u,v;
		cin>>u>>v;
		if(v<u)swap(u,v);
		if(u==v)continue;
		if(v==u+1||(u==1&&v==n))continue;
		tp.push_back({u,v});
	}
	sort(tp.begin(),tp.end());
	tp.erase(unique(tp.begin(),tp.end()),tp.end());
	m=tp.size();
	for(int i=1;i<=m;i++){
		a[i]={tp[i-1].fi,tp[i-1].se,i};
	}
	for(int i=1;i<=2*m;i++)fa[i]=i;
	sort(a+1,a+m+1,[](node t1,node t2){return t1.r<t2.r;});
	id.push_back(0);
	for(int i=1;i<=m;i++){
		if(a[i].r!=a[i+1].r){
			id.push_back(i);
		}
	}
	cdq(0,id.size()-1);
	for(int i=1;i<=m;i++){
		if(find(i)==find(i+m)){
			cout<<"No";
			return 0;
		}
	}
	cout<<"Yes";
	return 0;
}
```