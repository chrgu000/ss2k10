/* ss - 090911.1 by: jack */

{mfdtitle.i "090929.1 "}

    /*
&SCOPED-DEFINE PP_FRAME_NAME A
      */


DEF VAR fn_error AS CHAR FORMAT "x(30)" INIT "c:\poerr.txt" .
define var v_curr like vd_curr .
define var v_um like pt_um .

define var v_file as char format "x(40)" .
define var quote as char format "x(2)" initial '"' .
define var v_error as logical .


DEF TEMP-TABLE tt 
    FIELD tt_list LIKE pc_list
    field tt_part like pc_part
    field tt_ord_date LIKE po_ord_date
   .

    DEF TEMP-TABLE tt2 
        FIELD tt2_list LIKE pc_list
        FIELD tt2_curr LIKE pc_curr
        FIELD tt2_um LIKE pc_um
        FIELD tt2_part LIKE pc_part
        FIELD tt2_ord_date LIKE po_ord_date
        FIELD tt2_desc  AS CHAR FORMAT "x(30)"   /* �洢������Ϣ*/

    .

FORM
    

    SKIP(1)
    v_file  colon 20    label "�����ļ�"
    fn_error colon 20   label "������Ϣ�ļ�"
    "�����ļ����Զ��ŷָ�;ȥ��������" SKIP
    "�����ļ���ʽ���۸񵥣��ұ𣬵�λ���������������"
    SKIP(1)
    with frame a side-labels width 80 ATTR-SPACE
     .



/* Main Repeat */
mainloop:
repeat :
  view frame a .

  update 
      v_file
      fn_error
      
      with frame a.
  
 
  FOR EACH tt:
      DELETE tt.
  END.
 
  for each tt2 :
    delete tt2 .
  end .

  /*
  MESSAGE "���ڵ�������,��ȴ�......" . 
    */

    
  input from value(v_file) .
  repeat:
      create tt .
      import delimiter ","  tt_list tt_part tt_ord_date .
     
  end .

for each tt where tt_list = "" and tt_part = ""  :
delete tt .
end .

/* tt_flag = 1 ��ʾ�д��� */
for each tt  NO-LOCK where :
    FIND FIRST pt_mstr WHERE pt_part = tt_part NO-LOCK NO-ERROR .
    IF AVAILABLE pt_mstr THEN 
        v_um = pt_um .
    
    FIND FIRST vd_mstr WHERE vd_addr = tt_list NO-LOCK NO-ERROR .
    IF AVAILABLE vd_mstr  THEN
        v_curr = vd_curr .

    FIND FIRST pc_mstr WHERE pc_list = tt_list AND pc_part = tt_part AND pc_curr = v_curr AND pc_um = v_um AND ( ( pc_start <= tt_ord_date )  AND ( pc_expire = ? OR pc_expire >= tt_ord_date) )  NO-LOCK NO-ERROR .
    IF NOT AVAILABLE pc_mstr  THEN DO:
        CREATE tt2 .
           ASSIGN
                tt2_list = tt_list
               tt2_part = tt_part
               tt2_ord_date = tt_ord_date
               tt2_desc =  "�۸񵥲�����"
               .
    END.
     


 end .   /* for each */

output to value(fn_error) .
export delimiter "," "�۸�" "���"  "��������" "˵��" .
for each tt2 no-lock where  :
   export delimiter "," tt2_list tt2_part tt2_ord_date tt2_desc .
end .
output close .
 
  message "������ɣ���鿴�����ļ�"  view-as alert-box .
    
  
   
end. /* Main Repeat */
