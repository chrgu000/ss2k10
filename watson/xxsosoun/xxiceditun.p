/* icedit.p - RUN FILE TO EDIT INVENTORY TRANSACTION INPUT                    */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.10 $                                                           */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 6.0      LAST MODIFIED: 07/17/90   BY: emb       */
/* REVISION: 6.0      LAST MODIFIED: 10/03/91   BY: alb *D887**/
/* REVISION: 7.3      LAST MODIFIED: 04/26/93   BY: WUG *GA39**/
/* REVISION: 7.5      LAST MODIFIED: 11/16/94   BY: ktn *J038**/
/* REVISION: 8.6      LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KS* Mark Brown         */
/* REVISION: 9.1      LAST MODIFIED: 09/26/00   BY: *N0W6* Mudit Mehta        */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* $Revision: 1.10 $    BY: Jean Miller           DATE: 04/06/02  ECO: *P056*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*                                                            */
/* {&transtype}  ""ISS-SO"", ""RCT-PO"" etc.                  */
/* {&site}                                                    */
/* {&location}                                                */
/* {&part}                                                    */
/* {&lotserial}                                               */
/* {&quantity}   In terms of pt_um                            */
/* {&um}         The issue or receipt um                      */
/* {&trnbr}                                                   */
/* {&trline}                                                  */

{mfdeclre.i}
{cxcustom.i "ICEDIT.P"}

define input parameter transtype like tr_type.
define input parameter site like tr_site.
define input parameter location like tr_loc.
define input parameter part like tr_part.
define input parameter lotserial like tr_serial.
define input parameter lotref like tr_ref.
define input parameter quantity like tr_qty_loc.
define input parameter um like tr_um.
define input parameter trnbr like lot_nbr.
define input parameter trline like lot_line.
define output parameter undotran like mfc_logical no-undo.

define variable trans-ok like mfc_logical no-undo.
define variable check_overissue like mfc_logical.

check_overissue = yes.
{&ICEDIT-P-TAG1}
if transtype = "ISS-SO" then do:
   {&ICEDIT-P-TAG2}
   {gprun.i ""sosoisck.p"" "(output check_overissue)"}
end.

undotran = yes.
{&ICEDIT-P-TAG3}

do on error undo, retry:
   {&ICEDIT-P-TAG4}

   /* SS - 20080905.1 - B */
   {xxiceditun.i
      &transtype=transtype
      &site=site
      &location=location
      &part=part
      &lotserial=lotserial
      &lotref=lotref
      &quantity= quantity 
      &um=um
      &overissue_check="and check_overissue"
      &trnbr=trnbr
      &trline=trline}
   {&ICEDIT-P-TAG5}

   undotran = not undotran.
   leave.

end.
