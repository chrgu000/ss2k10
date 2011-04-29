/* xxscraprp004.p - ���ϵ���ӡ   copy from  xxscraprp002.p Rev:100327.1                                */
/* REVISION: 1.0      Created : 20090903   BY: Roger Xiao  ECO:*090903.1*   */

/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 090903.1  By: Roger Xiao */
/* SS - 100327.1  By: Roger Xiao */  /*����ԭ��Ĵ������͸�Ϊ(QC, and reject) */
/* SS - 100526.1  By: Roger Xiao */  /*���Ӱ�������Ч���ڴ�ӡ*/

/*
1.����Դxlkh_hist,����:���ĳ��û�д�Ʒ,��xlkh_hist�޼�¼,��������������¼��ʾ
2.�����ϵ���������ʵ��Ϊ������ɵĻر�����,������Ч����.
*/


{mfdtitle.i "100526.1"}

/* SS - 100526.1 - B */
define var v_scrap_effdate  like xlkh_scrap_effdate .
define var v_scrap_effdate1 like xlkh_scrap_effdate .
/* SS - 100526.1 - E */

define var date      as date .
define var date1     as date .
define var line      like ln_line.
define var line1     like ln_line.
define var part      like pt_part .
define var part1     like pt_part .
define var rsncode   as char .
define var rsncode1  as char .
define var v_time      as integer format ">>".
define var v_time1     as integer format ">>" .

define var v_qty_oh   like tr_qty_loc .
define var v_qty_prd  like tr_qty_loc .
define var v_rsncode  as char .
define var v_rsndesc  like rsn_desc .
define var v_over     as logical .
define var v_pct      as decimal format ">>>,>>9%".
define var v_qc_type as char .  
define var v_scrap_type as char .  
/* SS - 100327.1 - B 
v_qc_type = "reject" .
v_scrap_type = "reject" .
   SS - 100327.1 - E */
/* SS - 100327.1 - B */
v_qc_type = "QC" .
v_scrap_type = "QC" .
/* SS - 100327.1 - E */

define var site       like pt_site .
define var v_qc_loc   like pt_loc  .


define frame a .
form
    SKIP(.2)
/* SS - 100526.1 - B */
    v_scrap_effdate     colon 18  label "������Ч����"
    v_scrap_effdate1    colon 53  label "��"
/* SS - 100526.1 - E */

    date                colon 18  label "��������"
    date1               colon 53  label "��"
    line                colon 18  label "������"
    line1               colon 53  label "��"      
    part                colon 18  label "������"
    part1               colon 53  label "��"      
    rsncode             colon 18  label "ԭ�����"
    rsncode1            colon 53  label "��"      
    v_time              colon 18  label "����ʱ��"
    v_time1             colon 53  label "��"       
        
skip(2) 
with frame a  side-labels width 80 attr-space.
setFrameLabels(frame a:handle).

{wbrp01.i}
rploop:
repeat:
/* SS - 100526.1 - B */
    if v_scrap_effdate     = low_date then v_scrap_effdate  = ? .
    if v_scrap_effdate1    = hi_date  then v_scrap_effdate1 = ? .
/* SS - 100526.1 - E */

    if date     = low_date then date  = ? .
    if date1    = hi_date  then date1 = ? .
    if line1    = hi_char  then line1 = "" .
    if part1    = hi_char  then part1 = "" .
    if rsncode1 = hi_char  then rsncode1 = "" .
    if v_time1  = 24       then v_time1 = 0 .
    
    update 
/* SS - 100526.1 - B */
        v_scrap_effdate
        v_scrap_effdate1
/* SS - 100526.1 - E */

        date     
        date1    
        line     
        line1    
        part     
        part1    
        rsncode  
        rsncode1 
        v_time     
        v_time1    
    with frame a.

/* SS - 100526.1 - B */
    if v_scrap_effdate     = ?  then v_scrap_effdate      =  low_date.
    if v_scrap_effdate1    = ?  then v_scrap_effdate1     =  hi_date .
