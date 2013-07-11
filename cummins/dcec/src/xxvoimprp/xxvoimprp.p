/* GUI CONVERTED from icsirp.p (converter v1.78) Fri Oct 29 14:37:07 2004 */
/* icsirp.p - SITE MASTER REPORT                                              */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.15 $                                                          */
/*V8:ConvertMode=FullGUIReport                                                */
/* REVISION: 6.0     LAST MODIFIED: 02/07/90   BY: EMB *                      */
/* REVISION: 6.0     LAST MODIFIED: 09/03/91   BY: afs *D847*                 */
/* Revision: 7.3     Last edit:     11/19/92   By: jcd *G348*                 */
/* REVISION: 7.3     LAST MODIFIED: 01/06/93   BY: pma *G510*                 */
/* REVISION: 7.3     LAST MODIFIED: 12/19/95   BY: bcm *G1H2*                 */
/* REVISION: 8.5     LAST MODIFIED: 03/19/96   BY: *J0CV* Robert Wachowicz    */
/* REVISION: 8.6     LAST MODIFIED: 03/11/97   BY: *K07B* Arul Victoria       */
/* REVISION: 8.6     LAST MODIFIED: 10/07/97   BY: mzv *K0M9*                 */
/* REVISION: 9.0     LAST MODIFIED: 03/10/99   BY: *M0B8* Hemanth Ebenezer    */
/* REVISION: 9.0     LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan          */
/* REVISION: 9.1     LAST MODIFIED: 10/01/99   BY: *N014* Brian Compton       */
/* REVISION: 9.1     LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane    */
/* REVISION: 9.1     LAST MODIFIED: 08/13/00   BY: *N0KS* Mark Brown          */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.12    BY: Jean Miller          DATE: 04/06/02  ECO: *P056*     */
/* Revision: 1.13  BY: Patrick Rowan DATE: 05/24/02 ECO: *P018* */
/* $Revision: 1.15 $ BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00G* */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* DISPLAY TITLE */

/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdtitle.i "130709.1"}

/* title "121207.1" */

{xxapvorp0001.i "NEW"}

define variable vend like ap_vend.
define variable vend1 like ap_vend.
define new shared variable ref like ap_ref.
define new shared variable ref1 like ap_ref.
define new shared variable batch like ap_batch.
define new shared variable batch1 like ap_batch.
define variable apdate like ap_date.
define variable apdate1 like ap_date.
define variable duedate like vo_due_date.
define variable duedate1 like vo_due_date.
define variable po like po_nbr.
define variable po1 like po_nbr.
define variable invoice like vo_invoice.
define variable invoice1 like vo_invoice.
define variable show_conf like mfc_logical.
define variable show_unconf like mfc_logical initial yes.

/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/

 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
   batch          colon 22
   batch1         colon 48 label {t001.i}
   ref            colon 22
   ref1           colon 48 label {t001.i}
   vend           colon 22
   vend1          colon 48 label {t001.i}
   apdate         colon 22
   apdate1        colon 48 label {t001.i}
   duedate        colon 22
   duedate1       colon 48 label {t001.i}
   po             colon 22
   po1            colon 48 label {t001.i}
   invoice        colon 22
   invoice1       colon 48 label {t001.i}
   show_conf       colon 22
   show_unconf     colon 48 label {t001.i} skip(1)

 SKIP(.4)  /*GUI*/
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER.
 F-a-title = &IF DEFINED(GPLABEL_I)=0 &THEN
   &IF (DEFINED(SELECTION_CRITERIA) = 0)
   &THEN " Selection Criteria "
   &ELSE {&SELECTION_CRITERIA}
   &ENDIF
&ELSE
   getTermLabel("SELECTION_CRITERIA", 25).
&ENDIF.
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame a =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame a + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5. /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME


/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{wbrp01.i}

/*GUI*/ {mfguirpa.i false "printer" 132 " " " " " "  }

/*GUI repeat : */
/*GUI*/ procedure p-enable-ui:

   if batch1 = hi_char then batch1 = "".
   if ref1 = hi_char then ref1 = "".
   if vend1 = hi_char then vend1 = "".
   if apdate = low_date then apdate = ?.
   if apdate1 = hi_date then apdate1 = ?.
   if duedate = low_date then duedate = ?.
   if duedate1 = hi_date then duedate1 = ?.
   if po1 = hi_char then po1 = "".
   if invoice1 = hi_char then invoice1 = "".

   if c-application-mode <> 'web' then

run p-action-fields (input "display").
run p-action-fields (input "enable").
end procedure. /* p-enable-ui, replacement of Data-Entry GUI*/

