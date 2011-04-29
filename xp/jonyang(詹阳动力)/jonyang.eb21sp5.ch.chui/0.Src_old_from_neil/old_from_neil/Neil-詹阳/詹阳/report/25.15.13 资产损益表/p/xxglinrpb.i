/* glinrpb.i - GENERAL LEDGER INCOME STATEMENT REPORT                         */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.11 $                                                           */
/*V8:ConvertMode=Report                                                       */
/* REVISION: 7.3            CREATED: 08/17/92   by: mpp *G030*                */
/* Revision: 8.5           MODIFIED: 03/18/98   By: *J242*  Sachin Shah       */
/* REVISION: 8.6E     LAST MODIFIED: 04/07/98   BY: AWe *L00S*                */
/* REVISION: 8.6E     LAST MODIFIED: 06/11/98   BY: *L01W* Brenda Milton      */
/* REVISION: 9.1      LAST MODIFIED: 08/14/00   BY: *N0L1* Mark Brown         */
/* REVISION: 9.1      LAST MODIFIED: 10/24/00   BY: *N0T4* Manish K.          */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.9  BY: Jean Miller DATE: 04/08/02 ECO: *P058* */
/* $Revision: 1.11 $ BY: Paul Donnelly (SB) DATE: 06/26/03 ECO: *Q00D* */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
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

mainloop:
for each asc_mstr
fields( asc_domain asc_acc asc_cc asc_fpos asc_sub)
    where asc_mstr.asc_domain = global_domain and  asc_fpos = fm_fpos and
   asc_sub >= sub and asc_sub <= sub1 and
   asc_cc >= ctr and asc_cc <= ctr1
no-lock
use-index {&idx} break by asc_fpos by {&break1} {&break2} {&break3}
on endkey undo, leave mainloop:

   for first ac_mstr
   fields( ac_domain ac_code ac_active ac_type ac_desc ac_curr)
   no-lock  where ac_mstr.ac_domain = global_domain and  ac_code=asc_acc: end.

   assign
      xacc = ac_code
      xsub = {&xtype1}
      xcc = {&xtype2}.

   if first-of({&test_field}) then
      assign balance = 0.

   {&comm1}
   if first-of({&test_field2}) then do:
      if sort_type=2 then do:
         for first cc_mstr fields( cc_domain cc_desc cc_ctr)
         no-lock  where cc_mstr.cc_domain = global_domain and  cc_ctr=asc_cc:
         end.
         put cc_desc at min(19,(cur_level * 2 + 1)).
      end.
      else do:
         for first sb_mstr fields( sb_domain sb_desc sb_sub)
         no-lock  where sb_mstr.sb_domain = global_domain and  sb_sub=asc_sub:
         end.
         put sb_desc at min(19,(cur_level * 2 + 1)).
      end.
   end.  /* if first-of({&test_field}) */
   {&comm2} */

   /* CALCULATE AMOUNT*/
   {glinrp2.i}

   if last-of({&test_field}) then do:
      if et_report_curr <> rpt_curr then do:
         {gprunp.i "mcpl" "p" "mc-curr-conv"
            "(input rpt_curr,
              input et_report_curr,
              input et_rate1,
              input et_rate2,
              input balance,
              input true,  /* ROUND */
              output et_balance,
              output mc-error-number)"}
         if mc-error-number <> 0 then do:
            {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
         end.
      end.  /* if et_report_curr <> rpt_curr */
      else
         assign et_balance = balance.

      if prt1000 then
         assign et_balance = round(et_balance / 1000, 0).
      else
      if roundcnts then
         assign et_balance = round(et_balance, 0).

      if prt1000 then balance = round(balance / 1000, 0).

      if level > cur_level and
         ((not zeroflag and (ac_active or et_balance <> 0)) or
          (zeroflag and et_balance <> 0))
      then do:
/* SS 090709.1 - B */
/*
         {glinrp1.i}
*/
         {xxglinrp1.i}
/* SS 090709.1 - E */
      end.

      if lookup(ac_type, "M,S") = 0 then do:
         assign
            tot[cur_level] = tot[cur_level] + balance
            et_tot[cur_level] = et_tot[cur_level] + et_balance.
      end.

   end.  /* if last-of({&test-field}) */

end.  /* for each asc_mstr */
