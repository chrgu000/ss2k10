/*create barcode*/
{mfdeclre.i}
{bcdeclre.i}

DEFINE INPUT PARAMETER part LIKE pt_part.
DEFINE INPUT PARAMETER bcdate AS DATE.
DEFINE INPUT PARAMETER qty AS DECIMAL.
DEFINE INPUT PARAMETER fm AS CHARACTER.
DEFINE INPUT PARAMETER idty AS CHARACTER. /*identity of a vendor*/

DEFINE INPUT PARAMETER site LIKE pt_site.
DEFINE INPUT PARAMETER loc LIKE pt_loc.


DEFINE VARIABLE ord_qty LIKE pt_ord_qty.
DEFINE VARIABLE co_qty LIKE b_co_qty_cur.
DEFINE VARIABLE i AS INTEGER.
DEFINE VARIABLE co_lot LIKE ld_lot.
DEFINE VARIABLE co_code LIKE b_co_code.
DEFINE VARIABLE co_vcode LIKE b_co_vcode.
DEFINE  VARIABLE tmp_code LIKE b_co_code.

/*DEFINE SHARED TEMP-TABLE t_co_mstr
    FIELD t_co_code  AS CHARACTER FORMAT "X(40)"
    FIELD t_co_part  AS CHARACTER FORMAT "X(18)"
    FIELD t_co_um AS CHARACTER FORMAT  "X(8)"
    FIELD t_co_lot AS CHARACTER FORMAT "X(18)"
    FIELD t_co_status AS CHARACTER FORMAT   "X(8)"
    FIELD t_co_desc1 AS CHARACTER FORMAT  "X(24)"
    FIELD t_co_desc2 AS CHARACTER FORMAT  "X(24)"
    FIELD t_co_qty_ini AS DECIMAL FORMAT  "->>,>>9.99"
    FIELD t_co_qty_cur AS DECIMAL format  "->>,>>9.99"
    FIELD t_co_qty_std AS DECIMAL FORMAT   "->>,>>9.99"
    FIELD t_co_ser AS INTEGER FORMAT  "->,>>>,>>9"      
    FIELD t_co_ref AS CHARACTER FORMAT "X(8)"
    FIELD t_co_site LIKE b_co_site
    FIELD t_co_loc LIKE b_co_loc
    FIELD t_co_format AS CHARACTER FORMAT "X(8)".*/
mainloop:
DO ON ERROR UNDO:

  FIND FIRST pt_mstr NO-LOCK WHERE pt_part = part NO-ERROR.
  IF AVAILABLE pt_mstr THEN DO:
   ord_qty = (IF pt_ord_mult >0 THEN pt_ord_mult ELSE 1).
  END.
  ELSE DO:
    MESSAGE part + "不存在" VIEW-AS ALERT-BOX.
    UNDO.
  END.
/*
  IF loc NE "" THEN DO:   /*if this is a inventory item*/
    FIND FIRST ld_det NO-LOCK WHERE ld_part = part AND ld_site = site AND ld_loc = loc NO-ERROR.
    IF AVAILABLE ld_det THEN DO:
        IF ld_qty_oh < qty THEN DO:
            MESSAGE "库存数量为:" + string(ld_qty_oh) + "小于需要生成条码数量".
            UNDO.
        END.
    END.
    ELSE DO:
        MESSAGE "在地点:" + site + "库位:" + loc + "没有库存数量" VIEW-AS ALERT-BOX.
        UNDO.
    END.
  END.
*/
   /*{bcRUN.i ""bcbcltcr.p"" "(OUTPUT co_lot)"}.*/


  DEFINE VARIABLE lqty LIKE qty.
  ASSIGN lqty = qty.
  DO WHILE lqty > 0:
    co_qty = (IF lqty <= ord_qty THEN lqty ELSE ord_qty).

    {gprun.i  ""bcconbr.p"" "(INPUT part, input bcdate, input co_qty, input fm, input idty, input tmp_code, 
                  OUTPUT co_code, OUTPUT co_vcode)"}.

     FOR FIRST pt_mstr WHERE pt_part =  part:
     END.

    CREATE t_co_mstr.
       ASSIGN 
           t_co_code = co_code
           t_co_part = part
           t_co_um = ""
           t_co_lot = ""
           t_co_status = "MAT-CRE"
           t_co_desc1 = pt_desc1
           t_co_desc2 = pt_desc2
           t_co_qty_ini = co_qty
           t_co_qty_cur = co_qty
           t_co_qty_std = ord_qty
           t_co_ser = 0
           t_co_ref = ""
           t_co_site = site
           t_co_loc = loc
           t_co_format = ""
           t_co_vcode = co_vcode
           t_userid = mfguser.
     tmp_code = co_code.
     lqty = lqty - ord_qty.
   END.



        
END. /*mainloop*/
