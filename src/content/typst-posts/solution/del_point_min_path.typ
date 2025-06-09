#import "/typ/templates/blog.typ": main, note, tip, important, warning, caution, image
#show: main.with(
title: [删点最短路 题解],
desc: [],
date: "2025-06-09",
tags: ("分治","最短路"),
category: "题解",
draft: false,
)

#note[
  *题目大意：*

  给定 $n$ 的点的完全图，每条边有边权 $w_(i,j)$，有 $q$ 组询问，每次询问删去点 $x$ 后 $u->v$ 的最短路。 

  $1<=n<=200,1<=q,w_(i,j)<=10^5$
]

这道题虽然 $cal(O)(n^4)$ 可以卡过，不过有没有时间复杂度更优的做法？

我们先看 $cal(O)(n^4)$ 是怎么实现的。在进行 Floyd 的过程中，我们对最外层的定义是*经过第 $k$ 个点的最短路*。所以我们只需要在做 Floyd 时最外层跳过我们想删去的点后，即可求出答案。

在 Floyd 的过程当中，发现我们有时重复求了很多东西。比如求删去 $n$ 和删去 $n-1$ 时，我们的 Floyd 要重复把 $1 ~ n-2$ 不删的部分求两遍。考虑把它压缩到一遍，不过发现这样并没有使得复杂度减小，只是少了个常数而已。

当时我还想了下能不能处理前后缀的 Floyd，但是发现合并是困难的。

那这个问题的最优解决方案是什么？分治。

考虑分治时在当前区间 $[l,r]$，中点为 $m$，则假如我们要向 $[l,m]$ 递归，我们可以先记录此时的 Floyd 数组，然后对 $[m+1,r]$ 做选择 $[m+1,r]$ 的 Floyd，接下来向 $[l,m]$ 递归。递归结束后还原 Floyd 数组，再做选择 $[l,m]$ 的 Floyd，向右区间递归。发现这样做在每一层，会做一遍完整的 Floyd，一共有 $log(n)$ 层，故最终复杂度为 $cal(O)(n^3 log n)$。

```cpp
#include<bits/stdc++.h>
using namespace std;
int const MAX=205,INF=0x3f3f3f3f;
using ar=array<array<int,MAX>,MAX>;
ar c;
ar a[MAX];
int n,m,q;
void solve(int l,int r){
    if(l==r){ a[l]=c;return; }
    int mid=(l+r)/2;
    ar lst=c;
    for(int k=mid+1;k<=r;k++){
        for(int i=1;i<=n;i++){
            for(int j=1;j<=n;j++){
                c[i][j]=min(c[i][j],c[i][k]+c[k][j]);
            }
        }
    }
    solve(l,mid);
    c=lst;
    for(int k=1;k<=mid;k++){
        for(int i=1;i<=n;i++){
            for(int j=1;j<=n;j++){
                c[i][j]=min(c[i][j],c[i][k]+c[k][j]);
            }
        }
    }
    solve(mid+1,r);
    return;
}
signed main(){
    freopen("friend.in","r",stdin);
    freopen("friend.out","w",stdout);
    ios::sync_with_stdio(false);
    cin.tie(nullptr);
    cout.tie(nullptr);
    cin>>n>>m>>q;
    for(auto &it:c)it.fill(INF);
    for(int i=1;i<=m;i++){
        int u,v,w;cin>>u>>v>>w;
        c[u][v]=c[v][u]=min(c[u][v],w);
    }
    for(int i=1;i<=n;i++)c[i][i]=0;
    solve(1,n);
    for(int i=1;i<=q;i++){
        int x,u,v;cin>>x>>u>>v;
        cout<<(a[x][u][v]>=INF?-1:a[x][u][v])<<"\n";
    }
    return 0;
}
```