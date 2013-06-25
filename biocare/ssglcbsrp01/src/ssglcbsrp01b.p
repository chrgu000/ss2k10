/* glcbsrpb.p - GENERAL LEDGER COMPARITIVE BALANCE SHEET REPORT SUBROUTINE   */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */
/*F0PN*/ /*K0TV*/
/*V8:ConvertMode=Report                                             */
/* REVISION: 7.3      LAST MODIFIED:  8/13/92   BY: mpp *G030* major rewrite */
/* REVISION: 8.6      LAST MODIFIED: 10/11/97   BY: ays  *K0TV*           */
/* REVISION: 8.6      LAST MODIFIED: 03/24/97   BY: *J241* Jagdish Suvarna */
/* REVISION: 9.1      LAST MODIFIED: 08/14/00   BY: *N0L1* Mark Brown        */
/* $Revision: 1.8 $ BY: Paul Donnelly (SB) DATE: 06/26/03 ECO: *Q00D* */
/* $Revision: 1.8 $ BY: Bill Jiang DATE: 08/15/07 ECO: *SS - 20070815.1* */
/*-Revision end---------------------------------------------------------------*/

/*!
    This program determines the sort_type and sum_lev (level of
    summarization needed), and then calls glcbsrpb[0-4].
*/
/*J241* GROUPED MULTIPLE FIELD ASSIGNMENTS INTO ONE AND ADDED NO-UNDO
    WHEREVER MISSING FOR PERFORMANCE AND SMALLER R-CODE */

    {mfdeclre.i}
        {glcbsrp3.i}

    /*DEFINE INPUT PARAMETER subflag like mfc_logical.
    DEFINE INPUT PARAMETER ccflag like mfc_logical.*/
    DEFINE VARIABLE sum_lev  as integer no-undo.
    DEFINE VARIABLE sort_type as integer no-undo.
    /*DEFINE SHARED VARIABLE pl like co_pl.
    DEFINE SHARED VARIABLE pl_amt AS DECIMAL NO-UNDO.*/
/*K0TV*/ {wbrp02.i}


/*J241**  find fm_mstr where RECID(fm_mstr) = fm_recno no-lock no-error. **/
/*J241*/ for first fm_mstr fields( fm_domain fm_cc_sort fm_sub_sort)
/*J241*/     where RECID(fm_mstr) = fm_recno no-lock: end.

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
        /* SS - 20070815.1 - B */
        /*
        IF sort_type=0 THEN
        IF sum_lev<2 then DO:
        {gprun.i ""glcbsrb0.p"" "(sum_lev, sort_type)"}
        END.
        ELSE DO:
        {gprun.i ""glcbsrb5.p"" "(sum_lev, sort_type)"}
        END.
                                /*sort type=1=sac*/
        ELSE IF sort_type=1 THEN DO:
            {gprun.i ""glcbsrb1.p"" "(sum_lev, sort_type)"}
        END.
                                /*sort type=2=cas*/
        ELSE IF sort_type=2 THEN DO:
                {gprun.i ""glcbsrb2.p"" "(sum_lev, sort_type)"}
        END.
                                /*sort type=3=sca*/
        ELSE IF sort_type=3 THEN DO:
            {gprun.i ""glcbsrb3.p"" "(sum_lev, sort_type)"}
        END.
                                /*sort type=4=acs*/
        ELSE DO:
            {gprun.i ""glcbsrb4.p"" "(sum_lev, sort_type)"}
        END.
        */
        IF sort_type=0 THEN
        IF sum_lev<2 then DO:
        {gprun.i ""ssglcbsrp01b0.p"" "(sum_lev, sort_type)"}
        END.
        ELSE DO:
        {gprun.i ""ssglcbsrp01b5.p"" "(sum_lev, sort_type)"}
        END.
                                /*sort type=1=sac*/
        ELSE IF sort_type=1 THEN DO:
            {gprun.i ""ssglcbsrp01b1.p"" "(sum_lev, sort_type)"}
        END.
                                /*sort type=2=cas*/
        ELSE IF sort_type=2 THEN DO:
                {gprun.i ""ssglcbsrp01b2.p"" "(sum_lev, sort_type)"}
        END.
                                /*sort type=3=sca*/
        ELSE IF sort_type=3 THEN DO:
            {gprun.i ""ssglcbsrp01b3.p"" "(sum_lev, sort_type)"}
        END.
                                /*sort type=4=acs*/
        ELSE DO:
            {gprun.i ""ssglcbsrp01b4.p"" "(sum_lev, sort_type)"}
        END.
        /* SS - 20070815.1 - E */
/*K0TV*/ {wbrp04.i}
