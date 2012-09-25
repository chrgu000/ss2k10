/**-----------------------------------------------**
 @File: xxrspoprt1.p
 @Description: print schedule order based on active release
 @Version: 1.0
 @Author: James Zou
 @Created: 2006-6-20
 @Mfgpro: eb2sp7
 @Parameters: 
 @BusinessLogic:
**-----------------------------------------------**/


/* DISPLAY TITLE */
{mfdtitle.i "f+"}
{yyzzut001a.i}
{yyedcomlib.i}
IF f-howareyou("HAHA") = NO THEN LEAVE.


DEF VAR v_ok         AS LOGICAL.
DEF VAR v_sys_status AS CHAR.

DEF VAR v_inv_nbr    AS CHAR.
DEF VAR v_cust       AS CHAR.
DEF VAR v_inv_date   AS DATE.


DEF FRAME f-a
    v_inv_nbr     LABEL "系统发票"
    v_inv_date    LABEL "发票日期"
    v_cust        LABEL "发票号码"
WITH WIDTH 80 SIDE-LABEL TITLE "".

DEF FRAME f-b
    ih_inv_nbr  COLUMN-LABEL "系统发票"
    ih_inv_date COLUMN-LABEL "发票日期"
    ih_cust     COLUMN-LABEL "客户"
    ih_nbr      COLUMN-LABEL "订单"
    ih_user1    COLUMN-LABEL "实际发票"
    ih_export_batch COLUMN-LABEL "EDI#"
WITH WIDTH 80 18 DOWN TITLE "[光标-移动 ESC-退出 回车-修改]".



RUN xxpro-initial (OUTPUT v_sys_status).
REPEAT:
    VIEW FRAME f-a.
    VIEW FRAME f-b.

    RUN xxpro-input (OUTPUT v_sys_status).
    IF v_sys_status <> "0" THEN LEAVE.
    RUN xxpro-view  (OUTPUT v_sys_status).
END.



/*---------------------------*/
PROCEDURE xxpro-initial:
    DEF OUTPUT PARAMETER p_sys_status AS CHAR.
    p_sys_status = "".

    p_sys_status = "0".
END PROCEDURE.
/*---------------------------*/
PROCEDURE xxpro-input:
    DEF OUTPUT PARAMETER p_sys_status AS CHAR.
    p_sys_status = "".
    

    UPDATE 
        v_inv_nbr
        v_inv_date
        v_cust
    WITH FRAME f-a.

    p_sys_status = "0".
END PROCEDURE.
/*---------------------------*/
PROCEDURE xxpro-view:
    DEF OUTPUT PARAMETER p_sys_status AS CHAR.
    p_sys_status = "".

    MainBlock:
    do on error undo,leave on endkey undo,leave:
        { yyzzut001b.i
          &file = "ih_hist"
          &where = "where (ih_inv_nbr >= v_inv_nbr
                      AND (ih_inv_date = v_inv_date OR v_inv_date = ?)
                      AND (ih_cust = v_cust OR v_cust = '') 
            )"
          &frame = "f-b"
          &fieldlist = "
            ih_inv_nbr
            ih_inv_date
            ih_cust
            ih_nbr
            ih_user1
            ih_export_batch
                       "
          &prompt     = "ih_inv_nbr"
          &midchoose  = "color mesages"
        &updkey     = "Enter"
        &updcode    = "~ run xxpro-select-s. ~"
        }
    end. /*MAIN BLOCK */
    p_sys_status = "0".
END PROCEDURE.
/*---------------------------*/
PROCEDURE xxpro-select-s:
    find ih_hist where recid(ih_hist) = w-rid[Frame-line(f-b)] no-lock no-error.
    if available ih_hist then do:
        find ih_hist where recid(ih_hist) = w-rid[Frame-line(f-b)].
        UPDATE ih_user1 WITH FRAME f-b.
        RELEASE ih_hist.
    end.    	
END PROCEDURE.
