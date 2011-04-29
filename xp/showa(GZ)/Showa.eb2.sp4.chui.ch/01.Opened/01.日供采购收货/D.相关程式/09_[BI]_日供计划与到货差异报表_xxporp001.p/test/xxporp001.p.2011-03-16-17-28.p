/*xxporp001.p     */
/* REVISION: 110314.1   Created On: 20110314   By: Softspeed Roger Xiao                               */
/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 110314.1  By: Roger Xiao */
/*-Revision end---------------------------------------------------------------*/

{mfdtitle.i "110314"}

define var v_prgname   like execname no-undo.

define var v_pt_draw   like pt_draw .
define var v_pt_Desc   like pt_desc1 .
define var v_qty_ord   like pod_qty_ord .
define var v_qty_rct   like pod_qty_rcvd .
define var v_qty_today like pod_qty_rcvd .
define var v_qty_left  like pod_qty_rcvd .
define var v_userid    like global_userid .
define var v_vdname    like  ad_name .
define var v_newpo     as  char format "x(2)" .



define var rdate           like prh_rcp_date no-undo.
define var rdate1          like prh_rcp_date no-undo.
define var part            like pt_part no-undo.
define var part1           like pt_part no-undo.
define var nbr             like pt_site no-undo.
define var nbr1            like pt_site no-undo.
define var vend            like po_vend no-undo.
define var vend1           like po_vend no-undo.



form
    SKIP(.2)

    rdate            colon 15
    rdate1           colon 49 label "To"
    vend             colon 15
    vend1            colon 49 label "To"
    nbr              colon 15
    nbr1             colon 49 label "To"
    part             colon 15
    part1            colon 49 label "To"

skip(1) 
with frame a  side-labels width 80 attr-space.
setFrameLabels(frame a:handle).

{wbrp01.i}
repeat:

    if part1    = hi_char  then part1 = "" .    
    if vend1    = hi_char  then vend1 = "" .    
    if nbr1     = hi_char  then nbr1  = "" .    

    if rdate1   = hi_date  then rdate1 = ? .  
    if rdate    = low_date then rdate  = ? .

        update 
            rdate   
            rdate1     
            vend   
            vend1
            nbr 
            nbr1 
            part    
            part1   
        with frame a.
    if part1    = "" then part1 =  hi_char .    
    if vend1    = "" then vend1 =  hi_char .    
    if nbr1     = "" then nbr1  =  hi_char .    
                                           
    if rdate1   =  ? then rdate1 = hi_date .  
    if rdate    =  ? then rdate  = low_date.

    /*BI报表专用,不用再改程式名*/
    if index(execname,".p") <> 0 then v_prgname = entry(1,execname,".p").
    else do:
        message "错误:无效程式名格式" execname .
        undo,retry.
    end.

    /*BI报表专用,不要换页符: &pagedFlag = "nopage"  ,这样好像不能再输出到page*/
    {gpselout.i &printType = "printer"
                &printWidth = 132
                &pagedFlag = "nopage"
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

/*
put unformatted "#def reportpath=$/bi报表的路径/" + v_prgname  skip.
put unformatted "#def :end" skip.
*/



export delimiter "~011"
"收货日期"
"供应商ID"
"供应商Nm"
"采购单号"
"自动产生"
"项次"    
"零件图号"
"图纸图号"
"零件名称"
"采购员" 
"订购数量"
"累计到货"
"今日到货"
"进度"
"收货员"  
.


for each prh_hist 
    where prh_rcp_date >= rdate and prh_rcp_date <= rdate1 
    and prh_vend  >= vend and prh_vend <= vend1 
    and prh_nbr   >= nbr  and prh_nbr  <= nbr1 
    and prh_part  >= part and prh_part <= part1
    no-lock
    break by prh_rcp_date by prh_vend by prh_nbr by prh_line :
    
    if first-of(prh_line) then do:
        v_qty_today = 0 .
    end.

    v_qty_today = v_qty_today + prh_rcvd .

    if last-of(prh_line) then do:
        find first pt_mstr where pt_part = prh_part no-lock no-error.
        v_pt_draw = if avail pt_mstr then pt_draw  else "" .
        v_pt_Desc = if avail pt_mstr then pt_desc1 else "" .

        find first pod_Det where pod_nbr = prh_nbr and pod_line = prh_line no-lock no-error.
        v_qty_ord = if avail pod_det then pod_qty_ord else 0.
        v_qty_rct = if avail pod_det then pod_qty_rcvd else 0.
        v_qty_left = (v_qty_ord - v_qty_rct) .
        v_newpo   = if avail pod_det and pod_so_job = "AC" then "*" else "" .

        find first ad_mstr where ad_addr = prh_vend and ad_type = "supplier" no-lock no-error.
        v_vdname = if avail ad_mstr then ad_name else "" .

        find first tr_hist
            use-index tr_nbr_eff
            where tr_nbr = prh_nbr 
            and tr_effdate = prh_rcp_date
            and tr_line  = prh_line 
            and tr_part  = prh_part
            and tr_lot   = prh_receiver 
            and tr_type  = "rct-po"
        no-lock no-error.
        v_userid = if avail tr_hist then tr_userid else "" .

/*        put unformatted 
            prh_rcp_date ";"    /*收货日期*/  
            prh_vend     ";"    /*供应商ID*/  
            v_vdname     ";"    /*供应商Nm*/ 
            prh_nbr      ";"    /*采购单号*/  
            v_newpo      ";"    /*自动产生*/  
            prh_line     ";"    /*项次    */  
            prh_part     ";"    /*零件图号*/  
            v_pt_draw    ";"    /*图纸图号*/  
            v_pt_desc    ";"    /*零件名称*/  
            prh_buyer    ";"    /*采购员  */  
            v_qty_ord    ";"    /*订购数量*/  
            v_qty_rct    ";"    /*累计到货*/  
            v_qty_today  ";"    /*今日到货*/  
            v_qty_left   ";"    /*进度    */  
            v_userid     ";"    /*收货员  */  
            skip .
*/

export delimiter "~011"
    prh_rcp_date
    prh_vend    
    v_vdname    
    prh_nbr     
    v_newpo     
    prh_line    
    prh_part    
    v_pt_draw   
    v_pt_desc   
    prh_buyer   
    v_qty_ord   
    v_qty_rct   
    v_qty_today 
    v_qty_left  
    v_userid    
.

    end. /*if last-of(prh_line)*/
end.  /*for each prh_hist*/


end. /* mainloop: */
/* {mfrtrail.i}  *REPORT TRAILER  */
{mfreset.i}
{pxmsg.i &MSGNUM=9 &ERRORLEVEL=1}
end.  /* REPEAT */
{wbrp04.i &frame-spec = a}
