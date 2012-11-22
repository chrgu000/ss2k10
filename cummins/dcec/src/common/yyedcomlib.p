/*xxedcomlib.p - common function lib*/

{mfdeclre.i}



/*-------------------------------------------------------**
 *get po price
**-------------------------------------------------------*/
function f-getpoprice returns DECIMAL
    (input v_inp_ponbr as CHARACTER,
     INPUT v_inp_poln  AS INTEGER,
     INPUT v_inp_effdt AS DATE,
     INPUT v_inp_qty   AS DECIMAL):

    DEF VAR v_out_results AS DECIMAL.
    DEF VAR jk AS INTEGER.

    v_out_results = 0.

    FIND FIRST pod_det WHERE pod_domain = global_domain and 
    					 pod_nbr = v_inp_ponbr AND pod_line = v_inp_poln NO-LOCK NO-ERROR.
    FIND FIRST po_mstr WHERE po_domain = global_domain and
    				   po_nbr = v_inp_ponbr NO-LOCK NO-ERROR.

    IF AVAILABLE pod_det AND AVAILABLE po_mstr THEN DO:
        v_out_results = pod_pur_cost. 
        IF pod_pr_list <> "" THEN DO:
            for last pc_mstr
            fields(pc_amt pc_amt_type pc_curr pc_expire pc_list
            pc_min_qty pc_part pc_prod_line pc_start pc_um)
            where pc_domain    = global_domain and
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


    FIND FIRST pt_mstr WHERE pt_domain = global_domain and
    					 pt_mstr.pt_part = v_inp_part NO-LOCK NO-ERROR.
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


    FIND FIRST ad_mstr WHERE ad_domain = global_domain and
    				   ad_mstr.ad_addr = v_inp_addr NO-LOCK NO-ERROR.
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

    FIND FIRST sod_det WHERE sod_domain = global_domain and 
    				   sod_nbr = v_inp_sonbr AND sod_line = v_inp_soln NO-LOCK NO-ERROR.
    FIND FIRST so_mstr WHERE so_domain = global_domain and
               so_nbr = v_inp_sonbr NO-LOCK NO-ERROR.

    IF AVAILABLE sod_det AND AVAILABLE so_mstr THEN DO:
        v_out_results = sod_price.
        IF sod_pr_list <> "" THEN DO:
            for last pc_mstr
            fields(pc_amt pc_amt_type pc_curr pc_expire pc_list
            pc_min_qty pc_part pc_prod_line pc_start pc_um)
            where pc_domain    = global_domain and
                  pc_list      = sod_pr_list   and
                  pc_part      = sod_part      and
                  pc_um        = sod_um        and
                  (pc_start    <= v_inp_effdt or pc_start = ?)  and
                  (pc_expire   >= v_inp_effdt or pc_expire = ?) and
                  pc_curr      = so_curr                        and
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
function f-howareyou returns LOGICAL
    (input v_welcome as CHAR):

    DEF VAR v_out_results AS LOGICAL.

    v_out_results = yes.

/*check lic and expire date
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
*/


    RETURN v_out_results.
END FUNCTION.
