/* xxqmrp090.p 国内供应商转厂明细                                           */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/*V8:ConvertMode=NoConvert                                                  */
/* REVISION: 1.0      Create : 2008/05/20   BY: Softspeed RogerXiao         */

/****************************************************************************/

/*说明:
1.原始数据: v_sitelist(1100~1400) 所有5.13.1交货至CHA的 , site(1700):v_vendlist(指定供应商/零件)的所有5.13.1交货
2.除去了符合以上规则的5.13.1退货, 未除去5.13.7的(CHA)退货数
3.不包含计划外入库部分的供应商交货
*/


/* DISPLAY TITLE */
{mfdtitle.i "1.0"}


define var v_start as date label "开始日期" .
define var v_end  as date label "截止日期" .
define var site   like si_site .
define var v_site like si_site .
define var v_sitelist as char  .
define var v_loclist  as char .
define var v_vendlist as char .
define var vend   like po_vend .
define var vend1  like po_vend. 
define var vnbr  like prh_receiver label "收货单号".
define var vnbr1 like prh_receiver .
define var part like pod_part .
define var part1 like pod_part .
define var v_desc1 like pt_Desc1 .
define var v_desc2 like pt_Desc1 .
define var v_qty_iss like tr_qty_loc .



define temp-table temp1 
field t1_part like pod_part
field t1_vend like prh_vend
field t1_um like pt_um
field t1_qty  like tr_qty_loc .

define buffer prhhist for prh_hist . 

/*find icc_ctrl where icc_domain = global_domain no-lock no-error.
site = if avail icc_ctrl then icc_site else "" .*/
if v_start = ? then v_start = date(month(date(month(today),1,year(today)) - 1 ),1,year(date(month(today),1,year(today)) - 1)).
if v_end   = ? then v_end   = date(month(today),1,year(today)) - 1 .

v_site = "1100" .
v_vendlist = "93S006MH,93H014MU,93S007MH,93S007MU,93C008MU,93T020MU,93Y004MU,93U003MH,93I006MU,93P011MU" .
/*1700: 特殊供应商: 93P007MH(物料：C6009-200#)*/
v_sitelist = "1100,1200,1300,1400" .
site = "1700" .




define  frame a.
form
    SKIP(.2)

    v_start                 colon 16 
    v_end                   colon 50
    v_site                  colon 16
    vend                    colon 16
    vend1                   colon 50
    vnbr                     colon 16
    vnbr1                    colon 50
    part                    colon 16
    part1                   colon 50
	
skip(2) 
with frame a  side-labels width 80 attr-space.

/* SET EXTERNAL LABELS  */
setFrameLabels(frame a:handle).

{wbrp01.i}
repeat:
    hide all no-pause. {xxtop.i}
    
    if part1 = hi_char then part1 = "" .
    if vnbr1  = hi_char then vnbr1  = "" .
    if vend1  = hi_char then vend1  = "" .
    if v_start = ? then v_start = date(month(date(month(today),1,year(today)) - 1 ),1,year(date(month(today),1,year(today)) - 1)).
    if v_end   = ? then v_end   = date(month(today),1,year(today)) - 1 .

 update v_start v_end v_site vend vend1  vnbr vnbr1 part part1  with frame a.

/*
  find first si_mstr where si_domain = global_domain and si_site = site no-lock no-error .
  if not avail si_mstr then do:
     message "无效地点,请重新输入." view-as alert-box .
     next-prompt site with frame a.
     undo,retry .
  end.
*/
  if lookup(v_site,"1100,1200") = 0 then do:
     message "地点仅限1100,1200;请重新输入." view-as alert-box .
     next-prompt v_site with frame a.
     undo,retry .
  end.

  if v_site = "1100" then assign v_sitelist = "1100,1300" site = "1700".
  if v_site = "1200" then assign v_sitelist = "1200,1400" site = "" .
  v_loclist = "500,666,888,999" . /*all香港仓*/



 if v_start = ? then v_start = low_date .
 if v_end   = ? then v_end   = hi_date  .
 

 if vnbr1 = "" then vnbr1 = hi_char .
 if part1  = "" then part1 = hi_char .
 if vend1 = "" then vend1 = hi_char .

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


