#! /bin/bash
# Dinakar Kulkarni <kulkard2@gene.com>
# Add package to GRAN

source /home/gran/.Renviron

PACKAGE_URL=$1
SUBDIR=$2
BRANCH=$3
REPLACE=$4
INSTALL_TO_LIBRARY=$5

if [ $BRANCH == "none" ]
then
  GIT_BRANCH="master"
	SVN_BRANCH=""
fi

touch pkg
rm -rf pkg

git clone -b $GIT_BRANCH "$PACKAGE_URL" pkg
if [ $? -ne 0 ]
then
	svn co "$PACKAGE_URL/$SVN_BRANCH" pkg
  	if [ $? -ne 0 ]
    then
    	echo "Could not 'svn co $PACKAGE_URL/$SVN_BRANCH' or 'git clone -b $GIT_BRANCH' $PACKAGE_URL. Only git and svn supported."
    	exit 1
		else
			SCM_TYPE="svn"
    fi
else
	SCM_TYPE="git"
fi


if [ ! -f "pkg/$SUBDIR/DESCRIPTION" ]
then
	echo "$SUBDIR invalid or DESCRIPTION file not found"
    exit 1
fi

cat << RSCRIPT > add-pkg.R
library(switchr)
library(GRANBase)

options(error=function() { traceback(2); quit(status=1) })
options(repos=c(CRAN="http://cran.rstudio.com/"))

pkg = read.dcf(file = "pkg/$SUBDIR/DESCRIPTION", fields = c("Package"))  ## PACKAGE_NAME
pkg_url = "$PACKAGE_URL"  ## PACKAGE_URL
type = "$SCM_TYPE"  ## SCM_TYPE
branch = "$BRANCH"  ## BRANCH
subdir = "$SUBDIR" ## SUBDIR
replace = as.logical("$REPLACE") ## REPLACE
install_to_lib = as.logical("$INSTALL_TO_LIBRARY") ## INSTALL_TO_LIBRARY

if (branch == "none") {
  branch = NA_character_
}

if (RCurl::url.exists("$GRAN_REPO_DEST_BASE_URL/getGRAN-$GRAN_REPO_NAME.R")) {
	source("$GRAN_REPO_DEST_BASE_URL/getGRAN-$GRAN_REPO_NAME.R")
	library(GRAN$GRAN_REPO_NAME)
	repo <- defaultGRAN()
	repo <- loadRepo(file.path(repo@param@base_dir, repo@param@repo_name, "repo.R"))
} else {
	repo <- loadRepo(file.path("/var/opt/gran", "repo.R"))
}

if (is.null(repo)) {
  stop("No GRAN repo available.")
}

havepkg = pkg %in% manifest_df(repo)\$name

if (havepkg && !replace) {
  warning(
    "This package was already in the manifest for this repository, skipping. Set replace to TRUE to replace existing package."
  )
} else {
  repo_results(repo) = repo_results(repo)[, names(GRANBase:::ResultsRow())]
  man = manifest(repo)
  if (havepkg && replace) {
    codir = file.path(checkout_dir(repo), pkg)
    if (file.exists(codir) &&
        !identical(normalizePath(codir), normalizePath(checkout_dir(repo)))) {
      unlink(codir, recursive = TRUE)
		}
  }
  repo2 = tryCatch(
    addPkg(
      repo,
      name = pkg,
      url = pkg_url,
      type = type,
      branch = branch,
      subdir = subdir,
      replace = replace
    ),
    error = function(e) e
  )

	if (!is(repo2, "error")) {
	  repo = repo2
	  print("Attempting to build new package")
	  repo = makeRepo(repo, build_pkgs = pkg)
	} else {
	  stop(
	    "Failed to build: ", pkg
	  )
	}

	if (install_to_lib && (pkg %in% available.packages(contrib.url(repo_url(repo)))[, "Package"])) {
		install.packages(pkg, type = "source", repos = repo_url(repo))
	} else {
		message("Not installing package in default library.")
	}

}
RSCRIPT

Rscript add-pkg.R