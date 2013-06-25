/* trw.t  tr_hist Inventory Transaction Write Trigger                         */
/*Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                         */
/*All rights reserved worldwide.  This is an unpublished work.                */
/* $Revision: 1.6 $                                                           */
/*V8:ConvertMode=NoConvert                                                    */
/******************************************************************************/
/* Revision: 1.1        BY: Jean Miller          DATE: 06/06/02  ECO: *P07T*  */
/* Revision: 1.2        BY: Jean Miller          DATE: 06/13/02  ECO: *P082*  */
/* Revision: 1.5        BY: Jean Miller          DATE: 08/01/02  ECO: *P0CL*  */
/* $Revision: 1.6 $     BY: Jean Miller          DATE: 09/09/03  ECO: *P10C*  */
/******************************************************************************/

TRIGGER PROCEDURE FOR WRITE OF tr_hist OLD BUFFER old_tr_hist.

/* Removed logic, data now captured differently */
define variable wcm_sic  like cm_sic.
{mfdeclre.i }
if tr_hist.tr_type = "ISS-SO" then do:
	find first so_mstr where so_nbr  = tr_hist.tr_nbr  and so_cust = tr_hist.tr_addr  no-lock no-error.
	find first sod_det where sod_nbr = tr_hist.tr_nbr  and sod_line = tr_hist.tr_line no-lock no-error.
	if AVAILABLE(so_mstr) and AVAILABLE(sod_det)  then do:
	
	
	   find first cm_mstr where cm_addr = tr_hist.tr_addr and cm_sic <> "" no-lock no-error.
           if AVAILABLE(cm_mstr) then wcm_sic = cm_sic .
	   else wcm_sic = "". 
           if AVAILABLE(cm_mstr) OR sod_btb_type <> "01" then do:
	   create edi_hist .
		  edi_nbr	= tr_hist.tr_nbr.
		  edi_line	= tr_hist.tr_line.           
		  edi_sourcedomain   = global_domain .   
		  if length(global_userid) <> 20 then do:   /* FIRST EMT*/
		     edi_group	=                       		      	      
		     string ( decimal(substring( TRIM ( string(year(TODAY)) + string(MONTH(TODAY)) + string(DAY(TODAY)))  + trim(STRING(TIME)) + trim(string(RANDOM(1,100))) + fill("0",20) ,1,20) ) + 10 ).
		   end.
		   else do:
		    edi_group	= string ( decimal(global_userid) + 10 ).
		   end.
		   find first si_mstr where si_domain = global_domain and si_site = tr_hist.tr_site no-lock no-error.
		   if AVAILABLE(si_mstr) then  edi_entity        = si_entity.
		   edi_trnbr              = tr_hist.tr_trnbr.
		   edi_site		= tr_hist.tr_site.           
		   edi_targetdomain	= wcm_sic.      
		   edi_userid           = global_userid.
		   edi_type             = tr_hist.tr_type.
		   edi_addr             = tr_hist.tr_addr.
		   edi_part             = tr_hist.tr_part.
		   edi_curr             = tr_hist.tr_curr.
		   edi_action           = "NEW".
		   edi_qty_ord          = tr_hist.tr_qty_req.
		   edi_due_date         = tr_hist.tr_effdate.
		   edi_price            = tr_hist.tr_price.
		   edi_time             = time.
		   edi_TransLoc         = tr_hist.tr_loc.
		   edi_Translot         = tr_hist.tr_serial. 
		   edi_Transref         = tr_hist.tr_ref.
		   edi_TransQty         = tr_hist.tr_qty_loc.
		   edi_ReceiptPO        = so_po.
		   edi_sucess           = if wcm_sic <> "" then "" else "Y".

            end. /* if AVAILABLE(cm_mstr) OR sod_btb_type <> "01" then do:  */
	end. /* if AVAILABLE(so_mstr) and AVAILABLE(sod_det)  then do: */
end. /* tr_hist.tr_type = "ISS-SO" then do: */