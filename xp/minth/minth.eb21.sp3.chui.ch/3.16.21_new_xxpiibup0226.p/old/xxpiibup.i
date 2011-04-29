/* piibup.i - INVENTORY BALANCE UPDATE INCLUDE FILE                           */
/* Copyright 1986-2005 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.7.1.23.1.1 $                                                  */
/* REVISION: 6.0      LAST MODIFIED: 03/06/90   BY: WUG *D015*                */
/* REVISION: 6.0      LAST MODIFIED: 04/23/91   BY: WUG *D574*                */
/* REVISION: 6.0      LAST MODIFIED: 04/23/91   BY: WUG *D589*                */
/* REVISION: 7.0      LAST MODIFIED: 09/25/91   BY: pma *F003*                */
/* REVISION: 7.0      LAST MODIFIED: 11/11/91   BY: WUG *D887*                */
/* REVISION: 7.0      LAST MODIFIED: 02/07/92   BY: WUG *F182*                */
/* REVISION: 6.0      LAST MODIFIED: 03/05/92   BY: WUG *F254*                */
/* REVISION: 6.0      LAST MODIFIED: 07/31/92   BY: WUG *F824*                */
/* REVISION: 7.3      LAST MODIFIED: 12/01/93   BY: ais *GH64*                */
/* REVISION: 7.3      LAST MODIFIED: 12/23/93   BY: ais *GI30*                */
/* REVISION: 7.3      LAST MODIFIED: 11/07/94   BY: ais *FT46*                */
/* REVISION: 7.3      LAST MODIFIED: 12/28/94   BY: pxd *F0BX*                */
/* REVISION: 7.3      LAST MODIFIED: 01/18/95   BY: jxz *FT13*                */
/* REVISION: 7.3      LAST MODIFIED: 02/02/95   BY: pxd *F0GV*                */
/* REVISION: 8.5      LAST MODIFIED: 08/11/95   BY: sxb *J053*                */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 05/09/98   BY: *L00Y* Jeff Wootton       */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Paul Johnson       */
/* REVISION: 9.1      LAST MODIFIED: 08/02/99   BY: *N01B* Mugdha Tambe       */
/* REVISION: 9.1      LAST MODIFIED: 07/20/00   BY: *N0GF* Mudit Mehta        */
/* REVISION: 9.1      LAST MODIFIED: 08/10/00   BY: *M0R0* Vandna Rohira      */
/* REVISION: 9.1      LAST MODIFIED: 08/23/00   BY: *N0ND* Mark Brown         */
/* REVISION: 9.0      LAST MODIFIED: 04/02/01   BY: *M146* Vinod Kumar        */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.7.1.10     BY: Ellen Borden      DATE: 10/30/01  ECO: *P00G*   */
/* Revision: 1.7.1.11     BY: Robin McCarthy    DATE: 04/05/02  ECO: *P000*   */
/* Revision: 1.7.1.15     BY: Steve Nugent      DATE: 06/06/02  ECO: *P07Y*   */
/* Revision: 1.7.1.16     BY: Ashish Maheshwari DATE: 09/19/02  ECO: *N1V8*   */
/* Revision: 1.7.1.17     BY: Vandna Rohira      DATE: 03/26/03 ECO: *N2BJ*   */
/* Revision: 1.7.1.19     BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00J*   */
/* Revision: 1.7.1.20     BY: Rajiv Ramaiah      DATE: 08/05/03 ECO: *P0WC*   */
/* Revision: 1.7.1.21     BY: Deepak Rao         DATE: 01/21/04 ECO: *P1KB*   */
/* Revision: 1.7.1.22     BY: Veena Lad         DATE: 02/19/04  ECO: *P1PN*   */
/* Revision: 1.7.1.23     BY: Somesh Jeswani    DATE: 06/14/04  ECO: *P25V*   */
/* $Revision: 1.7.1.23.1.1 $           BY: Tejasvi Kulkarni  DATE: 07/06/05  ECO: *P3RY*   */


/* SS - 100226.1  By: Roger Xiao */ /*修改前版本mage:091230.1,修改内容见xxpiibup.i,修改原因call:SS-547 */
/*-Revision end---------------------------------------------------------------*/

/*V8:ConvertMode=Maintenance                                                  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*
     {1} = "break by" sequence
     {2} = lowest breakby field just above tag number
*/

{mfdeclre.i}
{gplabel.i}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE piibup_i_1 "QOH Variance"
/* MaxLen: Comment: */

&SCOPED-DEFINE piibup_i_3 "Item/Site"
/* MaxLen: Comment: */

&SCOPED-DEFINE piibup_i_4 "Sort by Item or Site"
/* MaxLen: Comment: */

/* OBSOLETED PREPROCESSOR , LABEL ALREADY DEFINED IN MAIN PROCEDURE */

&SCOPED-DEFINE piibup_i_6 "Variance Amt"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

&SCOPED-DEFINE simulation true
   /* PREPROCESSOR USED FOR REPORT'S WITH SIMULATION OPTION */

   &SCOPED-DEFINE edi_count_desc "EDI-846-Cycle-Count"

   define input-output parameter l_inv_advno_lst as character no-undo.

define shared variable site            like si_site.
define shared variable site1           like si_site label {t001.i}.
define shared variable loc             like loc_loc.
define shared variable loc1            like loc_loc label {t001.i}.
define shared variable line            like pl_prod_line.
define shared variable line1           like pl_prod_line
   label {t001.i}.
define shared variable part            like pt_part.
define shared variable part1           like pt_part label {t001.i}.
define shared variable abc             like pt_abc.
define shared variable abc1            like pt_abc  label {t001.i}.
define shared variable sortbypart      like mfc_logical
   format {&piibup_i_3}
   label {&piibup_i_4}.

/* VARIABLE NAME CHANGED FROM UPDATE_INV to UPDATE_YN TO MAINTAIN  */
/* THE CONSISTENCY BETWEEN REPORTS WITH SIMULATION OPTION          */

define shared variable update_yn      like mfc_logical no-undo.

define shared variable eff_date        like glt_effdate.
define shared variable yn              like mfc_logical.
define shared variable todays_date     as   date.
define variable sum_issqty              like tag_cnt_qty.
define variable iss_qty                 like tag_cnt_qty.
define variable count_qty               like tag_cnt_qty.
define variable qty_var                 like ld_qty_oh
   column-label {&piibup_i_1}.
define variable amt_var                 as   decimal decimals 2
   format "->>>,>>>,>>9.99"
   label {&piibup_i_6}.
define variable frz_qty                 like ld_qty_frz.
define variable linecnt                 as   integer.
define variable ref                     like glt_ref.
define buffer ptmstr                    for  pt_mstr.
define buffer plmstr                    for  pl_mstr.
define buffer tagmstr                   for  tag_mstr.
define buffer inmstr                    for  in_mstr.
define variable prcss                   like mfc_logical.
define variable acctno                  like in_gl_set.
define variable tagnbr                  like tr_lot.
define variable gl_tmp_amt              as   decimal   no-undo.
define variable l_tmp_filename          as   character no-undo.
define temp-table tt_tag_mstr
   field tt_inv_advno as character
   index tt_tag_idx as unique tt_inv_advno.

