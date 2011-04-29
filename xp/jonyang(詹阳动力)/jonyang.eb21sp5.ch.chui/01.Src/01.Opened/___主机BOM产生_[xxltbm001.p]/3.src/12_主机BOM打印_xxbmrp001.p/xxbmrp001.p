/* xxbmrp001.p - 主机BOM打印程式                                                                      */
/*----rev history-------------------------------------------------------------------------------------*/
/* REVISION: 100907.1  Created On: 20100907   BY: Roger Xiao  ECO:*100907.1*   */



{mfdtitle.i "100907.1"}

define var serial  like ld_lot format "x(12)".
define var serial1 like ld_lot format "x(12)".
define var part    like ld_part .
define var part1   like ld_part .
define var wonbr   like wo_nbr .
define var wonbr1  like wo_nbr .
define var wolot   like wo_lot .
define var wolot1  like wo_lot .
define var v_desc1 like pt_desc1 format "x(48)".
define var v_desc2 like pt_desc2 .
define var v_um    like pt_um .
define var v_rep   as char format "x(1)" .
define var v_ii    as integer .
define var linecount as integer .

define var v_hide as logical .

define temp-table temp1 no-undo
    field t1_part     like wo_part  
    field t1_desc     like pt_desc1 format "x(48)"  
    field t1_um       like pt_um 
    field t1_qty      like wod_bom_qty 
    field t1_sn       as char format "x(18)"
    field t1_hide     as logical     
    .



form
    SKIP(.2)
    serial        colon 15 label "主机号"
    serial1       colon 48 label "至"
    part          colon 15 label "物料号"
    part1         colon 48 label "至"

    skip(2)
    v_hide        colon 15 label "包含隐藏件"
    /*
    wonbr         colon 18
    wonbr1        colon 53
    wolot         colon 18
    wolot1        colon 53
    */

skip(2) 
with frame a  side-labels width 80 attr-space.
setFrameLabels(frame a:handle).

{wbrp01.i}
repeat:
    if wonbr1   = hi_char  then wonbr1    = "".
    if wolot1   = hi_char  then wolot1    = "".
    if part1    = hi_char  then part1     = "".
    if serial1  = hi_char  then serial1   = "".
    
    update 
        serial   
        serial1  
        part     
        part1 
        v_hide 

        /*
        wonbr    
        wonbr1   
        wolot    
        wolot1      
        */   
    with frame a.

    if wonbr1    = "" then wonbr1     =  hi_char .
    if wolot1    = "" then wolot1     =  hi_char .
    if part1     = "" then part1      =  hi_char .
    if serial1   = "" then serial1    =  hi_char .

    /* PRINTER SELECTION */
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

/*mfphead2宽度80, mfphead宽度132*/
{mfphead2.i}


for each xbm_mstr
        where xbm_domain = global_domain 
        and xbm_lot    >= serial and xbm_lot    <= serial1 
        and xbm_part   >= part   and xbm_part   <= part1 
        and xbm_wolot  >= wolot  and xbm_wolot  <= wolot1 
        and xbm_status  = ""
    no-lock break by xbm_lot  :
    
    empty temp-table temp1 .

    for each xbmd_det 
        where xbmd_domain = global_domain 
        and   xbmd_lot    = xbm_lot 
        and   xbmd_par    = xbm_part
        and   xbmd_wolot  = xbm_wolot
        no-lock :

        find first xbmzp 
            where xbmzp_domain = global_domain 
            and   xbmzp_lot    = xbm_lot 
            and   xbmzp_par    = xbm_part
            and   xbmzp_wolot  = xbm_wolot
            and   xbmzp_zppart = xbmd_comp 
        no-lock no-error .
        if avail xbmzp_det then next .

        find first temp1 
            where t1_part = xbmd_comp 
        no-error .
        if not avail temp1 then do:
            find first pt_mstr where pt_domain = global_domain and pt_part = xbmd_comp no-lock no-error.
            
            create temp1 .
            assign 
                t1_part = xbmd_comp 
                t1_sn   = xbmd_sn
                t1_desc = if avail pt_mstr then trim(pt_Desc1) + trim(pt_desc2) else "" 
                t1_um   = if avail pt_mstr then pt_um else ""  
                t1_hide = if (xbmd_hide = "Y" or pt__chr01 = "Y") then yes else no  
                .
        end.
        t1_qty  = t1_qty + xbmd_qty_bom  .

    end. /*for each xbmd_det*/
    for each xbmzp_det 
        where xbmzp_domain = global_domain 
        and   xbmzp_lot    = xbm_lot 
        and   xbmzp_par    = xbm_part
        and   xbmzp_wolot  = xbm_wolot
        no-lock :

        find first temp1 
            where t1_part = xbmzp_comp 
        no-error .
        if not avail temp1 then do:
            find first pt_mstr where pt_domain = global_domain and pt_part = xbmzp_comp no-lock no-error.
            
            create temp1 .
            assign 
                t1_part = xbmzp_comp 
                t1_sn   = xbmzp_sn
                t1_desc = if avail pt_mstr then trim(pt_Desc1) + trim(pt_desc2) else "" 
                t1_um   = if avail pt_mstr then pt_um else ""  
                t1_hide = if (xbmzp_hide = "Y" or pt__chr01 = "Y") then yes else no 
                .
        end.
        t1_qty = t1_qty + xbmzp_qty_bom .

    end. /*for each xbmzp_det*/

    form 
       v_ii            label "序号" format ">>>9"
       t1_part         label "物料号"
       t1_um           label "单位"
       t1_qty          label "每件需求量"
       t1_desc         label "品名规格"
       t1_sn           label "序列号"
       /*
       v_rep           label "替"*/
    with frame x1 with width 200 down .


    if first-of(xbm_lot) then do:
        find first pt_mstr where pt_domain = global_domain and pt_part = xbm_part no-lock no-error .
        v_desc1 = if avail pt_mstr then right-trim(pt_desc1) + left-trim(pt_desc2) else "" .
        v_um    = if avail pt_mstr then pt_um    else "" .

        
        disp 
            xbm_part @ t1_part
            v_desc1  @ t1_desc
            v_um     @ t1_um
        with frame x1 .
        down 1 with frame x1 .
        disp 
            "主机号:" + xbm_lot   @ t1_part 
            "工单ID:" + xbm_wolot @ t1_desc
        with frame x1 .
        down 2 with frame x1 .

    end. /*if first-of(*/

    v_ii = 0 . 
    for each temp1 
        where (t1_hide = no or v_hide = yes )
        break by t1_part :

        v_ii = v_ii + 1 .
        disp
            v_ii  
            t1_part 
            t1_desc 
            t1_um   
            t1_qty  
        with frame x1 .
        down 1 with frame x1.
    end.

    if last-of(xbm_lot) then do:
        if page-size - line-counter >= 2 then do:
            linecount = 0 .
            do linecount = 1 to (page-size - line-counter):
                put skip(1).
            end.
        end.
        page .
    end.

end. /*for each xbm_mstr*/

end. /* mainloop: */
{mfrtrail.i}  /* REPORT TRAILER  */
end.  /* REPEAT */
{wbrp04.i &frame-spec = a}
