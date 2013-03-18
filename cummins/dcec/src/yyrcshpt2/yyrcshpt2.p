
/* DISPLAY TITLE */
{mfdtitle.i "20120926.1"}
function f-getpoprice returns DECIMAL
    (input v_inp_ponbr as CHARACTER,
     INPUT v_inp_poln  AS INTEGER,
     INPUT v_inp_effdt AS DATE,
     INPUT v_inp_qty   AS DECIMAL):

    DEF VAR v_out_results AS DECIMAL.
    DEF VAR jk AS INTEGER.

    v_out_results = 0.

    FIND FIRST pod_det WHERE pod_domain = global_domain and pod_nbr = v_inp_ponbr AND pod_line = v_inp_poln NO-LOCK NO-ERROR.
    FIND FIRST po_mstr WHERE po_domain = global_domain and po_nbr = v_inp_ponbr NO-LOCK NO-ERROR.

    IF AVAILABLE pod_det AND AVAILABLE po_mstr THEN DO:
        v_out_results = pod_pur_cost. 
        IF pod_pr_list <> "" THEN DO:
            for last pc_mstr
            fields(pc_amt pc_amt_type pc_curr pc_expire pc_list
            pc_min_qty pc_part pc_prod_line pc_start pc_um)
            where pc_domain    = global_domain         and 
                  pc_list      = pod_pr_list           and
                  pc_part      = pod_part              and
                  pc_um        = pod_um                and
                  (pc_start    <= v_inp_effdt or pc_start = ?)  and
                  (pc_expire   >= v_inp_effdt or pc_expire = ?) and
                  pc_curr      = po_curr                        and
                  pc_amt_type  = "P" no-lock:
            end. /* FOR LAST PC_MSTR */
            if available pc_mstr then DO:
                if v_inp_qty < 0 then v_inp_qty = v_inp_qty * -1.
                do jk = 1 to 15:
                    if pc_min_qty[jk] > v_inp_qty
                    or (pc_min_qty[jk] = 0 and pc_amt[jk] = 0)
                    then leave.
                end.
                jk = jk - 1.

                if jk > 0 then v_out_results = pc_amt[jk].
            END.
        END.
    END.
    RETURN v_out_results.
END FUNCTION.
        

/*-------------------------------------------------------**
 *get item additional data
**-------------------------------------------------------*/
function f-getpartdata returns CHARACTER
    (input v_inp_part as CHARACTER,
     INPUT v_inp_fld  AS CHARACTER):

    DEF VAR v_out_results AS CHARACTER.

    v_out_results = "".


    FIND FIRST pt_mstr WHERE pt_mstr.pt_domain = global_domain and pt_mstr.pt_part = v_inp_part NO-LOCK NO-ERROR.
    IF AVAILABLE pt_mstr THEN DO:
        CASE v_inp_fld:
            WHEN "pt_desc1"     THEN ASSIGN v_out_results = pt_desc1.
            WHEN "pt_desc2"     THEN ASSIGN v_out_results = pt_desc2.
            WHEN "pt_desc12"    THEN ASSIGN v_out_results = pt_desc1 + pt_desc2.
            WHEN "pt_um"        THEN ASSIGN v_out_results = pt_um.
            WHEN "pt_dsgn_grp"  THEN ASSIGN v_out_results = pt_dsgn_grp.
            WHEN "pt_promo"     THEN ASSIGN v_out_results = pt_promo.
            WHEN "pt_draw"      THEN ASSIGN v_out_results = pt_draw.
            WHEN "pt_drwg_loc"  THEN ASSIGN v_out_results = pt_drwg_loc.
            WHEN "pt_drwg_size" THEN ASSIGN v_out_results = pt_drwg_size.
            WHEN "pt_break_cat" THEN ASSIGN v_out_results = pt_break_cat.
            WHEN "pt_article"   THEN ASSIGN v_out_results = pt_article. 
            WHEN "pt_net_wt"    THEN ASSIGN v_out_results = string(pt_net_wt). 
            WHEN "pt_ship_wt"   THEN ASSIGN v_out_results = string(pt_ship_wt).
            WHEN "pt_size"      THEN ASSIGN v_out_results = string(pt_size).
            WHEN "pt_user1"     THEN ASSIGN v_out_results = pt_user1. 
            WHEN "pt_user2"     THEN ASSIGN v_out_results = pt_user2. 
            WHEN "pt__chr01"   THEN ASSIGN v_out_results = pt__chr01. 
            WHEN "pt__chr02"   THEN ASSIGN v_out_results = pt__chr02. 
            WHEN "pt__chr03"   THEN ASSIGN v_out_results = pt__chr03. 
            WHEN "pt__chr04"   THEN ASSIGN v_out_results = pt__chr04. 
            WHEN "pt__chr05"   THEN ASSIGN v_out_results = pt__chr05. 
            WHEN "pt__chr06"   THEN ASSIGN v_out_results = pt__chr06. 
            WHEN "pt__chr07"   THEN ASSIGN v_out_results = pt__chr07. 
            WHEN "pt__chr08"   THEN ASSIGN v_out_results = pt__chr08. 
            WHEN "pt__dte01"   THEN ASSIGN v_out_results = string(pt__dte01). 
            WHEN "pt__dec01"   THEN ASSIGN v_out_results = string(pt__dec01). 
        END CASE.
    END.
    RETURN v_out_results.
END FUNCTION.

/*-------------------------------------------------------**
 *get address additional data
**-------------------------------------------------------*/
function f-getaddata returns CHARACTER
    (input v_inp_addr as CHARACTER,
     INPUT v_inp_fld  AS CHARACTER):

    DEF VAR v_out_results AS CHARACTER.

    v_out_results = "".


    FIND FIRST ad_mstr WHERE ad_mstr.ad_domain = global_domain and ad_mstr.ad_addr = v_inp_addr NO-LOCK NO-ERROR.
    IF AVAILABLE ad_mstr THEN DO:
        CASE v_inp_fld:
            WHEN "name"         THEN ASSIGN v_out_results = ad_name.
            WHEN "nameline1"    THEN ASSIGN v_out_results = ad_name + ad_line1.
            WHEN "line1"        THEN ASSIGN v_out_results = ad_line1.
            WHEN "line2"        THEN ASSIGN v_out_results = ad_line2.
            WHEN "line3"        THEN ASSIGN v_out_results = ad_line3.
            WHEN "line123"      THEN ASSIGN v_out_results = ad_line1 + ad_line2 + ad_line3.
            WHEN "phone"        THEN ASSIGN v_out_results = ad_phone.
            WHEN "fax"          THEN ASSIGN v_out_results = ad_fax.
            WHEN "attn"         THEN ASSIGN v_out_results = ad_attn.
        END CASE.
    END.
    RETURN v_out_results.
END FUNCTION.



/*-------------------------------------------------------**
 *conv string for date
**-------------------------------------------------------*/
function f-conv-date-c2d returns DATE
    (input v_inp_date as CHARACTER):
    DEF VAR v_out_results AS DATE.
    v_out_results = ?.
    v_inp_date = TRIM(v_inp_date).
    v_out_results = DATE(INTEGER(SUBSTRING(v_inp_date,5,2)),INTEGER(SUBSTRING(v_inp_date,7,2)),INTEGER(SUBSTRING(v_inp_date,1,4)) ).
    IF v_out_results = ? THEN v_out_results = DATE(v_inp_date).
    RETURN v_out_results.
END FUNCTION.



/*-------------------------------------------------------**
 *get so price
**-------------------------------------------------------*/
function f-getsoprice returns DECIMAL
    (input v_inp_sonbr as CHARACTER,
     INPUT v_inp_soln  AS INTEGER,
     INPUT v_inp_effdt AS DATE,
     INPUT v_inp_qty   AS DECIMAL):

    DEF VAR v_out_results AS DECIMAL.
    DEF VAR jk AS INTEGER.

    v_out_results = 0.

    FIND FIRST sod_det WHERE sod_domain = global_domain and sod_nbr = v_inp_sonbr AND sod_line = v_inp_soln NO-LOCK NO-ERROR.
    FIND FIRST so_mstr WHERE so_domain = global_domain and so_nbr = v_inp_sonbr NO-LOCK NO-ERROR.

    IF AVAILABLE sod_det AND AVAILABLE so_mstr THEN DO:
        v_out_results = sod_price.
/*      IF sod_pr_list <> "" THEN DO:                                        */
/*          for last pc_mstr                                                 */
/*          fields(pc_amt pc_amt_type pc_curr pc_expire pc_list              */
/*          pc_min_qty pc_part pc_prod_line pc_start pc_um)                  */
/*          where pc_domain    = global_domain         and                   */
/*                pc_list      = sod_pr_list           and                   */
/*                pc_part      = sod_part              and                   */
/*                pc_um        = sod_um                and                   */
/*                (pc_start    <= v_inp_effdt or pc_start = ?)  and          */
/*                (pc_expire   >= v_inp_effdt or pc_expire = ?) and          */
/*                pc_curr      = so_curr                        and          */
/*                pc_amt_type  = "P" no-lock:                                */
/*          end. /* FOR LAST PC_MSTR */                                      */
/*          if available pc_mstr then DO:                                    */
/*              if v_inp_qty < 0 then v_inp_qty = v_inp_qty * -1.            */
/*              do jk = 1 to 15:                                             */
/*                  if pc_min_qty[jk] > v_inp_qty                            */
/*                  or (pc_min_qty[jk] = 0 and pc_amt[jk] = 0)               */
/*                  then leave.                                              */
/*              end.                                                         */
/*              jk = jk - 1.                                                 */
/*                                                                           */
/*              if jk > 0 then v_out_results = pc_amt[jk].                   */
/*          END.                                                             */
/*      END.                                                                 */
    END.
    RETURN v_out_results.
