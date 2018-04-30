#! /bin/bash
# Dinakar Kulkarni <kulkard2@gene.com>
# Rebuild GRAN package

source /home/gran/.Renviron

cat << RSCRIPT > rebuild-pkg.R
options(error=function() { traceback(2); quit(status=1) } )
library(GRANBase)

repodir = "/var/opt/gran"
pkg = "$PACKAGE_NAME"

if (RCurl::url.exists("$GRAN_REPO_DEST_BASE_URL/getGRAN-$GRAN_REPO_NAME.R")) {
	source("$GRAN_REPO_DEST_BASE_URL/getGRAN-$GRAN_REPO_NAME.R")
	library(GRAN$GRAN_REPO_NAME)
	repo <- defaultGRAN()
	repo <- loadRepo(file.path(repo@param@base_dir, repo@param@repo_name, "repo.R"))
} else {
	repo <- loadRepo(file.path("/var/opt/gran", "repo.R"))
}

if (!pkg %in% manifest_df(repo)\$name) {
  stop("The package ", pkg, " is NOT in the GRAN manifest.")
}

if (pkg %in% suspended_pkgs(repo)) {
  stop("The package ", pkg, " has been suspended in GRAN. Restore/unsuspend it first if you want it to build again.")
}

sprintf("Building package %s ..............", pkg)
makeRepo(repo, build_pkgs = pkg)

if (as.logical("$INSTALL_TO_LIBRARY") &&
    (pkg %in% available.packages(contrib.url(repo_url(repo)))[, "Package"])) {
  message("Installing Package: ", pkg, " into site library")
  reps <- c(repo_url(repo), "http://cran.rstudio.com/")
  install.packages(pkg, repos = reps)
} else {
  message("Not installing package in default library.")
}
RSCRIPT

Rscript rebuild-pkg.R
