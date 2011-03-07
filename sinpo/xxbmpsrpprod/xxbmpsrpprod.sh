#!/bin/sh
# Script to start multi-user session of MFG/PRO
 
# tokens:
# &DLC = Progress Directory
# &CLIENT-DB-CONNECT = command line to connect to each db in dbset
 
stty intr '^c'
DLC=/app/progress/10b;export DLC
. $DLC/bin/slib_env
PATH=$PATH:$DLC/bin:/bin;export PATH
PROMSGS=$DLC/promsgs;export PROMSGS
PROTERMCAP=$DLC/protermcap;export PROTERMCAP
PS1='$$ ';export PS1
PROPATH=.,/app/mfgpro/eb21,/app/mfgpro/eb21/bbi;export PROPATH
 
#
# Set terminal type.
#
if [ ${TERM:-NULL} = NULL ]
then  
    echo
    echo "Please enter your terminal type: \c"
    read TERM
    export TERM
fi
 
#
# Start MFG/PRO.
# 
cd 	# change to home directory
 
# exec $DLC/bin/_progres &DB etc
$DLC/bin/_progres -b -rereadnolock -c 30 -d mdy -yy 1990 -Bt 350 -D 100 -mmax 3000 -nb 200 -s 128 -noshvarfix -pf /app/mfgpro/eb21/Production.pf -p xxbmpsrp20au.p
