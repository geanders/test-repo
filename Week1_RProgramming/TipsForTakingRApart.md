---
title: "Tips for taking R apart"
output: ioslides_presentation
---

## 1. Evaluate the full line and see what the output looks like



Evaluate: 


```r
seat.availability <- factor(rep("Empty", length.out = nrow(manifest)),
                            levels = c("Empty", "Taken"))
```

Then check:


```r
head(seat.availability)
```

```
## [1] Empty Empty Empty Empty Empty Empty
## Levels: Empty Taken
```

```r
length(seat.availability)
```

```
## [1] 162
```

## 2. Check out any objects within the call


```r
seat.availability <- factor(rep("Empty", length.out = nrow(manifest)),
                            levels = c("Empty", "Taken"))
```

Check out: 


```r
head(manifest, 3)
```

```
##   passenger assigned.seat row seat
## 1         1           16B  16    B
## 2         2           26F  26    F
## 3         3           11D  11    D
```

## 3. Evaluate calls within calls


```r
seat.availability <- factor(rep("Empty", length.out = nrow(manifest)),
                            levels = c("Empty", "Taken"))
```

For this call, check out:

```r
nrow(manifest)
```

```
## [1] 162
```

```r
head(rep("Empty", length.out = nrow(manifest)))
```

```
## [1] "Empty" "Empty" "Empty" "Empty" "Empty" "Empty"
```

```r
c("Empty", "Taken")
```

```
## [1] "Empty" "Taken"
```

## 4. Use "?" to find out about functions


```r
seat.availability <- factor(rep("Empty", length.out = nrow(manifest)),
                            levels = c("Empty", "Taken"))
```

For this call, check out:

```r
?nrow
?rep
?factor
```

Also, try googling "basic R example [function name]"

## 5. If you're looking at a loop, assign i to the first value of the loop then check out the code in the loop


```r
j <- 0
for(i in 1:3){
        j <- j + i
}
```

For this loop, check out:

```r
j <- 0

i <- 1
j <- i + 1
j
```

```
## [1] 2
```
