/* glcbsrpb.i - GENERAL LEDGER COMPARATIVE BALANCE SHEET REPORT (PART IV) */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                    */
/* All rights reserved worldwide.  This is an unpublished work.           */
/*F0PN*/ /*V8:ConvertMode=Report                                          */
/*                            (Summarized sub-accounts)                   */
/* REVISION: 6.0          LAST MODIFIED:  10/09/90   BY: jms  *D034*      */
/*                                        01/22/91   by: jms  *D330*      */
/*                                        04/23/91   by: jms  *D577*      */
/*                                        09/05/91   by: jns  *D849*      */
/* REVISION: 7.0          LAST MODIFIED:  11/11/91   BY: jms  *F058*      */
/*                                           (major re-write)             */
/*                                        01/31/92  by: jms   *F119*      */
/*                                           (major re-write)             */
/*                                        04/14/92   by: jms  *F396*      */
/*                                        08/27/92   by: mpp  *G030*      */
/*                                        12/22/95   by: mys  *G1HF*      */
/* REVISION: 8.5      LAST MODIFIED:  03/24/97 BY: *J241* Jagdish Suvarna */
/* REVISION: 8.6E     LAST MODIFIED:  04/23/98 BY: LN/SVA *L00M*          */
/* REVISION: 8.6E     LAST MODIFIED:  06/11/98 BY: *L01W* Brenda Milton   */
/* REVISION: 8.6E     LAST MODIFIED:  08/04/98 BY: *J2QZ* Dana Tunstall   */
/* REVISION: 9.1      LAST MODIFIED:  08/14/00 BY: *N0L1* Mark Brown      */
/* REVISION: 9.1      LAST MODIFIED:  10/30/00 BY: *N0T4* Jyoti Thatte    */
/* REVISION: 9.1      LAST MODIFIED:  09/12/05 BY: *SS - 20050912* Bill Jiang    */

/*J241* GROUPED MULTIPLE FIELD ASSIGNMENTS INTO ONE FOR PERFORMANCE
    AND SMALLER R-CODE */

          mainloop:
          for each asc_mstr
/*J241*/  fields (asc_acc asc_sub asc_cc asc_fpos)
          where asc_fpos = fm_fpos
/*J2QZ*/        and ((asc_sub >= sub and asc_sub <= sub1 and
/*J2QZ*/              asc_cc  >= ctr and asc_cc  <= ctr1)
/*J2QZ*/              or asc_acc = pl)
          no-lock
          use-index {&idx} break by asc_fpos
          by {&break1} {&break2} {&break3}
          on endkey undo, leave mainloop:
/*J241**     find first ac_mstr where ac_code=asc_acc no-lock no-error.  **/
/*J241*/     for first ac_mstr
/*J241*/     fields (ac_code ac_desc ac_active ac_type ac_curr)
/*J241*/     where ac_code=asc_acc no-lock: end.
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
/*L01W* /*L00M*/   {etrpconv.i pl_amt[i] et_balance[i]} */

/*L01W*/           if et_report_curr <> rpt_curr then do:
/*L01W*/              {gprunp.i "mcpl" "p" "mc-curr-conv"
                        "(input rpt_curr,
                          input et_report_curr,
                          input et_rate1,
                          input et_rate2,
                          input pl_amt[i],
                          input true,    /* ROUND */
                          output et_balance[i],
                          output mc-error-number)"}
/*L01W*/              if mc-error-number <> 0 then do:
/*L01W*/                 {mfmsg.i mc-error-number 2}
/*L01W*/              end.
/*L01W*/           end.  /* if et_report_curr <> rpt_curr */
/*L01W*/           else assign et_balance[i] = pl_amt[i].

                   if prt1000 then
                      assign balance[i] = round(balance[i] / 1000, 0).
                   else if roundcnts then
                      assign balance[i] = round(balance[i], 0).
