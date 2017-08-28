#' New R package reminders
#'
#' Print out a list of steps to take upon creating a new R package in RStudio.
#'
#' Adding the repo on GitHub (step 3) can be done any time prior to step 4.
#' The suggested steps are mostly universal except for the final two, which cater to SNAPverse defaults.
#' See \code{use_these} for details on defaults.
#'
#' @param pkg defaults to working directory.
#' @param account defaults to "leonawicz".
#'
#' @return \code{cat} a list of steps to the console.
#' @export
#'
#' @examples
#' reminders()
reminders <- function(pkg=basename(getwd()), account="leonawicz"){
  x <- paste0(
    "1. Create a new R package via New Project > R Package\n  with 'Create a git repository' checked.\n",
    "2. Make initial commit by adding the initial .Rbuildignore, .gitignore and [pkgname].Rproj files.\n",
    "3. Add the repo on GitHub:\n  ",
    "Use default settings (Do not create README.md).\n  ",
    "Set docs/ directory for hosting project website\n",
    "4. Then in git shell, enter:\n  ",
    paste0("git remote add origin git@github.com:", account, "/", pkg, ".git\n  "),
    "git push -u origin master\n",
    "5. Then return to R console and run:\n  ",
    "snapmeta::use_these()\n",
    "6. Add Travis CI, Appveyor and code coverage badges to README.Rmd and add projects on respective sites.\n",
    "7. Check the following:\n  ",
    "Delete absolute path to `docs` created by pkgdown in .Rbuildignore.\n  ",
    "Make initial updates to template files, e.g., README.Rmd, vignette Rmd file, LICENSE.md.\n  ",
    "Delete NAMESPACE so it can be auto-generated via devtools.\n  ",
    "At least one inital unit test is required to pass build.\n  ",
    "Commit changes, but hold off on cran-comments.md and revdep until meaningful.\n"
  )
  cat(x)
}

#' Package author and copyright holder/funder
#'
#' Specify the package author and the copyright holder/funder.
#'
#' This function is specific to the SNAPverse and is used as a default argument to \code{use_authors}.
#'
#' @param first author first name.
#' @param last author last name.
#' @param email author email address
#' @param cph_fnd copyright holder and funder.
#'
#' @return a list to be used by \code{use_authors}.
#' @export
#'
#' @examples
#' \dontrun{pkg_authors()}
pkg_authors <- function(first="Matthew", last="Leonawicz", email="mfleonawicz@alaska.edu",
                        cph_fnd=pkg_cph()){
  list(
    "Authors@R"=paste0(
      "c(",
      "person(\"", first, "\", \"", last, "\", email = \"", email, "\", role = c(\"aut\", \"cre\")),",
      "\n    person(\"", cph_fnd, "\", role = c(\"cph\", \"fnd\"))",
      "\n    )")
  )
}

#' Copyright holder
#'
#' Specify the copyright holder.
#'
#' This function simply returns its input, the copyright holder string. It is used as a default argument to \code{use_authors}.
#'
#' @param cph copyright holder.
#'
#' @return copyright holder.
#' @export
#'
#' @examples
#' pkg_cph()
pkg_cph <- function(cph="Scenarios Network for Alaska and Arctic Planning"){
  cph
}

#' Add author and license information to R package
#'
#' Add author and MIT license to DESCRIPTION and add license files to R package.
#' The defaults for this function cater to the SNAPverse.
#'
#' @param authors list as returned by \code{pkg_authors}.
#' @param cph copyright holder as returned by \code{pkg_cph}.
#'
#' @return side effect of updating DESCRIPTION and adding MIT license.
#' @export
#'
#' @examples
#' \dontrun{use_authors()}
use_authors <- function(authors=pkg_authors(), cph=pkg_cph()){
  usethis::use_description(authors)
  usethis::use_mit_license(cph)
}

#' Add \code{lintr} to R package
#'
#' Add scaffolding for \code{lintr} package usage to R package.
#'
#' This function creates a template \code{.lintr} file for SNAPverse packages inside \code{inst} and
#' adds a symbolic link to this file in the package root directory.
#' It also adds both files to \code{.Rbuildignore}.
#'
#' @param base_path package root directory.
#'
#' @return side effect of adding \code{lintr} scaffolding to package.
#' @export
#'
#' @examples
#' \dontrun{use_lintr()}
use_lintr <- function(base_path = "."){
  dir.create(file.path(base_path, "inst"), showWarnings=FALSE)
  sink("inst/.lintr")
  cat(paste0("linters: with_defaults(\n  ",
             "line_length_linter(120),\n  ",
             "infix_spaces_linter=NULL,\n  ",
             "camel_case_linter = NULL,\n  ",
             "snake_case_linter = NULL,\n  ",
             "spaces_left_parentheses_linter=NULL)\n"))
  sink()
  if(!file.exists(".lintr")) file.symlink("inst/.lintr", ".lintr")
  usethis::use_build_ignore(c(".lintr", "inst/.lintr"))
}

