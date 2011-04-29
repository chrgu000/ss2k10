/* socnuac1.p - Sales Order Consignment Usage window for final selection     */
/* Copyright 1986-2005 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */
/* $Revision: 1.31 $                                                              */
/*V8:ConvertMode=ReportAndMaintenance                                        */

/* Revision: 1.18   BY: Patrick Rowan      DATE: 04/04/02  ECO: *P00F* */
/* Revision: 1.20   BY: Ashish Maheshwari  DATE: 07/17/02  ECO: *N1GJ* */
/* Revision: 1.21   BY: Steve Nugent       DATE: 08/14/02  ECO: *P0F8* */
/* Revision: 1.23   BY: Paul Donnelly (SB) DATE: 06/28/03  ECO: *Q00L* */
/* Revision: 1.24   BY: Preeti Sattur      DATE: 03/10/04  ECO: *P1N2* */
/* Revision: 1.26   BY: Vandna Rohira      DATE: 04/14/04  ECO: *P1WX* */
/* Revision: 1.27   BY: Laxmikant Bondre   DATE: 04/26/04  ECO: *P1TT* */
/* Revision: 1.28   BY: Reena Ambavi       DATE: 06/23/04  ECO: *P27C* */
/* Revision: 1.29   BY: Swati Sharma       DATE: 09/28/04  ECO: *P2L9* */
/* Revision: 1.30   BY: Anitha Gopal       DATE: 05/16/05  ECO: *P3LM* */
/* $Revision: 1.31 $     BY: Preeti Sattur      DATE: 06/02/05  ECO: *P3N8* */
/* By: Neil Gao Date: *ss 20070302 ECO: *ss 20070302.1* */
/* By: Neil Gao Date: *ss 20070302 ECO: *ss 20070302.1* */
/* By: Neil Gao Date: *ss 20070330 ECO: *ss 20070330.1* */
/* By: Neil Gao Date: *ss 20070417 ECO: *ss 20070417.1* */
/* By: Neil Gao Date: *ss 20070419 ECO: *ss 20070419.1* */
/* By: Neil Gao Date: *ss 20070428 ECO: *ss 20070428.1* */
/* By: Neil Gao Date: *ss 20070709 ECO: *ss 20070709 * */
/* SS - 090401.1  By: Roger Xiao */
/* SS - 090927.1  By: Roger Xiao */

/* ss 20070428.1 - 
解决负数货运单不能选择的问题
   ss 20070428.1 - e */

/* ss 20070330.1 - b */
/*在货运单abs__chr01   标记 "Y" 表示不用开发票*/
/* ss 20070330.1 - e */

/* SS - 090401.1 - RNB
仅改变排序顺序,以优化查询速度
SS - 090401.1 - RNE */

/* SS - 090927.1 - RNB
多笔库位时校验出错.
SS - 090927.1 - RNE */

/*-Revision end---------------------------------------------------------------*/

/* -----  W A R N I N G  -----  W A R N I N G  -----  W A R N I N G  -----  */
/*                                                                          */
/*         THIS PROGRAM IS A BOLT-ON TO STANDARD PRODUCT MFG/PRO.           */
/* ANY CHANGES TO THIS PROGRAM MUST BE PLACED ON A SEPARATE ECO THAN        */
/* STANDARD PRODUCT CHANGES.  FAILURE TO DO THIS CAUSES THE BOLT-ON CODE TO */
/* BE COMBINED WITH STANDARD PRODUCT AND RESULTS IN PATCH DELIVERY FAILURES.*/
/*                                                                          */
/* -----  W A R N I N G  -----  W A R N I N G  -----  W A R N I N G  -----  */

/* MODIFICATION TO THIS PROGRAM MAY REQUIRE MODIFICATION TO socnuac4.p,     */
/* socnuac6.p and socnua7a.p                                                */

{mfdeclre.i}

/* STANDARD MAINTENANCE COMPONENT INCLUDE FILE */
{pxmaint.i}

/* DEFINE THE PERSISTENT HANDLE */
{pxphdef.i socmnrtn}

{gplabel.i}
/* TEMP TABLE */
{socnuac.i}

/* PARAMETERS */
define input-output parameter table for tt_autocr.
define input parameter sortby as character no-undo.
define input parameter sel_all as character no-undo.
define input parameter using_selfbilling as logical no-undo.
define output parameter continue-yn as logical no-undo.

/* VARIABLES */
define variable sopart like ac_sopart no-undo.
define variable part like ac_part no-undo.
define variable po like scx_po no-undo.
define variable order like scx_order no-undo.
define variable line like ac_line no-undo.
define variable ship like ac_ship no-undo.
define variable cust like ac_cust no-undo.
define variable tot_qty_oh like ac_tot_qty_oh no-undo.
define variable um like ac_stock_um no-undo.
define variable tot_qty_consumed
                    as decimal format "->,>>>,>>9.9<<<<" no-undo.
define variable frmd_tot_qty_consumed
                    as decimal format "->,>>>,>>9.9<<<<" no-undo.
define variable consumed_um like ac_consumed_um no-undo.
define variable consumed_um_conv like um_conv no-undo.
define variable lotser like cncix_lotser no-undo.
define variable ref like cncix_ref no-undo.
define variable ok_to_display as logical no-undo.
define variable ok_to_continue as logical no-undo.
define variable cust_usage_ref like cncu_cust_usage_ref no-undo.
define variable cust_usage_date like cncu_cust_usage_date no-undo.
define variable selfbill_auth like cncix_auth no-undo.
define variable l_effdate like glt_effdate no-undo.

define variable ac_first_recid as recid no-undo.
define variable ac_recid as recid no-undo.
define variable lotnext like wo_lot_next no-undo.
define variable lotprcpt like wo_lot_rcpt no-undo.
define variable undo-input like mfc_logical no-undo.


/* SHARED VARIABLES FOR icsrup.p */
define new shared variable multi_entry like mfc_logical no-undo.
define new shared variable cline as character.
define new shared variable lotserial_control like pt_lot_ser.
define new shared variable issue_or_receipt as character.
define new shared variable total_lotserial_qty like sr_qty.
define new shared variable site like sr_site no-undo.
define new shared variable location like sr_loc no-undo.
define new shared variable lotserial like sr_lotser no-undo.
define new shared variable lotserial_qty like sr_qty no-undo.
define new shared variable trans_um like pt_um.
define new shared variable trans_conv like sod_um_conv.
define new shared variable transtype as character initial "CN-USE".
define new shared variable lotref like sr_ref no-undo.


