/* xxpirp01.p  - Production Issue Report                                */
/* COPYRIGHT DCEC. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.    */
/* V1                 Developped: 11/06/01      BY: Rao Haobin          */
/* V2                 Developped: 01/04/02      BY: Rao Haobin          */
/* v3.1               modified by: Jch at 02/04/04                      */
/* RHB 生产材料领用报表，按产成品分类统计 */

{mfdtitle.i } 

define variable site like pt_site.
define variable site1 like pt_site.
define variable part like pt_part.
define variable part1 like pt_part.
define variable line like tr_prod_line.
define variable line1 like tr_prod_line.
define variable date like tr_effdate.
define variable date1 like tr_effdate.
define variable sum_1200 as decimal  label "国产件合计"  format "->,>>>,>>>,>>9.99" initial 0.
define variable sum_1100 as decimal  label "进口件合计"  format "->,>>>,>>>,>>9.99" initial 0.
define variable sum_1500 as decimal  label "委托加工材料合计"  format "->,>>>,>>>,>>9.99" initial 0.
define variable sum_2000 as decimal  label "外购半成品合计"  format "->,>>>,>>>,>>9.99" initial 0.
define variable sum_7000 as decimal  label "产成品改制合计"  format "->,>>>,>>>,>>9.99" initial 0.
define variable sum_9999 as decimal label "其他合计" format "->,>>>,>>>,>>9.99" initial 0.
define variable sum_qty_comp1 like wo_qty_comp  label "生产完工数量合计" initial 0.
define variable sum_qty_comp2 like wo_qty_comp  label "改制完工数量合计" initial 0.
define variable sum_qty_comp3 like wo_qty_comp  label "改制出库数量合计" initial 0.


define workfile wo_sum field ws_part like wo_part
                        field ws_1200 as decimal  label "国产件"  format "->,>>>,>>>,>>9.99"
                        field ws_1100 as decimal  label "进口件"  format "->,>>>,>>>,>>9.99"
                        field ws_1500 as decimal  label "委加材料"  format "->,>>>,>>>,>>9.99"
                        field ws_2000 as decimal  label "外购半成品"  format "->,>>>,>>>,>>9.99"
                        field ws_7000 as decimal  label "产成品改制"  format "->,>>>,>>>,>>9.99"
                        field ws_9999 as decimal label "其他" format "->,>>>,>>>,>>9.99"
                        /* ws_qty_comp1 存储日程排产完工数量 */
                        field ws_qty_comp1 like wo_qty_comp  label "生产完工数量"
                        /* ws_qty_comp2 存储利用iss_wo发出改制数量 */
                        field ws_qty_comp2 like wo_qty_comp  label "改制完工数量"
                        field ws_qty_comp3 like wo_qty_comp label "改制出库".
                        

/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

 FORM /*GUI*/ 
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
	     site           colon 18
	     site1          label {t001.i} colon 49 skip
	     line 	    colon 18
	     line1          label {t001.i} colon 49 skip
	     part           colon 18
	     part1          label {t001.i} colon 49 skip
             date            colon 18
             date1           label {t001.i} colon 49 skip
  skip
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.


 DEFINE VARIABLE F-a-title AS CHARACTER.
  F-a-title = " 选择条件 ".
  RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
  RECT-FRAME-LABEL:WIDTH-PIXELS in frame a =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame a + " ", RECT-FRAME-LABEL:FONT).
  RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
  RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5. /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME

/*judy 05/08/05*/ /* SET EXTERNAL LABELS */
/*judy 05/08/05*/  setFrameLabels(frame a:handle).


	  /* REPORT BLOCK */

	  
/*GUI*/ {mfguirpa.i true  "printer" 132 }

/*GUI repeat : */
/*GUI*/ procedure p-enable-ui:

	     if part1 = hi_char then part1 = "".
	     if date = low_date then date = ?.
	     if date1 = hi_date then date1 = ?.
	     if site1 = hi_char then site1 = "".
	     if line1 = hi_char then line1 = "".
	     if line  = hi_char then line = "".
	     
run p-action-fields (input "display").
run p-action-fields (input "enable").
end procedure. /* p-enable-ui, replacement of Data-Entry GUI*/

/*GUI*/ procedure p-report-quote:


	     bcdparm = "".

	     {mfquoter.i part   }
	     {mfquoter.i part1   }
	     {mfquoter.i date   }
	     {mfquoter.i date1   }
	     {mfquoter.i site   }
	     {mfquoter.i site1   }
	     {mfquoter.i line   }
	     {mfquoter.i line1   }
	     
	     if  part1 = "" then part1 = hi_char.
	     if  site1 = "" then site1 = hi_char.
	     if  line1 = "" then line1 = hi_char.
	     if  date = ? then date = low_date.
	     if  date1 = ? then date1 = hi_date.
	     
	     /* SELECT PRINTER */
	     
/*GUI*/ end procedure. /* p-report-quote */

/*GUI*/ procedure p-report:

/*GUI*/   {gpprtrpa.i  "printer" 132}
{mfphead.i}