/*CUSTOMER CONSIGNMENT VARIABLES*/
{socnvars.i}
define variable consigned_line             like mfc_logical  no-undo.
define variable consigned_qty_oh           like ld_qty_oh    no-undo.
define variable consigned_tag_qty          like ld_qty_oh    no-undo.
define variable unconsigned_qty            like ld_qty_oh    no-undo.
define variable procid                     as character      no-undo.
define variable hold_trnbr                 like tr_trnbr     no-undo.
define variable hold_qtyreq                like ld_qty_oh    no-undo.
define variable hold_countqty              like ld_qty_oh    no-undo.

/* SUPPLIER CONSIGNMENT VARIABLES */
define variable ENABLE_SUPPLIER_CONSIGNMENT
       as character initial "enable_supplier_consignment"    no-undo.
define variable SUPPLIER_CONSIGN_CTRL_TABLE
       as character initial "cns_ctrl"                       no-undo.
define variable using_supplier_consignment as logical        no-undo.
define variable supp_consign_tag_qty       like ld_qty_oh    no-undo.
define variable io_batch                   like cnsu_batch   no-undo.
/*minth*/ define  shared variable crtdate          as date label "标签产生日期".
/*minth*/ define  shared variable crtdate1          as date label "TO".  
/*minth*/ define  shared variable startdate         as date label "财务周期开始日".
/*minth*/ define  shared variable enddate           as date label "TO".  
/*minth*/ define    variable iss_qty1           as decimal .   
/*minth*/ define    variable sum_rctwo          as decimal .   
/*minth*/ define    variable tot_rctwo          as decimal .   
/*minth*/ define    variable sum_isswo          as decimal .   
/*minth*/ define    variable sum_short_isswo          as decimal .   
/*minth*/ define  new shared  variable xtitrnbr        as integer.   

 /*minth*/    define temp-table tmp_det 
                     field   tmp_type  as character
                     field   tmp_ps_par like ps_par
                     field   tmp_ps_comp   as  char format "320" 
                     field   tmp_wo_lot  like wo_lot
                     field   tmp_site   like tag_site
                     field   tmp_loc    like tag_loc 
                     field   tmp_rctwo  like   ld_qty_oh 
                     field   tmp_isswo  like   ld_qty_oh 
                     field   tmp_size   like   ld_qty_oh.

{mfphead.i}

/* CHECK TO SEE IF CONSIGNMENT IS ACTIVE */
{gprun.i ""gpmfc01.p""
   "(input ENABLE_CUSTOMER_CONSIGNMENT,
     input 10,
     input ADG,
     input CUST_CONSIGN_CTRL_TABLE,
     output using_cust_consignment)"}

/* DETERMINE IF SUPPLIER CONSIGNMENT IS ACTIVE */
{gprun.i ""gpmfc01.p""
   "(input ENABLE_SUPPLIER_CONSIGNMENT,
     input 11,
     input ADG,
     input SUPPLIER_CONSIGN_CTRL_TABLE,
     output using_supplier_consignment)"}
/*ss - 090514.1 - b */

for each tmp_det :
  delete tmp_det .
end.
/*ss - 090514.1 - e */
find first gl_ctrl  where gl_ctrl.gl_domain = global_domain no-lock no-error.
for each tagmstr exclusive-lock
    where tagmstr.tag_domain = global_domain and  tag_cnt_dt <> ? and not
    tag_void and not tag_posted
   and tag_site   >= site and tag_site <= site1
   and tag_loc    >= loc  and tag_loc  <= loc1
   and tag_part   >= part and tag_part <= part1
        and tag_crt_dt >= crtdate and tag_crt_dt <= crtdate1,  /*minth*/
   each ptmstr exclusive-lock
    where ptmstr.pt_domain = global_domain and  pt_part      = tag_part
   and pt_prod_line >= line and pt_prod_line <= line1,
   each plmstr no-lock
    where plmstr.pl_domain = global_domain and  pl_prod_line = pt_prod_line
   {1}

   with frame f-a width 132:
   setFrameLabels(frame f-a:handle).
 
   find inmstr exclusive-lock
       where inmstr.in_domain = global_domain and  in_part = tag_part and
       in_site = tag_site no-error.
   if available inmstr
   then
      if in_abc >= abc and in_abc <= abc1
      then
         prcss = yes.
      else
         prcss = no.
   else
      if pt_abc >= abc
         and pt_abc <= abc1
      then
         prcss = yes.
      else
         prcss = no.

/*ss - 090514.1 - b */
  find first wc_mstr no-lock where wc_domain = global_domain and wc_wkctr = tag_loc no-error .

 if available wc_mstr  and prcss  and update_yn and (pt__chr03 = "dd" or pt__chr04 = "fc") then  do:  
/*ss - 090825.1 - b*
/*ss - 090625 暂时去掉工作中心盘点差异自动回冲功能 */  if available wc_mstr  and prcss  and update_yn and pt__chr03 = "dd" then   
 *ss - 090825.1 - e*/

  if  pt__chr03 = "dd" then do:
  /*电镀材料回冲******************************/
      if tag_rcnt_dt <> ?
      then
         count_qty = tag_rcnt_qty * tag_rcnt_cnv.
      else
         count_qty = tag_cnt_qty * tag_cnt_cnv.
      
