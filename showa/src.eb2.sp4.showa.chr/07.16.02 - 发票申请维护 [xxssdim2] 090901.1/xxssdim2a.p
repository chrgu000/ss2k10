/* 创建临时表 - 增加 */

{mfdeclre.i }
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

/* 共享 */   
{xxssdim2s.i}

/* 选择条件 */
DEFINE INPUT PARAMETER site_ih LIKE ih_site.
DEFINE INPUT PARAMETER cust_ih LIKE ih_cust.
DEFINE INPUT PARAMETER effdate_tr LIKE tr_effdate.
DEFINE INPUT PARAMETER effdate_tr1 LIKE tr_effdate.
DEFINE INPUT PARAMETER ship_id_tr LIKE tr_ship_id.
DEFINE INPUT PARAMETER ship_id_tr1 LIKE tr_ship_id.
DEFINE INPUT PARAMETER po_ih LIKE ih_po.
DEFINE INPUT PARAMETER po_ih1 LIKE ih_po.

/* 发票限额 */
DEFINE VARIABLE amt_max AS DECIMAL.
/* 发票限额容差 */
DEFINE VARIABLE amt_tol AS DECIMAL.
/* 下一个发票备注 */
DEFINE VARIABLE SoftspeedDI_VAT AS DECIMAL.

/* 发票累计额 */
DEFINE VARIABLE amt_acc AS DECIMAL.
/* 发票数量 */
DEFINE VARIABLE qty_partial AS DECIMAL.
/* 未结数量 */
DEFINE VARIABLE qty_open AS DECIMAL.

/* 共享 */
/* ss - 090901.1 -b */
for each  tt1 :
delete tt1 .
end .
/* ss - 090901.1 -e */
/* 发票限额 */
FIND FIRST mfc_ctrl 
   WHERE mfc_field = 'SoftspeedDI_Max'
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
   WHERE mfc_field = 'SoftspeedDI_Tol'
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
{xxssdim2a1.i}

/* 锁定已经选择的记录 */
amt_acc = 0.
FOR EACH usrw_wkfl EXCLUSIVE-LOCK
   WHERE usrw_key1 = 'SoftspeedDI_History'
   AND usrw_decfld[4] <> 0
   ,EACH tr_hist NO-LOCK
   WHERE tr_trnbr = usrw_intfld[1]
   AND tr_effdate >= effdate_tr
   AND tr_effdate <= effdate_tr1
   AND ((tr_ship_id >= ship_id_tr AND tr_ship_id <= ship_id_tr1) OR tr_ship_id = '')
   ,EACH ih_hist NO-LOCK
   WHERE ih_inv_nbr = tr_rmks
   AND ih_nbr = tr_nbr
   AND ih_site = site_ih
   AND ih_cust = cust_ih
   AND ((ih_po >= po_ih AND ih_po <= po_ih1) OR ih_po = '')
   ,EACH idh_hist NO-LOCK
   WHERE idh_inv_nbr = ih_inv_nbr
   AND idh_nbr = ih_nbr
   AND idh_line = tr_line
   /* 按零件和日期排序 */
   BY tr_part
   BY tr_effdate
   BY tr_trnbr
   :
   qty_open = usrw_decfld[4].
   IF amt_acc + qty_open * idh_price <= amt_max THEN DO:
      qty_partial = qty_open.
      /* 创建 */
      {xxssdim2a2.i}

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
      IF amt_acc + qty_open * idh_price <= amt_max THEN DO:
         qty_partial = qty_open.
         /* 创建 */
         {xxssdim2a2.i}

         LEAVE.
      END.

      REPEAT:
         qty_partial = TRUNCATE((amt_max - amt_acc) / idh_price, 0).

         /* 单价大于发票限额容差 */
         /* 如果单价大于发票限额,死循环 */
         IF qty_partial = 0 THEN DO:
            amt_acc = 0.
            /* 下一个发票备注 */
            {xxssdim2a1.i}
         END.

         LEAVE.
      END.

      /* 创建 */
      {xxssdim2a2.i}

      qty_open = qty_open - qty_partial.
   END.
END.
