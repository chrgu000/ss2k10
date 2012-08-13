/* GUI CONVERTED from sosomtf3.p (converter v1.69) Wed Sep 10 15:19:46 1997 */
/* sosomtf3.p - SALES ORDER MAINTENANCE CONFIGURED PRODUCTS             */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/* REVISION: 7.3      LAST MODIFIED: 06/15/94   BY: WUG *GK60*          */
/* REVISION: 7.3      LAST MODIFIED: 07/21/94   BY: WUG *GK86*          */
/* REVISION: 7.4      LAST MODIFIED: 09/10/94   BY: afs *H510*          */
/* REVISION: 7.4      LAST MODIFIED: 11/01/94   BY: ame *GN90*          */
/* REVISION: 7.3      LAST MODIFIED: 11/11/94   BY: qzl *FT43*          */
/* REVISION  7.3      LAST MODIFIED: 01/04/95   BY: aep *F0CN*          */
/* REVISION  7.4      LAST MODIFIED: 01/11/95   BY: jxz *F0DG*          */
/* REVISION: 7.3      LAST MODIFIED: 01/11/95   BY: qzl *F0DH*          */
/* REVISION: 7.4      LAST MODIFIED: 02/20/95   BY: dxk *F0JN*          */
/* REVISION: 7.4      LAST MODIFIED: 03/07/95   BY: kjm *F0LT*          */
/* REVISION: 7.4      LAST MODIFIED: 03/31/95   BY: aed *F0PX*          */
/* REVISION: 7.4      LAST MODIFIED: 04/06/95   BY: dxk *F0Q3*          */
/* REVISION: 8.5      LAST MODIFIED: 03/09/95   BY: DAH *J042*          */
/* REVISION: 8.5      LAST MODIFIED: 07/10/95   BY: DAH *J05D*          */
/* REVISION: 7.4      LAST MODIFIED: 09/06/95   BY: ais *G0WL*          */
/* REVISION: 7.4      LAST MODIFIED: 10/25/95   BY: rxm *G1B4*          */
/* REVISION: 7.4      LAST MODIFIED: 12/07/95   BY: rxm *H0FS*          */
/* REVISION: 7.4      LAST MODIFIED: 01/22/96   BY: rxm *G1KC*          */
/* REVISION: 7.4      LAST MODIFIED: 01/24/96   BY: rxm *G1KP*          */
/* REVISION: 8.5      LAST MODIFIED: 03/28/96   BY: mzh *J0GK*          */
/* REVISION: 8.5      LAST MODIFIED: 04/02/96   BY: DAH *J0GT*          */
/* REVISION: 8.5      LAST MODIFIED: 04/15/96   BY: DAH *J0HR*          */
/* REVISION: 8.5      LAST MODIFIED: 05/21/96   BY: DAH *J0N2*          */
/* REVISION: 8.5      LAST MODIFIED: 07/05/96   BY: DAH *J0XR**/
/* REVISION: 8.5      LAST MODIFIED: 07/15/96   BY: ajw *J0Z6*          */
/* REVISION: 8.5      LAST MODIFIED: 05/28/97   BY: *J1RY* Tim Hinds    */
/* REVISION: 8.5      LAST MODIFIED: 11/14/03   BY: *LB01* Long Bo         */

/*GETS A COMPONENT PART FROM THE USER AND UPDATES QTY, PRICE INFO*/

/* References to work3_... (from H0FS) have been obsoleted by v8.5 */
/* v8.5 retains original references to work2_... */

/*F0PX*/ /*V8:EditableDownFrame=w */

define input param parent_id as character.
define input param parent_qty as decimal.
define input param parent_item as character.
define input param feature as character.
define input param mandatory like mfc_logical.

define shared variable cpex_prefix as character.
define shared variable cpex_ordernbr as character.
define shared variable cpex_orderline as integer.
define shared variable cpex_rev_date as date.
define shared variable cpex_order_due_date as date.
define shared variable cpex_site as character.
define shared variable cpex_ex_rate like so_ex_rate.
define shared variable cpex_mfg_lead like ptp_mfg_lead.
define shared variable cpex_last_id as integer.

define shared variable global_user_lang_dir as character.
/*J0N2*/ define shared variable global_user_lang as character.
/*J0N2*/ define shared variable batchrun like mfc_ctrl.mfc_logical.
define shared variable mfguser as character.
define shared variable config_changed like mfc_logical.              /*F0LT*/
/*J042** /*H0FS*/ define shared variable undo_all_config like mfc_logical
                                                              no-undo. */

define variable mandatory_caption as character.
define variable temp_id as integer.
define variable lines as integer.
define variable prior_qty_sel as decimal.
define variable open_ref as decimal.
define variable desc1 as character.
define variable new_parent_id as character.
define variable from_date as date.
define variable due_date as date.
define variable frame_val_save as character.
define variable up_lines as integer.
define variable pricelist2 as character.
define variable curr as character.
define variable um_conv as decimal.
define variable lineffdate as date.
/*J042** /*H0FS*/ define shared variable lineffdate like so_due_date. */
define variable list_pr as decimal.
define variable price as decimal.
define variable minprice as decimal.
define variable maxprice as decimal.
define variable minmaxerr like mfc_logical.
/*F0CN*/ define variable mrp_recno as recid.
/*F0CN*/ define variable recno as recid.
/*J0N2*/ define variable msg_temp like msg_desc.
/*J0N2*/ define variable msg_tmp2 like msg_desc.
/*J0N2*/ define variable msg_indx as integer.

/*H510*/ define variable pc_recno as recid.

/*FT43*/ define variable disc_ok like mfc_logical.
/*J042**
** /*FT43*/ define variable old_disc_pct as decimal format "->>9.9<".
**J042*/
/*J042*/ define variable old_disc_pct as decimal format "->>>9.9<<<".
/*FT43*/ define variable old_list_price as decimal format "->>>,>>9.99<<<<<".

/*J042*/ define shared variable line_pricing like mfc_logical.
/*J042*/ define shared variable reprice_dtl like mfc_logical.
/*J042*/ define shared variable pics_type like pi_cs_type.
/*J042*/ define shared variable part_type like pi_part_type.
/*J042*/ define shared variable picust like cm_addr.
/*J042*/ define variable update_accum_qty like mfc_logical.
/*J042*/ define variable um like sod_um.
/*J042*/ define variable save_disc_pct as decimal.
/*J042*/ define variable man_disc_pct as decimal.
/*J042*/ define variable sys_disc_fact as decimal.
/*J042*/ define variable discount as decimal.
/*J042*/ define shared variable new_order like mfc_logical.
/*J042*/ define variable err_flag as integer.
/*J042*/ define variable crt_int like sod_crt_int.
/*J042*/ define variable rfact as integer.
/*J05D*/ define variable already_priced like mfc_logical.
/*J0GK*/ define variable factor like mfc_logical initial no.
/*J0GT*/ define variable sobsite like sod_site.
/*J0GT*/ define variable glxcst like sct_cst_tot.
/*J0GT*/ define variable curcst like sct_cst_tot.
/*J0N2*/ define variable disc_min_max like mfc_logical.
/*J0N2*/ define variable disc_pct_err as decimal format "->>>>,>>>,>>9.9<<<".
/*J0N2*/ define variable last_net_price like sob_price.
/*J0N2*/ define variable sobdiscpct as decimal.

/*J042*/ {pppivar.i } /*SHARED VARIABLES FOR PRICING*/
/*J042*/ {pppiwkpi.i } /*SHARED WORKFILE FOR PRICING*/

/*J042**
** /*H0FS*/ define variable old_net_price as decimal format "->>>,>>9.99<<<<<".
** /*H0FS*/ define variable work3_recno as recid no-undo.
** /*H0FS*/ define variable sob_recno as recid no-undo.
**J042*/

{mfdatev.i}

