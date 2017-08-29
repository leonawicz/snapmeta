# Code snippets borrowed and modified from tidyverse: https://github.com/tidyverse
# but slightly more general to handle different SNAPverse package subsets (sectors of verse).
# Cannot import functions from tidyverse because they are not exported; will need to self-maintain.
# Only loads sector packages tidily; does not check for conflicts.

verse_attach <- function(core) {
  versions <- vapply(core, package_version, character(1))
  packages <- paste0(
    crayon::black("+ "), crayon::blue(format(core)), " ",
    crayon::col_align(versions, max(crayon::col_nchar(versions)))
  )

  info <- platform_info()
  info_name <- paste0(format(names(info), justify = "right"), ": ")
  info <- paste0(style_grey(0.6, info_name), style_grey(0.4, info))

  n <- max(length(packages), length(info))
  info <- c(info, rep("", n - length(info)))

  info <- paste0(packages, "      ", info, collapse = "\n")

  startup_message(info)
  suppressPackageStartupMessages(
    lapply(core, library, character.only = TRUE, warn.conflicts = FALSE)
  )

  invisible()
}

package_version <- function(x) {
  version <- as.character(unclass(utils::packageVersion(x))[[1]])

  if (length(version) > 3) {
    version[4:length(version)] <- crayon::bgRed(crayon::white(as.character(version[4:length(version)])))
  }
  crayon::black(paste0(version, collapse = "."))
}


platform_info <- function() {
  if (rstudioapi::isAvailable()) {
    ver <- rstudioapi::getVersion()
    ui <- paste0("RStudio ", ver, "")
  } else {
    ui <- .Platform$GUI
  }

  ver <- R.version

  c(
    Date = format(Sys.Date()),
    R = paste0(ver$major, ".", ver$minor),
    OS = os(),
    GUI = ui,
    Locale = Sys.getlocale("LC_COLLATE"),
    TZ = Sys.timezone()
  )
}

os <- function() {
  x <- utils::sessionInfo()$running

  # Regexps to clean up long windows strings generated at
  # https://github.com/wch/r-source/blob/af7f52f70101960861e5d995d3a4bec010bc89e6/src/library/utils/src/windows/util.c

  x <- gsub("Service Pack", "SP", x)
  x <- gsub(" [(]build \\d+[)]", "", x)

  x
}

is_attached <- function(x) {
  paste0("package:", x) %in% search()
}

startup_message <- function(...) {
  if (isTRUE(getOption("snapverse.quiet")))
    return()

  packageStartupMessage(...)
}

style_grey <- function(level, ...) {
  crayon::style(
    paste0(...),
    crayon::make_style(grDevices::grey(level), grey = TRUE)
  )
}
