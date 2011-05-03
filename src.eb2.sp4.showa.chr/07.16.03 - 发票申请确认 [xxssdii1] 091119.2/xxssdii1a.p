/* SS - 090511.1 By: Bill Jiang */
/* ss - 090824.1 by: jack */ /* 将eb21转为 eb2sp4*/
/* ss - 090831.1 by: jack */ /* 确认时取实际价格*/
/* ss - 090903.1 by: jack */ /* 去除参考号格式*/
/* ss - 090904.1 by: jack */ /* 价格取客户销售价格单种价格*/
/* ss - 090916.1 by: jack */ 
/* ss - 091112.1 by: jack */
/* ss - 091119.1 by: jack */  /* 考虑外币汇率格式*/
{mfdeclre.i}
/* EXTERNALIZED LABEL INCLUDE */
{gplabel.i}
{pxmaint.i}

/* DETERMINE INPUT DIRECTORY AND FILENAME */
{gpdirpre.i}

{xxcimimp.i}

define INPUT PARAMETER nbr like rqm_mstr.rqm_nbr no-undo.
define INPUT PARAMETER nbr1 like rqm_mstr.rqm_nbr no-undo.
define INPUT PARAMETER enterdate like rqh_date no-undo.
define INPUT PARAMETER enterdate1 like rqh_date no-undo.
define INPUT PARAMETER apr_userid like rqh_apr_userid no-undo.
define INPUT PARAMETER apr_userid1 like rqh_apr_userid no-undo.
define INPUT PARAMETER SoftspeedDI_inv like mfc_integer no-undo.
define INPUT PARAMETER show_email_ids like mfc_logical no-undo.

DEFINE VARIABLE SoftspeedDI_so_pre AS CHARACTER EXTENT 4.
DEFINE VARIABLE SoftspeedDI_sod_type LIKE sod_type EXTENT 4.
DEFINE VARIABLE SoftspeedDI_inv_pre AS CHARACTER EXTENT 4.
DEFINE STREAM s1.
DEFINE STREAM s2.

DEFINE VARIABLE infile AS CHARACTER EXTENT 2.
DEFINE VARIABLE outfile AS CHARACTER EXTENT 2.
DEFINE VARIABLE log_infile AS CHARACTER EXTENT 2.
DEFINE VARIABLE log_outfile AS CHARACTER EXTENT 2.
DEFINE VARIABLE i1 AS INTEGER.
DEFINE VARIABLE i2 AS INTEGER.
define variable recount       as integer format ">>>>>>>>9"
   label "Records Loaded" NO-UNDO.
define variable errcount      as integer format ">>>>>>>>9"
   label "Errors" NO-UNDO.
DEFINE VARIABLE LONG_lbl LIKE lbl_long.

DEFINE VARIABLE req_qty_rqd LIKE rqd_det.rqd_req_qty.

DEFINE TEMP-TABLE tt2
   FIELD tt2_c1 AS CHARACTER EXTENT 2
   .

   /* ss - 090916.1 -b */
   define var v_list_price like xxpi_list_price .
   /* ss - 090916.1 -e */

DEFINE TEMP-TABLE tt3 NO-UNDO
   FIELD tt3_nbr LIKE rqm_mstr.rqm_nbr
   FIELD tt3_part LIKE rqd_part
   FIELD tt3_trnbr LIKE tr_trnbr
   FIELD tt3_error AS CHARACTER
   .

SoftspeedDI_so_pre[1] = "SoftspeedDI_so_pre1".
SoftspeedDI_so_pre[2] = "SoftspeedDI_so_pre2".
SoftspeedDI_sod_type[1] = "SoftspeedDI_sod_type1".
SoftspeedDI_sod_type[2] = "SoftspeedDI_sod_type2".
SoftspeedDI_inv_pre[1] = "SoftspeedDI_inv_pre1".
SoftspeedDI_inv_pre[2] = "SoftspeedDI_inv_pre2".

DO i1 = 1 TO 2:
 /* ss - 090824.1 -b
   FIND FIRST mfc_ctrl 
      WHERE mfc_domain = GLOBAL_domain 
      AND mfc_field = SoftspeedDI_sod_type[i1]
      NO-LOCK NO-ERROR.
   ss - 090824.1 -e */

/* ss - 090824.1 -b */
 FIND FIRST mfc_ctrl 
      WHERE  mfc_field = SoftspeedDI_sod_type[i1]
      NO-LOCK NO-ERROR.
  /* ss - 090824.1 -e */
   IF NOT AVAILABLE mfc_ctr THEN DO:
      /* Control table error.  Check applicable control tables */
      {pxmsg.i &MSGNUM=594 &ERRORLEVEL=3}
      undo, RETURN.
   END.
   SoftspeedDI_sod_type[i1 + 2] = mfc_char.
