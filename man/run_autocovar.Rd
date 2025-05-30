% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/RcppExports.R
\name{run_autocovar}
\alias{run_autocovar}
\title{Calculate the trailing autocovariance of a \emph{time series} of returns
using an online recursive formula.}
\usage{
run_autocovar(timeser, lambdaf, lagg = 1L)
}
\arguments{
\item{\code{timeser}}{A \emph{time series} or a \emph{matrix} with a single
column of returns data.}

\item{\code{lambdaf}}{A decay factor which multiplies past estimates.}

\item{\code{lagg}}{An \emph{integer} equal to the number of periods to lag.
(The default is \code{lagg = 1}.)}
}
\value{
A \emph{matrix} with three columns of data: the trailing
  autocovariances, the variances, and the mean values of the argument
  \code{timeser}.
}
\description{
Calculate the trailing autocovariance of a \emph{time series} of returns
using an online recursive formula.
}
\details{
The function \code{run_autocovar()} calculates the trailing
  autocovariance of a streaming \emph{time series} of returns, by
  recursively weighting the past autocovariance estimates \eqn{{cov}_{t-1}},
  with the products of their returns minus their means, using the decay
  factor \eqn{\lambda}:
  \deqn{
    \bar{x}_t = \lambda \bar{x}_{t-1} + (1 - \lambda) x_t
  }
  \deqn{
    \sigma^2_{t} = \lambda^2 \sigma^2_{t-1} + (1 - \lambda^2) (x_t - \bar{x}_t)^2
  }
  \deqn{
    {cov}_t = \lambda^2 {cov}_{t-1} + (1 - \lambda^2) (x_t - \bar{x}_t) (x_{t-l} - \bar{x}_{t-l})
  }
  Where \eqn{{cov}_t} is the trailing autocovariance estimate at time
  \eqn{t}, with \code{lagg=l}.
  And \eqn{\sigma^2_{t}} and \eqn{\bar{x}_t} are the trailing variances and
  means of the streaming data.

  The above online recursive formulas are convenient for processing live
  streaming data because they don't require maintaining a buffer of past
  data. The formulas are equivalent to a convolution with exponentially
  decaying weights, but they're much faster to calculate.
  Using exponentially decaying weights is more natural than using a sliding
  look-back interval, because it gradually "forgets" about the past data.

  Note that the variance and covariance decay as the square of
  \eqn{\lambda}, while the mean returns decay as \eqn{\lambda}.
  This is because the variance is proportional to the square of the returns.
  
  The value of the decay factor \eqn{\lambda} must be in the range between
  \code{0} and \code{1}.  
  If \eqn{\lambda} is close to \code{1} then the decay is weak and past
  values have a greater weight, and the trailing covariance values have a
  stronger dependence on past data.  This is equivalent to a long
  look-back interval.
  If \eqn{\lambda} is much less than \code{1} then the decay is strong and
  past values have a smaller weight, and the trailing covariance values have
  a weaker dependence on past data.  This is equivalent to a short
  look-back interval.

  The function \code{run_autocovar()} returns three columns of data: the
  trailing autocovariances, the variances, and the mean values of the
  argument \code{timeser}.  This allows calculating the trailing
  autocorrelations.
}
\examples{
\dontrun{
# Calculate historical returns
retp <- zoo::coredata(na.omit(rutils::etfenv$returns$VTI))
# Calculate the trailing autocovariance
lambdaf <- 0.9 # Decay factor
lagg <- 3
covars <- HighFreq::run_autocovar(retp, lambdaf=lambdaf, lagg=lagg)
# Calculate the trailing autocorrelation
correl <- covars[, 1]/covars[, 2]
# Calculate the trailing autocovariance using R code
nrows <- NROW(retp)
retm <- numeric(nrows)
retm[1] <- retp[1, ]
retd <- numeric(nrows)
covarr <- numeric(nrows)
covarr[1] <- retp[1, ]^2
for (it in 2:nrows) {
  retm[it] <- lambdaf*retm[it-1] + (1-lambdaf)*(retp[it])
  retd[it] <- retp[it] - retm[it]
  covarr[it] <- lambdaf*covarr[it-1] + (1-lambdaf)*retd[it]*retd[max(it-lagg, 1)]
} # end for
all.equal(covarr, covars[, 1])
}  # end dontrun

}
