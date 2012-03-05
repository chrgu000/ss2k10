/* glabrpa.p - GENERAL LEDGER ACCOUNT BALANCES REPORT--SUBPROGRAM (PART II)   */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/*F0PN*/ /*V8:ConvertMode=Report                                              */
/* REVISION: 1.0      LAST MODIFIED: 04/21/87   BY: JMS                       */
/*                                   01/29/88   by: jms  CSR 28967            */
/* REVISION: 4.0      LAST MODIFIED: 02/26/88   by: jms                       */
/*                                   02/29/88   BY: WUG  *A175*               */
/*                                   04/11/88   by: jms                       */
/* REVISION: 5.0      LAST MODIFIED: 05/10/89   BY: JMS  *B066*               */
/*                                   06/16/89   by: jms  *B154*               */
/*                                   08/03/89   BY: jms  *C0028*              */
/*                                   10/08/89   by: jms  *B331*               */
/*                                   11/21/89   by: jms  *B400*               */
/*                                   04/11/90   by: jms  *B499*               */
/*                             (split into glabrp.p and glabrpa.p)            */
/* REVISION: 6.0      LAST MODIFIED: 10/15/90   by: jms  *D034*               */
/*                                   01/03/91   by: jms  *D287*               */
/*                                   02/20/91   by: jms  *D366*               */
/*                                   09/04/91   by: jms  *D849*               */
/* REVISION: 7.0      LAST MODIFIED: 10/15/91   by: jms  *F058*               */
/*                                       (major revision)                     */
/*                                   01/29/92   by: jms  *F107*               */
/*                                   06/10/92   by: jms  *F593*               */
/* REVISION: 7.4     LAST MODIFIED:  12/07/92   by: mpp  *G479*               */
/*                                   07/12/93   by: skk  *H026* sub/cc descrp */
/*                                   06/28/94   by: bcm  *H413*               */
/*                                   02/13/95   by: str  *F0HY*               */
/*                                   08/29/95   by: wjk  *G0VR*               */
/*                                   01/08/96   by: mys  *G1J9*               */
/* REVISION: 8.5     LAST MODIFIED:  12/19/96   by: rxm  *J1C7*               */
/* REVISION: 8.6     LAST MODIFIED:  10/13/97   BY: ays  *K0VL*               */
/* REVISION: 8.6E    LAST MODIFIED:  02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E    LAST MODIFIED:  03/19/98   by: *J240* Kawal Batra        */
/* REVISION: 8.6E    LAST MODIFIED:  04/24/98   BY: *L00M* D. Sidel           */
/* REVISION: 8.6E    LAST MODIFIED: 06/02/98    BY: *L01W* Brenda Milton      */
/* REVISION: 9.1     LAST MODIFIED: 08/03/99    BY: *N014* Murali Ayyagari    */
/* REVISION: 9.1     LAST MODIFIED: 01/07/00    BY: *M0D6* J. Fernando        */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/14/00 BY: *N0L1* Mark Brown           */
/* REVISION: 9.1      LAST MODIFIED: 09/23/00 BY: *N0VY* BalbeerS Rajput  */
/* $Revision: 1.21 $ BY: Paul Donnelly (SB) DATE: 06/26/03 ECO: *Q00D* */
/* REVISION: 9.1      LAST MODIFIED: 11/17/06 BY: *SS - 20061117* Bill Jiang  */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/*J240********** GROUPED MULTIPLE FIELD ASSIGNMENTS INTO ONE AND ADDED NO-UNDO
 WHEREVER MISSING FOR PERFORMANCE AND FOR SMALLER r-CODE *******J240*/

/* SS - 20061117 - B */
{a6glabrp0001.i}
/* SS - 20061117 - E */
                                                                
          {mfdeclre.i}
/*N0VY*/  {cxcustom.i "GLABRPA.P"}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE glabrpa_p_1 "Summarize Cost Centers"
/* MaxLen: Comment: */

&SCOPED-DEFINE glabrpa_p_2 "Summarize Sub-Accounts"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

