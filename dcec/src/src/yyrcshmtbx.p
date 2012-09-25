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

DEF VAR v_shipper    AS CHAR.
DEF VAR v_ship_fr    AS CHAR.
DEF VAR v_bill_to    AS CHAR.
DEF VAR v_tot_box    AS INTEGER.
DEF VAR v_nul_box    AS INTEGER.
DEF VAR v_shipper_recid AS RECID.
DEF VAR v_confirm    AS LOGICAL.
DEF VAR v_mot        AS CHAR.
DEF VAR v_fob        AS CHAR.
DEF VAR v_title_item AS CHAR.

DEF TEMP-TABLE xxwk1 
    FIELDS xxwk1_recid         AS RECID
    FIELDS xxwk1_modflag       AS CHAR INITIAL "" FORMAT "X"
    FIELDS xxwk1_box_nbr       AS CHAR
    FIELDS xxwk1_box_nwet      AS DECIMAL
    FIELDS xxwk1_box_gwet      AS DECIMAL
    FIELDS xxwk1_box_dim       AS CHAR
    FIELDS xxwk1_cnt_nbr       AS CHAR 
    INDEX xxwk1_idx1 xxwk1_box_nbr.

DEF TEMP-TABLE xxwk2 
    FIELDS xxwk2_recid         AS RECID
    FIELDS xxwk2_modflag       AS CHAR INITIAL "" FORMAT "X"
    FIELDS xxwk2_part          LIKE pt_part
    FIELDS xxwk2_qty           LIKE ABS_qty
    FIELDS xxwk2_sonbr         LIKE so_nbr
    FIELDS xxwk2_soline        LIKE sod_line
    FIELDS xxwk2_loc           LIKE sod_loc
    INDEX xxwk2_idx1 xxwk2_part.

DEF FRAME f-a
    v_shipper    LABEL "发货单"    COLON 8
    v_ship_fr    LABEL "发货地点"  COLON 24
    v_bill_to    LABEL "客户"      COLON 40
    ABS_shipto   LABEL "收货地点"  COLON 56
    ABS_shp_date LABEL "日期"      COLON 72
    SKIP
    v_fob        LABEL " FOB"       COLON 8
    v_mot        LABEL "运输方式"   COLON 24
    ABS_nwt      LABEL "净重"       COLON 40 FORMAT "->>>>>>>>>9.9<<<<"
    ABS_gwt      LABEL "毛重"       COLON 56 FORMAT "->>>>>>>>>9.9<<<<"
    SKIP
    v_confirm    LABEL "已发货"     COLON 8
    ABS_export_batch  LABEL "EDI已发ID"    COLON 40
WITH THREE-D WIDTH 80 SIDE-LABEL TITLE "".

DEF FRAME f-box
    xxwk1_box_nbr   FORMAT "x(12)"  COLUMN-LABEL "箱号"
    xxwk1_cnt_nbr   FORMAT "x(20)"  COLUMN-LABEL "集装箱号"
    xxwk1_box_nwet  FORMAT ">>>>>9"   COLUMN-LABEL "净重"
    xxwk1_box_gwet  FORMAT ">>>>>9"   COLUMN-LABEL "毛重"
    xxwk1_box_dim   FORMAT "x(18)"  COLUMN-LABEL "长宽高"
/*    xxwk1_modflag   FORMAT "x(1)"  COLUMN-LABEL "状态"*/
WITH THREE-D WIDTH 80 16 DOWN TITLE "[光标-移动 ESC-退出 S-单行修改 B-批量修改 D-删除 Enter-显示零件明细]".

DEF FRAME f-item
    xxwk2_part
    xxwk2_qty
    xxwk2_sonbr
    xxwk2_soline
    xxwk2_loc
WITH THREE-D WIDTH 80 ROW 15 5 DOWN OVERLAY TITLE v_title_item.


