/* xxicindate.p - CHECK THE EFFECTIVE DATE                              */
/* To restrict previous month transaction entering on and after         */
/*             the 5th of each month and effective day should <= today  */
/* REVISION: 8.5    LAST MODIFIED: 07/13/01  BY: hkm *KR010*            */
/* REVISION: 8.5    LAST MODIFIED: 12/05/02  BY: hkm *nm1205*           */
/* 1. Prompt a Warning Message if today - Eff Date >= 5 days            */
/* REVISION: 8.5    LAST MODIFIED: 04/09/03  BY: hkm *030409*           */
/*               no trx with 10/01/06 to 10/03/06 BY:wt    *060930*     */ 
/* SSIVAN 07112701 BY:Ivan Yang Date:11/27/07				*/

           define shared variable eff_date like glt_effdate.
           define shared variable dummy as logical initial no.
           define variable dd as integer.
           define variable mm as integer.
           define variable yy as integer.

           define var vdate1 like glt_effdate.
           define var vdate2 like glt_effdate.
/*nm1205*/ define variable continue like mfc_logical.
/*nm1205*/ define variable msg-temp like msg_desc.

           {mfdeclre.i}

/* 030902      dd = 4.   /* 4 is the last day */ */
/* 051102 cut-off date changed to 2 temporary 
/*030902*/     dd = 3.
*/
/* 051201 back to 3 days
/* 051102 */   dd = 2.
*/
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
/*030303       dd = 9.   /* for temporary use */ */
 /**        
           dd = 10.  /* temp. for version upgrade * BY: William */
 **/

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

/*030409** MOVE TO BELOW **
./*nm1205*/ if today - eff_date >= 5 then do:
./*nm1205*/    continue = no.
./*nm1205*/    msg-temp = "Effective Date Before Today, Continue?".
./*nm1205*/    {xxmfmsg01.i msg-temp 2 continue}
./*nm1205*/    if continue = no then dummy = yes.
./*nm1205*/ end.
**030409**/

           if eff_date = ?
             or eff_date > today
             or (day(today) >  dd and eff_date < vdate2)  
             or (day(today) <= dd and eff_date < vdate1)
/*060930*/   or eff_date = 10/01/2006 or eff_date = 10/02/2006 or eff_date = 10/03/2006
/*061230*/   or eff_date = 01/01/2007 or eff_date = 01/02/2007 or eff_date = 01/03/2007
           then do:
             bell.
/*nm**       message "错误: 生效日期错误, 请从新输入.".  **/
	     {mfmsg.i 27 3}
             dummy = yes.
           end.

/*030409*/ if dummy = no then do:
/*030409*/   if today - eff_date >= 5 then do:
/*030409*/      continue = no.
/*SSIVAN 07112701 rmk*/ /*/*030409*/      msg-temp = "Effective Date Before Today, Continue?". */
/*SSIVAN 07112701 rmk*/ /*/*030409*/      {xxmfmsg01.i msg-temp 2 continue}  */
/*SSIVAN 07112701 add*/		{pxmsg.i &MSGNUM=9023 &ERRORLEVEL=2 &CONFIRM=continue}
/*030409*/      if continue = no then dummy = yes.
/*030409*/   end.
/*030409*/ end.
