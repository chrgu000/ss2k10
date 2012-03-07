/* ss - 110726.1 by: jack */  
/* ss - 110802.1 by: jack */  /* Ӧ����Ʒ���Ϊ0�Ĳ����*/
/* ss - 110803.1 by: jack */  /* ������Ʒ�ܳ��Ĺ�˾��Ϊ������,������Ʒ����Ϊ0ʱɾ�� */ /* excel report ע��0����� */
/* ss - 110805.1 by: jack */ /* �������� */  /* ����bi���*/

/* DISPLAY TITLE */
/*
{mfdtitle.i "110802.1 "}
*/
/*
{mfdtitle.i "110804.1 "}
*/
{mfdtitle.i "110805.1 "}

define variable site       like si_site.   
define variable site1      like si_site. 
DEFINE VAR dept LIKE dpt_dept .
DEFINE VAR dept1 LIKE dpt_dept .
DEFINE VAR cust LIKE vd_addr .
DEFINE VAR cust1 LIKE vd_addr .
DEFINE VAR type AS CHAR FORMAT "x(1)" .
DEFINE VAR type1 AS CHAR  FORMAT "x(1)" .
DEFINE VAR due AS DATE INITIAL TODAY .
DEFINE VAR vv AS CHAR INITIAL ";" .
DEFINE VAR v_cat AS CHAR .


/* ������*/
DEFINE TEMP-TABLE t1
    FIELD t1_site LIKE si_site
    FIELD t1_part LIKE pt_part
    FIELD t1_loc LIKE tr_loc
    FIELD t1_lot LIKE ld_lot
    FIELD t1_ref LIKE ld_ref
    FIELD t1_qty LIKE ld_qty_oh
    FIELD t1_cost LIKE prh_pur_cost
    
    INDEX t1_site t1_site t1_part t1_loc t1_lot t1_ref   
    .

DEFINE TEMP-TABLE t2
    FIELD t2_site LIKE si_site
    FIELD t2_part LIKE pt_part
    FIELD t2_loc LIKE tr_loc
    FIELD t2_lot LIKE ld_lot
    FIELD t2_ref LIKE ld_ref
    FIELD t2_qty LIKE ld_qty_oh
    FIELD t2_cost LIKE prh_pur_cost
    FIELD t2_nbr LIKE sod_nbr
    FIELD t2_line LIKE sod_line
    INDEX t2_site t2_part t2_loc t2_lot t2_ref  t2_nbr t2_line  
    .

DEFINE TEMP-TABLE t3
    FIELD t3_nbr LIKE so_nbr
    FIELD t3_part LIKE sod_part
    FIELD t3_loc LIKE ld_loc 
    FIELD t3_qty LIKE tr_qty_loc
    .
/* ������*/

DEFINE NEW SHARED   TEMP-TABLE tt  /* */
    FIELD tt_cat AS CHAR  /* ���� */
    FIELD tt_dept AS CHAR 
    FIELD tt_deptname LIKE dpt_desc
    FIELD tt_vend LIKE po_vend
    FIELD tt_name LIKE ad_name
    FIELD tt_nbr LIKE vo_invoice
    FIELD tt_date AS DATE
    FIELD tt_part LIKE pt_part
    FIELD tt_desc1 LIKE pt_desc1
    FIELD tt_qty LIKE pod_qty_ord
    FIELD tt_cost LIKE prh_pur_cost
    FIELD tt_amt LIKE ap_amt
    FIELD tt_type AS CHAR /* 1 ������Ʒ 2 Ӧ�ս�� m/i 3 Ԥ�ս�� u 4 Ԥ��Ʊ�� d*/
    .
DEFINE VAR TYPE_POReceiver AS CHAR INITIAL "07" .
DEFINE VAR v_acct LIKE ar_acct .
DEFINE VAR v_acct1 LIKE ar_acct .


