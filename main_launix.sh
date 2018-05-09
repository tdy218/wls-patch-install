#!/bin/sh

WORKING_DIR="`pwd`"
WL_INSTALLS=`find / -type d -name 'wlserver_10.3' 2>/dev/null`

if [ -n "${WL_INSTALLS}" ]; then
   for WL_INSTALL in ${WL_INSTALLS}
   do
        WL_USER=`ls -ld ${WL_INSTALL} | awk '{print $3}'`
        printf "\nFind the weblogic software installed: ${WL_INSTALL}, su ${WL_USER} user to install psu!\n\n"
        su - ${WL_USER} -c "sh ${WORKING_DIR}/install_patch.sh ${WL_INSTALL}"
        sleep 3
   done
else
   echo "No weblogic software installed on this machine!"
fi
