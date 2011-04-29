/* GUI CONVERTED from apckrp.p (converter v1.71) Tue Oct  6 14:16:05 1998 */
/* apckrp.p - AP CHECK REGISTER AUDIT REPORT                              */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.   */
/* web convert apckrp.p (converter v1.00) Fri Oct 10 13:57:05 1997 */
/* web tag in apckrp.p (converter v1.00) Mon Oct 06 14:17:22 1997 */
/*F0PN*/ /*K0QV*/ /*V8#ConvertMode=WebReport                            */
/*V8:ConvertMode=FullGUIReport                                   */
/* REVISION: 1.0      LAST MODIFIED: 10/20/86   BY: PML                   */
/* REVISION: 6.0      LAST MODIFIED: 02/22/91   BY: mlv *D361*            */
/*                                   04/03/91   BY: mlv *D494*            */
/* REVISION: 7.0      LAST MODIFIED: 01/27/92   BY: mlv *F098*            */
/*                                   05/19/92   BY: mlv *F509*(rev only)  */
/*                                   05/21/92   BY: mlv *F461*            */
/* REVISION: 7.3      LAST MODIFIED: 09/27/93   BY: jcd *G247*            */
/*                                   04/12/93   BY: jms *G937* (rev only) */
/*                                   04/17/93   BY: jms *G967* (rev only) */
/*                                   07/22/93   BY: wep *GD59* (rev only) */
/*                                   09/16/93   BY: bcm *GF38* (rev only) */
/* REVISION: 7.4      LAST MODIFIED: 09/21/93   BY: bcm *H110* (rev only) */
/*                                   11/24/93   BY: wep *H245*            */
/* REVISION: 7.4      LAST MODIFIED: 10/27/94   BY: ame *FS90*            */
/* REVISION: 7.4      LAST MODIFIED: 02/11/95   BY: ljm *G0DZ*            */
/*                                   04/10/96   BY: jzw *G1LD*            */
/* REVISION: 8.6      LAST MODIFIED: 10/14/97   BY: ckm *K0QV*            */

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan     */

/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

/*G1LD*/ {mfdtitle.i "e+ "}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE apckrp_p_1 "供应商类型"
/* MaxLen: Comment: */

&SCOPED-DEFINE apckrp_p_2 "S-汇总/D-明细"
/* MaxLen: Comment: */

&SCOPED-DEFINE apckrp_p_3 "按供应商排序"
/* MaxLen: Comment: */

&SCOPED-DEFINE apckrp_p_4 "支票"
/* MaxLen: Comment: */

&SCOPED-DEFINE apckrp_p_5 "打印总帐明细"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */


    define new shared variable vend         like ap_vend.
    define new shared variable vend1        like ap_vend.
    define new shared variable batch        like ap_batch.
    define new shared variable batch1       like ap_batch.
    define new shared variable apdate       like ap_date.
    define new shared variable apdate1      like ap_date.
    define new shared variable effdate      like ap_effdate.
    define new shared variable effdate1     like ap_effdate.
    define new shared variable bank         like ck_bank.
    define new shared variable bank1        like ck_bank.
/*G0DZ*/ /*V8+*/      
    define new shared variable nbr          as integer format ">999999"
    label {&apckrp_p_4}.
    define new shared variable nbr1         as integer format ">999999".   
    define new shared variable entity       like ap_entity.
    define new shared variable entity1      like ap_entity.
    define new shared variable ckfrm        like ap_ckfrm.
    define new shared variable ckfrm1       like ap_ckfrm.
    define new shared variable summary      like mfc_logical
       format {&apckrp_p_2} label {&apckrp_p_2}.
    define new shared variable gltrans      like mfc_logical initial no
       label {&apckrp_p_5}.
    define new shared variable base_rpt     like ap_curr.
/*G1LD*    initial "Base" format "x(04)". */
    define new shared variable vdtype       like vd_type
       label {&apckrp_p_1}.
    define new shared variable vdtype1      like vdtype.
/*F461*/define new shared variable sort_by_vend like mfc_logical
       label {&apckrp_p_3}.
/*H245*/define new shared variable duedate      like vo_due_date.
/*H245*/define new shared variable duedate1     like vo_due_date.

/*G247* define shared variable mfguser as character.     */

/*G1LD* *H245* {mfdtitle.i "e+ "} */

    
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
       
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
batch          colon 15
       batch1         label {t001.i} colon 49 skip
       nbr            colon 15
       nbr1           label {t001.i} colon 49 skip
       bank           colon 15
       bank1          label {t001.i} colon 49 skip
       ckfrm          colon 15
       ckfrm1         label {t001.i} colon 49 skip
       entity         colon 15
       entity1        label {t001.i} colon 49 skip
       vend           colon 15
       vend1          label {t001.i} colon 49 skip
       vdtype         colon 15
       vdtype1        label {t001.i} colon 49 skip
       apdate         colon 15
       apdate1        label {t001.i} colon 49 skip
       effdate        colon 15
       effdate1       label {t001.i} colon 49
/*H245*/   duedate        colon 15
/*H245*/   duedate1       label {t001.i} colon 49 skip(1)
       summary        colon 25
/*F461*/   sort_by_vend   colon 25
       gltrans        colon 25
       base_rpt       colon 25
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




/*K0QV*/ {wbrp01.i}
       
/*GUI*/ {mfguirpa.i true  "printer" 132 }

