/* sorp10c.p  - SALES ORDER INVOICE PRINT FOR ENGLISH PRINT CODE "1"          */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.2.1.5 $                                                       */
/*V8:ConvertMode=Report                                                       */
/* REVISION: 7.3      LAST MODIFIED: 03/18/96   BY: ais *G1QW*                */
/* REVISION: 8.6      LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KN* Mark Brown         */
/* Revision: 1.2.1.3  BY: Jean Miller DATE: 12/07/01 ECO: *P03F* */
/* $Revision: 1.2.1.5 $ BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00L* */
/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 100726.1  By: Roger Xiao */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

define shared variable so_recno as recid.

define variable multbol_lab as character format "x(6)" no-undo.

define buffer somstr2 for so_mstr.

form
   multbol_lab    no-label
   qad_key1       no-label
   qad_key2       label "BOL"      format "x(18)"
   qad_charfld[2] label "Ship Via" format "x(20)"
with side-labels down frame multbol width 80 no-box.

/* SET EXTERNAL LABELS */
setFrameLabels(frame multbol:handle).

form
   qad_charfld[1] label "Site" at 16
   qad_charfld[3] label "Remarks" format "x(40)"
with side-labels down frame multbol2 width 80 no-box.

/* SET EXTERNAL LABELS */
setFrameLabels(frame multbol2:handle).

find so_mstr no-lock where recid(so_mstr) = so_recno.


for each somstr2 no-lock  where somstr2.so_domain = global_domain and
         somstr2.so_inv_nbr = so_mstr.so_inv_nbr
break by somstr2.so_inv_nbr:

   for each qad_wkfl exclusive-lock  where qad_wkfl.qad_domain = global_domain
   and
            qad_key1 = somstr2.so_nbr  and
     r-index(qad_key2,"utsoship") > 0 and
            qad_charfld[4] = " "
   break by somstr2.so_nbr with frame multbol:

/* SS - 100726.1 - B 
      if first-of(somstr2.so_nbr) or line-count = 1 then
         display
            getTermLabelRtColon("ORDER",6) @ multbol_lab
            qad_key1.

      display
         substring(qad_key2,1,((r-index(qad_key2,"utsoship")) - 1)) @ qad_key2
         qad_charfld[2].

      display
         qad_charfld[1]
         qad_charfld[3]
      with frame multbol2.

      down.
   SS - 100726.1 - E */

      assign qad_key3 = so_mstr.so_inv_nbr.

/* SS - 100726.1 - B 
      if page-size - line-count < 1 then
         page.
   SS - 100726.1 - E */

   end. /* for each qad_wkfl */

end.  /* get all sales order numbers printed */
