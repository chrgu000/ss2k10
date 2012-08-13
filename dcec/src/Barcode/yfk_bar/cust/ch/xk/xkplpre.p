/*Cai last modified by 06/15/2004*/

/*---------------------------------------------------------------------------
   File         xkplpre.p
   Purpose:     Preliminary process of kanban picklist printing
   Exceptions:  None
   Notes:       
                1. Before print picklist for this kanban card, the records
		           invloved of usrw_wkfl shoul be deleted.
		        2. The quantity of this kanban card will be accumulated.
		        3. After all the kanban card added to the usrw_wkfl, sub-proc
		           "xkkbdlrp.p" should be invoked to print out pick list or 
		           release PO.
		   
   History:
       2004-6-17, Yang Enping, 0003
          1. Assign window time when create preliminary pick list record.
	      2. Assign window date to field usrw_datefld[2], window time to
	         field usrw-intfld[3]
	      3. Below invloved programs should be review and modify:
	         xkkbdlrp.p
		     xkkbdlrp1.p
		     xkkbdlrd.p


   Inputs:
                kanbanID - kanban card ID needed print picklist or release PO
		approve -  approve flag, for auto generate pick list invoke,
		           set this value false, else set this value true
		urgent  -  urgency flag of this kanban card
		p       -  TRUE means create the pick list for the kanban
		           which has a release pick list.
   Outputs:
                <NONE>
---------------------------------------------------------------------------*/
 {mfdeclre.i}
 {kbconst.i}
 /*0003*----*/
 {pxmaint.i}
 {pxphdef.i xkutlib}
 /*----*0003*/

    define input parameter kanbanID like knbd_id .
    define input parameter approve as logical .
    define input parameter urgent as logical .
    DEFINE INPUT PARAMETER p AS LOGICAL .

    find first knbd_det no-lock
    where knbd_id = kanbanID .

    IF knbd_user1 <> "" AND NOT p THEN LEAVE .

    find first knbl_det no-lock
    where knbl_keyid = knbd_knbl_keyid .
    
    find first knb_mstr no-lock
    where knb_keyid = knbl_knb_keyid .

    find first knbi_mstr no-lock
    where knbi_keyid = knb_knbi_keyid .

    find first knbsm_mstr no-lock
    where knbsm_keyid = knb_knbsm_keyid .

    /*0003*----*/
    find first xkgpd_det no-lock
    where xkgpd_sup = knbsm_supermarket_id
    and xkgpd_site = knbsm_site
    and xkgpd_part = knbi_part
    no-error .
    
    if not available(xkgpd_det) then 
       leave .

    find first xkgp_mstr no-lock
    where xkgp_group = xkgpd_group 
    no-error .

    if not available(xkgp_mstr) then 
       leave .

    /*----*0003*/

    find first knbs_det no-lock
    where knbs_keyid = knb_knbs_keyid .

    for last kbtr_hist no-lock
    where kbtr_id = knbd_det.knbd_id:
    end.

    find usrw_wkfl where usrw_key1 = ("emptykb" + mfguser)
    and usrw_key2 = string(knbd_id)        	
    no-error .

    if not available usrw_wkfl then do:
        create usrw_wkfl .
        assign usrw_key1 = ("emptykb" + mfguser)
 	       usrw_key2 = string(knbd_id) .
    end .

    assign
 	    usrw_charfld[1] = knbi_part
 	    usrw_intfld[1] = knbi_step
 	    usrw_charfld[2] = knbsm_site
 	    usrw_charfld[3] = knbsm_supermarket_id
 	    usrw_charfld[4] =  knbs_det.knbs_source_type
  	    usrw_charfld[5] = knbs_ref1
 	    usrw_charfld[6] = knbs_ref2
 	    usrw_charfld[7] = knbs_ref3
 	    usrw_charfld[8] = knbs_ref4
 	    usrw_charfld[9] = knbs_ref5
 	    usrw_charfld[10] = knbl_det.knbl_card_type
 	    usrw_decfld[2] = knbd_kanban_quantity 
	    usrw_logfld[1] = approve 
	    usrw_logfld[2] = urgent 
        usrw_charfld[12] = knbd_status   
   	    usrw_datefld[1] = today
        usrw_decfld[1] = time 
        usrw_intfld[2] = xkgpd_line     
        usrw_charfld[11] = xkgpd_group 
        usrw_charfld[13] = xkgp_wkctr   
        usrw_key3 = usrw_charfld[11] 
        usrw_key4 = STRING(usrw_intfld[2]) .


     IF knbd_user1 <> "" THEN usrw_logfld[1] = NO .

     if knbs_source_type = {&KB-SOURCETYPE-SUPPLIER}
        and knbl_blanket_po = yes then do:
         for last kbtr_hist no-lock where 
            kbtr_id = knbd_id and
            kbtr_transaction_event = {&KB-CARDEVENT-FILL}:
            
            usrw_charfld[11] = "-TBD-".
            if kbtr_po_nbr <> "" then 
               usrw_charfld[11] = kbtr_po_nbr.
            else if kbtr_source_ref2 <> "" then
               usrw_charfld[11] = kbtr_source_ref2.
         end.
         if available knbs_det and knbs_ref2 <> "" then DO:
            usrw_intfld[2] = INTEGER(knbs_ref3) .
            usrw_charfld[11] = knbs_ref2.
         END.
	     else 
	        usrw_charfld[11] = "-TBD-".
     END.

     if knbs_source_type = {&KB-SOURCETYPE-SUPPLIER}
     and knbl_blanket_po = NO 
     then 
         usrw_logfld[1] = NO .

      /*0003*----assign window time*/

     {pxrun.i &PROC ='getWindowTime'
              &PROGRAM='xkutlib.p'
              &HANDLE=ph_xkutlib
              &PARAM="(true,
	               xkgpd_group,
	               urgent,
	               """",
	               output usrw_datefld[2],
	               output usrw_intfld[3]
	              )"
     }
     /*----*0003*/
