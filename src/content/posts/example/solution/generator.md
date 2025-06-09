---
title: "Generator 题解"
published: 2025-06-09
tags: [分治,cdq 分治,整体二分]
category: '题解'
draft: false
---
:::note

对于一个初始为 $0$ 的长度为 $n$ 的数列，有 $q$ 次操作：

- `1 l r d`：将区间 $[l,r]$ 内的所有元素加上 $d$。
- `2 l r`：查询区间 $[l,r]$ 的元素和。

一组数据最后的答案为所有查询操作的结果求和。

现在小 D 已经造好了一组数据 $D_q$，这组数据中有 $q$ 次操作。对于数据 $D_i$，他会在其中删去某一个操作，得到数据 $D_{i - 1}$。不难发现这样会产生 $q$ 组数据，数据 $D_i$ 中有 $i$ 次操作。而所有数据中的 $n$ 都是相同的。

给出每次删去的操作在数据 $D_q$ 中的编号 $P_i$，你需要对 $i \in [1, q]$，求出数据 $D_i$ 的答案。 

## 输入格式

- 第一行：$n$, $q$  
- 第二行：$P_2, P_3, \dots, P_q$（共 $q-1$ 个数，表示删除顺序）  
- 接下来 $q$ 行：操作序列 $D_q$  

## 输出格式

输出 $q$ 行，第 $i$ 行表示 $D_i$ 的答案。

## 样例输入

```plaintext
3 4
4 3 2
1 1 2 4
2 1 2
1 1 3 5
2 2 3
```

## 样例输出

```plaintext
0
4
14
22
```

## 数据范围

- $1 \leq n, q \leq 2 \times 10^5$  
- $1 \leq P_i \leq q$，$P_i$ 互不相同  
- $1 \leq l \leq r \leq n$  
- $0 \leq d \leq 10^3$  

:::

首先为了方便起见，我们可以把删除操作转化为添加操作。这样题意被转化为了：**有若干个操作，每一个操作有一个添加顺序 $t_i$ 和执行顺序 $s_i$，我们按照从小到大的添加顺序添加每一个操作后，输出按照从小到大的执行顺序执行被添加了的所有操作后，所有查询操作答案的总和。**

我们肯定不可能每次添加一个新操作后都重新按照执行顺序执行所有操作，所以考虑我们如何算出添加一个新操作后新产生的贡献。我们分为两种情况考虑这个问题，设此时操作的添加顺序和执行顺序分别为 $t,s$：

- 当添加 **区间加操作** 时，其可能会对 $t_i<t,s_i>s$ 的 **区间查询** 产生贡献。

- 当添加 **区间查询操作** 时，$t_i<t,s_i<s$ 的 **区间加操作** 可能对该操作产生贡献。

这个东西看着就很像二维偏序，只不过这个东西涉及到在时间轴上的某个时间点进行一些区间操作，不方便用数据结构简单维护。但是在处理偏序问题上，我们还有另一种常见的算法：**分治**。这里提供提供两种分治思想。

- **cdq分治**：考虑对 $t_i$ 进行分治，分治结束后对两侧按照 $s_i$ 排序，然后正反扫两遍分别计算两种操作的贡献。

- **类似整体二分的思想**：在刚开始先按照 $s_i$ 排序，然后整体二分 $t$，假如现在二分到了 $mid$，那么扫两遍，统计 $t_i \leq mid$ 的点对 $t_i > mid$ 的点产生的贡献，然后再向下继续二分。

其实这两种似乎是本质一致的，不过我完成的是第二种。

在扫的途中这样来统计贡献：

- 考虑 **区间查询操作**，按照 $s_i$ 正着扫，正常执行区间加和区间查询操作即可。

- 考虑 **区间加操作**，按照 $s_i$ 反着扫，遇到 **区间查询操作** 时对对应区间执行区间加 $1$，遇到 **区间加操作** 的贡献即为这个区间的权值乘上区间加操作要加的值。

线段树清空可以反着做或者使用懒标记，其实只需要一颗线段树就行。