define shared workfile wcomp_list
   field wcomp_comp like ps_comp
   field wcomp_component_req_qty as decimal
   field wcomp_component_sel_qty as decimal
   field wcomp_default like ps_default
   field wcomp_lt_off like ps_lt_off
   field wcomp_mandatory like ps_mandatory
   field wcomp_op like ps_op
   field wcomp_ps_code like ps_ps_code
   field wcomp_ref like ps_ref
   field wcomp_scrp_pct like ps_scrp_pct
/*J1RY*/ field wcomp_cf_lprice  like mfc_logical
/*J1RY*/ field wcomp_cf_lpricev like sod_list_pr
/*J1RY*/ field wcomp_cf_disc    like mfc_logical
/*J1RY*/ field wcomp_cf_discv   like sod_disc_pct
.

define workfile work_list
  field work_comp like sob_part
  field work_default like mfc_logical
/*J042** field work_disc_pct as dec format "->>9.9<" column-label "Disc %"*/
/*J042*/ field work_disc_pct as decimal format "->>>9.9<<<" column-label "销售!折扣帐户"
  field work_list_price as decimal
     format "->>>,>>9.99<<<<<" column-label "价格单价格"
  field work_lt_off like ps_lt_off
  field work_mandatory like ps_mandatory
  field work_net_price as decimal
     format "->>>,>>9.99<<<<<" column-label "净价"
  field work_op like ps_op
  field work_ps_code as character
  field work_qty_req as decimal
     format "->>>,>>9.9<<<<<<" column-label "需求"
  field work_qty_sel as decimal
     format "->>>,>>9.9<<<<<<" column-label "已选择"
  field work_scrp_pct as decimal
/*J042** /*H0FS*/    field work_man_price like mfc_logical */
/*J042*/ field work_ref like ps_ref
.

define workfile work2_list
  field work2_comp like sob_part
  field work2_default like mfc_logical
/*J042** field work2_disc_pct as dec format "->>9.9<" column-label "Disc %"*/
/*J042*/ field work2_disc_pct as decimal format "->>>9.9<<<" column-label "销售!折扣帐户"
  field work2_list_price as decimal
     format "->>>,>>9.99<<<<<" column-label "价格单价格"
  field work2_lt_off like ps_lt_off
  field work2_mandatory like ps_mandatory
  field work2_net_price as decimal
     format "->>>,>>9.99<<<<<" column-label "净价"
  field work2_op like ps_op
  field work2_ps_code as character
  field work2_qty_req as decimal
     format "->>>,>>9.9<<<<<<" column-label "需求"
  field work2_qty_sel as decimal
     format "->>>,>>9.9<<<<<<" column-label "已选择"
  field work2_scrp_pct as decimal
/*J042*/ field work2_ref like ps_ref
.

/*J042** /*H0FS*/ {gpfowfop.i} */  /* work3_list SHARED WORKFILE & VARIABLES */

mandatory_caption = if mandatory  then "必备" else "可选项".

/*J042**
** /*H0FS*/ for each work3_list exclusive-lock:
** /*H0FS*/    delete work3_list.
** /*H0FS*/ end.
**J042*/

/*J042*/ find first pic_ctrl no-lock.
/*J0N2**
** /*J042*/ if pic_so_fact then
** /*J042*/    rfact = pic_so_rfact.
** /*J042*/ else
** /*J042*/    rfact = pic_so_rfact + 2.
**J0N2*/

/*J0GK*/ if cpex_prefix = "qod_det" then do:
/*J0GK*/    if pic_qo_fact then
/*J0N2*/       assign
/*J0GK*/          factor = yes
/*J0N2*/          rfact  = pic_qo_rfact
/*J0N2*/       .
/*J0GK*/    else
/*J0N2*/       assign
/*J0GK*/          factor = no
/*J0N2*/          rfact  = pic_qo_rfact + 2
/*J0N2*/       .
/*J0GK*/ end. /* if cpex_prefix = "qod_det" */

/*J0GK*/ else do:
/*J0GK*/    if pic_so_fact then
/*J0N2*/       assign
/*J0GK*/          factor = yes
/*J0N2*/          rfact  = pic_so_rfact
/*J0N2*/       .
/*J0GK*/    else
/*J0N2*/       assign
/*J0GK*/          factor = no
/*J0N2*/          rfact  = pic_so_rfact + 2
/*J0N2*/       .
/*J0GK*/ end. /* else do */

/*GET ALL SOB_DET RECORDS AT THIS LEVEL AND WRITE TO WORKFILE*/

for each sob_det no-lock
where sob_nbr = cpex_prefix + cpex_ordernbr
and sob_line = cpex_orderline
and sob_parent = parent_id
and sob_feature = feature:
   create work_list.

   assign
   work_comp = sob_part
   work_default = substr(sob_serial,36,1) = "y"
/*J042**work_disc_pct =
**          if sob_tot_std <> 0 then
**             (sob_tot_std - sob_price) * 100 / sob_tot_std
**          else 0*/
   work_list_price = sob_tot_std
   work_lt_off = integer(substr(sob_serial,37,3))
   work_mandatory = substr(sob_serial,35,1) = "y"
   work_net_price = sob_price
/*G1KC         work_op = integer(substring(sob_serial,1,4)) */
/*G1KC*/       work_op = integer(substring(sob_serial,41,6))
   work_ps_code = substr(sob_serial,15,1)
   work_qty_req = decimal(substr(sob_serial,17,18))
   work_qty_sel = sob_qty_req
   work_scrp_pct = decimal(substr(sob_serial,5,6))
/*J042** /*H0FS*/       work_man_price = substring(sob_serial,40,1) = "y" */
/*J042*/ work_ref = feature
   .

/*J042*/ if sob_tot_std <> 0 then do:
/*J0N2*/ /*J042*/    work_disc_pct = if factor then
/*J0N2*/ /*J042*/              round((sob_price / sob_tot_std),rfact)
/*J042*/                    else
/*J042*/                       (sob_tot_std - sob_price) * 100 / sob_tot_std.
/*J042*/ end.
/*J042*/ else
/*J0GK *J042*    work_disc_pct = 0. */
/*J0GK*/ work_disc_pct = if factor then 1
                         else 0.

end.



/*ADD RECORDS TO WORKFILE FROM STANDARD BOM LIST NOT  ALREADY  IN
SOB_DET.   NOTE  WE  MULTIPLY  REQ BY PARENT QTY SINCE WHAT IS IN
WCOMP_LIST IS JUST QTY PER PARENT UNIT.  WE  LEAVE  SELECTED  QTY
ZERO  BECAUSE  ANY  POSITIVE SELECTED QTY WOULD HAVE COME THRU IN
THE SOB_DET RECORDS.*/

for each wcomp_list no-lock
where wcomp_ref = feature
and not can-find(sob_det
where sob_nbr = cpex_prefix + cpex_ordernbr
and sob_line = cpex_orderline
and sob_parent = parent_id
and sob_feature = feature
and sob_part = wcomp_comp)
break by wcomp_comp:
   accumulate wcomp_component_req_qty (sub-total by wcomp_comp).

   if last-of(wcomp_comp) then do:
      create work_list.

      assign
      work_comp = wcomp_comp
      work_default = wcomp_default
      work_lt_off = wcomp_lt_off
      work_mandatory = wcomp_mandatory
      work_op = wcomp_op
      work_ps_code = wcomp_ps_code
      work_qty_req = (accum sub-total by wcomp_comp wcomp_component_req_qty)
                     * parent_qty
      work_qty_sel = 0
      work_scrp_pct = wcomp_scrp_pct
/*J042*/ work_ref = feature
      .

      find pt_mstr where pt_part = wcomp_comp no-lock no-error.

      if available pt_mstr then do:
         if wcomp_ps_code = "o" then do:
            work_list_price = pt_price * cpex_ex_rate.
            work_net_price = work_list_price.
         end.
      end.

      if work_list_price <> 0 then do:
         work_disc_pct =
/*J042* DETERMINE DISCOUNT DISPLAY FORMAT*/
/*J0N2*/ /*J042*/ if factor then
/*J0N2*/ /*J042*/    round((work_net_price / work_list_price),rfact)
/*J042*/ else
            (work_list_price - work_net_price) * 100 / work_list_price.
      end.
      else
