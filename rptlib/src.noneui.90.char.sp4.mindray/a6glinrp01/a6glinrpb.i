/* glinrpb.i - GENERAL LEDGER INCOME STATEMENT REPORT                    */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.  */
/*F0PN*/ /*V8:ConvertMode=Report                                         */
/* REVISION: 7.3            CREATED: 08/17/92   by: mpp *G030*           */
/* Revision: 8.5           MODIFIED: 03/18/98   By: *J242*  Sachin Shah  */
/* REVISION: 8.6E     LAST MODIFIED: 04/07/98   BY: AWe *L00S*           */
/* REVISION: 8.6E     LAST MODIFIED: 06/11/98   BY: *L01W* Brenda Milton */
/*!
    This code is the innermost loop for glinrp.  It was written to
    be generic enough to handle every one of the nine possible sort
    and summarization combinations by allowing the calling program
    to pass in break, index, and field information.
    test_field: the least significant field in the sort being printed.
    test_field2: the most significant field in the sort being printed.
    break[1-3]: breaks in order of the sort.  Fields not printed are
            not included in the break statement.
    idx: the index used to trace through the asc_mstr; determines the
         sort order for a particular fpos group.

*/
/*J242* GROUPED MULTIPLE FIELD ASSIGNMENTS INTO ONE
        FOR PERFORMANCE AND SMALLER R-CODE */

          mainloop:
          for each asc_mstr
/*J242*/  fields (asc_acc asc_cc asc_fpos asc_sub)
          where asc_fpos = fm_fpos and
                asc_sub >= sub and asc_sub <= sub1 and
                asc_cc >= ctr and asc_cc <= ctr1
          no-lock
          use-index {&idx} break by asc_fpos by
          {&break1} {&break2} {&break3}
          on endkey undo, leave mainloop:
/*J242**     find ac_mstr where ac_code=asc_acc no-lock no-error.  **/
              /* SS - Bill - B 2005.07.06 */
              /*
/*J242*/     for first ac_mstr fields (ac_code ac_active ac_type ac_desc
/*J242*/     ac_curr)
/*J242*/     no-lock where ac_code=asc_acc: end.
*/
/*J242*/     for first ac_mstr fields (ac_fpos ac_code ac_active ac_type ac_desc
/*J242*/     ac_curr)
/*J242*/     no-lock where ac_code=asc_acc: end.
/* SS - Bill - E */

/*J242*/     assign
                xacc = ac_code
                xsub = {&xtype1}
                xcc = {&xtype2}.
             if first-of({&test_field}) then assign balance = 0.
             {&comm1}
             if first-of({&test_field2}) then do:
                if sort_type=2 then do:
/*J242**           find cc_mstr where cc_ctr=asc_cc. **/
/*J242*/           for first cc_mstr fields (cc_desc cc_ctr)
/*J242*/           no-lock where cc_ctr=asc_cc: end.
/* SS - Bill - B 2005.07.06 */
/*
                   put cc_desc at min(19,(cur_level * 3 + 1)).
                   */
                   /* SS - Bill - E */
                end.
                else do:
/*J242**           find sb_mstr where sb_sub=asc_sub. **/
/*J242*/           for first sb_mstr fields (sb_desc sb_sub)
/*J242*/           no-lock where sb_sub=asc_sub: end.
/* SS - Bill - B 2005.07.06 */
/*
                   put sb_desc at min(19,(cur_level * 3 + 1)).
                   */
                   /* SS - Bill - E */
                end.
             end.  /* if first-of({&test_field}) */
             {&comm2} */

             /* CALCULATE AMOUNT*/
             {glinrp2.i}

             if last-of({&test_field}) then do:
/*L00S          ***** CONVERT AMOUNTS AFTER ROUNDING ***** */
/*L01W* /*L00S*/{etrpconv.i balance et_balance} */
/*L01W*/        if et_report_curr <> rpt_curr then do:
/*L01W*/           {gprunp.i "mcpl" "p" "mc-curr-conv"
                     "(input rpt_curr,
                       input et_report_curr,
                       input et_rate1,
                       input et_rate2,
                       input balance,
                       input true,  /* ROUND */
                       output et_balance,
                       output mc-error-number)"}
/*L01W*/           if mc-error-number <> 0 then do:
/*L01W*/              {mfmsg.i mc-error-number 2}
/*L01W*/           end.
/*L01W*/        end.  /* if et_report_curr <> rpt_curr */
/*L01W*/        else assign et_balance = balance.

/*L00S*/        if prt1000 then assign et_balance =
/*L00S*/           round(et_balance / 1000, 0).
/*L00S*/        else if roundcnts
                   then assign et_balance = round(et_balance, 0).

/*L00S          if prt1000 then balance = round(balance / 1000, 0).
 *              else if roundcnts then balance = round(balance, 0).
 */

/*L00S          if level > cur_level and ((not zeroflag and (ac_active or
 *              balance <> 0)) or (zeroflag and balance <> 0)) then do:
 *                 /* PRINT ACCOUNT AND BALANCE */
 *                 {glinrp1.i}
 *              end.
 */

/*L00S*ADD SECTION*/
                if level > cur_level and ((not zeroflag and (ac_active or
                et_balance <> 0)) or (zeroflag and et_balance <> 0))
                then do:
                    /* SS - Bill - B 2005.07.06 */
                    /*
                   {glinrp1.i}
                       */
                       {a6glinrp1.i}
                       /* SS - Bill - E */
                end.
/*L00S*END ADD SECTION*/

                if lookup(ac_type, "M,S") = 0 then
/*L00S*/        do:
/*L00S*/           assign
                      tot[cur_level] = tot[cur_level] + balance
/*L00S*/              et_tot[cur_level] = et_tot[cur_level] + et_balance.
/*L00S*/        end.
             end.  /* if last-of({&test-field}) */
          end.  /* for each asc_mstr */