DEFINE VAR v_qty_oh LIKE ld_qty_oh .
define variable qty_init  like  ld_qty_oh FORMAT   "->>>>,>>9.<< " LABEL "�ڳ���" no-undo.
define variable amt_init  like  tr_gl_amt  FORMAT  "->>>>,>>9.<< "LABEL "�ڳ���"  no-undo.
define variable qty_po  like  ld_qty_oh FORMAT  "->>>>,>>9.<<" LABEL "�ջ���" no-undo.
define variable amt_po  like  tr_gl_amt  FORMAT  "->>>>,>>9.<<" LABEL "�ջ���" no-undo.
define variable qty_prv     like  ld_qty_oh FORMAT  "->>>>,>>9.<<" LABEL "�˻���" no-undo.
define variable amt_prv     like  tr_gl_amt  FORMAT  "->>>>,>>9.<<" LABEL "�˻���" no-undo.
define variable qty_iss_wo  like  ld_qty_oh FORMAT  "->>>>,>>9.<<" LABEL "��������" no-undo.
define variable amt_iss_wo  like  tr_gl_amt  FORMAT  "->>>>,>>9.<<" LABEL "���϶�" no-undo.
define variable qty_un_iss  like  ld_qty_oh FORMAT  "->>>>,>>9.<<" LABEL "�ƻ������" no-undo.
define variable amt_un_iss  like  tr_gl_amt  FORMAT  "->>>>,>>9.<<" LABEL "�ƻ�������" no-undo.
define variable qty_un_rct  like  ld_qty_oh FORMAT  "->>>>,>>9.<<" LABEL "�ƻ������" no-undo.
define variable amt_un_rct  like  tr_gl_amt  FORMAT  "->>>>,>>9.<<" LABEL "�ƻ�������" no-undo.
define variable qty_tr_rct  like  ld_qty_oh FORMAT  "->>>>,>>9.<<" LABEL  "ת�����" no-undo.
define variable amt_tr_rct  like  tr_gl_amt  FORMAT  "->>>>,>>9.<<" LABEL "ת������" no-undo.
define variable qty_tr_iss  like  ld_qty_oh FORMAT  "->>>>,>>9.<<" LABEL "ת�ֳ���" no-undo.
define variable amt_tr_iss  like  tr_gl_amt  FORMAT  "->>>>,>>9.<<" LABEL "ת�ֳ����" no-undo.


define variable amt_adj  like  tr_gl_amt  FORMAT  "->>>>,>>9.<<" LABEL "�ɱ�������" no-undo.
define variable qty_cyc  like  ld_qty_oh FORMAT  "->>>>,>>9.<<" LABEL "��ӯ��" no-undo.
define variable amt_cyc  like  tr_gl_amt  FORMAT  "->>>>,>>9.<<" LABEL "��ӯ����" no-undo.

define variable qty_rct_wo  like  ld_qty_oh FORMAT  "->>>>,>>9.<<" LABEL "�������" no-undo.
define variable amt_rct_wo  like  tr_gl_amt  FORMAT  "->>>>,>>9.<<" LABEL "����" no-undo.
define variable qty_iss_so  like  ld_qty_oh FORMAT  "->>>>,>>9.<<" LABEL "���۷���" no-undo.
define variable amt_iss_so  like  tr_gl_amt  FORMAT  "->>>>,>>9.<<" LABEL "������" no-undo.
define variable qty_other  like  ld_qty_oh FORMAT  "->>>>,>>9.<<" LABEL "�������" no-undo.
define variable amt_other  like  tr_gl_amt  FORMAT  "->>>>,>>9.<<" LABEL "��������" no-undo.
define variable qty_end  like  ld_qty_oh FORMAT  "->>>>,>>9.<<" LABEL "��δ��" no-undo.
define variable amt_end  like  tr_gl_amt  FORMAT  "->>>>,>>9.<<" LABEL "��δ��" no-undo.
define variable qty_over  like  ld_qty_oh FORMAT  "->>>>,>>9.<<" LABEL "�ڼ����" no-undo.
define variable amt_over  like  tr_gl_amt  FORMAT  "->>>>,>>9.<<" LABEL "�ڼ���" no-undo.
define variable qty_new  like  ld_qty_oh FORMAT  "->>>>,>>9.<<" LABEL "��ǰ��" no-undo.
define variable amt_new  like  tr_gl_amt  FORMAT  "->>>>,>>9.<<" LABEL "��ǰ��" no-undo.
DEFINE VARIABLE SIM LIKE SI_gl_set .

/*
   define variable.
*/