/*J0GK   work_disc_pct = 0. */
/*J0GK*/ work_disc_pct = if factor then 1
                         else 0.
   end.
end.



/*SORT THE WORKFILE AND CREATE A SECOND WORKFILE  WHICH  IS  USED
FOR  UPDATE  BY  THE  USER.  */

/*J0N2** /*FT43*/ disc_ok = yes. */
/*GN90* for each work_list no-lock*/
/*GN90*/ for each work_list exclusive-lock
break by work_comp:
   if last-of(work_comp) then do:
      create work2_list.

      assign
      work2_comp = work_comp
      work2_default = work_default
      work2_disc_pct = work_disc_pct
      work2_list_price = work_list_price
      work2_lt_off = work_lt_off
      work2_mandatory = work_mandatory
      work2_net_price = work_net_price
      work2_op = work_op
      work2_ps_code = work_ps_code
      work2_qty_req = work_qty_req
      work2_qty_sel = work_qty_sel
      work2_scrp_pct = work_scrp_pct
/*J042*/ work2_ref = work_ref
      .

/*J042**
** /*H0FS*/ work3_man_price = work_man_price
** /*H0FS*/ work3_recno = recid(work3_list)
**          .
**
**
**             /* PRICE LIST LOOK UP FOR OPTIONS */
** /*H0FS*/       if (work3_qty_sel = 0 or work3_net_price = 0)
** /*H0FS*/       and not work3_man_price then do:
** /*H0FS*/          sob_recno = ?.
** /*H0FS*/          {gprun.i ""gppccala.p"" "(input work3_comp,
**                                            input work3_recno,
**                                            input sob_recno)"}
** /*H0FS*/          if keyfunction(lastkey) = "END-ERROR" then do:
** /*H0FS*/             undo_all_config = yes.
** /*H0FS*/             undo, leave.
** /*H0FS*/          end.
** /*H0FS*/       end.
**J042*/

/*J0N2**
** /*J042**
** ** /*FT43*/ if work2_disc_pct > 999.99 or work2_disc_pct < -999.99 then do:
** **J042*/
** /*J042*/if work2_disc_pct > 9999.9999 or work2_disc_pct < -9999.9999 then do:
** /*G0WL /*FT43*/  work2_disc_pct = 0.  */
** /*J042** /*G0WL*/    work2_disc_pct = 999.9. */
** /*J0GK *J042*    work2_disc_pct = 0. */
** /*J0GK*/    work2_disc_pct = if factor then 1
**                             else 0.
** /*FT43*/    disc_ok = no.
** /*FT43*/ end.
**J0N2*/
      lines = lines + 1.
   end.

   delete work_list.
end.

/*J0N2**
** /*FT43*/ if not disc_ok then do:
** /*G0WL*/    /* DISCOUNT IS OUT OF RANGE AND WILL BE SET TO ALL 9'S  */
** /*J042*/    /* DISCOUNT IS OUT OF RANGE AND WILL BE SET 0 */
** /*FT43*/    {mfmsg.i 667 2}
** /*FT43*/    pause.
** /*FT43*/ end.
**J0N2*/

if lines = 0 then return.
lines = min(9,lines).



FORM /*GUI*/ 
   work2_default no-label format "*/ "
   work2_comp
   work2_qty_req
   work2_qty_sel
   work2_list_price
   work2_disc_pct
   work2_net_price
with frame w
row 9
scroll 1
lines down
overlay
no-validate
no-attr-space
width 80
title color normal " 已配置零件: " + string(parent_item,"x(18)") +
/*H0FS   "  " + mandatory_caption + " Feature " + feature. */
/*H0FS*/ "  " + mandatory_caption + " 特性: " + feature + " " THREE-D /*GUI*/.


pause 0.
view frame w.
pause before-hide.



/*F0JN* Begin windo1u.i *******************************************F0JN*/
mainloop:
do:
   {windo1u.i

   work2_list

   "
   work2_default
   work2_comp
   work2_qty_req
   work2_qty_sel
   work2_list_price     when (work2_ps_code = ""o"")
   work2_disc_pct       when (work2_ps_code = ""o"")
   work2_net_price      when (work2_ps_code = ""o"")
   "

   work2_comp

   " "

   yes
   "
   find pt_mstr where pt_part = ix1array[frame-line(w)]
     no-lock no-error.
   if available pt_mstr then message pt_desc1.
   "
   }
/*F0JN* End windo1u.i ********************************************F0JN*/


   if keyfunction(lastkey) = "RETURN" then do trans
   with frame w on error undo, leave on endkey undo, leave:
      find work2_list where recid(work2_list) = recidarray[frame-line(w)].
      open_ref = ?.

      find in_mstr where in_part = work2_comp and in_site = cpex_site
      no-lock no-error.
      if available in_mstr then do:
         open_ref = max(in_qty_oh - max (in_qty_all,0),0).
      end.

      desc1 = "".
      find pt_mstr where pt_part = work2_comp no-lock no-error.
      if available pt_mstr then desc1 = pt_desc1.
      message work2_comp desc1 "       可供货量: " open_ref.

      /*UPDATE QTY TO SELECT*/
      prior_qty_sel = work2_qty_sel.

/*F0DG*/ /*Initialize selected qty to required qty if ..*/
/*F0Q3   *F0DG* if not work2_mandatory and work2_qty_sel = 0 */
/*F0Q3*/ if not (work2_mandatory and work2_default) and work2_qty_sel = 0
/*F0Q3*/ then work2_qty_sel = work2_qty_req.
         update work2_qty_sel.

      /*UPDATE PRICES ONLY FOR OPTIONS*/
      if work2_ps_code = "o" then do:

/*FT43*/ old_disc_pct = work2_disc_pct.
/*FT43*/ old_list_price = work2_list_price.
/*J042** /*H0FS*/ old_net_price = work3_net_price. */

/*J042* DETERMINE DISCOUNT DISPLAY FORMAT*/
/*J042*/ if work2_list_price <> 0 then do:
/*J042*/    work2_disc_pct =
/*J0N2*/ /*J042*/ if factor then
/*J0N2*/ /*J042*/    round((work2_net_price / work2_list_price),rfact)
/*J042*/          else
/*J042*/             (work2_list_price - work2_net_price) * 100
/*J042*/                                               / work2_list_price.
/*J042*/ end.
/*J042*/ else
/*J0GK* *J042*    work2_disc_pct = 0. */
/*J0GK*/ work2_disc_pct = if factor then 1
                          else 0.

/*J042**    work2_disc_pct = if work2_list_price <> 0 then
**                     (work2_list_price - work2_net_price) * 100
**                     / work2_list_price
**                  else 0.
****************************************************************J042*/

/*J0N2**
** /*FT43*/ disc_ok = yes.
** /*J042**
** ** /*FT43*/ if work2_disc_pct > 999.99 or work2_disc_pct < -999.99 then do:
** **J042*/
** /*J042*/if work2_disc_pct > 9999.9999 or work2_disc_pct < -9999.9999 then do:
** /*G0WL /*FT43*/  work2_disc_pct = 0.    */
** /*J042** /*G0WL*/    work2_disc_pct = 999.9. */
** /*J0GK *J042*    work2_disc_pct = 0. */
** /*J0GK*/         work2_disc_pct = if factor then 1
**                                   else 0.
** /*FT43*/    disc_ok = no.
** /*G0WL*/    /* DISCOUNT IS OUT OF RANGE AND WILL BE SET TO ALL 9'S  */
** /*J042*/    /* DISCOUNT IS OUT OF RANGE AND WILL BE SET TO 0 */
** /*FT43*/    {mfmsg.i 667 2}
** /*FT43*/ end.
**J0N2*/

/*J042*/ /*RELOCATED THE FOLLOWING CODE TO SUPPORT CALLS TO PRICING
**J042*    ROUTINES. PRICING DATE, CURRENCY AND UNIT OF MEASURE ARE REQUIRED*/

