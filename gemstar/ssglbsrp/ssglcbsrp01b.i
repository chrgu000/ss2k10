/* glcbsrpb.i - GENERAL LEDGER COMPARATIVE BALANCE SHEET REPORT (PART IV)     */
/* Copyright 1986-2005 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/*                            (Summarized sub-accounts)                       */
/* REVISION: 6.0          LAST MODIFIED:  10/09/90   BY: jms  *D034*          */
/*                                        01/22/91   by: jms  *D330*          */
/*                                        04/23/91   by: jms  *D577*          */
/*                                        09/05/91   by: jns  *D849*          */
/* REVISION: 7.0          LAST MODIFIED:  11/11/91   BY: jms  *F058*          */
/*                                           (major re-write)                 */
/*                                        01/31/92  by: jms   *F119*          */
/*                                           (major re-write)                 */
/*                                        04/14/92   by: jms  *F396*          */
/*                                        08/27/92   by: mpp  *G030*          */
/*                                        12/22/95   by: mys  *G1HF*          */
/* REVISION: 8.5      LAST MODIFIED:  03/24/97 BY: *J241* Jagdish Suvarna     */
/* REVISION: 8.6E     LAST MODIFIED:  04/23/98 BY: LN/SVA *L00M*              */
/* REVISION: 8.6E     LAST MODIFIED:  06/11/98 BY: *L01W* Brenda Milton       */
/* REVISION: 8.6E     LAST MODIFIED:  08/04/98 BY: *J2QZ* Dana Tunstall       */
/* REVISION: 9.1      LAST MODIFIED:  08/14/00 BY: *N0L1* Mark Brown          */
/* REVISION: 9.1      LAST MODIFIED:  10/30/00 BY: *N0T4* Jyoti Thatte        */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.12     BY: Paul Donnelly (SB)  DATE: 06/26/03   ECO: *Q00D*    */
/* Revision: 1.14     BY: Jean Miller         DATE: 03/03/04   ECO: *Q069*    */
/* $Revision: 1.17 $       BY: Priya Idnani        DATE: 12/03/05   ECO: *P4B1*    */
/* $Revision: 1.17 $       BY: Bill Jiang        DATE: 08/15/07   ECO: *SS - 20070815.1*    */
/*-Revision end---------------------------------------------------------------*/

/*V8:ConvertMode=Report                                                       */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/


mainloop:
for each asc_mstr
   fields(asc_domain asc_acc asc_sub asc_cc asc_fpos)
   where asc_domain = global_domain
     and (asc_fpos = fm_fpos
     and ((asc_sub >= sub and asc_sub <= sub1 and
           asc_cc  >= ctr and asc_cc  <= ctr1)
        or asc_acc = pl))
no-lock
use-index {&idx} break by asc_fpos
                       by {&break1} {&break2} {&break3}
