#! /bin/bash

source /home/gran/.Renviron
GRAN_DIRS="/var/lib/jenkins /var/log/jenkins /var/cache/jenkins \
  $GRAN_BASE_DIR `dirname $GRAN_ERROR_LOG` \
  `dirname $GRAN_COMPREHENSIVE_LOG` \
  $GRAN_REPO_DEST_BASE_DIR $GRAN_TEMP_REPO/$GRAN_REPO_NAME/src/contrib \
  $GRAN_TEMP_REPO/src/contrib \
  $GRAN_REPO_DEST_BASE_DIR/$GRAN_REPO_NAME/src/contrib \
  /var/www/html/gran /home/gran /usr/local/lib/R/site-library"
sudo mkdir -p $GRAN_DIRS && sudo chown -R gran:gran $GRAN_DIRS
touch $GRAN_TEMP_REPO/$GRAN_REPO_NAME/src/contrib/PACKAGES \
  $GRAN_TEMP_REPO/src/contrib/PACKAGES

# Create initial build report page
if [ ! -f $GRAN_TEMP_REPO/$GRAN_REPO_NAME/src/contrib/buildreport.html ]
then
  sudo mv /var/www/html/nobuildrpt.html $GRAN_REPO_DEST_BASE_DIR/$GRAN_REPO_NAME/src/contrib/buildreport.html
fi

# Create JSON rendition of the repo params
python /var/scripts/env2json.py /home/gran/.Renviron | sudo tee /var/www/html/repoparams.json