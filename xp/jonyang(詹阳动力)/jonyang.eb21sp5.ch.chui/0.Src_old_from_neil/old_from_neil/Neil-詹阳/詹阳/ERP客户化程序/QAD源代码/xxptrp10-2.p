/* GUI CONVERTED from ppptrp08.p (converter v1.66) Fri Nov 10 15:45:11 1995 */
/* xxptrp10.p - INVENTORY DETAIL REPORT BY ITEMS                            */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=FullGUIReport                                 */
/* REVISION: 6.0      LAST MODIFIED: 05/17/90   BY: WUG                 */
/* REVISION: 7.0      LAST MODIFIED: 09/25/91   BY: pma *F003*          */
/* REVISION: 7.0      LAST MODIFIED: 09/30/93   BY: pxd *GG10*          */
/* REVISION: 7.3      LAST MODIFIED: 10/25/95   BY: jym *G1B5*          */
/* REVISION: 7.3      LAST MODIFIED: 09/21/98   BY: jac *INFOPOWER*     */
/* DISPLAY TITLE */

/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdtitle.i "f+ "}    

define variable amt like trgl_gl_amt.
define variable grade like ld_grade.
define variable grade1 like ld_grade.
define variable assay like ld_assay.
define variable assay1 like ld_assay.
define variable stat like ld_status.
define variable stat1 like ld_status.
define variable abc like pt_abc.
define variable abc1 like pt_abc.
define variable site like ld_site.
define variable site1 like ld_site.
define variable part like pt_part.
define variable part1 like pt_part.
define variable line like pt_prod_line.
define variable line1 like pt_prod_line.
define variable eff_date like  tr_effdate initial today.
define variable eff_date1 like tr_effdate initial today.
define variable part_type like  pt_part_type.
define variable part_type1 like pt_part_type.
define variable part_group like  pt_group.
define variable part_group1 like pt_group.
define variable loc like ld_loc.
define variable loc1 like ld_loc.
define variable zeroflag as logical label "抑制零数量/金额" initial yes.
define variable sort_by as logical label "L-库位/I-零件号" format  "L-库位/I-零件号" initial "L-库位".
define variable sort_name1 as character.
define variable sort_name2 as character.

define new shared temp-table tmp 
    field tmp_userid like mfguser
    field tmp_site like in_site 
    field tmp_loc like ld_loc
    field tmp_part like in_part 
    field tmp_prod_line like pt_prod_line
    field tmp_beg_bal  like in_qty_oh format "->>,>>>,>>9.99"
    field tmp_beg_amt  like in_qty_oh format "->>,>>>,>>9.99"
    field tmp_rct_qty like in_qty_oh format "->>,>>>,>>9.99"
    field tmp_rct_amt like in_qty_oh format "->>,>>>,>>9.99"
    field tmp_iss_qty like in_qty_oh format "->>,>>>,>>9.99"
    field tmp_iss_amt like in_qty_oh format "->>,>>>,>>9.99"
    field tmp_cnt_qty like in_qty_oh format "->>,>>>,>>9.99"
    field tmp_cnt_amt like in_qty_oh format "->>,>>>,>>9.99"
    field tmp_cst_qty like in_qty_oh format "->>,>>>,>>9.99"
    field tmp_cst_amt like in_qty_oh format "->>,>>>,>>9.99"
    field tmp_end_bal like in_qty_oh format "->>,>>>,>>9.99"
    field tmp_end_amt like in_qty_oh format "->>,>>>,>>9.99".
    
/* SELECT FORM */