/*GUI repeat : */
/*GUI*/ procedure p-enable-ui:

       if nbr1     = 999999   then nbr1     = 0.
       if batch1   = hi_char  then batch1   = "".
       if bank1    = hi_char  then bank1    = "".
       if vend1    = hi_char  then vend1    = "".
       if apdate   = low_date then apdate   = ?.
       if apdate1  = hi_date  then apdate1  = ?.
       if effdate  = low_date then effdate  = ?.
       if effdate1 = hi_date  then effdate1 = ?.
/*H245*/   if duedate  = low_date then duedate  = ?.
/*H245*/   if duedate1 = hi_date  then duedate1 = ?.
       if entity1  = hi_char  then entity1  = "".
       if vdtype1  = hi_char  then vdtype1  = "".
       if ckfrm1   = hi_char  then ckfrm1   = "".


/*K0QV*/ if c-application-mode <> 'web':u then
          
run p-action-fields (input "display").
run p-action-fields (input "enable").
end procedure. /* p-enable-ui, replacement of Data-Entry GUI*/

/*GUI*/ procedure p-report-quote:


/*K0QV*/ {wbrp06.i &command = update &fields = "  batch batch1 nbr nbr1 bank bank1
ckfrm ckfrm1 entity entity1 vend vend1 vdtype vdtype1 apdate apdate1 effdate effdate1
duedate duedate1 summary  sort_by_vend gltrans base_rpt" &frm = "a"}

/*K0QV*/ if (c-application-mode <> 'web':u) or
/*K0QV*/ (c-application-mode = 'web':u and
/*K0QV*/ (c-web-request begins 'data':u)) then do:


       bcdparm = "".
       {mfquoter.i batch}
       {mfquoter.i batch1}
       {mfquoter.i nbr}
       {mfquoter.i nbr1}
       {mfquoter.i bank}
       {mfquoter.i bank1}
       {mfquoter.i ckfrm  }
       {mfquoter.i ckfrm1  }
       {mfquoter.i entity}
       {mfquoter.i entity1}
       {mfquoter.i vend}
       {mfquoter.i vend1}
       {mfquoter.i vdtype  }
       {mfquoter.i vdtype1  }
       {mfquoter.i apdate}
       {mfquoter.i apdate1}
       {mfquoter.i effdate}
       {mfquoter.i effdate1}
/*H245*/   {mfquoter.i duedate}
/*H245*/   {mfquoter.i duedate1}
       {mfquoter.i summary}
/*F461*/   {mfquoter.i sort_by_vend}
       {mfquoter.i gltrans}
       {mfquoter.i base_rpt}

       if nbr1 = 0     then nbr1     = 999999.
       if batch1 = ""  then batch1   = hi_char.
       if bank1 = ""   then bank1    = hi_char.
       if vend1 = ""   then vend1    = hi_char.
       if apdate = ?   then apdate   = low_date.
       if apdate1 = ?  then apdate1  = hi_date.
       if effdate = ?  then effdate  = low_date.
       if effdate1 = ? then effdate1 = hi_date.
/*H245*/   if duedate = ?  then duedate  = low_date.
/*H245*/   if duedate1 = ? then duedate1 = hi_date.
       if entity1 = "" then entity1  = hi_char.
       if vdtype1 = "" then vdtype1  = hi_char.
       if ckfrm1 = ""  then ckfrm1   = hi_char.

/*K0QV*/ end.

       /* SELECT PRINTER */
          
/*GUI*/ end procedure. /* p-report-quote */
/*GUI - Field Trigger Section */

/*GUI MFSELxxx removed*/
/*GUI*/ procedure p-report:
/*GUI*/   {gpprtrpa.i  "printer" 132}
/*GUI*/   mainloop: do on error undo, return error on endkey undo, return error:



       {mfphead2.i}


       /* DELETE GL WORKFILE ENTRIES */
       if gltrans = yes then do:

/*FS90*       for each gltw_wkfl where gltw_userid = mfguser:*/
/*FS90*/      for each gltw_wkfl exclusive-lock
/*FS90*/      where gltw_userid = mfguser:
         delete gltw_wkfl.
          end.
       end.

/*F461*/   if sort_by_vend then do:
/*F461*/      {gprun.i ""XXapckrpb.p""}
   display  "制单：______________ 审批：______________ 批准：_______________ 收票人：____________" WITH WIDTH 120.  
/*F461*/   end.
/*F461*/   else do:
          {gprun.i ""XXapckrpa.p""}
   display  "制单：______________ 审批：______________ 批准：_______________ 收票人：____________" WITH WIDTH 120. 
/*F461*/   end.

       /* PRINT GL DISTRIBUTION */
       if gltrans then do:
          page.
          {gprun.i ""gpglrp.p""}
       end.
       /* REPORT TRAILER */
       
/*GUI*/ /*{mfguitrl.i} Replace mfrtrail*/

/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/


    end.

/*K0QV*/ {wbrp04.i &frame-spec = a}

/*GUI*/ end procedure. /*p-report*/
/*GUI*/ {mfguirpb.i &flds=" batch batch1 nbr nbr1 bank bank1 ckfrm ckfrm1 entity entity1 vend vend1 vdtype vdtype1 apdate apdate1 effdate effdate1  duedate duedate1 summary  sort_by_vend gltrans base_rpt "} /*Drive the Report*/
