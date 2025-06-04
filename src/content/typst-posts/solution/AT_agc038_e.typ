#import "/typ/templates/blog.typ": main, note, tip, important, warning, caution, image

#show: main.with(
  title: "AT_agc038_e 题解",
  //desc: "", 
  date: "2025-06-03",
  tags: ("容斥原理","期望", "动态规划"),
  category: "题解",
  draft: false,
)

= AT_agc038_e 题解

#link("https://www.luogu.com.cn/problem/AT_agc038_e")[题目链接（洛谷）]

容斥好题，考察了 min-max 容斥，期望的线性性，dp状态的设计。

不妨假设第 $i$ 个元素在第 $t_i$ 时刻出现了 $B_i$ 次，设 $t_i in S$，则我们想要求的即为 $max(S)$ 的期望。

可以套用 min-max 在期望意义下的容斥公式，即
$ EE(max(S))=sum_(T subset.eq S,T != emptyset) (-1)^(|T|+1) EE(min(T)) $
那么我们的任务就变为要如何求出 $EE(min(T))$。

考虑对于某个样本 $T$，若假设无论如何一定选择在 $T$ 内，在到达 $T$ 的过程当中有若干中间过程 ${c_i},forall c_i<B_i$。如 $T={2,5,6}$，则 ${c_i}={1,3,4}$ 为一种合法的中间状态。不妨设中间状态为 $G$，则我们有一个结论可以解决这个问题：
$ EE(min(T))= sum_(forall c_i<B_i,t_i in T) p(G) $
即我们所求期望即为中间状态的概率和，这要怎么证明呢？

#note[
  首先，我们有
  $ min(T)=sum_(i=1)^infinity [text("第")  i  text("次选择某个位置前还未到达终止状态") ] $
  注意此时为选择前。
  
  不难发现其等价于 $sum_(i=1)^infinity [text("第")  i-1  text("次选择某个位置后未到达终止状态") ]$ 。

  那么给等式两边同时加上期望，即
  $ EE(min(T))&=sum_(i=1)^infinity EE([text("第")  i-1  text("次选择某个位置后未到达终止状态") ])\
  &=sum_(i=1)^infinity 1 times p([text("第")  i-1  text("次选择某个位置后未到达终止状态") ])\
  &=sum_(i=1)^infinity  p([text("第")  i-1  text("次选择某个位置后未到达终止状态") ])\
  &=sum_(forall c_i<B_i) p(G) $
]
接下来我们思考如何求出 $p(G)$。假如此时 $G={c_i}$。将 $G$ 视为一个多重集，元素 $C_i$ 有 $c_i$ 个，则到达该状态的路径数为多重集的排列数，即 $ (sum c_i)!/(product (c_i !)) $
而通过任意一条路径的概率即为路径序列上各点的概率乘积，由乘法交换律，知其为 $ ((A_i)/(sum_(t_x in T) A_x))^(c_i) $
那么到达状态的概率即为路径条数乘以每条路径的概率，即


$ p(G)=(sum c_i)!/(product (c_i !)) times product_(t_i in T) ((A_i)/(sum_(t_x in T) A_x))^(c_i),c_i in G $

则在我们的假设条件下（所有选择均选择在 $T$ 内），有

$ EE(min(T))&=sum_(G text("为中间状态")) p(G)\
&=sum_(G text("为中间状态"),c_i in G) ((sum c_i)!/(product (c_i !)) times product_(t_i in T) ((A_i)/(sum_(t_x in T) A_x))^(c_i)) $

当然，我们的所有选择并不会全在 $T$ 内，单次选择在 $T$ 内的概率为 $display((sum_(A_x in T) A_x)/(sum_(A_i in S) A_i))$，设 $s=sum_(A_i in S) A_i$，则选择到 $T$ 的期望次数为 $display(s/(sum_(A_x in T) A_x))$。

所以在没有限制条件的情况下

$ EE(min(T))=s/(sum_(A_x in T) A_x) times sum_(G text("为中间状态"),c_i in G) ((sum c_i)!/(product (c_i !)) times product_(t_i in T) ((A_i)/(sum_(t_x in T) A_i))^(c_i)) $

带入 min-max 容斥公式，提出无关变量，有