/*J042*/ if cpex_prefix = "qod_det" then do:
/*J042*/    find qo_mstr where qo_nbr = cpex_ordernbr no-lock.
/*J042*/    pricelist2 = qo_pr_list2.
/*J042*/    curr = qo_curr.

/*J042*/    find qod_det where qod_nbr = cpex_ordernbr
/*J042*/    and qod_line = cpex_orderline no-lock.

/*J042*/    um = qod_um.
/*J042*/    um_conv = qod_um_conv.
/*J042**    lineffdate = qod_due_date.*/
/*J042*/    lineffdate = qod_pricing_dt.
/*J042*/    crt_int    = qod_crt_int.
/*J0GT*/    sobsite    = qod_site.
/*J042*/ end.
/*J042*/ else do:
/*J042*/    find so_mstr where so_nbr = cpex_ordernbr no-lock.
/*J042*/    pricelist2 = so_pr_list2.
/*J042*/    curr = so_curr.

/*J042*/    find sod_det where sod_nbr = cpex_ordernbr
/*J042*/    and sod_line = cpex_orderline no-lock.

/*J042*/    um = sod_um.
/*J042*/    um_conv = sod_um_conv.
/*J042**    lineffdate = sod_due_date.*/
/*J042*/    lineffdate = sod_pricing_dt.
/*J042*/    crt_int    = sod_crt_int.
/*J0GT*/    sobsite    = sod_site.
/*J042*/ end.

/*J042*/ /*INITIALIZE PRICING VARIABLES, GET BEST LIST PRICE, UPDATE
**J042*    ACCUM QTY WORKFILES.  GET BEST DISCOUNTS, CALCULATE BEST PRICE*/

/*J05D*/ /*TEST TO SEE IF PREVIOUS PROCEDURE HAS ALREADY UPDATED wkpi_wkfl,
           IF SO, NO NEED TO REPRICE THE LINE */

/*J05D*/ find first wkpi_wkfl where wkpi_source  = "0"       and
/*J05D*/                            wkpi_parent  = parent_id and
/*J05D*/                            wkpi_feature = work2_ref and
/*J05D*/                            wkpi_option  = work2_comp
/*J05D*/                      no-lock no-error.
/*J05D*/ if not available wkpi_wkfl then
/*J05D*/    already_priced = no.
/*J05D*/ else
/*J05D*/    already_priced = yes.

/*J0N2*/ assign
/*J0N2*/    last_net_price  = work2_net_price
/*J0N2*/    sobdiscpct      = (1 - (work2_net_price / work2_list_price))
/*J0N2*/                      * 100
/*J0N2*/ .

/*J05D** /*J042*/ if line_pricing or reprice_dtl then do: **/
/*J05D*/ if (line_pricing or reprice_dtl) and not already_priced then do:
/*J042*/    best_list_price = 0.
/*J042*/    best_net_price  = 0.

/*J0XR*/    /*Added cpex_site, cpex_ex_rate to parameters*/
            {gprun.i ""gppibx.p"" "(pics_type,
                                    picust,
                                    part_type,
                                    work2_comp,
                                    parent_id,
                                    work2_ref,
                                    work2_comp,
                                    1,
                                    curr,
                                    um,
                                    lineffdate,
                                    no,
                                    cpex_site,
                                    cpex_ex_rate,
                                    output err_flag)"}

/*J042*/    if best_list_price = 0 then do:
/*J042*/       find first wkpi_wkfl where wkpi_parent = parent_id and
/*J042*/                                  wkpi_feature = work2_ref and
/*J042*/                                  wkpi_option = work2_comp and
/*J042*/                                  wkpi_amt_type = "1"
/*J042*/                            no-lock no-error.
/*J042*/       if not available wkpi_wkfl then do:
/*J0GT*/          if available pt_mstr then do:
/*J0N2*/ /*J0GT*/    best_list_price = pt_price * cpex_ex_rate
/*J0XR*/                                        * um_conv.
/*J042*/             /*Create list type price list record in wkpi_wkfl*/
/*LB01*/             {gprun.i ""zzgppiwkad.p"" "(um,
                                               parent_id,
                                               work2_ref,
                                               work2_comp,
                                               ""4"",
                                               ""1"",
                                               best_list_price,
                                               0,
                                               no)"}
/*J0GT*/          end.
/*J0GT*/          else do:
/*J0GT*/             /*Create list type price list record in wkpi_wkfl
/*J0GT*/               for memo type*/
/*J0GT*/             best_list_price = work2_list_price.
/*LB01*/             {gprun.i ""zzgppiwkad.p"" "(um,
                                               parent_id,
                                               work2_ref,
                                               work2_comp,
                                               ""7"",
                                               ""1"",
                                               best_list_price,
                                               0,
                                               no)"}
/*J0GT*/          end.
/*J042*/       end.
/*J0GT** /*J042*/    best_list_price = work2_list_price. */
/*J0GT*/       else
/*J0GT*/          best_list_price = wkpi_amt.
/*J042*/    end.

/*J042*/    work2_list_price = best_list_price.
/*J042*/    work2_net_price  = best_list_price.

/*J042*/    /*CALCULATE TERMS INTEREST*/
/*J042*/    if crt_int <> 0 then do:
/*J042*/       work2_list_price = (100 + crt_int) / 100 * work2_list_price.
/*J042*/       work2_net_price  = work2_list_price.
/*J042*/       best_list_price  = work2_list_price.
/*J042*/       /*Create credit terms interest wkpi_wkfl record*/
/*LB01*/       {gprun.i ""zzgppiwkad.p"" "(um,
                                         parent_id,
                                         work2_ref,
                                         work2_comp,
                                         ""5"",
                                         ""1"",
                                         work2_list_price,
                                         0,
                                         no)"}
/*J042*/    end.

/*J042*/ end. /*if line_pricing or reprice_dtl*/

/*J042*/ if line_pricing or not new_order then do:
/*J0XR*/    /*Qualified the qty (work2_qty_sel - prior_qty_sel) and extended*/
/*J0XR*/    /*list (work2_qty_sel - prior_qty_sel * work2_list_price)       */
/*J0XR*/    /*parameters to divide by u/m conversion ratio since these      */
/*J0XR*/    /*include this factor already.                                  */
/*LB01*/  {gprun.i ""zzgppiqty2.p"" "(cpex_orderline,
                                      work2_comp,
                                     (work2_qty_sel - prior_qty_sel) / um_conv,
                                     (work2_qty_sel - prior_qty_sel) *
                                      work2_list_price / um_conv,
                                      um,
                                      no,
/*J0Z6*/                              yes,
                                      yes)"}

/*J042*/ end. /*line_pricing or not new_order*/

/*J05D** /*J042*/ if line_pricing or reprice_dtl then do:**/
/*J0HR* /*J05D*/if(line_pricing or reprice_dtl)and not already_priced then do:*/
/*J0HR*/ if work2_list_price <> 0 and not already_priced
/*J0HR*/                          and (line_pricing or reprice_dtl) then do:

/*J0GT*/    /*FIND THE ITEM COST BEFORE CALLING gppibx.p FOR DISCOUNTS*/

/*J0XR**    *NOW PERFORMED IN gppibx03.p*
** /*J0GT*/ {gpsct05.i &part=work2_comp &site=sobsite &cost=sct_cst_tot}
**J0XR*/

/*J042*/    /*GET BEST DISCOUNTS*/
/*J0GT** /*J042*/ item_cost = 0.  /*gppibx03.p will get cost if markup*/ */
/*J0XR** /*J0GT*/ item_cost = glxcst.  **Now performed in gppibx03.p*/
/*J0XR*/    /*Added cpex_site, cpex_ex_rate to parameters*/
            {gprun.i ""gppibx.p"" "(pics_type,
                                    picust,
                                    part_type,
                                    work2_comp,
                                    parent_id,
                                    work2_ref,
                                    work2_comp,
                                    2,
                                    curr,
                                    um,
                                    lineffdate,
                                    no,
                                    cpex_site,
                                    cpex_ex_rate,
                                    output err_flag)"}