/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
   site           colon 18
   site1          label {t001.i} colon 49
   loc            colon 18
   loc1           label {t001.i} colon 49
   line           colon 18
   line1          label {t001.i} colon 49 skip
   part           colon 18
   part1          label {t001.i} colon 49 skip
   part_type      colon 18
   part_type1     label {t001.i} colon 49 skip
   part_group     colon 18
   part_group1    label {t001.i} colon 49 skip
   eff_date       colon 18
   eff_date1      label {t001.i} colon 49 skip
   abc            colon 18
   abc1           colon 49 label {t001.i} skip
   grade          colon 18 
   grade1         colon 49 label {t001.i} skip
   assay          colon 18
   assay1         colon 49 label {t001.i}
   stat           colon 18
   stat1          colon 49 label {t001.i} skip(1)
   zeroflag       colon 18 skip
   sort_by        colon 18
   with frame a side-labels width 80 attr-space.

   form 
       /* tmp_site*/
        tmp_part column-label "零件号!描述1" 
        tmp_loc column-label "库位!单位" 
      /*  pt_desc1 
        pt_um*/
        tmp_beg_bal column-label "上期结存数量!上期结存金额 " 
        tmp_rct_qty column-label "本期入库数量!本期入库金额"
        tmp_iss_qty column-label "本期出库数量!本期出库金额"
        tmp_cnt_qty column-label "本期盘点损益!盘点损益金额"
        tmp_cst_qty column-label "本期成本变化!成本变化金额"
        tmp_end_bal column-label "本期结存数量!本期结存金额"
   with frame c down width 255 stream-io no-box.

   form 
     /* tmp_site*/
        tmp_part column-label "零件号!描述1" 
        tmp_loc column-label "库位!单位" 
      /*  pt_desc1 
        pt_um*/

        tmp_beg_bal column-label "上期结存数量!上期结存金额 " 
        tmp_rct_qty column-label "本期入库数量!本期入库金额"
        tmp_iss_qty column-label "本期出库数量!本期出库金额"
        tmp_cnt_qty column-label "本期盘点损益!盘点损益金额"
        tmp_cst_qty column-label "本期成本变化!成本变化金额"
        tmp_end_bal column-label "本期结存数量!本期结存金额"
   with frame d down width 255 stream-io no-box.

setFrameLabels(frame a:handle).

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME


repeat:
	
/* REPORT BLOCK */


     if line1 = hi_char then line1 = "".
     if part1 = hi_char then part1 = "".
     if site1 = hi_char then site1 = "".
     if loc1  = hi_char then loc1  = "".
     if abc1 = hi_char then abc1 = "".
     if grade1 = hi_char then grade1 = "".
     if stat1 = hi_char then stat1 = "".
     if eff_date = low_date then eff_date = ?.
     if eff_date1 = hi_date then eff_date1 = ?.
     if part_type1 = hi_char then part_type1 = "".   
     if part_group1 = hi_char then part_group1 = "".
     find first tmp where tmp_userid = mfguser no-error.
     if available tmp then
         for each tmp where tmp_userid = mfguser:
            delete tmp.
         end.
			update site site1 loc loc1 line line1 part part1 part_type part_type1 
