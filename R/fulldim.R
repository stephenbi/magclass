#' Reconstructs full dimensionality of MAgPIE objects
#' 
#' If a MAgPIE object is created from a source with more than one data
#' dimension, these data dimensions are combined to a single dimension. fulldim
#' reconstructs the original dimensionality and reports it.
#' 
#' 
#' @param x A MAgPIE-object
#' @param sep A character separating joined dimension names
#' @return A list containing in the first element the dim output and in the
#' second element the dimnames output of the reconstructed array.
#' @author Jan Philipp Dietrich
#' @seealso \code{\link{as.magpie}},\code{\link{unwrap}},\code{\link{wrap}}
#' @examples
#' 
#'   a <- as.magpie(array(1:6,c(3,2),list(c("bla","blub","ble"),c("up","down"))))
#'   fulldim(a)
#' 
#' 
#' @export fulldim
fulldim <- function(x,sep=".") {
  if(!is.null(dimnames(x)[[3]])){
    elemsplit <- strsplit(dimnames(x)[[3]],sep,fixed=TRUE)
    tmp <- sapply(elemsplit,length)
  } else{
    tmp<-1
  }
  if(length(tmp)==1) if(tmp==0) tmp <- 1
  if(any(tmp != rep(tmp[1],length(tmp))) | tmp[1]==1) {
    #data dimension cannot be splitted return dim(x)
    return(list(dim(x),dimnames(x)))
  } else {
    nElemDims <- tmp[1]
    tmp <- t(matrix(unlist(elemsplit),nElemDims))
    dimnames <- list()
    dimnames[[1]] <- dimnames(x)[[1]]
    dimnames[[2]] <- dimnames(x)[[2]]
    dim <- dim(x)[1:2]
    for(i in 1:nElemDims) {
      dimnames[[i+2]] <- unique(tmp[,i])
      dim <- c(dim,length(dimnames[[i+2]]))
    }
    tmp <- getSets(x,sep=sep)
    if(length(tmp)==length(dimnames) | is.null(tmp)) {
      names(dimnames) <- tmp
    } else {
      if(length(tmp)==length(dimnames)+1 & length(grep(sep,names(dimnames(x))[1],fixed=TRUE))) {
        names(dimnames) <- c(names(dimnames(x))[1],tmp[3:length(tmp)])
      }
    }    
    return(list(dim,dimnames))
  }
}
