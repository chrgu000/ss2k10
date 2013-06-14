/* ppptrp6a.i  INCLUDE FILE TO FIND THE STANDARD COST AS OF DATE        */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.7 $                                                     */
/*V8:ConvertMode=FullGUIReport                                          */
/* REVISION: 7.3      LAST MODIFIED: 06/02/95   by: dzs *G0NZ*          */
/* REVISION: 7.3      LAST MODIFIED: 10/13/95   by: str *G0ZG*          */
/* REVISION: 9.0      LAST MODIFIED: 05/11/00   BY: *J3PB* Kirti Desai  */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KQ* myb          */
/* Revision: 1.6      BY: Paul Donnelly (SB)  DATE: 06/28/03  ECO: *Q00K*     */
/* $Revision: 1.7 $   BY: Katie Hilbert       DATE: 10/13/03  ECO: *Q04B*     */
/*-Revision end---------------------------------------------------------------*/
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* FIND THE STANDARD COST AS OF DATE */

/* FIND THE BEGINNING COST ON THE FIRST CST-ADJ XACTION
   AFTER THE SELECTED DATE. THIS COST - TR_PRICE
   SHOULD EQUAL THE COST AT END OF THE AS-OF DATE */

/* HOWEVER, IF THIS IS THE FIRST TR_HIST RECORD,
   THEN ASSUME THAT THE COST AT THE END OF THE
   AS-OF DATE EQUALS THIS COST. */

/* FIND THE FIRST CST ADJ TRANSACTION AFTER THE AS OF DATE.  IF
   ONE IS AVAILABLE THEN GET THE DATE OF THIS CST ADJ TRANSACTION,
   AND THEN SORT THESE BY TRANSACTION NUMBER, WHICH ASSUMES THE
   TRANSACTION WITH THE LOWEST TRANSACTION NUMBER WAS DONE FIRST.
   THIS TRANSACTION SHOULD GIVE THE COST AT THE END OF THE AS
   OF DATE.  IF ACCEPT 0 COST IS YES, THEN COST WILL BE THE
   STD - PRICE.  IF ACCEPT 0 COST IS NO, THEN COST WILL BE THE
   STD.  IF NO CST ADJ TRANSACTION CAN BE FOUND AFTER THE AS
   OF DATE, THEN USE THE ITEM COST FROM THE SCT_DET RECORD */

/*
define temp-table cst_trhist no-undo
	field tr_part like tr_hist.tr_part
	field tr_site like tr_hist.tr_site
	field tr_effdate like tr_hist.tr_effdate
	field tr_trnbr like tr_hist.tr_trnbr
	field tr_time like tr_hist.tr_time
	field tr_recid as recid
	index p1 tr_part tr_site tr_effdate tr_time.
*/

find first cst_trhist no-error.
if not avail cst_trhist then do:
	for each tr_hist fields (tr_domain tr_part tr_effdate tr_site tr_trnbr tr_time tr_type)
		where tr_domain = global_domain and tr_type = 'CST-ADJ' and
		tr_part >= part and tr_part <= part1:
		create cst_trhist.
		buffer-copy tr_hist to cst_trhist.
		cst_trhist.tr_recid = recid(tr_hist).
	end.
end.

/*
for first tr_hist
   fields (tr_domain tr_part tr_effdate tr_site tr_loc tr_ship_type
           tr_qty_loc tr_bdn_std tr_lbr_std tr_mtl_std tr_ovh_std
           tr_price tr_status tr_sub_std tr_trnbr tr_type)
   where tr_domain  = global_domain
   and   tr_part    =  in_part
   and   tr_effdate >= as_of_date + 1
   and   tr_site    =  in_site
   and   tr_type    =  "CST-ADJ"
no-lock use-index tr_part_eff:
end. /* FOR FIRST TR_HIST */
*/
for first cst_trhist
	where 	cst_trhist.tr_part = in_part and
		cst_trhist.tr_site = in_site and
		cst_trhist.tr_effdate >= as_of_date + 1
		no-lock :
end.

if available /* tr_hist */ cst_trhist then do:

   /* GET THE FIRST RECORD ENTERED EVEN IF TR_PART_EFF*/
   /* ISN'T IN TRANSACTION NUMBER SEQUENCE            */

   cst_date = cst_trhist.tr_effdate.


   for each cst_trhist where cst_trhist.tr_part = in_part and
	cst_trhist.tr_effdate = cst_date and
	cst_trhist.tr_site = in_site 
	by cst_trhist.tr_time by cst_trhist.tr_trnbr :
	trrecno = cst_trhist.tr_recid.
	leave.
   end.

/*JJ
   for each tr_hist
      fields (tr_domain tr_part tr_effdate tr_site tr_loc tr_ship_type
              tr_qty_loc tr_bdn_std tr_lbr_std tr_mtl_std tr_ovh_std
              tr_price tr_status tr_sub_std tr_trnbr tr_type)
      where tr_domain = global_domain
      and   tr_part    = in_part
      and   tr_effdate = cst_date
      and   tr_site    = in_site
      and   tr_type    = "CST-ADJ"
      use-index tr_part_eff
      by tr_trnbr:

      trrecno = recid(tr_hist).
      leave.
   end. /* FOR EACH TR_HIST */
*/

   for first tr_hist
      fields (tr_domain tr_part tr_effdate tr_site tr_loc tr_ship_type
              tr_qty_loc tr_bdn_std tr_lbr_std tr_mtl_std tr_ovh_std
              tr_price tr_status tr_sub_std tr_trnbr tr_type)
      where recid(tr_hist) = trrecno no-lock:
   end. /* FOR FIRST TR_HIST */

   std_as_of = (tr_hist.tr_mtl_std + tr_hist.tr_lbr_std + tr_hist.tr_ovh_std
                + tr_hist.tr_bdn_std + tr_hist.tr_sub_std).

   if tr_hist.tr_price <> std_as_of or zero_cost then
      std_as_of = std_as_of - tr_hist.tr_price.

end.
else do:
   {gpsct03.i &cost=sct_cst_tot}
   std_as_of = glxcst.
end.

ext_std = round(total_qty_oh * std_as_of,2).
