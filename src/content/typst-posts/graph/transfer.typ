#import "/typ/templates/blog.typ": main, note, tip, important, warning, caution, image
#show: main.with(
title: [传递闭包],
desc: [],
date: "2025-06-06",
tags: ("图论","可达性"),
category: "图论",
draft: false,
)

= 传递闭包

听起来是一个很高级的东西，其实很平常，就是求出一个点在图上的的所有后继。这可以用 Floyd 简单的求出：
```cpp
for (int k = 1; k <= n; k++)
    for (int i = 1; i <= n; i++)
        for (int j = 1; j <= n; j++)
            f[i][j] |= f[i][k] & f[k][j];
```
不过这样写的话是 $cal(O)(n^3)$，如果数据范围大一点就没办法做了，但是我们可以采用 `bitset` 优化。

考虑转移方程:

$ f_(i,j)<--f_(i,j) or (f_(i,k)and f_(k,j)) $

这其实就是我们刚才讲的 Floyd。不过我们发现，其实上式和下式是等价的：

$ f_(i,j)=cases(f_(i,j) or f_(k,j) &"如果" f_(i,k) "成立",f_(i,j) &"否则") $

注意到 $f_(i,j) or f_(k,j)$ 实际上就是 ```cpp f[i]|f[k]```，故我们可采用以下代码实现：

```cpp
#include<bits/stdc++.h>
using namespace std;
int const MAX=1005;
bitset<MAX> B[MAX];
signed main(){
    int n;
    cin>>n;
    for(int i=1;i<=n;i++){
        for(int j=1;j<=n;j++){
            int tp;
            cin>>tp;
            B[i][j]=tp;
        }
    }
    for(int k=1;k<=n;k++){
        for(int i=1;i<=n;i++){
            if(B[i][k])B[i]|=B[k];
        }
    }
    for(int i=1;i<=n;i++){
        for(int j=1;j<=n;j++){
            cout<<B[i][j]<<" ";
        }
        cout<<"\n";
    }
    return 0;
}
```
时间复杂度 $cal(O)(n^3/w)$。