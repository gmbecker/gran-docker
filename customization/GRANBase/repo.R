new(
  "GRANRepository",
  results = structure(
    list(
      name = c(
        "switchr"
      ),
      status = c(
        NA
      ),
      version = c(
        NA
      ),
      lastAttempt = c(
        NA
      ),
      lastAttemptStatus = c(
        NA
      ),
      lastAttemptVersion = c(
        NA
      ),
      lastbuilt = c(
        NA
      ),
      lastbuiltversion = c(
        NA
      ),
      lastbuiltstatus = c(
        NA
      ),
      maintainer = c(
        NA
      ),
      suspended = c(FALSE),
      building = c(FALSE),
      revDepOf = c(""),
      revdepends = c(""),
      buildReason = c("")
    ),
    .Names = c(
      "name",
      "status",
      "version",
      "lastAttempt",
      "lastAttemptStatus",
      "lastAttemptVersion",
      "lastbuilt",
      "lastbuiltversion",
      "lastbuiltstatus",
      "maintainer",
      "suspended",
      "building",
      "revDepOf",
      "revdepends",
      "buildReason"
    ),
    row.names = c(NA,-1L),
    class = "data.frame"
  ),
  manifest = new(
    "SessionManifest",
    pkg_versions = structure(
      list(
        name = c(
          "switchr"
        ),
        version = c(
          NA_character_
        )
      ),
      .Names = c("name",
                 "version"),
      row.names = c(NA,-1L),
      class = "data.frame"
    ),
    pkg_manifest = new(
      "PkgManifest",
      manifest = structure(
        list(
          name = c(
            "switchr"
          ),
          url = c(
            "https://github.com/gmbecker/switchr"
          ),
          type = c("git"),
          branch = c(
            "master"
          ),
          subdir = c("."),
          extra = c(
            NA_character_
          )
        ),
        .Names = c("name", "url", "type", "branch", "subdir", "extra"),
        row.names = c(
          "1"
        ),
        class = "data.frame"
      ),
      dependency_repos = c(
        "http://bioconductor.org/packages/3.6/bioc",
        "http://bioconductor.org/packages/3.6/data/annotation",
        "http://bioconductor.org/packages/3.6/data/experiment",
        "http://bioconductor.org/packages/3.6/extra",
        "http://cran.rstudio.com"
      )
    )
  ),
  param = new(
    "RepoBuildParam",
    repo_name = Sys.getenv("GRAN_REPO_NAME"),
    base_dir = Sys.getenv("GRAN_BASE_DIR"),
    temp_repo = Sys.getenv("GRAN_TEMP_REPO"),
    temp_checkout = Sys.getenv("GRAN_TEMP_CHECKOUT"),
    errlog = Sys.getenv("GRAN_ERROR_LOG"),
    logfile = Sys.getenv("GRAN_COMPREHENSIVE_LOG"),
    tempLibLoc = Sys.getenv("GRAN_TEMP_LIBLOC"),
    check_warn_ok = as.logical(Sys.getenv("GRAN_CHECK_WARN_OK")),
    check_note_ok = as.logical(Sys.getenv("GRAN_CHECK_NOTE_OK")),
    extra_fun = function(...)
      NULL,
    auth = Sys.getenv("GRAN_SVN_AUTH"),
    dest_base = Sys.getenv("GRAN_REPO_DEST_BASE_DIR"),
    dest_url = Sys.getenv("GRAN_REPO_DEST_BASE_URL"),
    install_test = as.logical(Sys.getenv("GRAN_INSTALL_TEST")),
    check_test = as.logical(Sys.getenv("GRAN_CHECK_TEST")),
    suspended = character(0),
    use_cran_granbase = FALSE,
    build_timeout = 600,
    check_timeout = 900,
    email_notifications = as.logical(Sys.getenv("GRAN_EMAIL_NOTIFY")),
    email_opts = structure(
      list(
        smtp_server = Sys.getenv("GRAN_SMTP_SERVER"),
        smtp_port = Sys.getenv("GRAN_SMTP_PORT"),
        sender_email = Sys.getenv("GRAN_SENDER_EMAIL"),
        unsubscribers = NULL
      ),
      .Names = c("smtp_server", "smtp_port", "sender_email", "unsubscribers")
    ),
    repo_archive = character(0),
    logfun = function(pkg, msg, type = "full")
      writeGRANLog(
        pkg,
        msg,
        type,
        logfile = logfile(res),
        errfile = errlogfile(res),
        pkglog = pkg_log_file(pkg, res)
      ),
    shell_init = Sys.getenv("GRAN_SHELL_INIT"),
    archive_timing = 2,
    archive_retries = 2,
    dl_method = "auto",
    shell_timing = 1
  )
)