form
   site       colon 15 
   site1     label {t001.i} colon 49 skip
   dept       colon 15 
   dept1     label {t001.i} colon 49 skip
   cust        colon 15 
   cust1     label {t001.i} colon 49 skip
   type        colon 15 
   type1     label {t001.i} colon 49 skip
     "���� 1 Ϊ������2 Ϊ���ԣ� 3 Ϊ���� " 
   due       colon 15 
   
   with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{wbrp01.i}

repeat on error undo, retry:

    /* ss - 110805.1 -b */
    FIND FIRST xcomppi_mstr WHERE xcomppi_domain = GLOBAL_domain AND 
        xcomppi_user = GLOBAL_userid NO-LOCK NO-ERROR .
    IF NOT AVAILABLE xcomppi_mstr THEN DO:
        MESSAGE "�û����Ų�����" VIEW-AS ALERT-BOX .
        LEAVE .
    END.
    ELSE DO:
       ASSIGN
            dept = xcomppi_company
            dept1 = xcomppi_company
            .
       
     DISPLAY dept dept1 WITH FRAME a .

    END.
    /* ss - 110805.1 -e */

   if site1 = hi_char then site1 = "".
   if dept1 = hi_char then dept1 = "".
   if cust1 = hi_char then cust1 = "".
   IF type1 = hi_char THEN type1 = "" .


   /* ss - 110805.1 -b
   if c-application-mode <> "WEB" then
   update    
      site site1 dept dept1 cust cust1 type type1 due
   with frame a.
ss - 110805.1 -e */
   /* ss - 110805.1 -b */
   IF dept1 = "0000" THEN DO:
        if c-application-mode <> "WEB" then
   update    
      site site1 dept dept1 cust cust1 type type1 due
   with frame a.
   END.
   ELSE DO:
        if c-application-mode <> "WEB" then
   update    
      site site1 
   with frame a.

    if c-application-mode <> "WEB" then
   update    
       cust cust1 type type1 due
   with frame a.
   END.
  
   /* ss - 110805.1 -e */
   {wbrp06.i &command = update &fields = 
       "site site1 cust cust1 type type1 due"
         &frm = "a"}

   if (c-application-mode <> "WEB") or
      (c-application-mode = "WEB" and
      (c-web-request begins "DATA"))
   then do:

      bcdparm = "".
      {mfquoter.i site  }
      {mfquoter.i site1 }
      {mfquoter.i dept  }
      {mfquoter.i dept1 }
      {mfquoter.i cust  }
      {mfquoter.i cust1 }
      {mfquoter.i type  }
      {mfquoter.i type1 }
      {mfquoter.i due  }

      
      if site1 = "" then site1 = hi_char.
      if dept1 = "" then dept1 = hi_char.
      if cust1 = "" then cust1 = hi_char.
      if type1 = "" then type1 = "3".
      IF TYPE = ""  THEN TYPE = "1" .

   end.

   /* SELECT PRINTER */
   {gpselout.i
       &printType = "printer"
       &printWidth = 132
       &pagedFlag = " "
       &stream = " "
       &appendToFile = " "
       &streamedOutputToTerminal = " "
       &withBatchOption = "yes"
       &displayStatementType = 1
       &withCancelMessage = "yes"
       &pageBottomMargin = 6
       &withEmail = "yes"
       &withWinprint = "yes"
       &defineVariables = "yes"}
    

   /*{mfreset.i}*/ 
   /* {mfphead.i}  */

       FOR EACH tt :
           DELETE tt .
       END.

       FOR EACH t1 :
           DELETE t1 .
       END.

       FOR EACH t2 :
           DELETE t2 .
       END.

       FOR EACH t3 :
           DELETE t3 .
       END.
   /* FIND AND DISPLAY */
       /* ss - 110805.1 -b */
   PUT UNFORMATTED "ExcelFile" ";" "xxrar002" SKIP.   /* excel ģ������ */
   PUT UNFORMATTED "SaveFile" ";" "xxrar002" SKIP.     /* excel �������� */
   PUT UNFORMATTED "BeginRow" ";" "2" SKIP.       /* excel �ӵڼ��п�ʼ */
 /*  ss - 110805.1 -e */
       /* ss - 110805.1 -b 
       PUT UNFORMATTED "#def REPORTPATH=$/QAD Addons/BI Report/" + SUBSTRING(execname,1,LENGTH(execname) - 2) SKIP.
PUT UNFORMATTED "#def :end" SKIP.
        ss - 110805.1 -e */

    /* ���㷢����Ʒ */
    /* "���� 1 �ų�s,qtΪ������2 Ϊ����s�� 3 Ϊ����qt " */
     /* ����ֻ�ܲ�ѯһ������ȫ�� */  /* ��Ҫ���ǹ�˾�������� */
 /* ���� */

  /* ������ */

  /* ˳�ƿ�� */  /* û���Ƿ��� */
   FOR EACH ld_det WHERE ld_domain = GLOBAL_domain AND (ld_site >= site AND ld_site <= site1)
       AND SUBSTRING(ld_loc,LENGTH(ld_loc) - 1,2) = "99" NO-LOCK ,
       FIRST so_mstr WHERE so_domain = GLOBAL_domain AND (so_nbr = ld_ref) AND (so_cust >= cust AND so_cust <= cust1)
       AND (so__chr01 >= dept AND so__Chr01 <= dept1) NO-LOCK :

              IF  so_nbr BEGINS "s"  THEN DO:
                            v_cat = "����" .
               END.
               ELSE IF so_nbr BEGINS "qt" THEN
                    v_cat = "����" .
              ELSE
                   v_cat = "����" .

            FIND FIRST tt WHERE tt_cat = v_cat AND tt_nbr = so_nbr AND tt_part = ld_part  NO-ERROR .
            IF NOT AVAILABLE tt THEN DO:

               

                FIND FIRST sod_det WHERE sod_domain = GLOBAL_domain AND sod_nbr = so_nbr AND sod_part = ld_part NO-LOCK NO-ERROR .
               
                FIND FIRST ad_mstr WHERE ad_domain = GLOBAL_domain AND ad_addr = so_cust NO-LOCK NO-ERROR .
                  FIND FIRST pt_mstr WHERE pt_domain = GLOBAL_domain AND pt_part = ld_part NO-LOCK NO-ERROR .
                   FIND FIRST CODE_mstr WHERE CODE_domain = GLOBAL_domain AND CODE_fldname = "ss_20100423_001" AND CODE_value = so__chr01 NO-LOCK NO-ERROR .

                   FIND LAST tr_hist WHERE tr_domain = ld_domain AND tr_type = "rct-tr" AND tr_part = ld_part 
                       AND tr_loc = ld_loc AND tr_serial = ld_lot AND tr_ref = ld_ref NO-LOCK NO-ERROR .
            
                      CREATE tt .
		              ASSIGN
                      tt_cat = v_cat
                      tt_dept = so__chr01
                      tt_deptname =  IF AVAILABLE CODE_mstr THEN CODE_cmmt ELSE ""
                      tt_part = ld_part
                      tt_desc1 = IF AVAILABLE pt_mstr THEN pt_desc1 ELSE ""
                      tt_vend =  so_cust
                      tt_name = IF AVAILABLE ad_mstr THEN ad_name ELSE ""
                      tt_nbr = so_nbr
                      tt_date = IF AVAILABLE tr_hist THEN tr_effdate ELSE ?
                      tt_qty = ld_qty_oh
                      tt_cost = IF AVAILABLE sod_Det THEN sod_price ELSE 0
                      tt_amt = tt_qty * tt_cost
                      tt_type = "1"
                          .
              END.
              ELSE DO:
                  ASSIGN
                      tt_qty = tt_qty + ld_qty_oh
                      tt_amt =  tt_qty * tt_cost
                     .

              END.

   END.

   /* ˳�ƿ�� */

  FOR EACH tt WHERE tt_type = "1"    BREAK BY tt_nbr BY tt_part:
      
     
          IF tt_qty = 0   THEN DO:
              DELETE tt .
          END.
          
      
  END.
  /* ������ */

  
   
  
  
    /* ���㷢����Ʒ*/


    /* Ӧ�գ�Ԥ�� */
 
   /*
   CASE TYPE:
       WHEN  "1"  THEN DO:
           v_acct = "hk001" .
       END.
       WHEN "2"  THEN DO:
            v_acct = "hk002" .
       END.
       WHEN "3" THEN
        v_acct = "hk003" .
   END CASE.

   CASE TYPE1:
       WHEN  "1"  THEN DO:
           v_acct1 = "hk001" .
       END.
       WHEN "2"  THEN DO:
            v_acct1 = "hk002" .
       END.
       WHEN "3" THEN
        v_acct1 = "hk003" .
   END CASE.
   */

   /* Ӧ��*/
   {gprun.i ""xxrar002002.p""
       "(
       INPUT cust,
       INPUT cust1 ,
       INPUT v_acct,
       INPUT v_acct1,
       INPUT dept,
       INPUT dept1,
       INPUT due
       )"}

