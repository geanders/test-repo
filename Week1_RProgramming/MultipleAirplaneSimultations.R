## Now we can use the R function to run lots of simulations of the airplane
## filling and, and we'll see what happens each time. For example, let's start with
## 100 of these simulations, and we'll keep track for each one of whether 
## the last person got his assigned seat and the total number of people that
## didn't get their assigned seat (the outputs of the "fill.airplane" function)

sim.1 <- data.frame(n.not.assigned = rep(NA, 100),
                  last.got.assigned = factor(rep(NA, 100), levels = c("No", "Yes"))
                  )

for(i in 1:nrow(sim.1)){
        print(i)
        sim.1[i,] <- fill.airplane()
}

## Determine the percent of times that the last person got his assigned seat
table(sim.1$last.got.assigned)

## Plot a histogram of the number of people who did not get their assigned seats
ggplot(sim.1, aes(x = n.not.assigned)) + geom_histogram()

## Now do two other simulations: 1 with a smaller plane and one with a 
## bigger plane. How do the measures (probability of the last person 
## getting his seat and number of people who don't get their assigned seats)
## change? How does the length of time it takes to run a simulation change?

## small plane
sim.2 <- data.frame(n.not.assigned = rep(NA, 100),
                    last.got.assigned = factor(rep(NA, 100), levels = c("No", "Yes"))
                    )

for(i in 1:nrow(sim.2)){
        print(i)
        sim.2[i,] <- fill.airplane(rows = 10, seats = 3)
}

table(sim.2$last.got.assigned)
ggplot(sim.2, aes(x = n.not.assigned)) + geom_histogram()

## bigger plane
sim.3 <- data.frame(n.not.assigned = rep(NA, 100),
                    last.got.assigned = factor(rep(NA, 100), levels = c("No", "Yes"))
)

for(i in 1:nrow(sim.3)){
        print(i)
        sim.3[i,] <- fill.airplane(rows = 50, seats = 8)
}

table(sim.3$last.got.assigned)
ggplot(sim.3, aes(x = n.not.assigned)) + geom_histogram()
