## Take the code we just did and put it in a function so it's easy to run.
## Also, make it so we can specify the number of rows and seats per row 
## when we call the function, and so we can choose whether or not to plot the
## airplane.

fill.airplane <- function(rows = 27, seats = 6, plot.airplane = FALSE){
        available.rows <- 1:rows
        available.rowseats <- LETTERS[1:seats]
        available.seats <- expand.grid(available.rows, available.rowseats)
        available.seats <- apply(available.seats, 1, paste, collapse = "")
        available.seats <- gsub(" ", "", available.seats) 

        manifest <- data.frame(passenger = 1:(seats * rows),
                       assigned.seat = available.seats[sample(1:length(available.seats))], 
                       stringsAsFactors = FALSE)
        manifest$row <-  as.numeric(gsub("[A-Z]", "", manifest$assigned.seat))
        manifest$seat <- gsub("[0-9]", "", manifest$assigned.seat)

        manifest$last.passenger <- factor(rep("No"), levels = c("No", "Yes"))
        manifest$last.passenger[manifest$passenger == seats * rows] <- "Yes"


        seat.availability <- factor(rep("Empty", length = nrow(manifest)),
                               levels = c("Empty", "Taken"))
        names(seat.availability) <- available.seats 

        manifest$actual.seat <- rep(NA) 

        manifest$actual.seat[1] <- sample(names(seat.availability), 1) 
        seat.availability[manifest$actual.seat[1]] <- "Taken"

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

        check.assigned <- manifest$assigned.seat == manifest$actual.seat
        manifest$got.assigned.seat <- ifelse(check.assigned, "Yes", "No")
        manifest$got.assigned.seat <- factor(manifest$got.assigned.seat,
                                             levels = c("Yes", "No"))

        if(plot.airplane == TRUE){
                ap <- ggplot(manifest, aes(x = seat, y = row, group = last.passenger))
                ap <- ap + geom_point(aes(color = last.passenger, fill = got.assigned.seat),
                                      shape = 22, size = 5)
                ap <- ap + scale_y_reverse()
                ap <- ap + scale_color_manual(values = c("black", "red")) + 
                        scale_fill_manual(values = c("white", "darkblue"))
                print(ap)
        }
        out <- data.frame(n.not.assigned = sum(manifest$got.assigned.seat == "No"),
                          last.got.assigned = manifest$got.assigned.seat[manifest$last.passenger == "Yes"]
                         )
        return(out)
}
