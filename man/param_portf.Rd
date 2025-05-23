% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/RcppExports.R
\name{param_portf}
\alias{param_portf}
\title{Create a named list of model parameters that can be passed into portfolio
optimization functions.}
\usage{
param_portf(
  method = "sharpem",
  singmin = 1e-05,
  dimax = 0L,
  confl = 0.1,
  alphac = 0,
  rankw = FALSE,
  centerw = FALSE,
  scalew = "voltarget",
  voltarget = 0.01
)
}
\arguments{
\item{\code{method}}{A \emph{character string} specifying the method for
calculating the portfolio weights (the default is \code{method =
"sharpem"}).}

\item{\code{singmin}}{A \emph{numeric} threshold level for discarding
small \emph{singular values} in order to regularize the inverse of the
\code{covariance matrix} of \code{returns} (the default is \code{1e-5}).}

\item{\code{dimax}}{An \emph{integer} equal to the number of \emph{singular
values} used for calculating the \emph{reduced inverse} of the
\code{covariance matrix} of \code{returns} matrix (the default is
\code{dimax = 0} - standard matrix inverse using all the \emph{singular
values}).}

\item{\code{confl}}{The confidence level for calculating the quantiles of
returns (the default is \code{confl = 0.75}).}

\item{\code{alphac}}{The shrinkage intensity of \code{returns} (with values
between \code{0} and \code{1} - the default is \code{0}).}

\item{\code{rankw}}{A \emph{Boolean} specifying whether the weights should
be ranked (the default is \code{rankw = FALSE}).}

\item{\code{centerw}}{A \emph{Boolean} specifying whether the weights should
be centered (the default is \code{centerw = FALSE}).}

\item{\code{scalew}}{A \emph{character string} specifying the method for
scaling the weights (the default is \code{scalew = "voltarget"}).}

\item{\code{voltarget}}{A \emph{numeric} volatility target for scaling the
weights (the default is \code{0.01})}
}
\value{
A named list of model parameters that can be passed into portfolio
  optimization functions.
}
\description{
Create a named list of model parameters that can be passed into portfolio
optimization functions.
}
\details{
The function \code{param_portf()} creates a named list of model parameters
  that can be passed into portfolio optimization functions.  For example
  into the functions \code{calc_weights()} and \code{roll_portf()}.
  See the function \code{calc_weights()} for more details.
  
  The function \code{param_portf()} simplifies the creation of portfolio
  optimization parameter lists.  The users can create a parameter list with
  the default values, or they can specify custom parameter values.
}
\examples{
\dontrun{
# Create a default list of portfolio optimization parameters
controll <- HighFreq::param_portf()
unlist(controll)
# Create a custom list of portfolio optimization parameters
controll <- HighFreq::param_portf(method="regular", dimax=4)
unlist(controll)
}  # end dontrun

}