RUN xxpro-initial (OUTPUT v_sys_status).
REPEAT:
    VIEW FRAME f-a.
    VIEW FRAME f-box.

    RUN xxpro-input (OUTPUT v_sys_status).
    IF v_sys_status <> "0" THEN LEAVE.
    RUN xxpro-bud-box (OUTPUT v_sys_status).
    RUN xxpro-view-box  (OUTPUT v_sys_status).
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
    ASSIGN
        v_fob = ""
        v_mot = ""
        v_bill_to = ""
        v_confirm = NO
        .

    UPDATE 
        v_shipper
    WITH FRAME f-a EDITING :
        if frame-field = "v_shipper" then do:
            {mfnp05.i ABS_mstr abs_id "abs_id begins 'S'and abs_type = 's'" abs_id "'s' + v_shipper"}
        END.
        ELSE DO:
            status input.
            readkey.
            apply lastkey.
        END.
        if recno <> ? then do:
            v_mot     = trim(SUBSTRING(ABS_mstr.ABS__qad01,61,20)).
            v_fob     = trim(SUBSTRING(ABS_mstr.ABS__qad01,21,20)).
            IF substring(ABS_status,2,1) = "y" THEN v_confirm = YES. ELSE v_confirm = NO.
            v_bill_to = ABS_shipto.
            FIND FIRST ad_mstr WHERE ad_addr = v_bill_to NO-LOCK NO-ERROR.
            IF AVAILABLE ad_mstr THEN v_bill_to = ad_ref.

            DISPLAY 
                substring(ABS_id,2) @ v_shipper
                abs_shipfrom @ v_ship_fr
                abs_shipto   
                v_bill_to
                ABS_shp_date
                v_mot
                v_fob
                ABS_nwt
                ABS_gwt
                v_confirm
                ABS_export_batch
            WITH FRAME f-a.
        END.
    END.

    FIND FIRST ABS_mstr WHERE ABS_id = 's' + v_shipper 
        AND abs_type = 's'
        NO-LOCK NO-ERROR.
    IF AVAILABLE ABS_mstr THEN DO:
        ASSIGN 
            v_shipper = SUBSTRING(ABS_id,2)
            v_ship_fr = ABS_shipfrom
            v_bill_to = abs_shipto.
        FIND FIRST ad_mstr WHERE ad_addr = v_bill_to NO-LOCK NO-ERROR.
        IF AVAILABLE ad_mstr THEN v_bill_to = ad_ref.
        v_mot     = trim(SUBSTRING(ABS_mstr.ABS__qad01,61,20)).
        v_fob     = trim(SUBSTRING(ABS_mstr.ABS__qad01,21,20)).
        IF substring(ABS_status,2,1) = "y" THEN v_confirm = YES. ELSE v_confirm = NO.
        DISPLAY
            v_shipper v_ship_fr abs_shipto v_bill_to 
            ABS_shp_date v_mot v_fob
            ABS_nwt
            ABS_gwt
            v_confirm
            ABS_export_batch
            WITH FRAME f-a.
        v_shipper_recid = RECID(ABS_mstr).
    END.
    ELSE DO:
        MESSAGE "发货单未找到" VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
        UNDO, RETRY.
    END.
    p_sys_status = "0".
END PROCEDURE.



/*---------------------------*/
PROCEDURE xxpro-bud-box:
    DEF OUTPUT PARAMETER p_sys_status AS CHAR.
    p_sys_status = "".
    
    DEF VAR i AS INTEGER.
    i = 0.
    v_tot_box = 0.
    FOR EACH xxwk1:
        DELETE xxwk1.
    END.
    FOR EACH xxwk2:
        DELETE xxwk2.
    END.
    
    FOR EACH ABS_mstr WHERE abs_shipfrom = v_ship_fr 
        AND ABS_par_id = "s" + v_shipper 
        AND abs_type = 's'
        AND ABS_id BEGINS 'c'
        NO-LOCK:
        CREATE xxwk1.
        ASSIGN 
            xxwk1_box_nbr  = substring(abs_id,2)
            xxwk1_box_nwet = ABS_nwt
            xxwk1_box_gwet = ABS_gwt
            xxwk1_box_dim  = ABS_user1
            xxwk1_cnt_nbr  = ABS_user2
            xxwk1_recid    = RECID(ABS_mstr)
            xxwk1_modflag  = ""
            .
    END.
    p_sys_status = "0".
END PROCEDURE.
/*---------------------------*/
PROCEDURE xxpro-view-box:
    DEF OUTPUT PARAMETER p_sys_status AS CHAR.
    p_sys_status = "".

    MainBlock:
    do on error undo,leave on endkey undo,leave:
        { yyzzut001b.i
          &file = "xxwk1"
          &where = "where xxwk1_modflag <> 'D' "
          &frame = "f-box"
          &fieldlist = "
            xxwk1_box_nbr
            xxwk1_box_nwet
            xxwk1_box_gwet
            xxwk1_box_dim
            xxwk1_cnt_nbr
                       "
          &prompt     = "xxwk1_box_nbr"
          &index      = "use-index xxwk1_idx1"
          &updkey     = "S"
          &updcode    = "~ run xxpro-select-sbox. ~"
          &inskey     = "B"
          &inscode    = "~ run xxpro-select-mbox. ~"
          &delkey     = "D"
          &delcode    = "~ run xxpro-select-dbox. ~"
          &key1       = "Enter"
          &code1      = "~ run xxpro-show-item. ~"
          }
    end. /*MAIN BLOCK */
    p_sys_status = "0".