END FUNCTION.


/*-------------------------------------------------------**
 *get item additional data
**-------------------------------------------------------*/
function f-howareyou returns LOGICAL
    (input v_welcome as CHAR):

    DEF VAR v_out_results AS LOGICAL.

    v_out_results = NO.

/*check lic and expire date*/
FIND FIRST pin_mstr WHERE pin_product = "MFG/PRO" NO-LOCK NO-ERROR.
IF AVAILABLE pin_mstr THEN do:
    if pin_control1 = "QMJJ0"
    AND pin_control2 = "QQNJ0"
    AND pin_control3 = "QMJM1" 
    AND pin_control4 =  "QQ450" 
    AND pin_control5 = "QMJQ0"
    AND pin_control6 = "1NGLK" 
    then v_out_results = YES.
end.
   
IF v_out_results = YES THEN DO:
    if today > date(12,31,2007) then  v_out_results = NO.
END.
IF v_out_results = YES THEN DO:
    IF v_welcome <> "HAHA" THEN v_out_results = NO.
END.



    RETURN v_out_results.
END FUNCTION.
/*
IF f-howareyou("HAHA") = NO THEN LEAVE.
*/


DEF VAR v_sys_status AS CHAR.
DEF VAR v_fexcel     AS CHAR.
DEF VAR v_fname      AS CHAR.
DEF VAR v_ok         AS LOGICAL.

DEF VAR v_shipper    like abs_id.
DEF VAR v_ship_fr     AS CHAR.
DEF VAR v_bill_to     AS CHAR.
DEF VAR v_ship_to     AS CHAR.
DEF VAR v_sender      AS CHAR INITIAL "DCEC".


DEF TEMP-TABLE xxwk1
    FIELDS xxwk1_inv_nbr AS CHAR
    FIELDS xxwk1_nbr_po  AS CHAR
    FIELDS xxwk1_nbr_so  AS CHAR
    FIELDS xxwk1_nbr_asn AS CHAR
    FIELDS xxwk1_buyer AS CHAR EXTENT 5
    FIELDS xxwk1_seller AS CHAR EXTENT 5
    FIELDS xxwk1_billto AS CHAR EXTENT 5
    FIELDS xxwk1_sender AS CHAR EXTENT 5
    FIELDS xxwk1_tot_amt AS DECIMAL
    FIELDS xxwk1_curr    AS CHAR
    FIELDS xxwk1_date    AS DATE EXTENT 5
    FIELDS xxwk1_ref     AS CHAR EXTENT 5
    FIELDS xxwk1_flag    AS CHAR
    FIELDS xxwk1_payterm AS CHAR
    FIELDS xxwk1_mot     AS CHAR
    FIELDS xxwk1_org     AS CHAR
    FIELDS xxwk1_fob     AS CHAR
    FIELDS xxwk1_tot_box AS INTEGER
    FIELDS xxwk1_tot_nwt AS DECIMAL
    FIELDS xxwk1_mfg_nwt AS DECIMAL
    FIELDS xxwk1_tot_gwt AS DECIMAL
    FIELDS xxwk1_tot_vol AS DECIMAL

    .

DEF TEMP-TABLE xxwk2
    FIELDS xxwk2_inv_nbr AS CHAR
    FIELDS xxwk2_order   AS CHAR
    FIELDS xxwk2_line    AS INTEGER
    FIELDS xxwk2_part    AS CHAR
    FIELDS xxwk2_desc    AS CHAR
    FIELDS xxwk2_desc_ch AS CHAR
    FIELDS xxwk2_qty     AS DECIMAL
    FIELDS xxwk2_um      AS CHAR
    FIELDS xxwk2_price   AS DECIMAL
    FIELDS xxwk2_amt     AS DECIMAL
    FIELDS xxwk2_box_nbr AS CHARACTER
    FIELDS xxwk2_mfg_nwt AS DECIMAL
    FIELDS xxwk2_hscode  AS CHAR
    FIELDS xxwk2_hsrate  AS DECIMAL
    FIELDS xxwk2_mfg_line AS INTEGER
    FIELDS xxwk2_ref_part AS CHAR
    FIELDS xxwk2_ref_ord  AS CHAR
    .


DEF TEMP-TABLE xxwk3     
    FIELDS xxwk3_inv_nbr   AS CHAR
    FIELDS xxwk3_cnt_nbr   AS CHAR
    FIELDS xxwk3_box_nbr   AS CHAR
    FIELDS xxwk3_box_type  AS CHARACTER
    FIELDS xxwk3_box_nwt   AS DECIMAL
    FIELDS xxwk3_box_gwt   AS DECIMAL
    FIELDS xxwk3_box_dim   AS CHAR
    FIELDS xxwk3_box_vol   AS DECIMAL
    FIELDS xxwk3_qty       AS DECIMAL
    FIELDS xxwk3_mfg_nwt   AS DECIMAL
    INDEX xxwk3_idx1 xxwk3_cnt_nbr xxwk3_box_nbr.

DEF TEMP-TABLE xxwk4
    FIELDS xxwk4_doc_nbr  AS CHAR
    FIELDS xxwk4_err_type AS CHAR
    FIELDS xxwk4_err_desc AS CHAR
    FIELDS xxwk4_err_cmt  AS CHAR.


/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A
FORM
    RECT-FRAME       AT ROW 1.4 COLUMN 1.25
    RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
    SKIP(.1)  /*GUI*/
    
    v_shipper    LABEL "发票/发货单"  COLON 15
    v_ship_fr    LABEL "发货地点"     COLON 15
    v_bill_to    LABEL "票据开往"     COLON 15
    v_ship_to    LABEL "货物发往"     COLON 15
    SKIP(1)
    v_sender     LABEL "公司地址"     COLON 15
                 VALIDATE(CAN-FIND(FIRST ad_mstr WHERE ad_domain = global_domain and ad_addr = v_sender), "请输入公司地址码")
    SKIP
    SKIP(.4)  /*GUI*/
    WITH FRAME a SIDE-LABELS WIDTH 80 NO-BOX THREE-D.

DEFINE VARIABLE F-a-title AS CHARACTER.
F-a-title = &IF (DEFINED(SELECTION_CRITERIA) = 0)
            &THEN " Selection Criteria "
            &ELSE {&SELECTION_CRITERIA}
            &ENDIF .
RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
RECT-FRAME-LABEL:WIDTH-PIXELS in frame a =
                 FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
                 RECT-FRAME-LABEL:SCREEN-VALUE in frame a + " ", 
                 RECT-FRAME-LABEL:FONT).
RECT-FRAME:HEIGHT-PIXELS in frame a = FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5. /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).



DEFINE FRAME WaitingFrame 
        "处理中，请稍候..." 
        SKIP
WITH VIEW-AS DIALOG-BOX.






RUN xxpro-initial (OUTPUT v_sys_status).
REPEAT:
    VIEW FRAME a.
    
    RUN xxpro-input (OUTPUT v_sys_status).
    IF v_sys_status <> "0" THEN LEAVE.
    RUN xxpro-build (OUTPUT v_sys_status).
    RUN xxpro-post-process.

    FIND FIRST xxwk1 NO-LOCK NO-ERROR.
    IF NOT AVAILABLE xxwk1 THEN DO:
        MESSAGE "无数据,不能输出." VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
    END.
    ELSE DO:
        v_fname = "".
        SYSTEM-DIALOG GET-FILE v_fname
            TITLE "请输入要保存文件的名称..."        
            FILTERS "Source Files (*.xls)"   "*.xls"       
            /*MUST-EXIST*/
            SAVE-AS
            USE-FILENAME
            UPDATE v_ok.
        IF v_ok = TRUE THEN DO:
            VIEW FRAME waitingframe.
            RUN xxpro-excel  (INPUT v_fname, OUTPUT v_sys_status).
            HIDE FRAME waitingframe NO-PAUSE.
            MESSAGE "输出完毕，要预览吗" VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO TITLE "" UPDATE choice AS LOGICAL.
            IF choice = YES THEN DO:
                run xxpro-view (INPUT v_fname).
            END.
        END.
        ELSE DO:
            MESSAGE "未指定文件名称,不能输出." VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
        END.
    END.
END.

/*---------------------------*/
PROCEDURE xxpro-initial:
    DEF OUTPUT PARAMETER p_sys_status AS CHAR.
    p_sys_status = "".

    v_ok = NO.
    v_fexcel = "".
    p_sys_status = "0".
END PROCEDURE.