/*    FOR EACH ar_mstr WHERE ar_domain = GLOBAL_domain  AND ar_type = "i" AND (ar_cust >= cust AND ar_cust <= cust1 )          */
/*         AND ar_effdate <= due NO-LOCK ,                                                                                     */
/*         EACH idh_hist WHERE idh_domain = ar_domain AND   idh_inv_nbr = ar_nbr AND ( idh_site >= site AND idh_site <= site1) */
/*        AND(idh_acct >= v_acct AND idh_acct <= v_acct1) AND (idh_cc >= dept AND idh_cc <= dept1) NO-LOCK ,                   */
/*        EACH pt_mstr WHERE pt_domain = idh_domain AND pt_part = idh_part NO-LOCK :                                           */
/*                                                                                                                             */
/*        CREATE tt .                                                                                                          */
/*        FIND FIRST cc_mstr WHERE cc_domain = GLOBAL_domain AND cc_ctr = idh_cc NO-LOCK NO-ERROR .                            */
/*        FIND FIRST ad_mstr WHERE ad_domain = GLOBAL_domain AND ad_addr = ar_cust NO-LOCK NO-ERROR .                          */
/*                                                                                                                             */
/*        ASSIGN                                                                                                               */
/*                                                                                                                             */
/*           tt_dept = idh_cc                                                                                                  */
/*           tt_deptname = IF AVAILABLE cc_mstr THEN cc_desc ELSE ""                                                           */
/*           tt_vend = ar_cust                                                                                                 */
/*           tt_name = IF AVAILABLE ad_mstr THEN ad_name ELSE ""                                                               */
/*           tt_nbr = ar_nbr                                                                                                   */
/*           tt_date = ar_effdate                                                                                              */
/*           tt_part = idh_part                                                                                                */
/*           tt_desc1 = pt_desc1                                                                                               */
/*           tt_qty = idh_qty_inv                                                                                              */
/*           tt_cost = idh_price                                                                                               */
/*           tt_amt = tt_qty * tt_cost                                                                                         */
/*           tt_type = "2"                                                                                                     */
/*               .                                                                                                             */
/*         CASE idh_acct:                                                                                                      */
/*            WHEN  "hk001"  THEN DO:                                                                                          */
/*                tt_cat = "����" .                                                                                            */
/*            END.                                                                                                             */
/*            WHEN "hk002"  THEN DO:                                                                                           */
/*                 tt_cat = "����" .                                                                                           */
/*            END.                                                                                                             */
/*            WHEN "hk003" THEN                                                                                                */
/*                 tt_cat = "����" .                                                                                           */
/*         END CASE.                                                                                                           */
/*    END.                                                                                                                     */
   
   
   /* Ӧ��*/

   /* Ԥ�� */