$ EE(max(S))&=sum_(T subset.eq S,T != emptyset) (-1)^(|T|+1) s/(sum_(t_x in T) A_x) times sum_(G text("为中间状态"),c_i in G) ((sum c_i)!/(product (c_i !)) times product_(t_i in T) ((A_i)/(sum_(t_x in T) A_x))^(c_i))\
&=sum_(T subset.eq S,T != emptyset) (-1)^(|T|+1) s/(sum_(t_x in T) A_x) times sum_(G text("为中间状态"),c_i in G) ((sum c_i)!/(product (c_i !)) times (product_(t_i in T)(A_i)^(c_i)) (1/(sum_(t_x in T) A_x))^(sum_(t_i in T)c_i)) $

对于这个式子而言，我们发现其做乘法的部分较多，若只是单纯的乘法，便也许可以使用 dp 进行转移。但是由于其中存在着多处求和部分，其中 $s$ 为定值，在剩下的求和中，$sum_(t_x in T) A_x$ 和 $sum_(t_i in T)c_i$ 在不断变化。所以我们或许可以考虑将这两个变化的量设计进入 dp 状态中。

故不妨设 `dp[i][j][k]` 表示当前枚举到第 `i` 位，$j=sum_(t_x in T) A_x$，$k=sum_(t_i in T)c_i$，则可以设
$ text("dp")_(i,j,k)=sum_(text("在该状态的限制条件下")) (-1)^(|T|+1) product ((A_i)^(c_i))/(c_i !) $

#note[
  *为什么要这样设计状态？*

  不难发现我们的状态内的值都不直接与 $i,j,k$ 有关，这是因为如果有关，那么在 dp 时要对状态中的分母等信息进行修改，这较我们上面所设计的状态而言更加难以完成。

]

转移时考虑 $t_i$ 是否在我们选出的子集 $T$ 内，若不在，则显然 `dp[i][j][k]+=dp[i-1][j][k]`。若在，则枚举 $c_i<B_i$，`dp[i][j][k]+= -(dp[i-1][j-A[i]][k-c[i]]*(pow(A[i],c[i])/fact(c[i])))`（每次集合中多增加一个数，($-1$) 的符号取反，故要加一个负号）。注意 `dp[0][0][0]=-1`（因为此时集合中无元素，参考上述状态知 $(-1)^(0+1)=-1$）。

#note[
  *时间复杂度说明*

  注意到若 $t_i$ 在集合里时，转移最多进行 $O(sum B_i)=O(n)$ 次，而不在时，时间复杂度显然为 $O(n^3)$。故总转移复杂度为 $O(n^3)$。不过若幂部分的实现不好，最终结果可能会多一个 $log$。
]

求答案时参考答案式子，枚举 $j,k$，则最终答案
`ans+=dp[n][j][k]*s/j*fact(k)*pow((1/j),k);`。
= 代码

```cpp
#include<bits/stdc++.h>
using namespace std;
#define int long long
int const MOD=998244353;
int const MAX=405;
int dp[MAX][MAX][MAX];
int a[MAX],b[MAX];
int fact[MAX],inv[MAX],finv[MAX];
int qpow(int t1,int t2){
	int res=1;
	while(t2){
		if(t2&1){
			res*=t1;
			res%=MOD;
		}
		t1=t1*t1%MOD;
		t2>>=1;
	}
	return res;
}
signed main(){
	fact[0]=1;
	for(int i=1;i<MAX;i++)fact[i]=fact[i-1]*i%MOD;
	finv[MAX-1]=qpow(fact[MAX-1],MOD-2);
	for(int i=MAX-2;i>=0;i--){
		finv[i]=finv[i+1]*(i+1)%MOD;
		if(i)inv[i]=finv[i]*fact[i-1]%MOD;
	}
	int n;
	cin>>n;
	int sa=0,sb=0;
	for(int i=1;i<=n;i++)cin>>a[i]>>b[i],sa+=a[i],sb+=b[i];
	dp[0][0][0]=-1;
	for(int i=1;i<=n;i++){
		for(int j=0;j<=sa;j++){
			for(int k=0;k<=sb;k++){
				dp[i][j][k]=dp[i-1][j][k];
				for(int l=0;l<b[i];l++){
					if(j>=a[i]&&k>=l)dp[i][j][k]-=(dp[i-1][j-a[i]][k-l]*qpow(a[i],l)%MOD*finv[l]%MOD)%MOD;
					dp[i][j][k]=(dp[i][j][k]+MOD)%MOD;
				}
			}
		}
	}
	int ans=0;
	for(int j=0;j<=sa;j++){
		for(int k=0;k<=sb;k++){
			ans+=(dp[n][j][k]*sa%MOD*inv[j]%MOD*fact[k]%MOD*qpow(inv[j],k))%MOD;
			ans%=MOD;
		}
	}
	cout<<ans;
	return 0;
}
```
