/* glbsrpb.i - GENERAL LEDGER BALANCE SHEET REPORT SUBROUTINE                 */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.19 $                                                          */
/*V8:ConvertMode=Report                                                       */
/* REVISION: 7.3            CREATED:  8/13/92   BY: mpp  *G030*               */
/*                    LAST MODIFIED: 12/22/95   BY: mys  *G1HF*               */
/* REVISION: 8.5      LAST MODIFIED: 03/19/98   BY: *J240* Kawal Batra        */
/* REVISION: 8.6E     LAST MODIFIED: 04/24/98   BY: *L00S* D. Sidel           */
/* REVISION: 8.6E     LAST MODIFIED: 06/11/98   BY: *L01W* Brenda Milton      */
/* REVISION: 8.6E     LAST MODIFIED: 08/04/98   BY: *J2QZ* Dana Tunstall      */
/* REVISION: 8.6E     LAST MODIFIED: 09/08/99   BY: *L0HZ* Reetu Kapoor       */
/* REVISION: 9.1      LAST MODIFIED: 08/14/00   BY: *N0L1* Mark Brown         */
/* REVISION: 9.1      LAST MODIFIED: 10/24/00   BY: *N0T4* Jyoti Thatte       */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.16     BY: Jean Miller          DATE: 04/08/02  ECO: *P058*    */
/* Revision: 1.17  BY: Geeta Kotian DATE: 05/28/03 ECO: *P0TB* */
/* $Revision: 1.19 $ BY: Paul Donnelly (SB) DATE: 06/26/03 ECO: *Q00D* */
/* SS - 090708.1 By: Neil Gao */

/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*!
   This program loops through the asc_mstr and prints out each
   acct/sub/cc combo connected with the current format position.
   (glbsrpa traces through format position file.)  If a program sends
   a left comment delimiter through &comm2, this program will print
   a header just before it prints the accts and balances within the
   current format position.  For example, if the most significant
   sort field is the sub-acct, the name of the sub_accts will be
   printed at the top of each sub_acct group.  If the comment is
   sent through &comm1, the header-printing portion of the code
   will not be compiled.
*/

mainloop:
for each asc_mstr
   fields( asc_domain asc_fpos asc_sub asc_cc asc_acc)
    where asc_mstr.asc_domain = global_domain and (  asc_fpos = fm_fpos
   and ((asc_sub >= sub and asc_sub <= sub1 and
   asc_cc  >= ctr and asc_cc  <= ctr1) or asc_acc = pl)
) use-index {&idx} no-lock
break by asc_fpos by {&break1} {&break2} {&break3}
on endkey undo, leave mainloop:

   for first ac_mstr
   fields( ac_domain ac_code ac_type ac_active ac_curr ac_desc)
   no-lock  where ac_mstr.ac_domain = global_domain and  ac_code = asc_acc: end.

   assign
      xacc=ac_code
      xsub={&xtype1}
      xcc={&xtype2}.

   if xacc = pl then do:

      assign
         xsub = ""
         xcc = ""
         balance = pl_amt.

      if et_report_curr <> rpt_curr then do:
         {gprunp.i "mcpl" "p" "mc-curr-conv"
            "(input rpt_curr,
              input et_report_curr,
              input et_rate1,
              input et_rate2,
              input balance,
              input true,    /* ROUND */
              output et_balance,
              output mc-error-number)"}
         if mc-error-number <> 0 then do:
            {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
         end.
      end.  /* if et_report_curr <> rpt_curr */
      else assign et_balance = balance.

      if prt1000 then
         assign balance = round(balance / 1000, 0).
      else
      if roundcnts then
         assign balance = round(balance, 0).

      if prt1000 then
         et_balance = round(et_balance / 1000, 0).
      else if roundcnts then
         et_balance = round(et_balance, 0).

      if level > cur_level and
         ((not zeroflag and (ac_active=yes or balance <> 0 or et_balance <> 0))
         or (zeroflag and balance <> 0 or et_balance <> 0 ))
      then do:
         /* PRINT ACCOUNT AND BALANCE */
/* SS 090708.1 - B */
/*
         {glbsrp1.i}
*/
         {xxglbsrp1.i}
/* SS 090708.1 - E */
      end.

      if lookup(ac_type, "M,S") = 0 then
      do:
         assign
            tot[cur_level] = tot[cur_level] + balance.
         et_tot[cur_level] = et_tot[cur_level] + et_balance.
      end.
   end.
   else do:

      if first-of({&test_field}) then do:
         assign
            balance    = 0
            et_balance = 0.
      end.

      {&comm1}
      if first-of({&test_field2}) then do:
         if sort_type=2 then do:
            for first cc_mstr
            fields( cc_domain cc_desc)
            no-lock  where cc_mstr.cc_domain = global_domain and  cc_ctr =
            asc_cc: end.
            put cc_desc at min(19,(cur_level * 2 + 1)).
         end.
         else do:
            for first sb_mstr
            fields( sb_domain sb_desc)
            no-lock  where sb_mstr.sb_domain = global_domain and  sb_sub =
            asc_sub: end.
            put sb_desc at min(19,(cur_level * 2 + 1)).
         end.
      end.
      {&comm2} */

      /* CALCULATE AMOUNT */

      {glbsrp2.i}

      if last-of({&test_field}) then do:
         if prt1000 then
            assign balance = round(balance / 1000, 0).
         else if roundcnts then
            assign balance = round(balance, 0).

         if prt1000
         then
            et_balance = round(et_balance / 1000, 0).
         else
            if roundcnts
            then
               et_balance = round (et_balance , 0).

            if level > cur_level and
            ((not zeroflag and (ac_active or balance <> 0 or et_balance <> 0))
            or
            (zeroflag and balance <> 0 or et_balance <> 0)) then do:
            /* PRINT ACCOUNT AND BALANCE */
/* SS 090708.1 - B */
/*
            {glbsrp1.i}
*/
            {xxglbsrp1.i}
/* SS 090708.1 - E */
         end.
         if lookup(ac_type, "M,S") = 0 then do:
            tot[cur_level] = tot[cur_level] + balance.
            et_tot[cur_level] = et_tot[cur_level] + et_balance.
         end.

      end.  /*if*/

   end. /*else*/

end. /*for*/
