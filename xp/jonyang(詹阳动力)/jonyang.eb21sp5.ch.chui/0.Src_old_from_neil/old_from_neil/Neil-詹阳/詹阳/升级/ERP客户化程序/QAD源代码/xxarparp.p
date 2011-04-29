/* GUI CONVERTED from arparp.p (converter v1.71) Fri Aug 21 18:36:39 1998 */
/* arparp.p - DETAIL PAYMENT AUDIT REPORT                               */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/* web convert arparp.p (converter v1.00) Fri Oct 10 13:57:06 1997 */
/* web tag in arparp.p (converter v1.00) Mon Oct 06 14:17:23 1997 */
/*F0PN*/ /*K0QK*/ /*V8#ConvertMode=WebReport                            */
/*V8:ConvertMode=FullGUIReport                                 */
/*K1Q4*/ /*V8:WebEnabled=No                                             */
/* REVISION: 2.0      LAST MODIFIED: 12/09/86   BY: PML        */
/* REVISION: 4.0      LAST MODIFIED: 02/16/88   BY: FLM *A175* */
/* REVISION: 4.0      LAST MODIFIED: 07/27/88   BY: JC *C0028* */
/* REVISION: 4.0      LAST MODIFIED: 12/06/88   BY: JLC*C0028* */
/* REVISION: 5.0      LAST MODIFIED: 05/12/89   BY: MLB *B099* */
/* REVISION: 5.0      LAST MODIFIED: 06/23/89   BY: MLB *B159* */
/* REVISION: 5.0      LAST MODIFIED: 09/14/89   BY: MLB *B289* */
/* REVISION: 5.0      LAST MODIFIED: 10/04/89   BY: MLB *B326* */
/* REVISION: 5.0      LAST MODIFIED: 10/05/89   BY: MLB *B324* */
/* REVISION: 6.0      LAST MODIFIED: 08/29/90   BY: afs *D059* */
/* REVISION: 6.0      LAST MODIFIED: 08/31/90   BY: MLB *D055* */
/* REVISION: 6.0      LAST MODIFIED: 10/29/90   BY: MLB *D153* */
/* REVISION: 6.0      LAST MODIFIED: 02/28/91   BY: afs *D387* */
/* REVISION: 6.0      LAST MODIFIED: 03/15/91   BY: bjb *D461* */
/* REVISION: 6.0      LAST MODIFIED: 03/19/91   BY: MLB *D444* */
/* REVISION: 6.0      LAST MODIFIED: 04/17/91   BY: bjb *D515* */
/* REVISION: 7.0      LAST MODIFIED: 10/28/91   BY: MLV *F028* */
/* REVISION: 6.0      LAST MODIFIED: 11/18/19   BY: afs *D935* */
/* REVISION: 7.0      LAST MODIFIED: 03/04/92   BY: jms *F237* */
/* REVISION: 7.0      LAST MODIFIED: 03/17/92   BY: TMD *F258* */
/*                                   05/04/92   by: jms *F466* */
/* REVISION: 7.3      LAST MODIFIED: 08/03/92   by: jms *G024* */
/*                                   09/30/92   by: jms *G111* */
/*                                   09/27/93   by: jcd *G247* */
/*                                   11/23/92   by: mpp *G351* */
/*                                   03/17/93   by: bcm *G834* */
/*                                   04/20/93   by: bcm *G981* */
/* REVISION: 7.3      LAST MODIFIED: 06/29/93   by: pcd *GC86* REV ONLY */
/*                                   08/17/93   by: jjs *GE34*          */
/*                                           (split off arparpa.p)      */
/*                                   08/23/94   by: rxm *GL40*          */
/* Oracle changes (share-locks)    09/11/94           BY: rwl *FR14*    */
/* REVISION: 7.4      LAST MODIFIED: 10/27/94   by: ame *GN63* */
/* REVISION: 8.5      LAST MODIFIED: 12/13/95   by: taf *J053* */
/*                                   04/09/96   by: jzw *G1T9* */
/* REVISION: 8.6      LAST MODIFIED: 03/18/97   BY: *K082* E. HUGHART */
/* REVISION: 8.6      LAST MODIFIED: 10/16/97   BY: bvm *K0QK* */

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/*                                   8 apr 98   by: rup *L00K* */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan   */
/* REVISION: 8.6E     LAST MODIFIED: 07/21/98   BY: *L01K* Jaydeep Parikh */


/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

/* L00K* */ {mfdtitle.i "e+ "}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE arparp_p_1 "S-汇总/D-明细"
/* MaxLen: Comment: */

&SCOPED-DEFINE arparp_p_2 "打印总帐明细"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

         /* DEFINE NEW SHARED WORKFILE AP_WKFL FOR CURRENCY SUMMARY */
         {gpacctp.i "new"}

         {gldydef.i new}
         {gldynrm.i new}

         define new shared variable rndmthd like rnd_rnd_mthd.
         /* DEFINE OLD_CURR FOR CALL TO GPACCTP.P */
         define new shared variable old_curr like ar_curr initial "".
         define new shared variable cust like ar_bill.
         define new shared variable cust1 like ar_bill.
         define new shared variable check_nbr like ar_check.
         define new shared variable check1 like ar_check.
         define new shared variable batch like ar_batch.
         define new shared variable batch1 like ar_batch.
         define new shared variable entity like ar_entity.
         define new shared variable entity1 like ar_entity.
         define new shared variable ardate like ar_date.
         define new shared variable ardate1 like ar_date.
         define new shared variable effdate like ar_effdate.
         define new shared variable effdate1 like ar_effdate.
         define new shared variable summary like mfc_logical
            format {&arparp_p_1} initial no label {&arparp_p_1}.
         define new shared variable gltrans like mfc_logical initial no
           label {&arparp_p_2}.
         define new shared variable base_rpt like ar_curr.
         define new shared variable mixed_rpt like mfc_logical initial no
            label {gpmixlbl.i}.

