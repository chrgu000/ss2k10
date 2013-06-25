/* glcinrpc.i - GENERAL LEDGER COMPARATIVE INCOME STATEMENT REPORT            */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.15 $                                                          */
/*V8:ConvertMode=Report                                                       */
/* REVISION: 7.3              CREATED: 08/27/92   by: mpp  *G030*             */
/* REVISION: 8.6        LAST MODIFIED: 03/18/98   BY: *J242* Sachin Shah      */
/* REVISION: 8.6E       LAST MODIFIED: 04/24/98   BY: LN/SVA  *L00W*          */
/* REVISION: 8.6E       LAST MODIFIED: 06/11/98   BY: *L01W* Brenda Milton    */
/* REVISION: 9.1        LAST MODIFIED: 08/14/00   BY: *N0L1* Mark Brown       */
/* REVISION: 9.1        LAST MODIFIED: 10/30/00   BY: *N0T4* Manish K.        */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.13  BY: Jean Miller DATE: 04/08/02 ECO: *P058* */
/* $Revision: 1.15 $ BY: Paul Donnelly (SB) DATE: 06/26/03 ECO: *Q00D* */
/* $Revision: 1.15 $ BY: Bill Jiang DATE: 08/16/07 ECO: *SS - 20070816.1* */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

mainloop:

for each asc_mstr
fields( asc_domain asc_fpos asc_acc asc_sub asc_cc)
    where asc_mstr.asc_domain = global_domain and  asc_fpos = fm_fpos and
         asc_sub >= sub and asc_sub <= sub1 and
         asc_cc >= ctr and asc_cc <= ctr1
no-lock
use-index {&idx} break by asc_fpos by {&break1} {&break2} {&break3}
on endkey undo, leave mainloop:

   for first ac_mstr
   fields( ac_domain ac_code ac_type ac_active ac_curr ac_desc)
       where ac_mstr.ac_domain = global_domain and  ac_code=asc_acc
   no-lock: end.

   assign
      xacc=ac_code
      xsub={&xtype1}
      xcc={&xtype2}.

   if first-of({&test_field}) then do:
      assign
         balance[1] = 0
         balance[2] = 0.
   end.

   {&comm1}
   if first-of({&test_field2}) then do:
      if sort_type=2 then do:
         for first cc_mstr fields( cc_domain cc_desc cc_ctr)
         no-lock  where cc_mstr.cc_domain = global_domain and  cc_ctr=asc_cc:
         end.
         /* SS - 20070816.1 - B */
         /*
         put cc_desc at min(9,(cur_level * 2 + 1)).
         */
         /* SS - 20070816.1 - E */
      end.
      else do:
         for first sb_mstr fields( sb_domain sb_desc sb_sub)
         no-lock  where sb_mstr.sb_domain = global_domain and  sb_sub=asc_sub:
         end.
         /* SS - 20070816.1 - B */
         /*
         put sb_desc at min(9,(cur_level * 2 + 1)).
         */
         /* SS - 20070816.1 - E */
      end.
   end.
   {&comm2} */

   /* CALCULATE AMOUNT*/
   {glcinrp2.i}

   if last-of({&test_field}) then do:

      do i = 1 to 2:

         if et_report_curr <> rpt_curr then do:
            {gprunp.i "mcpl" "p" "mc-curr-conv"
               "(input rpt_curr,
                 input et_report_curr,
                 input et_rate1,
                 input et_rate2,
                 input balance[i],
                 input true,    /* ROUND */
                 output et_balance[i],
                 output mc-error-number)"}
            if mc-error-number <> 0 then do:
               {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
            end.
         end.  /* if et_report_curr <> rpt_curr */
         else
            assign et_balance[i] = balance[i].

         /* SS - 20070816.1 - B */
         /*
         if prt1000 then assign et_balance[i] =
            round(et_balance[i] / 1000, 0).
         else if roundcnts then assign et_balance[i] =
            round(et_balance[i], 0).
         */
         if prt1000 then assign et_balance[i] =
            round(et_balance[i] / 1000, 2).
         else if roundcnts then assign et_balance[i] =
            round(et_balance[i], 2).
         /* SS - 20070816.1 - E */
      end.  /* do i = 1 to 2 */

      if level > cur_level and ((not zeroflag and (ac_active or
         et_balance[1] <> 0 or et_balance[2] <> 0)) or
         (zeroflag and (et_balance[1] <> 0 or et_balance[2] <> 0)))
      then do:
         /* PRINT ACCOUNT AND BALANCE */
         /* SS - 20070816.1 - B */
         /*
         {glcinrp1.i}
         */
         {ssglcinrp011.i}
         /* SS - 20070816.1 - E */
      end.

      if lookup(ac_type, "M,S") = 0 then do:
         assign
            tot[cur_level] = tot[cur_level] + balance[1]
            tot1[cur_level] = tot1[cur_level] + balance[2]
            et_tot[cur_level] = et_tot[cur_level] + et_balance[1]
            et_tot1[cur_level] = et_tot1[cur_level] + et_balance[2].
      end.

   end.

end.
