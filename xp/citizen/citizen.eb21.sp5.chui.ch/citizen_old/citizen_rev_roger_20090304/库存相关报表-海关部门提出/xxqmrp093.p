/* xxqmrp093.p 生产线WIP库存报表:                                           */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/*V8:ConvertMode=NoConvert                                                  */
/* REVISION: 1.0      Create : 2008/05/20   BY: Softspeed RogerXiao         */

/****************************************************************************/
/*
说明:
1.不统计返修工单wo_type <> "R"
2.由现在工单出入库数量,按输入期初期末日期,寻找库存交易,推算期初/期末/本期出/入数,        
3.工单所发的材料,再按指定的BOM日期和工单的地点,展开成该地点的原材料
4.地点(上线前):1100-->1100,1300,1700 ;1200--> 1200,1400 .

*/



/* DISPLAY TITLE */
{mfdtitle.i "1.0"}

define var v_site       like si_site .
define var v_sitelist   as char .
define variable eff__date as date label "BOM生效日期".
define var v_pm_code like ptp_pm_code .

define var v_start as date label "开始日期" .
define var v_end  as date label "截止日期" .
define var nbr  like wo_nbr .
define var nbr1 like wo_nbr .

define var v_end_rct like tr_qty_loc .
define var v_qty_rct like tr_qty_loc .
define var v_end_iss like tr_qty_loc .
define var v_qty_iss like tr_qty_loc .
define var v_key as char .
define var v_time as integer .

define var v_desc1 like pt_desc1 .
define var v_desc2 like pt_desc1 .
define var v_qty_aa like tr_qty_loc .
define var v_qty_bb like tr_qty_loc .
define var v_qty_cc like tr_qty_loc .
define var v_qty_dd like tr_qty_loc .


define temp-table temp1
        field t1_par         like ps_par label "父零件" 
        field t1_comp        like ps_comp  label "子零件"
        field t1_site        like si_site 
        field t1_um          like pt_um
        field t1_desc1       like pt_desc1
        field t1_desc2       like pt_desc2
        field t1_qty_per     like ps_qty_per
        index t1_parcomp     t1_par t1_comp.

find first icc_ctrl where icc_domain = global_domain no-lock no-error.
v_site = if available icc_ctrl then icc_site else global_domain .

v_key = mfguser .

v_site = "1100" .


define  frame a.
form
    SKIP(.2)
    v_start                 colon 16 
    v_end                   colon 50
    v_site                  colon 16
    eff__date               colon 16
    
    nbr                     colon 16
    nbr1                    colon 50

skip(2) 
with frame a  side-labels width 80 attr-space.

/* SET EXTERNAL LABELS  */
setFrameLabels(frame a:handle).

{wbrp01.i}
repeat:
    hide all no-pause. {xxtop.i}

    if nbr1  = hi_char then nbr1  = "" .

 if v_start = ? then v_start = date(month(date(month(today),1,year(today)) - 1 ),1,year(date(month(today),1,year(today)) - 1)).
 if v_end   = ? then v_end   = date(month(today),1,year(today)) - 1 .
 if eff__date = ? then eff__date = today  .
 
 update v_start v_end v_site eff__date nbr nbr1 with frame a.

  if lookup(v_site,"1100,1200") = 0 then do:
      message "地点仅限1100,1200,请重新输入" view-as alert-box.
      next-prompt v_site.
      undo,retry .
  end.
  if v_site = "1100" then v_sitelist = "1100,1300,1700" .
  if v_site = "1200" then v_sitelist = "1200,1400" .

 
 if v_start = ? then v_start = low_date .
 if v_end   = ? then v_end   = hi_date  .
 if eff__date = ? then eff__date = today .


 if nbr1 = "" then nbr1 = hi_char .


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


v_time = time .    
for each xxcwo_wkfl  /**/
    where xxcwo_domain = global_domain 
    and xxcwo_key      = v_key   :  
    delete xxcwo_wkfl . 
end .

for each xxcwod_wkfl  /**/
    where xxcwod_domain = global_domain 
    and xxcwod_key      = v_key   : 
    delete xxcwod_wkfl . 
end .