/* SHARED VARIABLES FOR icsoisck.p */
define new shared variable ship_so like so_nbr.
define new shared variable ship_line like sod_line.

define variable l_cncix_qty1 like sr_qty      initial 0  no-undo.
define variable l_sr_yes     like mfc_logical initial no no-undo.

/* ss 20070302.1 - b */
DEFINE shared TEMP-TABLE tt1
   FIELD tt1_stat     as character format "x(1)" label "S"
   FIELD tt1_shipfrom LIKE ABS_shipfrom 
   FIELD tt1_id LIKE ABS_id FORMAT "x(46)"
   field tt1_disp_id like abs_id format "x(46)"
   FIELD tt1_par_id LIKE ABS_par_id
   FIELD tt1_shipto         LIKE ABS_shipto 
   FIELD tt1_order        AS CHAR FORMAT "x(8)"
   FIELD tt1_po           LIKE so_po
   FIELD tt1_line     LIKE ABS_line FORMAT "x(3)"
   FIELD tt1_item     AS CHAR FORMAT "x(18)"
   FIELD tt1_cust_part LIKE cp_cust_part
   FIELD tt1_desc1        like pt_desc1
   FIELD tt1_desc2        like pt_desc2
   FIELD tt1_um           AS CHAR FORMAT "x(2)"
   FIELD tt1_ship_qty AS DECIMAL FORMAT "->,>>>,>>9.99"
   FIELD tt1_qty_inv AS DECIMAL FORMAT "->,>>>,>>9.99"
   FIELD tt1_nbr AS char
   FIELD tt1_price LIKE sod_price
   FIELD tt1_close_abs AS LOGICAL
   FIELD tt1_type LIKE sod_type
   /* SS - 20060401 - B */
   FIELD tt1_new  AS LOGICAL INITIAL YES
   FIELD tt1_ord_date LIKE so_ord_date
   FIELD tt1__qad02 LIKE ABS__qad02
   FIELD tt1_conv AS DECIMAL INITIAL 1
   /* SS - 20060401 - E */
   index tt1_disp_id tt1_disp_id
   INDEX tt1_id tt1_id
   INDEX tt1_stat tt1_stat
   INDEX tt1_par_id_line tt1_par_id tt1_line
   INDEX tt1_shipfrom_id tt1_shipfrom tt1_id
   .
DEFINE VAR sel_total      AS DECIMAL FORMAT "->>,>>>,>>9.99".
DEFINE var sel_qty        as decimal.
define variable first_sw_call as logical initial true.
define variable apwork-recno  as recid.

/* ss 20070307.1 - b */
define shared var ship_dt like abs_shp_date.
define shared var ship_dt1 like abs_shp_date.
define shared variable xxrqmrqby_userid like xxrqm_rqby_userid.
define buffer xxtt1 for tt1.
/* ss 20070307.1 - e */

/* ss 20070302.1 - e */

/* ss 20070709 - b */
define variable cust_part like cp_cust_part.
/* ss 20070709 - e */

issue_or_receipt = getTermLabel("Ship",8).


/* CUSTOMER USAGE FORM */
/* ss 20070312.1 - b */
/*
form
   cust_usage_ref  colon 30 Label "Customer Usage Ref" /* ss 20070302.1 */ format "x(8)"
   cust_usage_date colon 66 label "Date"
   selfbill_auth   colon 30
                   view-as fill-in size 20 by 1
   l_effdate       colon 66
 */
form
   cust_usage_ref  colon 20  /* ss 20070302.1 */ format "x(8)" 
   xxrqmrqby_userid colon 45
   cust_usage_date colon 66 label "Date"
   selfbill_auth   colon 30
                   view-as fill-in size 20 by 1
   l_effdate       colon 66 
/* ss 20070312.1 - e */
with frame aa width 80 side-labels
title color normal (getFrameTitle("CUSTOMER_USAGE_DATA",50)).

/* SET EXTERNAL LABELS */
setFrameLabels(frame aa:handle).


/* FORM STATEMENT: FRAME B */
form
with frame b 6 down width 80
title color normal (getFrameTitle("CONSIGNMENT_SELECTION",78)).

/* SET EXTERNAL LABELS */
setFrameLabels(frame b:handle).


/* FORM STATEMENT: FRAME C */
form
   part                 colon 15
   site                 colon 40
   location             colon 65
   order                colon 15
   space(2)
   line                 label "Ln"
   tot_qty_consumed     colon 50 label "Consumed Qty"
   consumed_um          label "UM"
   po                   colon 15 label "PO Number"
   lotser
   sopart               colon 15
   ref                  colon 50 label "Ref"
   multi_entry          label "Multi Entry"
with frame c side-labels width 80  no-attr-space
title color normal (getFrameTitle("CONSIGNMENT_DETAILS",78)).

/* SET EXTERNAL LABELS */
setFrameLabels(frame c:handle).


/* FORM STATEMENT: FRAME D */
form
   part
   location
   lotser
   ref
   frmd_tot_qty_consumed column-label "Qty"
   um
with frame d 10 down width 80 no-attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame d:handle).

/* ss 20070312.1 - b */
form
   tt1_desc1 COLON 15
   tt1_desc2 NO-LABEL FORMAT "x(10)"
   tt1_price colon 60
   tt1_po COLON 15
   sel_total colon 60
with frame sel_item side-labels width 80.
setFrameLabels(frame sel_item:handle).
/* ss 20070312.1 - e */


/* ss 20070331 - b */
   
   
   	if sel_all = "yes" then do:
   
   		for each tt1 :
     	 delete tt1.
      end.
