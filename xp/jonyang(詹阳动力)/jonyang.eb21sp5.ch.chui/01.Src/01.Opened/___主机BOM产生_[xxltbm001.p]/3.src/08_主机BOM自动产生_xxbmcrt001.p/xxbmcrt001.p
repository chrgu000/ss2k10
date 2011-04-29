/*xxbmcrt001.p 主机BOM产生程式,按每个零件的批号产生BOM*/
/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 100907.1  By: Roger Xiao */


/* DISPLAY TITLE */
{mfdtitle.i "100907.1"}

define new shared var wonbr like wo_nbr no-undo.
define new shared var wolot like wo_lot no-undo.
define new shared var vleave as logical no-undo.

define var fieldname  like code_fldname no-undo.
fieldname = "PT_UM" .
define var v_um       like pt_um no-undo.
define var v_umx      as logical no-undo.

define var v_retry    as logical no-undo.
define var v_ii       as integer no-undo.
define var v_jj       as integer no-undo.
define var v_kk       as integer no-undo.
define var v_wo_tmp   like wo_lot no-undo.
define var v_yn       as logical no-undo.
define var v_hide     as logical no-undo.
define var v_sn       as char    no-undo.

define var v_qty_left as decimal no-undo.  
define var v_qty_crt  as decimal no-undo.
define var v_qty_bom  as decimal no-undo.
define var v_old_wolot like wo_lot no-undo. 

define var v_zp_wod_part like wod_part    extent 50.
define var v_zp_wod_qty  like wod_qty_iss extent 50.

define temp-table temp1    /*主机入库记录*/
    field t1_wolot like wo_lot 
    field t1_part  like tr_part
    field t1_lot   like tr_serial
    field t1_qty   like tr_qty_loc 
    .

define temp-table temp2    /*主机工单发料记录*/
    field t2_wolot     like wo_lot 
    field t2_part      like tr_part
    field t2_qty_iss   like tr_qty_loc 
    
    field t2_part_by   like tr_part     /*原件:消耗顺序*/
    field t2_qty_bom   like wod_bom_qty /*单位用量*/
    field t2_sub_type  as logical       /*普通替代 or 联合替代*/
    .

define temp-table temp3   /*ZP件待扣工单明细,getfrom优先分配表xpre_det*/
    field t3_wolot  like wo_lot
    field t3_part   like wo_part 
    field t3_lot    like ld_lot
    field t3_zppart like wo_part
    field t3_zpwo   as char .

define temp-table temp4   /*ZP件扣满,待分摊多发料的工单*/
    field t4_zpwo   like wo_lot  /*是哪个zpwo扣满了*/
    field t4_zppart like wo_part /*是哪个zppart扣满了*/
    field t4_lot    like ld_lot  /*分摊到哪个主机时,扣满的*/
    .

define buffer trbuff for tr_hist .

mainloop:
repeat:
    for each temp1 : delete temp1. end .
    for each temp2 : delete temp2. end .
    for each temp3 : delete temp3. end .
    for each temp4 : delete temp4. end .


    /*输入工单ID*/
    {gprun.i ""xxbmcrt001wo.p"" }
    if vleave = yes then leave mainloop. 

    /*检查工单是否锁定,并锁定它*/
    find first wo_mstr 
        where wo_domain = global_domain 
        and wo_lot      = wolot 
        and wo_nbr      = wonbr 
    exclusive-lock no-wait no-error .
    if not avail wo_mstr then do:
        if locked wo_mstr then do:
            message "警告:此工单ID正被他人占用,请稍后再试.".
            undo,retry.
        end.
        else do:
            message "错误:此工单ID不存在,请重新输入".
            undo,retry.
        end.
    end.
        

    {xxbmcrt001a.i}  /*get-lot-rct* "RCT-WO of 成品工单" */

    {xxbmcrt001b.i}  /*get-part-iss* "ISS-WO of 成品工单" */

    {xxbmcrt001g.i}  /*删除此工单之前产生的BOM,并取消占用明细(xused_,xuse_)的数量*/

    {xxbmcrt001c.i}  /*检查发料状况,ZP工单指定,ZP工单占用明细等,确定是否可以产生主机BOM*/


    createbom:
    do on error undo,retry on endkey undo,leave :
        /******************************************************************************************/
        message "主机BOM正在产生" .

        for each temp1 break by t1_part by t1_lot :
            
            {xxbmcrt001za.i &lot="t1_lot"  &part="t1_part" &wonbr="wonbr" &wolot="wolot" &error="'001'"}  /*产生xbm_mstr*/

            {xxbmcrt001d.i} /*按xpre_det优先分配指定的材料*/

            {xxbmcrt001e.i} /*按单位用量,分配材料(排除xpre_det指定部分)*/

            release xbm_mstr .
            release xbmd_det .
            release xbmzp_det .
        end. /*for each temp1*/

        {xxbmcrt001f.i} /*多发的材料,按单位是否可拆分设定分配*/

        message "主机BOM产生完成" .
    end. /*createbom*/   
end.  /* mainloop */

