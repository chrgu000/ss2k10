/**
 @File: xkyhdin.p
 @Description: 采购单到货输出
 @History: 
**/

{mfdtitle.i "ao"}

define variable ponbr  like po_nbr.
DEFINE VARIABLE err    AS   INTEGER .
DEFINE VARIABLE event  AS   CHARACTER FORMAT "x(20)" .

define variable postatus as char.
define variable v_order_id AS CHARACTER FORMAT "X(300)" INITIAL "".
define variable typeid as   char.
define variable updstat    as char.

{xpsqldef.i "new"}

FORM 
        
    SKIP(.3)  
    ponbr       COLON 30  
    SKIP(.3)  
WITH FRAME a SIDE-LABELS WIDTH 80 ATTR-SPACE THREE-D .
setFrameLabels(frame a:handle).

form
with down frame b width 80 no-labels three-d.

/*连接sql数据库*/
CREATE "ADODB.Connection" AdoConn.
{gprun.i ""xpdbconn.p""}
IF ERROR-STATUS:NUM-MESSAGES >= 1 THEN DO:
    MESSAGE "无法建立数据库连接，请联系系统管理员！" .
    PAUSE.
    LEAVE.
END.


OUTPUT STREAM OUTSTR TO "PONOTE.log".

REPEAT ON ERROR UNDO,LEAVE : 
   
    clear frame a all no-pause.
    
    update ponbr with frame a.

    if ponbr = "" then do:
       message "请输入采购单号".
       undo,retry.
    end.
    
    HIDE MESSAGE NO-PAUSE.

    find first po_mstr WHERE po_nbr = ponbr EXCLUSIVE-LOCK no-error.
    if not avail po_mstr then do:
       message "采购单不存在".
       undo, retry.
    end.
    
    if po_user1 = "published" then do:
       message "采购单没有发布".
    end.
    
    if po_user2 <> "" then do:
       message "此采购单到货通知已经发出".
       undo, retry.
    end.

    if po_stat = "x" then do:
       message "采购单已经被取消".
       undo, retry.
    end.
    
    if po_stat = "c" then do:
       message "采购单已经关闭".
       undo,retry.
    end.
    
    postatus = "GET".

    IF po_nbr begins "RE" THEN DO :
        typeid = "RO" .
    END.
    ELSE DO :
        typeid = "PO" .
    END.
    
    err = 0.
    
    SQLStr = "BEGIN TRANSACTION".
    {xpadoexe.i}

    SQLStr = "select STR(order_id) from order_header where order_type_id = '" + typeid + "' and qad_order_id = '" + po_nbr + "'".
    {xpadoexe.i}	

    if integer(adors:recordcount) <> 0 then do:
       v_order_id = String(AdoRs:FIELDS:ITEM(0):Value).

       /************************
       /* 更新订单状态 */
       SQLStr = "select order_id from po_order where Order_Id = " + v_order_id .
       {xpadoexe.i}   
       IF INTEGER(AdoRs:RecordCount) <> 0 THEN DO:
           SQLStr = "Update po_order set " + 
                       " status ='" + postatus  + "'" + 
                       " where Order_Id = " + v_order_id . 
           {xpadoexe.i} 
      
       end. /*update header*/
       ************************/
           SQLStr = "Update po_order set " + 
                       " status ='" + postatus  + "'" + 
                       " where Order_Id = " + v_order_id . 
           {xpadoexe.i} 
    end.  
    
    IF err <> 0 THEN DO :
       SQLStr = "Rollback TRANSACTION".
       {xpadoexe.i} 
       message "失败"  .
       
    END.
    else do:
       SQLStr = "COMMIT TRANSACTION".
       {xpadoexe.i}
       message "成功"  .
    end.
        
    IF err = 0 THEN po_user2 = "GET" .
    
    
end. /*repeat*/

OUTPUT STREAM OUTSTR CLOSE.
AdoConn:CLOSE.
RELEASE OBJECT AdoConn.



