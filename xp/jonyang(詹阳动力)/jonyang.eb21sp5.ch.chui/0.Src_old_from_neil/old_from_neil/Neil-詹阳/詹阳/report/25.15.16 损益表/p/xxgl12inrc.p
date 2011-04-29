/* gl12inrc.p - GENERAL LEDGER 12-COLUMN INCOME STATEMENT (PART IV)     */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*F0PN*/ /*K1DS*/
/*V8:ConvertMode=Report                                        */
/*                      (Both sub-accounts and cost centers summarized) */
/* REVISION: 7.0      LAST MODIFIED: 04/07/92   by: jms  *F340*         */
/*           7.3                     04/14/93   by: skk  *G945*         */
/*                                   09/13/96   by: jzw  *G2F9*         */
/* REVISION: 8.6      LAST MODIFIED: 12/15/97   by: bvm  *K1DS*         */
/* REVISION: 8.6           MODIFIED: 03/12/98   By: *J23W* Sachin Shah  */
/* REVISION: 8.6E     LAST MODIFIED: 24 apr 98  BY: *L00S* D. Sidel rev only */
/* REVISION: 8.6E          MODIFIED: 10/04/98   By: *J314* Alfred Tan        */
/* REVISION: 9.1           MODIFIED: 08/14/00   By: *N0L1* Mark Brown        */
/* $Revision: 1.11 $ BY: Paul Donnelly (SB) DATE: 06/26/03 ECO: *Q00D* */
/*-Revision end---------------------------------------------------------------*/


/*J23W* GROUPED MULTIPLE FIELD ASSIGNMENTS INTO ONE
        FOR PERFORMANCE AND SMALLER R-CODE */

/*G2F9*/  {mfdeclre.i}
/*K1DS*/ {wbrp02.i}


      /* DATA DEFINITIONS */
      {gl12inr3.i}
/*G2F9*   {mfdeclre.i} */

/*G2F9*   find ac_mstr where recid(ac_mstr) = ac_recno no-lock. */
/*J23W**   find fm_mstr where recid(fm_mstr) = fm_recno no-lock. **/

/*J23W*/  for first fm_mstr fields( fm_domain fm_fpos fm_dr_cr)
/*J23W*/      where recid(fm_mstr) = fm_recno no-lock: end.
/*J23W* GROUPED MULTIPLE FIELD ASSIGNMENTS INTO ONE */
      assign
      xsub = ""
      xcc = "".
/*J23W* END OF GROUPING FIELD ASSIGNMENTS */

      for each asc_mstr
/*J23W*/  fields( asc_domain asc_acc asc_sub asc_cc asc_fpos)
/*G2F9*/   where asc_mstr.asc_domain = global_domain and   asc_fpos = fm_fpos
and
/*G2F9*                           asc_acc = xacc and */
                 asc_sub >= sub and asc_sub <= sub1 and
                 asc_cc >= ctr and asc_cc <= ctr1 no-lock
                 break
/*G2F9*/                              by asc_fpos
                 by asc_acc:

/*J23W** /*G2F9*/     find ac_mstr where ac_code = asc_acc no-lock no-error.**/

/*J23W*/ for first ac_mstr fields( ac_domain ac_type ac_active ac_desc ac_curr
ac_code)
/*J23W*/      where ac_mstr.ac_domain = global_domain and  ac_code = asc_acc
no-lock: end.

         if first-of(asc_acc) then do:
/*J23W* GROUPED MULTIPLE FIELD ASSIGNMENTS INTO ONE */
            assign
              balance = 0
              pct = 0
/*G2F9*/        xacc = asc_acc.
/*J23W* END OF GROUPING FIELD ASSIGNMENTS */
/*G2F9*/        display with no-box.
         end.

         /* CALCULATE AMOUNTS */
         {gl12inr2.i}

         if last-of(asc_acc) then do:
        do i = 1 to 12:
           if prt1000 then assign balance[i] = round(balance[i] / 1000, 0).
           else assign balance[i] = round(balance[i], 0).
        end.

        /* CHECK IF ALL COLUMNS ARE ZERO */
        assign zflag = no.
        do i = 1 to 12:
           if balance[i] <> 0 then assign zflag = yes.
        end.

/*G945* ****    if level > cur_level and ((not zeroflag and (ac_active or
           zflag))) then do: */
/*G945*/        if level > cur_level then
/*G945*/           if zflag then do:
/*G945*/              /* PRINT ALL NON-ZERO BALANCES FOR ALL ACCOUNTS */
/* SS 090715.1 - B */
/*
/*G945*/              {gl12inr1.i}
*/
				              {xxgl12inr1.i}
/* SS 090715.1 - E */
/*G945*/           end.
/*G945*/           else
/*G945*/           if not zeroflag and ac_active then do:
/*G945*/              /* PRINT ZERO BALANCES FOR ACTIVE ACCOUNTS ONLY*/
/* SS 090715.1 - B */
/*
              {gl12inr1.i}
*/
              {xxgl12inr1.i}
/* SS 090715.1 - E */
           end.

        if lookup(ac_type, "M,S") = 0 then do:
/*J23W* GROUPED MULTIPLE FIELD ASSIGNMENTS INTO ONE */
           assign
           tot1[cur_level] = tot1[cur_level] + balance[1]
           tot2[cur_level] = tot2[cur_level] + balance[2]
           tot3[cur_level] = tot3[cur_level] + balance[3]
           tot4[cur_level] = tot4[cur_level] + balance[4]
           tot5[cur_level] = tot5[cur_level] + balance[5]
           tot6[cur_level] = tot6[cur_level] + balance[6]
           tot7[cur_level] = tot7[cur_level] + balance[7]
           tot8[cur_level] = tot8[cur_level] + balance[8]
           tot9[cur_level] = tot9[cur_level] + balance[9]
           tot10[cur_level] = tot10[cur_level] + balance[10]
           tot11[cur_level] = tot11[cur_level] + balance[11]
           tot12[cur_level] = tot12[cur_level] + balance[12].
/*J23W* END OF GROUPING FIELD ASSIGNMENTS */
        end.
         end.
      end. /* END OF ASC_MSTR LOOP */
/*K1DS*/ {wbrp04.i}
