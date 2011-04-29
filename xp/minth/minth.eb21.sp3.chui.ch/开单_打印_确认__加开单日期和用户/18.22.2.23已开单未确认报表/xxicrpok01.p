/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 090827.1  By: Roger Xiao */
/* SS - 090901.1  By: Roger Xiao */

/*----rev description---------------------------------------------------------------------------------*/


{mfdtitle.i "090901.1"}

define var v_type  like xic_type .
define var v_type1 like xic_type .
define var v_date  like xic_date .
define var v_date1 like xic_date .
define var v_nbr   like xic_nbr.
define var v_nbr1  like xic_nbr .
define var part    like pt_part .
define var part1   like pt_part .

define var v_desc1 like pt_desc1 .
define var v_desc2 like pt_desc2 .




form
SKIP(.2)
	
v_type        colon 18   label "单据类型"
v_type1       colon 50   label "至"
v_date        colon 18   label "开单日期"
v_date1       colon 50   label "至"
v_nbr         colon 18   label "单据号"
v_nbr1        colon 50   label "至"
part          colon 18   label "零件号"
part1         colon 50   label "至"
	
skip(2) 
with frame a  side-labels width 80 attr-space.
/*setFrameLabels(frame a:handle).*/

{wbrp01.i}
repeat:
 if v_type1 = hi_char then v_type1 = "" .
 if v_date  = low_date then v_date = ? .
 if v_date1 = hi_date  then v_date1 = ? .
 if v_nbr1  = hi_char then v_nbr1 = "" .
 if part1   = hi_char then part1 = "" .

 update 
        v_type 
        v_type1
        v_date
        v_date1
        v_nbr 
        v_nbr1
        part  
        part1 
 with frame a.

 if v_type1 = "" then v_type1 = hi_char .
 if v_nbr1 = ""  then v_nbr1 = hi_char .
 if part1 = ""   then part1 = hi_char .
 if v_date = ?   then v_date  = low_date .
 if v_date1 = ?  then v_date1 = hi_date  .

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


for each xic_det 
    where xic_domain = global_domain 
    and xic_type >= v_type and xic_type  <= v_type1 
    and xic_nbr  >= v_nbr  and xic_nbr   <= v_nbr1
    and ((xic_date >= v_date and xic_date  <= v_date1 )
        or xic_date = ? )
    and xic_part >= part   and xic_part  <= part1 
    and (
            (index("IA,OA,UI,UO",xic_type) = 0 and xic_flag  = no)
            or
            (index("IA,OA,UI,UO",xic_type) <> 0 and xic__log01 = no)
        )
    no-lock break by xic_type by xic_nbr by xic_line 
    with frame x width 300 :


    /*7.2.20等Q1程式未记录已确认到xic_flag,故判断tr_hist*/
    find first tr_hist 
        use-index tr_nbr_eff
        where tr_domain = global_domain 
        and tr_nbr = xic_nbr 
        and tr_part = xic_part
    no-lock no-error.
    if avail tr_hist then next .

    find first pt_mstr where pt_domain = global_domain and pt_part = xic_part no-lock no-error .
    v_Desc1 = if avail pt_mstr then pt_desc1 else  "" .
    v_Desc2 = if avail pt_mstr then pt_desc2 else  "" .
    

    disp xic_type               label "类型"
         xic_nbr                label "单据号"
         xic_line               label "行"
         xic_part               label "零件号"
         v_desc1                label "说明1"
         v_desc2                label "说明2"
         xic_um                 label "UM"
         xic_qty_from           label "开单数量"
         xic_site_fro           label "地点"
         xic_loc_from           label "转出库位"
         /*xic_site_to            label "转入地点" */
         xic_loc_to             label "转入库位"
         xic_print              label "已打印"
         xic_user1              label "用户"
         xic_date               label "开单日期"
    with frame x .
end. /*for each xic_det*/

end. /* mainloop: */
{mfrtrail.i}  /* REPORT TRAILER  */
end.  /* REPEAT */
{wbrp04.i &frame-spec = a}