/*        {wbrp02.i}                                             **M0D6*/

          define new shared variable first_acct like mfc_logical  no-undo.
          define new shared variable first_sub like mfc_logical  no-undo.
          define new shared variable first_cc like mfc_logical  no-undo.

      define new shared variable begdtxx as date  no-undo.
      define new shared variable beg_tot as decimal
         format ">>,>>>,>>>,>>>,>>9.99cr"  no-undo.
      define new shared variable per_tot like beg_tot  no-undo.
      define new shared variable end_tot like beg_tot  no-undo.

      define shared variable glname like en_name  no-undo.
      define shared variable per as integer  no-undo.
      define shared variable per1 as integer  no-undo.
      define shared variable yr as integer  no-undo.
      define shared variable begdt like gltr_eff_dt  no-undo.
      define shared variable enddt like gltr_eff_dt  no-undo.
      define shared variable yr_beg as date  no-undo.
      define shared variable yr_end as date  no-undo.
      define shared variable acc like ac_code  no-undo.
      define shared variable acc1 like ac_code  no-undo.
      define shared variable sub like sb_sub  no-undo.
      define shared variable sub1 like sb_sub  no-undo.
      define shared variable ctr like cc_ctr  no-undo.
      define shared variable ctr1 like cc_ctr  no-undo.
      define shared variable ccflag like mfc_logical
         label {&glabrpa_p_1}  no-undo.
      define shared variable subflag like mfc_logical
             label {&glabrpa_p_2}  no-undo.
      define shared variable entity like gltr_entity  no-undo.
      define shared variable entity1 like gltr_entity  no-undo.
      define shared variable cname like glname  no-undo.
      define shared variable ret like ac_code  no-undo.
         define shared variable rpt_curr like gltr_curr  no-undo.

      define variable beg_bal like beg_tot  no-undo.
      define variable end_bal like beg_tot  no-undo.
      define variable per_act like beg_tot  no-undo.
      define variable act_to_dt like beg_tot  no-undo.
      define variable begdt1 like gltr_eff_dt  no-undo.
      define variable enddt1 like gltr_eff_dt  no-undo.
      define variable knt as integer  no-undo.
      define variable dt as date  no-undo.
      define variable dt1 as date  no-undo.
/*N014*  define variable account as character format "x(14)"  no-undo. */
/*N014*/ define variable account as character format "x(22)"  no-undo.
      define variable perknt as integer  no-undo.
          define variable print_acct as logical no-undo.

      define buffer cal for glc_cal.

/*L00M*ADD SECTION*/
      {etvar.i}   /* common euro variables */
      {etrpvar.i} /* common euro report variables */
      define new shared variable et_beg_tot like beg_tot.
      define new shared variable et_per_tot like per_tot.
      define new shared variable et_end_tot like end_tot.
      define variable et_beg_bal   like beg_bal.
      define variable et_end_bal   like end_bal.
      define variable et_act_to_dt like act_to_dt.
      define variable et_per_act   like per_act.

      if not available gl_ctrl then find first gl_ctrl  where gl_ctrl.gl_domain
      = global_domain no-lock.
/*L00M*END ADD SECTION*/

      /* BEGIN ADDED CODE */                                /*M0D6*/
      define new shared frame pdetail.

      /* SET EXTERNAL LABELS */
      setFrameLabels(frame pdetail:handle).

      {glabrpf.i}
      {wbrp02.i}
      /* END ADDED CODE   */                                /*M0D6*/

      /* CYCLE THROUGH ACCOUNT FILE */
          assign
          begdtxx = begdt - 1
          beg_tot = 0
          per_tot = 0
          end_tot = 0
/*L00M*/  et_beg_tot = 0
/*L00M*/  et_per_tot = 0
/*L00M*/  et_end_tot = 0.
/*N0VY*/  {&GLABRPA-P-TAG1}

      /* CALCULATE BALANCE IF BOTH SUB-ACCTS & COST CTRS SUMMARIZED*/
      if ccflag and subflag then do:
         /* SS - 20061117.1 - B */
         /*
         {gprun.i ""glabrpb.p""}
         */
         {gprun.i ""a6glabrp0001b.p""}
       /* SS - 20061117.1 - E */
      end.

      /* CALCULATE BALANCE IF SUMMARIZED SUB-ACCOUNTS*/
      else if subflag then do:
         {gprun.i ""glabrpc.p""}
      end.

      /* CALCULATE BALANCE IF SUMMARIZED COST CENTERS */
      else if ccflag then do:
         {gprun.i ""glabrpd.p""}
      end.

      /* CALCULATE BALANCE FOR STANDARD ACCOUNTS */
      else do:
             loopa:
           for each asc_mstr
