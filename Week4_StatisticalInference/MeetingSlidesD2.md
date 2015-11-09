---
title: "Meeting Slides"
subtitle: "Coursera Statistical Inference, Week 4"
author: "Brooke Anderson"
date: "August 27, 2014"
output: ioslides_presentation
---

## Playing darts

**Research question: Is a person skilled at playing darts?**

Here's our dart board-- the numbers are the number of points you win for a hit in each area.

<img src="figure/unnamed-chunk-1-1.png" title="plot of chunk unnamed-chunk-1" alt="plot of chunk unnamed-chunk-1" style="display: block; margin: auto;" />

## Null hypothesis

First, what would we expect to see if the person we test has no skill at playing darts? 

*Questions for you:*

- *What would the dart board look like under the null (say the person throws 20 darts for the experiment)?*
- *About what do you think the person's mean score would be if they had no skill at darts?*
- *What are some ways to estimate or calculate the expected mean score under the null?*

## Graph of results under the null

Let's use R to answer the first question: what would the null look like?

First, create some random throws (the square goes from -1 to 1 on both sides):


```r
n.throws <- 10
throw.x <- runif(n.throws, min = -1 * (6 + 5/8),
                 max = (6 + 5/8))
throw.y <- runif(n.throws, min = -1 * (6 + 5/8),
                 max = (6 + 5/8))
head(cbind(throw.x, throw.y))
```

```
##         throw.x    throw.y
## [1,] -0.3417724  4.3112002
## [2,]  5.3568449  0.3986758
## [3,] -0.1968829 -4.0292692
## [4,] -3.7015105  1.3955238
## [5,]  0.9807719 -2.0511807
## [6,] -3.3563166 -3.6548960
```

## Graph of results under the null


```r
plot(c(-1 * (6 + 5/8), (6 + 5/8)), c(-1 * (6 + 5/8), (6 + 5/8)),
     type = "n", asp=1,
     xlab = "", ylab = "", axes = FALSE)
rect( -1 * (6 + 5/8), -1 * (6 + 5/8),
      (6 + 5/8), (6 + 5/8)) 
draw.circle( 0, 0, (6 + 5/8), col = "red")
draw.circle( 0, 0, 4, col = "white")
draw.circle( 0, 0, (3 / 4), col = "red")
points(throw.x, throw.y, col = "black", pch = 19)
```

![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-3-1.png) 

## Mean score under the null

Next, let's tally up the score for this simulation of what would happen under the null.

To score each throw, we calculate how far the point is from (0, 0), and then use the following rules: 

- **20 points**: $0.00 \le \sqrt{x^2 + y^2} \le .25$
- **15 points**: $0.25 < \sqrt{x^2 + y^2} \le .50$ 
- **10 points**: $0.50 < \sqrt{x^2 + y^2} \le .75$ 
-  **0 points**: $0.75 < \sqrt{x^2 + y^2} \le 1.41$ 

## Mean score under the null

Use these rules to "score" each random throw:


```r
throw.dist <- sqrt(throw.x^2 + throw.y^2)
head(throw.dist)
```

```
## [1] 4.324726 5.371660 4.034077 3.955840 2.273600 4.962169
```

```r
throw.score <- cut(throw.dist,
                   breaks = c(0, (3/4), 4, (6 + 5/8), 10),
                   labels = c("25", "10", "5", "Null"),
                   right = FALSE)
head(throw.score)
```

```
## [1] 5  5  5  10 10 5 
## Levels: 25 10 5 Null
```

## Mean score under the null

Now that we've scored each throw, let's tally up the total:


```r
table(throw.score)
```

```
## throw.score
##   25   10    5 Null 
##    0    4    6    0
```

```r
ex <- as.numeric(as.character(throw.score))
ex <- ex[!is.na(ex)]
mean(ex)
```

```
## [1] 7
```

## What to expect under the null

So, this just showed *one* example of what might happen under the null. If we had a lot of examples like this (someone with no skill throwing 20 darts), what would we expect the mean scores to be?

*Questions for you:*

- *How can you figure out the expected value of the mean scores under the null (that the person has no skill)?*
- *Do you think that 20 throws will be enough to figure out if a person's mean score is different from this value, if he or she is pretty good at darts?*
- *What steps do you think you could take to figure out the last question?*
- *What could you change about the experiment to make it easier to tell if someone's skilled at darts?*

## What to expect under the null

How can we figure this out?

- **Theory.** Calculate the expected mean value using the expectation formula
- **Simulation.** Simulate a lot of examples using R and calculate the mean of the mean score from these.

## Calculating $E[X]$

The expected value of the mean, $E[\bar{X}]$, is the expected value of $X$, $E[X]$. To calculate the expected value of $X$, use the formula:

$$ E[X] = \sum_x xp(x)$$
$$ E[X] = 20 * p(X = 20) + 15 * p(X = 15) +\\ 10 * p(X = 10) + 0 * p(X = 0)$$

So we just need to figure out $p(X = x)$ for $x = 20, 15, 10$.

## Calculating $E[X]$

(In all cases, we're dividing by 4 because that's the area of the full square, $2^2$.)

- $p(X = 20)$: Proportional to area of the smallest circle, $(\pi * 0.25^2) / 4 = 0.049$
- $p(X = 15)$: Proportional to area of the middle circle minus area of the smallest circle, $\pi(0.50^2 - 0.25^2) / 4 = 0.147$
- $p(X = 10)$: Proportional to area of the largest circle minus area of the middle circle, $\pi(0.75^2 - 0.50^2) / 4 = 0.245$
- $p(X = 0)$: Proportional to area of the square minus area of the largest circle, $(2^2 - \pi * 0.75^2) / 4 = 0.558$

