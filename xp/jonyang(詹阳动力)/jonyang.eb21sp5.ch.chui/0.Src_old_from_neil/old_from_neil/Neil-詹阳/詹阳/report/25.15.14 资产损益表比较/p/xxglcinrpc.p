/* glcinrpc.p - GENERAL LEDGER COMPARITIVE INCOME STMT REPORT SUBROUTINE     */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */
/*F0PN*/ /*K0TC*/
/*V8:ConvertMode=Report                                                      */
/* REVISION: 7.3      LAST MODIFIED:  8/13/92   BY: mpp *G030* major rewrite */
/* REVISION: 8.6      LAST MODIFIED: 10/11/97   by: ays *K0TC*               */
/* REVISION: 8.6      LAST MODIFIED: 03/18/98   BY: *J242*    Sachin Shah    */
/* REVISION: 8.6E     LAST MODIFIED: APR 24 98  BY: LN/SVA  *L00W*           */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan        */
/* REVISION: 9.1      LAST MODIFIED: 08/14/00   BY: *N0L1* Mark Brown        */
/* $Revision: 1.12 $ BY: Paul Donnelly (SB) DATE: 06/26/03 ECO: *Q00D* */
/* SS - 090709.1 By: Neil Gao */

/*-Revision end---------------------------------------------------------------*/

/*!
    This program determines the sort_type and sum_lev (level of
    summarization needed), and then calls glcinrpc[0-4].
*/
/*J242* GROUPED MULTIPLE FIELD ASSIGNMENTS INTO ONE AND ADDED NO-UNDO
 WHEREVER MISSING FOR PERFORMANCE AND SMALLER R-CODE */

    {mfdeclre.i}
/*K0TC*/ {wbrp02.i}

        {glcinrp3.i}

        DEFINE VARIABLE sum_lev  as integer no-undo.
        DEFINE VARIABLE sort_type as integer no-undo.

/*L00W**BEGIN ADD*/
        /* DEFINITION OF EURO TOOLKIT VARIABLES */
        {etrpvar.i &new = " "}
        {etvar.i   &new = " "}

        define     shared variable et_income      like income     no-undo.
        define     shared variable et_balance     like balance    no-undo.
        define     shared variable et_tot         like tot        no-undo.
        define     shared variable et_tot1        like tot1       no-undo.
/*L00W**END ADD*/

/*J242** find fm_mstr where RECID(fm_mstr) = fm_recno no-lock no-error. **/
/*J242*/ for first fm_mstr fields( fm_domain fm_cc_sort fm_sub_sort)
/*J242*/     where RECID(fm_mstr) = fm_recno no-lock: end.

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
                assign sort_type = 0.

                                /*sort type=0=asc*/
        IF sort_type = 0 THEN
        IF sum_lev < 2 then DO:
/* SS 090709.1 - B */
/*
        {gprun.i ""glcinrc0.p"" "(sum_lev, sort_type)"}
*/
        {gprun.i ""xxglcinrc0.p"" "(sum_lev, sort_type)"}
/* SS 090709.1 - E */
        END.
        ELSE DO:
/* SS 090709.1 - B */
/*
        {gprun.i ""glcinrc5.p"" "(sum_lev, sort_type)"}
*/
        {gprun.i ""xxglcinrc5.p"" "(sum_lev, sort_type)"}
/* SS 090709.1 - E */
        END.
                                /*sort type=1=sac*/
        ELSE IF sort_type = 1 THEN DO:
/* SS 090709.1 - B */
/*
            {gprun.i ""glcinrc1.p"" "(sum_lev, sort_type)"}
*/
            {gprun.i ""xxglcinrc1.p"" "(sum_lev, sort_type)"}
/* SS 090709.1 - E */
        END.
                                /*sort type=2=cas*/
        ELSE IF sort_type = 2 THEN DO:
/* SS 090709.1 - B */
/* 
                {gprun.i ""glcinrc2.p"" "(sum_lev, sort_type)"}
*/
                {gprun.i ""xxglcinrc2.p"" "(sum_lev, sort_type)"}
/* SS 090709.1 - E */
        END.
                                /*sort type=3=sca*/
        ELSE IF sort_type = 3 THEN DO:
/* SS 090709.1 - B */
/*
            {gprun.i ""glcinrc3.p"" "(sum_lev, sort_type)"}
*/
            {gprun.i ""xxglcinrc3.p"" "(sum_lev, sort_type)"}
/* SS 090709.1 - E */
        END.
                                /*sort type=4=acs*/
        ELSE DO:
/* SS 090709.1 - B */
/*
            {gprun.i ""glcinrc4.p"" "(sum_lev, sort_type)"}
*/
            {gprun.i ""xxglcinrc4.p"" "(sum_lev, sort_type)"}
/* SS 090709.1 - E */
        END.
/*K0TC*/ {wbrp04.i}
