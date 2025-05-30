% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/RcppExports.R
\name{calc_invrec}
\alias{calc_invrec}
\title{Calculate the approximate inverse of a square \emph{matrix} recursively
using the Schulz formula (without copying the data in memory).}
\usage{
calc_invrec(matrixv, invmat, niter = 1L)
}
\arguments{
\item{\code{matrixv}}{A \emph{matrix} of data to be inverted.}

\item{\code{invmat}}{A \emph{matrix} of data equal to the starting point for
the recursion.}

\item{\code{niter}}{An \emph{integer} equal to the number of recursion
iterations.}
}
\value{
No return value.
}
\description{
Calculate the approximate inverse of a square \emph{matrix} recursively
using the Schulz formula (without copying the data in memory).
}
\details{
The function \code{calc_invrec()} calculates the approximate inverse
  \eqn{\strong{A}^{-1}} of a square \emph{matrix} \eqn{\strong{A}}
  recursively using the Schulz formula:
  \deqn{
    \strong{A}_{i+1}^{-1} \leftarrow 2 \strong{A}_i^{-1} - \strong{A}_i^{-1} \strong{A} \strong{A}_i^{-1}
  }
  The Schulz formula is repeated \code{niter} times.
  The Schulz formula is useful for updating the inverse when the matrix
  \eqn{\strong{A}} changes only slightly.  For example, for updating the
  inverse of the covariance matrix as it changes slowly over time.

  The function \code{calc_invrec()} accepts a \emph{pointer} to the argument
  \code{invmat} (which is the initial value of the inverse matrix for the
  recursion), and it overwrites the old inverse matrix values with the
  updated inverse values.

  The function \code{calc_invrec()} performs the calculation in place,
  without copying the matrix in memory, which can significantly increase the
  computation speed for large matrices.
  
  The function \code{calc_invrec()} doesn't return a value.
  The function \code{calc_invrec()} performs the calculations using
  \code{C++} \code{Armadillo} code.
}
\examples{
\dontrun{
# Calculate a random matrix
matrixv <- matrix(rnorm(100), nc=10)
# Define the initial value of the inverse matrix
invmat <- solve(matrixv) + matrix(rnorm(100, sd=0.1), nc=10)
# Calculate the inverse in place using RcppArmadillo
HighFreq::calc_invrec(matrixv, invmat, 3)
# Multiply the matrix times its inverse
multmat <- matrixv \%*\% invmat
round(multmat, 4)
# Calculate the sum of the off-diagonal elements
sum(multmat[upper.tri(multmat)])
# Compare RcppArmadillo with R
all.equal(invmat, solve(matrixv))
# Compare the speed of RcppArmadillo with R code
library(microbenchmark)
summary(microbenchmark(
   rcode=solve(matrixv),
   cppcode=HighFreq::calc_invrec(matrixv, invmat, 3),
   times=10))[, c(1, 4, 5)]
}  # end dontrun

}
