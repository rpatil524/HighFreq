% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/RcppExports.R
\name{calc_var_ohlc}
\alias{calc_var_ohlc}
\title{Calculate the variance of returns from \emph{OHLC} prices using different
price range estimators.}
\usage{
calc_var_ohlc(
  ohlc,
  method = "yang_zhang",
  closel = 0L,
  scalit = TRUE,
  index = 0L
)
}
\arguments{
\item{\code{ohlc}}{A \emph{time series} or a \emph{matrix} of \emph{OHLC}
prices.}

\item{\code{method}}{A \emph{character string} representing the price range
estimator for calculating the variance.  The estimators include:
\itemize{
  \item "close" close-to-close estimator,
  \item "rogers_satchell" Rogers-Satchell estimator,
  \item "garman_klass" Garman-Klass estimator,
  \item "garman_klass_yz" Garman-Klass with account for close-to-open price jumps,
  \item "yang_zhang" Yang-Zhang estimator,
 }
 (The default is the \code{method = "yang_zhang"}.)}

\item{\code{closel}}{A \emph{vector} with the lagged \emph{close} prices
of the \emph{OHLC time series}.  This is an optional argument. (The
default is \code{closel = 0}).}

\item{\code{scalit}}{\emph{Boolean} argument: Should the returns be divided
by the time index, the number of seconds in each period? (The default is
\code{scalit = TRUE}).}

\item{\code{index}}{A \emph{vector} with the time index of the \emph{time
series}.  This is an optional argument (the default is \code{index = 0}).}
}
\value{
A single \emph{numeric} value equal to the variance of the
  \emph{OHLC time series}.
}
\description{
Calculate the variance of returns from \emph{OHLC} prices using different
price range estimators.
}
\details{
The function \code{calc_var_ohlc()} calculates the variance from all the
  different intra-day and day-over-day returns (defined as the differences
  of \emph{OHLC} prices), using several different variance estimation
  methods.

  The function \code{calc_var_ohlc()} does not calculate the logarithm of
  the prices.
  So if the argument \code{ohlc} contains dollar prices then
  \code{calc_var_ohlc()} calculates the dollar variance.
  If the argument \code{ohlc} contains the log prices then
  \code{calc_var_ohlc()} calculates the percentage variance.

  The default \code{method} is \emph{"yang_zhang"}, which theoretically
  has the lowest standard error among unbiased estimators.
  The methods \emph{"close"}, \emph{"garman_klass_yz"}, and
  \emph{"yang_zhang"} do account for \emph{close-to-open} price jumps, while
  the methods \emph{"garman_klass"} and \emph{"rogers_satchell"} do not
  account for \emph{close-to-open} price jumps.

  If \code{scalit} is \code{TRUE} (the default), then the returns are
  divided by the differences of the time index (which scales the variance to
  the units of variance per second squared). This is useful when calculating
  the variance from minutes bar data, because dividing returns by the
  number of seconds decreases the effect of overnight price jumps. If the
  time index is in days, then the variance is equal to the variance per day
  squared.
  
  If the number of rows of \code{ohlc} is less than \code{3} then it
  returns zero.
  
  The optional argument \code{index} is the time index of the \emph{time
  series} \code{ohlc}. If the time index is in seconds, then the
  differences of the index are equal to the number of seconds in each time
  period.  If the time index is in days, then the differences are equal to
  the number of days in each time period.
  
  The optional argument \code{closel} are the lagged \emph{close} prices
  of the \emph{OHLC time series}.  Passing in the lagged \emph{close} prices
  speeds up the calculation, so it's useful for rolling calculations.
  
  The function \code{calc_var_ohlc()} is implemented in \code{RcppArmadillo}
  \code{C++} code, and it's over \code{10} times faster than
  \code{calc_var_ohlc_r()}, which is implemented in \code{R} code.
}
\examples{
\dontrun{
# Extract the log OHLC prices of SPY
ohlc <- log(HighFreq::SPY)
# Extract the time index of SPY prices
indeks <- c(1, diff(xts::.index(ohlc)))
# Calculate the variance of SPY returns, with scaling of the returns
HighFreq::calc_var_ohlc(ohlc, 
 method="yang_zhang", scalit=TRUE, index=indeks)
# Calculate variance without accounting for overnight jumps
HighFreq::calc_var_ohlc(ohlc, 
 method="rogers_satchell", scalit=TRUE, index=indeks)
# Calculate the variance without scaling the returns
HighFreq::calc_var_ohlc(ohlc, scalit=FALSE)
# Calculate the variance by passing in the lagged close prices
closel <- HighFreq::lagit(ohlc[, 4])
all.equal(HighFreq::calc_var_ohlc(ohlc), 
  HighFreq::calc_var_ohlc(ohlc, closel=closel))
# Compare with HighFreq::calc_var_ohlc_r()
all.equal(HighFreq::calc_var_ohlc(ohlc, index=indeks), 
  HighFreq::calc_var_ohlc_r(ohlc))
# Compare the speed of Rcpp with R code
library(microbenchmark)
summary(microbenchmark(
  Rcpp=HighFreq::calc_var_ohlc(ohlc),
  Rcode=HighFreq::calc_var_ohlc_r(ohlc),
  times=10))[, c(1, 4, 5)]  # end microbenchmark summary
}  # end dontrun
}