```cpp
#include<bits/stdc++.h>
using namespace std;
#define int long long
int const MAX=2e5+10;
int id[MAX],ans[MAX],n,q;
struct ask{
    int op,l,r,val,id,tmp=0;
    ask(int op,int l,int r,int val,int id):op(op),l(l),r(r),val(val),id(id){};
    ask(int op,int l,int r,int id):op(op),l(l),r(r),val(0),id(id){};
    ask(){};
};
ask a[MAX];
struct tree{
    int T[MAX*4],tag[MAX*4],tim[MAX*4],cnt=0;
    void init(){
        cnt++;
    }
    bool inrange(int l,int r,int ll,int rr){return l<=ll&&rr<=r;}
    bool outrange(int l,int r,int ll,int rr){return r<ll||rr<l;}
    void check(int id){
        if(tim[id]<cnt)tim[id]=cnt,T[id]=tag[id]=0;
        return;
    }
    void pushup(int id){check(id<<1),check(id<<1|1),T[id]=T[id<<1]+T[id<<1|1],tim[id]=cnt;}
    void maketag(int id,int val,int l,int r){
        if(tim[id]<cnt)tim[id]=cnt,T[id]=tag[id]=0;
        T[id]+=val*(r-l+1),tag[id]+=val;
    }
    void pushdown(int id,int l,int r){
        int mid=(l+r)/2;
        if(tim[id]<cnt)tim[id]=cnt,T[id]=tag[id]=0;
        if(tag[id]){
            maketag(id<<1,tag[id],l,mid);
            maketag(id<<1|1,tag[id],mid+1,r);
            tag[id]=0;
        }
    }
    int get(int id){
        if(tim[id]<cnt)tim[id]=cnt,T[id]=tag[id]=0;
        return T[id];
    }
    void add(int l,int r,int val,int ind=1,int ll=1,int rr=n){
        if(inrange(l,r,ll,rr)){
            maketag(ind,val,ll,rr);
            return;
        }else if(outrange(l,r,ll,rr))return;
        int mid=(ll+rr)>>1;
        pushdown(ind,ll,rr);
        add(l,r,val,ind<<1,ll,mid);
        add(l,r,val,ind<<1|1,mid+1,rr);
        pushup(ind);
        return;
    }
    int find(int l,int r,int ind=1,int ll=1,int rr=n){
        if(inrange(l,r,ll,rr))return get(ind);
        else if(outrange(l,r,ll,rr))return 0;
        int mid=(ll+rr)>>1;
        pushdown(ind,ll,rr);
        return find(l,r,ind<<1,ll,mid)+find(l,r,ind<<1|1,mid+1,rr);
    }
}T1,T2;
vector<ask> L,R;
void solve(int ll,int rr,int l,int r){
    if(ll>rr||l>r)return;
    if(l==r){
        for(int i=ll;i<=rr;i++){
            //cerr<<"ans:"<<ll<<" "<<rr<<" "<<l<<" "<<r<<" "<<a[i].id<<" "<<a[i].tmp<<"\n";
            ans[a[i].id]=a[i].tmp;
        }
        return;
    }
    int mid=(l+r)/2;L.clear(),R.clear(),T1.init(),T2.init();
    //cerr<<" "<<ll<<" "<<rr<<" "<<l<<" "<<r<<" "<<mid<<"\n";
    for(int i=ll;i<=rr;i++){
        if(a[i].id<=mid){
            if(a[i].op==1){
                //cerr<<a[i].id<<" "<<a[i].op<<" "<<a[i].l<<" "<<a[i].r<<" "<<a[i].val<<"\n";
                T1.add(a[i].l,a[i].r,a[i].val);
            }
        }else{
            if(a[i].op==2){
                //cerr<<a[i].id<<" "<<a[i].op<<" "<<a[i].l<<" "<<a[i].r<<"\n";
                a[i].tmp+=T1.find(a[i].l,a[i].r);
            }
        }
    }
    for(int i=rr;i>=ll;i--){
        if(a[i].id<=mid){
            if(a[i].op==2){
                //cerr<<a[i].id<<" "<<a[i].l<<" "<<a[i].r<<"\n";
                T2.add(a[i].l,a[i].r,1);
            }
        }else{
            if(a[i].op==1){
                //cerr<<a[i].id<<" "<<a[i].l<<" "<<a[i].r<<" "<<a[i].val<<" "<<T2.find(a[i].l,a[i].r)<<"\n";
                a[i].tmp+=T2.find(a[i].l,a[i].r)*a[i].val;
            }
        }
    }
    for(int i=ll;i<=rr;i++){
        if(a[i].id<=mid){
            L.push_back(a[i]);
        }else{
            R.push_back(a[i]);
        }
    }
    int ct=ll-1;
    for(auto it:L)a[++ct]=it;
    int ct2=ct;
    for(auto it:R)a[++ct2]=it;
    solve(ll,ct,l,mid);
    solve(ct+1,rr,mid+1,r);
    return;
}
signed main(){
    freopen("generator.in","r",stdin);
    freopen("generator.out","w",stdout);
    ios::sync_with_stdio(0),cin.tie(0),cout.tie(0);
    cin>>n>>q;
    for(int i=2;i<=q;i++){int x;cin>>x,id[x]=i;}
    for(int i=1;i<=q;i++)if(!id[i])id[i]=1;
    for(int i=1;i<=q;i++){
        int op,l,r; cin>>op>>l>>r;
        if(op==1){
            int x;cin>>x;
            a[i]=ask(op,l,r,x,id[i]);
        }else{
            a[i]=ask(op,l,r,id[i]);
        }
    }
    solve(1,q,1,q);
    partial_sum(ans+1,ans+q+1,ans+1);
    for(int i=1;i<=q;i++)cout<<ans[i]<<"\n";
    return 0;
}
```