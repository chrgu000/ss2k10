/* xxicrurp tr_hist rct-unp record REPORT                                    */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */
/* $Revision: 1.13 $                                                         */
/*V8:ConvertMode=FullGUIReport                                               */
/* REVISION: 6.0     LAST MODIFIED: 02/07/90   BY: EMB *                     */
/* REVISION: 6.0     LAST MODIFIED: 09/03/91   BY: afs *D847*                */
/* Revision: 7.3     Last edit:     11/19/92   By: jcd *G348*                */
/* REVISION: 7.3     LAST MODIFIED: 01/06/93   BY: pma *G510*                */
/* REVISION: 7.3     LAST MODIFIED: 12/19/95   BY: bcm *G1H2*                */
/* REVISION: 8.5     LAST MODIFIED: 03/19/96   BY: *J0CV* Robert Wachowicz   */
/* REVISION: 8.6     LAST MODIFIED: 03/11/97   BY: *K07B* Arul Victoria      */
/* REVISION: 8.6     LAST MODIFIED: 10/07/97   BY: mzv *K0M9*                */
/* REVISION: 9.0     LAST MODIFIED: 03/10/99   BY: *M0B8* Hemanth Ebenezer   */
/* REVISION: 9.0     LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan         */
/* REVISION: 9.1     LAST MODIFIED: 10/01/99   BY: *N014* Brian Compton      */
/* REVISION: 9.1     LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1     LAST MODIFIED: 08/13/00   BY: *N0KS* Mark Brown         */
/* Old ECO marker removed, but no ECO header exists *F0PN*                   */
/* Revision: 1.12    BY: Jean Miller          DATE: 04/06/02  ECO: *P056*    */
/* $Revision: 1.13 $ BY: Patrick Rowan DATE: 05/24/02  ECO: *P018*           */
/*****************************************************************************/
/* All patch markers and commented out code have been removed from the source*/
/* code below. For all future modifications to this file, any code which is  */
/* no longer required should be deleted and no in-line patch markers should  */
/* be added.  The ECO marker should only be included in the Revision History.*/
/*****************************************************************************/

/* DISPLAY TITLE */
{mfdtitle.i "100826.1"}

/* CONSIGNMENT INVENTORY VARIABLES */
{pocnvars.i}

define variable datef as date.
define variable datet as date.

form
   datef    colon 20 label "生效日"
   datet    colon 40 label "至"
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

   if datet = today then datet = ?.

   if c-application-mode <> 'web' then
      update datef  datet with frame a.

   {wbrp06.i &command = update &fields = " datef datet " &frm = "a"}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:
      if datet = ? then datet = today.
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


   for each tr_hist no-lock where tr_type = "iss-unp"
       and tr_effdate >= datef and tr_effdate <= datet
   with frame b width 132 no-attr-space:
      /* SET EXTERNAL LABELS */
      setFrameLabels(frame b:handle).

      {mfrpchk.i}
      display tr_part    column-label "零件号"
              tr_effdate column-label "生效日期"
              tr_serial  column-label "批序号"
              tr_qty_loc column-label "数量"
              tr_price   column-label "成本"
              tr_qty_loc * tr_price format "->>>,>>>,>>>,>>9.9<"
                         column-label "金额"
              tr_rmks    format "x(34)" column-label "备注"
              with stream-io.
   end.

   {mfrtrail.i}

end.

{wbrp04.i &frame-spec = a}