/*---------------------------*/
PROCEDURE xxpro-input:
    DEF OUTPUT PARAMETER p_sys_status AS CHAR.
    p_sys_status = "".
    

    UPDATE 
        v_shipper
    WITH FRAME a EDITING :
        if frame-field = "v_shipper" then do:
            {mfnp05.i ABS_mstr abs_id "abs_domain = global_domain and abs_id begins 'S'and abs_type = 's'" abs_id "'s' + input v_shipper"}
        END.
        ELSE DO:
            status input.
            readkey.
            apply lastkey.
        END.
        if recno <> ? then do:

            DISPLAY 
                substring(ABS_id,2) @ v_shipper
            WITH FRAME a.
        END.
    END.

    FIND FIRST ABS_mstr WHERE abs_domain = global_domain and ABS_id = 's' + v_shipper 
        AND abs_type = 's'
        NO-LOCK NO-ERROR.
    IF AVAILABLE ABS_mstr THEN DO:
        ASSIGN 
            v_shipper = SUBSTRING(ABS_id,2)
            v_ship_fr = ABS_shipfrom
            v_bill_to = abs_shipto
            v_ship_to = abs_shipto
            /*v_sender  = ABS_shipfrom*/
            .
        FIND FIRST ad_mstr WHERE ad_domain = global_domain and ad_addr = v_bill_to NO-LOCK NO-ERROR.
        IF AVAILABLE ad_mstr AND ad_ref <> "" THEN v_bill_to = ad_ref.
        DISPLAY
            v_shipper v_ship_fr v_bill_to v_ship_to WITH FRAME a.
    END.
    ELSE DO:
        MESSAGE "发票/发货单未找到" VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
        UNDO, RETRY.
    END.

    UPDATE 
        v_sender 
        WITH FRAME a.
    
    p_sys_status = "0".
END PROCEDURE.


/*---------------------------*/
PROCEDURE xxpro-build:
    DEF OUTPUT PARAMETER p_sys_status AS CHAR.
    p_sys_status = "".
    

    DEFINE VARIABLE v_container_id AS CHAR.

    FOR EACH xxwk1: DELETE xxwk1. END.
    FOR EACH xxwk2: DELETE xxwk2. END.
    FOR EACH xxwk3: DELETE xxwk3. END.
    FOR EACH xxwk4: DELETE xxwk4. END.
    
    v_container_id = "".

    find first ABS_mstr WHERE abs_domain = global_domain and ABS_shipfrom = v_ship_fr 
        AND ABS_id = "s" + v_shipper
        AND abs_type = 's'
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE ABS_mstr THEN LEAVE.

    CREATE xxwk1.
    ASSIGN
/*        xxwk1_inv_nbr   = v_shipper        */
        xxwk1_inv_nbr   = abs_inv_nbr
        xxwk1_buyer[1]  = ABS_shipto
        xxwk1_seller[1] = /*ABS_shipfrom*/ v_sender
        xxwk1_billto[1] = ABS_shipto
        xxwk1_sender[1] = v_sender
        xxwk1_flag      = "INVOICE"
        xxwk1_date[1]   = ABS_shp_date
        xxwk1_mot       = trim(substr(abs_mstr.abs__qad01,61,20))
        xxwk1_fob       = trim(substr(abs_mstr.abs__qad01,21,17))
        xxwk1_ref[1]    = trim(substr(abs_mstr.abs__qad01,41,20))
        /*xxwk1_curr    = edxrd_exf_fld[1] 
        xxwk1_payterm = edxrd_exf_fld[9] /*payment term*/ */
        .
    FIND FIRST CODE_mstr WHERE code_domain = global_domain and code_fldname = "xx-mot" AND CODE_value = xxwk1_mot NO-LOCK NO-ERROR.
    IF AVAILABLE CODE_mstr THEN xxwk1_mot = CODE_cmmt.
    /*mot convert*/

    /*one level parts*/
    FOR EACH ABS_mstr WHERE abs_mstr.abs_domain = global_domain and ABS_mstr.abs_shipfrom = v_ship_fr 
        AND ABS_mstr.ABS_par_id = "s" + v_shipper 
        AND ABS_mstr.abs_type = 's'
        AND ABS_mstr.ABS_id BEGINS 'I'
        NO-LOCK:
        FIND FIRST xxwk3 
            WHERE xxwk3_inv_nbr   = xxwk1_inv_nbr
            AND   xxwk3_box_nbr   = ""
            NO-ERROR.
        IF NOT AVAILABLE xxwk3 THEN DO:
            CREATE xxwk3.
            ASSIGN 
                xxwk3_inv_nbr   = xxwk1_inv_nbr
                xxwk3_cnt_nbr   = ""
                xxwk3_box_nbr   = ""
                xxwk3_box_type  = ""
                xxwk3_box_gwt   = 0
                xxwk3_box_nwt   = 0
                xxwk3_box_dim   = ""
                .
        END.
        ASSIGN
            xxwk3_box_gwt   = xxwk3_box_gwt + ABS_mstr.ABS_gwt
            xxwk3_box_nwt   = xxwk3_box_nwt + ABS_mstr.ABS_nwt.

        FIND FIRST xxwk2 WHERE xxwk2_inv_nbr = xxwk1_inv_nbr
            AND xxwk2_box_nbr = ""
            AND xxwk2_part    = ABS_mstr.ABS_item
            NO-ERROR.
        IF NOT AVAILABLE xxwk2 THEN DO:
            CREATE xxwk2.
            ASSIGN 
                xxwk2_inv_nbr = xxwk1_inv_nbr
                xxwk2_order = ABS_order
                xxwk2_line = INTEGER(ABS_line)
                xxwk2_part = ABS_item
                xxwk2_desc = ""
                xxwk2_qty  = 0
                xxwk2_um   = ""
                xxwk2_box_nbr = ""
                xxwk2_mfg_line = integer(ABS_line)
                .
        END.
        ASSIGN xxwk2_qty  = xxwk2_qty + abs_qty.
    END.
    /*one level box*/
    FOR EACH ABS_mstr WHERE ABS_mstr.abs_domain = global_domain and ABS_mstr.abs_shipfrom = v_ship_fr 
        AND ABS_mstr.ABS_par_id = "s" + v_shipper 
        AND ABS_mstr.abs_type = 's'
        AND ABS_mstr.ABS_id BEGINS 'C'
        NO-LOCK:

        CREATE xxwk3.
        ASSIGN 
            xxwk3_inv_nbr   = xxwk1_inv_nbr
            xxwk3_cnt_nbr   = abs_mstr.ABS_user2
            xxwk3_box_nbr   = SUBSTRING(abs_mstr.ABS_id,2)
            xxwk3_box_type  = ""
            xxwk3_box_gwt   = abs_mstr.ABS_gwt
            xxwk3_box_nwt   = abs_mstr.ABS_nwt
            xxwk3_box_dim   = abs_mstr.ABS_user1
            .
    END.
    /*two level parts*/
    DEF BUFFER bbabs_mstr FOR ABS_mstr.
    FOR EACH bbabs_mstr 
        WHERE bbABS_mstr.abs_shipfrom = v_ship_fr and bbABS_mstr.abs_domain = global_domain 
        AND bbabs_mstr.ABS_par_id = "s" + v_shipper 
        AND bbABS_mstr.abs_type = 's'
        AND bbABS_mstr.ABS_id BEGINS 'C'
        NO-LOCK:

        FOR EACH abs_mstr WHERE abs_mstr.ABS_domain = bbabs_mstr.abs_domain
            AND abs_mstr.ABS_shipfrom = bbabs_mstr.abs_shipfrom
            AND abs_mstr.ABS_par_id = bbabs_mstr.abs_id
            AND ABS_mstr.abs_type = 's'
            AND ABS_mstr.ABS_id BEGINS 'I'
            NO-LOCK:

            FIND FIRST xxwk2 WHERE xxwk2_inv_nbr = xxwk1_inv_nbr
                AND xxwk2_box_nbr = SUBSTRING(bbabs_mstr.ABS_id,2)
                AND xxwk2_part    = ABS_mstr.ABS_item
                NO-ERROR.
            IF NOT AVAILABLE xxwk2 THEN DO:
                CREATE xxwk2.
                ASSIGN 
                    xxwk2_inv_nbr = xxwk1_inv_nbr
                    xxwk2_order = abs_mstr.ABS_order
                    xxwk2_line = INTEGER(abs_mstr.ABS_line)
                    xxwk2_part = abs_mstr.ABS_item
                    xxwk2_desc = ""
                    xxwk2_qty  = 0
                    xxwk2_um   = ""
                    xxwk2_box_nbr = SUBSTRING(bbabs_mstr.ABS_id,2)
                    xxwk2_mfg_line = INTEGER(abs_mstr.ABS_line)
                    .
            END.
            ASSIGN xxwk2_qty  = xxwk2_qty + abs_mstr.abs_qty.
        END.
    END. /*box*/
    p_sys_status = "0".