/*J042*/    /*CALCULATE BEST PRICE*/
/*LB01*/    {gprun.i ""zzgppibx04.p"" "(parent_id,
                                      work2_ref,
                                      work2_comp,
                                      no,
                                      rfact)"}

/*J042*/    work2_net_price = best_net_price.
/*J0N2*/    sobdiscpct      = (1 - (work2_net_price / work2_list_price)) * 100.

/*J0N2*/    /* JUST IN CASE SYSTEM DISCOUNTS CHANGED SINCE THE LAST PRICING  */
/*J0N2*/    /* AND THE USER MANUALLY ENTERED THE PRICE (OR DISCOUNT), RETAIN */
/*J0N2*/    /* THE PREVIOUS NET PRICE (THAT'S WHAT THE USER WANTS) AND REVISE*/
/*J0N2*/    /* THE MANUAL DISCOUNT ADJUSTMENT TO COMPENSATE.                 */

/*J0N2*/    find first wkpi_wkfl where wkpi_parent   = parent_id  and
/*J0N2*/                               wkpi_feature  = work2_ref  and
/*J0N2*/                               wkpi_option   = work2_comp and
/*J0N2*/                               wkpi_amt_type = "2"        and
/*J0N2*/                               wkpi_source   = "1"
/*J0N2*/                         no-lock no-error.

/*J0N2*/    if available wkpi_wkfl
/*J0N2*/    then do:
/*J0N2*/       save_disc_pct   = sobdiscpct.
/*J0N2*/       work2_net_price = last_net_price.
/*J0N2*/       if work2_list_price <> 0 then
/*J0N2*/          sobdiscpct = (1 - (work2_net_price / work2_list_price))
/*J0N2*/                       * 100.
/*J0N2*/       else
/*J0N2*/          sobdiscpct = 0.

/*J0N2*/       if pic_disc_comb = "1" then do:      /*cascading discount*/
/*J0N2*/          if available wkpi_wkfl then
/*J0N2*/             sys_disc_fact = if not found_100_disc then
/*J0N2*/                                ((100 - save_disc_pct) / 100) /
/*J0N2*/                                ((100 - wkpi_amt)      / 100)
/*J0N2*/                             else
/*J0N2*/                                0.
/*J0N2*/          else
/*J0N2*/             sys_disc_fact =  (100 - save_disc_pct) / 100.
/*J0N2*/          if sys_disc_fact = 1 then
/*J0N2*/             man_disc_pct  = sobdiscpct.
/*J0N2*/          else do:
/*J0N2*/             if sys_disc_fact <> 0 then do:
/*J0N2*/                discount      = (100 - sobdiscpct) / 100.
/*J0N2*/                man_disc_pct  = (1 - (discount / sys_disc_fact)) * 100.
/*J0N2*/             end.
/*J0N2*/             else
/*J0N2*/                man_disc_pct  = sobdiscpct - 100.
/*J0N2*/          end.
/*J0N2*/       end.
/*J0N2*/       else do:
/*J0N2*/          if available wkpi_wkfl then
/*J0N2*/             man_disc_pct = sobdiscpct -
/*J0N2*/                            (save_disc_pct - wkpi_amt).
/*J0N2*/          else
/*J0N2*/             man_disc_pct = sobdiscpct - save_disc_pct.
/*J0N2*/       end.

/*LB01**J0N2*/       {gprun.i ""zzgppiwkad.p"" "(um,
                                         parent_id,
                                         work2_ref,
                                         work2_comp,
                                         ""1"",
                                         ""2"",
                                         0,
                                         man_disc_pct,
                                         no)"}
/*J0N2*/    end. /* last_net_price <> work2_net_price */

/*J042*/ end. /*if line_pricing or reprice_dtl*/

/*J0N2*/ /* TEST FOR DISCOUNT RANGE VIOLATION.  IF FOUND, CREATE/MAINTAIN */
/*J0N2*/ /* MANUAL DISCOUNT TO RECONCILE THE DIFFERENCE BETWEEN THE SYSTEM*/
/*J0N2*/ /* DISCOUNT AND THE MIN OR MAX ALLOWABLE DISCOUNT, DEPENDING ON  */
/*J0N2*/ /* THE VIOLATION.                                                */