/* SS - 100226.1 - B 
      message tag_part tag_loc count_qty  view-as alert-box.
   SS - 100226.1 - E */

         frz_qty = 0.
         find ld_det
             where ld_det.ld_domain = global_domain and  ld_site = tag_site
            and    ld_loc = tag_loc
            and    ld_part = tag_part
            and    ld_lot = tag_serial
            and    ld_ref  = tag_ref
            exclusive-lock no-error.

         if available ld_det
            and ld_date_frz <> ?
          then
            frz_qty = ld_qty_frz.

            qty_var =  count_qty  - frz_qty .
            if qty_var <> 0 then do:
 
        for each ps_mstr where ps_domain = global_domain and ps_comp = tag_part 
                   and (ps_start  <= eff_date - 20 or ps_start = ? ) and (ps_end  >= eff_date or ps_end = ? ) no-lock: 

                find first tmp_det where tmp_type = "1" and tmp_ps_par = ps_par and tmp_site = tag_site and tmp_loc = tag_loc 
                no-error.
                if not available tmp_det  then do:

                   for each ln_mstr no-lock where ln_domain = global_domain 
                                  and (ln__chr03 = tag_loc or (ln__chr03 = "" and ln_line = tag_loc)),
                        each wo_mstr no-lock where  wo_domain = global_domain  and wo_part = ps_par 
                                  and wo_type = "c" and wo_rel_date >= startdate and wo_due_date <= enddate 
                                  and wo_line = ln_line  ,
                        each tr_hist no-lock where tr_domain = global_domain and tr_nbr = wo_nbr and  tr_lot = wo_lot and tr_part = ps_par
                                  and tr_effdate >= startdate and tr_effdate <= enddate  and tr_type = "rct-wo" :
                        find tmp_det where tmp_type = "1" and tmp_ps_par = ps_par and tmp_site = tag_site and tmp_loc = tag_loc 
                                  and tmp_wo_lot = wo_lot  no-error.
                        if not available tmp_det then do:
                            create tmp_det .
                            assign tmp_type = "1" 
                                tmp_ps_par = ps_par
                                tmp_site   = tag_site
                                tmp_loc    = tag_loc
                                tmp_wo_lot = wo_lot.
                            find first bom_mstr no-lock where bom_parent = ps_par  no-error .
                            if available bom_mstr then tmp_size = bom__dec01  .
                            else tmp_size = 1.
 
                            if index(tmp_ps_comp, tag_part) < 1  then tmp_ps_comp = tmp_ps_comp + ";"  + tag_part . 
                        end.
                        tmp_rctwo  = tmp_rctwo + tr_qty_loc .
                     
                      end. /*for each ln_mstr */
                end. /*if not available  */
                /* SS - 100226.1 - B */
                else do:
                    /*可能其他tag_part 也用于了同一个ps_par,已经产生过tmp_det记录*/
                    for each tmp_det where tmp_type = "1" and tmp_ps_par = ps_par  and tmp_site = tag_site and tmp_loc = tag_loc :
                        if index(tmp_ps_comp, tag_part) < 1  then tmp_ps_comp = tmp_ps_comp + ";"  + tag_part . 
                    end.
                end.
                /* SS - 100226.1 - E */
        end. /*for each ps_mstr where*/

 /*
for each tmp_det no-lock :
message "tmp_det"  
tmp_type   
tmp_ps_par 
tmp_ps_comp
tmp_site   
tmp_loc    
tmp_wo_lot 
tmp_size   
tmp_isswo
tmp_rctwo
view-as alert-box .
end.
 
  */               

 
                 sum_rctwo = 0.
               for each tmp_det no-lock where tmp_type = "1" and index(tmp_ps_comp, tag_part) >= 1  and tmp_site = tag_site and tmp_loc = tag_loc :
                   sum_rctwo = sum_rctwo + tmp_size * tmp_rctwo .
 
               end.  /*for each tmp_det  */ 

  

               if sum_rctwo <> 0 then 
               for each tmp_det no-lock where  tmp_type = "1" and index(tmp_ps_comp, tag_part) >= 1  and tmp_site = tag_site 
                   and tmp_loc = tag_loc  and tmp_size <> 0 and   tmp_rctwo <> 0 :
                   for first wo_mstr
                       fields (wo_domain  wo_line wo_lot   wo_nbr wo_part   wo_site  )
                      where   wo_domain = global_domain and wo_lot = tmp_wo_lot and wo_site = tag_site and  wo_part = tmp_ps_par 
                              and wo_rel_date >= startdate and wo_due_date <= enddate                        
                       no-lock: end.
                  if available wo_mstr then 
                   {gprun.i ""xxdisrlis1.p""
                     "(input tmp_wo_lot   ,
                       input eff_date ,
                       input tag_part ,
                       input - qty_var * tmp_size * tmp_rctwo / sum_rctwo ,
                       input tag_loc )"}
		       else do:
		         message "找不到物料:" tag_part "的产品" tmp_ps_par "生产线" tag_loc "对应累计加工单"  view-as alert-box .
                         next .
			 end.
 /*ss - 090629.1 - b*/
                  find  first xti_hist where   xti_domain = global_domain 
		            and xti_site = tmp_site
			    and xti_loc  = tmp_loc
			    and xti_tag_nbr  = tag_nbr
			    and xti_part = tag_part
                            and xti_ps_par = wo_part
			    and xti_wo_lot    = wo_lot no-error. .
		  if not available xti_hist then do:
		     create xti_hist .
		     assign xti_domain = global_domain 
		            xti_site = tmp_site
			    xti_loc  = tmp_loc
			    xti_tag_nbr  = tag_nbr
			    xti_part = tag_part
                            xti_ps_par = wo_part
			    xti_wo_lot    = wo_lot
			    xti_lot  = tag_serial
			    xti_ref  = tag_ref
			    xti_size = tmp_size
			   
			    xti_in_qty = tmp_rctwo
			    xti_tag_iss_qty = - qty_var * tmp_size * tmp_rctwo / sum_rctwo
			    xti_iss_qty = 0
			    xti_adj_iss_qty = 0			    
			    xti_effdate  = eff_date .
			   assign  xti_date     = today			    
			    xti_qty_diff = qty_var.

			    xti_trnbr    = xtitrnbr.

			     xti__chr[1]  = "tag dd".

		  end.
		   else assign xti_lot  = tag_serial
			    xti_ref  = tag_ref
			    xti_size = tmp_size
			    xti_in_qty = tmp_rctwo
			    xti_tag_iss_qty = - qty_var * tmp_size * tmp_rctwo / sum_rctwo
			    xti_iss_qty = 0
			    xti_adj_iss_qty = 0			    
			    xti_effdate  = eff_date
			    xti_date     = today			    
			    xti_qty_diff = qty_var 

			   xti_trnbr    = xtitrnbr 

			     xti__chr[1]  = "tag dd".

 /*ss - 090629.1 - e*/
        if prcss
              then if update_yn
              then DO:
               tag_post = yes.
               if available ld_det then
               assign
                 ld_cnt_date = eff_date
                 ld_qty_frz  = 0.
               END.

               end.  /*for each tmp_det  */ 
               else do:
                 message  tag_nbr tag_part  qty_var   skip(0) "累计入库数量为零，不能自动回冲差异, 请手工回冲差异" view-as alert-box .
               
	       end.
                        
            end.  /*if qty_var <> 0 */
	    else 
	    if prcss
            then if update_yn
         then DO:
            tag_post = yes.
            if available ld_det then
            assign
               ld_cnt_date = eff_date
               ld_qty_frz  = 0.
         END.

          

  end. /*  pt__chr03 = "dt" then do:*/
  else if  pt__chr04 = "fc"  then do:
  /*工作中心仓库*/
      if tag_rcnt_dt <> ?
      then
         count_qty = tag_rcnt_qty * tag_rcnt_cnv.
      else
         count_qty = tag_cnt_qty * tag_cnt_cnv.
      
      
         frz_qty = 0.
         find ld_det
             where ld_det.ld_domain = global_domain and  ld_site = tag_site
            and    ld_loc = tag_loc
            and    ld_part = tag_part
            and    ld_lot = tag_serial
            and    ld_ref  = tag_ref
            exclusive-lock no-error.

         if available ld_det
            and ld_date_frz <> ?
          then
            frz_qty = ld_qty_frz.

            qty_var =  count_qty  - frz_qty .
	    sum_issqty = qty_var.
            if qty_var <> 0 then do:
                for each wod_det no-lock where wod_domain = global_domain and wod_part = tag_part ,
                    each wo_mstr no-lock where  wo_domain = global_domain and wo_lot = wod_lot 
                            and wo_type = "c" and wo_rel_date >= startdate and wo_due_date <= enddate ,
                    each ln_mstr no-lock where ln_domain = global_domain  and ln_line = wo_line 
                         and (ln__chr03 = tag_loc or ( ln__chr03 = "" and ln_line = tag_loc)):


                    for each tr_hist no-lock where tr_domain = global_domain and tr_nbr = wo_nbr 
                         and tr_lot = wo_lot and tr_part = wo_part
                         and tr_effdate >= startdate and tr_effdate <= enddate  and tr_type = "rct-wo" :

                    find tmp_det where tmp_type = "2" and tmp_ps_par = wo_part and tmp_ps_comp = tag_part
                       and tmp_site = tag_site and tmp_loc = tag_loc 
                       and tmp_wo_lot = wo_lot    no-error.
                     if not available tmp_det then do:
                      create tmp_det .
                      assign tmp_type = "2" 
                             tmp_ps_par = wo_part
                             tmp_ps_comp = tag_part
                             tmp_site   = tag_site
                             tmp_loc    = tag_loc
                             tmp_wo_lot = wo_lot
                             tmp_size = wod_bom_qty.
                      end.
                     tmp_rctwo  = tmp_rctwo + tr_qty_loc .

                     
                      end. /*for each tr_hist */