/*L00K*/ {etvar.i   &new = "new"}
/*L00K*/ {etrpvar.i &new = "new"}
/*L01K*
* /*L00K*/ {eteuro.i}
**L01K*/
         /*CHECK FOR VAT TAXES */
         find first gl_ctrl no-lock.
         
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
            
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
batch          colon 18
            batch1         label {t001.i} colon 49 skip
            check_nbr      colon 18
            check1         label {t001.i} colon 49 skip
            cust           colon 18
            cust1          label {t001.i} colon 49 skip
            entity   colon 18
            entity1  label {t001.i} colon 49 skip
            ardate         colon 18
            ardate1        label {t001.i} colon 49 skip
            effdate        colon 18
            effdate1       label {t001.i} colon 49 skip (1)
            summary        colon 25
            gltrans        colon 25
            base_rpt       colon 25
            mixed_rpt      colon 25
          SKIP(.4)  /*GUI*/
with frame a side-labels width 80 NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER.
 F-a-title = &IF (DEFINED(SELECTION_CRITERIA) = 0)
  &THEN " 选择条件 "
  &ELSE {&SELECTION_CRITERIA}
  &ENDIF .
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame a =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame a + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5. /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME



         {wbrp01.i}

         
/*GUI*/ {mfguirpa.i true  "printer" 132 }

/*GUI repeat : */
/*GUI*/ procedure p-enable-ui:


            find first ap_wkfl no-error.
            if available ap_wkfl then

               for each ap_wkfl exclusive-lock:
                   delete ap_wkfl.
               end.

            if batch1 = hi_char then batch1 = "".
            if check1 = hi_char then check1 = "".
            if cust1 = hi_char then cust1 = "".
            if entity1 = hi_char then entity1 = "".
            if ardate = low_date then ardate = ?.
            if ardate1 = hi_date then ardate1 = ?.
            if effdate = low_date then effdate = ?.
            if effdate1 = hi_date then effdate1 = ?.

            if c-application-mode <> 'web':u then
            
run p-action-fields (input "display").
run p-action-fields (input "enable").
end procedure. /* p-enable-ui, replacement of Data-Entry GUI*/

/*GUI*/ procedure p-report-quote:


         {wbrp06.i &command = update
                   &fields = "  batch batch1 check_nbr check1
                                cust cust1 entity entity1 ardate ardate1
                                effdate effdate1 summary gltrans base_rpt
                                mixed_rpt" &frm = "a"}

         if (c-application-mode <> 'web':u) or
         (c-application-mode = 'web':u and
         (c-web-request begins 'data':u)) then do:

            bcdparm = "".
            {mfquoter.i batch    }
            {mfquoter.i batch1   }
            {mfquoter.i check_nbr}
            {mfquoter.i check1   }
            {mfquoter.i cust     }
            {mfquoter.i cust1    }
            {mfquoter.i entity   }
            {mfquoter.i entity1  }
            {mfquoter.i ardate   }
            {mfquoter.i ardate1  }
            {mfquoter.i effdate  }
            {mfquoter.i effdate1 }
            {mfquoter.i summary  }
            {mfquoter.i gltrans  }
            {mfquoter.i base_rpt}
            {mfquoter.i mixed_rpt}

            if batch1 = "" then batch1 = hi_char.
            if check1 = "" then check1 = hi_char.
            if cust1 = "" then cust1 = hi_char.
            if entity1 = "" then entity1 = hi_char.
            if ardate = ? then ardate = low_date.
            if ardate1 = ? then ardate1 = hi_date.
            if effdate = ? then effdate = low_date.
            if effdate1 = ? then effdate1 = hi_date.

         end.

            /* SELECT PRINTER */
            
/*GUI*/ end procedure. /* p-report-quote */
/*GUI - Field Trigger Section */

/*GUI MFSELxxx removed*/
/*GUI*/ procedure p-report:
/*GUI*/   {gpprtrpa.i  "printer" 132}
/*GUI*/   mainloop: do on error undo, return error on endkey undo, return error:
find first gl_ctrl no-lock.
find first ap_wkfl no-error.



            {mfphead2.i}

            if daybooks-in-use then
               {gprun.i ""nrm.p"" "persistent set h-nrm"}.

            /* DELETE GL WORKFILE ENTRIES */
            if gltrans = yes then do:
               for each gltw_wkfl exclusive-lock
                  where gltw_userid = mfguser:
                  delete gltw_wkfl.
               end.
            end.

            /* PRINT BODY OF REPORT */
            {gprun.i ""xxarparpa.p""}

            /* PRINT GL DISTRIBUTION */
            if gltrans then do:
               page.
               {gprun.i ""gpglrp.p""}
            end.

/*  Display Currency Totals.                                            */
             if base_rpt = ""
             and mixed_rpt
             then
                 {gprun.i ""gpacctp.p""}.

   /* REPORT TRAILER */
            
/*GUI*//* {mfguitrl.i} Replace mfrtrail*/

/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/

            if daybooks-in-use then delete procedure h-nrm no-error.

         end.

         {wbrp04.i &frame-spec = a}

/*GUI*/ end procedure. /*p-report*/
/*GUI*/ {mfguirpb.i &flds=" batch batch1 check_nbr check1 cust cust1 entity entity1 ardate ardate1 effdate effdate1 summary gltrans base_rpt mixed_rpt "} /*Drive the Report*/
