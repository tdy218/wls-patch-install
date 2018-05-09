#!/bin/sh

#/**
# * @Created on : 2016-8-16, 18:59:57
# * @Author tdy218
# */

if [ -n "$1" ]; then
  WL_HOME=$1
else
  echo "Bad argument to $(basename $0) provide."
  exit 1
fi

WORKING_DIR="`dirname $0`"

JAVA_HOME=`grep -w JAVA_HOME ${WL_HOME}/.product.properties | awk -F '=' '{print $2}'`
BEA_HOME=`grep -w BEAHOME ${WL_HOME}/.product.properties | awk -F '=' '{print $2}'`

if [ -n ${JAVA_HOME} -a -x ${JAVA_HOME}/bin/java ]; then
  echo "The java developer's kit's version is:"
  echo "-----------------------------------------"
  ${JAVA_HOME}/bin/java ${JAVA_BIT_MODE} -version

  if [ $? -ne 0 ]; then
     echo "Can not execute java executable program, the ${JAVA_HOME} may be incorrect."
     exit 1
  else
     printf '\nBegin to apply weblogic patch by smart update...\n\n'
  fi
else
  echo "Can not get the JAVA_HOME variable."
  exit 1
fi


export ANT_HOME=${WORKING_DIR}/ant
export ANT_OPTS="-Xmx2560m -XX:-UseGCOverheadLimit"
export PATH=${JAVA_HOME}/bin:${ANT_HOME}/bin:${PATH}

ant -Dbea.home=${BEA_HOME} \
    -Dwl.home=${WL_HOME} \
    -Djava.home=${JAVA_HOME} \
    -f ${WORKING_DIR}/xml/wls-patch-install.xml
