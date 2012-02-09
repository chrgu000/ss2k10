/* xxpocima.p ����xxinv_mstr �� xxship_det �Զ�cimload popomt poporc */
/*----rev history-------------------------------------------------------------------------------------*/
/* Revision: eb2sp4      BY: Ching Ye     DATE: 11/26/07  ECO: *SS - 20071126.1* */
/*ԭ��{mfdtitle.i "2+ "}*/

/* SS - 110307.1  By: Roger Xiao */ /*ԭ��{mfdtitle.i "2+ "}, vp_mstr ���ֱ�˰�Ǳ�˰,vp_part : P,M��ͷ���� */
/* SS - 110321.1  By: Roger Xiao */  /*�ջ���ָ����λtemp */
/* SS - 110326.1  By: Roger Xiao */  /*�к�����ˮ��xxship_case,����ԭ��Ʊ�к�xxship_case,���������볤�� */
/* SS - 110408.1  By: Roger Xiao */  /*xxinv_mstr,һ����Ʊ�ſ��ܶ�Ӧ�����Ӧ��*/
/* SS - 120112.1  BY: ZY         */  /*�к�����ˮ��ȡ��,���������볤�� */
/*-Revision end---------------------------------------------------------------*/


{mfdtitle.i "120209.1"}
   
/*�������*/
Define variable Eoutputstatment AS CHARACTER FORMAT "x(200)". 
Define variable Eonetime        AS CHARACTER FORMAT "x(1)" init "N".
Define variable outputstatment AS CHARACTER FORMAT "x(200)".
Define variable woutputstatment AS CHARACTER .
DEFINE VARIABLE UKKEY1 AS CHARACTER INITIAL "xxpocima.p.shippo_ref".
DEF VAR fn_me AS CHAR FORMAT "x(30)" INIT "po-rct-error.txt" .
def var v9000 as char.
define var v_rctdate as date initial today .

def var site like si_site init "gsa01".
def var site1 like   si_site init "gsa01".
def var vend like  po_vend initial "J19X004".
def var vend1 like po_vend initial "J19X004".
def var shipno like xxship_nbr  initial "VT32/443".
def var shipno1 like xxship_nbr initial "VT32/443".
def var shipline like xxship_line init 0.
def var shipline1 like xxship_line init 9999.
def var rcvddate like tr_effdate init today.
def var tmpstr as char.
define variable usection as char format "x(16)".
def var tmpmonth as char.
def var j as integer.
def var i as integer.
def var datestr as char.
def var glbasecurr like gl_base_curr.
DEF VAR v_flag AS LOGICAL.
def var tstr as char.
def var tstr1 as char.
def var errstr as char.
def var ciminputfile  as char.
def var cimoutputfile as char.
def var tmp_order_qty like tr_qty_loc.
def var tmp_lot as char.
def var tmp_cost like tr_qty_loc.
def var tmp_fix_rate as char.
def var tmp_loc like pt_loc.
def var tmp_qty like tr_qty_loc.
def var tmp_part like pt_part.
def var tmp_flagt like pt_part.
def var tmp_line like pod_line.
def var  curr like  po_curr.
DEF VAR jj AS INTEGER .
DEF VAR tmp_ponbr LIKE po_nbr.
DEF VAR v_flagyn AS LOGICAL INIT NO .
DEF VAR v_flagpo AS LOGICAL INIT NO .

define var v_qty_rct like tr_qty_loc .

define variable vtrrecid as recid .

/* ȡ��xxinv_mstr �� xxship_det�е�ԭʼ���� */
DEF TEMP-TABLE pott 
    FIELD pott_shipno LIKE xxship_nbr
    FIELD pott_site LIKE xxinv_site
    FIELD pott_vend LIKE xxinv_vend
    FIELD pott_case like xxship_case
    FIELD pott_part_vend LIKE xxship_part
    FIELD pott_pkg LIKE xxship_pkg
    FIELD pott_qty_unit like xxship_qty_unit
    FIELD pott_qty like xxship_qty
    field pott_inv_pm  like xxinv_pm   /* SS - 110307.1 */

    FIELD pott_status LIKE xxship_status
    FIELD pott_price like xxship_price
    FIELD pott_value like xxship_value
    FIELD pott_curr like xxship_curr
    FIELD pott_rcvddate like tr_effdate
    FIELD pott_line like xxship_line
    FIELD pott_part_zh like xxship_part
    field pott_loc like pt_loc
    field pott_lot like tr_serial
    field pott_fix_rate as char
    field pott_order_type like xxship_type
    field pott_rate like xxinv_rate
    field pott_cost like xxship_price
    .

