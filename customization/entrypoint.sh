#! /bin/bash

# Create dirs and files
source /var/scripts/gran_init.sh

# Start the services
sudo service jenkins start
sudo service apache2 start

# Start RStudio Server, if it exists
if [ -f /usr/lib/rstudio-server/bin/rserver ]
then
  echo "Starting RStudio Server..."
  sudo rstudio-server start
  echo "Done."
fi

# Keep container alive
while true
do
  sleep 1
done
