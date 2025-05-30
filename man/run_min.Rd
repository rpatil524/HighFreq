% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/RcppExports.R
\name{run_min}
\alias{run_min}
\title{Calculate the trailing minimum values of streaming \emph{time series} data
using an online recursive formula.}
\usage{
run_min(timeser, lambdaf)
}
\arguments{
\item{\code{timeser}}{A \emph{time series} or a \emph{matrix}.}

\item{\code{lambdaf}}{A decay factor which multiplies past estimates.}
}
\value{
A \emph{matrix} with the same dimensions as the input argument
  \code{timeser}.
}
\description{
Calculate the trailing minimum values of streaming \emph{time series} data
using an online recursive formula.
}
\details{
The function \code{run_min()} calculates the trailing minimum values of
  streaming \emph{time series} data by recursively weighting present and past
  values using the decay factor \eqn{\lambda}.

  It calculates the trailing minimum values \eqn{p^{min}_t} of the streaming
  data \eqn{p_t} as follows:
  \deqn{
    p^{min}_t = min(p_t, \lambda p^{min}_{t-1} + (1 - \lambda) p_t)
  }
  The first term in the sum is the minimum value multiplied by the decay
  factor \eqn{\lambda}, so that the past minimum value is gradually
  "forgotten". The second term pulls the minimum value to the current value
  \eqn{p_t}.
  
  The value of the decay factor \eqn{\lambda} must be in the range between
  \code{0} and \code{1}.  
  If \eqn{\lambda} is close to \code{1} then the past minimum values persist
  for longer.  This is equivalent to a long look-back interval.
  If \eqn{\lambda} is much less than \code{1} then the past minimum values
  decay quickly, and the trailing minimum depends on the more recent
  streaming data.  This is equivalent to a short look-back interval.

  The above formula can also be expressed as:
  \deqn{
    p^{min}_t = \lambda min(p_t, p^{min}_{t-1}) + (1 - \lambda) p_t
  }
  The first term is the minimum value multiplied by the decay factor
  \eqn{\lambda}, so that the past minimum value is gradually "forgotten".
  The second term pulls the minimum value to the current value \eqn{p_t}.
  
  The above recursive formula is convenient for processing live streaming
  data because it doesn't require maintaining a buffer of past data.

  The function \code{run_min()} returns a \emph{matrix} with the same
  dimensions as the input argument \code{timeser}.
}
\examples{
\dontrun{
# Calculate historical prices
closep <- zoo::coredata(quantmod::Cl(rutils::etfenv$VTI))
# Calculate the trailing minimums
lambdaf <- 0.9 # Decay factor
pricmin <- HighFreq::run_min(closep, lambdaf=lambdaf)
# Plot dygraph of VTI prices and trailing minimums
datav <- cbind(quantmod::Cl(rutils::etfenv$VTI), pricmin)
colnames(datav) <- c("prices", "min")
colnamev <- colnames(datav)
dygraphs::dygraph(datav, main="VTI Prices and Trailing Minimums") \%>\%
  dySeries(label=colnamev[1], strokeWidth=1, col="blue") \%>\%
  dySeries(label=colnamev[2], strokeWidth=1, col="red")
}  # end dontrun

}