END PROCEDURE.
/*****************/
PROCEDURE xxpro-post-process:

    FOR EACH Xxwk1:
        FIND FIRST ad_mstr WHERE ad_domain = global_domain and ad_addr = xxwk1_buyer[1] NO-LOCK NO-ERROR.
        IF AVAILABLE ad_mstr THEN DO:
            ASSIGN
                xxwk1_buyer[2] = ad_name 
                xxwk1_buyer[3] = ad_line1 + ad_line2 + ad_line3
                xxwk1_buyer[4] = ad_attn
                xxwk1_buyer[5] = ad_phone + "/" + ad_fax.
            IF ad_ref <> "" AND (ad_type = "DOCK" OR ad_type = "ship-to") THEN ASSIGN xxwk1_billto = ad_ref.
        END.
        FIND FIRST ad_mstr WHERE ad_domain = global_domain and ad_addr = xxwk1_billto[1] NO-LOCK NO-ERROR.
        IF AVAILABLE ad_mstr THEN DO:
            ASSIGN
                xxwk1_billto[2] = ad_name  
                xxwk1_billto[3] = ad_line1 + ad_line2 + ad_line3
                xxwk1_billto[4] = ad_attn
                xxwk1_billto[5] = ad_phone + "/" + ad_fax.
        END.
        FIND FIRST ad_mstr WHERE ad_domain = global_domain and ad_addr = xxwk1_seller[1] NO-LOCK NO-ERROR.
        IF AVAILABLE ad_mstr THEN DO:
            ASSIGN
                xxwk1_seller[2] = ad_name 
                xxwk1_seller[3] = ad_line1 + ad_line2 + ad_line3
                xxwk1_seller[4] = ad_attn
                xxwk1_seller[5] = ad_phone + "/" + ad_fax.
        END.
        FIND FIRST xxwk2 WHERE xxwk2_inv_nbr = xxwk1_inv_nbr NO-LOCK NO-ERROR.
        IF AVAILABLE xxwk2 THEN DO:
            FIND FIRST so_mstr WHERE so_domain = global_domain and so_nbr = xxwk2_order NO-LOCK NO-ERROR.
            IF AVAILABLE so_mstr THEN ASSIGN 
                xxwk1_payterm = so_cr_terms
                xxwk1_curr    = so_curr.
            FIND FIRST pt_mstr WHERE pt_domain = global_domain and pt_part = xxwk2_part NO-LOCK NO-ERROR.
            IF AVAILABLE pt_mstr THEN ASSIGN
                xxwk1_org = pt__chr03.
        END.

        FOR EACH xxwk2 WHERE xxwk2_inv_nbr = xxwk1_inv_nbr:
            FIND FIRST pt_mstr WHERE pt_domain = global_domain and pt_part = xxwk2_part NO-LOCK NO-ERROR.
            IF AVAILABLE pt_mstr THEN DO:
                ASSIGN 
                    xxwk2_mfg_nwt = xxwk2_qty * pt_net_wt
                    xxwk2_hscode  = pt__chr05.
                IF xxwk2_desc = "" THEN xxwk2_desc = pt_desc1.
                IF xxwk2_desc_ch = "" THEN xxwk2_desc_ch = pt_desc2.
            END.
            ASSIGN xxwk1_mfg_nwt = xxwk1_mfg_nwt + xxwk2_mfg_nwt.
            FIND FIRST xxwk3 WHERE xxwk3_inv_nbr = xxwk2_inv_nbr AND xxwk3_box_nbr = xxwk2_box_nbr
                NO-ERROR.
            IF AVAILABLE Xxwk3 THEN DO:
                ASSIGN xxwk3_qty = xxwk3_qty + xxwk2_qty.
            END.
            find first idh_hist no-lock where idh_domain = global_domain and idh_inv_nbr = xxwk1_inv_nbr
                   and idh_part = xxwk2_part no-error.
            if available idh_hist then do:
               assign xxwk2_price = idh_price.
            end.
/*0316          xxwk2_price = f-getsoprice(xxwk2_order, xxwk2_mfg_line, xxwk1_date[1], xxwk2_qty).  */            
            xxwk2_amt   = xxwk2_price * xxwk2_qty.
            FIND FIRST scx_ref 
                where scx_domain = global_domain 
                and scx_type = 1
                and scx_order = xxwk2_order
                and scx_line = xxwk2_mfg_line
                NO-LOCK NO-ERROR.
            IF AVAILABLE scx_ref THEN do:
                xxwk2_ref_ord = scx_po.
            END.
            FIND FIRST sod_det WHERE sod_domain = global_domain and sod_nbr = xxwk2_order AND sod_line = xxwk2_mfg_line NO-LOCK NO-ERROR.
            IF AVAILABLE sod_det THEN xxwk2_ref_part = sod_custpart.
            IF xxwk2_ref_part = "" THEN xxwk2_ref_part = xxwk2_part.
        END.
        FOR EACH xxwk3 WHERE xxwk3_inv_nbr = xxwk1_inv_nbr:
            ASSIGN 
                xxwk1_tot_nwt = xxwk1_tot_nwt + xxwk3_box_nwt
                xxwk1_tot_gwt = xxwk1_tot_gwt + xxwk3_box_gwt
                xxwk1_tot_box = xxwk1_tot_box + 1.
        END.
    END.

END PROCEDURE.