/*GUI*/ procedure p-report-quote:


   {wbrp06.i &command = update
             &fields = " batch batch1 ref ref1 vend vend1 apdate apdate1 duedate duedate1 po po1 invoice invoice1 show_conf show_unconf"
             &frm = "a"}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:
      if batch1 = "" then batch1 = hi_char.
      if ref1 = "" then ref1 = hi_char.
      if vend1 = "" then vend1 = hi_char.
      if apdate = ? then apdate = low_date.
      if apdate1 = ? then apdate1 = hi_date.
      if duedate = ? then duedate = low_date.
      if duedate1 = ? then duedate1 = hi_date.
      if po1 = "" then po1 = hi_char.
      if invoice1 = "" then invoice1 = hi_char.
   end.

   /* OUTPUT DESTINATION SELECTION */

/*GUI*/ end procedure. /* p-report-quote */
/*GUI - Field Trigger Section */

/*GUI MFSELxxx removed*/
/*GUI*/ procedure p-report:
/*GUI*/   {gpprtrpa.i "printer" 132 " " " " " " " " }
/*GUI*/   mainloop: do on error undo, return error on endkey undo, return error:

   EMPTY TEMP-TABLE ttssapvorp0001 no-error.
   {gprun.i ""xxapvorp0001.p"" "(
      input batch,
      input batch1,
      input ref,
      input ref1,
      input '',
      input hi_char,
      input '',
      input hi_char,
      input vend,
      input vend1,
      input '',
      input hi_char,
      input apdate,
      input apdate1,
      input duedate,
      input duedate1,
      input no,
      input no,
      input show_conf,
      input show_unconf,
      input '',
      input no
      )"}


/*
ƾ֤�š���Ʊ�š���Ʊ���ڡ���˰�PO���ջ���������š����������ۡ����Ӧ�̡��������ڡ����ۡ��������
*/
   {mfphead.i}
     for each ttssapvorp0001 exclusive-lock
        where ttssapvorp0001_vo_invoice >= invoice and
             ttssapvorp0001_vo_invoice <= invoice1 and
             ttssapvorp0001_vopo >= po and
             ttssapvorp0001_vopo <= po1:
         find first vod_det no-lock where
                    vod_det.vod_domain = global_domain and
                    vod_ref = ttssapvorp0001_vo_ref and
                    vod_det.vod_acct = "222100" no-error.
         if available vod_det then do:
            assign ttssapvorp0001_vod_amt = vod_base_amt.
         end.
         find first glt_det no-lock where glt_domain = global_domain
                and glt_batch = ttssapvorp0001_ap_batch no-error.
         if available glt_det then do:
            assign ttssapvorp0001_trgl_gl_ref = glt_ref.
         end.
/*
         find first tr_hist use-index tr_type WHERE tr_domain = global_domain
             AND tr_type = "rct-po"
             AND tr_lot = ttssapvorp0001_prh_receiver
             AND tr_line = ttssapvorp0001_prh_line NO-LOCK no-error.
         if available tr_hist then do:
            find first trgl_det no-lock where  trgl_domain = global_domain and
                 trgl_trnbr = tr_trnbr no-error.
            if available trgl_det then do:
               assign ttssapvorp0001_trgl_gl_ref = trgl_gl_ref.
            end.
         END.
*/
      end.
   for each ttssapvorp0001 no-lock
       where ttssapvorp0001_vo_invoice >= invoice and
             ttssapvorp0001_vo_invoice <= invoice1 and
             ttssapvorp0001_vopo >= po and
             ttssapvorp0001_vopo <= po1
   with frame b width 500 no-attr-space:
   setFrameLabels(frame b:handle).
      /*
      display ttxxapvorp0002_vo_ref
              ttxxapvorp0002_vo_invoice
              ttxxapvorp0002_ap_date
              ttxxapvorp0002_vopo
              */
      display ttssapvorp0001_ap_batch
              ttssapvorp0001_trgl_gl_ref
              ttssapvorp0001_vo_ref
              ttssapvorp0001_vo_invoice
              ttssapvorp0001_ap_effdate
              ttssapvorp0001_ap_date
              ttssapvorp0001_ap_amt
              ttssapvorp0001_vopo
              ttssapvorp0001_prh_receiver
              ttssapvorp0001_prh_line
              ttssapvorp0001_prh_part
              ttssapvorp0001_prh_rcp_date
              ttssapvorp0001_inv_qty
              ttssapvorp0001_pur_amt
              ttssapvorp0001_inv_amt
              ttssapvorp0001_ap_vend
              ttssapvorp0001_vod_amt
              ttssapvorp0001_vo_hold_amt
        /*    ttssapvorp0001_vo_confirmed */
              ttssapvorp0001_vo_conf_by
              with stream-io.




/*GUI*/ {mfguichk.i } /*Replace mfrpchk*/

   end.


/*GUI*/ {mfguitrl.i} /*Replace mfrtrail*/

/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/


end.

{wbrp04.i &frame-spec = a}

/*GUI*/ end procedure. /*p-report*/
/*GUI*/ {mfguirpb.i &flds=" batch batch1 ref ref1 vend vend1 apdate apdate1 duedate duedate1 po po1 invoice invoice1 show_conf show_unconf"} /*Drive the Report*/