END.

loop1:
/* ss - 090824.1 -b
FOR EACH rqm_mstr NO-LOCK
   WHERE rqm_domain = GLOBAL_domain
   AND rqm_nbr >= nbr
   AND rqm_nbr <= nbr1
   AND rqm_req_date >= enterdate
   AND rqm_req_date <= enterdate1
   AND rqm_rqby_userid >= apr_userid
   AND rqm_rqby_userid <= apr_userid1
   /* 不包括已结的申请 */
   AND rqm_open = NO
   /* 仅限已打印 */
   AND rqm_status = "P"
   :
 ss - 090824.1 -e */
 /* ss - 090824.1 -b */
 FOR EACH rqm_mstr NO-LOCK
   WHERE  rqm_nbr >= nbr
   AND rqm_nbr <= nbr1
   AND rqm_req_date >= enterdate
   AND rqm_req_date <= enterdate1
   AND rqm_rqby_userid >= apr_userid
   AND rqm_rqby_userid <= apr_userid1
   /* 不包括已结的申请 */
   AND rqm_open = NO
   /* 仅限已打印 */
   AND rqm_status = "P"
   :

 /* ss - 090824.1 -e */

/* ss - 090824.1 -b
   FOR EACH rqd_det NO-LOCK
      WHERE rqd_domain = GLOBAL_domain
      AND rqd_nbr = rqm_nbr
      /* 不包括已结的申请 */
      AND rqd_open = NO
      ,EACH tr_hist NO-LOCK
      WHERE tr_domain = GLOBAL_domain
      AND tr_trnbr = rqd_cmtindx
      ,EACH ih_hist NO-LOCK
      WHERE ih_domain = GLOBAL_domain
      AND ih_inv_nbr = tr_rmks
      AND ih_nbr = tr_nbr
      ,EACH idh_hist NO-LOCK
      WHERE idh_domain = GLOBAL_domain
      AND idh_inv_nbr = ih_inv_nbr
      AND idh_nbr = ih_nbr
      AND idh_line = tr_line
      BREAK
      BY rqd_part
      BY idh_inv_nbr
      BY idh_nbr
      BY idh_line
      BY rqd_cmtindx
      :
 ss - 090824.1 -e */
 /* ss - 090824.1 -b */
   FOR EACH rqd_det NO-LOCK
      WHERE  rqd_nbr = rqm_nbr
      /* 不包括已结的申请 */
      AND rqd_open = NO
      ,EACH tr_hist NO-LOCK
      WHERE  tr_trnbr = rqd_cmtindx
      ,EACH ih_hist NO-LOCK
      WHERE  ih_inv_nbr = tr_rmks
      AND ih_nbr = tr_nbr
      ,EACH idh_hist NO-LOCK
      WHERE  idh_inv_nbr = ih_inv_nbr
      AND idh_nbr = ih_nbr
      AND idh_line = tr_line
      BREAK
      BY rqd_part
      BY idh_inv_nbr
      BY idh_nbr
      BY idh_line
      BY rqd_cmtindx
      :
 
 /* ss - 090824.1 -e */

      /* 头栏 - B */
      IF FIRST-OF(rqd_part) THEN DO:
         /* 增值税专用发票 */
	 /* ss - 090824.1 -b
         FIND FIRST mfc_ctrl 
            WHERE mfc_domain = GLOBAL_domain 
            AND mfc_field = "SoftspeedDI_inv"
            EXCLUSIVE-LOCK NO-ERROR.
          ss - 090824.1 -e */
	  /* ss - 090824.1 -b */
	  FIND FIRST mfc_ctrl 
            WHERE  mfc_field = "SoftspeedDI_inv"
            EXCLUSIVE-LOCK NO-ERROR.
	  /* ss - 090824.1 -e */
	 IF NOT AVAILABLE mfc_ctr THEN DO:
            /* Control table error.  Check applicable control tables */
            {pxmsg.i &MSGNUM=594 &ERRORLEVEL=3}
            undo, RETURN.
         END.
         SoftspeedDI_inv = mfc_integer.
         mfc_integer = mfc_integer + 1.
	
	/* ss - 090904.1 -b
	 /* ss - 090831.1 - b */
	  find last pi_mstr where pi_list = ih_bill and pi_cs_type = "9"
            and pi_cs_code = ih_bill and pi_part_type = "6" and pi_part_code = idh_part
            and pi_curr = tr_curr and pi_um = tr_um and ((pi_start <= today ) and (pi_expire >= today or pi_expire = ?)) no-lock no-error .
           if not available pi_mstr then do:  /* 无效价格单*/
           {pxmsg.i &MSGNUM=2022 &ERRORLEVEL=3}
             undo, RETURN.
           end .
	 /* ss - 090831.1 - -e */
	 ss - 090904.1 -e */

	 /* ss - 090904.1 -b */
	 /* ss - 090916.1 -b */
	/* ss - 091112.1 -b
	 /* ss - 090916.1 -e */
	 find last xxpi_mstr where xxpi_list = ih_bill and xxpi_part = idh_part and xxpi_curr = tr_curr and xxpi_um = tr_um
	   and ( ( xxpi_start <= today and xxpi_start <> ? ) or  xxpi_start = ?  ) 
	   and  ( ( xxpi_expire > today and xxpi_expire <> ? ) or xxpi_expire = ?) no-lock no-error .
	   if not available xxpi_mstr then do:
	   /* ss - 090916.1 -b */
	   v_list_price = 0 .
	   /* ss - 090916.1 -e */
	     {pxmsg.i &MSGNUM=2022 &ERRORLEVEL=3}
             undo, RETURN.
	   end .
	   /* ss - 090916.1 -b */
	   else 
	   v_list_price = xxpi_list_price .

	 /* ss - 090904.1 -e */
     ss - 091112.1 -e */

         DO i1 = 1 TO 2:
            /* 订单前缀及其序号 */
	    /* ss - 090824.1 -b
            FIND FIRST mfc_ctrl 
               WHERE mfc_domain = GLOBAL_domain 
               AND mfc_field = SoftspeedDI_so_pre[i1]
               EXCLUSIVE-LOCK NO-ERROR.
              ss - 090824.1 -e */

	      /* ss - 090824.1 -b */
	                  FIND FIRST mfc_ctrl 
               WHERE mfc_field = SoftspeedDI_so_pre[i1]
               EXCLUSIVE-LOCK NO-ERROR.

	      /* ss - 090824.1 -e */
	    IF NOT AVAILABLE mfc_ctr THEN DO:
               /* Control table error.  Check applicable control tables */
               {pxmsg.i &MSGNUM=594 &ERRORLEVEL=3}
               undo, RETURN.
            END.
            SoftspeedDI_so_pre[i1 + 2] = STRING(INTEGER("1" + fill("0",8)) + mfc_integer).
            SoftspeedDI_so_pre[i1 + 2] = mfc_char + SUBSTRING(SoftspeedDI_so_pre[i1 + 2], 2 + LENGTH(mfc_char)).
            DO WHILE CAN-FIND(
              /* ss - 090824.1 -b
	       FIRST so_mstr
               WHERE so_mstr.so_domain = GLOBAL_domain
               AND so_mstr.so_nbr = SoftspeedDI_so_pre[i1 + 2]
                ss - 090824.1 -e */
		/* ss - 090824.1 -b */
			       FIRST so_mstr
               WHERE  so_mstr.so_nbr = SoftspeedDI_so_pre[i1 + 2]
		/* ss - 090824.1 -e */
	       ):
               mfc_integer = mfc_integer + 1.
               SoftspeedDI_so_pre[i1 + 2] = STRING(INTEGER("1" + fill("0",8)) + mfc_integer).
               SoftspeedDI_so_pre[i1 + 2] = mfc_char + SUBSTRING(SoftspeedDI_so_pre[i1 + 2], 2 + LENGTH(mfc_char)).
            END.
            mfc_integer = mfc_integer + 1.

            /* 发票前缀及其序号 */
	    /* ss - 090824.1 -b
            FIND FIRST mfc_ctrl 
               WHERE mfc_domain = GLOBAL_domain 
               AND mfc_field = SoftspeedDI_inv_pre[i1]
               EXCLUSIVE-LOCK NO-ERROR.
             ss - 090824.1 -e */
	     /* ss - 090824.1 -b */
	                 FIND FIRST mfc_ctrl 
               WHERE mfc_field = SoftspeedDI_inv_pre[i1]
               EXCLUSIVE-LOCK NO-ERROR.

	     /* ss - 090824.1 -e */
	    IF NOT AVAILABLE mfc_ctr THEN DO:
               /* Control table error.  Check applicable control tables */
               {pxmsg.i &MSGNUM=594 &ERRORLEVEL=3}
               undo, RETURN.
            END.
            SoftspeedDI_inv_pre[i1 + 2] = STRING(INTEGER("1" + fill("0",8)) + mfc_integer).
            SoftspeedDI_inv_pre[i1 + 2] = mfc_char + SUBSTRING(SoftspeedDI_inv_pre[i1 + 2], 2 + LENGTH(mfc_char)).
            DO WHILE CAN-FIND(
               FIRST so_mstr
               WHERE  so_mstr.so_inv_nbr = SoftspeedDI_inv_pre[i1 + 2]
               ):
               mfc_integer = mfc_integer + 1.
               SoftspeedDI_inv_pre[i1 + 2] = STRING(INTEGER("1" + fill("0",8)) + mfc_integer).
               SoftspeedDI_inv_pre[i1 + 2] = mfc_char + SUBSTRING(SoftspeedDI_inv_pre[i1 + 2], 2 + LENGTH(mfc_char)).
            END.
            mfc_integer = mfc_integer + 1.

            /* 获得临时和日志文件名 - 包括完整路径 */
            {gprun.i ""xxcimnow.p"" "(
               OUTPUT infile[i1]
               )"}
            infile[i1] = FILE_prefix + infile[i1].
            infile[i1] = infile[i1] + "." + SoftspeedDI_so_pre[i1 + 2].
            if log_directory <> "" and
               substring(log_directory,length(log_directory),1) <> dir_prefix THEN DO:
               log_infile[i1] = log_directory + dir_prefix + infile[i1].
            END.
            ELSE DO:
               log_infile[i1] = log_directory + infile[i1].
            END.
            if temporary_directory <> "" and
               substring(temporary_directory,length(temporary_directory),1) <> dir_prefix THEN DO:
               infile[i1] = temporary_directory + dir_prefix + infile[i1].
            END.
            ELSE DO:
               infile[i1] = temporary_directory + infile[i1].
            END.
            {gprun.i ""xxcimfilename.p"" "(
               INPUT '',
               INPUT-OUTPUT infile[i1]
               )"}
            outfile[i1] = infile[i1] + ".out".
            infile[i1] = infile[i1] + ".in".
            log_outfile[i1] = log_infile[i1] + ".out".
            log_infile[i1] = log_infile[i1] + ".in".
         END. /* DO i1 = 1 TO 2: */

         OUTPUT STREAM s1 TO VALUE(infile[1]).
         OUTPUT STREAM s2 TO VALUE(infile[2]).

         /* DIF10: 订单前缀及其序号 */
         EXPORT STREAM s1 DELIMITER " " SoftspeedDI_so_pre[3].
         EXPORT STREAM s2 DELIMITER " " SoftspeedDI_so_pre[4].

         EXPORT STREAM s1 DELIMITER " " ih_cust.
         EXPORT STREAM s2 DELIMITER " " ih_cust.

         EXPORT STREAM s1 DELIMITER " " ih_bill.
         EXPORT STREAM s2 DELIMITER " " ih_bill.

         EXPORT STREAM s1 DELIMITER " " ih_ship.
         EXPORT STREAM s2 DELIMITER " " ih_ship.

         /* Order Date,Required Date,Due Date,Perform Date,Pricing Date */
         PUT STREAM s1 UNFORMATTED " - - - - -".
         /* Purchase Order */
         /*
         PUT STREAM s1 UNFORMATTED " """ + STRING(SoftspeedDI_inv) + """".
         */
         PUT STREAM s1 UNFORMATTED " -".
         PUT STREAM s1 UNFORMATTED " """ + ih_rmks + """".
         /* Line Pricing,Manual */
         PUT STREAM s1 UNFORMATTED " - -".
         PUT STREAM s1 UNFORMATTED " """ + ih_site + """".
         PUT STREAM s1 UNFORMATTED " """ + ih_channel + """".
         PUT STREAM s1 UNFORMATTED " """ + ih_project + """".
         /* Last Ship */
         PUT STREAM s1 UNFORMATTED " -".
         PUT STREAM s1 UNFORMATTED " """ + ih_curr + """".
         /* Language */
         PUT STREAM s1 UNFORMATTED " -".
         PUT STREAM s1 UNFORMATTED " """ + STRING(ih_taxable) + """".
         PUT STREAM s1 UNFORMATTED " """ + ih_taxc + """".
         PUT STREAM s1 UNFORMATTED " """ + STRING(ih_tax_date) + """".
         PUT STREAM s1 UNFORMATTED " """ + STRING(ih_fix_pr) + """".
         PUT STREAM s1 UNFORMATTED " """ + ih_cr_terms + """".
         PUT STREAM s1 SKIP.
         /* ss - 091119.1 -b */
         IF ih_curr <> base_curr  THEN DO:
          PUT STREAM s1 SKIP(1) .
         END.
         /* SS - 091119.1 -E */
         /* Order Date,Required Date,Due Date,Perform Date,Pricing Date */
         PUT STREAM s2 UNFORMATTED " - - - - -".
         /* Purchase Order */
         /*
         PUT STREAM s2 UNFORMATTED " """ + STRING(SoftspeedDI_inv) + """".
         */
         PUT STREAM s2 UNFORMATTED " -".
         PUT STREAM s2 UNFORMATTED " """ + ih_rmks + """".
         /* Line Pricing,Manual */
         PUT STREAM s2 UNFORMATTED " - -".
         PUT STREAM s2 UNFORMATTED " """ + ih_site + """".
         PUT STREAM s2 UNFORMATTED " """ + ih_channel + """".
         PUT STREAM s2 UNFORMATTED " """ + ih_project + """".
         /* Last Ship */
         PUT STREAM s2 UNFORMATTED " -".
         PUT STREAM s2 UNFORMATTED " """ + ih_curr + """".
         /* Language */
         PUT STREAM s2 UNFORMATTED " -".
         PUT STREAM s2 UNFORMATTED " """ + STRING(ih_taxable) + """".
         PUT STREAM s2 UNFORMATTED " """ + ih_taxc + """".
         PUT STREAM s2 UNFORMATTED " """ + STRING(ih_tax_date) + """".
         PUT STREAM s2 UNFORMATTED " """ + STRING(ih_fix_pr) + """".
         PUT STREAM s2 UNFORMATTED " """ + ih_cr_terms + """".
         PUT STREAM s2 SKIP.
           /* ss - 091119.1 -b */
         IF ih_curr <> base_curr  THEN DO:
          PUT STREAM s2  SKIP(1) .
         END.
         /* SS - 091119.1 -E */

         IF ih_taxable = YES OR YES THEN DO:
            PUT STREAM s1 UNFORMATTED " """ + ih_tax_usage + """".
            PUT STREAM s1 UNFORMATTED " """ + ih_tax_env + """".
            PUT STREAM s1 UNFORMATTED " """ + ih_taxc + """".
            PUT STREAM s1 UNFORMATTED " """ + STRING(ih_taxable) + """".
            /* Tax In */
            PUT STREAM s1 UNFORMATTED " -".
            PUT STREAM s1 SKIP.
            PUT STREAM s2 UNFORMATTED " """ + ih_tax_usage + """".
            PUT STREAM s2 UNFORMATTED " """ + ih_tax_env + """".
            PUT STREAM s2 UNFORMATTED " """ + ih_taxc + """".
            PUT STREAM s2 UNFORMATTED " """ + STRING(ih_taxable) + """".
            /* Tax In */
            PUT STREAM s2 UNFORMATTED " -".
            PUT STREAM s2 SKIP.
         END. /* IF ih_taxable = YES THEN DO: */

         PUT STREAM s1 UNFORMATTED " """ + ih_xslspsn[1] + """".
         /* Multiple */
         PUT STREAM s1 UNFORMATTED " """ + STRING(NO) + """".
         PUT STREAM s1 UNFORMATTED " """ + STRING(ih_xcomm_pct[1]) + """".
         PUT STREAM s1 UNFORMATTED " """ + ih_shipvia + """".
         PUT STREAM s1 UNFORMATTED " """ + ih_bol + """".
         PUT STREAM s1 UNFORMATTED " """ + ih_fr_list + """".
         PUT STREAM s1 UNFORMATTED " """ + STRING(ih_fr_min_wt) + """".
         PUT STREAM s1 UNFORMATTED " """ + ih_fr_terms + """".
         /* Calculate Freight */
         PUT STREAM s1 UNFORMATTED " """ + STRING(NO) + """".
         /* Display Weights */
         PUT STREAM s1 UNFORMATTED " """ + STRING(NO) + """".
         /* Imp/Exp */
         PUT STREAM s1 UNFORMATTED " """ + STRING(NO) + """".
         /* Comments */
         PUT STREAM s1 UNFORMATTED " """ + STRING(NO) + """".
         PUT STREAM s1 SKIP.
         PUT STREAM s2 UNFORMATTED " """ + ih_xslspsn[1] + """".
         /* Multiple */
         PUT STREAM s2 UNFORMATTED " """ + STRING(NO) + """".
         PUT STREAM s2 UNFORMATTED " """ + STRING(ih_xcomm_pct[1]) + """".
         PUT STREAM s2 UNFORMATTED " """ + ih_shipvia + """".
         PUT STREAM s2 UNFORMATTED " """ + ih_bol + """".
         PUT STREAM s2 UNFORMATTED " """ + ih_fr_list + """".
         PUT STREAM s2 UNFORMATTED " """ + STRING(ih_fr_min_wt) + """".
         PUT STREAM s2 UNFORMATTED " """ + ih_fr_terms + """".
         /* Calculate Freight */
         PUT STREAM s2 UNFORMATTED " """ + STRING(NO) + """".
         /* Display Weights */
         PUT STREAM s2 UNFORMATTED " """ + STRING(NO) + """".
         /* Imp/Exp */
         PUT STREAM s2 UNFORMATTED " """ + STRING(NO) + """".
         /* Comments */
         PUT STREAM s2 UNFORMATTED " """ + STRING(NO) + """".
         PUT STREAM s2 SKIP.
      END. /* IF FIRST-OF(rqd_part) THEN DO: */
      /* 头栏 - E */

      /* 明细栏 - B */
      /* Summary - B */
      IF FIRST-OF(idh_line) THEN DO:
         req_qty_rqd = 0.
      END.
      req_qty_rqd = req_qty_rqd + rqd_req_qty.
      IF LAST-OF(idh_line) THEN DO:

          /* ss - 091112.1 -b */
           /* ss - 090916.1 -e */
	 find last xxpi_mstr where xxpi_list = ih_bill and xxpi_part = idh_part and xxpi_curr = tr_curr and xxpi_um = tr_um
	   and ( ( xxpi_start <= today and xxpi_start <> ? ) or  xxpi_start = ?  ) 
	   and  ( ( xxpi_expire > today and xxpi_expire <> ? ) or xxpi_expire = ?) no-lock no-error .
	   if not available xxpi_mstr then do:
	   /* ss - 090916.1 -b */
	   v_list_price = 0 .
	   /* ss - 090916.1 -e */
	     {pxmsg.i &MSGNUM=2022 &ERRORLEVEL=3}
             undo, RETURN.
	   end .
	   /* ss - 090916.1 -b */
	   else 
	   v_list_price = xxpi_list_price .

        /* ss - 091112.1 -e */
      
       /* Summary - E */
         /* Ln */
         PUT STREAM s1 UNFORMATTED " -" SKIP.
         PUT STREAM s2 UNFORMATTED " -" SKIP.

         EXPORT STREAM s1 DELIMITER " " idh_part.
         EXPORT STREAM s2 DELIMITER " " idh_part.

         EXPORT STREAM s1 DELIMITER " " idh_site.
         EXPORT STREAM s2 DELIMITER " " idh_site.

         /* DIF20: 数量 */
         /* Detail - B
         EXPORT STREAM s1 DELIMITER " " (- rqd_req_qty) idh_um.
         EXPORT STREAM s2 DELIMITER " " (+ rqd_req_qty) idh_um.
         Detail - E */
         /* Summary - B */
         EXPORT STREAM s1 DELIMITER " " (- req_qty_rqd) idh_um.
         EXPORT STREAM s2 DELIMITER " " (+ req_qty_rqd) idh_um.
         /* Summary - E */

         /* Quantity Backorder */
         PUT STREAM s1 UNFORMATTED " -" SKIP.
         PUT STREAM s2 UNFORMATTED " -" SKIP.

         /*
         EXPORT STREAM s1 DELIMITER " " idh_list_pr idh_disc_pct.
         EXPORT STREAM s2 DELIMITER " " idh_list_pr idh_disc_pct.
         */
	 /* ss - 090831.1 -b
         EXPORT STREAM s1 DELIMITER " " idh_price 0.
         EXPORT STREAM s2 DELIMITER " " idh_price 0.

         EXPORT STREAM s1 DELIMITER " " idh_price.
         EXPORT STREAM s2 DELIMITER " " idh_price.
           ss - 090831.1 -e */
	   /* ss - 090831.1 -b */
	 EXPORT STREAM s1 DELIMITER " " idh_price 0.
	 /* ss - 090904.1 -b
         EXPORT STREAM s2 DELIMITER " " pi_list_price 0.
           ss - 090904.1 -e */
	 /* ss - 090904.1 -b */
	 /* ss - 090916.1 -b 
	 EXPORT STREAM s2 DELIMITER " "  xxpi_list_price   0.
           ss - 090916.1 -e */
	/* ss - 090916.1 -b */
	   EXPORT STREAM s2 DELIMITER " "  v_list_price   0.
	/* ss - 090916.1 -e */

	 /* ss - 090904.1 -e */
         EXPORT STREAM s1 DELIMITER " " idh_price.
	 /* ss - 090904.1 -b
         EXPORT STREAM s2 DELIMITER " " pi_list_price.
           ss - 090904.1 -e */

	 /* ss - 090904.1 -b */
	 /* ss - 090916.1 -b
         EXPORT STREAM s2 DELIMITER " " xxpi_list_price.
            ss - 090916.1 -e */
	 /* ss - 090916.1 -b */
	  EXPORT STREAM s2 DELIMITER " " v_list_price.
	 /* ss - 090916.1 -e */
	 /* ss - 090904.1 -e */
	   /* ss - 090831.1 -e */

         /* Loc */
         PUT STREAM s1 UNFORMATTED " -".
         /* Lot/Serial */
         PUT STREAM s1 UNFORMATTED " """ + STRING(tr_trnbr) + """".
         /* ss - 090903.1 -b 
	 /* Ref */
         PUT STREAM s1 UNFORMATTED " -".
          ss - 090903.1 -e */
	 /* TODO60: 销售及其折扣账户 */
         PUT STREAM s1 UNFORMATTED " """ + idh_acct + """".
         PUT STREAM s1 UNFORMATTED " """ + idh_sub + """".
         PUT STREAM s1 UNFORMATTED " """ + idh_cc + """".
         PUT STREAM s1 UNFORMATTED " """ + idh_project + """".
         PUT STREAM s1 UNFORMATTED " """ + idh_dsc_acct + """".
         PUT STREAM s1 UNFORMATTED " """ + idh_dsc_sub + """".
         PUT STREAM s1 UNFORMATTED " """ + idh_dsc_cc + """".
         PUT STREAM s1 UNFORMATTED " """ + idh_dsc_project + """".
         /* Required,Due Date,Perform Date */
         PUT STREAM s1 UNFORMATTED " - - -".
         PUT STREAM s1 UNFORMATTED " """ + STRING(idh_fix_pr) + """".
         /* DIF30: 明细栏类型 */
         PUT STREAM s1 UNFORMATTED " """ + SoftspeedDI_sod_type[3] + """".
         PUT STREAM s1 UNFORMATTED " """ + STRING(idh_um_conv) + """".
         /* Category,Freight List */
         PUT STREAM s1 UNFORMATTED " - -".
         PUT STREAM s1 UNFORMATTED " """ + STRING(idh_taxable) + """".
         PUT STREAM s1 UNFORMATTED " """ + idh_taxc + """".
         /* Comments */
         PUT STREAM s1 UNFORMATTED " """ + STRING(NO) + """".
         PUT STREAM s1 SKIP.
         /* Loc */
         PUT STREAM s2 UNFORMATTED " -".
         /* Lot/Serial */
         PUT STREAM s2 UNFORMATTED " """ + STRING(tr_trnbr) + """".
         /* Ref */
        /* ss - 090903.1 -b
	 PUT STREAM s2 UNFORMATTED " -".
        ss - 090903.1 - e */
	 /* TODO60: 销售及其折扣账户 */
         PUT STREAM s2 UNFORMATTED " """ + idh_acct + """".
         PUT STREAM s2 UNFORMATTED " """ + idh_sub + """".
         PUT STREAM s2 UNFORMATTED " """ + idh_cc + """".
         PUT STREAM s2 UNFORMATTED " """ + idh_project + """".
         PUT STREAM s2 UNFORMATTED " """ + idh_dsc_acct + """".
         PUT STREAM s2 UNFORMATTED " """ + idh_dsc_sub + """".
         PUT STREAM s2 UNFORMATTED " """ + idh_dsc_cc + """".
         PUT STREAM s2 UNFORMATTED " """ + idh_dsc_project + """".
         /* Required,Due Date,Perform Date */
         PUT STREAM s2 UNFORMATTED " - - -".
         PUT STREAM s2 UNFORMATTED " """ + STRING(idh_fix_pr) + """".
         /* DIF30: 明细栏类型 */
         PUT STREAM s2 UNFORMATTED " """ + SoftspeedDI_sod_type[4] + """".
         PUT STREAM s2 UNFORMATTED " """ + STRING(idh_um_conv) + """".
         /* Category,Freight List */
         PUT STREAM s2 UNFORMATTED " - -".
         PUT STREAM s2 UNFORMATTED " """ + STRING(idh_taxable) + """".
         PUT STREAM s2 UNFORMATTED " """ + idh_taxc + """".
         /* Comments */
         PUT STREAM s2 UNFORMATTED " """ + STRING(NO) + """".
         PUT STREAM s2 SKIP.

         /* TODO70: 税账户 */
         IF idh_taxable = YES THEN DO:
            PUT STREAM s1 UNFORMATTED " """ + idh_tax_usage + """".
            PUT STREAM s1 UNFORMATTED " """ + idh_tax_env + """".
            PUT STREAM s1 UNFORMATTED " """ + idh_taxc + """".
            PUT STREAM s1 UNFORMATTED " """ + STRING(idh_taxable) + """".
            PUT STREAM s1 UNFORMATTED " """ + STRING(idh_tax_in) + """".
            PUT STREAM s1 SKIP.
            PUT STREAM s2 UNFORMATTED " """ + idh_tax_usage + """".
            PUT STREAM s2 UNFORMATTED " """ + idh_tax_env + """".
            PUT STREAM s2 UNFORMATTED " """ + idh_taxc + """".
            PUT STREAM s2 UNFORMATTED " """ + STRING(idh_taxable) + """".
            PUT STREAM s2 UNFORMATTED " """ + STRING(idh_tax_in) + """".
            PUT STREAM s2 SKIP.
         END. /* IF ih_taxable = YES THEN DO: */
      /* Summary - B */
      END. /* IF LAST-OF(idh_line) THEN DO: */
      /* Summary - E */
      /* 明细栏 - E */

      /* 尾栏 - B */
      IF LAST-OF(rqd_part) THEN DO:
         /* Ln */
         PUT STREAM s1 UNFORMATTED "." SKIP.
         PUT STREAM s2 UNFORMATTED "." SKIP.

         /* Ln Format S/M */
         PUT STREAM s1 UNFORMATTED "." SKIP.
         PUT STREAM s2 UNFORMATTED "." SKIP.

         EXPORT STREAM s1 DELIMITER " " ih_disc_pct ih_trl1_cd ih_trl1_amt ih_trl2_cd ih_trl2_amt ih_trl3_cd ih_trl3_amt NO.
         EXPORT STREAM s2 DELIMITER " " ih_disc_pct ih_trl1_cd ih_trl1_amt ih_trl2_cd ih_trl2_amt ih_trl3_cd ih_trl3_amt NO.

         PUT STREAM s1 UNFORMATTED " """ + ih_cr_init + """".
         PUT STREAM s1 UNFORMATTED " """ + ih_cr_card + """".
         PUT STREAM s1 UNFORMATTED " """ + ih_stat  + """".
         PUT STREAM s1 UNFORMATTED " """ + STRING(ih_rev) + """".
         PUT STREAM s1 UNFORMATTED " """ + ih_fob + """".
         /* Invoice Number */
         PUT STREAM s1 UNFORMATTED " """ + SoftspeedDI_inv_pre[3] + """".
         /* Ready to Invoice */
         PUT STREAM s1 UNFORMATTED " -".
         /* Invoiced */
         PUT STREAM s1 UNFORMATTED " -".
         PUT STREAM s1 UNFORMATTED " """ + STRING(ih_prepaid) + """".
         /* TODO80: 应收账户 */
         PUT STREAM s1 UNFORMATTED " """ + ih_ar_acct + """".
         PUT STREAM s1 UNFORMATTED " """ + ih_ar_sub + """".
         PUT STREAM s1 UNFORMATTED " """ + ih_ar_cc + """".
         PUT STREAM s1 UNFORMATTED " """ + STRING(ih_print_so) + """".
         PUT STREAM s1 UNFORMATTED " """ + STRING(ih_print_pl) + """".
         PUT STREAM s1 SKIP.
         PUT STREAM s2 UNFORMATTED " """ + ih_cr_init + """".
         PUT STREAM s2 UNFORMATTED " """ + ih_cr_card + """".
         PUT STREAM s2 UNFORMATTED " """ + ih_stat  + """".
         PUT STREAM s2 UNFORMATTED " """ + STRING(ih_rev) + """".
         PUT STREAM s2 UNFORMATTED " """ + ih_fob + """".
         /* Invoice Number */
         PUT STREAM s2 UNFORMATTED " """ + SoftspeedDI_inv_pre[4] + """".
         /* Ready to Invoice */
         PUT STREAM s2 UNFORMATTED " -".
         /* Invoiced */
         PUT STREAM s2 UNFORMATTED " -".
         PUT STREAM s2 UNFORMATTED " """ + STRING(ih_prepaid) + """".
         /* TODO80: 应收账户 */
         PUT STREAM s2 UNFORMATTED " """ + ih_ar_acct + """".
         PUT STREAM s2 UNFORMATTED " """ + ih_ar_sub + """".
         PUT STREAM s2 UNFORMATTED " """ + ih_ar_cc + """".
         PUT STREAM s2 UNFORMATTED " """ + STRING(ih_print_so) + """".
         PUT STREAM s2 UNFORMATTED " """ + STRING(ih_print_pl) + """".
         PUT STREAM s2 SKIP.

         /* Order */
         PUT STREAM s1 UNFORMATTED "." SKIP.
         PUT STREAM s2 UNFORMATTED "." SKIP.

         OUTPUT STREAM s1 CLOSE.
         OUTPUT STREAM s2 CLOSE.

         /* CIM */
         {xxssdii1c.i}
      END. /* IF LAST-OF(rqd_part) THEN DO: */
      /* 尾栏 - E */
   END. /* FOR EACH rqd_det EXCLUSIVE-LOCK */

   /* 已结 */
   IF show_email_ids = YES THEN DO:
      {gprun.i ""xxssdii1m.p"" "(
         INPUT rqm_nbr
         )"}
   END.
END. /* FOR EACH rqm_mstr EXCLUSIVE-LOCK */

/* 输出执行结果 */
{gprun.i ""xxcimterm.p"" "(
   INPUT 'RECORDS_LOADED',
   OUTPUT LONG_lbl
   )"}
PUT UNFORMATTED LONG_lbl + ": " + STRING(recount) SKIP.
{gprun.i ""xxcimterm.p"" "(
   INPUT 'ERRORS',
   OUTPUT LONG_lbl
   )"}
PUT UNFORMATTED LONG_lbl + " [" + STRING(errcount) + "]: " SKIP.
FOR EACH tt3:
   EXPORT DELIMITER "~011" tt3.
END.
