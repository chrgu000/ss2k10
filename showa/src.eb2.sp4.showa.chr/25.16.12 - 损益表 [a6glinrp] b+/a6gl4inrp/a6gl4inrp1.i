/* gl4inrp1.i - GENERAL LEDGER 4-COLUMN INCOME STATEMENT--SUBROUTINE TO    */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                     */
/* All rights reserved worldwide.  This is an unpublished work.            */
/*F0PN*/ /*V8:ConvertMode=Report                                           */
/*                DISPLAY ACCOUNTS AND AMOUNTS.                            */
/* REVISION: 7.0      LAST MODIFIED: 11/11/91   BY: JMS     *F058*         */
/* REVISION: 8.5      LAST MODIFIED: 03/12/98   BY: *J23W*  Sachin Shah    */
/* REVISION: 9.0      LAST MODIFIED: 02/08/00   BY: *J3P3*  Ranjit Jain    */
/* REVISION: 9.1      LAST MODIFIED: 08/14/00   BY: *N0L1* Mark Brown      */
/* REVISION: 9.1      LAST MODIFIED: 09/13/05   BY: *SS - 20050913* Bill Jiang      */
/***************************************************************************/
/*!
This include file prints the detail lines for the 4-column income statement
report.
*/
/***************************************************************************/
/*J23W* GROUPED MULTIPLE FIELD ASSIGNMENTS INTO ONE
        FOR PERFORMANCE AND SMALLER R-CODE */

      /* DISPLAY ACCOUNT AND AMOUNTS */

/* SS - 20050913 - B */
/*
      put ac_desc at min(9, ((cur_level - 1) * 2 + 3)).
      */
      CREATE tta6gl4inrp.
      ASSIGN
          tta6gl4inrp_fpos = ac_fpos
          tta6gl4inrp_code = ac_code
          tta6gl4inrp_desc = ac_desc
          .
      /* SS - 20050913 - E */

      if fm_dr_cr = false then do:
         do i = 1 to 4:
/*J23W* GROUPED MULTIPLE FIELD ASSIGNMENTS INTO ONE */
            assign
            cramt = - balance[i]
            pct = 0.
/*J23W* END OF GROUPING FIELD ASSIGNMENTS */
        if income[i] <> 0 then assign pct = cramt / income[i] * 100.
/*J3P3** if not budget[i] or not fmbgflag then  */
/*J3P3*/ if not budget[i]   or
/*J3P3*/    not fmbgflag[i]
/*J3P3*/ then
    /* SS - 20050913 - B */
    /*
           put cramt at (34 + ((i - 1) * 25))
               pct at (52 + ((i - 1) * 25)).
*/
    ASSIGN
    tta6gl4inrp_balance[i] = cramt
    tta6gl4inrp_pct[i] = pct
    .
/* SS - 20050913 - E */
         end.
         /* SS - 20050913 - B */
         /*
         put skip.
         */
         /* SS - 20050913 - E */
      end.

      else do:
         do i = 1 to 4:
/*J23W*/ assign
           pct = 0.
        if income[i] <> 0 then assign pct = balance[i] / income[i] * 100.
/*J3P3** if not budget[i] or not fmbgflag then  */
/*J3P3*/ if not budget[i]   or
/*J3P3*/    not fmbgflag[i]
/*J3P3*/ then
    /* SS - 20050913 - B */
    /*
           put balance[i] at (34 + ((i - 1) * 25))
               pct at (52 + ((i - 1) * 25)).
*/
    ASSIGN
    tta6gl4inrp_balance[i] = balance[i]
    tta6gl4inrp_pct[i] = pct
    .
/* SS - 20050913 - E */
         end.
/* SS - 20050913 - B */
/*
         put skip.
         */
         /* SS - 20050913 - E */
      end.

/*J23W*/  assign
          totflag[cur_level] = yes.