#' Add \code{clone_notes.md} to R package
#'
#' Add \code{clone_notes.md} to a SNAPverse R package.
#'
#' The created file is for tracking information unique to a package and helpful to know upon cloning
#' the repository, e.g., external locations of large data sets, available cached files, or other required files that are not tracked with git.
#'
#' @return side effect of creating file.
#' @export
#'
#' @examples
#' \dontrun{use_clone_notes}
use_clone_notes <- function(){
  sink("clone_notes.md")
  cat(paste0("# Clone this repository\n\n", "No notes for this respository.\n"))
  sink()
}

#' Wrapper function for package setup
#'
#' Wrapper function around several package creation/setup functions from the \code{usethis} and \code{snapmeta} packages.
#'
#' \code{use_these} calls the following functions: \code{use_authors}, \code{use_github_links}, \code{use_clone_notes},
#' \code{use_cran_comments},\code{use_data_raw}, \code{use_news_md}, \code{use_testthat}, \code{use_vignette},
#' \code{use_readme_rmd}, \code{use_revdep}, \code{use_lintr}, \code{use_appveyor}, \code{use_travis} and \code{use_coverage}.
#'
#' Authors, clone notes and \code{lintr} use are by \code{snapmeta} functions. The others are \code{usethis} package functions.
#' \code{pkgdown} for R package website building is also initialized, using a \code{pkgdown} directory in the package root
#' directory containing template \code{_pkgdown.yml} and \code{extra.css} files relevant to the SNAPverse.
#' The \code{docs} directory is used for website files and should be specified likewise in the repository settings on GitHub.
#'
#' \code{pkgdown::init_site} is also called.
#' \code{.Rbuildignore} is also updated. Make sure to remove the absolute path created by \code{pkgdown::init_site}.
#' Only retain the relative path to the \code{docs} directory.
#' Finally, it adds the following packages to \code{Suggests} in \code{DESCRIPTION}: \code{snapmeta}, \code{snapsite}.
#'
#' While this and other functions in \code{snapmeta} cater to the development of SNAPverse packages, functions like
#' \code{use_these} can still be useful for other SNAPverse satellite packages. But for these, there may be no need to add
#' packages like \code{snapmeta} and \code{snapsite} under \code{Suggests} in \code{DESCRIPTION}.
#' Setting to \code{FALSE} will leave out any such SNAPverse developer suggested packages.
#'
#' @param pkg defaults to the name of the working directory.
#' @param authors list as generated by \code{pkg_authors}.
#' @param cph copyright holder as generated by \code{pkg_cph}.
#' @param snapverse logical, whether \code{pkg} is part of the SNAPverse. Defaults to \code{TRUE}. See details.
#'
#' @return side effect of setting up various package files and configurations.
#' @export
#'
#' @examples
#' \dontrun{use_these()}
use_these <- function(pkg=basename(getwd()), authors=pkg_authors(), cph=pkg_cph(), snapverse=TRUE){
  snapmeta::use_authors(authors, cph)
  usethis::use_github_links()
  snapmeta::use_clone_notes()
  usethis::use_cran_comments()
  usethis::use_data_raw()
  usethis::use_news_md()
  usethis::use_testthat()
  if(!file.exists(paste0("vignettes/", pkg, ".Rmd"))) usethis::use_vignette(pkg)
  usethis::use_readme_rmd()
  usethis::use_revdep()
  snapmeta::use_lintr()
  pkgdown::init_site()
  pdfiles <- list.files(file.path(system.file(package="snapmeta"), "resources/pkgdown"),
                        full.names = TRUE)
  dir.create("pkgdown", showWarnings = FALSE)
  file.copy(pdfiles, file.path("pkgdown", basename(pdfiles)), overwrite = TRUE)
  usethis::use_build_ignore(c("docs", "pkgdown", "clone_notes.md"))
  usethis::use_appveyor()
  usethis::use_travis()
  usethis::use_coverage()
  if(snapverse){
    if(pkg != "snapmeta") usethis::use_package("snapmeta", "Suggests")
    if(pkg != "snapsite") usethis::use_package("snapsite", "Suggests")
  }
}