/*ss - 090917.1 - b* 不考虑发料多少************************
                    for each tr_hist no-lock where tr_domain = global_domain and tr_nbr = wo_nbr 
                         and tr_lot = wo_lot and tr_part = tag_part
                         and tr_effdate >= startdate and tr_effdate <= enddate  and tr_type = "iss-wo" :
                     
                    find tmp_det where tmp_type = "2" and tmp_ps_par = wo_part and tmp_ps_comp = tag_part
                       and tmp_site = tag_site and tmp_loc = tag_loc 
                       and tmp_wo_lot = wo_lot    no-error.
                     if not available tmp_det then do:
                      create tmp_det .
                      assign tmp_type    = "2" 
                             tmp_ps_par  = wo_part
                             tmp_ps_comp = tag_part
                             tmp_site   = tag_site
                             tmp_loc    = tag_loc
                             tmp_wo_lot = wo_lot
                             tmp_size   = wod_bom_qty.
                      end.
                     tmp_isswo  = tmp_isswo + tr_qty_loc .

                     
                      end. /*for each tr_hist */
*ss - 090917.1 - e* 不考虑发料多少************************/

              end. /*for each wod_det no-lock where wod_domain = global_domain and wod_part = tag_part*/

 
                   sum_rctwo = 0 .
                   sum_isswo = 0.
                   sum_short_isswo = 0 .
 
               for each tmp_det no-lock where tmp_type = "2" and  tmp_ps_comp = tag_part   and tmp_site = tag_site and tmp_loc = tag_loc :
                   sum_rctwo = sum_rctwo + tmp_size * tmp_rctwo .
/*ss - 090917.1 - b* 不考虑发料多少************************
                   sum_isswo = sum_isswo + tmp_isswo.
                   if tmp_rctwo * tmp_size + tmp_isswo  > 0 then sum_short_isswo = sum_short_isswo + tmp_rctwo * tmp_size + tmp_isswo .
*ss - 090917.1 - e* 不考虑发料多少************************/
                   
    /*                 display tmp_type     
			     tmp_ps_par  
			     tmp_ps_comp 
			     tmp_site    
			     tmp_loc     
			     tmp_wo_lot  
			     tmp_size
			     tmp_rctwo.   

*/


               end.  /*for each tmp_det  */ 
/*
for each tmp_det :
message "tmp_det" 
tmp_type   
tmp_ps_par 
tmp_ps_comp
tmp_site   
tmp_loc    
tmp_wo_lot 
tmp_size   
tmp_isswo
tmp_rctwo
view-as alert-box .
end.
message "test001" sum_short_isswo sum_isswo  sum_rctwo view-as alert-box .
*/
/*ss - 090917.1 - b* 不考虑发料多少************************
               if   ( sum_short_isswo - sum_isswo)   <> 0 then 
               for each tmp_det no-lock where  tmp_type = "2" and  tmp_ps_comp = tag_part and tmp_site = tag_site 
                   and tmp_loc = tag_loc  and tmp_size <> 0 and   tmp_rctwo <> 0  break by tmp_ps_comp by tmp_wo_lot:

                   if last-of(tmp_ps_comp) then do:                        
                      if  tmp_rctwo * tmp_size + tmp_isswo > 0 then do:
		         if pt_um = "EA" then do:
                            iss_qty =  - sum_issqty.
                         end.  /*if pt_um = "EA"*/
		         else do:
                          iss_qty =  - sum_issqty.

                         end.  /*else do:*/ 
                     end. /*tmp_rctwo * tmp_size + tmp_isswo > 0 then do:*/
		     else do: 
                       if pt_um = "EA" then do:
                          iss_qty = - sum_issqty.
                       end.  /*if pt_um = "EA"*/
		       else do:
                          iss_qty = - sum_issqty.
                       end.  /*else do:*/ 
		     end. /*else do:   if tmp_rctwo * tmp_size + tmp_isswo > 0 then do */ 
		    end. /*if last-of(tmp_ps_comp) then do:*/
		    else do:
                       if  tmp_rctwo * tmp_size + tmp_isswo > 0 then do:
		          if pt_um = "EA" then do:
			     iss_qty =  truncate(- (( qty_var + sum_short_isswo ) * ( tmp_rctwo * tmp_size  ) / ( sum_short_isswo - sum_isswo)  - (tmp_rctwo * tmp_size + tmp_isswo )), 0).
                             sum_issqty = sum_issqty + iss_qty.                          
			  end.  /*if pt_um = "EA"*/
		          else do:
                             iss_qty =  - (( qty_var + sum_short_isswo ) * ( tmp_rctwo * tmp_size  ) / ( sum_short_isswo - sum_isswo)  - (tmp_rctwo * tmp_size + tmp_isswo )).
                             sum_issqty = sum_issqty + iss_qty.
                          end.  /*else do:*/ 
                      end.
		      else do: 
                       if pt_um = "EA" then do:
                          iss_qty =  truncate( - ( ( qty_var + sum_short_isswo ) * ( - tmp_isswo) / ( sum_short_isswo - sum_isswo)), 0).
                          sum_issqty = sum_issqty + iss_qty.                          
		       end.  /*if pt_um = "EA"*/
		       else do:
                          iss_qty = - ( ( qty_var + sum_short_isswo ) * ( - tmp_isswo) / ( sum_short_isswo - sum_isswo)) .
                          sum_issqty = sum_issqty + iss_qty.                      
		       end.  /*else do:*/ 
	              end. /*else do:   tmp_rctwo * tmp_size + tmp_isswo > 0 then do */
		    end. /*else do:  if last-of(tmp_ps_comp) then */

                   {gprun.i ""xxdisrlis1.p""
                       "(input tmp_wo_lot   ,
                        input eff_date    ,
                        input tag_part,
                        input  iss_qty,
                        input tag_loc )"}
			
 /*ss - 090629.1 - b*/
                  find  first xti_hist where   xti_domain = global_domain 
		            and xti_site = tmp_site
			    and xti_loc  = tmp_loc
			    and xti_tag_nbr  = tag_nbr
			    and xti_part = tag_part
                            and xti_ps_par = tmp_ps_par
			    and xti_wo_lot    = tmp_wo_lot no-error.
		  if not available xti_hist then do:
		     create xti_hist .
		     assign xti_domain = global_domain 
		            xti_site = tmp_site
			    xti_loc  = tmp_loc
			    xti_tag_nbr  = tag_nbr
			    xti_part = tag_part
                            xti_ps_par = tmp_ps_par
			    xti_wo_lot    = tmp_wo_lot
			    xti_lot  = tag_serial
			    xti_ref  = tag_ref
			    xti__dec[1] = tmp_size
			    xti_in_qty = tmp_rctwo
			    xti_tag_iss_qty = iss_qty
			    xti_iss_qty = tmp_isswo
			    xti_adj_iss_qty =  tmp_rctwo * tmp_size + tmp_isswo			    
			    xti_effdate  = eff_date
			    xti_date     = today			    
			    xti_qty_diff = qty_var
			    xti_trnbr    = xtitrnbr
			    xti__chr[1]  = "tag adj".

		  end.
		   else assign xti_lot  = tag_serial
			    xti_ref  = tag_ref
			    xti__dec[1] = tmp_size
			    xti_in_qty = tmp_rctwo
			    xti_tag_iss_qty =  iss_qty
			    xti_iss_qty = tmp_isswo
			    xti_adj_iss_qty = tmp_rctwo * tmp_size + tmp_isswo				    
			    xti_effdate  = eff_date
			    xti_date     = today			    
			    xti_qty_diff = qty_var
			    xti_trnbr    = xtitrnbr
			    xti__chr[1]  = "tag adj".
                