/*J0N2*/ disc_min_max = no.
/*J0N2*/ {gppidisc.i factor sobdiscpct rfact}
/*J0N2*/ if disc_min_max then do:     /* found a discount range violation */
/*J0N2*/    {mfmsg03.i 6931 2 disc_pct_err """" """"}
/*J0N2*/    if not batchrun then
/*J0N2*/       pause.
/*J0N2*/    save_disc_pct = disc_pct_err.
/*J0N2*/    sobdiscpct    = if factor then
/*J0N2*/                       (1 - discount) * 100
/*J0N2*/                    else
/*J0N2*/                       discount.
/*J0N2*/    find first wkpi_wkfl where wkpi_parent   = parent_id  and
/*J0N2*/                               wkpi_feature  = work2_ref  and
/*J0N2*/                               wkpi_option   = work2_comp and
/*J0N2*/                               wkpi_amt_type = "2"        and
/*J0N2*/                               wkpi_source   = "1"
/*J0N2*/                         no-lock no-error.

/*J0N2*/    if pic_disc_comb = "1" then do:     /*cascading discount*/
/*J0N2*/       if available wkpi_wkfl then
/*J0N2*/          sys_disc_fact = ((100 - save_disc_pct) / 100) /
/*J0N2*/                            ((100 - wkpi_amt)      / 100).
/*J0N2*/       else
/*J0N2*/          sys_disc_fact =  (100 - save_disc_pct) / 100.
/*J0N2*/       if sys_disc_fact = 1 then
/*J0N2*/          man_disc_pct  = sobdiscpct.
/*J0N2*/       else do:
/*J0N2*/          if sys_disc_fact <> 0 then do:
/*J0N2*/             discount      = (100 - sobdiscpct) / 100.
/*J0N2*/             man_disc_pct  = (1 - (discount / sys_disc_fact))
/*J0N2*/                             * 100.
/*J0N2*/          end.
/*J0N2*/          else
/*J0N2*/             man_disc_pct  = sobdiscpct - 100.
/*J0N2*/       end.
/*J0N2*/    end.
/*J0N2*/    else do:                            /*additive discount*/
/*J0N2*/       if available wkpi_wkfl then
/*J0N2*/            man_disc_pct = sobdiscpct -
/*J0N2*/                         (save_disc_pct - wkpi_amt).
/*J0N2*/       else
/*J0N2*/          man_disc_pct = sobdiscpct - save_disc_pct.
/*J0N2*/    end.

/*LB01**J0N2*/    {gprun.i ""zzgppiwkad.p"" "(
                                      um,
                                      parent_id,
                                      work2_ref,
                                      work2_comp,
                                      ""1"",
                                      ""2"",
                                      0,
                                      man_disc_pct,
                                      no
                                    )"}


/*J0N2*/    work2_net_price = work2_list_pr * (1 - (sobdiscpct / 100)).

/*J0N2*/ end.    /* if disc_min_max */

/*J042*/ save_disc_pct = if work2_list_price <> 0 then
/*J042*/                    (work2_list_price - work2_net_price) * 100
/*J042*/                   / work2_list_price
/*J042*/                 else
/*J042*/                    0.

/*J042*/ if work2_list_price <> 0 then do:
/*J042*/    work2_disc_pct =
/*J0N2*/ /*J042*/ if factor then
/*J0N2*/ /*J042*/    round((work2_net_price / work2_list_price),rfact)
/*J042*/          else
/*J042*/             (work2_list_price - work2_net_price) * 100
/*J042*/                                                  / work2_list_price.
/*J042*/ end.
/*J042*/ else
/*J0GK* *J042*    work2_disc_pct = 0. */
/*J0GK*/ work2_disc_pct = if factor then 1
                          else 0.

/*J042*/ display work2_net_price.

/*J0N2*/ do on error undo, retry:

            update work2_list_price work2_disc_pct.

/*J042*/    /*TEST TO SEE IF LIST PRICE AND/OR DISCOUNT ARE MANUALLY ENTERED.
**J042*       IF SO, UPDATE PRICING WORKFILE TO REFLECT CHANGE*/

/*J042*/    if work2_list_price entered or work2_disc_pct entered then do:
/*J042*/       if work2_list_price entered then do:
/*LB01*/          {gprun.i ""zzgppiwkad.p"" "(um,
                                            parent_id,
                                            work2_ref,
                                            work2_comp,
                                            ""1"",
                                            ""1"",
                                            work2_list_price,
                                            0,
                                            no)"}
/*J042*/       end.
/*J042*/       if work2_disc_pct entered then do:
/*J0N2*/ /*J042*/ if factor then
/*J0N2*/ /*J042*/    sobdiscpct = (1 - work2_disc_pct) * 100.
/*J0N2*/          else
/*J0N2*/             sobdiscpct = work2_disc_pct.
/*J042*/
/*J0N2*/          disc_min_max = no.
/*J0N2*/          {gppidisc.i factor sobdiscpct rfact}
/*J0N2*/          if disc_min_max then do:
/*J0N2*/             {mfmsg03.i 6932 3 disc_pct_err """" """"}
/*J0N2*/             if not batchrun then
/*J0N2*/                pause.
/*J0N2*/             undo, retry.
/*J0N2*/          end.

/*J042*/          find first wkpi_wkfl where wkpi_parent   = parent_id  and
/*J042*/                                     wkpi_feature  = work2_ref  and
/*J042*/                                     wkpi_option   = work2_comp and
/*J042*/                                     wkpi_amt_type = "2"        and
/*J042*/                                     wkpi_source   = "1"
/*J042*/                               no-lock no-error.
/*J042*/
/*J042*/          if pic_disc_comb = "1" then do:     /*cascading discount*/
/*J042*/             if available wkpi_wkfl then
/*J0N2**
** /*J042*/                sys_disc_fact = ((100 - save_disc_pct) / 100) /
** /*J042*/                                ((100 - wkpi_amt)      / 100).
**J0N2*/
/*J0N2*/                sys_disc_fact = if not found_100_disc then
/*J0N2*/                                   ((100 - save_disc_pct) / 100) /
/*J0N2*/                                   ((100 - wkpi_amt)      / 100)
/*J0N2*/                                else
/*J0N2*/                                   0.
/*J042*/             else
/*J042*/                sys_disc_fact =  (100 - save_disc_pct) / 100.
/*J042*/             if sys_disc_fact = 1 then
/*J0N2** /*J042*/       man_disc_pct  = work2_disc_pct. */
/*J0N2*/                man_disc_pct  = sobdiscpct.
/*J042*/             else do:
/*J0N2*/                if sys_disc_fact <> 0 then do:
/*J0N2** /*J042*/          discount      = (100 - work2_disc_pct) / 100. */
/*J0N2*/                   discount      = (100 - sobdiscpct) / 100.
/*J042*/                   man_disc_pct  = (1 - (discount / sys_disc_fact))
/*J042*/                                   * 100.
/*J0N2*/                end.
/*J0N2*/                else
/*J0N2*/                   man_disc_pct  = sobdiscpct - 100.
/*J042*/             end.
/*J042*/          end.
/*J042*/          else do:
/*J042*/             if available wkpi_wkfl then
/*J0N2** /*J042*/       man_disc_pct = work2_disc_pct - */
/*J0N2*/                man_disc_pct = sobdiscpct -
/*J042*/                               (save_disc_pct - wkpi_amt).
/*J042*/             else
/*J0N2** /*J042*/       man_disc_pct = work2_disc_pct - save_disc_pct. */
/*J0N2*/                man_disc_pct = sobdiscpct.
/*J042*/          end.
/*J042*/
/*LB01*/          {gprun.i ""zzgppiwkad.p"" "(um,
                                            parent_id,
                                            work2_ref,
                                            work2_comp,
                                            ""1"",
                                            ""2"",
                                            0,
                                            man_disc_pct,
                                            no)"}

/*J042*/       end.
/*J042*/    end. /*if work2_list_price entered or work2_disc_pct entered*/

/*J0N2*/ end. /* do on error undo, retry */

/*J042**
** /*FT43*/ if work2_list_price <> old_list_price or
** /*FT43*/ (disc_ok and work2_disc_pct <> old_disc_pct) or
** /*G0WL /*FT43*/ (not disc_ok and work2_disc_pct <> 0) then   */
** /*G0WL*/ (not disc_ok and work2_disc_pct <> 999.9) then
**J042*/

/*J0GK   work2_net_price = ((100 - work2_disc_pct) / 100) * work2_list_price.*/

/*J0N2**
** /*J0GK*/ work2_net_price = if factor then
**                               (work2_disc_pct * work2_list_price)
**                      else (((100 - work2_disc_pct) / 100) * work2_list_price).
**J0N2*/
/*J0N2*/ work2_net_price = ((100 - sobdiscpct) / 100) * work2_list_price.

/*J042***RELOCATED THE FOLLOWING CODE ABOVE THE update work2_list_price****
**       if cpex_prefix = "qod_det" then do:
**          find qo_mstr where qo_nbr = cpex_ordernbr no-lock.
**          pricelist2 = qo_pr_list2.
**          curr = qo_curr.
**
**          find qod_det where qod_nbr = cpex_ordernbr
**          and qod_line = cpex_orderline no-lock.
**
**          um_conv = qod_um_conv.
** /*H0FS   lineffdate = qod_due_date. */
**       end.
**       else do:
**          find so_mstr where so_nbr = cpex_ordernbr no-lock.
**          pricelist2 = so_pr_list2.
**          curr = so_curr.
**
**          find sod_det where sod_nbr = cpex_ordernbr
**          and sod_line = cpex_orderline no-lock.
**
**          um_conv = sod_um_conv.
** /*H0FS   lineffdate = sod_due_date. */
**       end.
**
** /*H0FS if lineffdate = ? then lineffdate = today. */
****************************************************************J042*/
/*J1RY         disp work2_net_price.              */
/*J1RY*/       display work2_net_price.

/*J0N2** /*J042*/ save_disc_pct = work2_disc_pct. */
/*J0N2*/ save_disc_pct = sobdiscpct.

/*J0N2*/ if work2_list_price <> 0 then do:
/*J0N2*/    work2_disc_pct = if factor then
/*J0N2*/                       round((work2_net_price / work2_list_price),rfact)
/*J0N2*/                     else
/*J0N2*/                       (work2_list_price - work2_net_price) * 100
/*J0N2*/                      / work2_list_price.
/*J0N2*/ end.
/*J0N2*/ else
/*J0N2*/    work2_disc_pct = if factor then 1
/*J0N2*/                     else 0.

         do on error undo, retry:

            set work2_net_price.

/*J0N2*/       sobdiscpct = (1 - (work2_net_price / work2_list_price)) * 100.
/*J0N2*/       disc_min_max = no.
/*J0N2*/       {gppidisc.i factor sobdiscpct rfact}
/*J0N2*/       if disc_min_max then do:
/*J0N2*/          {mfmsg03.i 6932 3 disc_pct_err """" """"}
/*J0N2*/          if not batchrun then
/*J0N2*/             pause.
/*J0N2*/          undo, retry.
/*J0N2*/       end.

/*J042*/ /*TEST TO SEE IF NET PRICE HAS BEEN ENTERED, IF SO CREATE A
**J042*    TYPE MANUAL RECORD TO wkpi_wkfl.*/

/*J042*/    if work2_net_price entered and work2_list_price <> 0 then do:
/*J0N2** /*J042*/ work2_disc_pct = (1 - (work2_net_price / work2_list_price))*/
/*J0N2** /*J042*/                  100. */

/*J042*/       find first wkpi_wkfl where wkpi_parent   = parent_id  and
/*J042*/                                  wkpi_feature  = work2_ref  and
/*J042*/                                  wkpi_option   = work2_comp and
/*J042*/                                  wkpi_amt_type = "2"        and
/*J042*/                                  wkpi_source   = "1"
/*J042*/                            no-lock no-error.
/*J042*/
/*J042*/       if pic_disc_comb = "1" then do:      /*cascading discount*/
/*J042*/          if available wkpi_wkfl then
/*J0N2**
** /*J042*/             sys_disc_fact = ((100 - save_disc_pct) / 100) /
** /*J042*/                             ((100 - wkpi_amt)      / 100).
**J0N2*/
/*J0N2*/             sys_disc_fact = if not found_100_disc then
/*J0N2*/                                ((100 - save_disc_pct) / 100) /
/*J0N2*/                                ((100 - wkpi_amt)      / 100)
/*J0N2*/                             else
/*J0N2*/                                0.
/*J042*/          else
/*J042*/             sys_disc_fact =  (100 - save_disc_pct) / 100.
/*J042*/          if sys_disc_fact = 1 then
/*J0N2** /*J042*/    man_disc_pct  = work2_disc_pct. */
/*J0N2*/             man_disc_pct  = sobdiscpct.
/*J042*/          else do:
/*J0N2*/             if sys_disc_fact <> 0 then do:
/*J0N2** /*J042*/       discount      = (100 - work2_disc_pct) / 100. */
/*J0N2*/                discount      = (100 - sobdiscpct) / 100.
/*J042*/                man_disc_pct  = (1 - (discount / sys_disc_fact)) * 100.
/*J0N2*/             end.
/*J0N2*/             else
/*J0N2*/                man_disc_pct  = sobdiscpct - 100.
/*J042*/          end.
/*J042*/       end.
/*J042*/       else do:
/*J042*/          if available wkpi_wkfl then
/*J0N2** /*J042*/    man_disc_pct = work2_disc_pct - */
/*J0N2*/             man_disc_pct = sobdiscpct -
/*J042*/                            (save_disc_pct - wkpi_amt).
/*J042*/          else
/*J0N2** /*J042*/    man_disc_pct = work2_disc_pct - save_disc_pct. */
/*J0N2*/             man_disc_pct = sobdiscpct - save_disc_pct.
/*J042*/       end.
/*J042*/
/*LB01*/       {gprun.i ""zzgppiwkad.p"" "(um,
                                         parent_id,
                                         work2_ref,
                                         work2_comp,
                                         ""1"",
                                         ""2"",
                                         0,
                                         man_disc_pct,
                                         no)"}

/*J0N2*/       if work2_list_price <> 0 then do:
/*J0N2*/          work2_disc_pct = if factor then
/*J0N2*/                       round((work2_net_price / work2_list_price),rfact)
/*J0N2*/                     else
/*J0N2*/                       (work2_list_price - work2_net_price) * 100
/*J0N2*/                      / work2_list_price.
/*J0N2*/       end.
/*J0N2*/       else
/*J0N2*/          work2_disc_pct = if factor then 1
/*J0N2*/                           else 0.
/*J0N2*/
/*J0N2*/       display work2_disc_pct.
/*J0N2*/
/*J042*/    end.

/*J042**THE FOLLOWING CODE REPLACED BY BEST PRICE ROUTINE ABOVE**********
**
**          if pricelist2 <> "" then do:
** /*H0FS*/    list_pr = work3_list_price.
** /*H0FS*/    price = work3_net_price.
**
**             /* GET MIN & MAX PRICES */
** /*H510*/       /* Added parameters for price table required, recid */
**             {gprun.i ""gppclst.p""
**             "(input pricelist2,
**             input work2_comp,
**             input pt_um,
**             input um_conv,
**             input lineffdate,
**             input curr,
**             input no,
**             input no,
**             input-output list_pr,
**             input-output price,
**             output minprice,
**             output maxprice,
**             output pc_recno
**             )" }
**
**
**             /* PRICE TABLE MIN/MAX ERROR CHECK */
** /*H0FS*/    /* ADDED work3_comp & REMOVED um_conv PARAMETERS BELOW */
**             {gprun.i ""gpmnmx.p""
**             "(input no,
**             input yes,
**             input minprice,
**             input maxprice,
**             output minmaxerr,
**             input-output list_pr,
**             input-output price,
**             input work3_comp
**             )" }
**
**             if minmaxerr then do:
**                undo, retry.
**             end.
**          end.
** /*H0FS*/ /* IF EITHER PRICE HAS CHANGED, THEN FLAG THIS ITEM AS HAVING
**             IT'S PRICE MANUALLY UPDATED. IF THE DISCOUNT % WAS CHANGED,
**             THAT WOULD RESULT IN A DIFFERENT NET PRICE. SO THAT CHANGE
**             WOULD ALSO RESULT IN TURNING ON THE MANUAL PRICE UPDATE
**             FLAG. */
** /*H0FS*/ if work3_list_price <> old_list_price
** /*H0FS*/ or work3_net_price <> old_net_price then
** /*H0FS*/    work3_man_price = yes.
**
**************************************************************J042*/
         end.
       end.

      find sob_det
      where sob_nbr = cpex_prefix + cpex_ordernbr
      and sob_line = cpex_orderline
      and sob_parent = parent_id
      and sob_feature = feature
      and sob_part = work2_comp
      exclusive-lock no-error.

      if available sob_det then do:

/*F0LT*/ if (sob_qty_req <> work2_qty_sel) or (sob_tot_std <> work2_list_price)
/*F0LT*/ or (sob_price <> work2_net_price) then
/*F0LT*/    config_changed = yes.
/*G1B4
 * /*F0LT*/ else
 * /*F0LT*/    config_changed = no.
 *
 *G1B4   config_changed IS ONLY REINITIALIZED FOR EACH LINE (IN sosomtf8.p WHERE
 *       THE NEW SHARED VARIABLE IS DEFINED) NOT EACH OPTION, IF THE CURRENT
 *       OPTION IS NOT CHANGED, BUT A PREVIOUS ONE FOR THIS LINE WAS CHANGED, WE
 *       NEED TO RETAIN THE SETTING OF THE FLAG FROM THAT CHANGE IN ORDER TO
 *       OFFER THE RECALC PRICE MESSAGE.
 *G1B4*/

/*J042*/ if work2_ps_code = "o" and (line_pricing or not new_order) then
/*J042*/    update_accum_qty = yes.
/*J042*/ else
/*J042*/    update_accum_qty = no.

         assign

/*H0FS*/  /* UPDATE MANUAL PRICE FLAG IN THE sob_det IN CASE IT HAS
             CHANGED */
/*J042** /*H0FS*/ substring(sob_serial,40,1) = string(work3_man_price,"y/n") */

         sob_qty_req = work2_qty_sel
         sob_tot_std = work2_list_price
         sob_price = work2_net_price.

         if work2_qty_sel = 0 then do:
            /*NEW QTY IS ZERO, DELETE CHILDREN RECORDS*/

            temp_id = integer(substr(sob_serial,11,4)).
            new_parent_id = string(temp_id,"9999").

/*J042**    {gprun.i ""sosomtf4.p"" "(input new_parent_id)"}*/
/*J042*/    /*Call sosomtf4.p with additional parameters to support*/
/*J042*/    /*maintenance of accum qty workfiles.                  */
/*J0XR*/    /*Added um_conv to parameters.                         */
/*LB01*/    {gprun.i ""zzsosomtf4.p"" "(input new_parent_id,
                                      input update_accum_qty,
                                      input um,
                                      input um_conv)"}

/*F0CN*     DELETE MRP_DET AS REQUIRED               */

            {mfmrw.i "sob_det" sob_part sob_nbr
            "string(sob_line) + ""-"" + sob_feature" sob_parent
            ? sob_iss_date "0" "DEMAND"
            "客户订单零件" sob_site}

/*J042*/    /*Delete related pricing workfile entries*/
/*J042*/    if update_accum_qty then do:
/*J042*/       for each wkpi_wkfl where wkpi_parent  = parent_id and
/*J042*/                                wkpi_feature = work2_ref and
/*J042*/                                wkpi_option  = work2_comp
/*J042*/                          exclusive-lock:
/*J042*/          delete wkpi_wkfl.
/*J042*/       end.
/*J042*/    end.
            delete sob_det.
         end.
         else
         if prior_qty_sel <> 0 then do:
            /*NEW AND PREVIOUS QTY NONZERO, MULTIPLY CHILDREN QTIES
            BY RATIO OF NEW TO OLD*/

            temp_id = integer(substr(sob_serial,11,4)).
            new_parent_id = string(temp_id,"9999").

/*J042**    {gprun.i ""sosomtf6.p""
**          "(input new_parent_id, input prior_qty_sel, input sob_qty_req)"}
**J042*/
/*J042*/    /*Call sosomtf6.p with additional paramenters to support*/
/*J042*/    /*maintenance of accum qty workfiles.                   */
/*J0XR*/    /*Added um_conv to parameters.                          */
/*LB01*/    {gprun.i ""zzsosomtf6.p"" "(input new_parent_id,
                                      input prior_qty_sel,
                                      input sob_qty_req,
                                      input update_accum_qty,
                                      input um,
                                      input um_conv)"}
         end.
      end.
      else
      if not available sob_det and work2_qty_sel <> 0 then do:
         /*PREVIOUS QTY WAS ZERO AND THE USER ENTERED A NEW QTY:
         THIS MEANS WE NEED TO CREATE A NEW SOB_DET RECORD*/

         due_date = ?.
         from_date = cpex_order_due_date.
         if cpex_order_due_date = ? then from_date = today.

         {mfdate.i due_date from_date "cpex_mfg_lead - work2_lt_off"
         cpex_site}


         cpex_last_id = cpex_last_id + 1.
         new_parent_id = string(cpex_last_id,"9999").


         /*******************************************
         sob_serial subfield positions:
/*G1KC*/ 1-4     operation number (old - now 0's)
         5-10    scrap percent
         11-14   id number of this record
         15-15   structure code
         16-16   "y" (indicates "new" format sob_det record (created herein)
         17-34   original qty per parent
         35-35   original mandatory indicator (y/n)
         36-36   original default indicator (y/n)
         37-39   leadtime offset
/*J042** /*H0FS*/ 40-40   price manually updated (y/n) */
/*G1KC*/ 41-46   operation number (new - 6 digits)
         *******************************************/

         create sob_det.
/*F0LT*/ config_changed = yes.

         assign
         sob_nbr = cpex_prefix + cpex_ordernbr
         sob_line = cpex_orderline
         sob_parent = parent_id
         sob_feature = feature
         sob_part = work2_comp
/*G1KC   sob_serial = string(work3_op,"9999") */
/*G1KC*/ sob_serial = string(0,"9999")
                      + string(work2_scrp_pct,"999.99")
                      + new_parent_id
                      + string(work2_ps_code,"x(1)") + "y"
                      + string(work2_qty_req,"-9999999.999999999")
                      + string(work2_mandatory,"y/n")
                      + string(work2_default,"y/n")
                      + string(work2_lt_off,"-99")
/*J042** /*H0FS*/     + string(work3_man_price,"y/n") */
/*J042*/              + "n"
/*J042** /*G1KC*/     + string(work3_op,"999999") */
/*J042*/              + string(work2_op,"999999")
         sob_iss_date = due_date
         sob_qty_req = work2_qty_sel
         sob_site = cpex_site
         sob_tot_std = work2_list_price
         sob_price = work2_net_price
         .

         find pt_mstr where pt_part = work2_comp no-lock no-error.

         if available pt_mstr then do:
            sob_loc = pt_loc.
         end.


         /*EXPLODE THE COMPONENT IF CONFIGURED*/

/*LB01*/ {gprun.i ""zzsosomtf1.p"" "(input work2_comp, input new_parent_id,
         input work2_qty_sel, input work2_scrp_pct)"}
      end.



      if mandatory and work2_qty_sel = 0 then do:
         find first work2_list where work2_qty_sel <> 0 no-lock no-error.

         if not available work2_list then do:
            {mfmsg.i 635 2}
            message.
            message.
         end.
      end.
   end.
   else
   if keyfunction(lastkey) = "GO" then do trans:
      /*DO IT ALL OVER AGAIN IF ITEM IS CONFIGURED*/

      find work2_list where recid(work2_list) = recidarray[frame-line(w)].

      if work2_qty_sel <> 0 then do:
         find sob_det where sob_nbr = cpex_prefix + cpex_ordernbr
         and sob_line = cpex_orderline
         and sob_parent = parent_id
         and sob_feature = feature
         and sob_part = work2_comp
         no-lock.

         hide frame w no-pause.
         new_parent_id = substr(sob_serial,11,4).

/*LB01*/ {gprun.i ""zzsosomtf2.p""
         "(input sob_part, input new_parent_id, input sob_qty_req,
         input work2_scrp_pct)"}

         if keyfunction(lastkey) = "END-ERROR"
         or keyfunction(lastkey) = "GO"
         then leave mainloop.

         view frame w.
      end.
      else do:
         leave mainloop.
      end.
   end.
   else
/*F0DH*   if lastkey = keycode("ESC-A") or lastkey = keycode("CTRL-A") */
/*F0DH*/ if keyfunction(lastkey) = "HELP"
   then do trans:
/*F0DH*/ if lastkey = keycode ("CTRL-F") then do:
/*F0DH*/    message "字段名称是 work2_comp。".
/*F0DH*/    hide message.
/*F0DH*/ end.
/*F0DH*/ else do:
      window_row = 12.
      window_down = 6.
      {gprun.i ""swpart.p""}

      if global_recid <> ? then do:
         find pt_mstr where recid(pt_mstr) = global_recid no-lock.
         find first work2_list where work2_comp = pt_part no-error.

         if available work2_list then do
         on error undo, leave on endkey undo, leave:
            {mfmsg.i 7430 2}
            message.
            message.
         end.
         else do:
            /*FIGURE WHERE TO ADD IT IN SINCE PROGRESS MUST USE A LINKED LIST*/

            find last work2_list where work2_comp < pt_part no-error.
            if not available work2_list then do:
               find first work2_list.
               find prev work2_list no-error.
            end.

            create work2_list.

            assign
            work2_comp = pt_part
            work2_ps_code = "o"
            work2_list_price = pt_price * cpex_ex_rate
            work2_net_price = pt_price * cpex_ex_rate
/*J0N2*/    work2_disc_pct  = if factor then 1
/*J0N2*/                      else 0.
/*J042**
** /*G1KP*/    work3_qty_req = 1
** /*G1KP*/    work3_recno = recid(work3_list)
**J042*/
            .

/*J042**
** /*G1KP*/    {gprun.i ""gppccala.p"" "(input work3_comp,
**                                       input work3_recno,
**                                       input sob_recno)"}
**J042*/

            /*REDRAW THE SCREEN*/

            do with frame w:
               clear frame w all no-pause.
               ixlastline = 0.

               repeat while available work2_list with frame w:
                  ixlastline = ixlastline + 1.
                  ix1array[ixlastline] = work2_comp.
                  recidarray[ixlastline] = recid(work2_list).

/*J1RY              disp  */
/*J1RY*/          display
                  work2_default
                  work2_comp
                  work2_qty_req
                  work2_qty_sel
                  work2_list_price     when (work2_ps_code = "o")
                  work2_disc_pct       when (work2_ps_code = "o")
                  work2_net_price      when (work2_ps_code = "o")
                  .

                  if frame-line = frame-down then leave.
                  find next work2_list no-error.

                  if available work2_list then down 1.
               end.

               up ixlastline - 1.
               partial_ixval = substr(ix1array[1] + spcs,1,partial_ixlen).
               partial_ixval = "".
               partial_ixlen = 0.
            end.
         end.
      end.
/*F0DH*/ end.
   end.


/*F0JN* Begin windo1u1.i *****************************************F0JN*/
       {windo1u1.i
       work2_comp
       "
       find pt_mstr where pt_part = ix1array[frame-line(w)]
          no-lock no-error.
       if available pt_mstr then message pt_desc1.
       "
       }
/*F0JN* End windo1u1.i********************************************F0JN*/
end.


hide frame w no-pause.

pause before-hide.