/*---------------------------*/
PROCEDURE xxpro-excel:
    DEF INPUT PARAMETER  p_fname      AS CHARACTER.
    DEF OUTPUT PARAMETER p_sys_status AS CHAR.

    p_sys_status = "".

    IF p_fname = "" THEN LEAVE.

    DEF VAR chExcel AS COM-HANDLE.
    DEF VAR chWorkbook AS COM-HANDLE.
    DEF VAR chWorksheet AS COM-HANDLE.

    DEFINE VARIABLE chPicture   AS COM-HANDLE NO-UNDO.
    DEF VAR v_pic_name AS CHAR.
    
    DEF VAR i   AS INTEGER.
    DEF VAR j   AS INTEGER.
    DEF VAR k   AS INTEGER.
    DEF VARIABLE v_part_qty AS DECIMAL.
    DEF VARIABLE v_part_price AS DECIMAL.
    DEF VARIABLE v_part_amt   AS DECIMAL.

    
    /* read EXCEL file and load data begin..*/
    FOR EACH xxwk1 BREAK BY xxwk1_inv_nbr:
        CREATE "Excel.Application" chExcel.
        /*chWorkbook =  chExcel:Workbooks:ADD(v_fexcel).*/
        chWorkbook =  chExcel:Workbooks:ADD().
        chExcel:visible = NO.

        /*sheet-1 invoice*/
        chWorkSheet = chWorkbook:workSheets(1).
        chWorkSheet:NAME = "INVOICE".
        chWorksheet:COLUMNS:Font:SIZE = 10.
        DO j = 1 TO 10:
            chWorkSheet:COLUMNS(j):NumberFormatLocal = "@".
        END.

        /*pic*/
        v_pic_name = "".
        FIND FIRST CODE_mstr WHERE code_domain = global_domain and CODE_fldname = "xx-image-list"
            AND CODE_value = xxwk1_seller[1]
            NO-LOCK NO-ERROR.
        IF AVAILABLE CODE_mstr THEN v_pic_name = CODE_cmmt.
        IF v_pic_name <> "" THEN DO:
            IF SEARCH(v_pic_name) <> ? THEN DO:
                chPicture = chWorksheet:Pictures:INSERT(v_pic_name).
                chPicture:ShapeRange:Left = 432.75.
                chPicture:ShapeRange:Top  = 2.25.
                chPicture:ShapeRange:Width = 40.
                chPicture:ShapeRange:Height = 80.
            END.
        END.

                        /*header*/
                        i = 1.
                        chWorkbook:worksheets(1):cells(i,6):Font:SIZE = 16.
                        chWorkbook:worksheets(1):cells(i,6):Font:BOLD = TRUE.
                        chWorkSheet:range("F" + string(i) + ":" + "H" + STRING(i)):merge().
                        chWorkbook:worksheets(1):cells(i,6):value = "发票 INVOICE".

        DO j = 1 TO 5:
            chWorkSheet:range("A" + string(j) + ":" + "D" + string(j)):merge().
        END.

        DO j = 6 TO 10:
            chWorkSheet:range("A" + string(j) + ":" + "D" + string(j)):merge().
            chWorkSheet:range("F" + string(j) + ":" + "J" + string(j)):merge().
        END.

        chWorkbook:worksheets(1):cells(6,1):Font:BOLD = TRUE.
        chWorkbook:worksheets(1):cells(6,1):value = "客户 SOLD TO".
        chWorkbook:worksheets(1):cells(6,6):Font:BOLD = TRUE.
        chWorkbook:worksheets(1):cells(6,6):value = "发往 SHIP TO".

        DO j = 1 TO 5:
            chWorkbook:worksheets(1):cells(j    ,1):value = xxwk1_seller[j].
            chWorkbook:worksheets(1):cells(j + 6,1):value = xxwk1_billto[j].
            chWorkbook:worksheets(1):cells(j + 6,6):value = xxwk1_buyer[j].
        END.

        i = 12.
        chWorkSheet:range("A" + string(i) + ":" + "B" + string(i)):merge().
        chWorkSheet:range("F" + string(i) + ":" + "G" + string(i)):merge().
        chWorkbook:worksheets(1):cells(i,1):Font:BOLD = TRUE.
        chWorkbook:worksheets(1):cells(i,1):VALUE = "付款方式 TERMS:".
        chWorkbook:worksheets(1):cells(i,6):Font:BOLD = TRUE.
        chWorkbook:worksheets(1):cells(i,6):VALUE = "运输方式 SHIP VIA:".
        chWorkbook:worksheets(1):cells(i,3):value = xxwk1_payterm.
        chWorkbook:worksheets(1):cells(i,8):value = xxwk1_mot.

        i = i + 1.
        chWorkSheet:range("F" + string(i) + ":" + "G" + string(i)):merge().
        chWorkbook:worksheets(1):cells(i,6):Font:BOLD = TRUE.
        chWorkbook:worksheets(1):cells(i,6):VALUE = "承运人单据 CARRIER DOC.:".
        chWorkbook:worksheets(1):cells(i,8):value = xxwk1_ref[1].

        
        i = i + 1.
        chWorkSheet:range("B" + string(i) + ":" + "C" + string(i)):merge().
        chWorkSheet:range("D" + string(i) + ":" + "E" + string(i)):merge().
        chWorkSheet:range("F" + string(i) + ":" + "G" + string(i)):merge().
        chWorkSheet:range("H" + string(i) + ":" + "I" + string(i)):merge().
        DO k = 2 TO 9:
            chWorkbook:worksheets(1):cells(i,k):Borders(7):LineStyle  = 1.   /* Top border    */
            chWorkbook:worksheets(1):cells(i,k):Borders(7):Weight = 2.      /*  Hairline border's weight */ 
            chWorkbook:worksheets(1):cells(i,k):Borders(8):LineStyle  = 1.   /* Top border    */
            chWorkbook:worksheets(1):cells(i,k):Borders(8):Weight = 2.      /*  Hairline border's weight */ 
            chWorkbook:worksheets(1):cells(i,k):Borders(9):LineStyle  = 1.   /* Top border    */
            chWorkbook:worksheets(1):cells(i,k):Borders(9):Weight = 2.      /*  Hairline border's weight */ 
            chWorkbook:worksheets(1):cells(i,k):Borders(10):LineStyle  = 1.   /* Top border    */
            chWorkbook:worksheets(1):cells(i,k):Borders(10):Weight = 2.      /*  Hairline border's weight */ 
        END.
        chWorkbook:worksheets(1):cells(i,2):Font:BOLD = TRUE.
        chWorkbook:worksheets(1):cells(i,2):value = "客户 CUSTOMER".
        chWorkbook:worksheets(1):cells(i,4):Font:BOLD = TRUE.
        chWorkbook:worksheets(1):cells(i,4):value = "发货日期 SHIP DATE".
        chWorkbook:worksheets(1):cells(i,6):Font:BOLD = TRUE.
        chWorkbook:worksheets(1):cells(i,6):value = "发票日期 INVOICE DATE".
        chWorkbook:worksheets(1):cells(i,8):Font:BOLD = TRUE.
        chWorkbook:worksheets(1):cells(i,8):value = "发票 INVOICE".

        i = i + 1.
        chWorkSheet:range("B" + string(i) + ":" + "C" + string(i)):merge().
        chWorkSheet:range("D" + string(i) + ":" + "E" + string(i)):merge().
        chWorkSheet:range("F" + string(i) + ":" + "G" + string(i)):merge().
        chWorkSheet:range("H" + string(i) + ":" + "I" + string(i)):merge().
        DO k = 2 TO 9:
            chWorkbook:worksheets(1):cells(i,k):Borders(7):LineStyle  = 1.   /* Top border    */
            chWorkbook:worksheets(1):cells(i,k):Borders(7):Weight = 2.      /*  Hairline border's weight */ 
            chWorkbook:worksheets(1):cells(i,k):Borders(8):LineStyle  = 1.   /* Top border    */
            chWorkbook:worksheets(1):cells(i,k):Borders(8):Weight = 2.      /*  Hairline border's weight */ 
            chWorkbook:worksheets(1):cells(i,k):Borders(9):LineStyle  = 1.   /* Top border    */
            chWorkbook:worksheets(1):cells(i,k):Borders(9):Weight = 2.      /*  Hairline border's weight */ 
            chWorkbook:worksheets(1):cells(i,k):Borders(10):LineStyle  = 1.   /* Top border    */
            chWorkbook:worksheets(1):cells(i,k):Borders(10):Weight = 2.      /*  Hairline border's weight */ 
        END.
        chWorkbook:worksheets(1):cells(i,2):value = xxwk1_seller[1].
        chWorkbook:worksheets(1):cells(i,4):value = xxwk1_date[1].
        chWorkbook:worksheets(1):cells(i,6):value = xxwk1_date[1].
        chWorkbook:worksheets(1):cells(i,8):value = xxwk1_inv_nbr.

        /*body*/
        i = 17.	
        chWorkSheet:range("A" + string(i) + ":" + "B" + string(i)):merge().
        chWorkSheet:range("C" + string(i) + ":" + "D" + string(i)):merge().
        chWorkSheet:range("E" + string(i) + ":" + "F" + string(i)):merge().
        chWorkSheet:range("I" + string(i) + ":" + "J" + string(i)):merge().
        DO k = 1 TO 10:
            chWorkbook:worksheets(1):cells(i,k):Borders(7):LineStyle  = 1.   /* Top border    */
            chWorkbook:worksheets(1):cells(i,k):Borders(7):Weight = 2.      /*  Hairline border's weight */ 
            chWorkbook:worksheets(1):cells(i,k):Borders(8):LineStyle  = 1.   /* Top border    */
            chWorkbook:worksheets(1):cells(i,k):Borders(8):Weight = 2.      /*  Hairline border's weight */ 
            chWorkbook:worksheets(1):cells(i,k):Borders(9):LineStyle  = 1.   /* Top border    */
            chWorkbook:worksheets(1):cells(i,k):Borders(9):Weight = 2.      /*  Hairline border's weight */ 
            chWorkbook:worksheets(1):cells(i,k):Borders(10):LineStyle  = 1.   /* Top border    */
            chWorkbook:worksheets(1):cells(i,k):Borders(10):Weight = 2.      /*  Hairline border's weight */ 
        END.
        chWorkbook:worksheets(1):cells(i,1):Font:BOLD = TRUE.
        chWorkbook:worksheets(1):cells(i,1):value = "零件 PART NUMBER".
        chWorkbook:worksheets(1):cells(i,3):Font:BOLD = TRUE.
        chWorkbook:worksheets(1):cells(i,3):value = "描述 DESCRIPTION".
        chWorkbook:worksheets(1):cells(i,5):Font:BOLD = TRUE.
        chWorkbook:worksheets(1):cells(i,5):value = "客户参考 CUSTOMER REF".
        chWorkbook:worksheets(1):cells(i,7):Font:BOLD = TRUE.
        chWorkbook:worksheets(1):cells(i,7):value = "数量 QTY".
        chWorkbook:worksheets(1):cells(i,8):Font:BOLD = TRUE.
        chWorkbook:worksheets(1):cells(i,8):value = "单价 PRICE".
        chWorkbook:worksheets(1):cells(i,9):Font:BOLD = TRUE.
        chWorkbook:worksheets(1):cells(i,9):value = "金额 AMOUNT".

        FOR EACH xxwk2 WHERE xxwk2_inv_nbr = xxwk1_inv_nbr BREAK BY xxwk2_part:
            IF FIRST-OF(xxwk2_part) THEN DO:
                v_part_qty   = 0.
                v_part_price = 0.
                v_part_amt   = 0.
            END.

            v_part_qty = v_part_qty + xxwk2_qty.
            v_part_amt = v_part_amt + xxwk2_amt.
            v_part_price = xxwk2_price.
            xxwk1_tot_amt = xxwk1_tot_amt + xxwk2_amt.

            IF LAST-OF(xxwk2_part) THEN DO:
                IF v_part_qty <> 0 THEN v_part_price = v_part_amt / v_part_qty.
                
                i = i + 1.
                chWorkSheet:range("A" + string(i) + ":" + "B" + string(i)):merge().
                chWorkSheet:range("C" + string(i) + ":" + "D" + string(i)):merge().
                chWorkSheet:range("E" + string(i) + ":" + "F" + string(i)):merge().
                chWorkSheet:range("I" + string(i) + ":" + "J" + string(i)):merge().
                chWorkbook:worksheets(1):cells(i,7):HorizontalAlignment = -4152.
                chWorkbook:worksheets(1):cells(i,8):HorizontalAlignment = -4152.
                chWorkbook:worksheets(1):cells(i,9):HorizontalAlignment = -4152.

                chWorkbook:worksheets(1):cells(i,1):value = xxwk2_part.
                chWorkbook:worksheets(1):cells(i,3):value = xxwk2_desc.
                chWorkbook:worksheets(1):cells(i,5):value = xxwk2_order.
                chWorkbook:worksheets(1):cells(i,7):value = v_part_qty.
                chWorkbook:worksheets(1):cells(i,8):value = v_part_price.
                chWorkbook:worksheets(1):cells(i,9):value = v_part_amt.
                i = i + 1.
                chWorkSheet:range("A" + string(i) + ":" + "B" + string(i)):merge().
                chWorkSheet:range("C" + string(i) + ":" + "D" + string(i)):merge().
                chWorkSheet:range("E" + string(i) + ":" + "F" + string(i)):merge().
                chWorkSheet:range("I" + string(i) + ":" + "J" + string(i)):merge().
                chWorkbook:worksheets(1):cells(i,3):value = xxwk2_desc_ch.
                chWorkbook:worksheets(1):cells(i,5):value = "客户零件号:" + xxwk2_ref_part.
                i = i + 1.
                chWorkSheet:range("A" + string(i) + ":" + "B" + string(i)):merge().
                chWorkSheet:range("C" + string(i) + ":" + "D" + string(i)):merge().
                chWorkSheet:range("E" + string(i) + ":" + "F" + string(i)):merge().
                chWorkSheet:range("I" + string(i) + ":" + "J" + string(i)):merge().
                chWorkbook:worksheets(1):cells(i,5):value = "客户订单号:" + xxwk2_ref_ord.
            END.
        END.
        /*foot*/
        i = i + 1.
        DO k = 1 TO 10:
            chWorkbook:worksheets(1):cells(i,k):Borders(8):LineStyle  = 1.   /* Top border    */
            chWorkbook:worksheets(1):cells(i,k):Borders(8):Weight = 2.      /*  Hairline border's weight */ 
        END.
        chWorkSheet:range("A" + string(i) + ":" + "B" + string(i)):merge().
        chWorkSheet:range("C" + string(i) + ":" + "D" + string(i)):merge().
        chWorkSheet:range("E" + string(i) + ":" + "F" + string(i)):merge().
        chWorkSheet:range("I" + string(i) + ":" + "J" + string(i)):merge().
        chWorkbook:worksheets(1):cells(i,8):HorizontalAlignment = -4152.
        chWorkbook:worksheets(1):cells(i,9):HorizontalAlignment = -4152.
        
        chWorkbook:worksheets(1):cells(i,5):value = "合计 TOTAL".
        chWorkbook:worksheets(1):cells(i,8):value = xxwk1_curr.
        chWorkbook:worksheets(1):cells(i,9):value = xxwk1_tot_amt.

        i = i + 2.
        chWorkSheet:range("A" + string(i) + ":" + "C" + string(i)):merge().
        chWorkbook:worksheets(1):cells(i,1):value = "原产地 COUNTRY OF ORIGIN:".
        chWorkbook:worksheets(1):cells(i,4):value = xxwk1_org.

        i = i + 5.
        chWorkSheet:range("F" + string(i) + ":" + "J" + string(i)):merge().
        chWorkbook:worksheets(1):cells(i,6):value = "签字 SIGNED:___________________________".

        
       
        /*for sheet2 *packlist*/
        chWorkSheet = chWorkbook:workSheets(2).
        chWorkSheet:NAME = "PACKLIST".
        chWorksheet:COLUMNS:Font:SIZE = 10.
        DO j = 1 TO 10:
            chWorkSheet:COLUMNS(j):NumberFormatLocal = "@".
        END.
         
        /*pic*/
        v_pic_name = "".
        FIND FIRST CODE_mstr WHERE code_domain = global_domain and CODE_fldname = "xx-image-list"
            AND CODE_value = xxwk1_seller[1]
            NO-LOCK NO-ERROR.
        IF AVAILABLE CODE_mstr THEN v_pic_name = CODE_cmmt.
        IF v_pic_name <> "" THEN DO:
            IF SEARCH(v_pic_name) <> ? THEN DO:
                chPicture = chWorksheet:Pictures:INSERT(v_pic_name).
                chPicture:ShapeRange:Left = 432.75.
                chPicture:ShapeRange:Top  = 2.25.
                chPicture:ShapeRange:Width = 40.
                chPicture:ShapeRange:Height = 80.
            END.
        END.

        /*header*/ 
        chWorkbook:worksheets(2):cells(1,3):Font:SIZE = 16.
        chWorkbook:worksheets(2):cells(1,3):Font:BOLD = TRUE.
        chWorkSheet:range("C1" + ":" + "E1"):merge().
        /*chWorkbook:worksheets(2):cells(1,3):HorizontalAlignment = -4152.*/
        chWorkbook:worksheets(2):cells(1,3):VALUE = "发货/装箱单".
        chWorkSheet:range("C2" + ":" + "E2"):merge().
        chWorkbook:worksheets(2):cells(2,3):VALUE = "SHIPPING-NOTICE&PACKING LIST".

        chWorkbook:worksheets(2):cells(1,6):HorizontalAlignment = -4152.
        chWorkbook:worksheets(2):cells(1,6):VALUE = "NO:".
        chWorkbook:worksheets(2):cells(1,7):VALUE = xxwk1_inv_nbr.
        chWorkbook:worksheets(2):cells(2,6):HorizontalAlignment = -4152.
        chWorkbook:worksheets(2):cells(2,6):VALUE = "Date:".
        chWorkbook:worksheets(2):cells(2,7):VALUE = xxwk1_date[1].


        DO j = 4 TO 9:
            chWorkSheet:range("A" + string(j) + ":" + "D" + string(j)):merge().
            chWorkSheet:range("F" + string(j) + ":" + "I" + string(j)):merge().
        END.
        chWorkbook:worksheets(2):cells(4,1):Font:BOLD = TRUE.
        chWorkbook:worksheets(2):cells(4,1):value = "供应商 SUPPLIER".
        chWorkbook:worksheets(2):cells(5,1):value = xxwk1_seller[1].
        chWorkbook:worksheets(2):cells(6,1):value = xxwk1_seller[2].
        chWorkbook:worksheets(2):cells(7,1):value = xxwk1_seller[3].
        chWorkbook:worksheets(2):cells(8,1):value = xxwk1_seller[4].
        chWorkbook:worksheets(2):cells(9,1):value = xxwk1_seller[5].

        chWorkbook:worksheets(2):cells(4,6):Font:BOLD = TRUE.
        chWorkbook:worksheets(2):cells(4,6):value = "发往 SHIP-TO".
        chWorkbook:worksheets(2):cells(5,6):value = xxwk1_buyer[1].
        chWorkbook:worksheets(2):cells(6,6):value = xxwk1_buyer[2].
        chWorkbook:worksheets(2):cells(7,6):value = xxwk1_buyer[3].
        chWorkbook:worksheets(2):cells(8,6):value = xxwk1_buyer[4].
        chWorkbook:worksheets(2):cells(9,6):value = xxwk1_buyer[5].

        i = 11.
        chWorkSheet:range("B" + string(i) + ":" + "C" + string(i)):merge().
        chWorkSheet:range("D" + string(i) + ":" + "E" + string(i)):merge().
        chWorkSheet:range("G" + string(i) + ":" + "H" + string(i)):merge().
        chWorkSheet:range("I" + string(i) + ":" + "J" + string(i)):merge().
        DO k = 1 TO 10:
            chWorkbook:worksheets(2):cells(i,k):Borders(7):LineStyle  = 1.   /* Top border    */
            chWorkbook:worksheets(2):cells(i,k):Borders(7):Weight = 2.      /*  Hairline border's weight */ 
            chWorkbook:worksheets(2):cells(i,k):Borders(8):LineStyle  = 1.   /* Top border    */
            chWorkbook:worksheets(2):cells(i,k):Borders(8):Weight = 2.      /*  Hairline border's weight */ 
            chWorkbook:worksheets(2):cells(i,k):Borders(10):LineStyle  = 1.   /* Top border    */
            chWorkbook:worksheets(2):cells(i,k):Borders(10):Weight = 2.      /*  Hairline border's weight */ 
        END.
        chWorkbook:worksheets(2):cells(i,1):Font:BOLD = TRUE.
        chWorkbook:worksheets(2):cells(i,1):value = "箱号".
        chWorkbook:worksheets(2):cells(i,2):Font:BOLD = TRUE.
        chWorkbook:worksheets(2):cells(i,2):value = "零件号".
        chWorkbook:worksheets(2):cells(i,4):Font:BOLD = TRUE.
        chWorkbook:worksheets(2):cells(i,4):value = "零件名称".
        chWorkbook:worksheets(2):cells(i,6):Font:BOLD = TRUE.
        chWorkbook:worksheets(2):cells(i,6):value = "数量".
        chWorkbook:worksheets(2):cells(i,7):Font:BOLD = TRUE.
        chWorkbook:worksheets(2):cells(i,7):value = "净重".
        chWorkbook:worksheets(2):cells(i,9):Font:BOLD = TRUE.
        chWorkbook:worksheets(2):cells(i,9):value = "订单".

        i = 12.
        chWorkSheet:range("B" + string(i) + ":" + "C" + string(i)):merge().
        chWorkSheet:range("D" + string(i) + ":" + "E" + string(i)):merge().
        chWorkSheet:range("G" + string(i) + ":" + "H" + string(i)):merge().
        chWorkSheet:range("I" + string(i) + ":" + "J" + string(i)):merge().
        DO k = 1 TO 10:
            chWorkbook:worksheets(2):cells(i,k):Borders(7):LineStyle  = 1.   /* Top border    */
            chWorkbook:worksheets(2):cells(i,k):Borders(7):Weight = 2.      /*  Hairline border's weight */ 
            chWorkbook:worksheets(2):cells(i,k):Borders(9):LineStyle  = 1.   /* Top border    */
            chWorkbook:worksheets(2):cells(i,k):Borders(9):Weight = 2.      /*  Hairline border's weight */ 
            chWorkbook:worksheets(2):cells(i,k):Borders(10):LineStyle  = 1.   /* Top border    */
            chWorkbook:worksheets(2):cells(i,k):Borders(10):Weight = 2.      /*  Hairline border's weight */ 
        END.
        chWorkbook:worksheets(2):cells(i,1):Font:BOLD = TRUE.
        chWorkbook:worksheets(2):cells(i,1):value = "CASE NO.".
        chWorkbook:worksheets(2):cells(i,2):Font:BOLD = TRUE.
        chWorkbook:worksheets(2):cells(i,2):value = "Buyer P/N".
        chWorkbook:worksheets(2):cells(i,4):Font:BOLD = TRUE.
        chWorkbook:worksheets(2):cells(i,4):value = "DESCRIPTION".
        chWorkbook:worksheets(2):cells(i,6):Font:BOLD = TRUE.
        chWorkbook:worksheets(2):cells(i,6):value = "QTY".
        chWorkbook:worksheets(2):cells(i,7):Font:BOLD = TRUE.
        chWorkbook:worksheets(2):cells(i,7):value = "Net Weight".
        chWorkbook:worksheets(2):cells(i,9):Font:BOLD = TRUE.
        chWorkbook:worksheets(2):cells(i,9):value = "Order".

        /*body*/
        i = 12.
        FOR EACH xxwk3 WHERE xxwk3_inv_nbr = xxwk1_inv_nbr 
            BREAK BY xxwk3_cnt_nbr BY xxwk3_box_nbr:
            IF FIRST-OF(xxwk3_cnt_nbr) THEN DO:
                i = i + 1.
                chWorkSheet:range("A" + string(i) + ":" + "J" + string(i)):merge().
                chWorkbook:worksheets(2):cells(i,1):value = "Container#:" + xxwk3_cnt_nbr.
            END.

            FOR EACH xxwk2 WHERE xxwk2_inv_nbr = xxwk3_inv_nbr 
                AND trim(xxwk2_box_nbr) = trim(xxwk3_box_nbr)
                BY xxwk2_part:
            
                i = i + 1.            
                chWorkSheet:range("B" + string(i) + ":" + "C" + string(i)):merge().
                chWorkSheet:range("D" + string(i) + ":" + "E" + string(i)):merge().
                chWorkSheet:range("G" + string(i) + ":" + "H" + string(i)):merge().
                chWorkSheet:range("I" + string(i) + ":" + "J" + string(i)):merge().
                chWorkbook:worksheets(2):cells(i,6):HorizontalAlignment = -4152.
                chWorkbook:worksheets(2):cells(i,7):HorizontalAlignment = -4152.
             
                chWorkbook:worksheets(2):cells(i,1):value = xxwk2_box_nbr.
                chWorkbook:worksheets(2):cells(i,2):value = xxwk2_part.
                chWorkbook:worksheets(2):cells(i,4):value = xxwk2_desc.
                chWorkbook:worksheets(2):cells(i,6):value = xxwk2_qty.
                chWorkbook:worksheets(2):cells(i,7):value = xxwk2_mfg_nwt.
                chWorkbook:worksheets(2):cells(i,9):value = xxwk2_order + "-" + STRING(xxwk2_line).
            END.
        END.


        /*foot*/
        i = i + 2.
        chWorkSheet:range("A" + string(i) + ":" + "B" + string(i)):merge().
        chWorkSheet:range("D" + string(i) + ":" + "E" + string(i)):merge().
        chWorkSheet:range("G" + string(i) + ":" + "H" + string(i)):merge().
        chWorkSheet:range("I" + string(i) + ":" + "J" + string(i)):merge().
        DO k = 1 TO 10:
            chWorkbook:worksheets(2):cells(i,k):Borders(7):LineStyle  = 1.   /* Top border    */
            chWorkbook:worksheets(2):cells(i,k):Borders(7):Weight = 2.      /*  Hairline border's weight */ 
            chWorkbook:worksheets(2):cells(i,k):Borders(8):LineStyle  = 1.   /* Top border    */
            chWorkbook:worksheets(2):cells(i,k):Borders(8):Weight = 2.      /*  Hairline border's weight */ 
            chWorkbook:worksheets(2):cells(i,k):Borders(10):LineStyle  = 1.   /* Top border    */
            chWorkbook:worksheets(2):cells(i,k):Borders(10):Weight = 2.      /*  Hairline border's weight */ 
        END.
        chWorkbook:worksheets(2):cells(i,1):Font:BOLD = TRUE.
        chWorkbook:worksheets(2):cells(i,1):value = "集装箱号".
        chWorkbook:worksheets(2):cells(i,3):Font:BOLD = TRUE.
        chWorkbook:worksheets(2):cells(i,3):value = "箱号".
        chWorkbook:worksheets(2):cells(i,4):Font:BOLD = TRUE.
        chWorkbook:worksheets(2):cells(i,4):value = "包装箱尺寸".
        chWorkbook:worksheets(2):cells(i,6):Font:BOLD = TRUE.
        chWorkbook:worksheets(2):cells(i,6):value = "数量".
        chWorkbook:worksheets(2):cells(i,7):Font:BOLD = TRUE.
        chWorkbook:worksheets(2):cells(i,7):value = "净重(KGS)".
        chWorkbook:worksheets(2):cells(i,9):Font:BOLD = TRUE.
        chWorkbook:worksheets(2):cells(i,9):value = "毛重(KGS)".
        i = i + 1.
        chWorkSheet:range("A" + string(i) + ":" + "B" + string(i)):merge().
        chWorkSheet:range("D" + string(i) + ":" + "E" + string(i)):merge().
        chWorkSheet:range("G" + string(i) + ":" + "H" + string(i)):merge().
        chWorkSheet:range("I" + string(i) + ":" + "J" + string(i)):merge().
        DO k = 1 TO 10:
            chWorkbook:worksheets(2):cells(i,k):Borders(7):LineStyle  = 1.   /* Top border    */
            chWorkbook:worksheets(2):cells(i,k):Borders(7):Weight = 2.      /*  Hairline border's weight */ 
            chWorkbook:worksheets(2):cells(i,k):Borders(9):LineStyle  = 1.   /* Top border    */
            chWorkbook:worksheets(2):cells(i,k):Borders(9):Weight = 2.      /*  Hairline border's weight */ 
            chWorkbook:worksheets(2):cells(i,k):Borders(10):LineStyle  = 1.   /* Top border    */
            chWorkbook:worksheets(2):cells(i,k):Borders(10):Weight = 2.      /*  Hairline border's weight */ 
        END.
        chWorkbook:worksheets(2):cells(i,1):Font:BOLD = TRUE.
        chWorkbook:worksheets(2):cells(i,1):value = "CONTAINER NO".
        chWorkbook:worksheets(2):cells(i,3):Font:BOLD = TRUE.
        chWorkbook:worksheets(2):cells(i,3):value = "CASE NO".
        chWorkbook:worksheets(2):cells(i,4):Font:BOLD = TRUE.
        chWorkbook:worksheets(2):cells(i,4):value = "DIMENSION".
        chWorkbook:worksheets(2):cells(i,6):Font:BOLD = TRUE.
        chWorkbook:worksheets(2):cells(i,6):value = "QTY".
        chWorkbook:worksheets(2):cells(i,7):Font:BOLD = TRUE.
        chWorkbook:worksheets(2):cells(i,7):value = "NET WEIGHT".
        chWorkbook:worksheets(2):cells(i,9):Font:BOLD = TRUE.
        chWorkbook:worksheets(2):cells(i,9):value = "GROSS WEIGHT".


        FOR EACH xxwk3 WHERE xxwk3_inv_nbr = xxwk1_inv_nbr 
            BREAK BY xxwk3_cnt_nbr BY xxwk3_box_nbr:

            ACCUMULATE xxwk3_qty (TOTAL BY xxwk3_cnt_nbr).
            ACCUMULATE xxwk3_box_gwt (TOTAL BY xxwk3_cnt_nbr).
            ACCUMULATE xxwk3_box_nwt (TOTAL BY xxwk3_cnt_nbr).
            ACCUMULATE xxwk3_box_nbr (COUNT BY xxwk3_cnt_nbr).
            ACCUMULATE xxwk3_mfg_nwt (TOTAL BY xxwk3_cnt_nbr).

            i = i + 1.
            chWorkSheet:range("A" + string(i) + ":" + "B" + string(i)):merge().
            chWorkSheet:range("D" + string(i) + ":" + "E" + string(i)):merge().
            chWorkSheet:range("G" + string(i) + ":" + "H" + string(i)):merge().
            chWorkSheet:range("I" + string(i) + ":" + "J" + string(i)):merge().
            chWorkbook:worksheets(2):cells(i,6):HorizontalAlignment = -4152.
            chWorkbook:worksheets(2):cells(i,7):HorizontalAlignment = -4152.
            chWorkbook:worksheets(2):cells(i,9):HorizontalAlignment = -4152.

            chWorkbook:worksheets(2):cells(i,1):value = xxwk3_cnt_nbr.
            chWorkbook:worksheets(2):cells(i,3):value = xxwk3_box_nbr.
            chWorkbook:worksheets(2):cells(i,4):value = xxwk3_box_dim.
            chWorkbook:worksheets(2):cells(i,6):value = xxwk3_qty.
            chWorkbook:worksheets(2):cells(i,7):value = xxwk3_box_nwt.
            chWorkbook:worksheets(2):cells(i,9):value = xxwk3_box_gwt.

            /*subtotal*/
            IF LAST-OF(xxwk3_cnt_nbr) THEN DO:
                i = i + 1.
                chWorkSheet:range("A" + string(i) + ":" + "B" + string(i)):merge().
                chWorkSheet:range("D" + string(i) + ":" + "E" + string(i)):merge().
                chWorkSheet:range("G" + string(i) + ":" + "H" + string(i)):merge().
                chWorkSheet:range("I" + string(i) + ":" + "J" + string(i)):merge().
                chWorkbook:worksheets(2):cells(i,3):HorizontalAlignment = -4152.
                chWorkbook:worksheets(2):cells(i,6):HorizontalAlignment = -4152.
                chWorkbook:worksheets(2):cells(i,7):HorizontalAlignment = -4152.
                chWorkbook:worksheets(2):cells(i,9):HorizontalAlignment = -4152.

                chWorkbook:worksheets(2):cells(i,3):value = (ACCUM COUNT BY xxwk3_cnt_nbr xxwk3_box_nbr).
                chWorkbook:worksheets(2):cells(i,7):value = (ACCUM TOTAL BY xxwk3_cnt_nbr xxwk3_box_nwt).
                chWorkbook:worksheets(2):cells(i,9):value = (ACCUM TOTAL BY xxwk3_cnt_nbr xxwk3_box_gwt).
            END.
            IF LAST(xxwk3_cnt_nbr) THEN DO:
                i = i + 1.
                chWorkSheet:range("A" + string(i) + ":" + "B" + string(i)):merge().
                chWorkSheet:range("D" + string(i) + ":" + "E" + string(i)):merge().
                chWorkSheet:range("G" + string(i) + ":" + "H" + string(i)):merge().
                chWorkSheet:range("I" + string(i) + ":" + "J" + string(i)):merge().
                DO k = 3 TO 10:
                    chWorkbook:worksheets(2):cells(i,k):Borders(8):LineStyle  = 1.   /* Top border    */
                    chWorkbook:worksheets(2):cells(i,k):Borders(8):Weight = 2.      /*  Hairline border's weight */ 
                END.
                chWorkbook:worksheets(2):cells(i,1):HorizontalAlignment = -4152.
                chWorkbook:worksheets(2):cells(i,3):HorizontalAlignment = -4152.
                chWorkbook:worksheets(2):cells(i,6):HorizontalAlignment = -4152.
                chWorkbook:worksheets(2):cells(i,7):HorizontalAlignment = -4152.
                chWorkbook:worksheets(2):cells(i,9):HorizontalAlignment = -4152.
                chWorkbook:worksheets(2):cells(i,1):value = "合计".
                chWorkbook:worksheets(2):cells(i,3):value = (ACCUM COUNT xxwk3_box_nbr).
                chWorkbook:worksheets(2):cells(i,7):value = (ACCUM TOTAL xxwk3_box_nwt).
                chWorkbook:worksheets(2):cells(i,9):value = (ACCUM TOTAL xxwk3_box_gwt).
            END.
            
        END.




        
        /*for 3 sheet*hssummary*/
        chWorkSheet = chWorkbook:workSheets(3).
        chWorkSheet:NAME = "CHECK".
        chWorksheet:COLUMNS:Font:SIZE = 10.
        DO j = 1 TO 10:
            chWorkSheet:COLUMNS(j):NumberFormatLocal = "@".
        END.

        i = 1.
        chWorkSheet:range("A" + string(i) + ":" + "F" + string(i)):merge().
        chWorkbook:worksheets(3):cells(i,1):value = "HS 汇总".
        i = i + 1.
        chWorkSheet:range("A" + string(i) + ":" + "B" + string(i)):merge().
        chWorkSheet:range("C" + string(i) + ":" + "D" + string(i)):merge().
        chWorkSheet:range("E" + string(i) + ":" + "F" + string(i)):merge().
        DO k = 1 TO 6:
            chWorkbook:worksheets(3):cells(i,k):Borders(7):LineStyle  = 1.   /* Top border    */
            chWorkbook:worksheets(3):cells(i,k):Borders(7):Weight = 2.      /*  Hairline border's weight */ 
            chWorkbook:worksheets(3):cells(i,k):Borders(8):LineStyle  = 1.   /* Top border    */
            chWorkbook:worksheets(3):cells(i,k):Borders(8):Weight = 2.      /*  Hairline border's weight */ 
            chWorkbook:worksheets(3):cells(i,k):Borders(9):LineStyle  = 1.   /* Top border    */
            chWorkbook:worksheets(3):cells(i,k):Borders(9):Weight = 2.      /*  Hairline border's weight */ 
            chWorkbook:worksheets(3):cells(i,k):Borders(10):LineStyle  = 1.   /* Top border    */
            chWorkbook:worksheets(3):cells(i,k):Borders(10):Weight = 2.      /*  Hairline border's weight */ 
        END.
        chWorkbook:worksheets(3):cells(i,1):Font:BOLD = TRUE.
        chWorkbook:worksheets(3):cells(i,1):value = "HS CODE".
        chWorkbook:worksheets(3):cells(i,3):Font:BOLD = TRUE.
        chWorkbook:worksheets(3):cells(i,3):value = "数量 QTY".
        chWorkbook:worksheets(3):cells(i,5):Font:BOLD = TRUE.
        chWorkbook:worksheets(3):cells(i,5):value = "净重 NET WEIGHT".


        FOR EACH xxwk2 WHERE xxwk2_inv_nbr = xxwk1_inv_nbr BREAK BY xxwk2_hscode:
            ACCUMULATE xxwk2_mfg_nwt (TOTAL BY xxwk2_hscode).
            ACCUMULATE xxwk2_qty     (TOTAL BY xxwk2_hscode).
            IF LAST-OF(xxwk2_hscode) THEN DO:
                    i = i + 1.
                    chWorkSheet:range("A" + string(i) + ":" + "B" + string(i)):merge().
                    chWorkSheet:range("C" + string(i) + ":" + "D" + string(i)):merge().
                    chWorkSheet:range("E" + string(i) + ":" + "F" + string(i)):merge().
                    chWorkbook:worksheets(3):cells(i,1):HorizontalAlignment = -4152.
                    chWorkbook:worksheets(3):cells(i,3):HorizontalAlignment = -4152.
                    chWorkbook:worksheets(3):cells(i,5):HorizontalAlignment = -4152.
                    chWorkbook:worksheets(3):cells(i,1):value = xxwk2_hscode.
                    chWorkbook:worksheets(3):cells(i,3):value = (ACCUM TOTAL BY xxwk2_hscode xxwk2_qty).
                    chWorkbook:worksheets(3):cells(i,5):value = (ACCUM TOTAL BY xxwk2_hscode xxwk2_mfg_nwt).
            END.
        END.
        /*for 3 sheet*error*/
        i = i + 5.
        chWorkbook:worksheets(3):cells(i,1):value = "检查结果:".
        FOR EACH xxwk4 WHERE xxwk4_doc_nbr = xxwk1_inv_nbr BY xxwk4_err_type:
            i = i + 1.
            chWorkbook:worksheets(3):cells(i,1):value = xxwk4_err_type + ":" + xxwk4_err_desc + "(" + xxwk4_err_cmt + ")".
        END.



        /*close*/
        chExcel:DisplayAlerts = FALSE.
        chWorkbook:SaveAs(p_fname,, , ,,,).
        chWorkbook:CLOSE.
        chExcel:QUIT.

        IF VALID-HANDLE(chPicture) THEN RELEASE OBJECT chPicture.
        RELEASE OBJECT chWorksheet.
        RELEASE OBJECT chWorkbook.
        RELEASE OBJECT chExcel.
    END.


    p_sys_status = "0".