/*del************************************************************************************************

		    else do: 
                       if pt_um = "EA" then do:

		       {gprun.i ""xxdisrlis1.p""
                       "(input tmp_wo_lot   ,
                       input eff_date    ,
                        input tag_part,
                       input - ( ( qty_var - sum_short_isswo ) * ( - tmp_isswo) / ( sum_short_isswo - sum_isswo))   ,
                       input tag_loc )"}
  /*ss - 090629.1 - b*/
                  find  first xti_hist where   xti_domain = global_domain 
		            and xti_site = tmp_site
			    and xti_loc  = tmp_loc
			    and xti_tag_nbr  = tag_nbr
			    and xti_part = tag_part
                            and xti_ps_par = tmp_ps_par
			    and xti_wo_lot    = tmp_wo_lot no-error. 
		  if not available xti_hist then do:
		     create xti_hist .
		     assign xti_domain = global_domain 
		            xti_site = tmp_site
			    xti_loc  = tmp_loc
			    xti_tag_nbr  = tag_nbr
			    xti_part = tag_part
                            xti_ps_par = tmp_ps_par
			    xti_wo_lot    = tmp_wo_lot
			    xti_lot  = tag_serial
			    xti_ref  = tag_ref
			    xti__dec[1] = tmp_size
			    xti_in_qty = tmp_rctwo
			    xti_tag_iss_qty = - ( ( qty_var + sum_short_isswo ) * ( - tmp_isswo) / ( sum_short_isswo - sum_isswo))
			    xti_iss_qty = tmp_isswo
			    xti_adj_iss_qty = 0			    
			    xti_effdate  = eff_date
			    xti_date     = today			    
			    xti_qty_diff = qty_var
			    xti_trnbr    = xtitrnbr
			     xti__chr[1]  = "tag adj".

		  end.
		   else assign xti_lot  = tag_serial
			    xti_ref  = tag_ref
			    xti__dec[1] = tmp_size
			    xti_in_qty = tmp_rctwo
			    xti_tag_iss_qty = - ( ( qty_var + sum_short_isswo ) * ( - tmp_isswo) / ( sum_short_isswo - sum_isswo))
			    xti_iss_qty = tmp_isswo
			    xti_adj_iss_qty = 0			    
			    xti_effdate  = eff_date
			    xti_date     = today			    
			    xti_qty_diff = qty_var
			    xti_trnbr    = xtitrnbr 
			    xti__chr[1]  = "tag adj".
                 end.  /*if pt_um = "EA" then do:*/
		 else do:
                     		       {gprun.i ""xxdisrlis1.p""
                       "(input tmp_wo_lot   ,
                       input eff_date    ,
                        input tag_part,
                       input - ( ( qty_var - sum_short_isswo ) * ( - tmp_isswo) / ( sum_short_isswo - sum_isswo))   ,
                       input tag_loc )"}
  /*ss - 090629.1 - b*/
                  find  first xti_hist where   xti_domain = global_domain 
		            and xti_site = tmp_site
			    and xti_loc  = tmp_loc
			    and xti_tag_nbr  = tag_nbr
			    and xti_part = tag_part
                            and xti_ps_par = tmp_ps_par
			    and xti_wo_lot    = tmp_wo_lot no-error. 
		  if not available xti_hist then do:
		     create xti_hist .
		     assign xti_domain = global_domain 
		            xti_site = tmp_site
			    xti_loc  = tmp_loc
			    xti_tag_nbr  = tag_nbr
			    xti_part = tag_part
                            xti_ps_par = tmp_ps_par
			    xti_wo_lot    = tmp_wo_lot
			    xti_lot  = tag_serial
			    xti_ref  = tag_ref
			    xti__dec[1] = tmp_size
			    xti_in_qty = tmp_rctwo
			    xti_tag_iss_qty = - ( ( qty_var + sum_short_isswo ) * ( - tmp_isswo) / ( sum_short_isswo - sum_isswo))
			    xti_iss_qty = tmp_isswo
			    xti_adj_iss_qty = 0			    
			    xti_effdate  = eff_date
			    xti_date     = today			    
			    xti_qty_diff = qty_var
			    xti_trnbr    = xtitrnbr
			     xti__chr[1]  = "tag adj".

		  end.
		   else assign xti_lot  = tag_serial
			    xti_ref  = tag_ref
			    xti__dec[1] = tmp_size
			    xti_in_qty = tmp_rctwo
			    xti_tag_iss_qty = - ( ( qty_var + sum_short_isswo ) * ( - tmp_isswo) / ( sum_short_isswo - sum_isswo))
			    xti_iss_qty = tmp_isswo
			    xti_adj_iss_qty = 0			    
			    xti_effdate  = eff_date
			    xti_date     = today			    
			    xti_qty_diff = qty_var
			    xti_trnbr    = xtitrnbr 
			    xti__chr[1]  = "tag adj".
		 end.   /*else do:*/