/* SS - 090401.1 - B *
   		
   		for each bAutoCreate no-lock:
      	for each abs_mstr where abs_order = ac_order and 
        	 abs_line = string(ac_line) and abs_domain = global_domain 
					 and abs_shp_date >= ship_dt and abs_shp_date <= ship_dt1
					 and abs__chr01 = ""
         		no-lock:
       		sel_qty = 0.
       		find first xxabs_mstr where xxabs_shipfrom = abs_shipfrom and xxabs_domain = global_domain and
         	xxabs_id = abs_id and xxabs_canceled no-lock no-error.
       		if avail xxabs_mstr then next.
       		for each xxabs_mstr where xxabs_shipfrom = abs_shipfrom and xxabs_domain = global_domain and
         	xxabs_id = abs_id no-lock:
         		sel_qty = sel_qty + xxabs_ship_qty .
       		end.

* SS - 090401.1 - E */
/* SS - 090401.1 - B */
for each bAutoCreate no-lock:
    for each abs_mstr 
        use-index abs_order
        where abs_domain = global_domain 
        and abs_order = ac_order 
        and abs_line = string(ac_line) 
        and abs_shp_date >= ship_dt and abs_shp_date <= ship_dt1
        and abs__chr01 = ""
    no-lock:
        sel_qty = 0.
        find first xxabs_mstr 
            /*use-index abs_id*/
            where xxabs_domain = global_domain 
            and xxabs_shipfrom = abs_shipfrom 
            and xxabs_id = abs_id 
            and xxabs_canceled 
        no-lock no-error.
        if avail xxabs_mstr then next.

        for each xxabs_mstr 
            /*use-index abs_id*/
            where xxabs_domain = global_domain 
            and  xxabs_shipfrom = abs_shipfrom
            and xxabs_id = abs_id 
        no-lock:
           sel_qty = sel_qty + xxabs_ship_qty .
        end.


/* SS - 090401.1 - E */
       		find first sod_det where sod_domain = global_domain and sod_nbr = abs_order
         		and sod_line = int(abs_line) no-lock no-error.
/* ss 20070428.1 - b */
/*
       		if sel_qty >= abs_ship_qty then next. 
*/
       		if sel_qty >= abs_ship_qty and abs_ship_qty >= 0 then next. 
/* ss 20070428.1 - e */
       
              create tt1 .    	
              ASSIGN 
                 tt1_stat = "*"  
                 tt1_nbr = ac_cust_usage_ref
                 tt1_shipfrom = abs_shipfrom
                 tt1_id = abs_id
                 tt1_disp_id = substring(abs_id,3, length( abs_par_id ) - 1 ) + " " + 
                 substring(abs_id,length(abs_par_id) + 2 + length(abs_shipfrom) , length(abs_order) ) + " " +
                 substring(abs_id,length(abs_par_id) + 2 + length(abs_shipfrom) + length(abs_order) , length(abs_line ) ) + " " +
                 substring(abs_id,length(abs_par_id) + 2 + length(abs_shipfrom) + length(abs_order) + length(abs_line ),length(abs_item) ) + " " +
                 substring(abs_id,length(abs_par_id) + 2 + length(abs_shipfrom) + length(abs_order) + length(abs_line ) + length(abs_item) )
                 tt1_par_id = abs_par_id
                 tt1_shipto = abs_shipto
                 tt1_order = abs_order
                 tt1_po = ""
                 tt1_ord_date = ?
                 tt1_line = abs_line
                 tt1_item = abs_item
                 tt1_um  = "" 
                 /* SS - 20060401 - B */
                 tt1__qad02 = abs__qad02
                 /* SS - 20060401 - E */
                 tt1_ship_qty = ABS_ship_qty - sel_qty
                 tt1_price = if avail sod_det then sod_price else 0
                 tt1_qty_inv = tt1_ship_qty
                 tt1_close_abs = no
                 tt1_type = ""
                 tt1_new = yes
                 . 
    			end.  /* for each abs_mstr */  
    			
    			sel_qty = 0 .
    			for each tt1 where tt1_nbr = ac_cust_usage_ref and tt1_order = ac_order and 
        		tt1_line = string(ac_line) no-lock :
/* ss 20070417.1 - b */
/*
        		sel_qty = sel_qty + tt1_ship_qty.
*/
        		sel_qty = sel_qty + tt1_qty_inv.
/* ss 20070417.1 - e */
        	end.
        	
        	if ac_tot_qty_consumed <> sel_qty then do:
        		message ac_order ac_line "与货运单数量不符, 请修改"  sel_qty .
        	end.
   		end. 
   
  	end. /* if sel_all */  
/* ss 20070331 - e */

shiploop:
repeat:

   clear frame b.
   view frame b.
   view frame c.

   scroll_loop:
   do with frame b:


      {swview.i &domain="true and "
         &buffer       = bAutoCreate
         &scroll-field = ac_part
         &searchkey    = "ac_cncixrecid <> 0"
         &index-phrase = "use-index sort_order"
         &framename    = "b"
         &framesize    = 6
         &display1     = ac_part
         &display2     = ac_order
         &display3     = ac_line
         &display4     = ac_tot_qty_oh
         &display5     = ac_stock_um
         &display6     = ac_tot_qty_consumed
         &display7     = ac_consumed_um
         &display8     = ac_loc
         &exitlabel    = scroll_loop
         &exit-flag    = "true"
         &record-id    = ac_recid
         &first-recid  = ac_first_recid
         &exec_cursor  =
                    " run displayConsignmentDetails
                              (buffer bAutoCreate). "
         &logical1     = true }
   end. /* DO with frame b */


/* ss 20070331 - b */
/*
   if keyfunction(lastkey) = "END-ERROR" then
      leave shiploop.
*/
   if keyfunction(lastkey) = "END-ERROR" then do:
/* SS - 090927.1 - B 
      for each bAutoCreate no-lock:
          sel_qty = 0 .
    			for each tt1 where tt1_nbr = ac_cust_usage_ref and tt1_order = ac_order and 
        		tt1_line = string(ac_line) no-lock :
/* ss 20070417.1 - b */
/*
        		sel_qty = sel_qty + tt1_ship_qty.
*/
        		sel_qty = sel_qty + tt1_qty_inv.
/* ss 20070417.1 - e */
        	end.
        	
        	if ac_tot_qty_consumed <> sel_qty then do:
        		message ac_order ac_line "与货运单数量不符, 请修改"  sel_qty .

/* ss 20070419.1 - b */
/*
        		pause.
        		if keyfunction(lastkey) = "END-ERROR" then do:
        			continue-yn = no.
        			return .
        		end. 
*/
/* ss 20070419.1 - e */

        		next shiploop.
        	end.
      end.
   SS - 090927.1 - E */
/* SS - 090927.1 - B */
        define var v_qty_total_ac like tr_qty_loc .
        for each bAutoCreate no-lock
            break by ac_cust_usage_ref by ac_order by ac_line:
            if first-of(ac_line) then do:
                v_qty_total_ac = 0 .
            end.

            v_qty_total_ac = v_qty_total_ac + ac_tot_qty_consumed .
            if last-of(ac_line) then do:
                sel_qty = 0 .
                for each tt1 
                    where tt1_nbr = ac_cust_usage_ref 
                    and tt1_order = ac_order 
                    and tt1_line  = string(ac_line) 
                    no-lock :
                    sel_qty = sel_qty + tt1_qty_inv.
                end.

                if v_qty_total_ac <> sel_qty then do:
                    message ac_order ac_line "与货运单数量不符, 请修改"  v_qty_total_ac " , "  sel_qty .
                    next shiploop.
                end.
            end.
        end.
