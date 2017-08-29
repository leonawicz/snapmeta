#' List local SNAPverse packages
#'
#' Generate a list of existing local SNAPverse packages.
#'
#' This function looks for packages beginning with the expression \code{^snap*} and sharing the same parent
#' directory as the current package/working directory. If \code{self = TRUE} (default),
#' the current working directory will be included in the list if applicable.
#'
#' @param base_path defaults to the parent directory of the working directory.
#' @param self logical, include the currently loaded package (working directory) if in the SNAPverse.
#'
#' @return a character vector.
#' @export
#'
#' @examples
#' sv_local_pkgs()
sv_local_pkgs <- function(base_path="../", self = TRUE){
  x <- list.files(base_path, pattern="^snap*")
  if(!self) x <- x[x != basename(getwd())]
  x
}

#' Location in the SNAPverse
#'
#' List the packages in and around the SNAPverse and their section of the verse.
#'
#' This function returns a 3-column data frame of all SNAPverse package names, their part of the verse,
#' and whether local git repositories/R projects sharing the same parent directory are found for each.
#' The list includes SNAPverse satellite packages, which are related to and often used in conjunction with,
#' but not a strict part of the SNAPverse.
#'
#' The other packages are considered core packages of the SNAPverse and fall into of three sectors of the verse:
#' functions, data or apps. The three packages listed as \code{sector} packages load different subsets of SNAPverse packages
#' for convenience. \code{snapverse} loads functions, data and apps packages. \code{snaplite} loads only the functions packages.
#' \code{snapdata} loads only the data packages. For most users, the packages most likely needed or of interst
#' are \code{snapfuns}, \code{snapapps} and any of the data packages.
#'
#' @return a data frame.
#' @export
#'
#' @examples
#' sv_pkgs
sv_pkgs <- function(){
  secnames <- c("sector", "functions", "data", "apps", "satellite")
  sections <- list(
    sector=c("snapverse", "snaplite", "snapdata"),
    functions=c("snapfuns", "snapprep", "alfresco"),
    data=c("snapclim", "snapfire", "snappoly", "snapmaps", "snapdist"),
    apps="snapapps",
    satellite=c("rvtable", "apputils", "maputils", "snaputils", "snapsite", "snapmeta")

  )
  d <- tibble::data_frame(
    pkg=unlist(sections), section=rep(secnames, times=sapply(sections, length)), local=FALSE
  )
  x <- sv_local_pkgs()
  if(length(x)) d$local[d$pkg %in% x] <- TRUE
  d
}