*del******************************************************************************/
 /*ss - 090629.1 - e*/
 

        if prcss
              then if update_yn
              then DO:
               tag_post = yes.
               if available ld_det then
               assign
                 ld_cnt_date = eff_date
                 ld_qty_frz  = 0.
              END.
       end.  /*for each tmp_det  */ 
       else do: /* if   ( sum_short_isswo - sum_isswo)   <> 0 then 盘点差异同，与少回冲数量相等 */
   /*              message "累计入库数量为零，不能自动回冲差异, 请手工回冲差异" view-as alert-box . */
          if  tmp_rctwo * tmp_size + tmp_isswo > 0 then do: 
	      iss_qty =   tmp_rctwo * tmp_size + tmp_isswo .

		  {gprun.i ""xxdisrlis1.p""
                       "(input tmp_wo_lot   ,
                        input eff_date    ,
                        input tag_part,
                        input  iss_qty,
                        input tag_loc )"}
			
 /*ss - 090629.1 - b*/
                  find  first xti_hist where   xti_domain = global_domain 
		            and xti_site = tmp_site
			    and xti_loc  = tmp_loc
			    and xti_tag_nbr  = tag_nbr
			    and xti_part = tag_part
                            and xti_ps_par = tmp_ps_par
			    and xti_wo_lot    = tmp_wo_lot no-error.
		  if not available xti_hist then do:
		     create xti_hist .
		     assign xti_domain = global_domain 
		            xti_site = tmp_site
			    xti_loc  = tmp_loc
			    xti_tag_nbr  = tag_nbr
			    xti_part = tag_part
                            xti_ps_par = tmp_ps_par
			    xti_wo_lot    = tmp_wo_lot
			    xti_lot  = tag_serial
			    xti_ref  = tag_ref
			    xti__dec[1] = tmp_size
			    xti_in_qty = tmp_rctwo
			    xti_tag_iss_qty = iss_qty
			    xti_iss_qty = tmp_isswo
			    xti_adj_iss_qty =  tmp_rctwo * tmp_size + tmp_isswo			    
			    xti_effdate  = eff_date
			    xti_date     = today			    
			    xti_qty_diff = qty_var
			    xti_trnbr    = xtitrnbr
			    xti__chr[1]  = "tag adj".

		  end.
		   else assign xti_lot  = tag_serial
			    xti_ref  = tag_ref
			    xti__dec[1] = tmp_size
			    xti_in_qty = tmp_rctwo
			    xti_tag_iss_qty =  iss_qty
			    xti_iss_qty = tmp_isswo
			    xti_adj_iss_qty = tmp_rctwo * tmp_size + tmp_isswo				    
			    xti_effdate  = eff_date
			    xti_date     = today			    
			    xti_qty_diff = qty_var
			    xti_trnbr    = xtitrnbr
			    xti__chr[1]  = "tag adj".
           end. /* if  tmp_rctwo * tmp_size + tmp_isswo > 0 then do: */
           if prcss
              then if update_yn
              then DO:
               tag_post = yes.
               if available ld_det then
               assign
                 ld_cnt_date = eff_date
                 ld_qty_frz  = 0.
           END.
       end.  /*else do: if   ( sum_short_isswo - sum_isswo)   <> 0 then 盘点差异同，与少回冲数量相等 */

*ss - 090917.1 - e* 不考虑发料多少************************/
/*ss - 090917.1 - b* 不考虑发料多少************************/
                for each tmp_det no-lock where  tmp_type = "2" and  tmp_ps_comp = tag_part and tmp_site = tag_site 
                   and tmp_loc = tag_loc  and tmp_size <> 0 and   tmp_rctwo <> 0  break by tmp_ps_comp by tmp_wo_lot:

                   if last-of(tmp_ps_comp) then do:                        
                      
                            iss_qty =  - sum_issqty.
                         
		    end. /*if last-of(tmp_ps_comp) then do:*/
		    else do:
 		          if pt_um = "EA" then do:
			     iss_qty =  truncate(- (( qty_var   ) * ( tmp_rctwo * tmp_size  ) / ( sum_rctwo)), 0).
                             sum_issqty = sum_issqty + iss_qty.                          
			  end.  /*if pt_um = "EA"*/
		          else do:
                             iss_qty =  - qty_var  * ( tmp_rctwo * tmp_size  ) / (sum_rctwo).
                             sum_issqty = sum_issqty + iss_qty.
                          end.  /*else do:*/ 
 		       
		    end. /*else do:  if last-of(tmp_ps_comp) then */

                   {gprun.i ""xxdisrlis1.p""
                       "(input tmp_wo_lot   ,
                        input eff_date    ,
                        input tag_part,
                        input  iss_qty,
                        input tag_loc )"}
			
 /*ss - 090629.1 - b*/
                  find  first xti_hist where   xti_domain = global_domain 
		            and xti_site = tmp_site
			    and xti_loc  = tmp_loc
			    and xti_tag_nbr  = tag_nbr
			    and xti_part = tag_part
                            and xti_ps_par = tmp_ps_par
			    and xti_wo_lot    = tmp_wo_lot no-error.
		  if not available xti_hist then do:
		     create xti_hist .
		     assign xti_domain = global_domain 
		            xti_site = tmp_site
			    xti_loc  = tmp_loc
			    xti_tag_nbr  = tag_nbr
			    xti_part = tag_part
                            xti_ps_par = tmp_ps_par
			    xti_wo_lot    = tmp_wo_lot
			    xti_lot  = tag_serial
			    xti_ref  = tag_ref
			    xti__dec[1] = tmp_size
			    xti_in_qty = tmp_rctwo
			    xti_tag_iss_qty = iss_qty
			    xti_iss_qty = tmp_isswo
			    xti_adj_iss_qty =  0			    
			    xti_effdate  = eff_date
			    xti_date     = today			    
			    xti_qty_diff = qty_var
			    xti_trnbr    = xtitrnbr
			    xti__chr[1]  = "tag adj".

		  end.
		   else assign xti_lot  = tag_serial
			    xti_ref  = tag_ref
			    xti__dec[1] = tmp_size
			    xti_in_qty = tmp_rctwo
			    xti_tag_iss_qty =  iss_qty
			    xti_iss_qty = tmp_isswo
			    xti_adj_iss_qty = 0				    
			    xti_effdate  = eff_date
			    xti_date     = today			    
			    xti_qty_diff = qty_var
			    xti_trnbr    = xtitrnbr
			    xti__chr[1]  = "tag adj".
                


        if prcss
              then if update_yn
              then DO:
               tag_post = yes.
               if available ld_det then
               assign
                 ld_cnt_date = eff_date
                 ld_qty_frz  = 0.
              END.
       end.  /*for each tmp_det  */ 