/* SS - 090927.1 - E */

      leave shiploop.
   end.
/* ss 20070331 - e */

/* ss 20070302.1 - b */
   hide frame b no-pause.
   hide frame c no-pause.
   
   sw_block:
   do on endkey undo, leave:
 
     for each tt1 where tt1_nbr = "" :
     	 delete tt1.
     end.
/* SS - 090401.1 - B *
     for each abs_mstr where abs_order = ac_order and 
         abs_line = string(ac_line) and abs_domain = global_domain 
/* ss 20070307.1 */ and abs_shp_date >= ship_dt and abs_shp_date <= ship_dt1
/* ss 20070330.1 */ and abs__chr01 = ""
         no-lock:
       sel_total = 0 .
       sel_qty   = 0.
       find first xxabs_mstr where xxabs_shipfrom = abs_shipfrom and xxabs_domain = global_domain and
         xxabs_id = abs_id and xxabs_canceled no-lock no-error.
       if avail xxabs_mstr then next.
       for each xxabs_mstr where xxabs_shipfrom = abs_shipfrom and xxabs_domain = global_domain and
         xxabs_id = abs_id no-lock:
         sel_qty = sel_qty + xxabs_ship_qty .
       end.
* SS - 090401.1 - E */

/* SS - 090401.1 - B */
for each abs_mstr 
    where abs_domain = global_domain
    and abs_order = ac_order 
    and abs_line = string(ac_line)   
    /* ss 20070307.1 */ and abs_shp_date >= ship_dt and abs_shp_date <= ship_dt1
    /* ss 20070330.1 */ and abs__chr01 = ""
no-lock:
    sel_total = 0 .
    sel_qty   = 0.
    find first xxabs_mstr 
        where xxabs_domain = global_domain 
        and xxabs_shipfrom = abs_shipfrom 
        and xxabs_id = abs_id 
        and xxabs_canceled 
    no-lock no-error.
    if avail xxabs_mstr then next.
    for each xxabs_mstr 
        where xxabs_domain = global_domain 
        and xxabs_shipfrom = abs_shipfrom 
        and xxabs_id = abs_id 
    no-lock:
        sel_qty = sel_qty + xxabs_ship_qty .
    end.
/* SS - 090401.1 - E */
       find first sod_det where sod_domain = global_domain and sod_nbr = abs_order
         and sod_line = int(abs_line) no-lock no-error.
/* ss 20070429.1 - b */
/*
       if sel_qty >= abs_ship_qty then next. 
*/
       if sel_qty >= abs_ship_qty and abs_ship_qty >= 0 then next. 
