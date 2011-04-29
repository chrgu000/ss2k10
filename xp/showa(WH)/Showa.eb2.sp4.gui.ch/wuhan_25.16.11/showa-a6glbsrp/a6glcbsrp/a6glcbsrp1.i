/* glcbsrp1.i - GENERAL LEDGER COMPARATIVE BALANCE SHEET REPORT--          */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                     */
/* All rights reserved worldwide.  This is an unpublished work.            */
/*F0PN*/ /*V8:ConvertMode=Report                                           */
/*                   SUBROUTINE TO DISPLAY ACCOUNTS AND AMOUNTS.           */
/* REVISION: 7.0      LAST MODIFIED: 11/11/91   BY: JMS   *F058*           */
/*                                   06/29/92   by: jms   *F714*           */
/* REVISION: 7.3      LAST MODIFIED: 06/28/96   BY: sdp   *G1Z0*           */
/* REVISION: 8.5      LAST MODIFIED: 03/24/97   BY: *J241* Jagdish Suvarna */
/* REVISION: 8.6E     LAST MODIFIED: APR 23 98  BY: LN/SVA   *L00M*        */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan      */
/* REVISION: 9.1      LAST MODIFIED: 09/10/99   BY: *N02V* Arul Victoria   */
/* REVISION: 9.1      LAST MODIFIED: 08/14/00   BY: *N0L1* Mark Brown      */
/* REVISION: 9.1      LAST MODIFIED: 10/30/00   BY: *N0T4* Jyoti Thatte    */
/* REVISION: 9.1      LAST MODIFIED: 09/12/05   BY: *SS - 20050912* Bill Jiang    */

/* SS - 091214.1  By: Roger Xiao */  /*add percentage format */
/***************************************************************************/
/*!
This include file prints the detail lines for the comparative balance sheet
report.
*/
/***************************************************************************/
/*J241* GROUPED MULTIPLE FIELD ASSIGNMENTS INTO ONE FOR PERFORMANCE
    AND SMALLER R-CODE */
      /* DISPLAY ACCOUNT */
      /* SS - 20050912 - B */
      /*
      if prtflag = no then do:
         {glacct.i &acc=xacc &sub=xsub &cc=xcc &acct=account}
/*G1Z0*      put account at min(19,(cur_level * 3 + 1)) ac_desc.  */
/*N0T4** /*G1Z0*/   put account at min(19,(cur_level * 3 + 1)) " " ac_desc. */
/*N0T4*/     put account at min(19,(cur_level * 2 + 1)) " " ac_desc.
      end.

/*N0T4**  else put ac_desc at min(19, (cur_level * 3 + 1)). */
/*N0T4*/  else put ac_desc at min(19, (cur_level * 2 + 1)).
*/
{glacct.i &acc=xacc &sub=xsub &cc=xcc &acct=account}
CREATE tta6glcbsrp.
ASSIGN
    tta6glcbsrp_code = account
    tta6glcbsrp_desc = ac_desc
    .
FIND FIRST ac_mstr WHERE ac_code = account NO-LOCK NO-ERROR.
IF AVAILABLE ac_mstr THEN
    ASSIGN
    tta6glcbsrp_fpos = ac_fpos
    .
/* SS - 20050912 - E */

      /* DISPLAY AMOUNTS */
/* SS - 20050912 - B */
/*
      if not fm_dr_cr then do:
         assign
         balance1[1] = - balance[1]
         balance1[2] = - balance[2]
/*L00M*/ et_balance1[1] = - et_balance[1].
/*L00M*/ et_balance1[2] = - et_balance[2].
/*L00M   variance = balance1[2] - balance1[1]. */
/*L00M*/ variance = et_balance1[2] - et_balance1[1].
/*F714*/     if balance1[2] <> 0 then do:
                assign
/*F714*/        varpct = (variance / balance1[2]) * 100
/*L00M*/        varpct = (variance / et_balance1[2]) * 100.
/*F714*/        pctchar = string(varpct, "->>>9.9%").
/*F714*/     end.
/*F714*/     else assign pctchar = "     **".
         if not budgflag[1] or not fmbgflag then
/*L00M      put string(balance1[1], prtfmt) format "x(20)" to 75. */

/*N02V* /*L00M*/    put string(et_balance1[1], prtfmt) format "x(20)" to 75.*/
/*N02V*/    put string(et_balance1[1], prtfmt) format "x(20)" to 79.

         if not budgflag[2] or not fmbgflag then
