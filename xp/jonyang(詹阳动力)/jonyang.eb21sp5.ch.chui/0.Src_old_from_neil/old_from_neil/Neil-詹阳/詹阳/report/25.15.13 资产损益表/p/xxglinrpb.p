/* glinrpb.p - GENERAL LEDGER INCOME STATEMENT REPORT SUBROUTINE             */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */
/*F0PN*/ /*V8:ConvertMode=Report                                             */
/* REVISION: 7.3      CREATED:  8/13/92   BY: mpp  *G030*                    */
/* REVISION: 8.5      CREATED: 03/18/98   BY: *J242*     Sachin Shah         */
/* REVISION: 8.6ELAST MODIFIED: 04/07/98  BY: AWe  *L00S*RO*                 */
/* REVISION: 8.6ELAST MODIFIED: 10/04/98  BY: *J314* Alfred Tan              */
/* REVISION: 9.1     MODIFIED: 08/14/00   BY: *N0L1* Mark Brown              */
/* $Revision: 1.10 $ BY: Paul Donnelly (SB) DATE: 06/26/03 ECO: *Q00D* */
/* SS - 090709.1 By: Neil Gao */

/*-Revision end---------------------------------------------------------------*/

/*!
    This program determines the sort_type and sum_lev (level of
    summarization needed), and then calls glinrpb[0-4].
*/
/*J242* GROUPED MULTIPLE FIELD ASSIGNMENTS INTO ONE AND ADDED NO-UNDO
 WHEREVER MISSING FOR PERFORMANCE AND SMALLER R-CODE */

   {mfdeclre.i}
        {glinrp3.i}

    /*DEFINE INPUT PARAMETER subflag like mfc_logical.
    DEFINE INPUT PARAMETER ccflag like mfc_logical.*/
    DEFINE VARIABLE sum_lev  as integer no-undo.
    DEFINE VARIABLE sort_type as integer no-undo.
    /*DEFINE SHARED VARIABLE pl like co_pl.
    DEFINE SHARED VARIABLE pl_amt AS DECIMAL NO-UNDO.*/

/*J242** find fm_mstr where RECID(fm_mstr) = fm_recno no-lock no-error. **/
/*J242*/ for first fm_mstr
         fields( fm_domain fm_cc_sort fm_sub_sort)
         no-lock where RECID(fm_mstr) = fm_recno: end.

        /*determine sub_type and sum_level*/
      IF ccflag AND subflag THEN
                assign sum_lev = 2.
          ELSE IF ccflag OR subflag THEN
                assign sum_lev = 1.
          ELSE
                assign sum_lev = 0.
          IF fm_sub_sort AND NOT(subflag) THEN DO:
                IF fm_cc_sort AND NOT(ccflag) THEN
                        assign sort_type = 3.
                ELSE
                        assign sort_type = 1.
          END.
          ELSE IF NOT(ccflag) THEN DO:
                IF fm_cc_sort THEN
                        assign sort_type = 2.
                ELSE IF subflag THEN
                        assign sort_type = 4.
                ELSE
                        assign sort_type = 0.
         END.
         ELSE
                assign sort_type=0.
                                /*sort type=0=asc*/
        IF sort_type=0 THEN DO:
/* SS 090709.1 - B */
/*
        {gprun.i ""glinrpb0.p"" "(sum_lev, sort_type)"}
*/
        {gprun.i ""xxglinrpb0.p"" "(sum_lev, sort_type)"}
/* SS 090709.1 - E */
    END.
                                /*sort type=1=sac*/
        ELSE IF sort_type=1 THEN DO:
/* SS 090709.1 - B */
/*
            {gprun.i ""glinrpb1.p"" "(sum_lev, sort_type)"}
*/
            {gprun.i ""xxglinrpb1.p"" "(sum_lev, sort_type)"}
/* SS 090709.1 - E */
        END.
                                /*sort type=2=cas*/
        ELSE IF sort_type=2 THEN DO:
/* SS 090709.1 - B */
/*
                {gprun.i ""glinrpb2.p"" "(sum_lev, sort_type)"}
*/
                {gprun.i ""xxglinrpb2.p"" "(sum_lev, sort_type)"}
/* SS 090709.1 - E */
        END.
                                /*sort type=3=sca*/
        ELSE IF sort_type=3 THEN DO:

/* SS 090709.1 - B */
/*
            {gprun.i ""glinrpb3.p"" "(sum_lev, sort_type)"}
*/
            {gprun.i ""xxglinrpb3.p"" "(sum_lev, sort_type)"}
/* SS 090709.1 - E */
        END.
                                /*sort type=4=acs*/
        ELSE DO:
/* SS 090709.1 - B */
/*
            {gprun.i ""glinrpb4.p"" "(sum_lev, sort_type)"}
*/
            {gprun.i ""xxglinrpb4.p"" "(sum_lev, sort_type)"}
/* SS 090709.1 - B */
        END.
