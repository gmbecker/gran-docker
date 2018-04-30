#! /bin/bash
# Dinakar Kulkarni <kulkard2@gene.com>
# Suspend GRAN package

source /home/gran/.Renviron

cat << RSCRIPT > suspend-pkg.R
options(error=function() { traceback(2); quit(status=1) } )
options(repos=c(CRAN="http://cran.rstudio.com/"))

library(GRANBase)

if (RCurl::url.exists("$GRAN_REPO_DEST_BASE_URL/getGRAN-$GRAN_REPO_NAME.R")) {
	source("$GRAN_REPO_DEST_BASE_URL/getGRAN-$GRAN_REPO_NAME.R")
	library(GRAN$GRAN_REPO_NAME)
	repo <- defaultGRAN()
	repo <- loadRepo(file.path(repo@param@base_dir, repo@param@repo_name, "repo.R"))
} else {
	repo <- loadRepo(file.path("/var/opt/gran", "repo.R"))
}

pkg <- "$PACKAGE_NAME"

if ( (pkg %in% manifest_df(repo)\$name) && (!pkg == "") ) {
    suspended_pkgs(repo) <- unique(c(suspended_pkgs(repo), pkg))
    GRANBase:::saveRepoFiles(repo)
    message("Package called ", pkg, " is suspended in GRAN")
} else {
    stop("Package called ", pkg, " is not in GRAN")
}
RSCRIPT

Rscript suspend-pkg.R