/* �ڽ���CIMLOAD֮ǰ������ʾҪ��������� */
DEF TEMP-TABLE  tt1a
    field   tt1a_nbr like po_nbr
    field   tt1a_curr like po_curr
    field   tt1a_line like pod_line
    field   tt1a_vend like po_vend
    field   tt1a_fix_rate  as char
    field   tt1a_openqty like pod_qty_ord
    field   tt1a_qty     like pod_qty_ord
    field   tt1a_part like pod_part
    field   tt1a_site like pod_site
    field   tt1a_lot like tr_serial
    field   tt1a_loc like pt_loc
    field   tt1a_flag as char
    field   tt1a_shipno like xxship_nbr
    field   tt1a_rmks like pt_desc1
    field   tt1a_vendpart like pt_part
    field   tt1a_rcvddate LIKE tr_effdate
    FIELD   tt1a_type AS CHAR
    FIELD   tt1a_cost LIKE xxship_price
    .

DEF TEMP-TABLE  tt2
    field   tt2_nbr like po_nbr.

/* ��Ŵ�����Ϣ������ */
DEF TEMP-TABLE tte 
    FIELD tte_type1 AS CHAR
    FIELD tte_type AS CHAR
    FIELD tte_vend LIKE po_vend
    FIELD tte_part LIKE pt_part
    FIELD tte_desc AS CHAR FORMAT "x(120)".

define temp-table shippo_ref
		fields spr_ship_nbr  like xxship_nbr
		fields spr_ship_vend like xxship_vend
		fields spr_ship_line like xxship_line
		fields spr_pod_nbr   like pod_nbr
		fields spr_pod_line  like pod_line
		fields spr_qty       like pod_qty_ord.

/*�������*/
{xxpocimdatain_out.i}  

FORM
    SKIP(1)
    site      colon 20    label "�ص�" 
    site1     colon 50    label   {t001.i}  
    
    vend      colon 20    label "��Ӧ��" 
    vend1     colon 50    label   {t001.i}  

    shipno    colon 20    label "��Ʊ��" 
    shipno1   colon 50    label   {t001.i}  

    shipline  colon 20    label "���" 
    shipline1 colon 50    label   {t001.i} 

    v_rctdate colon 20    label "��������"
    rcvddate  colon 20    label "�ջ���Ч����"
    fn_me     colon 20    label "����������Ϣ�ļ�"

    skip(1)                      
    v_flagpo  colon 20    label "�Ƿ񴴽��µ�PO"
    v_flagyn  colon 20    label "�Ƿ���������ջ�"
    SKIP(1)
    with frame a side-labels width 80 ATTR-SPACE .

/* Main Repeat */
mainloop:
repeat :
    hide all no-pause .
    view frame dtitle .
    view frame a .

    IF site1 = hi_char THEN site1 = "".
    IF vend1 = hi_char THEN vend1 = "".
    IF shipno1 = hi_char THEN shipno1 = "".

    update 
      site
      site1
      vend
      vend1
      shipno
      shipno1
      shipline
      shipline1
      v_rctdate
      rcvddate
      fn_me
      v_flagpo
      v_flagyn
      with frame a.
  
    IF site1 = "" THEN site1 = hi_char.
    IF vend1 = "" THEN vend1 = hi_char.
    IF shipno1 = "" THEN shipno1 = hi_char.

if v_rctdate = ? then do:
    message "����:�������ڲ���Ϊ��,����������.". 
    next-prompt v_rctdate with frame a.
    undo,retry.
end.
if rcvddate = ? then do:
    message "����:�ջ���Ч���ڲ���Ϊ��,����������.". 
    next-prompt rcvddate with frame a.
    undo,retry.
end.



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
               
    {mfphead.i}
    
    /* �����ʱ�� */
    FOR EACH pott:
      DELETE pott.
    END.
    FOR EACH tte:
      DELETE tte.
    END.
    FOR EACH tt1a:
      DELETE tt1a.
    END.


    /* �������,��ִ��cimload */
    {xxpocimcheck.i} 
    
    find first tte no-lock no-error.
    if avail tte then do:
        output to value (fn_me) .
        export delimiter ";" 
            "����" 
            "��������" 
            "�ͻ�����" 
            "����/�����"
            "��������" 
            .

        for each tte :
            export delimiter ";" tte .
        end.
        output close .
    end.

    undo mainloop, retry mainloop.   
end.
 
 