/* SS - 100526.1 - E */

    if date     = ?  then date      =  low_date.
    if date1    = ?  then date1     =  hi_date .
    if line1    = "" then line1     =  hi_char .
    if part1    = "" then part1     =  hi_char .
    if rsncode1 = "" then rsncode1  =  hi_char .
    if v_time1  = 0  then v_time1   =  24      .


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
/*put  "test_begin_time: " string(time,"hh:mm:ss") skip(3). */

{mfphead.i}



for each xlkh_hist 
    where xlkh_domain = global_domain 
/* SS - 100526.1 - B */
    and xlkh_scrap_effdate >= v_scrap_effdate and xlkh_scrap_effdate <= v_scrap_effdate1
/* SS - 100526.1 - E */
    and ((xlkh_date >= date and xlkh_date <= date1 ) or xlkh_date = ?)
    and xlkh_line >= line and xlkh_line <= line1 
    and xlkh_part >= part and xlkh_part <= part1 
    and (if index(xlkh_barcode,"qc") <> 0 
             then (xlkh_barcode >= "x" + xlkh_line + "qc" + rsncode and xlkh_barcode <= "x" + xlkh_line + "qc" + rsncode1) 
             else  (xlkh_barcode >= "x" + xlkh_line + rsncode and xlkh_barcode <= "x" + xlkh_line + rsncode1)
        )
    and xlkh_time >= v_time * 3600 and xlkh_time <= v_time1 * 3600
    and xlkh_qc_qty > 0     /*��Ʒ��Ϊ���*/ 
    and xlkh_scrap_date <> ? /*�Ѿ��������޵�*/
    and xlkh_scrap_qty <> 0  /*���޺��б��ϵ�*/
    no-lock
/* SS - 100526.1 - B */
    break by xlkh_scrap_effdate
/* SS - 100526.1 - E */

    with frame x width 300:

    find first pt_mstr where pt_domain = global_domain and pt_part = xlkh_part no-lock no-error.

    v_rsncode = xlkh_scrap_rsn .
    find first rsn_ref where rsn_domain = global_domain and  ( rsn_type = v_scrap_type or rsn_type = "Reject") and rsn_code = v_rsncode no-lock no-error.
    v_rsndesc = if avail rsn_ref  then rsn_desc else "" .

    v_qty_prd = 0 .
    for each tr_hist 
        use-index tr_date_trn 
        where tr_domain = global_domain 
        and tr_date     = xlkh_date  /*tr_date or tr_effdate ??? */
        and tr_type     = "rct-wo" 
        and tr_part     = xlkh_part 
        and tr_site     = xlkh_site
      /*and tr_loc      = xlkh_line*/   /**��Ʒ/��Ʒ��λ<>prod_line*/
    no-lock:
        v_qty_prd = v_qty_prd + tr_qty_loc .
    end. /*for each tr_hist*/

    v_over  = if xlkh_scrap_qty > 60 then yes else no .
    v_pct   = if v_qty_prd <> 0 then 100 * (xlkh_scrap_qty / v_qty_prd) else 0 .

    disp 
/* SS - 100526.1 - B */
        xlkh_scrap_effdate           label "������Ч"
/* SS - 100526.1 - E */
        xlkh_date                    label "��������"
        xlkh_line                    label "������"
        xlkh_part                    label "�����"
        pt_desc1 when avail pt_mstr  label "���˵��1"
        pt_desc2 when avail pt_mstr  label "˵��2"
        pt_um    when avail pt_mstr  label "UM"
        v_qty_prd                    label "��������"
        xlkh_scrap_qty               label "��������"
        v_rsncode                    label "����ԭ��"
        v_rsndesc                    label "ԭ������"
        v_over                       label "�쳣"
        v_pct                        label "������%"

     
    with frame x  .






end. /*for each xlkh_hist*/

/*put skip(3) "test_end_time: " string(time,"hh:mm:ss") . */

end. /* mainloop: */
{mfrtrail.i}  /* REPORT TRAILER  */
end.  /* REPEAT */
{wbrp04.i &frame-spec = a}