PUT UNFORMATTED "#def REPORTPATH=$/Citizen/xxqmrp090" SKIP.
PUT UNFORMATTED "#def :end" SKIP.   

for each temp1 : delete temp1 . end.

for each prh_hist 
    use-index prh_rcp_date
    where prh_domain = global_domain 
    and prh_rcp_Date >= v_start and prh_rcp_date <= v_end
    and prh_vend >= vend and prh_vend <= vend1
    and prh_receiver  >= vnbr and prh_receiver <= vnbr1
    and prh_part >= part and prh_part <= part1 
    and (
          (lookup(prh_site,v_sitelist) > 0 and prh__chr01 = "CHA" )
          or
          (prh_site = site and (lookup(prh_vend ,v_vendlist) > 0 or (prh_vend = "93P007MH" and prh_part = "C6009-200#"))
           )
         )
    no-lock break by prh_part by prh_vend :


/*and lookup(prh_site,v_sitelist) > 0*/ 
/*
    find first tr_hist
        use-index tr_nbr_eff
        where tr_hist.tr_domain = global_domain
        and   tr_nbr            = prh_nbr
        and   tr_effdate        = prh_rcp_date
        and   tr_lot            = prh_receiver        
        and   tr_line           = prh_line
        and   tr_part           = prh_part
    no-lock no-error .
    if not avail tr_hist then next .
    else do:
        if lookup(tr_loc , v_loclist) > 0 then next . 
    end.
   

    if prh_rcvd < 0 then do:
        find first prhhist 
            where prhhist.prh_domain  = global_domain 
            and prhhist.prh_nbr       = prh_hist.prh_nbr
            and prhhist.prh_receiver  <> prh_hist.prh_receiver
            and prhhist.prh_line      = prh_hist.prh_line 
            and prhhist.prh_rcvd      > 0 
            and can-find(first tr_hist
                            use-index tr_nbr_eff
                            where tr_hist.tr_domain = global_domain
                            and   tr_nbr            = prhhist.prh_nbr
                            and   tr_effdate        = prhhist.prh_rcp_date
                            and   tr_lot            = prhhist.prh_receiver        
                            and   tr_line           = prhhist.prh_line
                            and   tr_part           = prhhist.prh_part
                            and   lookup(tr_loc , v_loclist) > 0 
                        )
        no-lock no-error .
        if avail prhhist then next . 
    end. /*属退货时,判断是否此po项有过送交香港,yes-报表不减去此退货数,no-报表扣掉此部分退货数*/
*/ 

    find first temp1 where t1_part = prh_hist.prh_part and t1_vend = prh_hist.prh_vend no-error .
    if not avail temp1 then do:
        create temp1.
        assign  t1_part = prh_hist.prh_part 
                t1_vend = prh_hist.prh_vend 
                t1_um   = prh_hist.prh_um 
                t1_qty  = prh_hist.prh_rcvd .
    end.
    else do:
        t1_qty = t1_qty + prh_hist.prh_rcvd .
    end.

end.





for each temp1 break by t1_part by t1_vend :


        find first pt_mstr where pt_domain = global_domain and pt_part = t1_part no-lock no-error .
        v_desc1 = if avail pt_mstr then pt_desc1 else "" .
        find first ad_mstr where ad_domain = global_Domain and ad_addr = t1_vend no-lock no-error .
        v_desc2 = if avail ad_mstr then ad_name else "" .

        put UNFORMATTED t1_part ";" .
        put UNFORMATTED v_desc1 ";" .
        put UNFORMATTED t1_um ";" .
        put UNFORMATTED t1_vend ";" .
        put UNFORMATTED v_desc2 ";" .
        put UNFORMATTED t1_qty  .
        put skip .
end.


	end. /* mainloop: */
/* {mfrtrail.i}  REPORT TRAILER  */
{mfreset.i}
end.  /* REPEAT */
{wbrp04.i &frame-spec = a}


