#import "/typ/templates/blog.typ": main, note, tip, important, warning, caution, image
#show: main.with(
title: [Shop 题解],
desc: [],
date: "2025-06-03",
tags: ("贪心","二分"),
category: "题解",
draft: false,
)
= shop


#note[
#link("https://vjudge.net/problem/HackerRank-the-imp#author=GPT_zh")[原题]

== 题目描述
小 A 来到了一个商店，商店内有 $n$ 件物品，每件物品有一个售价 $A_i$，小 A 是一个奸商，因此他能够把每件物品以 $B_i$ 的价格卖出。

而由于小 A 背包空间有限，他只能买走恰好一件商品。而小 A 每次购买之后，小 B 将有可能将小 A 的物品摧毁，此时小 A 必须继续购买，并且商店不会返还购买这件物品的钱。小 B 至多可以摧毁 $m$ 件物品。

小 A 的目标是最大化自己的收益。

小 B 的目标是最小化小 A 获得的收益，即卖出的商品所得减去购买所有物品的总花费。

注意到任何时刻小 B 都可以选择不将小 A 手中的物品摧毁，这样小 A 就必须立刻带着这件物品离开商店。

== 输入格式

第一行一个正整数 $T$，表示数据组数。

对于每组数据：

第一行两个正整数 $n,m$，分别表示物品数目和小 B 可摧毁的物品数量。

接下来 $n$ 行，每行两个正整数 $A_i,B_i$，表示第 $i$ 件物品的售价和小 A 能卖出的价格。

== 输出格式
对于每组数据，一行一个整数表示小 A 最终能获得的最大收益。由于小 A 可以直接走出商店（什么都不买），这个收益显然是非负的。

== 数据范围

$1<=n<=10^5$，$0<=m<=n-1$，$sum n <=3 times 10^5$，$1<=A_i,B_i<=10^18$。
]

这个问题看起来就很难以下手，因为它涉及到了两个人都要以最优策略进行，我们思考是否能对它进行转化，以方便我们进行处理。

而以下便是一种合理的转化方案：

设 $p$ 为一个 $1 ~ n$ 的排列，小 A 需要找到最优的 $p$，使 $min_(i=1)^m {B_p_i - sum_(j=1)^i A_p_i}$ 最大。

这个东西仍然不好处理，我们似乎很难设计一个状态去达到这道题所要求的最优化状态。不过，有的时候如果最优化问题比较复杂，我们可以考虑一下是否能把它转为可行性问题来分析。尝试二分一个答案 $"mid"$，则我们需要判断 $"mid"$ 是否可达，实际上，也就是要求在最优 $p$ 下，有

$ B_p_i-sum_(j=1)^i A_p_i>="mid",forall i in NN sect [1,m] $

不过就算如此，这个 $p$ 还是很讨厌，研究我们是否有去掉 $p$ 的方法。经过一些思考，我们可以得出关于 $p$ 的一个结论：

$ B_p_i<=B_p_(i+1),forall i in NN sect [1,m) $

我们可以通过反证法来证明这一结论，若 $B_p_i>B_p_(i+1)$，设 $sum_(j=1)^i=S$，则我们求出的价值应为

$ min(B_p_i-S,B_p_(i+1)-S-A_p_(i+1))=B_p_(i+1)-S-A_p_(i+1) $

若交换 $p_i,p_(i+1)$，价值变为

$ min(B_p_(i+1)-S+A_p_i-A_p_(i+1),B_p_i-S-A_(p_(i+1))) $

显然新价值无论如何都比旧价值大，通过简单的比较就可以得出，故无论如何，均有 $B_p_i arrow.tr$。

所以我们先将商品按照从小到大排序，然后考虑顺着选择 $p_i$，使 $forall i in [1,m),p_(i+1)>p_i$。我们可以设 $f_(a,b)$ 表示我们当前考虑到第 $a$ 个物品，选了 $b$ 个物品，且保证 $forall j<=b,B_q_j-sum_(k=1)^j A_q_k >= "mid"$ 下，最小的 $sum_(k=1)^b A_q_k$。

将状态全部初始化为 $infinity$，令 $f_(0,0)=0$，则转移

$ f_(a,b)=cases(f_(a-1,b),
min(f_(a-1,b),f_(a-1,b-1)+A_a) "当" B_a-A_a-f_(a-1,b-1)>= "mid 时") $

时间复杂度 $cal(O)(n m log V)$，仍然无法通过。

如果再多思考一点，会发现它其实满足贪心的性质：假如我已知前 $a-1$ 个物品中最多可以选 $b-1$ 个满足 $forall j<=b-1,B_q_j-sum_(k=1)^j A_q_k >= "mid"$，且使 $sum_(k=1)^(b-1) A_q_k$ 最小，那么我们若能选第 $a$ 个，必然满足 $B_a-A_a-sum_(k=1)^(b-1) A_q_k>="mid"$ 才可以。所以若可以选，我们则选。若不可以选，那么当 $A_a<max_(i=1)^(b-1)(A_q_i)$ 时，我们不妨交换最大值与 $A_a$，因为这样能使 $sum_(k=1)^(b-1) A_q_k$ 最小，而且可以说明这样做可行性不会被破坏，用堆维护即可。

时间复杂度 $cal(O)(n log V)$。

= 代码

```cpp
#include<bits/stdc++.h>
using namespace std;
#define int long long
#define pr pair<int,int>
#define fi first
#define se second
int n,m;
int const MAX=1e5+10;
pr a[MAX];
bool check(__int128 val){
    __int128 res=0;
    int cnt=0;
    priority_queue<int> Q;
    for(int i=1;i<=n;i++){
        if(a[i].se-a[i].fi-res>=val){
            res+=a[i].fi;
            cnt++;
            Q.push(a[i].fi);
        }else{
            if(!Q.empty()&&Q.top()>a[i].fi){
                res-=Q.top();
                res+=a[i].fi;
                Q.pop();
                Q.push(a[i].fi);
            }
        }
    }
    return cnt>m;
}
void solve(){
    cin>>n>>m;
    for(int i=1;i<=n;i++)cin>>a[i].fi>>a[i].se;
    sort(a+1,a+n+1,[](pr t1,pr t2){return t1.se<t2.se;});
    __int128 ans=0,l=0,r=1e18+1;
    while(l<=r){
        __int128 mid=(l+r)/2;
        if(check(mid)){
            ans=mid;
            l=mid+1;
        }else r=mid-1;
    }
    cout<<(long long)ans<<"\n";
}
signed main(){
    freopen("shop.in","r",stdin);
    freopen("shop.out","w",stdout);
    int T;
    cin>>T;
    while(T--)solve();
    return 0;
}
```