on endkey undo, leave mainloop:

   for first ac_mstr
      /* SS - 20070815.1 - B */
      /*
      fields(ac_domain ac_code ac_desc ac_active ac_type ac_curr)
      */
      /* SS - 20070815.1 - E */
      where ac_domain = global_domain and ac_code=asc_acc
   no-lock: end.

   assign
      xacc=ac_code
      xsub={&xtype1}
      xcc={&xtype2}.

   if xacc = pl then do:

      assign
         xsub = ""
         xcc = "".

      do i = 1 to 2:

         assign balance[i] = pl_amt[i].

         if et_report_curr <> rpt_curr then do:
            {gprunp.i "mcpl" "p" "mc-curr-conv"
               "(input rpt_curr,
                 input et_report_curr,
                 input et_rate1,
                 input et_rate2,
                 input pl_amt[i],
                 input true,    /* ROUND */
                 output et_balance[i],
                 output mc-error-number)"}
            if mc-error-number <> 0 then do:
               {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
            end.
         end.  /* if et_report_curr <> rpt_curr */

         else
            assign et_balance[i] = pl_amt[i].

         if prt1000 then
            assign balance[i] = round(balance[i] / 1000, 0).
         else if roundcnts then
            assign balance[i] = round(balance[i], 0).

         if prt1000 then
            et_balance[i] = round(et_balance[i] / 1000, 0).
         else if roundcnts then
            et_balance[i] = round(et_balance[i], 0).

      end. /* END OF DO I LOOP */

      if level > cur_level and ((not zeroflag and
         (ac_active or balance[1] <> 0 or balance[2] <> 0
      or et_balance[1] <> 0 or et_balance[2] <> 0))
      or (zeroflag and (balance[1] <> 0 or balance[2] <> 0
      or et_balance[1] <> 0 or et_balance[2] <> 0)))
      then do:

         /* PRINT ACCOUNT AND BALANCE */
         if prtflag = no then do:
            {glacct.i &acc=xacc &sub=xsub &cc=xcc &acct=account}
            /* SS - 20070815.1 - B */
            /*
            put account at min(19,(cur_level * 2 + 1)) " " ac_desc.
            */
            /* SS - 20070815.1 - E */
         end.
         /* SS - 20070815.1 - B */
         /*
         else
            put ac_desc at min(19, (cur_level * 2 + 1)).
         */
         CREATE ttssglcbsrp01.
         ASSIGN
            ttssglcbsrp01_ac_code = ac_code
            .
         /* SS - 20070815.1 - E */

         /* DISPLAY AMOUNTS */
         if not fm_dr_cr then do:

            assign
               balance1[1] = - balance[1]
               balance1[2] = - balance[2]
               et_balance1[1] = - et_balance[1].
               et_balance1[2] = - et_balance[2].

            variance = et_balance1[2] - et_balance1[1].

            if balance1[2]               <> 0
               and abs(variance
                       / et_balance1[2]) < 100
            then
               assign
                  varpct = (variance / balance1[2]) * 100
                  varpct = (variance / et_balance1[2]) * 100
                  pctchar = string(varpct, "->>>9.9%").
            else
               assign pctchar = "     **".

            /* SS - 20070815.1 - B */
            /*
            if not budgflag[1] or not fmbgflag then
               put string(et_balance1[1], prtfmt) format "x(20)" to 79.

            if not budgflag[2] or not fmbgflag then
               put string(et_balance1[2], prtfmt) format "x(20)" to 100.

            if varflag and not fmbgflag then
               put string(variance, vprtfmt) format "x(20)" to 120
               pctchar to 130.

            put skip.
            */
               if not budgflag[1] or not fmbgflag THEN DO:
                  ASSIGN ttssglcbsrp01_et_balance[1] = et_balance1[1].
               END.

               if not budgflag[2] or not fmbgflag THEN DO:
                  ASSIGN ttssglcbsrp01_et_balance[2] = et_balance1[2].
               END.

            /* SS - 20070815.1 - E */

         end.

         else do:
            assign
               variance = et_balance[1] - et_balance[2].

            if balance[2]               <> 0
               and abs(variance
                       / et_balance[2]) < 100
            then
               assign
                  varpct = (variance / balance[2]) * 100
                  varpct = (variance / et_balance[2]) * 100
                  pctchar = string(varpct, "->>>9.9%").
            else
               assign pctchar = "     **".

            /* SS - 20070815.1 - B */
            /*
            if not budgflag[1] or not fmbgflag then
               put string(et_balance[1], prtfmt) format "x(20)" to 79.

            if not budgflag[2] or not fmbgflag then
               put string(et_balance[2], prtfmt) format "x(20)" to 100.

            if varflag and not fmbgflag then
               put string(variance, vprtfmt) format "x(20)" to 120
               pctchar to 130.

            put skip.
            */
            if not budgflag[1] or not fmbgflag THEN DO:
               ASSIGN ttssglcbsrp01_et_balance[1] = et_balance[1].
            END.

            if not budgflag[2] or not fmbgflag THEN DO:
               ASSIGN ttssglcbsrp01_et_balance[2] = et_balance[2].
            END.
            /* SS - 20070815.1 - E */

         end.

         assign totflag[cur_level] = yes.

      end.

      if lookup(ac_type, "M,S") = 0 then
         assign
            tot[cur_level] = tot[cur_level] + balance[1]
            tot1[cur_level] = tot1[cur_level] + balance[2]
            et_tot[cur_level] = et_tot[cur_level] + et_balance[1]
            et_tot1[cur_level] = et_tot1[cur_level] + et_balance[2].

   end.

   else do:

      if first-of({&test_field}) then
         assign
            balance[1] = 0
            balance[2] = 0
            et_balance[1] = 0
            et_balance[2] = 0.

      /* Code between comm1 and comm2 commented out when sort_type = 0 or 4. */
      {&comm1}

      if first-of({&test_field2}) then do:

         if sort_type=2 then do:

            for first cc_mstr
               fields( cc_domain cc_desc cc_ctr)
               where cc_domain = global_domain and
                     cc_ctr=asc_cc
            no-lock: end.

            /* SS - 20070815.1 - B */
            /*
            put
               cc_desc at min(19,(cur_level * 2 + 1)).
            */
            /* SS - 20070815.1 - E */

         end.

         else do:

            for first sb_mstr
               fields(sb_domain sb_desc sb_sub)
               where sb_domain = global_domain and
                     sb_sub = asc_sub
            no-lock: end.

            /* SS - 20070815.1 - B */
            /*
            put
               sb_desc at min(19,(cur_level * 2 + 1)).
            */
            /* SS - 20070815.1 - E */

         end.

      end.

      {&comm2} */

      /* CALCULATE AMOUNT*/
      {glcbsrp2.i}

      if last-of({&test_field}) then do:

         do i = 1 to 2:

            if prt1000 then
               assign
                  balance[i] = round(balance[i] / 1000, 0).
            else if roundcnts then
               assign
                  balance[i] = round(balance[i], 0).

            if prt1000 then
               et_balance[i] = round(et_balance[i] / 1000, 0).
            else if roundcnts then
               et_balance[i] = round(et_balance[i], 0).

         end.

         if level > cur_level and ((not zeroflag and
            (ac_active or balance[1] <> 0 or balance[2] <> 0 or
             et_balance[1] <> 0 or et_balance[2] <> 0 ))
         or (zeroflag and (balance[1] <> 0 or balance[2] <> 0
         or et_balance[1] <> 0 or et_balance[2] <> 0 )))
         then do:

            /* PRINT ACCOUNT AND BALANCE */
            if prtflag = no then do:
               {glacct.i &acc=xacc &sub=xsub &cc=xcc &acct=account}
               /* SS - 20070815.1 - B */
               /*
               put account at min(19,(cur_level * 2 + 1)) " " ac_desc.
               */
               /* SS - 20070815.1 - E */
            end.
            /* SS - 20070815.1 - B */
            /*
            else
               put ac_desc at min(19, (cur_level * 2 + 1)).
            */
            CREATE ttssglcbsrp01.
            ASSIGN
               ttssglcbsrp01_ac_code = ac_code
               .
            /* SS - 20070815.1 - E */

            /* DISPLAY AMOUNTS */
            if not fm_dr_cr then do:

               assign
                  balance1[1] = - balance[1]
                  balance1[2] = - balance[2]
                  et_balance1[1] = - et_balance[1].
                  et_balance1[2] = - et_balance[2].
               variance = et_balance1[2] - et_balance1[1].

               if balance1[2] <> 0
                  and abs(variance
                          / et_balance1[2]) < 100
               then do:
                  assign
                     varpct = (variance / balance1[2]) * 100
                     varpct = (variance / et_balance1[2]) * 100.
                     pctchar = string(varpct, "->>>9.9%").
               end.
               else
                  assign pctchar = "     **".

               /* SS - 20070815.1 - B */
               /*
               if not budgflag[1] or not fmbgflag then
                  put string(et_balance1[1], prtfmt) format "x(20)" to 79.

               if not budgflag[2] or not fmbgflag then
                  put string(et_balance1[2], prtfmt) format "x(20)" to 100.

               if varflag and not fmbgflag then
                  put string(variance, vprtfmt) format "x(20)" to 120
                  pctchar to 130.

               put skip.
               */
               if not budgflag[1] or not fmbgflag THEN DO:
                  ASSIGN ttssglcbsrp01_et_balance[1] = et_balance1[1].
               END.

               if not budgflag[2] or not fmbgflag THEN DO:
                  ASSIGN ttssglcbsrp01_et_balance[2] = et_balance1[2].
               END.
               /* SS - 20070815.1 - E */

            end.

            else do:

               assign
                  variance = et_balance[1] - et_balance[2].

               if balance[2] <> 0
                  and abs(variance
                          / et_balance[2]) < 100
               then do:
                  assign
                     varpct = (variance / balance[2]) * 100
                     varpct = (variance / et_balance[2]) * 100.
                     pctchar = string(varpct, "->>>9.9%").
               end.
               else
                  assign pctchar = "     **".

               /* SS - 20070815.1 - B */
               /*
               if not budgflag[1] or not fmbgflag then
                  put string(et_balance[1], prtfmt) format "x(20)" to 79.

               if not budgflag[2] or not fmbgflag then
                  put string(et_balance[2], prtfmt) format "x(20)" to 100.

               if varflag and not fmbgflag then
                  put string(variance, vprtfmt) format "x(20)" to 120
                  pctchar to 130.

               put skip.
               */
               if not budgflag[1] or not fmbgflag THEN DO:
                  ASSIGN ttssglcbsrp01_et_balance[1] = et_balance[1].
               END.

               if not budgflag[2] or not fmbgflag THEN DO:
                  ASSIGN ttssglcbsrp01_et_balance[2] = et_balance[2].
               END.
               /* SS - 20070815.1 - E */

            end.

            assign totflag[cur_level] = yes.

         end.

         if lookup(ac_type, "M,S") = 0 then
            assign
               tot[cur_level] = tot[cur_level] + balance[1]
               tot1[cur_level] = tot1[cur_level] + balance[2]
               et_tot[cur_level] = et_tot[cur_level] + et_balance[1]
               et_tot1[cur_level] = et_tot1[cur_level] + et_balance[2].

      end.

   end.

end.
