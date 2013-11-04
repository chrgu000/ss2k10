/* CHECK THE EFFECTIVE DATE                              */
/* To restrict previous month transaction entering on and after         */
/*             the 5th of each month and effective day should <= today  */
/* REVISION: 8.5    LAST MODIFIED: 07/13/01  BY: hkm *KR010*            */
/* REVISION: 8.5    LAST MODIFIED: 12/05/02  BY: hkm *nm1205*           */
/* 1. Prompt a Warning Message if today - Eff Date >= 5 days            */
/* REVISION: 8.5    LAST MODIFIED: 04/09/03  BY: hkm *030409*           */
/*               no trx with 10/01/06 to 10/03/06 BY:wt    *060930*         */
/* REVISION: 9.2  LAST MODIFIED:  08/13/08   BY: Apple Tam *SS-KI0807*      */

/*apple*/  define variable eff_date like glt_effdate.
/*apple*/  define variable dummy as logical initial no.
           define variable dd as integer.
           define variable mm as integer.
           define variable yy as integer.

           define var vdate1 like glt_effdate.
           define var vdate2 like glt_effdate.
/*nm1205*/ define variable continue like mfc_logical.
/*nm1205*/ define variable msg-temp like msg_desc.

/*apple*/  eff_date = date(tmp_effdate).

/*070503
/*070303
/*070113
/*061230
/*061004
/*051201*/     dd = 3.
  061004*/     dd = 6.   /* change for 10/01 - 10/03 */
  061230*/     dd = 4.   /* change cut-off date to 01/04/07 */
070113*/       dd = 3.   /* change cu-off day to 3 days */
070303*/       dd = 4.   /* change cut-off day to 4 for yq*/
070503*/
/*070602 /*070503*/  dd = 5. /* change cut-off date to 5 for labor holiday*/ */
/*070602*/     dd = 3.   /* back to normail */

/*0603 /***/      dd = 5. /* Physical take */ */
           mm = month(today).
           yy = year(today).
           vdate2 = date(mm,01,yy).     /* begins of current month */
           if mm = 1 then
              assign mm = 12
                     yy = yy - 1.
           else
              assign mm = mm - 1.
           vdate1 = date(mm,01,yy).     /* begins of prev. month */

           dummy = no.


           if eff_date = ?
             or eff_date > today
             or (day(today) >  dd and eff_date < vdate2)
             or (day(today) <= dd and eff_date < vdate1)
/*060930*/   or eff_date = 10/01/2006 or eff_date = 10/02/2006 or eff_date = 10/03/2006
/*061230*/   or eff_date = 01/01/2007 or eff_date = 01/02/2007 or eff_date = 01/03/2007
           then do:
             bell.
/*apple
/*nm**       message "錯誤: 生效日期錯誤, 請從新輸入.".  **/
       {mfmsg.i 27 3}   *apple*/
/*apple*/    if tmpstr <> "" then tmpstr = tmpstr + ",Invalid effective date" .
                else  tmpstr = "Invalid effective date" .

             dummy = yes.
           end.

/*apple
/*030409*/ if dummy = no then do:
/*030409*/   if today - eff_date >= 5 then do:
/*030409*/      continue = no.
/*030409*/      msg-temp = "Effective Date Before Today, Continue?".
/*030409*/      {xxmfmsg01.i msg-temp 2 continue}
/*030409*/      if continue = no then dummy = yes.
/*030409*/   end.
/*030409*/ end.
*apple*/