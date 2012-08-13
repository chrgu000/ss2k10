/* GUI CONVERTED from bmpkiq.p (converter v1.75) Sun Aug 13 21:22:57 2000 */
/* bmpkiq.p - SIMULATED PICKLIST INQUIRY                                */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*F0PN*/ /*V8:ConvertMode=Report                                        */
/* REVISION: 1.0        LAST EDIT:     05/05/86   BY: EMB               */
/* REVISION: 1.0        LAST EDIT:     01/29/87   BY: EMB *A19*         */
/* REVISION: 2.1        LAST EDIT:     10/20/87   BY: WUG *A94*         */
/* REVISION: 4.0        LAST EDIT:     12/30/87   BY: WUG *A137*        */
/* REVISION: 4.0        LAST EDIT:     07/12/88   BY: flm *A318*        */
/* REVISION: 4.0        LAST EDIT:     08/03/88   BY: flm *A375*        */
/* REVISION: 4.0        LAST EDIT:     11/04/88   BY: flm *A520*        */
/* REVISION: 4.0        LAST EDIT:     11/15/88   BY: emb *A535*        */
/* REVISION: 4.0        LAST EDIT:     02/21/89   BY: emb *A654*        */
/* REVISION: 5.0        LAST EDIT:     05/03/89   BY: WUG *B098*        */
/* REVISION: 5.0        LAST MODIFIED: 06/23/89   BY: MLB *B159*        */
/* REVISION: 6.0        LAST MODIFIED: 07/11/90   BY: WUG *D051*        */
/* REVISION: 7.2        LAST MODIFIED: 10/26/92   BY: emb *G234*        */
/* REVISION: 7.2        LAST MODIFIED: 11/02/92   BY: pma *G265*        */
/* REVISION: 8.6        LAST MODIFIED: 09/27/97   BY: mzv *K0J *        */
/* REVISION: 8.6        LAST MODIFIED: 10/15/97   BY: mur *K11D*        */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00 BY: *N0KK* jyn              */
/*G265***********************************************************************/
/*                     MOVED ENTIRE EXISTING LOGIC                          */
/*                          TO BMPKIQA.P                                    */
/*                                                                          */
/*       (NOTE: THE REPORT PRODUCED IS IDENTICAL TO THE PREVIOUS ONE)       */
/*       (      SEE BMWUIQA.P FOR EXAMPLE OF HOW DISPLAYS CAN DIVERGE)      */
/*G265***********************************************************************/

/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

pause 0.
/*G265*/ {mfdeclre.i}
{gplabel.i &ClearReg=yes} /* EXTERNAL LABEL INCLUDE */
/*G265*/ define new shared variable transtype as character format "x(4)".
/*zx*/	define shared variable parpart like pt_part.
/*K11D*/ /*{wbrp01.i}*/
define shared workfile pkkdet no-undo
    field pkkpart like ps_comp
    field pkkop as char format "x(20)" 
    field pkkqty like pk_qty.
/*G265*/ transtype = "BM".
/*G265*/ {gprun.i ""xgbmpkqa.p""}
/*/*K11D*/ {wbrp04.i}*/
