/* GUI CONVERTED from bmwuiq.p (converter v1.76) Tue Jun  4 05:16:51 2002 */
/* bmwuiq.p - WHERE-USED INQUIRY                                              */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.4.1.5 $                                                       */
/*V8:ConvertMode=Report                                                       */
/* REVISION: 1.0      LAST EDIT:     06/11/86   BY: EMB                       */
/* REVISION: 2.1      LAST EDIT:     09/02/87   BY: WUG *A94*                 */
/* REVISION: 4.0      LAST EDIT:     12/30/87   BY: WUG *A137*                */
/* REVISION: 4.0      LAST EDIT:     04/28/88   BY: EMB                       */
/* REVISION: 5.0      LAST EDIT:     05/03/89   BY: WUG *B098*                */
/* REVISION: 6.0      LAST EDIT:     10/26/90   BY: emb *D145*                */
/* REVISION: 7.0      LAST EDIT:     01/02/92   BY: emb                       */
/* REVISION: 7.2      LAST MODIFIED: 11/02/92   BY: pma *G265*                */
/* REVISION: 8.6      LAST MODIFIED: 10/16/97   BY: mur *K124*                */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* jyn                */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* $Revision: 1.4.1.5 $   BY: Jean Miller        DATE: 05/25/02  ECO: *P076*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

define new shared variable transtype as character format "x(4)".
{wbrp01.i}

transtype = "BM".
/*{gprun.i ""bmwuiqa.p""}   */
{gprun.i ""yybbmwuiqa1.p""}      /*judy*/
{wbrp04.i}
