## Put comments here that give an overall description of what your
## functions do

## This function creates a list based on a n-by-n square matrix

makeCacheMatrix <- function(x = matrix()) {
        m <- NULL
        setx <- function(y) {
                x <<- y
                m <<- NULL
        }
        getx <- function() x
        setmatrix <- function(matrix) m <<- matrix
        getmatrix <- function() m
        list(setx = setx, getx = getx,
             setmatrix = setmatrix,
             getmatrix = getmatrix)
}


## This function will return the matrix inverse from the function makeCacheMatrix

cacheSolve <- function(x, ...) {
        m <- x$getmatrix()
        if(!is.null(m)) {
                message("getting cached data")
                return(m)
        }
        data <- x$getx()
        m <- solve(data, ...)
        x$setmatrix(m)
        m
}
