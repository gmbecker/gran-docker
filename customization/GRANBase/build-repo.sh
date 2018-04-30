#! /bin/bash
# Dinakar Kulkarni <kulkard2@gene.com>
# Build GRAN repository

source /home/gran/.Renviron

cat << RSCRIPT > build-repo.R
# Set error options
options(error=function() { traceback(2); quit(status=1) } )
library(GRANBase)

if (RCurl::url.exists("$GRAN_REPO_DEST_BASE_URL/getGRAN-$GRAN_REPO_NAME.R")) {
	source("$GRAN_REPO_DEST_BASE_URL/getGRAN-$GRAN_REPO_NAME.R")
	library(GRAN$GRAN_REPO_NAME)
	repo <- defaultGRAN()
	repo <- loadRepo(file.path(repo@param@base_dir, repo@param@repo_name, "repo.R"))
} else {
	repo <- loadRepo(file.path("/var/opt/gran", "repo.R"))
}

repo <- makeRepo(repo)

if (as.logical("$INSTALL_UPDATES")) {
  newpkgs = setdiff(available.packages(repo)[, "Package"] , installed.packages()[,"Package"])
  reps = c(repo_url(repo), "http://cran.rstudio.com/")
  if (length(newpkgs)) install.packages(newpkgs, repos = reps)
}
RSCRIPT

Rscript build-repo.R