/*L00M*/           if prt1000 then
/*L00M*/              et_balance[i] = round(et_balance[i] / 1000, 0).
/*L00M*/           else if roundcnts then
/*L00M*/              et_balance[i] = round(et_balance[i], 0).
                end. /* END OF DO I LOOP */

                if level > cur_level and ((not zeroflag and
                (ac_active or balance[1] <> 0 or balance[2] <> 0
/*L00M*/        or et_balance[1] <> 0 or et_balance[2] <> 0
                )) or (zeroflag and (balance[1] <> 0 or
                balance[2] <> 0
/*L00M*/        or et_balance[1] <> 0 or et_balance[2] <> 0
                ))) then do:
                   /* PRINT ACCOUNT AND BALANCE */
                    /* SS - 20050912 - B */
                    /*
                   {glcbsrp1.i}
                       */
                    {a6glcbsrp1.i}
                       /* SS - 20050912 - E */
                end.
                if lookup(ac_type, "M,S") = 0 then
                   assign
                      tot[cur_level] = tot[cur_level] + balance[1]
                      tot1[cur_level] = tot1[cur_level] + balance[2]
/*L00M*/              et_tot[cur_level] = et_tot[cur_level] + et_balance[1]
/*L00M*/              et_tot1[cur_level] = et_tot1[cur_level] + et_balance[2].
             end.
             else do:
/*J2QZ**       BEGIN DELETE
 *                if not (asc_sub >= sub and asc_sub <= sub1 and
 *                asc_cc  >= ctr and asc_cc  <= ctr1) then next.
 *J2QZ**       END DELETE */

                if first-of({&test_field}) then
                   assign
                      balance[1] = 0
                      balance[2] = 0
/*L00M*/              et_balance[1] = 0
/*L00M*/              et_balance[2] = 0.

                  /* code between comm1 and comm2 is commented
                  ** out when sort_type = 0 or 4. */

                   {&comm1}

                   if first-of({&test_field2}) then do:
                      if sort_type=2 then do:
/*J241**                 find cc_mstr where cc_ctr=asc_cc.  **/
/*J241*/                 for first cc_mstr fields (cc_desc cc_ctr)
/*J241*/                 no-lock where cc_ctr=asc_cc: end.
/*N0T4**                 put cc_desc at min(19,(cur_level * 3 + 1)). */
/*N0T4*/                 put cc_desc at min(19,(cur_level * 2 + 1)).
                      end.
                      else do:
/*J241**                 find sb_mstr where sb_sub=asc_sub.  **/
/*J241*/                 for first sb_mstr fields (sb_desc sb_sub)
/*J241*/                 no-lock where sb_sub=asc_sub: end.
/*N0T4**                 put sb_desc at min(19,(cur_level * 3 + 1)). */
/*N0T4*/                 put sb_desc at min(19,(cur_level * 2 + 1)).
                      end.
                   end.
                   {&comm2} */

                   /* CALCULATE AMOUNT*/
                   {glcbsrp2.i}
                   if last-of({&test_field}) then do:
                      do i = 1 to 2:
                         if prt1000 then assign balance[i] =
                            round(balance[i] / 1000, 0).
                         else if roundcnts then assign balance[i] =
                            round(balance[i], 0).
/*L00M*/                 if prt1000 then et_balance[i] =
/*L00M*/                    round(et_balance[i] / 1000, 0).
/*L00M*/                 else if roundcnts then et_balance[i] =
/*L00M*/                    round(et_balance[i], 0).
                      end.
                      if level > cur_level and ((not zeroflag and (ac_active or
                      balance[1] <> 0 or balance[2] <> 0
/*L00M*/              or et_balance[1] <> 0 or et_balance[2] <> 0
                      )) or (zeroflag and (balance[1] <> 0 or balance[2] <> 0
/*L00M*/              or et_balance[1] <> 0 or et_balance[2] <> 0
                      )))
                      then do:
                         /* PRINT ACCOUNT AND BALANCE */
                          /* SS - 20050912 - B */
                          /*
                         {glcbsrp1.i}
                             */
                             {a6glcbsrp1.i}
                             /* SS - 20050912 - E */
                      end.
                      if lookup(ac_type, "M,S") = 0 then
                         assign
                            tot[cur_level] = tot[cur_level] + balance[1]
                            tot1[cur_level] = tot1[cur_level] + balance[2]
/*L00M*/                    et_tot[cur_level] = et_tot[cur_level] +
/*L00M*/                                        et_balance[1]
/*L00M*/                   et_tot1[cur_level] = et_tot1[cur_level] +
/*L00M*/                                        et_balance[2].
                   end.
                end.
             end.
