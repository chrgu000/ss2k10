/* xxpopoap.p -                                                              */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 9.1     LAST MODIFIED: 03/26/03    BY: *EAS015*  Apple Tam       */


{mfdtitle.i "b+ "}
/*{gplabel.i &ClearReg=yes} /* EXTERNAL LABEL INCLUDE */*/


define variable ponbr like po_nbr.
define variable ponbr1 like po_nbr.
define variable part like pt_part.
define variable part1 like pt_part.
define variable vend like po_vend.
define variable vend1 like po_vend.
define variable appr_yn as logical initial no.
define variable buyer as character format "x(2)".
define variable xxline as integer format ">>9".
define variable    x_nbr  like po_nbr.
define variable    x_line like pod_line.
define variable    x_part like pod_part.
define variable    x_qty_ord like pod_qty_ord.
define variable    x_um like pod_um.
define variable    x_curr like po_curr.
define variable    x_curr2 like po_curr.
define variable    x_unit_cost like xxpoa_unit_cost.
define variable    x_last_price like xxpoa_last_price.
define variable    x_quote_price like xxpoa_quote_price.
define variable    x_log like xxpoa_log.
define variable    x_appr like xxpoa_appr.
define new shared variable line                like pod_line   format ">>>".
define variable i as integer.
define variable need-to-validate-defaults like mfc_logical            no-undo.
define variable del-yn like mfc_logical initial no.
define variable f_yn like mfc_logical initial no.
define variable log_yn like mfc_logical initial no.
define variable ord_date like po_ord_date.
define variable ord_date1 like po_ord_date.

define temp-table xx_tmp 
            field xxline2 as integer  format ">>>"
	    field xx_nbr         like  xxpoa_nbr        
            field xx_line        like  xxpoa_line       
	    field xx_part        like  xxpoa_part       
	    field xx_qty_ord     like  xxpoa_qty_ord    
	    field xx_um          like  xxpoa_um         
	    field xx_curr        like  xxpoa_curr       
	    field xx_curr2        like  xxpoa_curr       
	    field xx_unit_cost   like  xxpoa_unit_cost  
	    field xx_last_price  like  xxpoa_last_price 
	    field xx_quote_price like  xxpoa_quote_price
	    field xx_log         like  xxpoa_log        
	    field xx_appr        like  xxpoa_appr       
        index xxline2 IS PRIMARY UNIQUE xxline2 ascending
	    .


form with frame c 5 down width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame c:handle).

form
   xxline2            at 1 label "Ln"
   xx_nbr         at 5
   xx_line        at 14
   xx_part        at 18
   xx_qty_ord     at 37 format "->,>>>,>>9.9"
   xx_um          at 50
   xx_curr        at 53
   xx_unit_cost   at 57
   xx_last_price  at 37
   xx_curr2       at 53
   xx_quote_price at 57
   xx_log         label "Lg"
   xx_appr        label "OK"
with frame cship 5 down width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame cship:handle).

form
   ponbr         colon 18 label "Purchase Order"
   ponbr1        label {t001.i} colon 49 skip
   part          colon 18 label "Item Number"
   part1         label {t001.i} colon 49 skip
   vend          colon 18 label "Supplier"
   vend1         label {t001.i} colon 49 
   ord_date      colon 18 label "PO Date"
   ord_date1     label {t001.i} colon 49
   skip(1)
   appr_yn       colon 40 label "Default Approve"
   buyer         colon 40 label "Buyer"
with frame b side-labels no-attr-space width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame b:handle).

form
   line              at 1                         
   x_nbr	     at 5                         
   x_line	     at 14                        
   x_part	     at 18                        
   x_qty_ord	     at 37 format "->,>>>,>>9.9"  
   x_um		     at 50                        
   x_curr	     at 53                        
   x_unit_cost	     at 57                        
   x_last_price	     at 37 
   x_curr2           at 53
   x_quote_price     at 57                        
   x_log
   x_appr
with frame d no-labels no-attr-space width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame d:handle).


assign
   line    = 1.


edit-loop:

repeat on endkey undo, leave:
      clear frame cship all no-pause.
      clear frame d all no-pause.
      hide frame b.
      hide frame cship.
      hide frame d.
      view frame b.

       if ponbr1  = hi_char  then ponbr1 = "".
       if part1  = hi_char then part1 = "".
       if vend1 = hi_char  then vend1 = "".
       if ord_date = low_date then ord_date = ?.
       if ord_date1 = hi_date then ord_date1 = ?.

        update    
	   ponbr
	   ponbr1
	   part
	   part1
	   vend
	   vend1
	   ord_date
	   ord_date1
	   appr_yn
	   buyer
        with frame b.
       if ponbr1  = "" then ponbr1 = hi_char.
       if part1 = "" then part1 = hi_char.
       if vend1 = "" then vend1 = hi_char.
       if ord_date = ? then ord_date = low_date.
       if ord_date1 = ? then ord_date1 = hi_date.
      
      f_yn = no.

   lineloop:
   repeat:
     clear frame cship all no-pause.

     xxline = 0.
     i = 0.
      hide frame b.
      hide frame cship.
      view frame cship.
      view frame d.
      for each xx_tmp:
          delete xx_tmp.
      end.
      for each xxpoa_det 
         where xxpoa_nbr >= ponbr
           and xxpoa_nbr <= ponbr1
	   and xxpoa_part >= part
	   and xxpoa_part <= part1
	   and xxpoa_appr = yes,
	   each po_mstr where po_nbr = xxpoa_nbr
           and po_vend >= vend
	   and po_vend <= vend1
	   and po_ord_date >= ord_date
	   and po_ord_date <= ord_date1
	   and (buyer = "" or (buyer <> "" and po_buyer = buyer ))
	   no-lock by xxpoa_nbr by xxpoa_line:
             i = i + 1.
	     create xx_tmp.
	        assign
		   xxline2         = i
		   xx_nbr         = xxpoa_nbr        
		   xx_line        = xxpoa_line       
		   xx_part        = xxpoa_part       
		   xx_qty_ord     = xxpoa_qty_ord    
		   xx_um          = xxpoa_um         
		   xx_curr        = xxpoa_curr       
		   xx_unit_cost   = xxpoa_unit_cost  
		   xx_last_price  = xxpoa_last_price 
		   xx_quote_price = xxpoa_quote_price
		   xx_log         = xxpoa_log        
		   xx_appr        = appr_yn /*xxpoa_appr */      .
/**********apple***************/
   find first pc_mstr where pc_part = xxpoa_part 
                  and pc_list = "L-PRICE" /*po_pr_list2*/
		  and pc_amt_type = "L"
		  no-lock no-error.
         if available pc_mstr then do:
	    xx_curr2 = pc_curr.
         end.
/******************************/

	    if f_yn = no then do:
	        xxpoa_log01 = no.
		if appr_yn = yes then xxpoa_log01 = yes.
	    end.
	    xx_appr = xxpoa_log01.
	    
      end.  /* FOR EACH XXPOA_DET */
      f_yn = yes.
      for each xx_tmp where xxline2 >= line:
               display
                    xxline2            
  		    xx_nbr         
  		    xx_line        
  		    xx_part        
  		    xx_qty_ord     
  		    xx_um          
  		    xx_curr        
  		    xx_unit_cost   
  		    xx_last_price  
		    xx_curr2
  		    xx_quote_price 
  		    xx_log         
  		    xx_appr        
               with frame cship.
               if frame-line(cship) = frame-down(cship) then leave.
               down 1 with frame cship.
      end.
      line = 0.

      setline:
      do transaction on error undo, retry:
         update line with frame d
         editing:
            nppoddet:
            repeat:
               /* FIND NEXT/PREVIOUS RECORD */
               {mfnp.i
                  xx_tmp
                  line
                  xxline2
                  line
                  xxline2
                  xxline2}

               if recno <> ? then do:
                  line = xxline2.
                  x_nbr          =  xx_nbr        .
		  x_line         =  xx_line       .
		  x_part         =  xx_part       .
		  x_qty_ord      =  xx_qty_ord    .
		  x_um           =  xx_um         .
		  x_curr         =  xx_curr       .
		  x_curr2         =  xx_curr2       .
		  x_unit_cost      =  xx_unit_cost  .
		  x_last_price   =  xx_last_price .
		  x_quote_price  =  xx_quote_price.
		  x_log          =  xx_log        .
		  x_appr         =  xx_appr       .

                  run display-detail.

               end. /* IF RECNO <> ? */
               leave.


            end.  /* NPPODDET: REPEAT: */
               if keyfunction(lastkey) = "END-ERROR"
                  or keyfunction(lastkey) = "GO" then do:

                  need-to-validate-defaults = no.

                  if need-to-validate-defaults then
                     leave. /* LEAVE UPDATE..EDITING BLOCK */

                  if keyfunction(lastkey) = "END-ERROR" then
                     undo lineloop, leave.

               end.  /* IF KEYFUNCTION(LASTKEY)... */

         end. /* EDITING */


	       find xx_tmp where xxline2 = line no-error.
	       if available xx_tmp then do:
		  line = xxline2.
                  x_nbr          =  xx_nbr        .
		  x_line         =  xx_line       .
		  x_part         =  xx_part       .
		  x_qty_ord      =  xx_qty_ord    .
		  x_um           =  xx_um         .
		  x_curr         =  xx_curr       .
		  x_curr2         =  xx_curr2       .
		  x_unit_cost      =  xx_unit_cost  .
		  x_last_price   =  xx_last_price .
		  x_quote_price  =  xx_quote_price.
		  x_log          =  xx_log        .
		  x_appr         =  xx_appr       .
              end.
	      else do:
                  x_nbr          =  "".
		  x_line         =  0.
		  x_part         =  "".
		  x_qty_ord      =  0.0.
		  x_um           =  "".
		  x_curr         =  "".
		  x_curr2        =  "".
		  x_unit_cost      =  0.00.
		  x_last_price   =  0.00.
		  x_quote_price  =  0.00.
		  x_log          =  "".
		  x_appr         =  no.
	      end.
                  run display-detail.

         if (line = 0) then do:         /* NO PO LINE SELECTED */
         end.     /* IF LINE = 0 */
	 if not available xx_tmp /*and line <> 0*/ then do:
             {mfmsg.i 45 3}
	    undo, retry.
	 end.
         update x_appr with frame d.

         find xxpoa_det where xxpoa_nbr = x_nbr and xxpoa_line = x_line no-error.
	 if available xxpoa_det then do:
	    xxpoa_log01 = x_appr.
	 end.

      end.

      end. /* lineloop: repeat: */
               del-yn = yes.
               {mfmsg01.i 12 1 del-yn}
               if del-yn then do:
                    for each xxpoa_det                                    
      		       where xxpoa_nbr >= ponbr                                   
      		         and xxpoa_nbr <= ponbr1                                  
		       and xxpoa_part >= part                                   
		       and xxpoa_part <= part1                                  
		       and xxpoa_appr = yes,                                    
		       each po_mstr where po_nbr = xxpoa_nbr                    
      		         and po_vend >= vend                                      
		       and po_vend <= vend1 
		       and po_ord_date >= ord_date
		       and po_ord_date <= ord_date1
		       and (buyer = "" or (buyer <> "" and po_buyer = buyer ))  
		       no-lock by xxpoa_nbr by xxpoa_line:   

		       find first pod_det where pod_nbr = xxpoa_nbr and pod_line = xxpoa_line no-error.
		       if available pod_det then do:
		          pod_user1 = global_userid.
		       end.
		      find first pc_mstr where pc_part = xxpoa_part and pc_amt_type = "L" 
                 		           /*apple and pc_curr = po_curr*/
		                           and pc_list = "L-PRICE" no-error.
		      if available pc_mstr then do:
		         pc_start = today.
			 pc_amt = xxpoa_unit_cost.
			 pc_um = xxpoa_um.
