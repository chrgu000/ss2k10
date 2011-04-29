/*                                                   */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                               */
/* All rights reserved worldwide.  This is an unpublished work.                      */
/*V8:ConvertMode=NoConvert                                                           */
/* REVISION: 1.0      LAST MODIFIED: 2008/01/16   BY: Softspeed roger xiao   /*xp001*/ */
/*-Revision end------------------------------------------------------------          */



/* DISPLAY TITLE */
{mfdtitle.i "1+ "}
{cxcustom.i "POPORP03.P"}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE poporp03_p_1 "Open PO's Only"
&SCOPED-DEFINE poporp03_p_8 "Unprinted PO's Only"
&SCOPED-DEFINE poporp03_p_9 "Update"

/* ********** End Translatable Strings Definitions ********* */

define variable ord_date like po_ord_date.
define variable ord_date1 like po_ord_date.
define variable nbr like po_nbr.
define variable nbr1 like po_nbr.
define variable vend like po_vend.
define variable vend1 like po_vend.
define variable buyer like po_buyer.
define variable buyer1 like po_buyer.
define variable new_only like mfc_logical initial yes.
define variable open_only like mfc_logical initial yes.
define variable update_yn like mfc_logical initial yes label {&poporp03_p_9} .
define variable addr as character format "x(38)" extent 16.
define var v_desc1 like pt_desc1 .
define var v_desc2 like pt_desc2 .



define temp-table temp
	field t_nbr      like pod_nbr 
	field t_line     like pod_line 
	field t_vend     like po_vend
	field t_ship     like po_ship
	field t_curr     like po_curr
	field t_shipvia  like po_shipvia 
	field t_ord_date like po_ord_date
	field t_buyer    like po_buyer
	field t_part     like pod_part
	field t_um       like pod_um

	field t_rev_new  like po_rev
	field t_rev_old  like po_rev
	field t_qty_new  like pod_qty_ord 
	field t_qty_old  like pod_qty_ord
	field t_due_new  like pod_due_date 
	field t_due_old  like pod_due_date
	field t_cost_new like pod_pur_cost
	field t_cost_old like pod_pur_cost
	field t_amt_new  like pod_pur_cost
	field t_amt_old  like pod_pur_cost.







form
   nbr            colon 15
   nbr1           label {t001.i} colon 49
   vend           colon 15
   vend1          label {t001.i} colon 49
   buyer          colon 15
   buyer1         label {t001.i} colon 49
   ord_date       colon 15
   ord_date1      label {t001.i} colon 49 skip
    skip(1)
   open_only      colon 25 label {&poporp03_p_1}
   new_only       colon 25 label {&poporp03_p_8}
   update_yn      colon 60 
   skip(2)

with frame a width 80 attr-space side-labels.

setFrameLabels(frame a:handle).


{wbrp01.i}
repeat:
   if nbr1 = hi_char then nbr1 = "".
   if vend1 = hi_char then vend1 = "".
   if buyer1 = hi_char then buyer1 = "".
   if ord_date = low_date then ord_date = ?.
   if ord_date1 = hi_date then ord_date1 = ?.
  
	update  nbr nbr1 vend vend1
			buyer buyer1
			ord_date ord_date1
			open_only new_only update_yn   with frame a.


   bcdparm = "".
   {mfquoter.i nbr    }
   {mfquoter.i nbr1   }
   {mfquoter.i vend   }
   {mfquoter.i vend1  }
   {mfquoter.i buyer  }
   {mfquoter.i buyer1 }
   {mfquoter.i ord_date}
   {mfquoter.i ord_date1}

   {mfquoter.i open_only}
   {mfquoter.i new_only}
   {mfquoter.i update_yn }
   
   if nbr1 = "" then nbr1 = hi_char.
   if vend1 = "" then vend1 = hi_char.
   if buyer1 = "" then buyer1 = hi_char.
   if ord_date = ? then ord_date = low_date.
   if ord_date1 = ? then ord_date1 = hi_date.






for each po_mstr  
	where po_mstr.po_domain = global_domain 
	and (po_nbr >= nbr) and (po_nbr <= nbr1)
	and (po_vend >= vend) and (po_vend <= vend1)
	and (po_buyer >= buyer and po_buyer <= buyer1)
	and (po_print or not new_only)
	and (po_ord_date >= ord_date) and (po_ord_date <= ord_date1)
	and (po_stat = "" or not open_only)
	/*and (po__chr01 = "A" )  已发行的才可列印*/
	/*and (not po_sched or include_sched)
	and (not po_is_btb or incl_b2b_po) */
	and po_type <> "B"  