As a double check, if we've done this write, the probabilities should sum to 1:

$$0.049 + 0.147 + 0.245 + 0.558 = 0.999$$

## Calculating $E[X]$

$$ E[X] = \sum_x xp(x)$$
$$ E[X] = 20 * 0.049 + 15 * 0.147 +\\ 10 * 0.245 + 0 * 0.558$$
$$ E[X] = 5.635 $$

Remember, this also gives us $E[\bar{X}]$.

## Calculating $var(X)$ and $var(\bar{X})$

Now it's pretty easy to also calculate $var(X)$ and $var(\bar{X})$:

$$
Var(X) = E[(X - \mu)^2] = E[X^2] - E[X]^2
$$ 

$$
E[X^2] = 20^2 * 0.049 + 15^2 * 0.147 +\\ 10^2 * 0.245 + 0^2 * 0.558 = 77.18
$$

$$
Var(X) = 77.175 - (5.635)^2 = 45.42
$$

$$
Var(\bar X) = \sigma^2 / n = 45.42 / 20 = 2.27
$$

## Calculating CI for $\bar{X}$

Now that we can use the Central Limit Theorem to calculate a 95% confidence interval for the mean score when someone with no skill (null hypothesis) throws 20 darts:


```r
5.635 + c(-1, 1) * qnorm(.975) * sqrt(2.27)
```

```
## [1] 2.682017 8.587983
```

## Simulating $E[\bar{X}]$ and $Var(\bar{X})$

We can check our math by running simulations-- we should get the same values of $E[\bar{X}]$ and $Var(\bar{X})$ (which we can calculate directly from the simulations using R).


```r
n.throws <- 30
n.sims <- 10000

x.throws <- matrix(runif(n.throws * n.sims,
                         -1*(6 + 5/8), (6 + 5/8)),
                   ncol = n.throws, nrow = n.sims)
y.throws <- matrix(runif(n.throws * n.sims,
                         -1*(6 + 5/8), (6 + 5/8)),
                   ncol = n.throws, nrow = n.sims)
dist.throws <- sqrt(x.throws^2 + y.throws^2)
ex <- matrix(NA, ncol = 10, nrow = 10000)
for(i in 1:nrow(ex)){
        x <- as.numeric(as.character(dist.throws[i,]))
        x <- x[!is.na(x)]
        x <- x[1:10]
        ex[i,] <- x
}
score.throws <- apply(ex, 2, cut,
                   breaks = c(0, (3/4), 4, (6 + 5/8), 10),
                   labels = c("25", "10", "5", "Null"),
                   right = FALSE)
```

## Simulating $E[\bar{X}]$ and $Var(\bar{X})$


```r
dist.throws[1:3,1:5]
```

```
##          [,1]     [,2]     [,3]     [,4]     [,5]
## [1,] 5.235099 4.205553 5.258347 4.730786 5.561223
## [2,] 7.651559 6.259084 4.711931 1.372088 5.159890
## [3,] 1.477280 4.269533 3.117517 3.075932 2.679381
```

```r
score.throws[1:3,1:5]
```

```
##      [,1]   [,2] [,3] [,4] [,5]
## [1,] "5"    "5"  "5"  "5"  "5" 
## [2,] "Null" "5"  "5"  "10" "5" 
## [3,] "10"   "5"  "10" "10" "10"
```

## Simulating $E[\bar{X}]$ and $Var(\bar{X})$


```r
mean.scores <- apply(score.throws, MARGIN = 1,
                     function(x){
                             out <- mean(as.numeric(
                                     as.character(x)))
                             return(out)
                     })
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```
## Warning in mean(as.numeric(as.character(x))): NAs introduced by coercion
```

```r
head(mean.scores)
```

```
## [1] NA NA NA NA NA NA
```

## Simulating $E[\bar{X}]$ and $Var(\bar{X})$


```
## Error in quantile.default(mean.scores, probs = c(0.0275, 0.975)): missing values and NaN's not allowed if 'na.rm' is FALSE
```

<img src="figure/unnamed-chunk-10-1.png" title="plot of chunk unnamed-chunk-10" alt="plot of chunk unnamed-chunk-10" style="display: block; margin: auto;" />

## Simulating $E[\bar{X}]$ and $Var(\bar{X})$

Let's check the simulated mean and variance against the theoretical values:


```r
mean(mean.scores) ## Theoretical: 5.635
```

```
## [1] NA
```

```r
var(mean.scores) ## Theoretical: 2.27
```

```
## [1] NA
```

## Testing against null

*Questions for you:*

- *How high of a mean score would someone need to get for us not to chalk it up to chance? In other words, how high would someone's mean score need to be after 20 throws for us to reject the null that he or she is unskilled?*
- *Do you think this experiment is powerful enough to detect a skilled darts player from a practical point of view? (Related: What is the difference in this experiment between statistical and practical significance?)*
- *If not, what would you change about the experiment?*
- *If you think that this experiment is more than powerful enough, how could you improve the experiment design?* 

## Testing against the null

<img src="figure/unnamed-chunk-12-1.png" title="plot of chunk unnamed-chunk-12" alt="plot of chunk unnamed-chunk-12" style="display: block; margin: auto;" />
