/*
Function : Check Stock Balance for rep backflush
Design By: Micho / Sam Song
Input Paramter :
           V1002 - Site
           V1100 - Productin Line = Emploneer No
	   V1203 - Effective Date
	   V1300 - Finished Goods
	   V1310 - Operation 
	   V1600 - Finished Qty
	   
Output Paramter :
           ErrorMsg ( IF ErrorMsg = "" then Pass Check Else Show Error Message )

*/
/* BY: Micho Yang         DATE: 11/01/06  ECO: *SS - 20061101.1*  */
/*
此次修改的内容：
1。在判断短缺量的时候，不限制以‘N’开头的图号。
2。在输入回冲数量的时候，如果存在有短缺量并且以‘N’开头的图号，将回冲数量修改为0
3. CHECK 负数回冲 
 */
If substring ( V1600,1,1) = "Q" then V1600 = substring( V1600 , 2,15 ). 
If V1600 = "" OR V1600 = "-" OR V1600 = "." OR V1600 = ".-" OR V1600 = "-." then do:
	display skip "CAN NOT EMPTY  " @ WMESSAGE NO-LABEL with fram F1600.
	pause 0 before-hide.
	undo, retry.
end.
DO i = 1 to length(V1600).
	If index("0987654321.-", substring(V1600,i,1)) = 0 then do:
	display skip "Format  Error  " @ WMESSAGE NO-LABEL with fram F1600.
	pause 0 before-hide.
	undo, retry.
	end.
end.
Def variable ErrorMsg as char format "X(30)".
ErrorMsg = "".
define variable global_user_lang_dir as char format "x(40)" init "/app/mfgpro/eb2/ch/".
define shared variable global_gblmgr_handle as handle no-undo.
run pxgblmgr.p persistent set global_gblmgr_handle.

/******************** SS - 20061018.1 - B ********************/
{xxbmpkiq.i "new"}
DEF VAR v_qty AS DECIMAL.

for each tta6bmpkiq :
    delete tta6bmpkiq .
end.

{gprun.i ""xxbmpkiq.p"" "(
           INPUT V1300 ,               /* 父零件 "V1300" */
           INPUT V1203,                /* 日期 "V1203" */
           INPUT V1002 ,               /* 地点 "V1002" */
           INPUT dec(V1600) ,          /* 数量 "V1600" */
           INPUT int(V1310)            /* 工序 "V1310" */
           )"  }

v_qty = 0.
FOR EACH tta6bmpkiq :
    v_qty = tta6bmpkiq_qty .
    FOR EACH ld_det WHERE ld_site = V1002 
                      AND ld_loc  = V1100      /* "V1100" */
                      AND ld_part = tta6bmpkiq_part 
                      NO-LOCK BY ld_lot :
        v_qty = v_qty - ld_qty_oh .
        IF v_qty <= 0 THEN LEAVE .
    END.

    /******************** SS - 20061101.1 - B ********************/
    /*
    IF v_qty > 0 THEN DO:
        ErrorMsg = tta6bmpkiq_part + " 短缺 " + STRING(v_qty) + 
                   " 个 " .
    END.
    */
    IF v_qty > 0 AND NOT (tta6bmpkiq_part BEGINS "N") THEN DO:
        ErrorMsg = tta6bmpkiq_part + " 短缺 " + STRING(v_qty) + 
                           " 个 " .
    END.
    /******************** SS - 20061101.1 - E ********************/

    /******************** SS - 20070117.1 - B ********************/

    if tta6bmpkiq_qty < 0 and ErrorMsg = "" then do:
       find first pt_mstr where pt_part = tta6bmpkiq_part  no-lock.

       if pt_lot_ser = "L" then do:  /* L control , Inventory > 0  , Lot = "" */

       find first ld_det WHERE ld_site = V1002 
                         AND ld_loc  = V1100      /* "V1100" */
                         AND ld_part = tta6bmpkiq_part 
			 AND ld_qty_oh <> 0 and ld_lot = "" 
			 no-lock no-error.
       if AVAILABLE(ld_det) then ErrorMsg = trim ( tta6bmpkiq_part) + "有非法库存".
       end. 
       
       if pt_lot_ser = "L" then do: /* L control , Inventory = 0 and ld_lot <> "" */

       find first ld_det WHERE ld_site = V1002 
                         AND ld_loc  = V1100      /* "V1100" */
                         AND ld_part = tta6bmpkiq_part 
			 AND ld_qty_oh <> 0 and ld_lot <> "" 
			 no-lock no-error.
       if NOT AVAILABLE(ld_det) then ErrorMsg = trim ( tta6bmpkiq_part) + "没有库存".
       end. 

       if pt_lot_ser = "" then do: /* Not L control , Inventoy = 0 */

       find first ld_det WHERE ld_site = V1002 
                         AND ld_loc  = V1100      /* "V1100" */
                         AND ld_part = tta6bmpkiq_part 
			 AND ld_qty_oh <> 0  
			 no-lock no-error.
       if NOT AVAILABLE(ld_det) then ErrorMsg = trim ( tta6bmpkiq_part) + "没有库存".
       end. 
    

    end.

    /******************** SS - 20070117.1 - E ********************/
END.
/******************** SS - 20061018.1 - E ********************/

if ErrorMsg <> "" then do:
   display skip ErrorMsg @ WMESSAGE NO-LABEL with fram F1600.
                pause 0 before-hide.
                undo, retry.
end.
