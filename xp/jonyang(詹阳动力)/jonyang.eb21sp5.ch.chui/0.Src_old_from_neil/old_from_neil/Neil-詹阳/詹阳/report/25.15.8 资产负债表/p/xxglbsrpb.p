/* glbsrpb.p - GENERAL LEDGER BALANCE SHEET REPORT SUBROUTINE                 */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/*F0PN*/ /*K0V3*/
/*V8:ConvertMode=Report                                                       */
/* REVISION: 7.3      LAST MODIFIED:   8/13/92  BY: mpp *G030* major rewrite  */
/* REVISION: 8.6      LAST MODIFIED:  10/13/97  by: ays *K0V3*                */
/* REVISION: 8.6      LAST MODIFIED:  03/19/98  BY: *J240* Kawal Batra        */
/* REVISION: 8.6E     LAST MODIFIED:  APR 22 98 BY: LN/SVA  *L00S*RO*         */
/* REVISION: 8.6E     LAST MODIFIED:  10/04/98  BY: *J314* Alfred Tan                                                                                          */
/* REVISION: 9.1      LAST MODIFIED:  08/14/00  BY: *N0L1* Mark Brown                                                                                          */
/* $Revision: 1.12 $ BY: Paul Donnelly (SB) DATE: 06/26/03 ECO: *Q00D* */
/* SS - 090708.1 By: Neil Gao */

/*-Revision end---------------------------------------------------------------*/

/*!
    This program determines the sort_type and sum_lev (level of
    summarization needed), and then calls glbsrpb[0-4].
*/
/*J240*/ /* ADDED NO_UNDO WHEREVER MISSING */

    {mfdeclre.i}
    {glbsrp3.i}

    DEFINE INPUT PARAMETER subflag like mfc_logical  no-undo.
    DEFINE INPUT PARAMETER ccflag like mfc_logical  no-undo.
    DEFINE VARIABLE sum_lev  as integer  no-undo.
    DEFINE VARIABLE sort_type as integer  no-undo.
    DEFINE SHARED VARIABLE pl like co_pl  no-undo.
    DEFINE SHARED VARIABLE pl_amt AS DECIMAL NO-UNDO.
/*K0V3*/ {wbrp02.i}

/*J240**find fm_mstr where RECID(fm_mstr) = fm_recno no-lock no-error. **/
/*J240*/ for first fm_mstr fields( fm_domain fm_sub_sort fm_cc_sort)
/*J240*/     no-lock where RECID(fm_mstr) = fm_recno: end.


        /*determine sub_type and sum_level*/
    IF ccflag AND subflag THEN
    assign sum_lev=2.
          ELSE IF ccflag OR subflag THEN
          assign sum_lev=1.
          ELSE
          assign sum_lev=0.
          IF fm_sub_sort AND NOT(subflag) THEN DO:
                IF fm_cc_sort AND NOT(ccflag) THEN
                 assign sort_type=3.
                ELSE
                assign sort_type = 1.
          END.
          ELSE IF NOT(ccflag) THEN DO:
                IF fm_cc_sort THEN
                assign sort_type = 2.
                ELSE IF subflag THEN
                assign sort_type=4.
                ELSE
                assign sort_type=0.
         END.
         ELSE
         assign sort_type=0.

                                /*sort type=0=asc*/
        IF sort_type=0 THEN DO:
/* SS 090708.1 - B */
/*
        {gprun.i ""glbsrpb0.p"" "(sum_lev, sort_type)"}
*/
        {gprun.i ""xxglbsrpb0.p"" "(sum_lev, sort_type)"}
/* SS 090708.1 - E */
    END.
                                /*sort type=1=sac*/
        ELSE IF sort_type=1 THEN DO:
/* SS 090708.1 - B */
/*
            {gprun.i ""glbsrpb1.p"" "(sum_lev, sort_type)"}
*/
            {gprun.i ""xxglbsrpb1.p"" "(sum_lev, sort_type)"}
/* SS 090708.1 - E */
        END.
                                /*sort type=2=cas*/
        ELSE IF sort_type=2 THEN DO:
/* SS 090708.1 - B */
/*
                {gprun.i ""glbsrpb2.p"" "(sum_lev, sort_type)"}
*/
                {gprun.i ""xxglbsrpb2.p"" "(sum_lev, sort_type)"}
/* SS 090708.1 - E */
        END.
                                /*sort type=3=sca*/
        ELSE IF sort_type=3 THEN DO:
/* SS 090708.1 - B */
/*
            {gprun.i ""glbsrpb3.p"" "(sum_lev, sort_type)"}
*/
            {gprun.i ""xxglbsrpb3.p"" "(sum_lev, sort_type)"}
/* SS 090708.1 - B */
        END.
                                /*sort type=4=acs*/
        ELSE DO:
/* SS 090708.1 - B */
/*
            {gprun.i ""glbsrpb4.p"" "(sum_lev, sort_type)"}
*/
            {gprun.i ""xxglbsrpb4.p"" "(sum_lev, sort_type)"}
/* SS 090708.1 - E */
        END.
/*K0V3*/ {wbrp04.i}