END PROCEDURE.
/*---------------------------*/
PROCEDURE xxpro-select-sbox:
    find xxwk1 where recid(xxwk1) = w-rid[Frame-line(f-box)] no-lock no-error.
    if available xxwk1 then do:
        IF xxwk1_modflag = "D" THEN LEAVE.
        find xxwk1 where recid(xxwk1) = w-rid[Frame-line(f-box)].
        UPDATE 
            xxwk1_cnt_nbr 
            xxwk1_box_nwet
            xxwk1_box_gwet
            xxwk1_box_dim
            WITH FRAME f-box.
        xxwk1_modflag = "M".
        RUN xxpro-update-box.
    end.    	
END PROCEDURE.
/*---------------------------*/
PROCEDURE xxpro-select-mbox:
    DEF VAR v_cnt_nbr AS CHAR.
    DEF VAR v_box_fr  AS CHAR.
    DEF VAR v_box_to  AS CHAR.

    DEF FRAME f-c
        v_box_fr   FORMAT "x(8)" LABEL "箱子范围从"
        v_box_to   FORMAT "x(8)" LABEL "至"            
        v_cnt_nbr  FORMAT "x(14)" LABEL "集装箱号"
        WITH WIDTH 60 SIDE-LABELS OVERLAY CENTER.
    UPDATE 
        v_box_fr
        v_box_to
        v_cnt_nbr
    WITH FRAME f-c.
    FOR EACH xxwk1 WHERE xxwk1_box_nbr >= v_box_fr
        AND xxwk1_box_nbr <= v_box_to
        AND xxwk1_modflag <> "D":
        ASSIGN 
            xxwk1_cnt_nbr = v_cnt_nbr
            xxwk1_modflag = "M".

    END.
    HIDE FRAME f-c NO-PAUSE.
    RUN xxpro-update-box.
END PROCEDURE.
/*---------------------------*/
PROCEDURE xxpro-select-dbox:
    find xxwk1 where recid(xxwk1) = w-rid[Frame-line(f-box)] no-lock no-error.
    if available xxwk1 then do:
        IF xxwk1_modflag = "D" THEN LEAVE.
        IF v_confirm = YES THEN DO:
            MESSAGE "发货单已经确认,不能删除" VIEW-AS ALERT-BOX BUTTONS OK.
            LEAVE.
        END.
        find xxwk1 where recid(xxwk1) = w-rid[Frame-line(f-box)].
        ASSIGN xxwk1_modflag = "D".
        RUN xxpro-delete-box (INPUT xxwk1_recid).
    end.    	
END PROCEDURE.
/*---------------------------*/
PROCEDURE xxpro-update-box:
    v_ok = NO.
    MESSAGE "确认更新" VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE v_ok.
    IF v_ok = NO THEN LEAVE.
    FOR EACH xxwk1 WHERE xxwk1_modflag = "M":
        FIND FIRST ABS_mstr WHERE RECID(ABS_mstr) = xxwk1_recid NO-ERROR.
        IF AVAILABLE ABS_mstr THEN do: 
            ASSIGN 
                ABS_nwt = xxwk1_box_nwet 
                ABS_gwt = xxwk1_box_gwet 
                ABS_user1 = xxwk1_box_dim 
                ABS_user2 = xxwk1_cnt_nbr
                .
            RELEASE ABS_mstr.
        END.
        xxwk1_modflag = "".
    END.
END PROCEDURE.
/*---------------------------*/
PROCEDURE xxpro-delete-box:
    DEFINE INPUT PARAMETER p-recid AS RECID.
    IF p-recid = ? THEN LEAVE.

    v_ok = NO.
    DEFINE BUFFER bbabs_mstr FOR ABS_mstr.
    MESSAGE "确认更新" VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE v_ok.
    IF v_ok = NO THEN LEAVE.

    FIND FIRST ABS_mstr WHERE RECID(ABS_mstr) = p-recid NO-ERROR.
    IF NOT AVAILABLE ABS_mstr THEN NEXT.

    /*delete item first*/
    FOR EACH bbabs_mstr WHERE bbabs_mstr.ABS_type = "S"
        AND bbabs_mstr.ABS_par_id = ABS_mstr.ABS_id
        AND bbabs_mstr.ABS_shipfrom = ABS_mstr.abs_shipfrom
        AND bbabs_mstr.ABS_id BEGINS "i"
        NO-LOCK:
        RUN xxpro-delete-item (INPUT RECID(bbabs_mstr)).
    END.
    /*DELETE  box.*/
    DELETE ABS_mstr.
    /*DELETE ABS_mstr*/
    DELETE xxwk1.
    /*update shipper header*/
    RUN xxpro-cal-shipper (INPUT v_shipper_recid).
