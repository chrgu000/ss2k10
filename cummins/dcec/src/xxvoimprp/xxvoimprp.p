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

{mfdtitle.i "121207.1"}
{xxapvorp0001.i "NEW"}

define new shared variable vend like ap_vend.
define new shared variable vend1 like ap_vend.
define new shared variable apdate like ap_date.
define new shared variable apdate1 like ap_date.
define new shared variable po like po_nbr.
define new shared variable po1 like po_nbr.
define new shared variable invoice like vo_invoice.
define new shared variable invoice1 like vo_invoice.

/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
	 vend           colon 25
   vend1          colon 46 label {t001.i}
   apdate					colon 25       
   apdate1        colon 46 label {t001.i} 
   po             colon 25       
   po1            colon 46 label {t001.i} 
   invoice        colon 25       
   invoice1       colon 46 label {t001.i} skip(1)
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


   if vend1 = hi_char then vend1 = "".
   if apdate = low_date then apdate = ?.
   if apdate1 = hi_date then apdate1 = ?.
   if po1 = hi_char then po1 = "".
	 if invoice1 = hi_char then invoice1 = "".
	
   if c-application-mode <> 'web' then
      
run p-action-fields (input "display").
run p-action-fields (input "enable").
end procedure. /* p-enable-ui, replacement of Data-Entry GUI*/

/*GUI*/ procedure p-report-quote:


   {wbrp06.i &command = update  
   					 &fields = " vend vend1 apdate apdate1 po po1 invoice invoice1" 
   					 &frm = "a"}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:
      if vend1 = "" then vend1 = hi_char.
      if apdate = ? then apdate = low_date.
      if apdate1 = ? then apdate1 = hi_date.
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
      input '',
      input hi_char,
      input '',
      input hi_char,
      input '',
      input hi_char,
      input '',
      input hi_char,
      input '',
      input hi_char,
      input '',
      input hi_char,
      input low_date,
      input hi_date,
      input low_date,
      input hi_date,
      input no,
      input no,
      input no,
      input yes,
      input '',
      input no
      )"}
      
      
/*
凭证号、发票号、开票日期、金额、税额、PO、收货单、零件号、数量、单价、项、供应商、发货日期、单价、暂留金额
*/
   {mfphead.i}
   for each ttssapvorp0001 no-lock
   	/*	 where ttxxapvorp0002_vo_invoice >= invoice and 
   		 			 ttxxapvorp0002_vo_invoice <= invoice1 and
   		 			 ttxxapvorp0002_vopo >= po and
   		 			 ttxxapvorp0002_vopo <= po1 */
   with frame b width 592 no-attr-space:
			/*
			display ttxxapvorp0002_vo_ref
							ttxxapvorp0002_vo_invoice
							ttxxapvorp0002_ap_date
							ttxxapvorp0002_vopo
							*/
		  display ttssapvorp0001_vo_ref
		          ttssapvorp0001_vo_invoice
		          ttssapvorp0001_ap_date
		  				ttssapvorp0001_ap_amt
		  				ttssapvorp0001_vopo
		  				ttssapvorp0001_prh_receiver
		  				ttssapvorp0001_prh_part
		  				ttssapvorp0001_inv_qty
		  				ttssapvorp0001_pur_amt
		  				ttssapvorp0001_inv_amt
		  				ttssapvorp0001_prh_line
		  				ttssapvorp0001_ap_vend
		  				ttssapvorp0001_vo_hold_amt
		  			  with stream-io.
					
      setFrameLabels(frame b:handle).

      
/*GUI*/ {mfguichk.i } /*Replace mfrpchk*/

   end.

   
/*GUI*/ {mfguitrl.i} /*Replace mfrtrail*/

/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/


end.

{wbrp04.i &frame-spec = a}

/*GUI*/ end procedure. /*p-report*/
/*GUI*/ {mfguirpb.i &flds=" vend vend1 apdate apdate1 po po1 invoice invoice1"} /*Drive the Report*/