/*    FOR EACH ar_mstr WHERE ar_domain = GLOBAL_domain  AND ar_type = "p" AND (ar_cust >= cust AND ar_cust <= cust1 ) */
/*         AND ar_effdate <= due NO-LOCK ,                                                                            */
/*        EACH ard_det WHERE ard_domain = ar_domain AND ard_type = "u" AND ard_acct >= v_acct AND ard_acct <= v_acct1 */
/*        AND ( ard_cc >= dept AND ard_cc <= dept1) :                                                                 */
/*                                                                                                                    */
/*        CREATE tt .                                                                                                 */
/*        FIND FIRST cc_mstr WHERE cc_domain = GLOBAL_domain AND cc_ctr = ard_cc NO-LOCK NO-ERROR .                   */
/*        FIND FIRST ad_mstr WHERE ad_domain = GLOBAL_domain AND ad_addr = ar_cust NO-LOCK NO-ERROR .                 */
/*                                                                                                                    */
/*        ASSIGN                                                                                                      */
/*                                                                                                                    */
/*           tt_dept = ard_cc                                                                                         */
/*           tt_deptname = IF AVAILABLE cc_mstr THEN cc_desc ELSE ""                                                  */
/*           tt_vend = ar_cust                                                                                        */
/*           tt_name = IF AVAILABLE ad_mstr THEN ad_name ELSE ""                                                      */
/*           tt_nbr = ar_batch                                                                                        */
/*           tt_date = ar_effdate                                                                                     */
/*           tt_amt = ard_amt                                                                                         */
/*           tt_type = "3"                                                                                            */
/*               .                                                                                                    */
/*         CASE ard_acct:                                                                                             */
/*            WHEN  "hk001"  THEN DO:                                                                                 */
/*                tt_cat = "����" .                                                                                   */
/*            END.                                                                                                    */
/*            WHEN "hk002"  THEN DO:                                                                                  */
/*                 tt_cat = "����" .                                                                                  */
/*            END.                                                                                                    */
/*            WHEN "hk003" THEN                                                                                       */
/*                 tt_cat = "����" .                                                                                  */
/*         END CASE.                                                                                                  */
/*    END.                                                                                                            */
/*                                                                                                                    */

   /* Ԥ�� */

      /* Ӧ�գ�Ԥ�� */
    
