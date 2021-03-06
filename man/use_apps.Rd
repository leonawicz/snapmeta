% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/snapapps.R
\name{use_apps}
\alias{use_apps}
\title{Use apps from shiny-apps repo in snapapps package}
\usage{
use_apps(id, base_path = ".", source_path = "../shiny-apps",
  res_path = "inst/shiny", description = TRUE, readme = TRUE,
  overwrite = FALSE)
}
\arguments{
\item{id}{character, app directory name.}

\item{base_path}{base file path, defaults to working directory.}

\item{source_path}{character, path to source directory containing apps to be copied. See details.}

\item{res_path}{character, path to installed resources where apps will be copied to. See details.}

\item{description}{logical, add a \code{DESCRIPTION} file template for showcase mode.}

\item{readme}{logical, add a \code{Readme.md} template for showcase mode.}

\item{overwrite}{logical, overwrite previously added apps.}
}
\description{
Include Shiny apps from a local clone of the SNAP shiny-apps repository in the local clone of the snapapps package.
}
\details{
This function will check (assuming default arguments) to see if local git repositories exist
for both the \code{snapapps} package and the SNAP \code{shiny-apps} repository.
This is assuming it is called with the \code{snapapps} directory as the working directory, that \code{source_path} is unchanged, and that they are
adjacent to each other.
For general use, change \code{base_path} to your source package root directory and
change \code{source_path} to whatever directory contains your existing apps.
By default, \code{use_apps} also assumes the package installed resources location for apps is be \code{"inst/shiny"}.

If \code{id} is a valid app directory in the latter, it will be copied to the former. \code{id} may be a vector.
This function should be used once per included app. It should only be reused (to update an app) if changes have not been made
to the copy previously placed in \code{snapapps} or you will lose those changes.

At this time, the canonical source is the \code{shiny-apps} repository, though this may swap to \code{snapapps} in the future
when critical mass favors the package, as well as more apps being includes from sources other than \code{shiny-apps}.

This function should be called for copying apps into the \code{snapapps} top level directory. It will place apps in \code{inst/shiny}.
Another base path should only be used if apps are to be copied to some other location that \code{snapapps} for some reason.
}
\examples{
\dontrun{use_apps(id = "rvdist")}
}
