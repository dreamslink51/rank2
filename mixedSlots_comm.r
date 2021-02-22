#####################################################################
##        Linear programming to optimized the mixed slots          ##
##         Hui Yang, Rank Data Science group,July 2018             ##
##                                                                 ##
## This R script will read the original Number_Machines and        ##  
## Ave_MeteredCoinIn from ("MixSlots_%s.csv",my_casino) files.     ##
## And then write the Opt_Number_Machines and the revenue_increase ##
## in the ("MixSlots_%s_opt.csv",my_casino) files.                 ##
#####################################################################

##please install the packages if you do not have##

#install.packages('ompr')
#install.packages('dplyr')
#install.packages('ROI.plugin.glpk')
#install.packages('ompr.roi')
#install.packages('formattable')
library(dplyr)
library(ROI)
library(ROI.plugin.glpk)
library(ompr)
library(ompr.roi)
library(formattable)
##please remind to check your working directory and "MixSlots_%s.csv" files##
getwd()
options(stringsAsFactors = FALSE)

runAnalysis = function() {
  casinos = list('Luton', 'London Victoria','London Russell Square','London Piccadilly')
  for(i in 1:length(casinos)){
   
    my_casino = casinos[i]
    sprintf("Current working casino: %s", my_casino)
    filename<-sprintf("MixSlots_%s.csv",my_casino)
    ##please remind to check your directory ##
    df = read.csv(filename,header = TRUE)
    no=df[,2] #load original Number_Machines        
    y=df[,3]  #load Ave_CoinIn
    n=nrow(df)
    tot_slot=sum(df$Number_Machines)
    ## Tolerance is +/-10% of the original number of machines. Change is if you need##
    upperbounds =ceiling(no*1.1)
    lowerbounds =floor(no*0.9)
    result <- MIPModel() %>%
      add_variable(x[i], i=1:n, type = "integer") %>%   # x = no of machines for each category
      add_variable(y[i],i=1:n,type = "continuous") %>%  # y = Ave_CoinIn for each category
      set_objective( sum_expr(y[i]*x[i],i=1:n),"max") %>% # maximize the sum of x*y  -> profit
      add_constraint(x[i] <= upperbounds[i], i=1:n) %>%
      add_constraint(x[i] >= lowerbounds[i], i=1:n) %>%
      add_constraint(sum_expr(x[i],i=1:n) <= tot_slot) %>% # the maximum number of total machines allowed on the floor
      solve_model(with_ROI(solver = "glpk"))
    #get_solution(result, x)
    #get_solution(result, y)
    xvals= get_solution(result, x[i]) 
    #print(xvals)
    xOpt=xvals[,3]  #return optimal no of slots for each category
    change = percent((xOpt-no)/no)
    
    # Calculate the total CoinIn with original slots/ optimal slots, and profit increase
    CPD=sum(no*y)
    new_CPD=sum(xOpt*y)
    CPD_change=percent((sum(xOpt*y)-sum(no*y))/sum(no*y))# profit increase
    new_df=data.frame(df,upperbounds,lowerbounds,xOpt,change,stringsAsFactors=FALSE )
    
    colnames(new_df)[colnames(new_df) == 'xOpt'] <- 'Opt_Number_Machines'
    
    
    ## check the consistency of the total capability ##
    new_df[nrow(new_df) + 1,]= list( 'Total Machines', sum(no),NA,NA,NA,sum(xOpt),NA)
    new_df[nrow(new_df) + 1,]= list( 'Total CPD',as.numeric(CPD),NA,as.numeric(new_CPD),NA,NA,as.numeric(CPD_change))
    
    filename_opt<-sprintf("MixSlots_%s_opt.csv",my_casino)
    
    filename_opt = gsub(" ", "_", filename_opt) # replaces " " by "_"in casinos names
    
    write.csv(new_df, file = filename_opt, row.names = TRUE)
    sum(no)==sum(xOpt)
    print(sprintf("Casino of %s: the revenue will increase by %1.2f%%", my_casino,CPD_change*100, "\n"))
    
  }
}

runAnalysis()