/*    for each pt_mstr no-lock:              */
/*        PUT UNFORMATTED pt_part ";".       */
/*        PUT UNFORMATTED pt_um ";".         */
/*        PUT UNFORMATTED pt_desc1 ";".      */
/*        PUT UNFORMATTED pt_loc ";".        */
/*        PUT UNFORMATTED pt_prod_line ";".  */
/*        PUT UNFORMATTED pt_mrp ";".        */
/*        PUT UNFORMATTED pt_abc ";".        */
/*        PUT UNFORMATTED pt_type ";" skip. */
/*                                           */
/*    end.                                   */
  
   FOR EACH tt NO-LOCK :
       IF tt_type = "1" THEN DO:

           PUT UNFORMATTED
                tt_cat vv
                  tt_dept vv
                  tt_deptname vv
                  tt_vend   vv
                   tt_name vv
                   tt_nbr vv
                   tt_date vv
                   tt_part vv
                   tt_desc1 vv
                    tt_qty vv
                    tt_cost vv
                    tt_amt vv
                    "0" vv
                    "0" vv
                    "0" vv
                   "0" vv 
                  "0" vv 
            SKIP
                       .

       END.
       ELSE IF tt_type = "2"  THEN DO:


            PUT UNFORMATTED
                tt_cat vv
                  tt_dept vv
                  tt_deptname vv
                  tt_vend   vv
                   tt_name vv
                   tt_nbr vv
                   tt_date vv
                   tt_part vv
                   tt_desc1 vv
                    tt_qty vv
                    tt_cost vv
                     "0" vv
                    tt_amt vv
                    
                    "0" vv
                    "0" vv
                   "0" vv 
                  "0" vv 
            SKIP
                       .

           

       END.
       ELSE IF tt_type = "3" THEN DO:
          PUT UNFORMATTED
                 tt_cat vv
                  tt_dept vv
                  tt_deptname vv
                  tt_vend   vv
                   tt_name vv
                   tt_nbr vv
                   tt_date vv
                   tt_part vv
                   tt_desc1 vv
                    tt_qty vv
                    tt_cost vv
                     "0" vv
                     "0" vv
                    tt_amt vv
                    
                    "0" vv
                     "0" vv 
                   "0" vv 
            SKIP
                       .

       END.
       ELSE IF tt_type = "4" THEN DO:

          
            PUT UNFORMATTED
                tt_cat vv
                  tt_dept vv
                  tt_deptname vv
                  tt_vend   vv
                   tt_name vv
                   tt_nbr vv
                   tt_date vv
                   tt_part vv
                   tt_desc1 vv
                    tt_qty vv
                    tt_cost vv
                     "0" vv
                    "0" vv
                    
                    "0" vv
                    tt_amt vv
                   "0" vv 
                "0" vv 
            SKIP
                       .

       END.
   END.

   {mfreset.i}
 /* {mfrtrail.i} */
end.

{wbrp04.i &frame-spec = a}
