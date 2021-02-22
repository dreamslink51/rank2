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

### Linear mixed integer programming assumption / constrains:
- Average Coin-in for a given slot in a given casino is fixed
- For a casino, the total number of slots is conserved (remains the same)
- We allow a tolerance of +/-10% of the original number of machines. This can be tailored to each machine type. 