END PROCEDURE.
/*---------------------------*/
PROCEDURE xxpro-show-item:
    find xxwk1 where recid(xxwk1) = w-rid[Frame-line(f-box)] no-lock no-error.
    if available xxwk1 then do:
        v_title_item = "箱子" + xxwk1_box_nbr + "的零件明细".
        RUN xxpro-bud-item (INPUT xxwk1_recid).
        RUN xxpro-view-item (OUTPUT v_sys_status).
        DISP xxwk1_box_nbr WITH FRAME f-box.
    end.    	
END PROCEDURE.
/*---------------------------*/
PROCEDURE xxpro-bud-item:
    DEF INPUT PARAMETER p_recid AS RECID.
    DEF VAR             v-keyx  AS CHAR EXTENT 6.

    FOR EACH xxwk2:
        DELETE xxwk2.
    END.
    v-keyx = "".
    IF p_recid = ? THEN LEAVE.
    FIND FIRST ABS_mstr WHERE recid(ABS_mstr) = p_recid NO-LOCK NO-ERROR.
    IF NOT AVAILABLE ABS_mstr THEN LEAVE.
    ASSIGN 
        v-keyx[1] = ABS_id
        v-keyx[2] = ABS_shipfrom
        v-keyx[3] = ABS_type.

    FOR EACH ABS_mstr NO-LOCK WHERE ABS_type = v-keyx[3]
        AND ABS_par_id   = v-keyx[1]
        AND ABS_shipfrom = v-keyx[2]
        AND ABS_id BEGINS "i":
        CREATE xxwk2.
        ASSIGN
            xxwk2_recid = RECID(ABS_mstr)
            xxwk2_modflag = ""
            xxwk2_part  = ABS_item
            xxwk2_sonbr = ABS_order
            xxwk2_soline = INTEGER(ABS_line)
            xxwk2_loc    = ABS_loc
            xxwk2_qty    = ABS_qty
            .
    END.
END PROCEDURE.
/*---------------------------*/
PROCEDURE xxpro-view-item:
    DEF OUTPUT PARAMETER p_sys_status AS CHAR.
    p_sys_status = "".
    CLEAR FRAME f-item ALL NO-PAUSE.
    FOR EACH xxwk2 WHERE xxwk2_modflag <> "D":
        DISPLAY
            xxwk2_part
            xxwk2_qty
            xxwk2_sonbr
            xxwk2_soline
            xxwk2_loc
            WITH FRAME f-item.
        DOWN 1 WITH FRAME f-item.
    END.
    PAUSE.
    HIDE FRAME f-item NO-PAUSE.
    p_sys_status = "0".
END PROCEDURE.
/*---------------------------*/
PROCEDURE xxpro-delete-item:
    DEFINE INPUT PARAMETER p-recid AS RECID.
    IF p-recid = ? THEN LEAVE.
    DEFINE BUFFER bbabs_mstr FOR ABS_mstr.
    FIND FIRST bbABS_mstr WHERE RECID(bbABS_mstr) = p-recid NO-ERROR.
    IF AVAILABLE bbABS_mstr THEN DO:
        DELETE bbabs_mstr.
    END.
END PROCEDURE.
/*---------------------------*/
PROCEDURE xxpro-cal-shipper:
    DEFINE INPUT PARAMETER p-recid AS RECID.
    IF p-recid = ? THEN LEAVE.
    DEFINE VAR v-decfld AS DECIMAL EXTENT 3.
    v-decfld = 0.
    DEFINE BUFFER bbabs_mstr FOR ABS_mstr.
    FIND FIRST ABS_mstr WHERE recid(ABS_mstr) = p-recid NO-ERROR.
    IF AVAILABLE ABS_mstr THEN DO:
        FOR EACH bbabs_mstr NO-LOCK WHERE bbabs_mstr.ABS_type = ABS_mstr.ABS_type 
            AND bbabs_mstr.ABS_shipfrom = ABS_mstr.ABS_shipfrom
            AND bbabs_mstr.ABS_par_id   = ABS_mstr.ABS_id
            AND bbabs_mstr.ABS_id BEGINS 'C':
            v-decfld[1] = v-decfld[1] + bbabs_mstr.ABS_nwt.
            v-decfld[2] = v-decfld[2] + bbabs_mstr.ABS_gwt.
            v-decfld[3] = v-decfld[3] + bbabs_mstr.ABS_vol.
        END.
        ABS_mstr.ABS_nwt = v-decfld[1].
        ABS_mstr.ABS_gwt = v-decfld[2].
        ABS_mstr.ABS_vol = v-decfld[3].
    END.
END PROCEDURE.