/*按每张工单建立零件明细:*/
for each wo_mstr         
        field(wo_domain wo_type wo_nbr wo_status wo_lot wo_nbr wo_rel_date wo_part wo_qty_ord wo_qty_comp  wo_site )
         where wo_domain = global_domain 
         and wo_nbr >= nbr and wo_nbr <= nbr1
         and lookup(wo_site,v_sitelist) > 0 
         and wo_rel_date <= v_end
         and (wo_type <> "R" /*or wo_type = ""*/)
         and (wo_status = "R" or wo_status = "C" )          
         use-index wo_type_nbr
     no-lock ,
     each wod_det 
         field(wod_domain wod_lot wod_nbr wod_part wod_qty_req wod_qty_iss wod_bom_qty )
         where wod_domain = global_domain 
         and wod_lot  = wo_lot 
     no-lock :


     find first xxcwo_wkfl 
            where xxcwo_domain = global_domain 
            and xxcwo_key      = v_key 
            and xxcwo_lot      = wod_lot 
            and xxcwo_part     = wod_part 
     no-error .
     if not avail xxcwo_wkfl then do :
        create xxcwo_wkfl.
        assign
         xxcwo_domain   = global_domain 
         xxcwo_key      = v_key 
         xxcwo_userid   = global_userid 
         xxcwo_date     = today 
         xxcwo_lot      = wo_lot
         xxcwo_site     = wo_site
         xxcwo_nbr      = wo_nbr
         xxcwo_par      = wo_part
         xxcwo_part     = wod_part 
         xxcwo_start_date = v_start 
         xxcwo_end_date = v_end
         xxcwo_end_comp = wo_qty_comp 
         xxcwo_end_iss  = wod_qty_iss
         xxcwo_bom_qty  = wod_bom_qty
          
         .
        
     end.
     else do:
        xxcwo_bom_qty  = xxcwo_bom_qty + wod_bom_qty .
        xxcwo_end_iss  = xxcwo_end_iss + wod_qty_iss .
     end.

 end. /*for each wo_mstr*/


/*每张工单的领料入库交易查询:*/
for each xxcwo_wkfl 
        where xxcwo_domain = global_domain 
        and xxcwo_key = v_key 
        break by xxcwo_lot by xxcwo_part :

        if first-of(xxcwo_lot) then do:

                v_qty_rct = 0 .
                v_end_rct = 0 . 
                for each tr_hist 
                    field( tr_rmks tr_nbr tr_line tr_site tr_prod_line tr_part tr_trnbr tr_addr tr_lot tr_effdate
                        tr_date tr_type tr_site tr_loc tr_program tr_qty_loc )
                    where tr_hist.tr_domain = global_domain
                    and tr_part = xxcwo_par
                    and (tr_effdate >= v_start or tr_effdate = ?)
                    and (tr_type = "RCT-WO")
                    and tr_nbr = xxcwo_nbr 
                    and tr_lot = xxcwo_lot 
                    no-lock :
                        if tr_effdate = ? or tr_effdate > v_end then v_end_rct = v_end_rct + tr_qty_loc .
                        else v_qty_rct = v_qty_rct + tr_qty_loc .
                		/*	put tr_date ""  tr_effdate "" tr_part "" tr_program "" tr_type  "" tr_trnbr "" tr_qty_loc skip .*/
                end.
        end. /*if first-of(xxcwo_lot)*/

        v_qty_iss = 0 .
        v_end_iss = 0 .
        for each tr_hist 
            field( tr_rmks tr_nbr tr_line tr_site tr_prod_line tr_part tr_trnbr tr_addr tr_lot tr_effdate
                tr_date tr_type tr_site tr_loc tr_program tr_qty_loc )
            where tr_hist.tr_domain = global_domain
            and tr_part = xxcwo_part 
            and (tr_effdate >= v_start  or tr_effdate = ?)
            and (tr_type = "ISS-WO")
            and tr_nbr = xxcwo_nbr 
            and tr_lot = xxcwo_lot 
            no-lock :
                if tr_effdate = ? or tr_effdate > v_end then v_end_iss = v_end_iss + (- tr_qty_loc ) .
                else v_qty_iss = v_qty_iss + (- tr_qty_loc ) .
		            /*put tr_date ""  tr_effdate "" tr_part "" tr_program "" tr_type  "" tr_trnbr "" tr_qty_loc skip .*/
        end.

        xxcwo_end_comp = (xxcwo_end_comp - v_end_rct)  * xxcwo_bom_qty .
        xxcwo_end_iss  = xxcwo_end_iss  - v_end_iss .
        xxcwo_rct      = xxcwo_rct + v_qty_rct * xxcwo_bom_qty .
        xxcwo_iss      = xxcwo_iss + v_qty_iss .
        xxcwo_end_wip      = xxcwo_end_iss - xxcwo_end_comp . 
        xxcwo_start_comp   = xxcwo_end_comp - xxcwo_rct .
        xxcwo_start_iss    = xxcwo_end_iss - xxcwo_iss .
        xxcwo_start_wip    = xxcwo_start_iss - xxcwo_start_comp  . 


