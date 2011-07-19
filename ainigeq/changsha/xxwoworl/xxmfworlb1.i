/* mfworlb1.i - PRINT PICKLISTS OPTIONS INCLUDE FILE                    */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.10 $                                                    */
/*V8:ConvertMode=Maintenance                                            */
/* REVISION: 7.0     LAST MODIFIED: 04/02/92    BY: RAM *F351*          */
/* REVISION: 7.2     LAST MODIFIED: 08/18/94    BY: pxd *FQ32*          */
/* REVISION: 7.5     LAST MODIFIED: 10/13/94    BY: tjs *J027*          */
/* REVISION: 7.2     LAST MODIFIED: 10/18/94    BY: ljm *FS55*          */
/* REVISION: 8.5     LAST MODIFIED: 02/04/97    BY: *J1GW*  Russ Witt   */
/* REVISION: 8.5     LAST MODIFIED: 02/04/97    BY: *F0XM*  David Seo   */
/* REVISION: 8.6E    LAST MODIFIED: 02/23/98    BY: *L007* A. Rahane    */
/* REVISION: 8.6E    LAST MODIFIED: 05/20/98    BY: *K1Q4* Alfred Tan   */
/* REVISION: 8.6E    LAST MODIFIED: 10/04/98    BY: *J314* Alfred Tan   */
/* REVISION: 9.1     LAST MODIFIED: 03/24/00    BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1     LAST MODIFIED: 08/13/00    BY: *N0KR* myb          */
/* Old ECO marker removed, but no ECO header exists *F0PN*              */
/* $Revision: 1.10 $    BY: Katie Hilbert  DATE: 04/01/01 ECO: *P008*   */
/* SS - 091021.1 By: Neil Gao */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*!
Variable and form definitions for WO picklist print options.
*/
/*!
Input Parameters:
   {&new} "new" to define variables as new shared
   {&row} row number for top of overlay frame
*/
/************************************************************************/

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE mfworlb1_i_1 "Print floor stock items"
/* MaxLen: Comment: */

&SCOPED-DEFINE mfworlb1_i_2 "Print Co/By-Products as first or last document"
/* MaxLen: Comment: */

&SCOPED-DEFINE mfworlb1_i_3 "First/Last"
/* MaxLen: Comment: */

&SCOPED-DEFINE mfworlb1_i_4 "Include zero open"
/* MaxLen: Comment: */

&SCOPED-DEFINE mfworlb1_i_5 "Include zero required"
/* MaxLen: Comment: */

&SCOPED-DEFINE mfworlb1_i_6 "Reprint picked quantities"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

define {&new} shared variable incl_zero_reqd like mfc_logical
   label {&mfworlb1_i_5} initial yes.
define {&new} shared variable incl_zero_open like mfc_logical
   label {&mfworlb1_i_4} initial no.
define {&new} shared variable incl_pick_qtys like mfc_logical
   label {&mfworlb1_i_6} initial no.
define {&new} shared variable incl_floor_stk like mfc_logical
   label {&mfworlb1_i_1} initial yes.
define {&new} shared variable jp_1st_last_doc like mfc_logical
   label {&mfworlb1_i_2}
   format {&mfworlb1_i_3} initial "yes".

/* SS 091021.1 - B */
define {&new} shared variable xxloc  like ld_loc.
define {&new} shared variable xxloc1 like ld_loc.
/* SS 091021.1 - E */

form
/* SS 091021.1 - B */
   xxloc      colon 20 label "ø‚Œª"
   xxloc1     colon 45 label "÷¡"
/* SS 091021.1 - E */
   incl_zero_reqd       colon 57 space(2)
   incl_zero_open       colon 57 space(2)
   incl_pick_qtys       colon 57 space(2)
   incl_floor_stk       colon 57 space(2)
   jp_1st_last_doc      colon 57 space(2)
with frame a1 attr-space centered overlay row {&row} side-labels.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a1:handle).
