#! /bin/bash
# Dinakar Kulkarni <kulkard2@gene.com>
# Clear GRAN repository

source /home/gran/.Renviron

cat << RSCRIPT > clear-repo.R
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

repo <- clear_repo(repo)
message("Cleared the repository. Resulting repo:")
repo
RSCRIPT

Rscript clear-repo.R
source /var/scripts/gran_init.sh