/*L00M      put string(balance1[2], prtfmt) format "x(20)" to 97. */

/*N02V* /*L00M*/    put string(et_balance1[2], prtfmt) format "x(20)" to 97. */
/*N02V*/    put string(et_balance1[2], prtfmt) format "x(20)" to 100.

         if varflag and not fmbgflag then

/*N02V*
 * /*F714*/        put string(variance, vprtfmt) format "x(20)" to 119
 * /*F714*/            pctchar to 129.
 *N02V*/

/*N02V*/        put string(variance, vprtfmt) format "x(20)" to 120
/*N02V*/            pctchar to 130.

         put skip.
      end.
      else do:
         assign
/*L00M   variance = balance[1] - balance[2]. */
/*L00M*/ variance = et_balance[1] - et_balance[2].
/*F714*/     if balance[2] <> 0 then do:
            assign
/*F714*/        varpct = (variance / balance[2]) * 100
/*L00M*/        varpct = (variance / et_balance[2]) * 100.
/*F714*/        pctchar = string(varpct, "->>>9.9%").
/*F714*/     end.
/*F714*/     else assign pctchar = "     **".
         if not budgflag[1] or not fmbgflag then
/*L00M      put string(balance[1], prtfmt) format "x(20)" to 75. */

/*N02V* /*L00M*/    put string(et_balance[1], prtfmt) format "x(20)" to 75. */
/*N02V*/    put string(et_balance[1], prtfmt) format "x(20)" to 79.

         if not budgflag[2] or not fmbgflag then
/*L00M      put string(balance[2], prtfmt) format "x(20)" to 97. */

/*N02V* /*L00M*/    put string(et_balance[2], prtfmt) format "x(20)" to 97. */
/*N02V*/    put string(et_balance[2], prtfmt) format "x(20)" to 100.

         if varflag and not fmbgflag then

/*N02V*
 * /*F714*/        put string(variance, vprtfmt) format "x(20)" to 119
 * /*F714*/            pctchar to 129.
 *N02V*/

/*N02V*/        put string(variance, vprtfmt) format "x(20)" to 120
/*N02V*/            pctchar to 130.

         put skip.
      end.
      */
      if not fm_dr_cr then do:
         assign
         balance1[1] = - balance[1]
         balance1[2] = - balance[2]
/*L00M*/ et_balance1[1] = - et_balance[1].
/*L00M*/ et_balance1[2] = - et_balance[2].
/*L00M   variance = balance1[2] - balance1[1]. */
/*L00M*/ variance = et_balance1[2] - et_balance1[1].
/*F714*/     if balance1[2] <> 0 then do:
                assign
/*F714*/        varpct = (variance / balance1[2]) * 100
/*L00M*/        varpct = (variance / et_balance1[2]) * 100.
/* SS - 091214.1 - B 
/*F714*/        pctchar = string(varpct, "->>>9.9%").
   SS - 091214.1 - E */
/* SS - 091214.1 - B */
pctchar = string(varpct, "->>>>>9.9%").
/* SS - 091214.1 - E */
/*F714*/     end.
/*F714*/     else assign pctchar = "     **".
         if not budgflag[1] or not fmbgflag then
             ASSIGN tta6glcbsrp_et_balance1 = et_balance1[1].
         if not budgflag[2] or not fmbgflag then
             ASSIGN tta6glcbsrp_et_balance2 = et_balance1[2].
      end.
      else do:
         assign
/*L00M   variance = balance[1] - balance[2]. */
/*L00M*/ variance = et_balance[1] - et_balance[2].
/*F714*/     if balance[2] <> 0 then do:
            assign
/*F714*/        varpct = (variance / balance[2]) * 100
/*L00M*/        varpct = (variance / et_balance[2]) * 100.
/* SS - 091214.1 - B 
/*F714*/        pctchar = string(varpct, "->>>9.9%").
   SS - 091214.1 - E */
/* SS - 091214.1 - B */
pctchar = string(varpct, "->>>>>9.9%").
/* SS - 091214.1 - E */
/*F714*/     end.
/*F714*/     else assign pctchar = "     **".
         if not budgflag[1] or not fmbgflag then
             ASSIGN tta6glcbsrp_et_balance1 = et_balance[1].
         if not budgflag[2] or not fmbgflag then
             ASSIGN tta6glcbsrp_et_balance2 = et_balance[2].
      end.
      /* SS - 20050912 - E */
             assign totflag[cur_level] = yes.
