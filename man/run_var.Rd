% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/RcppExports.R
\name{run_var}
\alias{run_var}
\title{Calculate the trailing mean and variance of streaming \emph{time series} of
data using an online recursive formula.}
\usage{
run_var(timeser, lambdaf)
}
\arguments{
\item{\code{timeser}}{A \emph{time series} or a \emph{matrix} of data.}

\item{\code{lambdaf}}{A decay factor which multiplies past estimates.}
}
\value{
A \emph{matrix} with two columns and the same number of rows as the
  input argument \code{timeser}.  The first column contains the trailing
  means and the second contains the variance.
}
\description{
Calculate the trailing mean and variance of streaming \emph{time series} of
data using an online recursive formula.
}
\details{
The function \code{run_var()} calculates the trailing mean and variance
  of streaming \emph{time series} of data \eqn{r_t}, by recursively
  weighting the past variance estimates \eqn{\sigma^2_{t-1}}, with the
  squared differences of the data minus its trailing means \eqn{(r_t -
  \bar{r}_t)^2}, using the decay factor \eqn{\lambda^2}:
  \deqn{
    \bar{r}_t = \lambda \bar{r}_{t-1} + (1 - \lambda) r_t
  }
  \deqn{
    \sigma^2_t = \lambda^2 \sigma^2_{t-1} + (1 - \lambda^2) (r_t - \bar{r}_t)^2
  }
  Where \eqn{r_t} are the streaming data, \eqn{\bar{r}_t} are the trailing
  means, and \eqn{\sigma^2_t} are the trailing variance estimates.
  
  Note that the variance decays as the square of \eqn{\lambda}, while the
  mean returns decay as \eqn{\lambda}.
  This is because the variance is proportional to the square of the returns.
  
  The above online recursive formulas are convenient for processing live
  streaming data because they don't require maintaining a buffer of past
  data.
  The formulas are equivalent to a convolution with exponentially decaying
  weights, but they're much faster to calculate.
  Using exponentially decaying weights is more natural than using a sliding
  look-back interval, because it gradually "forgets" about the past data.

  The value of the decay factor \eqn{\lambda} must be in the range between
  \code{0} and \code{1}.  
  If \eqn{\lambda} is close to \code{1} then the decay is weak and past
  values have a greater weight, and the trailing variance values have a
  stronger dependence on past data.  This is equivalent to a long
  look-back interval.
  If \eqn{\lambda} is much less than \code{1} then the decay is strong and
  past values have a smaller weight, and the trailing variance values have a
  weaker dependence on past data.  This is equivalent to a short look-back
  interval.

  The function \code{run_var()} performs the same calculation as the
  standard \code{R} function\cr\code{stats::filter(x=series,
  filter=weightv, method="recursive")}, but it's several times faster.

  The function \code{run_var()} returns a \emph{matrix} with two columns and
  the same number of rows as the input argument \code{timeser}.
  The first column contains the trailing means and the second contains the
  variance.
}
