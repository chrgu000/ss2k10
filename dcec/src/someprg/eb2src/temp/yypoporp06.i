/* poporp06.i - PURCHASE ORDER RECEIPTS REPORT INCLUDE FILE                */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                     */
/* All rights reserved worldwide.  This is an unpublished work.            */
/* $Revision: 1.10.3.1 $                                                        */
/*V8:ConvertMode=Maintenance                                               */
/* REVISION: 7.4     LAST MODIFIED: 12/17/93    BY: dpm *H074**/
/* REVISION: 7.4     LAST MODIFIED: 10/25/94    BY: mmp *H573**/
/* REVISION: 8.5     LAST MODIFIED: 11/15/95    BY: taf *J053**/
/* REVISION: 8.5     LAST MODIFIED: 04/08/96    BY: jzw *G1LD**/
/* REVISION: 8.6E    LAST MODIFIED: 02/23/98    BY: *L007* A. Rahane       */
/* REVISION: 8.6E    LAST MODIFIED: 05/09/98    BY: *L00Y* Jeff Wootton    */
/* REVISION: 8.6E    LAST MODIFIED: 06/11/98    BY: *L020* Charles Yen     */
/* REVISION: 9.1     LAST MODIFIED: 03/06/00    BY: *N05Q* David Morris    */
/* REVISION: 9.1     LAST MODIFIED: 08/13/00    BY: *N0KQ* myb             */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* $Revision: 1.10.3.1 $    BY: Manisha Sawant        DATE: 04/26/04  ECO: *P1YV*  */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*cj*add*age info*/

define {1} shared variable rndmthd         like rnd_rnd_mthd.
define {1} shared variable oldcurr         like prh_curr.
define {1} shared variable rdate           like prh_rcp_date.
define {1} shared variable rdate1          like prh_rcp_date.
define {1} shared variable part            like pt_part.
define {1} shared variable part1           like pt_part.
define {1} shared variable site            like pt_site.
define {1} shared variable site1           like pt_site.
define {1} shared variable vendor          like po_vend.
define {1} shared variable vendor1         like po_vend.
define {1} shared variable pj              like prj_nbr.
define {1} shared variable pj1             like prj_nbr.
define {1} shared variable vend_name       like ad_name.
define {1} shared variable sel_inv         like mfc_logical
   label "Inventory Items" initial yes.
define {1} shared variable sel_sub         like mfc_logical
   label "Subcontracted Items" initial yes.
define {1} shared variable sel_mem         like mfc_logical
   label "Memo Items" initial no.
define {1} shared variable use_tot         like mfc_logical
   label "Use Total Std Cost" initial no.
define {1} shared variable uninv_only      like mfc_logical
   label "Non-Vouchered Only" initial yes.
define {1} shared variable show_sub        like mfc_logical
   label "Print Subtotals" initial yes.
define {1} shared variable std_ext         as decimal
   format "->>>>>>>>>>9.99<<<" label "Ext GL Cost".
define {1} shared variable pur_ext         as decimal
   format "->>>>>>>>>>9.99<<<"
   label "Ext PO Cost".
define {1} shared variable std_cost        as decimal format
   "->>>>>>>9.99<<<"
   label "GL Cost".
define {1} shared variable std_var         as decimal
   format "->>>>>>>9.99<<<"
   label "PO-GL Var".
define {1} shared variable base_rpt        like po_curr.
define {1} shared variable base_cost
   as decimal format "->>>>>>>>9.99<<<"
   label "PO Cost" .
define {1} shared variable disp_curr       as character
   format "x(1)" label "C".
define {1} shared variable descname        as character format "x(50)".
define {1} shared variable qty_open as decimal
   format "->>>,>>>,>>9.9<<<<<<<<".
define {1} shared variable last_vend       like prh_vend.

define {1} shared variable exdrate         like exr_rate.

define {1} shared variable exdrate2        like exr_rate.
define {1} shared variable sort_by_desc    like glt_desc no-undo.
define {1} shared variable valid_mnemonic  like mfc_logical no-undo.
define {1} shared variable sort_by     as character
   format "x(9)" no-undo.
define {1} shared variable sort_by_code    like sort_by initial "1".

define {1} shared variable fname           like lngd_dataset
   initial "poporp06.p"  no-undo.
define {1} shared variable fr_ps_nbr       like prh_ps_nbr .
define {1} shared variable to_ps_nbr       like prh_ps_nbr .
define {1} shared variable last_rcp        like prh_rcp_date.

/*cj*/ DEF {1} SHARED VAR det AS LOGICAL LABEL "ÕÊÁä" INITIAL YES .
/*cj*/ DEF {1} SHARED VAR age AS INT EXTENT 4 .