END PROCEDURE.

/*-----------------------*/
PROCEDURE xxpro-view:
    def input parameter p_fname as char.
    DEF VAR chExcel AS COM-HANDLE.
    DEF VAR chWorkbook AS COM-HANDLE.
    DEF VAR chWorksheet AS COM-HANDLE.

    CREATE "Excel.Application" chExcel.
    chExcel:VISIBLE = YES.
    chWorkbook = chExcel:Workbooks:Open(p_fname).
    chWorkSheet = chWorkbook:workSheets(1).


    MESSAGE "关闭EXCEL，返回" VIEW-AS ALERT-BOX BUTTONS OK.  
    /* Perform housekeeping and cleanup steps */
    chExcel:Application:Workbooks:CLOSE() NO-ERROR.
    chExcel:Application:QUIT NO-ERROR.

    RELEASE OBJECT chWorksheet.
    RELEASE OBJECT chWorkbook.
    RELEASE OBJECT chExcel.
END PROCEDURE.

/*-----------*/
PROCEDURE xxpro-bud-xxwk4:
    DEF INPUT PARAMETER p_nbr AS CHAR.
    DEF INPUT PARAMETER p_type AS CHAR.
    DEF INPUT PARAMETER p_id AS CHAR.
    DEF INPUT PARAMETER p_cmt AS CHAR.

    CREATE xxwk4.
    ASSIGN 
        xxwk4_doc_nbr  = p_nbr
        xxwk4_err_type = p_type
        xxwk4_err_desc = p_id
        xxwk4_err_cmt  = p_cmt.
    RELEASE xxwk4.
