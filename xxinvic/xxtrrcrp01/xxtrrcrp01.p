/* xxtrrcrp01.p - rct-po Report                                               */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.13 $                                                          */
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
/* $Revision: 1.13 $ BY: Patrick Rowan DATE: 05/24/02  ECO: *P018* */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* DISPLAY TITLE */
{mfdtitle.i "120308.1"}

/* CONSIGNMENT INVENTORY VARIABLES */
{pocnvars.i}

define variable effdt like tr_effdate  initial today.
define variable effdt1 like tr_effdate initial today.
define variable part   like pt_part.
define variable part1  like pt_part.
define variable loc    like loc_loc.
define variable loc1   like loc_loc.
define variable vend like vd_addr.
define variable vend1 like vd_addr.
define variable article as character format "x(2)".
define variable ponbr  like po_nbr.
define variable buyer   like pt_buyer.
define variable shipdate as date.

form
   effdt           colon 20
   effdt1          colon 50 label {t001.i}
   part            colon 20
   part1           colon 50 label {t001.i}
   loc             colon 20
   loc1            colon 50 label {t001.i}
   vend            colon 20
   vend1           colon 50 label {t001.i}
   article         colon 40
   ponbr           colon 40
   buyer           colon 40
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).


/* DETERMINE IF SUPPLIER CONSIGNMENT IS ACTIVE */
{gprun.i ""gpmfc01.p""
         "(input ENABLE_SUPPLIER_CONSIGNMENT,
           input 11,
           input ADG,
           input SUPPLIER_CONSIGN_CTRL_TABLE,
           output using_supplier_consignment)"}

{wbrp01.i}
repeat:

   if effdt = low_date then effdt = ?.
   if effdt1 = hi_date then effdt1 = ?.
   if part1 = hi_char then part1 = "".
   if loc1 = hi_char then loc1 = "".
   if vend1 = hi_char then vend1 = "".

   if c-application-mode <> 'web' then
      update effdt effdt1 part part1 loc loc1 vend vend1 article ponbr buyer
      with frame a.

   {wbrp06.i &command = update
             &fields = " effdt effdt1 part part1 loc loc1 vend vend1
             						 article ponbr buyer"
             &frm = "a"}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:
      if effdt = ? then effdt = low_date.
      if effdt1 = ? then effdt1 = hi_date.
      if part1 = "" then part1 = hi_char.
      if loc1 = "" then loc1 = hi_char.
      if vend1 = "" then vend1 = hi_char.
   end.

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "printer"
               &printWidth = 132
               &pagedFlag = " "
               &stream = " "
               &appendToFile = " "
               &streamedOutputToTerminal = " "
               &withBatchOption = "no"
               &displayStatementType = 1
               &withCancelMessage = "yes"
               &pageBottomMargin = 6
               &withEmail = "yes"
               &withWinprint = "yes"
               &defineVariables = "yes"}

   {mfphead.i}


   for each tr_hist no-lock where tr_type = "RCT-PO" and
            tr_effdate >= effdt and tr_effdate <= effdt1 and
            (tr_nbr = ponbr or ponbr = "") and
            tr_part >= part and tr_part <= part1 and
            tr_loc >= loc and tr_loc <= loc1,
       each pt_mstr no-lock where pt_part = tr_part and
            pt_vend >= vend and pt_vend <= vend1 and
            (pt_buyer = buyer or buyer = "") and
            (substring(pt_article,1,2) = article or article = ""),
       each ad_mstr no-lock where ad_addr = pt_vend,
       each prh_hist no-lock where prh_receiver = tr_lot and
            prh_line = tr_line and prh_part = tr_part
      break by tr_loc by tr_part
      with frame b width 300 no-attr-space:
			find first xxinv_mstr no-lock where xxinv_nbr = prh_ps_nbr and 
								 xxinv_vend = prh_vend no-error.
			if available xxinv_mstr then do:
				 assign shipdate = xxinv_duedate.
		  end.
		  else do:
		  		assign shipdate = ?.
		  end.
      /* SET EXTERNAL LABELS */
      setFrameLabels(frame b:handle).

      {mfrpchk.i}

      display  pt_vend ad_name pt_part pt_desc1 tr_um tr_loc pt_draw
               tr_serial tr_lot tr_effdate tr_nbr pt_buyer prh_ps_nbr
               prh_ship_date tr_line tr_qty_loc shipdate.

   end.

   {mfrtrail.i}

end.

{wbrp04.i &frame-spec = a}
