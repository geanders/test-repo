## Simulate an example of this situation: Everyone on an airplane has been 
## assigned a seat. The first person to enter, rascal that he is, sits at random
## in the airplane instead of finding his seat (although he may *randomly* sit
## where he's supposed to!). For all the rest of the passengers to board, 
## if their assigned seat is available, they will sit there. Otherwise, they 
## will choose a random seat from the ones that are still empty. We want to know
## the probability that the last person to board will end up in the seat 
## originally assigned to him. 

############################################################################
## Set up your initial data-- make a dataframe of all the passengers on the 
## plane and where they're sitting (manifest) and plot the seats with something
## that shows where the last person is assigned to sit.
############################################################################

## Create a list of all the seats on the plane (assume it has 27 rows 
## and 6 seats in each row)
available.rows <- 1:27
available.rowseats <- LETTERS[1:6]
available.seats <- expand.grid(available.rows, available.rowseats)
available.seats <- apply(available.seats, 1, paste, collapse = "")
available.seats <- gsub(" ", "", available.seats) ## don't worry too much about this,
                                                  ## it just seems that there were 
                                                  ## some extra spaces at the start of
                                                  ## some seat names, so I'm cleaning
                                                  ## that up.

## Create your manifest (list of passengers and each one's assigned seat)
manifest <- data.frame(passenger = 1:(6 * 27),
                       assigned.seat = available.seats[sample(1:length(available.seats))], ## scramble the order
                       stringsAsFactors = FALSE)
manifest$row <-  as.numeric(gsub("[A-Z]", "", manifest$assigned.seat))
manifest$seat <- gsub("[0-9]", "", manifest$assigned.seat)

## add a marker identifying the last passenger
manifest$last.passenger <- factor(rep("No"), levels = c("No", "Yes"))
manifest$last.passenger[manifest$passenger == 6*27] <- "Yes"

## Plot the airplane, with a box for each seat
ap <- ggplot(manifest, aes(x = seat, y = row, group = last.passenger))
ap <- ap + scale_y_reverse()
ap <- ap + geom_point(aes(color = last.passenger), shape = 0, size = 5)
ap <- ap + scale_color_manual(values = c("black", "red"))
ap

##############################################################################
## Now simulate the process of passengers boarding
##############################################################################

seat.availability <- factor(rep("Empty", length = nrow(manifest)),
                            levels = c("Empty", "Taken"))
names(seat.availability) <- available.seats ## Create a vector that keeps track
                                            ## of whether each seat is empty or
                                            ## taken.

manifest$actual.seat <- rep(NA) ## Create a column in the manifest dataframe
                                ## where we'll put the actual seat the passenger
                                ## ends up in.

manifest$actual.seat[1] <- sample(names(seat.availability), 1) ## pick a random
                                                               ## seat for the 
                                                               ## first passenger
seat.availability[manifest$actual.seat[1]] <- "Taken"

## For the rest of the passengers, the above loop seats them according to the
## rules (if their seat is free, they take it. Otherwise, they pick a random
## seat from the seats that are still open.)
for(i in 2:nrow(manifest)){  
        assigned.seat <- manifest[manifest$passenger == i, "assigned.seat"]
        check.seat <- seat.availability[assigned.seat]
        if(check.seat == "Empty"){
                manifest$actual.seat[i] <- assigned.seat
        } else {
                empty.seats <- names(seat.availability)[seat.availability == "Empty"]
                manifest$actual.seat[i] <- sample(empty.seats, 1)
        }
        seat.availability[manifest$actual.seat[i]] <- "Taken"
}  

## Following this process, everyone on the manifest should now have an actual seat
## Now create a column in "manifest" that says whether or not the passenger got
## his assigned seat.
check.assigned <- manifest$assigned.seat == manifest$actual.seat
manifest$got.assigned.seat <- ifelse(check.assigned, "Yes", "No")
manifest$got.assigned.seat <- factor(manifest$got.assigned.seat,
                                     levels = c("Yes", "No"))

## Plot the plane again, and this time use the fill of the boxes to show
## who got an assigned seat and who didn't
ap <- ggplot(manifest, aes(x = seat, y = row, group = last.passenger))
ap <- ap + geom_point(aes(color = last.passenger, fill = got.assigned.seat),
                      shape = 22, size = 5)
ap <- ap + scale_y_reverse()
ap <- ap + scale_color_manual(values = c("black", "red")) + 
        scale_fill_manual(values = c("white", "darkblue"))
print(ap)
