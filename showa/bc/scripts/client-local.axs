TERM=vt100
export TERM
QAD=/app/mfgpro/eb2;export QAD
BC=/app/bc;export RF
XS=/app/bc/xs;export XS

DLC=/app/progress/dlc91d;export DLC
PATH=$PATH:$DLC;export PATH
PROMSGS=$DLC/promsgs;export PROMSGS
PROTERMCAP=$DLC/protermcap;export PROTERMCAP
PS1='$$ ';export PS1
PROPATH=.,$XS,$BC,$BC/labels,$BC/scripts,/app/mfgpro/eb2,/app/mfgpro/eb2/src,/app/mfgpro/eb2/us;/app/mfgpro/eb2/bbi;export PROPATH
cd $BC/tmp
rm -f *.i
rm -f *.o
rm -f *.l
rm -f *.tmp

exec $DLC/bin/_progres -c 30 -d mdy -yy 1920 -Bt 350 -D 100 -mmax 3000 -nb 200 -s 63 -noshvarfix -p $XS/xsmfa.p -pf /app/scripts/Demonstration.pf
exit
