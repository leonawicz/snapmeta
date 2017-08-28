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
#' get_pkgs()
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
#' It includes SNAPverse satellite packages.
#'
#' @return a data frame.
#' @export
#'
#' @examples
#' sv_sections
sv_pkgs <- function(){
  secnames <- c("core", "functions", "data", "satellite")
  sections <- list(
    core=c("snapverse", "snaplite", "snapdata"),
    functions=c("snapfuns", "snapprep", "alfresco"),
    data=c("snapclim", "snapfire", "snappoly", "snapmaps", "snapdist"),
    satellite=c("rvtable", "apputils", "maputils", "snaputils", "snapsite", "snapmeta", "snapapps")

  )
  d <- tibble::data_frame(
    pkg=unlist(sections), section=rep(secnames, times=sapply(sections, length)), local=FALSE
  )
  x <- sv_local_pkgs()
  if(length(x)) d$local[d$pkg %in% x] <- TRUE
  d
}