end. /*for each xxcwo_wkfl*/


/*wo"发料件"展开成"原材料"*/
for each xxcwo_wkfl 
        use-index xxcwo_part
        where xxcwo_domain = global_domain 
        and xxcwo_key = v_key 
        break by xxcwo_site by xxcwo_part :
        if first-of(xxcwo_part) then do:
            v_pm_code = "" .
            find first ptp_det where ptp_domain = global_domain and ptp_part = xxcwo_part and ptp_site = xxcwo_site  no-lock no-error  .
            if avail ptp_det then do:
                v_pm_code = ptp_pm_code .
            end.
            else do:
                find first pt_mstr where pt_domain = global_domain and pt_part = xxcwo_part  no-lock no-error  .
                if avail pt_mstr then do:
                    v_pm_code = pt_pm_code .
                end.          
            end. /*仅非原材料*/

            for each temp1 : delete temp1 . end.

            if v_pm_code <> "P" then do:                
                run process_report (input xxcwo_part,input eff__date ,input xxcwo_site ).
            end.
            
            /*有BOM的,展开*/
            for each temp1 where t1_par = xxcwo_part :
                find first xxcwod_wkfl 
                        where xxcwod_domain = global_domain 
                        and xxcwod_key      = v_key
                        and xxcwod_site     = xxcwo_site
                        and xxcwod_part     = t1_par
                        and xxcwod_sub_part = t1_comp
                no-error .
                if not avail xxcwod_wkfl then do:
                    create xxcwod_wkfl .
                    assign 
                        xxcwod_domain   = global_domain 
                        xxcwod_key      = v_key
                        xxcwod_site     = xxcwo_site
                        xxcwod_part     = t1_par
                        xxcwod_sub_part = t1_comp
                        xxcwod_bom_qty  = t1_qty_per
                        .
                end.
            end.
            
            /*没BOM的,本身*/
            find first xxcwod_wkfl 
                    where xxcwod_domain = global_domain 
                    and xxcwod_key      = v_key
                    and xxcwod_site     = xxcwo_site
                    and xxcwod_part     = xxcwo_part
            no-error .
            if not avail xxcwod_wkfl then do:
                create xxcwod_wkfl .
                assign 
                    xxcwod_domain   = global_domain 
                    xxcwod_key      = v_key
                    xxcwod_site     = xxcwo_site
                    xxcwod_part     = xxcwo_part
                    xxcwod_sub_part = xxcwo_part
                    xxcwod_bom_qty  = 1
                    .
            end.

        end. /*if first-of(xxcwo_part)*/
end. /*wo"发料件"展开成"原材料"*/


/*test*/
/*
for each xxcwo_wkfl with frame test1 width 300 :
disp xxcwo_wkfl with frame test1 .
end.


for each xxcwod_wkfl with frame test2 width 300 :
disp xxcwod_wkfl with frame test2 .
end.
*/ 


PUT UNFORMATTED "#def REPORTPATH=$/Citizen/xxqmrp093" SKIP.
PUT UNFORMATTED "#def :end" SKIP.   

