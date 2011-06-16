/* ������ʱ�� - ���� */

{mfdeclre.i }
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

  /* ss - 090929.1 by: jack */  /* ȥ��sales ����*/

/* ���� */   
{xxssirm2s.i}

/* ѡ������ */
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

/* ��Ʊ�޶� */
DEFINE VARIABLE amt_max AS DECIMAL.
/* ��Ʊ�޶��ݲ� */
DEFINE VARIABLE amt_tol AS DECIMAL.
/* ��һ����Ʊ��ע */
DEFINE VARIABLE SoftspeedIR_VAT AS DECIMAL.

/* ��Ʊ�ۼƶ� */
DEFINE VARIABLE amt_acc AS DECIMAL.
/* ��Ʊ���� */
DEFINE VARIABLE qty_partial AS DECIMAL.
/* δ������ */
DEFINE VARIABLE qty_open AS DECIMAL.

/* ���� */

FOR EACH  tt1:
    DELETE tt1 .
END.

/* ��Ʊ�޶� */
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

/* ��Ʊ�޶��ݲ� */
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

/* ��һ����Ʊ��ע */
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

/* �����Ѿ�ѡ��ļ�¼ */
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
   /* ��������������� */
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
      /* ���� */
      {xxssirm2a2.i}

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
      IF amt_acc + qty_open * sod_price <= amt_max THEN DO:
         qty_partial = qty_open.
         /* ���� */
         {xxssirm2a2.i}

             

         LEAVE.
      END.

        REPEAT:
           qty_partial = TRUNCATE((amt_max - amt_acc) / sod_price, 0).

             /* ���۴��ڷ�Ʊ�޶��ݲ� */
             /* ������۴��ڷ�Ʊ�޶�,��ѭ�� */
               IF qty_partial = 0 THEN DO:
               amt_acc = 0.
               /* ��һ����Ʊ��ע */
                {xxssirm2a1.i}
               END.
            
           LEAVE.
         END.

      /* ���� */
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

        /*��һ��һ��Ҫ����for each�����*/
        run get-sales-person-list_ki (INPUT-OUTPUT value_code_ki ).
    end. /*for each code_mstr*/

end procedure . /*get-sales-person-list_ki*/
/* KI - E */
ss - 090929.1 -e */