END.


/*****************/
PROCEDURE xxpro-check-data:
    
    DEF VAR v_check_price AS DECIMAL.

    FOR EACH xxwk1:
        FOR EACH xxwk2 WHERE xxwk2_inv_nbr = xxwk1_inv_nbr:
            /*check price*/
            v_check_price = f-getsoprice(xxwk2_order, xxwk2_mfg_line, xxwk1_date[1], xxwk2_qty).
            IF v_check_price <> xxwk2_price THEN
            RUN xxpro-bud-xxwk4 ( INPUT xxwk1_inv_nbr, INPUT "Price", INPUT "EDI and MFG does not match", INPUT STRING(xxwk2_price) + "<>" + STRING(v_check_price)).
        END.
        IF xxwk1_tot_nwt > xxwk1_tot_gwt THEN
            RUN xxpro-bud-xxwk4 ( INPUT xxwk1_inv_nbr, INPUT "Weight", INPUT "Net Weight > Gross Weight", INPUT STRING(xxwk1_tot_nwt) + ">" + STRING(xxwk1_tot_gwt)).
        IF xxwk1_tot_nwt <> xxwk1_mfg_nwt THEN
            RUN xxpro-bud-xxwk4 ( INPUT xxwk1_inv_nbr, INPUT "Weight", INPUT "Net Weight <> DCEC's", INPUT STRING(xxwk1_tot_nwt) + "<>" + STRING(xxwk1_mfg_nwt)).
    END.

    
    /*check netweight*/
    

END PROCEDURE.                                      