/*ss - 090917.1 - e* 不考虑发料多少************************/                        
            end.  /*if qty_var <> 0 */
	    else 
          if prcss
            then if update_yn
          then DO:
            tag_post = yes.
            if available ld_det then
            assign
               ld_cnt_date = eff_date
               ld_qty_frz  = 0.
         END.
     end. /*else if tag_loc = "" then do:*/

  
  end.  /* if available wc_mstr  and prcss  and update_yn and (pt__chr03 = "dd" or pt__chr04 = "fc") then  do:  */
  
  else do: /*if available wc_mstr  and process and update then */

/*ss - 090514.1 - b */

   if prcss
   then do:
      glxcst = 0.

      if not available icc_ctrl
      then
         find first icc_ctrl  where icc_ctrl.icc_domain = global_domain no-lock.

      if available inmstr
      then do:
         if inmstr.in_gl_set = ""
         then do:
            find sct_det
                where sct_det.sct_domain = global_domain and  sct_part =
                inmstr.in_part
                 and sct_sim  = icc_gl_set
                 and sct_site = inmstr.in_gl_cost_site
                 no-lock no-error.
         end. /* IF INMSTR.IN_GL_SET = "" */

         else do:
            find sct_det
                where sct_det.sct_domain = global_domain and  sct_part =
                inmstr.in_part
               and    sct_sim = inmstr.in_gl_set
               and    sct_site = inmstr.in_gl_cost_site
               no-lock no-error.
         end. /* ELSE DO */

         if available sct_det
         then
            glxcst = sct_cst_tot.
      end.  /* IF AVAILABLE INMSTR */

      else do:
         find si_mstr
             where si_mstr.si_domain = global_domain and  si_site = tag_site
            no-error.

         if available si_mstr
         then
            if si_gl_set <> ""
            then
               acctno = si_gl_set.
            else
               acctno = icc_gl_set.
         else
            acctno = icc_gl_set.

         find sct_det
             where sct_det.sct_domain = global_domain and  sct_sim  = acctno
            and   sct_part = tag_part
            and   sct_site = si_site no-error.

         if available sct_det
         then
            glxcst = sct_cst_tot.

      end. /* ELSE DO */
   end. /* IF PRCSS THEN DO */

   if first-of({2})
   then
      linecnt = 0.

   if prcss
   then do:
      linecnt = linecnt + 1.
      if linecnt = 1
      then do:
      end.

      if tag_rcnt_dt <> ?
      then
         count_qty = tag_rcnt_qty * tag_rcnt_cnv.
      else
         count_qty = tag_cnt_qty * tag_cnt_cnv.

      accumulate count_qty(total by tagmstr.{2}).

   end. /* IF PRCSS THEN DO */

   if last-of({2})
   then do:

      if prcss
      then do:
         frz_qty = 0.
         find ld_det
             where ld_det.ld_domain = global_domain and  ld_site = tag_site
            and    ld_loc = tag_loc
            and    ld_part = tag_part
            and    ld_lot = tag_serial
            and    ld_ref  = tag_ref
            exclusive-lock no-error.

         if available ld_det
            and ld_date_frz <> ?
         then
            frz_qty = ld_qty_frz.
         assign
            qty_var = (accum total by tagmstr.{2} count_qty) - frz_qty
            amt_var = qty_var * glxcst.

         {gprun.i ""gpcurrnd.p""
            "(input-output amt_var,
              input gl_rnd_mthd)"}
         accumulate amt_var(total).

         display
            tag_site
            tag_loc

            tag_part   /*V8! format "x(24)" */
            tag_serial /*V8! format "x(24)" */
            tag_ref
            pt_um.

         display
            (accum total by tagmstr.{2} count_qty) @ count_qty
            frz_qty
            qty_var
            amt_var.
      end. /* IF PRCSS THEN DO */

      tagnbr = string(tagmstr.tag_nbr, "99999999").

      if prcss
      then do:

         if update_yn
         then do:

           /* RESETTING THE CONSIGNED QUANTITY TO ZERO */
            assign
               consigned_tag_qty    = 0
               supp_consign_tag_qty = 0.

            do for in_mstr, pt_mstr, pl_mstr, tag_mstr:

               hold_countqty = accum total by tagmstr.{2} count_qty.

               /* CUSTOMER CONSIGNMENT */
               if using_cust_consignment
                  and hold_countqty <  frz_qty
               then do:

                  assign
                     consigned_qty_oh = ld_cust_consign_qty
                     unconsigned_qty  = frz_qty - consigned_qty_oh.

                  if unconsigned_qty < (frz_qty - hold_countqty)
                  then do:
                     consigned_tag_qty = (frz_qty - hold_countqty)
                     - unconsigned_qty.
                  end.
               end. /*if using_cust_consignment*/

               /* SUPPLIER CONSIGNMENT */
               if using_supplier_consignment
                  and hold_countqty < frz_qty
               then do:

                  supp_consign_tag_qty = frz_qty - hold_countqty.

               end.

               /* ADDED SECOND EXCHANGE RATE, TYPE, SEQUENCE */
               /* ADDED SUB-ACCOUNTS                         */
               {ictrans.i
                  &addrid=""""
                  &bdnstd=0
                  &cracct="
                    if available pld_det
                    then pld_dscracct
                    else pl_dscr_acct"
                  &crsub="
                    if available pld_det
                    then pld_dscr_sub
                    else pl_dscr_sub"
                  &crcc="
                    if available pld_det
                    then pld_dscr_cc
                    else pl_dscr_cc"
                  &crproj=""""
                  &curr=""""
                  &dracct="
                    if available pld_det
                    then pld_inv_acct
                    else pl_inv_acct"
                  &drsub="
                    if available pld_det
                    then pld_inv_sub
                    else pl_inv_sub"
                  &drcc="
                    if available pld_det
                    then pld_inv_cc
                    else pl_inv_cc"
                  &drproj=""""
                  &effdate=eff_date
                  &exrate=0
                  &exrate2=0
                  &exratetype=""""
                  &exruseq=0
                  &glamt=amt_var
                  &lbrstd=0
                  &line=0
                  &location="tagmstr.tag_loc"
                  &lotnumber=""""
                  &lotref="tagmstr.tag_ref"
                  &lotserial="tagmstr.tag_serial"
                  &mtlstd=0
                  &ordernbr=tagnbr
                  &ovhstd=0
                  &part="tagmstr.tag_part"
                  &perfdate=?
                  &price=glxcst
                  &quantityreq="accum total by tagmstr.{2} count_qty"
                  &quantityshort=0
                  &quantity=qty_var
                  &revision=""""
                  &rmks="tagmstr.tag_rmks"
                  &shiptype=""""
                  &site="tagmstr.tag_site"
                  &slspsn1=""""
                  &slspsn2=""""
                  &sojob=""""
                  &substd=0
                  &transtype=""TAG-CNT""
                  &msg=0
                  &ref_site=tr_site
                  }

               hold_trnbr = tr_hist.tr_trnbr.

               /* BACKOUT THE CONSIGNED PORTION OF THE PHYSICAL COUNT THAT WAS*/
               /* REPORTED.  CREATE A CONSIGNMENT USAGE FOR THAT PORTION*/
               /* THAT IS BACKED OUT.                                   */
               hold_qtyreq = accum total by tagmstr.{2} count_qty.

               if using_cust_consignment
                  and consigned_tag_qty > 0
               then do:

                  {ictrans.i
                     &addrid=""""
                     &bdnstd=0
                     &cracct=" if available pld_det
                               then pld_dscracct
                       else pl_dscr_acct"
                     &crsub=" if available pld_det then pld_dscr_sub
                       else pl_dscr_sub"
                     &crcc=" if available pld_det then pld_dscr_cc
                       else pl_dscr_cc"
                     &crproj=""""
                     &curr=""""
                     &dracct=" if available pld_det then pld_inv_acct
                       else pl_inv_acct"
                     &drsub=" if available pld_det then pld_inv_sub
                       else pl_inv_sub"
                     &drcc=" if available pld_det then pld_inv_cc
                       else pl_inv_cc"
                     &drproj=""""
                     &effdate=eff_date
                     &exrate=0
                     &exrate2=0
                     &exratetype=""""
                     &exruseq=0
                     &glamt="amt_var * -1"
                     &lbrstd=0
                     &line=0
                     &location="tagmstr.tag_loc"
                     &lotnumber=""""
                     &lotref="tagmstr.tag_ref"
                     &lotserial="tagmstr.tag_serial"
                     &mtlstd=0
                     &ordernbr=tagnbr
                     &ovhstd=0
                     &part="tagmstr.tag_part"
                     &perfdate=?
                     &price=glxcst
                     &quantityreq="hold_qtyreq + consigned_tag_qty"
                     &quantityshort=0
                     &quantity=consigned_tag_qty
                     &revision=""""
                     &rmks="tagmstr.tag_rmks"
                     &shiptype=""""
                     &site="tagmstr.tag_site"
                     &slspsn1=""""
                     &slspsn2=""""
                     &sojob=""""
                     &substd=0
                     &transtype=""CN-CNT""
                     &msg=0
                     &ref_site=tr_site
                     }

                  {gprunmo.i
                     &program = "socnuse.p"
                     &module = "ACN"
                     &param = """(input tagmstr.tag_part,
                       input tagmstr.tag_site,
                       input tagmstr.tag_loc,
                       input tagmstr.tag_serial,
                       input tagmstr.tag_ref,
                       input pt_um,
                       input consigned_tag_qty,
                       input 'CN-CNT',
                       input eff_date)"""}

               end. /*if using_cust_consignment*/

               if using_supplier_consignment
                  and supp_consign_tag_qty > 0
               then do:

                  {gprunmo.i
                     &program = ""ictrancn.p""
                     &module  = "ACN"
                     &param   =  """(input tagnbr,
                                     input '',
                                     input 0,
                                     input '',
                                     input supp_consign_tag_qty,
                                     input tagmstr.tag_serial,
                                     input tagmstr.tag_part,
                                     input tagmstr.tag_site,
                                     input tagmstr.tag_loc,
                                     input tagmstr.tag_ref,
                                     input eff_date,
                                     input hold_trnbr,
                                     input FALSE,
                                     input-output io_batch)"""}

               end. /* IF using_supplier_consignment */

            end. /* DO FOR */

            if available ld_det then
            assign
               ld_cnt_date = eff_date
               ld_qty_frz  = 0.

         end.       /*update_yn */
      end.          /*prcss     */
   end.             /*last-of   */

   if prcss
   then

      if update_yn
      then
         tag_post = yes.

   if last({2})
   then do:
      down 2.

      display getTermLabel("GRAND_TOTAL",18) @ tag_part
         accum total amt_var @ amt_var.
   end.

   /* CREATE RECORDS IN QAD WORKFILE FOR EXPORT AND LATER USE */

   /* CHECK TO SEE IF QAD WORK FILE EXISTS FOR THE 'INCOMING'
   "INVENTORY ADVICE NUMBER" AND "PART NUMBER" COMBINATION.
   PLEASE NOTE THAT THE INCOMING INVENTORY ADVICE NUMBER IS
   STORED IN THE TAG REMARKS (TAG_RMKS) FIELDS WITH A "|" PIPE
   LINE DELIMITER.
   */

   /* CHECK THAT REMARKS ACTUALLY HAS THE DELIMITER */
   if index(tag_rmks,"|") > 0
   then do:
      for first qad_wkfl
          where qad_wkfl.qad_domain = global_domain and  qad_wkfl.qad_key1 =
          {&edi_count_desc}
         and qad_wkfl.qad_key2 =
         entry(1,tag_rmks,"|") + "," + tag_part + "," +
         tag_loc exclusive-lock:
      end.

      if not available qad_wkfl
      then do:

         create qad_wkfl. qad_wkfl.qad_domain = global_domain.
         assign
            qad_key1 = {&edi_count_desc}
            qad_key2 = entry(1,tag_rmks,"|") + "," +
                       tag_part + "," + tag_loc
            qad_key3 = {&edi_count_desc}
            qad_key4 = entry(1,tag_rmks,"|").

      end. /* IF NOT AVAILABLE QAD_WKFL THEN */

      /* STORE THE INVENTORY ADVICE NUMBER INTO "TT_TAG_MSTR"
         TEMPORARY TABLE */

      for first tt_tag_mstr
         where tt_inv_advno = entry(1,tag_rmks,"|"):
      end.

      if not available tt_tag_mstr
      then do:

         create tt_tag_mstr.
         tt_inv_advno = entry(1,tag_rmks,"|").

      end. /* IF NOT AVAILABLE TT_TAG_MSTR THEN */

      qad_wkfl.qad_charfld[1] = string(tag_nbr).

   end. /* IF INDEX(tag_rmks,"|") > 0 */

/*ss - 090514.1 - b */
   end.  /*else do: */
/*ss - 090514.1 - b */

end. /* FOR EACH TAGMSTR */

/* CREATE THE LIST OF INVENTORY ADVICE NUMBERS */

l_inv_advno_lst = "".

for first tt_tag_mstr:
   l_inv_advno_lst = l_inv_advno_lst +
                     (if l_inv_advno_lst <> ""
                      then ","
                      else "") + tt_inv_advno.
end.

/* REMOVE THE FILE WE JUST CREATED */

/*ss - 090514.1 - b */

for each tmp_det :
  delete tmp_det .
end.
/*ss - 090514.1 - e */

os-delete value("inv_upd_tmp").

/* EOF */