exclusive-lock break by po_nbr:


	for each pod_det 
		where pod_det.pod_domain = global_domain 
		and pod_nbr = po_nbr 
		no-lock break by pod_nbr by pod_line  :

		find first temp where t_nbr = pod_nbr and t_line = pod_line no-lock no-error.
		if not avail temp then do:
				create temp .
				assign 
					t_nbr  = pod_nbr 
					t_line = pod_line 
					t_vend = po_vend
					t_ship = po_ship
					t_shipvia  = po_shipvia 
					t_ord_date = po_ord_date
					t_buyer    = po_buyer
					t_part     = pod_part
					t_um       = pod_um
					t_rev_new  = po_rev				
					t_qty_new  = pod_qty_ord 				
					t_due_new  = pod_due_date 				
					t_cost_new = pod_pur_cost
					t_amt_new  = round(pod_qty_ord *  pod_pur_cost ,5).

				find last xrev_hist 
						where xrev_domain = global_domain 
						and xrev_key1    = "PO"
						and xrev_key2    = pod_nbr
						and  xrev_key3   = string(pod_line) 
						and  xrev_chr03  = pod_part
						and  xrev_release = yes 
						and  xrev_int01  <> po_rev
				no-lock no-error .
				if avail xrev_hist then do:
					assign 
						t_cost_old = xrev_dec02
						t_qty_old  = xrev_dec01
						t_due_old  = xrev_dte01
						t_rev_old  = xrev_int01 
						t_amt_old  = round(xrev_dec02 *  xrev_dec01 ,5).
				end.

		end. /*if not avail temp*/

	end. /*for each pod_det */
	if update_yn then do:
		assign 
			po_print = no
			po__chr01 = "R" .
	end.
end. /*for each po_mstr*/



    /* PRINTER SELECTION */
    /* OUTPUT DESTINATION SELECTION */
    {gpselout.i &printType = "printer"
                &printWidth = 132
                &pagedFlag = " "
                &stream = " "
                &appendToFile = " "
                &streamedOutputToTerminal = " "
                &withBatchOption = "yes"
                &displayStatementType = 1
                &withCancelMessage = "yes"
                &pageBottomMargin = 6
                &withEmail = "yes"
                &withWinprint = "yes"
                &defineVariables = "yes"}
    mainloop: 
    do on error undo, return error on endkey undo, return error:   

        PUT UNFORMATTED "#def REPORTPATH=$/xxxxxxxxxxx/xxxxxxxxxxxxx" SKIP.
	    PUT UNFORMATTED "#def :end" SKIP.

for each temp no-lock break by t_nbr by t_line :
	if first-of(t_nbr) then do:
		assign addr[1] = "" addr[2] = "" addr[3] = "" addr[4] = "" 
			   addr[5] = "" addr[6] = "" addr[7] = "" addr[8] = "" 
			   addr[9] = "" addr[10] = "" addr[11] = "" addr[12] = ""
			   addr[13] = "" addr[14] = "" addr[15] = "" addr[16] = "" .
		find ad_mstr
			 where ad_mstr.ad_domain = global_domain
			 and   ad_addr           = t_vend
		no-lock no-error.
		if avail ad_mstr then do:
			 assign
				addr[1] = ad_name
				addr[2] = ad_line1
				addr[3] = ad_line2
				addr[4] = ad_line3
				addr[5] = ad_country
				addr[6] = ad_phone 
				addr[7] = ad_fax	.	
		end.
		find ad_mstr
			 where ad_mstr.ad_domain = global_domain
			 and   ad_addr           = t_ship
		no-lock no-error.
		if avail ad_mstr then do:
			 assign
				addr[9]  = ad_name
				addr[10] = ad_line1
				addr[11] = ad_line2
				addr[12] = ad_line3
				addr[13] = ad_country
				addr[14] = ad_phone 
				addr[15] = ad_fax	.	
		end.

	end. /*if first-of(t_nbr)*/

	find first pt_mstr where pt_domain = global_domain and pt_part = t_part no-lock no-error .
	v_desc1 = if avail pt_mstr then pt_desc1 else "" .
	v_desc2 = if avail pt_mstr then pt_desc2 else "" .

    export  
		delimiter ";"
		t_nbr 
		t_line
		t_vend
		t_ship
		addr[1]
		addr[2]
		addr[3]
		addr[4]
		addr[5]
		addr[6]
		addr[7]
		addr[8]
		addr[9]
		addr[10]
		addr[11]
		addr[12]
		addr[13]
		addr[14]
		addr[15]
		addr[16]
		t_shipvia
		t_ord_date
		t_buyer	
		t_rev_new
		t_rev_old
		t_part
		v_desc1
		v_desc2
		t_um
		t_qty_new
		t_qty_old
		t_curr
		t_cost_new
		t_cost_old
		t_amt_new
		t_amt_old
		t_due_new
		t_due_old
		.




end. /*for each temp*/


    end. /* mainloop: */
    /* {mfrtrail.i}  REPORT TRAILER  */
    {mfreset.i}
end.  /* REPEAT */
{wbrp04.i &frame-spec = a}