/*apple*/		 pc_curr = xxpoa_curr.
		      end.
		      else do:
		         create pc_mstr.
			 assign
			     pc_part = xxpoa_part
			     pc_list = "L-PRICE"
			     pc_curr = po_curr
			     pc_start = today
			     pc_um    = xxpoa_um
			     pc_amt_type = "L"
			     pc_amt = xxpoa_unit_cost
			     .
		      end.

		       if xxpoa_log01 = yes then xxpoa_appr = no.

		   end.
		   log_yn = no.
		   for each po_mstr where po_nbr >= ponbr and po_nbr <= ponbr1:
	 	       po__log01 = no.
		       find first xxpoa_det where xxpoa_nbr = po_nbr and xxpoa_appr = yes no-error.
			  if available xxpoa_det then do:
			        po__log01 = yes.
			  end.
		   end.
		       
	       end.
	       else do:
                   for each xxpoa_det                                    
      		       where xxpoa_nbr >= ponbr                                   
      		         and xxpoa_nbr <= ponbr1                                  
		       and xxpoa_part >= part                                   
		       and xxpoa_part <= part1                                  
		       and xxpoa_appr = yes,                                    
		       each po_mstr where po_nbr = xxpoa_nbr                    
      		         and po_vend >= vend                                      
		       and po_vend <= vend1
		       and po_ord_date >= ord_date
		       and po_ord_date <= ord_date1
		       and (buyer = "" or (buyer <> "" and po_buyer = buyer ))  
		       no-lock by xxpoa_nbr by xxpoa_line:   
		       xxpoa_log01 = no.
		   end.
	       end.
      
   end. /* edit-loop */

   run hide-frames.


/*============================================================================*/
PROCEDURE display-detail :

   display
       line          
       x_nbr         
       x_line        
       x_part        
       x_qty_ord     
       x_um          
       x_curr
       x_unit_cost     
       x_last_price  
       x_curr2
       x_quote_price 
       x_log         
       x_appr         
    with frame d.

END PROCEDURE.

/*============================================================================*/
PROCEDURE hide-frames :

   hide frame c     no-pause.
   hide frame cship no-pause.
   hide frame d     no-pause.

END PROCEDURE.

