/*xxbmcrt001.p ����BOM������ʽ,��ÿ����������Ų���BOM*/
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

define temp-table temp1    /*��������¼*/
    field t1_wolot like wo_lot 
    field t1_part  like tr_part
    field t1_lot   like tr_serial
    field t1_qty   like tr_qty_loc 
    .

define temp-table temp2    /*�����������ϼ�¼*/
    field t2_wolot     like wo_lot 
    field t2_part      like tr_part
    field t2_qty_iss   like tr_qty_loc 
    
    field t2_part_by   like tr_part     /*ԭ��:����˳��*/
    field t2_qty_bom   like wod_bom_qty /*��λ����*/
    field t2_sub_type  as logical       /*��ͨ��� or �������*/
    .

define temp-table temp3   /*ZP�����۹�����ϸ,getfrom���ȷ����xpre_det*/
    field t3_wolot  like wo_lot
    field t3_part   like wo_part 
    field t3_lot    like ld_lot
    field t3_zppart like wo_part
    field t3_zpwo   as char .

define temp-table temp4   /*ZP������,����̯�෢�ϵĹ���*/
    field t4_zpwo   like wo_lot  /*���ĸ�zpwo������*/
    field t4_zppart like wo_part /*���ĸ�zppart������*/
    field t4_lot    like ld_lot  /*��̯���ĸ�����ʱ,������*/
    .

define buffer trbuff for tr_hist .

mainloop:
repeat:
    for each temp1 : delete temp1. end .
    for each temp2 : delete temp2. end .
    for each temp3 : delete temp3. end .
    for each temp4 : delete temp4. end .


    /*���빤��ID*/
    {gprun.i ""xxbmcrt001wo.p"" }
    if vleave = yes then leave mainloop. 

    /*��鹤���Ƿ�����,��������*/
    find first wo_mstr 
        where wo_domain = global_domain 
        and wo_lot      = wolot 
        and wo_nbr      = wonbr 
    exclusive-lock no-wait no-error .
    if not avail wo_mstr then do:
        if locked wo_mstr then do:
            message "����:�˹���ID��������ռ��,���Ժ�����.".
            undo,retry.
        end.
        else do:
            message "����:�˹���ID������,����������".
            undo,retry.
        end.
    end.
        

    {xxbmcrt001a.i}  /*get-lot-rct* "RCT-WO of ��Ʒ����" */

    {xxbmcrt001b.i}  /*get-part-iss* "ISS-WO of ��Ʒ����" */

    {xxbmcrt001g.i}  /*ɾ���˹���֮ǰ������BOM,��ȡ��ռ����ϸ(xused_,xuse_)������*/

    {xxbmcrt001c.i}  /*��鷢��״��,ZP����ָ��,ZP����ռ����ϸ��,ȷ���Ƿ���Բ�������BOM*/


    createbom:
    do on error undo,retry on endkey undo,leave :
        /******************************************************************************************/
        message "����BOM���ڲ���" .

        for each temp1 break by t1_part by t1_lot :
            
            {xxbmcrt001za.i &lot="t1_lot"  &part="t1_part" &wonbr="wonbr" &wolot="wolot" &error="'001'"}  /*����xbm_mstr*/

            {xxbmcrt001d.i} /*��xpre_det���ȷ���ָ���Ĳ���*/

            {xxbmcrt001e.i} /*����λ����,�������(�ų�xpre_detָ������)*/

            release xbm_mstr .
            release xbmd_det .
            release xbmzp_det .
        end. /*for each temp1*/

        {xxbmcrt001f.i} /*�෢�Ĳ���,����λ�Ƿ�ɲ���趨����*/

        message "����BOM�������" .
    end. /*createbom*/   
end.  /* mainloop */

