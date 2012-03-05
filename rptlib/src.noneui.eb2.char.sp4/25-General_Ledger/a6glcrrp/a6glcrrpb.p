/* glcrrpb.p - GENERAL LEDGER CUSTOM REPORT PRINT (PART III)               */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                     */
/* All rights reserved worldwide.  This is an unpublished work.            */
/*F0PN*/
/*V8:ConvertMode=Report                                                    */
/*                  (Both sub-accounts and cost centers summarized)        */
/* REVISION: 7.0      LAST MODIFIED: 06/15/92   by: jms *F661*             */
/*                                                      (major revision)   */
/* REVISION: 8.6     LAST MODIFIED:  10/11/97   by: ays   *K0TL*           */
/* REVISION: 8.6E    LAST MODIFIED:  04/24/98   by: LN/SVA *L00S*          */
/* REVISION: 8.6E    LAST MODIFIED:  05/08/98   by: *J2JF* Niranjan R.     */
/* REVISION: 8.6E    LAST MODIFIED:  06/18/98   by: *L01W* Brenda Milton   */
/* REVISION: 9.1     LAST MODIFIED:  08/14/00   by: *N0L1* Mark Brown      */
/* REVISION: 9.1     LAST MODIFIED:  09/27/00   BY: *N0VY* Mudit Mehta     */
/* REVISION: 9.1     LAST MODIFIED:  09/14/05   BY: *SS - 20050914* Bill Jiang     */

          {mfdeclre.i}
/*N0VY*/  {cxcustom.i "GLCRRPB.P"}
          {wbrp02.i}

          /* DATA DEFINITIONS */
          {glcrrp3.i}

/*L00S*BEGIN ADD*/
          {etrpvar.i }
          {etvar.i   }
          define shared variable et_tot as decimal extent 100 no-undo.
          define shared variable et_tot1 like tot no-undo.
          define shared variable et_balance as decimal extent 2 no-undo.
          define variable et_variance as decimal.
/*L00S*END ADD*/

          find ac_mstr where recid(ac_mstr) = ac_recno no-lock.
          find glrd_det where recid(glrd_det) = g1_recno no-lock.

          xsub = "".
          xcc = "".

/*N0VY*/  {&GLCRRPB-P-TAG1}
          for each asc_mstr where asc_acc = xacc and
                   asc_sub >= sub and
                   asc_sub <= sub1 and
                   asc_cc >= ctr and
                   asc_cc <= ctr1
/*N0VY*/  {&GLCRRPB-P-TAG2}
                   no-lock break by asc_acc:

             if first-of(asc_acc) then balance = 0.

/*J2JF** BEGIN DELETE
 *           if asc_sub < glrd_sub or asc_sub > glrd_sub1 then next.
 *           if asc_cc < glrd_cc or asc_cc > glrd_cc1 then next.
 *J2JF** END DELETE */

/*J2JF*/     /* CALCULATE BALANCE ONLY WHEN ACCOUNT/SUB-ACCOUNT/COST CENTRE */
/*J2JF*/     /* COMBINATION EXISTS IN THE RANGE ASSIGNED TO FORMAT POSITION */

/*J2JF*/     if asc_sub >= glrd_sub and asc_sub <= glrd_sub1
/*J2JF*/        and asc_cc >= glrd_cc and asc_cc <= glrd_cc1 then do:

                /* CALCULATE BALANCE */
                {glcrrp2.i}

/*J2JF*/     end. /* IF asc_sub >= glrd_sub ... */

             if last-of(asc_acc) then do:
                do i = 1 to 2:
/*L01W* /*L00S*/   {etrpconv.i balance[i] et_balance[i]} */

/*L01W*/           if et_report_curr <> rpt_curr then do:
/*L01W*/              {gprunp.i "mcpl" "p" "mc-curr-conv"
                        "(input rpt_curr,
                          input et_report_curr,
                          input et_rate1,
                          input et_rate2,
                          input balance[i],
                          input true,    /* ROUND */
                          output et_balance[i],
                          output mc-error-number)"}
/*L01W*/              if mc-error-number <> 0 then do:
/*L01W*/                 {mfmsg.i mc-error-number 2}
/*L01W*/              end.
/*L01W*/           end.  /* if et_report_curr <> rpt_curr */
/*L01W*/           else assign et_balance[i] = balance[i].

/* SS - 20050914 - B */
/*
                   if prt1000 then balance[i] = round(balance[i] / 1000, 0).
                   else if roundcnts then balance[i] = round(balance[i], 0).
/*L00S*/           if prt1000 then et_balance[i] =
/*L00S*/              round(et_balance[i] / 1000, 0).
/*L00S*/           else if roundcnts
/*L00S*/              then et_balance[i] = round(et_balance[i], 0).
*/
                   if prt1000 then balance[i] = round(balance[i] / 1000, 2).
                   else if roundcnts then balance[i] = round(balance[i], 2).
/*L00S*/           if prt1000 then et_balance[i] =
/*L00S*/              round(et_balance[i] / 1000, 2).
/*L00S*/           else if roundcnts
/*L00S*/              then et_balance[i] = round(et_balance[i], 2).
/* SS - 20050914 - E */
                end.  /* do i = 1 to 12 */

                /* SS - 20050914 - B */
                /*
                if level > cur_level and ((not zeroflag and
/*L00S*         (ac_active or balance[1] <> 0 or balance[2] <> 0)) or */
/*L00S*/        (ac_active or et_balance[1] <> 0 or et_balance[2] <> 0)) or
/*L00S*         (zeroflag and (balance[1] <> 0 or balance[2] <> 0)))  */
/*L00S*/        (zeroflag and (et_balance[1] <> 0 or et_balance[2] <> 0)))
                then do:
                   /* PRINT ACCOUNT AND BALANCE */
                   {glcrrp1.i}
                end.
                   */
                   /* SS - 20050914 - E */
                if lookup(ac_type, "M") = 0 then
                   assign
                      tot[cur_level] = tot[cur_level] + balance[1]
                      tot1[cur_level] = tot1[cur_level] + balance[2]
/*L00S*/              et_tot[cur_level] = et_tot[cur_level] + et_balance[1]
/*L00S*/              et_tot1[cur_level] = et_tot1[cur_level] + et_balance[2].
             end.  /* if last-of(asc_acc) */
          end.  /* END OF ASC_MSTR LOOP */
          {wbrp04.i}