/*J240*/       fields( asc_domain asc_acc asc_sub asc_cc)
                where asc_mstr.asc_domain = global_domain and  asc_acc >= acc
                and asc_acc <= acc1 and
                     asc_sub >= sub and asc_sub <= sub1 and
                     asc_cc >= ctr and asc_cc <= ctr1 no-lock
                                     break by asc_acc by asc_sub by asc_cc:

          if first-of(asc_acc) then assign first_acct = yes.
          if first-of(asc_sub) then assign first_sub = yes.
          if first-of(asc_cc)  then assign first_cc = yes.

/*J240**     find ac_mstr where ac_code = asc_acc no-lock no-error. **/
            for first ac_mstr fields( ac_domain ac_code ac_curr ac_type
            ac_active ac_desc)
/*J240*/            no-lock  where ac_mstr.ac_domain = global_domain and
ac_code = asc_acc: end.

        if not available ac_mstr then next.

           assign
           knt = 0
           act_to_dt = 0
/*L00M*/    et_act_to_dt = 0.

        /* CALCULATE BEGINNING BALANCE */
        if lookup(ac_type, "A,L") = 0 then do:
           {glacbal1.i &acc=asc_acc &sub=asc_sub &cc=asc_cc
             &begdt=yr_beg &enddt=begdtxx &balance=beg_bal
              &yrend=yr_end &rptcurr=rpt_curr &accurr=ac_curr}
        end.
        else do:
/*N0VY*/   {&GLABRPA-P-TAG2}
           {glacbal1.i &acc=asc_acc &sub=asc_sub &cc=asc_cc
              &begdt=low_date &enddt=begdtxx &balance=beg_bal
              &yrend=yr_end &rptcurr=rpt_curr &accurr=ac_curr}
/*N0VY*/   {&GLABRPA-P-TAG3}
        end.

        /* CALCULATE PERIOD ACTIVITY */

          assign
          perknt = 0
          print_acct = yes.

         for each cal
/*J240*/ fields( glc_domain cal.glc_year cal.glc_per cal.glc_start cal.glc_end)
          where cal.glc_domain = global_domain and  cal.glc_year = yr and
          cal.glc_per >= per and
               cal.glc_per <= per1 no-lock
         break by cal.glc_per:

           /* LOOK UP TRANSACTIONS */
           assign begdt1 = begdt.
           if begdt1 < cal.glc_start then assign begdt1 = cal.glc_start.
           assign enddt1 = enddt.
           if enddt1 > cal.glc_end then assign enddt1 = cal.glc_end.
           assign knt = 0.

           {glacbal1.i &acc=asc_acc &sub=asc_sub &cc=asc_cc
              &begdt=begdt1 &enddt=enddt1 &balance=per_act
              &yrend=yr_end &rptcurr=rpt_curr &accurr=ac_curr}

           /* DISPLAY ACCOUNT AND AMOUNTS */
                   if ac_active = yes or beg_bal <> 0 or per_act <> 0 or
                   perknt <> 0 then do:
                      /* SS - 20061117.1 - B */
                      /*
              {glabrp1.i}
              */
                      {a6glabrp00011.i}
                      /* SS - 20061117.1 - E */
           end.
                   {mfrpchk.i}
        end.
                {mfrpchk.i}
         end.

             {mfrpchk.i &warn="true"}
      end.

          {mfrpchk.i}
      /*  PRINT TOTALS */

/*N014*                put skip(1) "--------------------" to 69 */
/*N014*                    "--------------------" to 94 */
/*N014*                    "--------------------" to 119 skip(1). */

/** BEGIN DELETE **                                      **M0D6*
 * /*N014*/        put skip(1) "--------------------" to 77
 * /*N014*/                    "--------------------" to 102
 * /*N014*/                    "--------------------" to 127 skip(1).
 ** END DELETE   **                                      **M0D6*/

                /* BEGIN ADDED CODE */                   /*M0D6*/
             /* SS - 20061117.1 - B */
             /*
                down 1 with frame pdetail.
                display
                   "-----------------------" @ d_beg
                   "-----------------------" @ d_act
                   "-----------------------" @ d_end
                with frame pdetail.
                down 1 with frame pdetail.
                assign
                   d_beg = et_beg_tot
                   d_act = et_per_tot
                   d_end = et_end_tot.
                display
                   d_beg
                   d_act
                   d_end
                with frame pdetail.
                */
               /* SS - 20061117.1 - E */
                /* END ADDED CODE   */                  /*M0D6*/