/*按地点/零件/成品汇总,输出*/
for each xxcwo_wkfl 
        where xxcwo_domain = global_domain 
        and xxcwo_key = v_key ,
    each xxcwod_wkfl 
        where xxcwod_domain = global_domain 
        and xxcwod_key      = v_key
        and xxcwod_site     = xxcwo_site
        and xxcwod_part     = xxcwo_part
    break by xxcwo_site by xxcwo_par  by xxcwo_part by xxcwod_sub_part with frame x width 300 :


    if first-of(xxcwod_sub_part) then do:
        find first pt_mstr where pt_domain = global_domain and pt_part = xxcwod_sub_part no-lock no-error .
        v_desc1 = if avail pt_mstr then pt_desc1 else "" .
        v_qty_aa = 0 .
        v_qty_bb = 0 .
        v_qty_cc = 0 .
        v_qty_dd = 0 .
    end.

    if first-of(xxcwo_par) then do:
        find first pt_mstr where pt_domain = global_domain and pt_part = xxcwo_par no-lock no-error .
        v_desc2 = if avail pt_mstr then pt_desc1 else "" .

    end.

    v_qty_aa = v_qty_aa + xxcwo_start_wip * xxcwod_bom_qty  .
    v_qty_bb = v_qty_bb + xxcwo_rct * xxcwod_bom_qty  .
    v_qty_cc = v_qty_cc + xxcwo_iss * xxcwod_bom_qty  .
    v_qty_dd = v_qty_dd + xxcwo_end_wip * xxcwod_bom_qty  .


    if last-of(xxcwod_sub_part) then do:
        /*disp 
         xxcwo_site            label "地点"
         xxcwod_sub_part       label "原材料"
         v_desc1               label "材料名称"
         xxcwo_part            label "工单发料"
         xxcwo_par             label "完成品"
         v_desc2               label "完成品名称"

	     v_qty_aa              label "期初库存"
         v_qty_bb              label "入库数量"
         v_qty_cc              label "领料数量"
         v_qty_dd              label "期末库存"
        with frame x .*/
        PUT UNFORMATTED		xxcwo_site ";"	.
        PUT UNFORMATTED		xxcwod_sub_part ";"	.
        PUT UNFORMATTED		v_desc1 ";"	.
        PUT UNFORMATTED		xxcwo_par ";"	.
        PUT UNFORMATTED		v_desc2 ";"	.
        PUT UNFORMATTED		v_qty_aa  ";"	.
        PUT UNFORMATTED		v_qty_cc ";"	.
        PUT UNFORMATTED		v_qty_bb ";"	.
        PUT UNFORMATTED		v_qty_dd 	.
        put skip .
    end.


end. /*for each xxcwo_wkfl*/






    for each xxcwo_wkfl 
        where xxcwo_domain = global_domain 
        and xxcwo_key      = v_key   :  
        delete xxcwo_wkfl . 
    end .

    for each xxcwod_wkfl  
        where xxcwod_domain = global_domain 
        and xxcwod_key      = v_key   : 
        delete xxcwod_wkfl . 
    end .

	end. /* mainloop: */
/* {mfrtrail.i}  REPORT TRAILER  */
{mfreset.i}
end.  /* REPEAT */
{wbrp04.i &frame-spec = a}

