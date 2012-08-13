/* xxptcuiq.p - ITEM ENGINEERING COPPER WEIGHT DATA INQUIRY */
/* Copyright 2004 Shanghai e-Steering Inc., Shanghai , CHINA                  */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.4.1.5 $                                                        */
/*V8:ConvertMode=Report                                                       */
/* REVISION: 7.0      LAST MODIFIED: 03/12/92   BY: WUG *F281**/
/* REVISION: 8.6      LAST MODIFIED: 10/09/97   BY: mzv *K0PT**/
/* REVISION: 8.6      LAST MODIFIED: 11/20/97   BY: *G2QD* Manmohan Pardesi   */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KQ* Mark Brown         */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.4.1.3   BY: Jean Miller         DATE: 12/11/01  ECO: *P03N*    */
/* $Revision: 1.4.1.5 $  BY: Santhosh Nair       DATE: 07/11/02  ECO: *P0BC*    */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdeclre.i}

/* EXTERNAL LABEL INCLUDE */
{gplabel.i}

{wbrp01.i}

define variable ppform as character no-undo.

ppform = "a".

{gprun.i ""xxptcuiqb.p"" "(input ppform)"}

{wbrp04.i}
