#' Use apps from shiny-apps repo in snapapps package
#'
#' Include Shiny apps from a local clone of the SNAP shiny-apps repository in the local clone of the snapapps package.
#'
#' This function will check to see if local Git repositories exist for both the \code{snapapps} pacakge and the SNAP \code{shiny-apps} repository.
#' If \code{id} is a valid app directory in the latter, it will be copied to the former. \code{id} may be a vector.
#' This function should be used once per included app. It should only be reused (to update an app) if changes have not been made
#' to the copy previously placed in \code{snapapps} or you will lose those changes.
#'
#' At this time, the canonical source is the \code{shiny-apps} repository, though this may swap to \code{snapapps} in the future
#' when critical mass favors the package, as well as more apps being includes from sources other than \code{shiny-apps}.
#'
#' This function should be called for copying apps into the \code{snapapps} top level directory. It will place apps in \code{inst/shiny-examples}.
#' Another base path should only be used if apps are to be copied to some other location that \code{snapapps} for some reason.
#'
#' @param id character, app directory name.
#' @param base_path base file path.
#' @param overwrite logical, overwrite previously added apps.
#'
#' @export
#'
#' @examples
#' \dontrun{use_apps(id = "rvdist")}
use_apps <- function(id, base_path = ".", overwrite = FALSE){
  if(!file.exists("../shiny-apps"))
    stop("`shiny-apps` directory does not exist adjacent to parent directory.")
  if(any(!id %in% list.files("../shiny-apps")))
    stop("`id` must refer to an app in the local `shiny-apps` repository.")
  path <- file.path(base_path, "inst/shiny-examples")
  if(!file.exists(path)){
    message("inst/shiny-examples does not exist. Creating it now.")
    dir.create("inst/shiny-examples", recursive = TRUE, showWarnings = FALSE)
  }
  cur_files <- list.files(path)
  if(!length(cur_files)) cur_files <- NULL
  purrr::walk(id, ~(if(.x %in% cur_files & overwrite)
    unlink(file.path(path, .x), recursive = TRUE, force = TRUE)))
  purrr::walk(id, ~(if(!.x %in% cur_files || overwrite)
    dir.create(file.path(path, .x), recursive = TRUE, showWarnings = FALSE)))
  purrr::walk(id, ~(if(!.x %in% cur_files || overwrite){
    cat(paste("Copying app to:", file.path(path, .x)))
    file.copy(file.path("../shiny-apps", id), path, recursive = TRUE)
    })
  )
  purrr::walk(id, ~(if(!.x %in% cur_files || overwrite){
    if("rsconnect" %in% list.files(file.path(path, .x)))
      unlink(file.path(path, .x, "rsconnect"), recursive = TRUE, force = TRUE)
    })
  )
  invisible()
}
