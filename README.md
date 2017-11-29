# Quantitative Analysis
## Trading Strategy Creation and Evaluation

### Description of the Strategy
The strategy uses exponentially weight moving averages (*specifically, their slope*) of the returns over the last `a` and `b` days (in our submission, 20 and 50).
With a threshold `t`, we:

- buy if both EWMA are greater than `t`;
- sell if both EWMA are less than `t`.

*Using a threshold allows us to avoid assets whose averages are very close to zero to cause rapid trading. Even a small threshold (in testing) moves the average holding period from approx. 2 days to 9 days, reducing turnover and transaction costs significantly.*

To model this, we create an `Ownership` column that describes whether on that day, the asset is owned on a given `datenum`. The rule for doing so is described above.

Finally, the algorithm evaluates its performance using methods supplied in class.


### Description of the Code
#### `addLags`, `addEWMA`
These functions add respectively lag in a variable, and exponentially weighted moving averages.

#### `runSimpleStrategy.m`


###### Threshold

The threshold is declared as `deltaThreshold = 0.001`, and there is a sell (`-t`) threshold under which we sell the asset, and a buy (`+t`) threshold above which we buy.

###### Buy and Sell Decisions
The following lines of code model the buying and selling decisions.

		crsp.Buy = crsp.ewma20RET_derived > buyThreshold ...
         & crsp.ewma50RET_derived > buyThreshold;
     
		crsp.Sell = crsp.ewma20RET_derived < sellThreshold ...
          & crsp.ewma50RET_derived < sellThreshold;

#### `makeWeights.m`
Uses the `Ownership` (which represents which assets are owned on that day, `1` or those that are not owned `0`) column to construct a `total` column (summing for each `datenum` the `Ownership`) to build the `w` column, short for weights.

### Findings
*To do.*