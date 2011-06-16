/* ������ʱ�� - ���� */

{mfdeclre.i }
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

/* ���� */   
{xxssdim2s.i}

/* ѡ������ */
DEFINE INPUT PARAMETER site_ih LIKE ih_site.
DEFINE INPUT PARAMETER cust_ih LIKE ih_cust.
DEFINE INPUT PARAMETER effdate_tr LIKE tr_effdate.
DEFINE INPUT PARAMETER effdate_tr1 LIKE tr_effdate.
DEFINE INPUT PARAMETER ship_id_tr LIKE tr_ship_id.
DEFINE INPUT PARAMETER ship_id_tr1 LIKE tr_ship_id.
DEFINE INPUT PARAMETER po_ih LIKE ih_po.
DEFINE INPUT PARAMETER po_ih1 LIKE ih_po.

/* ��Ʊ�޶� */
DEFINE VARIABLE amt_max AS DECIMAL.
/* ��Ʊ�޶��ݲ� */
DEFINE VARIABLE amt_tol AS DECIMAL.
/* ��һ����Ʊ��ע */
DEFINE VARIABLE SoftspeedDI_VAT AS DECIMAL.

/* ��Ʊ�ۼƶ� */
DEFINE VARIABLE amt_acc AS DECIMAL.
/* ��Ʊ���� */
DEFINE VARIABLE qty_partial AS DECIMAL.
/* δ������ */
DEFINE VARIABLE qty_open AS DECIMAL.

/* ���� */
/* ss - 090901.1 -b */
for each  tt1 :
delete tt1 .
end .
/* ss - 090901.1 -e */
/* ��Ʊ�޶� */
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

/* ��Ʊ�޶��ݲ� */
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

/* ��һ����Ʊ��ע */
{xxssdim2a1.i}

/* �����Ѿ�ѡ��ļ�¼ */
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
   /* ��������������� */
   BY tr_part
   BY tr_effdate
   BY tr_trnbr
   :
   qty_open = usrw_decfld[4].
   IF amt_acc + qty_open * idh_price <= amt_max THEN DO:
      qty_partial = qty_open.
      /* ���� */
      {xxssdim2a2.i}

      NEXT.
   END.

   /* ������Ʊ�޶� */
   qty_open = usrw_decfld[4].
   REPEAT:
      /* �˳�ѭ�� */
      IF qty_open = 0 THEN DO:
         LEAVE.
      END.

      /* �˳�ѭ�� */
      IF amt_acc + qty_open * idh_price <= amt_max THEN DO:
         qty_partial = qty_open.
         /* ���� */
         {xxssdim2a2.i}

         LEAVE.
      END.

      REPEAT:
         qty_partial = TRUNCATE((amt_max - amt_acc) / idh_price, 0).

         /* ���۴��ڷ�Ʊ�޶��ݲ� */
         /* ������۴��ڷ�Ʊ�޶�,��ѭ�� */
         IF qty_partial = 0 THEN DO:
            amt_acc = 0.
            /* ��һ����Ʊ��ע */
            {xxssdim2a1.i}
         END.

         LEAVE.
      END.

      /* ���� */
      {xxssdim2a2.i}

      qty_open = qty_open - qty_partial.
   END.
END.