/* ss 20070429.1 - e */

       /*
              find first xxtt1 where xxtt1.tt1_id = tt1.tt1_id and xxtt1.tt1_order = abs_order and
                xxtt1.tt1_line = abs_line and xxtt1.tt1_nbr <> "" no-lock no-error.
              if avail xxtt1 then assign tt1.tt1_qty_inv = xxtt1.tt1_qty_inv
                                         tt1.tt1_stat = "*" . */
       		find first tt1 where tt1_id = abs_id and tt1_order = abs_order and tt1_line = abs_line no-error.
       		if avail tt1 then assign tt1_nbr = "".
       		else do:
              create tt1 .
              ASSIGN 
                 tt1_stat = ""  
                 tt1_shipfrom = abs_shipfrom
                 tt1_id = abs_id
                 tt1_disp_id = substring(abs_id,3, length( abs_par_id ) - 1 ) + " " + 
                 substring(abs_id,length(abs_par_id) + 2 + length(abs_shipfrom) , length(abs_order) ) + " " +
                 substring(abs_id,length(abs_par_id) + 2 + length(abs_shipfrom) + length(abs_order) , length(abs_line ) ) + " " +
                 substring(abs_id,length(abs_par_id) + 2 + length(abs_shipfrom) + length(abs_order) + length(abs_line ),length(abs_item) ) + " " +
                 substring(abs_id,length(abs_par_id) + 2 + length(abs_shipfrom) + length(abs_order) + length(abs_line ) + length(abs_item) )
                 tt1_par_id = abs_par_id
                 tt1_shipto = abs_shipto
                 tt1_order = abs_order
                 tt1_po = ""
                 tt1_ord_date = ?
                 tt1_line = abs_line
                 tt1_item = abs_item
                 tt1_um  = "" 
                 /* SS - 20060401 - B */
                 tt1__qad02 = abs__qad02
                 /* SS - 20060401 - E */
                 tt1_ship_qty = ABS_ship_qty - sel_qty
                 tt1_price = if avail sod_det then sod_price else 0
                 tt1_qty_inv = 0
                 tt1_close_abs = no
                 tt1_type = ""
                 tt1_new = yes
                 . 
          end. /*else do: */
     end.  /* for each abs_mstr */
     sel_total = 0.
     for each tt1 where tt1_nbr = "" :
     	 if tt1_ship_qty = 0 then do:
     	 	 delete tt1.
     	 	 next.
     	 end.
     	 sel_total = sel_total + tt1_qty_inv * tt1_price.
     end.
     FIND FIRST tt1 where tt1_nbr = "" NO-LOCK NO-ERROR.
       IF NOT AVAILABLE tt1 THEN DO:
          MESSAGE "不存在相关货运单的资料".
          undo ,retry.
       END.
       
       hide frame c.
       hide frame d.
       VIEW FRAME sel_shipper.
       VIEW FRAME sel_item .
       {xxswselect.i
                 &detfile      = tt1
                 &scroll-field = tt1_disp_id
                 &searchkey    = "where tt1_nbr = '' "
                 &framename    = "sel_shipper"
                 &framesize    = 7
                 &sel_on       = ""*""
                 &sel_off      = """"
                 &display1     = tt1_stat
                 &display2     = tt1_disp_id
                 &display3     = tt1_ship_qty
                 &display4     = tt1_qty_inv
                 &exitlabel    = sw_block
                 &exit-flag    = first_sw_call
                 &record-id    = apwork-recno
                 &include1     = "
                     sel_total = sel_total - tt1_qty_inv * tt1_price.
                     tt1_qty_inv = 0.
                     disp tt1_qty_inv .
                     tt1_close_abs = no.                     
                     display sel_total with frame sel_item .
/* ss 20070728.1 - b */

								find first sod_det where sod_domain = global_domain and sod_nbr = tt1_order and sod_line = int(tt1_line) no-lock no-error.
								if avail sod_det then 
								find first so_mstr where so_domain = global_domain and sod_nbr = so_nbr no-lock no-error.
								if avail so_mstr then 
								run xxmj (input tt1_item , input so_cust,input ac_cust_usage_ref).

/* ss 20070728 - e */
                    "
                 &include2     = "
                    disp tt1_ship_qty @ tt1_qty_inv.
                    set tt1_qty_inv .
                    if tt1_qty_inv >= tt1_ship_qty then tt1_close_abs = yes .
                    else tt1_close_abs = no .
                    sel_total = sel_total + tt1_qty_inv * tt1_price.
                    display sel_total with frame sel_item.
/* ss 20070728.1 - b */

								find first sod_det where sod_domain = global_domain and sod_nbr = tt1_order and sod_line = int(tt1_line) no-lock no-error.
								if avail sod_det then 
								find first so_mstr where so_domain = global_domain and sod_nbr = so_nbr no-lock no-error.
								if avail so_mstr then 
								run xxmj (input tt1_item , input so_cust, input ac_cust_usage_ref).

/* ss 20070728 - e */
                    "
                 &include3     = " 
                 find FIRST pt_mstr where pt_part = tt1_item 
/* ss 20070227.2 */ and pt_domain = global_domain                  
                  no-lock no-error.
                  if available pt_mstr THEN DO:
                     display
                        pt_desc1 @ tt1_desc1
                        pt_desc2 @ tt1_desc2
                        tt1_price
                        tt1_po
                        sel_total
                        with frame sel_item.
                  END.
                  ELSE DO:
                     display
                        '非库存零件' @ tt1_desc1
                        '' @ tt1_desc2
                        tt1_price
                        tt1_po
                        sel_total
                        with frame sel_item.
                  END.  
                  
                  "
                 }
   
   end. /* sw_block:  */
   if keyfunction(lastkey) = "end-error" 
      then undo  ,retry .
   
   for each tt1 where tt1_stat = "" and tt1_nbr = "" :
   	 delete tt1.
   end.
   sel_qty = 0.
   for each tt1 where tt1_stat = "*" and tt1_nbr = "" no-lock:
     sel_qty = sel_qty + tt1_qty_inv.
   end.
   
   hide frame sel_shipper no-pause.
   hide frame sel_item    no-pause.
   view frame b.
   view frame c.
/* ss 20070302.1 - e */

   setloop1:
   do on error undo setloop1, leave setloop1 
      on endkey undo setloop1, leave setloop1 with frame c:
      /* DISPLAY CURRENT bAutoCreate RECORD */
      if ac_recid <> ? then
         for first bAutoCreate
            where recid(bAutoCreate) = ac_recid
            no-lock:
            run displayConsignmentDetails
               (buffer bAutoCreate).
            ac_recid = ?.
         end.


      disp sel_qty @ tot_qty_consumed .
/* ss 20070302.1 - b */
/*      prompt-for
         part
         editing:

         /* FIND NEXT/PREVIOUS RECORD */
         {mfnp05.i bAutoCreate
                   sort_order
                   "true"
                   ac_sortfld2
                   ac_sortfld2}

         if recno <> ? then do:
            run displayConsignmentDetails
               (buffer bAutoCreate).

             /* SAVE recid FOR RE-POSITIONING */
            ac_recid = recid(bAutoCreate).
         end.

      end. /* PROMPT-FOR */
*/
/* ss 20070302.1 - e */

      /* VALIDATE */
      if input frame c part = "" then do:
        {pxmsg.i &MSGNUM=40 &ERRORLEVEL=3} /* BLANK NOT ALLOWED */
        next-prompt part with frame c.
        undo, retry.
      end.

      if not can-find(first bAutoCreate where
         ac_part = input frame c part)
      then do:
         {pxmsg.i &MSGNUM=5935 &ERRORLEVEL=3} /* RECORD DOESN'T EXIST */
         next-prompt part with frame c.
         undo, retry.
      end.

      /* DISPLAY LOWER FRAME */
      if can-find(first bAutoCreate where
                  ac_part  = input frame c part    and
                  ac_loc   = input frame c location    and
                  ac_order = input frame c order   and
                  ac_line  = input frame c line) then do:

         for first bAutoCreate
            where ac_part  = input frame c part    and
                  ac_loc   = input frame c location    and
                  ac_order = input frame c order   and
                  ac_line  = input frame c line
            no-lock:
            run displayConsignmentDetails
               (buffer bAutoCreate).
         end.  /* for first bAutoCreate */

      end.  /* if can-find(first bAutoCreate) */
      else
         for first bAutoCreate
            where ac_part = input frame c part
            no-lock:
            run displayConsignmentDetails
               (buffer bAutoCreate).
         end.  /* for first bAutoCreate */


      /* SAVE recid FOR RE-POSITIONING IN DOWN FRAME */
      ac_recid = recid(bAutoCreate).

      /* SAVE global FOR LOT/SERIAL LOOKUP */
      assign
         part = input frame c part
         global_part = input frame c part
         global_site = site
         global_loc  = location
         .

/* ss 20070312.1 - b */
/*
      setloop2:
      do on endkey undo setloop1, retry setloop1
         on error  undo setloop2, retry setloop2
         with frame c:
  */
/* ss 20070312.1 - e */  
         view frame b.

         {gpbrparm.i
             &browse=gplu909.p
             &parm=c-brparm1
             &val="input frame c order"}

         {gpbrparm.i
             &browse=gplu909.p
             &parm=c-brparm2
             &val="string(input frame c line)"}

/* ss 20070302.1 - b */
/* 
         set
            tot_qty_consumed
 */
         tot_qty_consumed = sel_qty.
         disp tot_qty_consumed with frame c.
         set
/* ss 20070302.1 - e */
            consumed_um
            lotser
            ref
            multi_entry
         with frame c.           

         if not multi_entry
         then do:
            if (not can-find(first cncix_mstr
               where cncix_domain      = global_domain
               and   cncix_part        = bAutoCreate.ac_part
               and   cncix_site        = bAutoCreate.ac_site
               and   cncix_shipto      = bAutoCreate.ac_ship
               and   cncix_cust        = bAutoCreate.ac_cust
               and   cncix_custpart    = bAutoCreate.ac_sopart
               and   cncix_so_nbr      = bAutoCreate.ac_order
               and   cncix_sod_line    = bAutoCreate.ac_line
               and   cncix_current_loc = bAutoCreate.ac_loc
               and   cncix_lotser      = input frame c lotser
               and   (bAutoCreate.ac_asn_shipper = ""
                      or (cncix_asn_shipper = bAutoCreate.ac_asn_shipper
                          and bAutoCreate.ac_asn_shipper <> ""))
               and   cncix_ref         = input frame c ref
               and   cncix_auth        = bAutoCreate.ac_auth
               and   cncix_cust_job    = bAutoCreate.ac_cust_job
               and   cncix_cust_seq    = bAutoCreate.ac_cust_seq
               and   cncix_cust_ref    = bAutoCreate.ac_cust_ref
               and   cncix_qty_stock   > 0)
               )
            and
               (not can-find(first cncu_mstr
                  where cncu_domain    = global_domain
                  and   cncu_part      = bAutoCreate.ac_part
                  and   cncu_site      = bAutoCreate.ac_site
                  and   cncu_shipto    = bAutoCreate.ac_ship
                  and   cncu_cust      = bAutoCreate.ac_cust
                  and   cncu_custpart  = bAutoCreate.ac_sopart
                  and   cncu_so_nbr    = bAutoCreate.ac_order
                  and   cncu_sod_line  = bAutoCreate.ac_line
                  and   cncu_lotser    = input frame c lotser
                  and   cncu_ref       = input frame c ref
                  and   cncu_auth      = bAutoCreate.ac_auth
                  and   cncu_cust_job  = bAutoCreate.ac_cust_job
                  and   cncu_cust_seq  = bAutoCreate.ac_cust_seq
                  and   cncu_cust_ref  = bAutoCreate.ac_cust_ref)
               )
            then do:
               /* NO SHIPMENT RECORD EXISTS FOR LOT/SERIAL */
               {pxmsg.i &MSGNUM=6562 &ERRORLEVEL=3 &MSGARG1=lotser}
               next-prompt lotser with frame c.

/* ss 20070312.1 - b */
/*
               undo setloop2, retry setloop2.
 */
               undo setloop1, retry setloop1.
/* ss 20070312.1 - e */

            end. /* IF NOT CAN-FIND(FIRST cncix_mstr) */
        end. /* IF NOT multi_entry */

         assign
            global_lot  = lotser
            total_lotserial_qty = tot_qty_consumed
            cline = string(ac_count)
            trans_conv = 1
            .

         /* UM CONVERSION */
         if consumed_um <> ac_stock_um then do:
            {gprun.i ""gpumcnv.p""
                   "(input consumed_um,
                     input ac_stock_um,
                     input ac_part,
                     output trans_conv)"}
            if trans_conv = ? then do:
               {pxmsg.i &MSGNUM=33 &ERRORLEVEL=2}
                  /* NO UOM CONVERSION EXISTS */
               next-prompt consumed_um with frame c.
               undo, retry.
            end.
         end.  /* if consumed_um <> ac_stock_um */

         trans_um = consumed_um.

         /* IF MULTI-ENTRY THEN CALL SUB-PROGRAM TO DISPLAY */
         /* LOT/SERIAL NUMBER ENTRY FRAME.                  */

         if multi_entry then do:
            assign
               lotser = ""
               ref = ""
               .

           /* ADDED SIXTH INPUT PARAMETER AS NO */
            {gprun.i ""icsrup.p""
                   "(input site,
                     input bAutoCreate.ac_order,
                     input string(bAutoCreate.ac_line),
                     input-output lotnext,
                     input lotprcpt,
                     input no)"}

            tot_qty_consumed = total_lotserial_qty.

         end.  /* if multi_entry */
         else do:

            if tot_qty_consumed <> 0 then do:

               assign
                  ship_so = ac_order
                  ship_line = ac_line.

               {gprun.i ""icedit.p""
                      "(""CN-USE"",
                          site,
                          location,
                          part,
                          lotser,
                          ref,
                          tot_qty_consumed * trans_conv,
                          consumed_um,
                          """",
                          """",
                          output undo-input)"}

               if undo-input then undo, retry.

               if can-find (first sr_wkfl  where sr_wkfl.sr_domain =
               global_domain and
                                sr_userid = mfguser      and
                                sr_lineid = string(ac_count))
               then do:

                  for first sr_wkfl
                      where sr_wkfl.sr_domain = global_domain and  sr_userid =
                      mfguser          and
                         sr_lineid = string(ac_count) and
                         sr_lotser = lotser           and
                         sr_ref    = ref
                  exclusive-lock:

                     /* UPDATE LOT/SERIAL QUANTITY */
                     sr_qty = tot_qty_consumed * trans_conv.

                  end.  /* for first sr_wkfl */

               end.  /* if can-find (first sr_wkfl) */

               assign
                  ac_lotser = lotser
                  ac_ref = ref.


            end.  /* if tot_qty_consumed <> 0 */

         end.  /* else do */

         /* CHECK FOR AVAILABLE QUANTITY AND RESTRICT THE USER FROM OVERISSUE */
         if can-find(first sr_wkfl
            where sr_domain = global_domain
            and   sr_userid = mfguser
            and   sr_lineid = string(ac_count)
            and   sr_qty   <> 0)
         then do:

            for each sr_wkfl no-lock
               where sr_domain = global_domain
               and   sr_userid = mfguser
               and   sr_lineid = string(ac_count)
               and   sr_qty   <> 0
            break by sr_lineid:

               /* RUN PROCEDURE socmnrtn.p PERSISTENTLY AND SET ph_socmnrtn */
               /* AS HANDLE TO PERSISTENT PROCEDURE                         */

               {pxrun.i
                  &PROC    = 'GetCncixQty'
                  &PROGRAM = 'socmnrtn.p'
                  &HANDLE  = ph_socmnrtn
                  &PARAM   = "(input  ac_part,
                               input  sr_site,
                               input  ac_ship,
                               input  ac_cust,
                               input  ac_sopart,
                               input  ac_order,
                               input  ac_line,
                               input  sr_loc,
                               input  sr_lotser,
                               input  sr_ref,
                               input  ac_auth,
                               input  ac_cust_job,
                               input  ac_cust_seq,
                               input  ac_cust_ref,
                               input  ac_asn_shipper,
                               output l_cncix_qty1)"}.

               if l_cncix_qty1 < (sr_qty * trans_conv)
               then do:

                  assign tot_qty_consumed = 0
                         l_sr_yes         = yes.

                  /* ERROR: MAXIMUM CONSIGNMENT QUANTITY TO BE INVOICED # */
                  {pxmsg.i &MSGNUM=6673 &ERRORLEVEL=3 &MSGARG1=l_cncix_qty1}

               end. /* IF l_cncix_qty1 < sr_qty */

            end. /* FOR EACH sr_wkfl */

            /* RESET LOT/SERIAL QUANTITY */

            if l_sr_yes = yes
            then do:
               for each sr_wkfl where
                  sr_domain = global_domain    and
                  sr_userid = mfguser          and
                  sr_lineid = string(ac_count) and
                  sr_qty   <> 0
               exclusive-lock:

                  sr_qty = 0 .

               end.  /* FOR EACH sr_wkfl */

               release sr_wkfl.
               l_sr_yes = no.
               undo setloop1 , retry setloop1.

            end. /* IF l_sr_yes = yes THEN */

         end. /* IF CAN-FIND(sr_wkfl) ... */

         /* IF NOT LOT OR SERIAL CONTROLLED   */

         else do:

            /* RUN PROCEDURE socmnrtn.p PERSISTENTLY AND SET ph_socmnrtn AS */
            /* HANDLE TO PERSISTENT PROCEDURE                               */

            {pxrun.i
               &PROC    = 'GetCncixQty'
               &PROGRAM = 'socmnrtn.p'
               &HANDLE  = ph_socmnrtn
               &PARAM   = "(input  ac_part,
                            input  ac_site,
                            input  ac_ship,
                            input  ac_cust,
                            input  ac_sopart,
                            input  ac_order,
                            input  ac_line,
                            input  ac_loc,
                            input  ac_lotser,
                            input  ac_ref,
                            input  ac_auth,
                            input  ac_cust_job,
                            input  ac_cust_seq,
                            input  ac_cust_ref,
                            input  ac_asn_shipper,
                            output l_cncix_qty1)"}.

            if l_cncix_qty1 < (tot_qty_consumed * trans_conv)
            then do:

               /* ERROR: MAXIMUM CONSIGNMENT QUANTITY TO BE INVOICED # */
               {pxmsg.i &MSGNUM=6673 &ERRORLEVEL=3 &MSGARG1=l_cncix_qty1}
               undo, retry.

            end. /* IF l_cncix_qty1 < tot_qty_consumed */
         end. /* ELSE DO */

/* ss 20070302.1 - b */
         cust_usage_ref = ac_cust_usage_ref.
         disp xxrqmrqby_userid with frame aa.
/* ss 20070302.1 - e */

         display
            ac_cust_usage_ref @ cust_usage_ref
            ac_cust_usage_date @ cust_usage_date
            ac_selfbill_auth   @ selfbill_auth
            ac_eff_date        @ l_effdate
         with frame aa.

         setloop3:
         do on error undo, retry:

            set
/* ss 20070312.1 */
/*
               cust_usage_ref
               xxrqmrqby_userid
 */
/* ss 20070312.1 */
               cust_usage_date
               selfbill_auth   when (using_selfbilling)
               l_effdate
            with frame aa.

         end.  /* SETLOOP3 */

         assign
            ac_cust_usage_ref = cust_usage_ref
            ac_cust_usage_date = if cust_usage_date = ?
                                  then today
                                  else cust_usage_date
            ac_selfbill_auth = selfbill_auth
            ac_eff_date = if l_effdate = ?
                          then
                             today
                          else
                             l_effdate
            ac_tot_qty_consumed = tot_qty_consumed
            ac_consumed_um = consumed_um
            ac_consumed_um_conv = trans_conv
            .

/* ss 20070312.1 - b */
/* ss 20070417.1 - b */
/*
         for each tt1 where tt1_nbr <> "" and tt1_order = ac_order and tt1_line = string(ac_line) :
         	 delete tt1.
         end.         
*/
/* ss 20070417.1 - e */
        
         for each tt1 where tt1_nbr = "" :
         	 assign tt1.tt1_nbr = cust_usage_ref.
         end.

/*         
      end. /* SETLOOP2 */
 */
/* ss 20070312.1 - e */

   end. /* SETLOOP1 */

end. /* SHIPLOOP */


if valid-handle(ph_socmnrtn)
   and ph_socmnrtn:PERSISTENT
then do:

   delete procedure ph_socmnrtn.

end. /* IF VALID-HANDLE(ph_socmnrtn) */

if can-find(first bAutoCreate where
                ac_tot_qty_consumed <> 0)
then do on end-key undo, leave:

   ok_to_display = yes.
   {pxmsg.i &MSGNUM=636
            &ERRORLEVEL=1
            &CONFIRM=ok_to_display
            &CONFIRM-TYPE='LOGICAL'}

   if ok_to_display then do:
      /* DISPLAY QUANTITIES */

/* ss 20070419.1 - b */
			clear frame d no-pause.
/* ss 20070419.1 - e */

      for each bAutoCreate
         where ac_tot_qty_consumed <> 0
         use-index sort_order
      no-lock:

         display
            ac_part               @ part
            ac_loc                @ location
            ac_consumed_um        @ um
            ac_tot_qty_consumed   @ frmd_tot_qty_consumed
         with frame d.

         if can-find (first sr_wkfl  where sr_wkfl.sr_domain = global_domain
         and
            sr_userid = mfguser             and
            sr_lineid = string(ac_count)    and
            sr_qty <> 0)
            then do:

            for each sr_wkfl
                where sr_wkfl.sr_domain = global_domain and  sr_userid =
                mfguser         and
               sr_lineid = string(ac_count)   and
               sr_qty <> 0
               no-lock:

               display
                  ac_part        @ part
                  ac_loc         @ location
                  ac_consumed_um @ um
                  sr_lotser      @ lotser
                  sr_ref         @ ref
                  sr_qty         @ frmd_tot_qty_consumed
               with frame d.

               down with frame d.

            end.  /* for each sr_wkfl */

         end.  /* if can-find (first sr_wkfl) */

         down with frame d.

      end.  /* for each bAutoCreate */
   end.  /* if ok_to_display */

   /* ASK IF EVERYTHING IS CORRECT. IF YES THEN  */
   /* RETURN YES AS THE OUTPUT PARAMETER TO THE  */
   /* CALLING PROGRAM.                           */

   ok_to_continue = yes.

   {pxmsg.i &MSGNUM=12
            &ERRORLEVEL=1
            &CONFIRM=ok_to_continue
            &CONFIRM-TYPE='LOGICAL'}

   continue-yn = ok_to_continue.

end.  /* if can-find(first bAutoCreate) */

hide frame b.
hide frame c.


/* ========================================================================= */
/* ************************ INTERNAL PROCEDURES **************************** */
/* ========================================================================= */

/* ========================================================================= */
PROCEDURE displayConsignmentDetails:
/* -------------------------------------------------------------------------
Purpose:      This procedure displays the consignment data to the screen.
Exceptions:   None
Conditions:
Pre:
Post:
Notes:
History:

Inputs:
Outputs:
 --------------------------------------------------------------------------- */

   define parameter buffer bAutoCreate for tt_autocr.

   define variable cntr as integer no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      assign
         site     = bAutoCreate.ac_site
         location = bAutoCreate.ac_loc
         lotser   = bAutoCreate.ac_lotser
         ref      = bAutoCreate.ac_ref.

        /* LOT/SERIAL ITEMS */
      if can-find (first sr_wkfl  where sr_wkfl.sr_domain = global_domain and
         sr_userid = mfguser   and
         sr_lineid = string(bAutoCreate.ac_count) and
         sr_qty <> 0)
         then do:

         for each sr_wkfl  where sr_wkfl.sr_domain = global_domain and
            sr_userid = mfguser and
            sr_lineid = string(bAutoCreate.ac_count) and
            sr_qty <> 0
            no-lock:

            assign
               cntr = cntr + 1
               location = sr_loc.

            if cntr = 1 then           /* SINGLE */
               assign
                  lotser      = sr_lotser
                  ref         = sr_ref
                  multi_entry = no.
            else do:
               assign                 /* MULTI-ENTRY */
                  lotser      = ""
                  ref         = ""
                  multi_entry = yes.
               leave.
            end.  /* else do */

         end.  /* for each sr_wkfl */

      end.  /* if can-find (first sr_wkfl) */

/* ss 20070709 - b */
      cust_part = "".
			for each cp_mstr no-lock where cp_domain = global_domain and
				 	cp_part = bAutoCreate.ac_part by cp_cust_eco:
			 		cust_part = cp_cust_part.
			end.
/* ss 20070709 - e */

      display
      /*
         bAutoCreate.ac_sopart*/
         cust_part						         @ sopart
         bAutoCreate.ac_part           @ part
         bAutoCreate.ac_po             @ po
         bAutoCreate.ac_order          @ order
         bAutoCreate.ac_line           @ line
         bAutoCreate.ac_site           @ site
         bAutoCreate.ac_loc            @ location
         bAutoCreate.ac_tot_qty_consumed @ tot_qty_consumed
         bAutoCreate.ac_consumed_um    @ consumed_um
         lotser
         ref
         multi_entry
      with frame c.

   end. /*Do on error undo..*/

   return {&SUCCESS-RESULT}.

END PROCEDURE. /*displayConsignmentDetails*/

/* ss 20070728.1 - b */

procedure xxmj:
	
		define input parameter p_part like pt_part no-undo.
		define input parameter p_cust like so_cust no-undo.
		define input parameter p_nbr  as char no-undo.
		define var v_qty like tr_qty_loc no-undo.
		define buffer btt11 for tt1.
		for first xxmj_mstr where xxmj_domain = global_domain and
			xxmj_cust = p_cust and xxmj_part = p_part and
			xxmj_start_date <= today
			no-lock:
			
			v_qty = 0.
			IF xxmj_type = '1' or xxmj_type = "3" THEN DO:
				if xxmj_type = "3" then do:
					if xxmj_end_date < today then do:
						message '模具' xxmj_nbr '已经分摊完' VIEW-AS ALERT-BOX.
      			leave.
      		end.	
				end.
			
				for each btt11 where btt11.tt1_item = xxmj_part and btt11.tt1_stat <> "" no-lock:
					
					IF v_qty < xxmj_qty THEN
      				v_qty = v_qty + btt11.tt1_qty_inv.
      		if v_qty >= xxmj_qty then do:
      				message '模具' xxmj_nbr '已经分摊完' VIEW-AS ALERT-BOX .
      				leave.
      		end.
      	end. /* for each btt11 */
      	
      	if v_qty >= xxmj_qty then leave.
				
				for each xxrqm_mstr where xxrqm_domain = global_domain and xxrqm_cust = p_cust and
					xxrqm_nbr <> p_nbr and not xxrqm_invoiced  no-lock, 
					EACH xxabs_mstr WHERE xxabs_domain = global_domain and xxabs_nbr = xxrqm_nbr no-lock,
					each sod_det where sod_domain = global_domain and sod_nbr = xxabs_order and sod_line = int(xxabs_line) 
						and sod_part = xxmj_part no-lock:
					IF v_qty < xxmj_qty then 
						v_qty = v_qty + xxabs_ship_qty.
					if v_qty >= xxmj_qty then do:
      			message '模具' xxmj_nbr '已经分摊完' VIEW-AS ALERT-BOX .
      			leave.
      		end.
				end.
				
				if v_qty >= xxmj_qty then leave.
				FOR EACH ih_hist WHERE ih_domain = GLOBAL_domain
                 AND ih_cust = xxmj_cust
                 AND ih_inv_date >= xxmj_start_date
                 NO-LOCK,
  					EACH idh_hist WHERE idh_domain = GLOBAL_domain
                  AND idh_inv_nbr = ih_inv_nbr
                  AND idh_nbr = ih_nbr 
                  AND idh_part = xxmj_part NO-LOCK
                  BY ih_inv_date :
						
						IF v_qty < xxmj_qty THEN 
      				v_qty = v_qty + idh_qty_inv .
      			if v_qty >= xxmj_qty then do:
      				message '模具' xxmj_nbr '已经分摊完' VIEW-AS ALERT-BOX .
      				leave.
      			end.		
  			END.
  			
  			if v_qty >= xxmj_qty then leave.
  			
			end.

			IF xxmj_type = '2' THEN DO:
				if xxmj_end_date < today then do:
					message '模具' xxmj_nbr '已经分摊完' VIEW-AS ALERT-BOX .
      		leave.
				end.
			end.
			
		end.

end procedure.

/* ss 20070728.1 - e */