sum_1100 = 0.
sum_1200 = 0.
sum_1500 = 0.
sum_2000 = 0.
sum_7000 = 0.
sum_9999 = 0.
sum_qty_comp1 = 0.
sum_qty_comp2 = 0.
for each tr_hist no-lock where tr_type = "iss-wo" 
                               and tr_effdate >= date and tr_effdate <= date1 
                               and tr_prod_line >= line and tr_prod_line <= line1
                               and tr_site >= site and tr_site <= site1 ,
    each wo_mstr no-lock where wo_lot = tr_lot:

    find first wo_sum where ws_part = wo_part no-error.
         if not available wo_sum then do:
            create wo_sum.
            ws_part = wo_part.
    end.
    if tr_prod_line >= "1100" AND tr_prod_line <= "1199"  then do:
	ws_1100 = ws_1100 + round(tr_qty_chg * (tr_mtl_std + tr_lbr_std + tr_ovh_std + tr_bdn_std + tr_sub_std),2).
	end.
	else if tr_prod_line >= "1200" AND tr_prod_line <= "1299"  then do:
		ws_1200 = ws_1200 + round(tr_qty_chg * (tr_mtl_std + tr_lbr_std + tr_ovh_std + tr_bdn_std + tr_sub_std),2).
		end.
		else if tr_prod_line = "1500" then do: 
			ws_1500 = ws_1500 + round(tr_qty_chg * (tr_mtl_std + tr_lbr_std + tr_ovh_std + tr_bdn_std + tr_sub_std),2).
			end.
			else if tr_prod_line >= "2000" and tr_prod_line <= "2999" then do:
				ws_2000 = ws_2000 + round(tr_qty_chg * (tr_mtl_std + tr_lbr_std + tr_ovh_std + tr_bdn_std + tr_sub_std),2).
				end.
				else if tr_prod_line >= "7000" and tr_prod_line <= "7999" then do:
					ws_7000 = ws_7000 + round(tr_qty_chg * (tr_mtl_std + tr_lbr_std + tr_ovh_std + tr_bdn_std + tr_sub_std),2).
					end.
					else do:
						ws_9999 = ws_9999 + round(tr_qty_chg * (tr_mtl_std + tr_lbr_std + tr_ovh_std + tr_bdn_std + tr_sub_std),2).
						end.
    end.

for each tr_hist no-lock where tr_type = "rct-wo"  and tr_effdate >= date and tr_effdate <= date1 
     and tr_prod_line >= line and tr_prod_line <= line1:
    find first wo_sum where ws_part = tr_part no-error.
    if available wo_sum then do:
       if tr_nbr <> "" then do:
          ws_qty_comp2 = ws_qty_comp2 + tr_qty_loc.
       end.
       else do: 
          ws_qty_comp1 = ws_qty_comp1 + tr_qty_loc.
       end.
    end.
end.

for each tr_hist no-lock where (tr_type = "iss-wo") and tr_effdate >= date and tr_effdate <= date1 and tr_prod_line >= line and tr_prod_line <= line1:
    find first wo_sum where ws_part = tr_part no-error.
    if not available wo_sum then do:
       create wo_sum.
       ws_part = tr_part.
    end.
    ws_qty_comp3 = ws_qty_comp3 + tr_qty_loc.
end.

for each wo_sum,
    each pt_mstr where pt_part = ws_part,
    each pl_mstr where pl_prod_line = pt_prod_line:
    if available wo_sum then do:
    if pl_prod_line >= line and pl_prod_line <= line1 and ws_part >= part and ws_part <= part1 then do:
       disp ws_part pt_desc2 pl_prod_line pl_desc ws_1200 round(ws_1100,2) format "->>>,>>>,>>9.99" column-label "进口件    "  ws_1500 ws_2000 ws_7000 ws_9999 ws_qty_comp1 ws_qty_comp2 ws_qty_comp3 ws_qty_comp1 + ws_qty_comp2 + ws_qty_comp3 column-label "完工合计  " format "->>,>>>,>>9"  with STREAM-IO width 256 .
       sum_1100 = sum_1100 + ws_1100.
       sum_1200 = sum_1200 + ws_1200.
       sum_1500 = sum_1500 + ws_1500.
       sum_2000 = sum_2000 + ws_2000.
       sum_7000 = sum_7000 + ws_7000.
       sum_9999 = sum_9999 + ws_9999.
       sum_qty_comp1 = sum_qty_comp1 + ws_qty_comp1.
       sum_qty_comp2 = sum_qty_comp2 + ws_qty_comp2.
       sum_qty_comp3 = sum_qty_comp3 + ws_qty_comp3.
    end.
    end.
end.

disp sum_1200 sum_1100 sum_1500 sum_2000 sum_7000 sum_9999 sum_qty_comp1 sum_qty_comp2 sum_qty_comp3 sum_qty_comp1 + sum_qty_comp2 + sum_qty_comp3 column-label "完工合计  " format "->>,>>>,>>9" with width 256 STREAM-IO.
sum_1100 = 0.
sum_1200 = 0.
sum_1500 = 0.
sum_2000 = 0.
sum_7000 = 0.
sum_9999 = 0.
sum_qty_comp1 = 0.
sum_qty_comp2 = 0.

 
{mfguitrl.i}
/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/

end procedure.



/*GUI*/ {mfguirpb.i &flds=" site site1 line line1 part part1 date date1 "} /*Drive the Report*/