/*L00M*                 put beg_tot to 69 per_tot to 94 end_tot to 119.  */

/*L00M*ADD SECTION*/
/*N014*         put et_beg_tot to 69 et_per_tot to 94 et_end_tot to 119. */
/* /*N014*/ put et_beg_tot to 77 et_per_tot to 102 et_end_tot to 127. **M0D6*/
/*L01W*         {etrpconv.i beg_tot beg_tot} */
/*L01W*         {etrpconv.i per_tot per_tot} */

/*L01W*/        if et_report_curr <> rpt_curr then do:
/*L01W*/           {gprunp.i "mcpl" "p" "mc-curr-conv"
                     "(input rpt_curr,
                       input et_report_curr,
                       input et_rate1,
                       input et_rate2,
                       input beg_tot,
                       input true,   /* ROUND */
                       output beg_tot,
                       output mc-error-number)"}
/*L01W*/           if mc-error-number <> 0 then do:
/*L01W*/              {mfmsg.i mc-error-number 2}
/*L01W*/           end.

/*L01W*/           {gprunp.i "mcpl" "p" "mc-curr-conv"
                     "(input rpt_curr,
                       input et_report_curr,
                       input et_rate1,
                       input et_rate2,
                       input per_tot,
                       input true,   /* ROUND */
                       output per_tot,
                       output mc-error-number)"}
/*L01W*/           if mc-error-number <> 0 then do:
/*L01W*/              {mfmsg.i mc-error-number 2}
/*L01W*/           end.
/*L01W*/        end.  /* if et_report_curr <> rpt_curr */


                   end_tot = beg_tot + per_tot.
                   if (beg_tot <> et_beg_tot or per_tot <> et_per_tot or
                   end_tot <> et_end_tot) and et_show_diff
/*L01W*            and et_tk_active */
                   then do:
/*N014*               *BEGIN DELETE*
 *                     put et_diff_txt to 42
 *                         (et_beg_tot - beg_tot) to 69
 *                         format ">>,>>>,>>>,>>>,>>9.99cr"
 *                         (et_per_tot - per_tot) to 94
 *                         format ">>,>>>,>>>,>>>,>>9.99cr"
 *                         (et_end_tot - end_tot) to 119
 *                         format ">>,>>>,>>>,>>>,>>9.99cr".
 *N014*               *END DELETE */

/** BEGIN DELETE **                                        **M0D6*
 * /*N014*/              /* BEGIN ADD */
 *                    put et_diff_txt to 50
 *                        (et_beg_tot - beg_tot) to 77
 *                        format ">>,>>>,>>>,>>>,>>9.99cr"
 *                        (et_per_tot - per_tot) to 102
 *                        format ">>,>>>,>>>,>>>,>>9.99cr"
 *                        (et_end_tot - end_tot) to 127
 *                        format ">>,>>>,>>>,>>>,>>9.99cr".
 * /*N014*/              /*END ADD */
 ** END DELETE   **                                        **M0D6*/

                      /* BEGIN ADDED CODE */               /*M0D6*/
                      assign
                         d_desc = et_diff_txt
                         d_beg = (et_beg_tot - beg_tot)
                         d_act = (et_per_tot - per_tot)
                         d_end = (et_end_tot - end_tot).
                      /* SS - 20061117.1 - B */
                      /*
                      display
                         d_desc
                         d_beg
                         d_act
                         d_end
                      with frame pdetail.
                      */
                      /* SS - 20061117.1 - E */
                      /* END ADDED CODE   */               /*M0D6*/

                   end.
 /*L00M*END ADD SECTION*/

 /*N014*    put "====================" to 69 "====================" to 94 */
 /*N014*        "====================" to 119. */

/* BEGIN DELETE **                                          **M0D6*
 * /*N014*/   put "====================" to 77 "====================" to 102
 * /*N014*/       "====================" to 127.
 * END   DELETE **                                           *M0D6*/

                /* BEGIN ADDED CODE */                      /*M0D6*/
                   /* SS - 20061117.1 - B */
                   /*
                down with frame pdetail.
                display
                   "=======================" @ d_beg
                   "=======================" @ d_act
                   "=======================" @ d_end
                with frame pdetail.
                */
                  /* SS - 20061117.1 - E */
                /* END ADDED  CODE  */                      /*M0D6*/


         {wbrp04.i}