part_group part_group1 eff_date eff_date1 abc abc1 grade grade1 assay assay1 stat stat1
zeroflag sort_by with frame a.	
				
       bcdparm = "".
       {mfquoter.i site   }
       {mfquoter.i site1  }
       {mfquoter.i loc    }
       {mfquoter.i loc1   }
       {mfquoter.i line   }
       {mfquoter.i line1  }
       {mfquoter.i part   }
       {mfquoter.i part1  }
       {mfquoter.i eff_date }
       {mfquoter.i eff_date1}
       {mfquoter.i abc    }
       {mfquoter.i abc1   }
       {mfquoter.i grade  }
       {mfquoter.i grade1 }
       {mfquoter.i assay  }
       {mfquoter.i assay1 }
       {mfquoter.i stat   }
       {mfquoter.i stat1  }
       {mfquoter.i sort_by}
       
       if  line1 = "" then line1 = hi_char.
       if  part1 = "" then part1 = hi_char.
       if  site1 = "" then site1 = hi_char.
       if  loc1  = "" then loc1  = hi_char.
       if  abc1 = "" then abc1 = hi_char.
       if  grade1 = "" then grade1 = hi_char.
       if  stat1 = "" then stat1 = hi_char.
       if  eff_date = ? then eff_date = low_date.
       if  eff_date1 = ? then eff_date1 = hi_date.
       if  part_type1 = "" then part_type1 = hi_char.
       if  part_group1 = "" then part_group1 = hi_char.
  
   /* SELECT PRINTER */
   
					{mfselbpr.i "printer" 132}

          {mfphead2.i}
          find first icc_ctrl where icc_domain = global_domain  /*---Add by davild 20090205.1*/
		  no-lock no-error.
          for each in_mstr where 
			in_domain = global_domain and /*---Add by davild 20090205.1*/
			in_site >= site and in_site <= site1 
       		and in_part >= part and in_part <= part1:
               find first pt_mstr where 
					pt_domain = global_domain and /*---Add by davild 20090205.1*/
					pt_prod_line >= line and pt_prod_line <= line1
        	      and pt_part_type >= part_type and pt_part_type <= part_type1
	             and pt_group >= part_group and pt_group <= part_group1 
                    and (pt_abc >= abc and pt_abc <= abc1)
        	      and pt_part = in_part no-lock no-error.
               if not available pt_mstr then next.
               for each ld_det where 
					ld_domain = global_domain and /*---Add by davild 20090205.1*/
					(ld_site = in_site) and (ld_part = in_part)
                    and (ld_loc >= loc and ld_loc <= loc1)
                    and (ld_grade >= grade and ld_grade <= grade1)
	             and ((ld_assay >= assay and ld_assay <= assay1) or assay1 = 0)
	             and (ld_status >= stat and ld_status <= stat1)
                    no-lock:
                    find first tmp where tmp_part = ld_part and tmp_site = ld_site 
                          and tmp_loc = ld_loc and tmp_userid = mfguser no-error.
                    if not available tmp then do:
                       {gpsct03.i &cost=sct_cst_tot}
                       create tmp.
                       assign  tmp_userid = mfguser
                               tmp_site = ld_site
                               tmp_loc  = ld_loc 
                               tmp_part = ld_part
                               tmp_prod_line = pt_prod_line
                               tmp_beg_bal = ld_qty_oh
                               tmp_beg_amt = ld_qty_oh * glxcst
                               tmp_end_bal = ld_qty_oh
                               tmp_end_amt = ld_qty_oh * glxcst.
                    end.
                    else assign tmp_beg_bal = tmp_beg_bal + ld_qty_oh 
                                tmp_end_bal = tmp_end_bal + ld_qty_oh
                                tmp_beg_amt = tmp_beg_amt + ld_qty_oh * glxcst
                                tmp_end_amt = tmp_end_amt + ld_qty_oh * glxcst.
               end.    
	  	 {mfguirex.i } /*Replace mfrpexit*/
         end.

         for each tr_hist where 
				tr_domain = global_domain and /*---Add by davild 20090205.1*/
				tr_effdate >= eff_date and tr_site >= site and tr_site <= site1
              and tr_part >= part and tr_part <=  part1 and tr_loc >= loc and tr_loc <= loc1
              and tr_ship_type <> "M" and tr_assay >= assay and tr_assay <= assay1
              and tr_stat >= stat and tr_stat <= stat1
              and tr_grade >= grade and tr_grade <= grade1
              and (substring(tr_type,1,3) <> "ORD")
              , first pt_mstr where 
				pt_domain = global_domain and /*---Add by davild 20090205.1*/
				pt_part = tr_part and pt_abc >= abc and pt_abc <= abc1 no-lock:
              find first tmp where tmp_userid = mfguser and tmp_site = tr_site and 
                         tmp_part = tr_part and tmp_loc = tr_loc no-error.
              if not available tmp then do:
                    create tmp.
                    assign  tmp_userid = mfguser
                            tmp_site = tr_site
                            tmp_loc  = tr_loc 
                            tmp_part = tr_part
                            tmp_prod_line = pt_prod_line.
              end.
              find first trgl_det where 
				trgl_domain = global_domain and /*---Add by davild 20090205.1*/
				trgl_trnbr = tr_trnbr no-lock no-error.
              if available trgl_det then amt = trgl_gl_amt.
              else amt = 0.
              if tr_effdate >= eff_date then do:
                 assign tmp_beg_bal = tmp_beg_bal - tr_qty_loc.
                 if tr_type begins "ISS" then tmp_beg_amt = tmp_beg_amt + amt.
                 else tmp_beg_amt = tmp_beg_amt - amt.
              end.

              if tr_effdate > eff_date1 then do:
                 assign tmp_end_bal = tmp_end_bal - tr_qty_loc.
                 if tr_type begins "ISS" then tmp_end_amt = tmp_end_amt + amt.
                 else tmp_end_amt = tmp_end_amt - amt.
              end.
              if tr_effdate >= eff_date and tr_effdate <= eff_date1 then do:
                 if tr_type begins "RCT" or tr_type = "RJCT-WO" then do:
                    assign tmp_rct_qty = tmp_rct_qty + tr_qty_loc
                           tmp_rct_amt = tmp_rct_amt + amt.
                 end.
                 else if tr_type begins "ISS" then do:
                    assign tmp_iss_qty = tmp_iss_qty + tr_qty_loc
                           tmp_iss_amt = tmp_iss_amt + amt.
                 end.
                 else if tr_type begins "CST" then assign tmp_cst_qty = tmp_cst_qty + tr_loc_begin
                             tmp_cst_amt = tmp_cst_amt + amt.
                 else assign tmp_cnt_qty = tmp_cnt_qty + tr_qty_loc
                             tmp_cnt_amt = tmp_cnt_amt + amt.
              end.
         end.
         if sort_by then          
             for each tmp where tmp_userid = mfguser ,
                 first pt_mstr where pt_part = tmp_part no-lock
                 break by tmp_site by tmp_prod_line by tmp_loc by tmp_part
                 with frame c stream-io width 255 no-box:
                  if zeroflag then 
                      if tmp_beg_bal = 0 and tmp_rct_qty = 0 and tmp_iss_qty = 0 
                         and tmp_cnt_qty = 0 and tmp_end_bal = 0 then next.        
