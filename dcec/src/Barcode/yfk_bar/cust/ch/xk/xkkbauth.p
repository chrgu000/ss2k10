/*Modified by Traccy Zhang on 02/03/05 /*zx0202*/ */
/*Cai last modified by 05/20/2004*/
/*---------------------------------------------------
      2005-01-17, Yang Enping, 000A
          1. 性能调整
	  2. 解决knbd_det，kbc_ctrl的锁定问题
-----------------------------------------------------*/

{mfdtitle.i "2+ "}
{kbconst.i}

define variable a           as      char .
define variable b           as      inte .
define variable kbtr        like    kbtr_trans_nbr .

define buffer   xwusrwwkfl  for usrw_wkfl.
define var      xwusrwkfl_recno as recid.

find last kbtr_hist no-lock no-error .
if available kbtr_hist then kbtr = kbtr_trans_nbr .
else kbtr = 0 .

release kbc_ctrl .


for each usrw_wkfl where usrw_key1 = ("emptykb" + mfguser) and usrw_logfld[1]
    and usrw_charfld[12] = {&KB-CARDSTATE-EMPTYACC} NO-LOCK :
   {gprun.i ""xkkbtr.p""
            "({&KB-CARDEVENT-AUTHORIZE}, usrw_key2, today)"}
   pause 0 .
end.

for each usrw_wkfl where usrw_key1 = ("emptykb" + mfguser) and usrw_logfld[1]
    and usrw_charfld[12] = {&KB-CARDSTATE-EMPTYACC} no-lock :
    xwusrwkfl_recno = recid(usrw_wkfl).
    find xwusrwwkfl where recid(xwusrwwkfl) =  xwusrwkfl_recno exclusive-lock .

    find first kbtr_hist no-lock 
    where kbtr_trans_nbr > kbtr and kbtr_id = integer(xwusrwwkfl.usrw_key2) 
      and kbtr_transaction_event = {&KB-CARDEVENT-AUTHORIZE} NO-ERROR .
    if not available kbtr_hist then do:
        xwusrwwkfl.usrw_logfld[1] = no .
        next .
    end.

    find knbd_det no-lock 
    where knbd_id = integer(xwusrwwkfl.usrw_key2) .
    xwusrwwkfl.usrw_datefld[1] = knbd_authorize_date .
    xwusrwwkfl.usrw_decfld[1] = knbd_authorize_time .
    release xwusrwwkfl.
end. 



