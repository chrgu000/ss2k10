/* 创建临时表 - 增加 */

{mfdeclre.i }
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

  /* ss - 090929.1 by: jack */  /* 去除sales 限制*/

/* 共享 */   
{xxssirm2s.i}

/* 选择条件 */
DEFINE INPUT PARAMETER site_so LIKE so_site.
DEFINE INPUT PARAMETER cust_so LIKE so_cust.
DEFINE INPUT PARAMETER effdate_tr LIKE tr_effdate.
DEFINE INPUT PARAMETER effdate_tr1 LIKE tr_effdate.
/* ss - 090929.1 -b
DEFINE INPUT PARAMETER ship_id_tr LIKE tr_ship_id.
DEFINE INPUT PARAMETER ship_id_tr1 LIKE tr_ship_id.
ss - 090929.1 -e */
DEFINE INPUT PARAMETER po_so LIKE so_po.
DEFINE INPUT PARAMETER po_so1 LIKE so_po.

/* 发票限额 */
DEFINE VARIABLE amt_max AS DECIMAL.
/* 发票限额容差 */
DEFINE VARIABLE amt_tol AS DECIMAL.
/* 下一个发票备注 */
DEFINE VARIABLE SoftspeedIR_VAT AS DECIMAL.

/* 发票累计额 */
DEFINE VARIABLE amt_acc AS DECIMAL.
/* 发票数量 */
DEFINE VARIABLE qty_partial AS DECIMAL.
/* 未结数量 */
DEFINE VARIABLE qty_open AS DECIMAL.

/* 共享 */

FOR EACH  tt1:
    DELETE tt1 .
END.

/* 发票限额 */
FIND FIRST mfc_ctrl 
   WHERE /* mfc_domain = GLOBAL_domain
   AND */ mfc_field = 'SoftspeedIR_Max'
   NO-LOCK NO-ERROR.
IF NOT AVAILABLE mfc_ctrl THEN DO:
   /* Control table error.  Check applicable control tables */
   {pxmsg.i &MSGNUM=594 &ERRORLEVEL=3}
   RETURN.
END.
ELSE DO:
   amt_max = mfc_decimal.
END.

/* 发票限额容差 */
FIND FIRST mfc_ctrl 
   WHERE /* mfc_domain = GLOBAL_domain
   AND */ mfc_field = 'SoftspeedIR_Tol'
   NO-LOCK NO-ERROR.
IF NOT AVAILABLE mfc_ctrl THEN DO:
   /* Control table error.  Check applicable control tables */
   {pxmsg.i &MSGNUM=594 &ERRORLEVEL=3}
   RETURN.
END.
ELSE DO:
   amt_tol = mfc_decimal.
END.

/* 下一个发票备注 */
{xxssirm2a1.i}

 /* ss - 090929.1 -b
/* KI - B */
DEFINE VARIABLE value_code_ki AS CHARACTER.
DEFINE VARIABLE find-can_ki AS LOGICAL.
DEFINE VARIABLE i1_ki AS INTEGER.

value_code_ki = "".
RUN get-sales-person-list_ki (INPUT-OUTPUT value_code_ki).
/* KI - E */
ss - 090929.1 -e */

/* 锁定已经选择的记录 */
amt_acc = 0.
FOR EACH usrw_wkfl EXCLUSIVE-LOCK
   WHERE /* usrw_domain = GLOBAL_domain
   AND */ usrw_key1 = 'SoftspeedIR_History'
   AND usrw_decfld[4] <> 0
   ,EACH tr_hist NO-LOCK
   WHERE /* tr_domain = GLOBAL_domain
   AND*/ tr_trnbr = usrw_intfld[1]
   AND tr_effdate >= effdate_tr
   AND tr_effdate <= effdate_tr1
   AND (  /* ss - 090929..1 -b (tr_ship_id >= ship_id_tr AND tr_ship_id <= ship_id_tr1) OR ss -090929.1 -e */ 
        tr_ship_id = '')
   ,EACH so_mstr NO-LOCK
   WHERE /* so_domain = GLOBAL_domain
   /*
   AND so_inv_nbr = tr_rmks
   */
   AND */ so_nbr = tr_nbr
   AND so_site = site_so
   AND so_cust = cust_so
   AND ((so_po >= po_so AND so_po <= po_so1) OR so_po = '')
   ,EACH sod_det NO-LOCK
   WHERE /* sod_domain = GLOBAL_domain
   AND  */ sod_nbr = so_nbr
   AND sod_line = tr_line
   /* 按零件和日期排序 */
   BY tr_part
   BY tr_effdate
   BY tr_trnbr
   :
    /* ss - 090929.1 -b
   /* KI - B */
   find-can_ki = NO.
   DO i1_ki = 1 TO 4:
      IF LOOKUP(so_slspsn[i1_ki],value_code_ki) <> 0 THEN DO:
         find-can_ki = YES.
         LEAVE.
      END.
   END.
   IF find-can_ki = NO THEN DO:
      NEXT.
   END.
   /* KI - E */
   ss - 090929.1 -e */
    

   qty_open = usrw_decfld[4].
   IF amt_acc + qty_open * sod_price <= amt_max THEN DO:
      qty_partial = qty_open.
      /* 创建 */
      {xxssirm2a2.i}

      NEXT.
   END.

   /* 超过发票限额 */
   qty_open = usrw_decfld[4].
   REPEAT:

      
      /* 退出循环 */
      IF qty_open = 0 THEN DO:
         LEAVE.
      END.

      /* 退出循环 */
      IF amt_acc + qty_open * sod_price <= amt_max THEN DO:
         qty_partial = qty_open.
         /* 创建 */
         {xxssirm2a2.i}

             

         LEAVE.
      END.

        REPEAT:
           qty_partial = TRUNCATE((amt_max - amt_acc) / sod_price, 0).

             /* 单价大于发票限额容差 */
             /* 如果单价大于发票限额,死循环 */
               IF qty_partial = 0 THEN DO:
               amt_acc = 0.
               /* 下一个发票备注 */
                {xxssirm2a1.i}
               END.
            
           LEAVE.
         END.

      /* 创建 */
      {xxssirm2a2.i}

      qty_open = qty_open - qty_partial.

       
   END.

    

END.

/* ss - 090929.1 -b
/* KI - B */
procedure get-sales-person-list_ki:
    define INPUT-OUTPUT parameter value_code_ki   as char .

    for each code_mstr 
        where /* code_domain = global_domain and */ code_fldname = GLOBAL_userid 
        no-lock :

        IF LOOKUP(CODE_value,value_code_ki,",") = 0 THEN DO:
           find first sp_mstr where /* sp_domain = global_domain and */ sp_addr = code_value no-lock no-error .
           if avail sp_mstr then do:
              IF value_code_ki = "" THEN DO:
                 value_code_ki = CODE_value.
              END.
              ELSE DO:
                 value_code_ki = value_code_ki + "," + CODE_value.
              END.
           end.
        END.

        /*这一行一定要放在for each的最后*/
        run get-sales-person-list_ki (INPUT-OUTPUT value_code_ki ).
    end. /*for each code_mstr*/

end procedure . /*get-sales-person-list_ki*/
/* KI - E */
ss - 090929.1 -e */