/*                  if last-of(tmp_site) then page.*/
  accumulate tmp_beg_amt (total by tmp_prod_line).
  accumulate tmp_rct_amt (total by tmp_prod_line).
  accumulate tmp_iss_amt (total by tmp_prod_line).
  accumulate tmp_cnt_amt (total by tmp_prod_line).
  accumulate tmp_cst_amt (total by tmp_prod_line).
  accumulate tmp_end_amt (total by tmp_prod_line).

                

                  if  page-size - line-counter < 19 then  page.
                  display tmp_loc tmp_part 
                        
                          tmp_beg_bal 
                          tmp_rct_qty 
                          (tmp_iss_qty * -1) @ tmp_iss_qty
                          tmp_cnt_qty 
                          tmp_end_bal 
                  with frame c.
                  down with frame c.
                  display 
                    pt_desc1 @ tmp_part
                    pt_um @ tmp_loc
                    tmp_beg_amt @ tmp_beg_bal
                    tmp_rct_amt @ tmp_rct_qty
                    tmp_iss_amt @ tmp_iss_qty 
                    tmp_cnt_amt @ tmp_cnt_qty
                    tmp_cst_amt @ tmp_cst_qty
                    tmp_end_amt @ tmp_end_bal 
                   
                    with frame c.
                  down with frame c.
                  if pt_desc2 <> "" then
                    display 
                    pt_desc2 @ tmp_part
                    with frame c.
                  down with frame c.


                    if last-of(tmp_prod_line) then do:
                   down with frame c.
                  display 
                  "---------------" @ tmp_beg_bal
                  "---------------" @ tmp_rct_qty
                  "---------------" @ tmp_iss_qty
                  "---------------" @ tmp_cnt_qty
                  "---------------" @ tmp_cst_QTY
                  "---------------"  @ tmp_end_bal.
                 DOWN.
                  DISPLAY
                  (trim(tmp_prod_line) + "产品类金额汇总") @ tmp_part
                  (accum total by tmp_prod_line (tmp_beg_amt)) format "->>>,>>>,>>9.99"  @ tmp_beg_bal
                  (accum total by tmp_prod_line (tmp_rct_amt)) format "->>>,>>>,>>9.99"  @ tmp_rct_qty
                  (accum total by tmp_prod_line (tmp_iss_amt)) format "->>>,>>>,>>9.99"  @ tmp_iss_qty
                  (accum total by tmp_prod_line (tmp_cnt_amt)) format "->>>,>>>,>>9.99"  @ tmp_cnt_qty
                  (accum total by tmp_prod_line (tmp_cst_amt)) format "->>>,>>>,>>9.99"  @ tmp_cst_QTY
                  (accum total by tmp_prod_line (tmp_end_amt)) format "->>>,>>>,>>9.99"  @ tmp_end_bal
                  with frame c.
                  down with frame c .
                  page.
                  end.
                  {mfguirex.i } /*Replace mfrpexit*/
             end.
         else for each tmp where tmp_userid = mfguser ,
                 first pt_mstr where pt_part = tmp_part no-lock
                 break by tmp_site by tmp_prod_line  by tmp_part by tmp_loc
                 with frame d stream-io width 255 no-box:
                  if zeroflag then 
                      if tmp_beg_bal = 0 and tmp_rct_qty = 0 and tmp_iss_qty = 0 
                         and tmp_cnt_qty = 0 and tmp_end_bal = 0 then next.        
                 /*                  if last-of(tmp_site) then page.*/
  accumulate tmp_beg_amt (total by tmp_prod_line).
  accumulate tmp_rct_amt (total by tmp_prod_line).
  accumulate tmp_iss_amt (total by tmp_prod_line).
  accumulate tmp_cnt_amt (total by tmp_prod_line).
  accumulate tmp_cst_amt (total by tmp_prod_line).
  accumulate tmp_end_amt (total by tmp_prod_line).

                

                  if  page-size - line-counter < 19 then  page.

                  display tmp_loc tmp_part 
                         
                          tmp_beg_bal 
                          tmp_rct_qty 
                          (tmp_iss_qty * -1) @ tmp_iss_qty
                          tmp_cnt_qty 
                          tmp_end_bal 
                  with frame d.
                  down with frame d.
                  display 
                    pt_desc1 @ tmp_part
                    pt_um @ tmp_loc
                    tmp_beg_amt @ tmp_beg_bal
                    tmp_rct_amt @ tmp_rct_qty
                    tmp_iss_amt @ tmp_iss_qty
                    tmp_cnt_amt @ tmp_cnt_qty
                    tmp_cst_amt @ tmp_cst_qty
                    tmp_end_amt @ tmp_end_bal 
                 
                    with frame d.
                  down with frame d.
                    if pt_desc2 <> "" then
                    display 
                    pt_desc2 @ tmp_part
                    with frame d.
                  down with frame d.

                   if last-of(tmp_prod_line) then do:
                   down with frame d.
                   display 
                  "---------------" @ tmp_beg_bal
                  "---------------" @ tmp_rct_qty
                  "---------------" @ tmp_iss_qty
                  "---------------" @ tmp_cnt_qty
                  "---------------" @ tmp_cst_QTY
                  "---------------"  @ tmp_end_bal.
                 DOWN.
                  DISPLAY

                  (trim(tmp_prod_line) + "产品类金额汇总") @ tmp_part
                  (accum total by tmp_prod_line (tmp_beg_amt)) format "->>>,>>>,>>9.99"  @ tmp_beg_bal
                  (accum total by tmp_prod_line (tmp_rct_amt)) format "->>>,>>>,>>9.99"  @ tmp_rct_qty
                  (accum total by tmp_prod_line (tmp_iss_amt)) format "->>>,>>>,>>9.99"  @ tmp_iss_qty
                  (accum total by tmp_prod_line (tmp_cnt_amt)) format "->>>,>>>,>>9.99"  @ tmp_cnt_qty
                  (accum total by tmp_prod_line (tmp_cst_amt)) format "->>>,>>>,>>9.99"  @ tmp_cst_QTY
                  (accum total by tmp_prod_line (tmp_end_amt)) format "->>>,>>>,>>9.99"  @ tmp_end_bal
                  with frame d.
                  down with frame d .
                  page.
                  end.

                  {mfguirex.i } /*Replace mfrpexit*/
             end.
         /* REPORT TRAILER */
   
 {mfguirex.i }.
 {mfguitrl.i}.
 {mfgrptrm.i} .

end.
