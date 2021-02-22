# rank2
## Optimization of the casino slot floor using linear mixed integer programming


### Protocol 
#### Section 1 Data Extraction (pandas)
For each casino we:
- Establish a shared time period (e.g. 90 days) for all machines within a club where there has been no movement or replacement. 
- Calculate the average Coin-in for each machines in the time period.
- Split all the machines into categories by PlatformType.
- For each category, count the number of slots and average Coin-in.

#### Section 2 Linear mixed integer programming (R ompr package)
- Apply the linear mixed integer programming model to obtain the optimal mix of slot machines (using R)
- Predict the number-of-slots change for each categories that maximises potential revenue increase.

#### section 3 Data visulization (matplotlib.pyplot)
- Analyze and visualize the optimized slot floor 

### Linear mixed integer programming 
$$ Max \sum\limits _{i=1} ^{m} c_i * x_i$$
subject to $$ \sum\limits _{i=1} ^{m} x_i \leq M $$
$$ L_i \leq x_i \leq U_i $$ 
$$ x_i \geq>0 $$ 
$$ x_i \in Z $$
Where m = the number of slot machine category <br>
$x_i$ = the number of machines for category i, i = 1, m <br>
$c_i$= CIPUPD for category i<br>
M = the maximum number of total machines allowed on the floor<br>
$L_i$ = the minimum number of machines of category i<br>
$U_i$= the maximum number of machines of category i<br>

#### Assumption / constrains:
- Average Coin-in ($c_i$) for a given slot in a given casino is fixed
- For a casino, the total number of slots (M) is conserved (remains the same)
- We allow a tolerance of +/-10% of the original number of machines ($L_i$/$U_i$).  This can be tailored to each machine type. 

