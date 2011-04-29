/* gl4inrpb.i - GENERAL LEDGER INCOME STATEMENT REPORT                        */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.9 $                                                           */
/*V8:ConvertMode=Report                                                       */
/* REVISION: 7.3            CREATED: 08/17/92   by: mpp  *G030*               */
/*                    LAST MODIFIED: 05/17/96   by: jzw  *G1VY*               */
/* Revision: 8.5           MODIFIED: 03/12/98   By: *J23W*  Sachin Shah       */
/* REVISION: 8.6E     LAST MODIFIED: 24 apr 98  BY: *L00M* D. Sidel  rev only */
/* Revision: 8.6E          MODIFIED: 10/04/98   By: *J314* Alfred Tan         */
/* Revision: 9.1           MODIFIED: 08/14/00   By: *N0L1* Mark Brown         */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.8       BY: Paul Donnelly (SB)    DATE: 06/26/03  ECO: *Q00D*  */
/* $Revision: 1.9 $    BY: Jean Miller           DATE: 08/18/04  ECO: *Q0CD*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*!
This code is the innermost loop for gl4inrp.  It was written to be generic
enough to handle every one of the nine possible sort and summarization
combinations by allowing the calling program to pass in break, index, and
field information.
test_field: the least significant field in the sort being printed.
test_field2: the most significant field in the sort being printed.
break[1-3]: breaks in order of the sort.  Fields not printed are
not included in the break statement.
idx: the index used to trace through the asc_mstr; determines the
sort order for a particular fpos group.
*/

mainloop:
for each asc_mstr
   fields( asc_domain asc_acc asc_sub asc_cc asc_fpos)
   where asc_domain = global_domain
     and asc_fpos = fm_fpos
     and asc_sub >= sub and asc_sub <= sub1
     and asc_cc >= ctr and asc_cc <= ctr1
   no-lock
   use-index {&idx}
   break by asc_fpos by {&break1} {&break2} {&break3}
   on endkey undo, leave mainloop:

   for first ac_mstr
      fields(ac_domain ac_active ac_code ac_curr ac_desc ac_type)
      where ac_domain = global_domain and
            ac_code=asc_acc
   no-lock: end.

   assign
      xacc=ac_code
      xsub={&xtype1}
      xcc={&xtype2}.

   if first-of({&test_field})
   then do i = 1 to 4:
      assign balance[i] = 0.
   end.

   {&comm1}
   if first-of({&test_field2}) then do:

      if sort_type=2 then do:

         for first cc_mstr
            fields(cc_domain cc_ctr cc_desc)
            where cc_domain = global_domain
              and cc_ctr = asc_cc
         no-lock: end.

         if cc_desc = "" then
            put skip.
         else
            put cc_desc at min(9,((cur_level - 1) * 2 + 3)).
      end.

      else do:

         for first sb_mstr
            fields(sb_domain sb_desc sb_sub)
            where sb_domain = global_domain
              and sb_sub=asc_sub
         no-lock: end.

         if sb_desc = "" then
            put skip.
         else
            put sb_desc at min(9,((cur_level - 1) * 2 + 3)).
      end.

   end. /* IF FIRST_OF */

   {&comm2} */

   /* CALCULATE AMOUNT*/
   {gl4inrp2.i}

   if last-of({&test_field}) then do:

      do i = 1 to 4:
         if prt1000 then
            assign balance[i] = round(balance[i] / 1000, 0).
         else
            assign balance[i] = round(balance[i], 0).
      end.

      if level > cur_level and
         ((not zeroflag and
           (ac_active or
            balance[1] <> 0 or
            balance[2] <> 0 or
            balance[3] <> 0 or
            balance[4] <> 0)) or
          (zeroflag and
           (balance[1] <> 0 or
            balance[2] <> 0 or
            balance[3] <> 0 or
            balance[4] <> 0)))
      then do:
         /* PRINT ACCOUNT AND BALANCE */
/* SS 090715.1 - B */
/*
         {gl4inrp1.i}
*/
         {xxgl4inrp1.i}
/* SS 090715.1 - E */
      end.

      if lookup(ac_type, "M,S") = 0 then do:
         assign
         tot1[cur_level] = tot1[cur_level] + balance[1]
         tot2[cur_level] = tot2[cur_level] + balance[2]
         tot3[cur_level] = tot3[cur_level] + balance[3]
         tot4[cur_level] = tot4[cur_level] + balance[4].
      end.

   end. /* IF LAST-OF */

end.  /* MAINLOOP: FOR EACH ASC_MSTR */
