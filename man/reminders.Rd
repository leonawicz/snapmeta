% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/create.R
\name{reminders}
\alias{reminders}
\title{New R package reminders}
\usage{
reminders(pkg = basename(getwd()), account = "leonawicz")
}
\arguments{
\item{pkg}{defaults to working directory.}

\item{account}{GitHub account name, defaults to "leonawicz".}
}
\value{
\code{cat} a list of steps to the console.
}
\description{
Print out a list of steps to take upon creating a new R package in RStudio.
}
\details{
Adding the repo on GitHub (step 3) can be done any time prior to step 4.
The suggested steps are mostly universal except for the final two, which cater to SNAPverse defaults.
See \code{use_these} for details on defaults.
}
\examples{
reminders()
}