/*--------------------------------------------------------------------------------------------------------*/


                
                
         
procedure process_report:
    define input  parameter vv_part as character .
    define input  parameter vv_eff_date as date format "99/99/99" .
    define input  parameter vv_site as character .
    
    define var  vv_comp like ps_comp no-undo.
    define var  vv_level as integer no-undo.
    define var  vv_record as integer extent 100.
    define var  vv_qty as decimal initial 1 no-undo.
    define var  vv_save_qty as decimal extent 100 no-undo.
    define var  vv_pm_code like ptp_pm_code no-undo .
    define var  vv_recno    like recno .
    
    



    assign vv_level = 1 vv_qty = 1 vv_comp = vv_part  /*vv_site = ""*/ .

    find first ps_mstr use-index ps_parcomp where ps_domain = global_domain and ps_par = vv_comp  no-lock no-error .
    repeat:        
               if not avail ps_mstr then do:                        
                     repeat:  
                        vv_level = vv_level - 1.
                        if vv_level < 1 then leave .                    
                        find ps_mstr where recid(ps_mstr) = vv_record[vv_level] no-lock no-error.
                        vv_comp  = ps_par.  
                        vv_qty = vv_save_qty[vv_level].            
                        find next ps_mstr use-index ps_parcomp where ps_domain = global_domain and  ps_par = vv_comp  no-lock no-error.
                        if avail ps_mstr then leave .               
                    end.
                end.  /*if not avail ps_mstr*/
            
                if vv_level < 1 then leave .
                vv_record[vv_level] = recid(ps_mstr).                
                
                
                if (ps_end = ? or vv_eff_date <= ps_end) then do :
                       vv_save_qty[vv_level] = vv_qty.
                       
                
                       vv_pm_code = "" .   
                       find ptp_det where ptp_domain = global_domain and ptp_part = ps_comp and ptp_site = vv_site no-lock no-error .
                       if avail ptp_det then do :
                             vv_pm_code = ptp_pm_code  .                             
                       end.
                       else do:
                            find pt_mstr where pt_domain = global_domain and pt_part = ps_comp no-lock no-error .
                            vv_pm_code = if avail pt_mstr then pt_pm_code else "" .
                       end.
                       
                       /*if ps_ps_code = "x" then vv_pm_code = "P"  . */

                              
                              
                     if vv_pm_code <> "P" then do:
                               vv_comp  = ps_comp .
                               vv_qty = vv_qty * ps_qty_per * (100 / (100 - ps_scrp_pct)).
                               vv_level = vv_level + 1.
                               vv_recno = recid(ps_mstr) .

                               find first ps_mstr use-index ps_parcomp where ps_domain = global_domain and ps_par = vv_comp  no-lock no-error.
                               if not avail ps_mstr then do:
                                    find ps_mstr where recid(ps_mstr) = vv_recno  no-lock no-error.
                                    if avail ps_mstr then do:
                                        /*create */
                                        find first temp1 where t1_par = vv_part and t1_comp = ps_comp and t1_site = vv_site no-error.
                                        if not available temp1 then do:
                                            find pt_mstr where pt_domain = global_domain and pt_part = ps_comp no-lock no-error .
                                            create temp1.
                                            assign
                                                t1_par      = caps(vv_part)
                                                t1_comp     = caps(ps_comp)
                                                t1_site     = vv_site
                                                t1_desc1    = (if available pt_mstr then pt_desc1 else "")
                                                t1_desc2    = (if available pt_mstr then pt_desc2 else "")
                                                t1_um       = (if available pt_mstr then pt_um else "")
                                                t1_qty_per  = vv_qty 
                                                .
                                        end.
                                        else t1_qty_per   = t1_qty_per + vv_qty  .  
                                    end.
                               end.

                               
                               find first ps_mstr use-index ps_parcomp where ps_domain = global_domain and ps_par = vv_comp  no-lock no-error.     
                     end. /*if vv_pm_code <> "P"*/
                     else do :
                                /*create */
                                find first temp1 where t1_par = vv_part and t1_comp = ps_comp and t1_site = vv_site no-error.
                                if not available temp1 then do:
                                    find pt_mstr where pt_domain = global_domain and pt_part = ps_comp no-lock no-error .
                                    create temp1.
                                    assign
                                        t1_par      = caps(vv_part)
                                        t1_comp     = caps(ps_comp)
                                        t1_site     = vv_site
                                        t1_desc1    = (if available pt_mstr then pt_desc1 else "")
                                        t1_desc2    = (if available pt_mstr then pt_desc2 else "")
                                        t1_um       = (if available pt_mstr then pt_um else "")
                                        t1_qty_per  = vv_qty * ps_qty_per * (100 / (100 - ps_scrp_pct))
                                        .
                                end.
                                else t1_qty_per   = t1_qty_per + vv_qty * ps_qty_per * (100 / (100 - ps_scrp_pct)) .  
                               find next ps_mstr use-index ps_parcomp where ps_domain = global_domain and ps_par = vv_comp no-lock no-error.
                     end. /*if vv_pm_code = "P"*/      
                end.   /*if (ps_end = ? or vv_eff_date <= ps_end)*/
                else do:
                      find next ps_mstr use-index ps_parcomp where ps_domain = global_domain and ps_par = vv_comp  no-lock no-error.
                end.  /* not (ps_end = ? or vv_eff_date <= ps_end)  */
    
    
    end. /*repeat:*/   

end procedure.
