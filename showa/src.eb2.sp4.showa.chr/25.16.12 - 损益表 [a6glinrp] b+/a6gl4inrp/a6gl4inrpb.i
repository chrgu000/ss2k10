/* gl4inrpb.i - GENERAL LEDGER INCOME STATEMENT REPORT                    */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                    */
/* All rights reserved worldwide.  This is an unpublished work.           */
/*F0PN*/ /*V8:ConvertMode=Report                                          */
/* REVISION: 7.3            CREATED: 08/17/92   by: mpp  *G030*           */
/*                    LAST MODIFIED: 05/17/96   by: jzw  *G1VY*           */
/* Revision: 8.5           MODIFIED: 03/12/98   By: *J23W*  Sachin Shah   */
/* REVISION: 8.6E     LAST MODIFIED: 24 apr 98  BY: *L00M* D. Sidel  rev only */
/* Revision: 8.6E          MODIFIED: 10/04/98   By: *J314* Alfred Tan         */
/* Revision: 9.1           MODIFIED: 08/14/00   By: *N0L1* Mark Brown         */
/* Revision: 9.1           MODIFIED: 09/13/05   By: *SS - 20050913* Bill Jiang         */

/*J23W* GROUPED MULTIPLE FIELD ASSIGNMENTS INTO ONE
        FOR PERFORMANCE AND SMALLER R-CODE */

/*!
    This code is the innermost loop for gl4inrp.  It was written to
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
/*J23W*/   fields (asc_acc asc_sub asc_cc asc_fpos)
           where asc_fpos = fm_fpos and
                 asc_sub >= sub and asc_sub <= sub1 and
                 asc_cc >= ctr and asc_cc <= ctr1
                 no-lock
                 use-index {&idx} break by asc_fpos by
                 {&break1} {&break2} {&break3}
                 on endkey undo, leave mainloop:

/*J23W**  find ac_mstr where ac_code=asc_acc no-lock no-error. **/

         /* SS - 20050913 - B */
         /*
/*J23W*/ for first ac_mstr fields (ac_active ac_code ac_curr ac_desc ac_type)
/*J23W*/      no-lock where ac_code=asc_acc: end.
*/
/*J23W*/ for first ac_mstr fields (ac_fpos ac_active ac_code ac_curr ac_desc ac_type)
/*J23W*/      no-lock where ac_code=asc_acc: end.
/* SS - 20050913 - E */

/*J23W* GROUPED MULTIPLE FIELD ASSIGNMENTS INTO ONE */
        assign
        xacc=ac_code
        xsub={&xtype1}
        xcc={&xtype2}.
/*J23W* END OF GROUPING FIELD ASSIGNMENTS */
        if first-of({&test_field}) then do i = 1 to 4:
           assign balance[i] = 0.
        end.
                /*code between comm1 and comm2 is commented
                  out when sort_type = 0 or 4. */
        {&comm1}
        if first-of({&test_field2}) then do:
           if sort_type=2 then do:

/*J23W**   find cc_mstr where cc_ctr=asc_cc. **/

/*J23W*/  for first cc_mstr fields (cc_ctr cc_desc)
/*J23W*/      no-lock where cc_ctr=asc_cc: end.

          if cc_desc = "" then
             put skip.
          else
             put cc_desc at min(9,((cur_level - 1) * 2 + 3)).
           end.
           else do:

/*J23W**       find sb_mstr where sb_sub=asc_sub. **/

/*J23W*/      for first sb_mstr fields (sb_desc sb_sub)
/*J23W*/          no-lock where sb_sub=asc_sub: end.

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
/*G1VY*        if prt1000 then do i=1 to 4: */
/*G1VY*/       do i=1 to 4:
    /* SS - 20050913 - B */
    /*
/*G1VY*/          if prt1000 then
                    assign balance[i] = round(balance[i] / 1000, 0).
/*G1VY*/          else
/*G1VY*/            assign balance[i] = round(balance[i], 0).
*/
/*G1VY*/          if prt1000 then
                    assign balance[i] = round(balance[i] / 1000, 2).
/*G1VY*/          else
/*G1VY*/            assign balance[i] = round(balance[i], 2).
/* SS - 20050913 - E */
           end.

           if level > cur_level and ((not zeroflag and (ac_active or
          balance[1] <> 0 or balance[2] <> 0 or balance[3] <> 0 or
          balance[4] <> 0)) or
          (zeroflag and (balance[1] <> 0 or balance[2] <> 0 or
          balance[3] <> 0 or balance[4] <> 0))) then do:
          /* PRINT ACCOUNT AND BALANCE */
               /* SS - 20050913 - B */
               /*
          {gl4inrp1.i}
              */
              {a6gl4inrp1.i}
              /* SS - 20050913 - E */
           end.

           if lookup(ac_type, "M,S") = 0 then do:
/*J23W* GROUPED MULTIPLE FIELD ASSIGNMENTS INTO ONE */
          assign
          tot1[cur_level] = tot1[cur_level] + balance[1]
          tot2[cur_level] = tot2[cur_level] + balance[2]
          tot3[cur_level] = tot3[cur_level] + balance[3]
          tot4[cur_level] = tot4[cur_level] + balance[4].
/*J23W* END OF GROUPING FIELD ASSIGNMENTS */
           end.

        end. /* IF LAST-OF */
     end.  /* MAINLOOP: FOR EACH ASC_MSTR */
