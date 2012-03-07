/* ss - 110726.1 by: jack */  
/* ss - 110803.1 by: jack */ /* 暂估金额与5.13.10不对 */
/* ss - 110804.1 by: jack */  /* 修改暂估单价 */

/* DISPLAY TITLE */
/*
{mfdtitle.i "110726.1 "}
*/
/*
{mfdtitle.i "110803.1 "}
*/
{mfdtitle.i "110804.1 "}

define variable site       like si_site.   
define variable site1      like si_site.  
DEFINE VAR vendor LIKE vd_addr .
DEFINE VAR vendor1 LIKE vd_addr .
DEFINE VAR buyer AS CHAR .
DEFINE VAR buyer1 AS CHAR .
DEFINE VAR due AS DATE INITIAL TODAY .
DEFINE VAR vv AS CHAR INITIAL ";" .


define var  part       like pt_part no-undo.
define var part1      like pt_part no-undo.
define var acc        like ap_acct no-undo.
define var acc1       like ap_acct no-undo.
define var sub        like ap_sub no-undo.
define var sub1       like ap_sub no-undo.
define var cc         like ap_cc no-undo.
define var cc1        like ap_cc no-undo.
define var rcpt_from  like prh_rcp_date format "99/99/99" no-undo.
define var sel_inv    like mfc_logical  initial yes no-undo.
define var sel_sub    like mfc_logical  initial yes no-undo.
define var sel_mem    like mfc_logical  initial yes no-undo.
define var excl_unconfirmed like mfc_logical initial yes no-undo.
define var use_tot    like mfc_logical  initial no no-undo.
define var base_rpt   like po_curr no-undo.
define var l-summary  like mfc_logical no-undo.



DEFINE NEW SHARED TEMP-TABLE tt  /* */
    FIELD tt_vend LIKE po_vend
    FIELD tt_name LIKE ad_name
    FIELD tt_nbr LIKE vo_invoice
    FIELD tt_date AS DATE
    FIELD tt_user AS CHAR
    FIELD tt_part LIKE pt_part
    FIELD tt_desc1 LIKE pt_desc1
    FIELD tt_qty LIKE pod_qty_ord
    FIELD tt_cost LIKE prh_pur_cost
    FIELD tt_amt LIKE ap_amt
    FIELD tt_type AS CHAR /* 1 入库 2 应付 3 预付*/
    .
DEFINE VAR TYPE_POReceiver AS CHAR INITIAL "07" .

/*
   define variable.
*/

form
   site       colon 15 
   site1     label {t001.i} colon 49 skip
   vendor        colon 15 
   vendor1     label {t001.i} colon 49 skip
   buyer        colon 15 
   buyer1     label {t001.i} colon 49 skip
   due       colon 15 
   
   with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{wbrp01.i}

repeat on error undo, retry:
   if site1 = hi_char then site1 = "".
   if vendor1 = hi_char then vendor1 = "".
   IF buyer1 = hi_char THEN buyer1 = "" .


   if c-application-mode <> "WEB" then
   update    
      site site1 vendor vendor1 buyer buyer1 due
   with frame a.

   {wbrp06.i &command = update &fields = 
       "site site1 vendor vendor1 buyer buyer1 due"
         &frm = "a"}

   if (c-application-mode <> "WEB") or
      (c-application-mode = "WEB" and
      (c-web-request begins "DATA"))
   then do:

      bcdparm = "".
      {mfquoter.i site  }
      {mfquoter.i site1 }
      {mfquoter.i vendor  }
      {mfquoter.i vendor1 }
      {mfquoter.i buyer  }
      {mfquoter.i buyer1 }
      {mfquoter.i due  }

      
      if site1 = "" then site1 = hi_char.
      if vendor1 = "" then vendor1 = hi_char.
      if buyer1 = "" then buyer1 = hi_char.

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

       FOR EACH tt:
           DELETE tt .
       END.

   /* FIND AND DISPLAY */
   PUT UNFORMATTED "ExcelFile" ";" "xxrap001" SKIP.   /* excel 模板名称 */
   PUT UNFORMATTED "SaveFile" ";" "xxrap001" SKIP.     /* excel 保存名称 */
   PUT UNFORMATTED "BeginRow" ";" "2" SKIP.       /* excel 从第几行开始 */

   /* 计算入库*/
   ASSIGN
       part = ""
       part1 = ""
       acc = ""
       acc1 = ""
       sub = ""
       sub1 = ""
       cc = ""
       cc1 = ""
       sel_inv = YES
       sel_sub = YES
       sel_mem = YES
       excl_unconfirmed = NO /* 排除做了凭证但是为确认,但是帐龄中是否会体现？*/
       USE_tot = NO 
       base_rpt = ""
       l-summary = NO
       .

    
    /* 借用5.13.10*/
    {gprun.i ""xxrap001001.p"" "(
      INPUT vendor,
      INPUT vendor1,
      INPUT part,
      INPUT part1,
      INPUT site,
      INPUT site1,
      INPUT acc,
      INPUT acc1,
      INPUT sub,
      INPUT sub1,
      INPUT cc,
      INPUT cc1,
      INPUT due,
      INPUT rcpt_from,
      INPUT sel_inv,
      INPUT sel_sub,
      INPUT sel_mem,
      INPUT excl_unconfirmed,
      INPUT USE_tot,
      INPUT base_rpt,
      INPUT l-summary,
      INPUT buyer,
      INPUT buyer1
      
      )"}

  


/*    FOR EACH prh_hist USE-INDEX prh_vend WHERE prh_domain = GLOBAL_domain                                        */
/*        AND (prh_vend >= vendor AND prh_vend <= vendor1 )                                                            */
/*        AND (prh_site >= site AND prh_site <= site1)                                                             */
/*        AND (prh_per_date <= due) NO-LOCK ,                                                                      */
/*        EACH po_mstr WHERE po_domain = prh_domain AND po_nbr = prh_nbr                                           */
/*        AND (po_user_id >= buyer AND po_user_id <= buyer1) NO-LOCK ,                                             */
/*        EACH ad_mstr WHERE ad_domain = po_domain AND ad_addr = prh_vend NO-LOCK ,                                */
/*        EACH pt_mstr WHERE pt_domain = po_domain AND pt_part = prh_part NO-LOCK :                                */
/*                                                                                                                 */
/*        FIND FIRST tt WHERE tt_type = "1" AND tt_vend = prh_vend AND tt_nbr = prh_nbr AND tt_date = prh_per_date */
/*            AND tt_part = prh_part  NO-ERROR .                                                                   */
/*        IF NOT AVAILABLE tt THEN DO:                                                                             */
/*            CREATE tt .                                                                                          */
/*            ASSIGN                                                                                               */
/*                tt_date = prh_per_date                                                                           */
/*                tt_vend = prh_vend                                                                               */
/*                tt_name = ad_name                                                                                */
/*                tt_nbr = prh_nbr                                                                                 */
/*                tt_user = po_user_id                                                                             */
/*                tt_part = prh_part                                                                               */
/*                tt_desc1 = pt_desc1                                                                              */
/*                tt_qty = prh_rcvd                                                                                */
/*                tt_cost = prh_pur_cost                                                                           */
/*                tt_amt = prh_rcvd * prh_pur_cost                                                                 */
/*                tt_type = "1"                                                                                    */
/*                .                                                                                                */
/*        END.                                                                                                     */
/*        ELSE DO:                                                                                                 */
/*            ASSIGN                                                                                               */
/*                                                                                                                 */
/*                tt_qty = tt_qty + prh_rcvd                                                                       */
/*                tt_amt =  tt_amt + tt_qty * tt_cost                                                              */
/*                .                                                                                                */
/*                                                                                                                 */
/*        END.                                                                                                     */
/*                                                                                                                 */
/*                                                                                                                 */
/*    END.                                                                                                         */
    /* 计算入库*/

   /* 不考虑零件
    FOR EACH ap_mstr USE-INDEX ap_vend_date WHERE ap_domain  = GLOBAL_domain 
       AND ap_date <= due
       AND (ap_vend >= vendor AND ap_vend <= vendor1)
       AND ap_type = "vo"   NO-LOCK ,
       EACH vo_mstr WHERE vo_domain = ap_domain AND vo_ref = ap_ref NO-LOCK ,
      EACH po_mstr WHERE po_domain = ap_domain 
       AND (po_site >= site AND po_site <= site1)
       AND (po_user_id >= buyer AND po_user_id <= buyer1) NO-LOCK ,
       EACH ad_mstr WHERE ad_domain = GLOBAL_domain AND ad_addr = ap_vend NO-LOCK ,
       EACH  vph_hist no-lock where vph_domain = global_domain 
       and  vph_ref = ap_ref  and vph_pvo_id <> 0 and vph_pvod_id_line > 0 use-index vph_ref,
       each pvo_mstr no-lock  where pvo_mstr.pvo_domain = global_domain and
               pvo_lc_charge   = "" and
               pvo_internal_ref_type = TYPE_POReceiver and
               pvo_id = vph_pvo_id :

         find prh_hist  where prh_hist.prh_domain = global_domain and
         prh_receiver = pvo_internal_ref
            and prh_line = pvo_line no-lock no-error.

       IF AVAILABLE prh_hist  THEN DO:
       
               IF  ap_acct <> "1123"  THEN DO:
               
                        FIND FIRST tt WHERE tt_type = "2" AND  tt_vend = ap_vend AND tt_nbr = vo_invoice AND tt_date = ap_date
                           AND tt_part = prh_part  NO-ERROR .
                       IF NOT AVAILABLE tt THEN DO:
                           CREATE tt .
                           ASSIGN
                               tt_date = ap_date
                               tt_vend = prh_vend
                               tt_name = ad_name
                               tt_nbr = prh_nbr
                               tt_part = prh_part
                               tt_user = vo_type
                               tt_qty = 0
                               tt_cost = 0
                               tt_amt = ap_amt
                               tt_type = "2"
                               .
                         
                               FIND FIRST pt_mstr WHERE pt_domain = GLOBAL_domain AND pt_part = prh_part NO-LOCK NO-ERROR .
                               IF AVAILABLE pt_mstr  THEN DO:
                                   ASSIGN
                                       tt_part = pt_part
                                       tt_desc1 = pt_desc1
                                       .
                               END.
                               ELSE DO:
                                    ASSIGN
                                       tt_part = prh_part
                                       tt_desc1 = ""
                                       .
                               END.
                          
        
                       END.
                       ELSE DO:
                           ASSIGN
                
/*                                tt_qty = tt_qty + prh_rcvd */
                               tt_amt =  tt_amt + ap_amt
                               .
                
                       END.
               END.
               ELSE DO:
                    FIND FIRST tt WHERE tt_type = "3" AND  tt_vend = ap_vend AND tt_nbr = prh_nbr AND tt_date = ap_date
                           AND tt_part = prh_part  NO-ERROR .
                      IF NOT AVAILABLE tt THEN DO:
                           CREATE tt .
                           ASSIGN
                               tt_date = ap_date
                               tt_vend = prh_vend
                               tt_name = ad_name
                               tt_nbr = prh_nbr
                               tt_part = prh_part
                               tt_user = vo_type
                               tt_qty = 0
                               tt_cost = 0
                               tt_amt = ap_amt
                               tt_type = "3"
                               .
                         
                               FIND FIRST pt_mstr WHERE pt_domain = GLOBAL_domain AND pt_part = prh_part NO-LOCK NO-ERROR .
                               IF AVAILABLE pt_mstr  THEN DO:
                                   ASSIGN
                                       tt_part = pt_part
                                       tt_desc1 = pt_desc1
                                       .
                               END.
                               ELSE DO:
                                    ASSIGN
                                       tt_part = prh_part
                                       tt_desc1 = ""
                                       .
                               END.
                          
        
                       END.
                       ELSE DO:
                           ASSIGN
                
/*                                tt_qty = tt_qty + prh_rcvd */
                               tt_amt =  tt_amt + ap_amt
                               .
                       END.

        
               END.
        END. /* availab prh_hist */
   END.
    不考虑零件*/

   /*
   /* 应付*/
   FOR EACH ap_mstr USE-INDEX ap_vend_date WHERE ap_domain  = GLOBAL_domain 
       AND ap_date <= due
       AND (ap_vend >= vendor AND ap_vend <= vendor1)
       AND ap_type = "vo"   NO-LOCK ,
       EACH vo_mstr WHERE vo_domain = ap_domain AND vo_ref = ap_ref NO-LOCK ,
      EACH po_mstr WHERE po_domain = ap_domain 
       AND (po_site >= site AND po_site <= site1)
       AND (po_user_id >= buyer AND po_user_id <= buyer1) NO-LOCK ,
       EACH ad_mstr WHERE ad_domain = GLOBAL_domain AND ad_addr = ap_vend NO-LOCK ,
       EACH  vph_hist no-lock where vph_domain = global_domain 
       and  vph_ref = ap_ref  and vph_pvo_id <> 0 and vph_pvod_id_line > 0 use-index vph_ref,
       each pvo_mstr no-lock  where pvo_mstr.pvo_domain = global_domain and
               pvo_lc_charge   = "" and
               pvo_internal_ref_type = TYPE_POReceiver and
               pvo_id = vph_pvo_id,
          each pvod_det no-lock where
               pvod_det.pvod_domain = global_domain
           and pvod_id = pvo_id
           and pvod_id_line = vph_pvod_id_line
            :

         find prh_hist  where prh_hist.prh_domain = global_domain and
         prh_receiver = pvo_internal_ref
            and prh_line = pvo_line no-lock no-error.

       IF AVAILABLE prh_hist  THEN DO:
       
               IF  ap_acct <> "1123"  THEN DO:
               
                        FIND FIRST tt WHERE tt_type = "2" AND  tt_vend = ap_vend AND tt_nbr = vo_invoice AND tt_date = ap_date
                           AND tt_part = prh_part  NO-ERROR .
                       IF NOT AVAILABLE tt THEN DO:
                           CREATE tt .
                           ASSIGN
                               tt_date = ap_date
                               tt_vend = prh_vend
                               tt_name = ad_name
                               tt_nbr = prh_nbr
                               tt_part = prh_part
                               tt_user = vo_type
                               tt_qty = 0
                               tt_cost = 0
                               tt_amt = ap_amt
                               tt_type = "2"
                               .
                         
                               FIND FIRST pt_mstr WHERE pt_domain = GLOBAL_domain AND pt_part = prh_part NO-LOCK NO-ERROR .
                               IF AVAILABLE pt_mstr  THEN DO:
                                   ASSIGN
                                       tt_part = pt_part
                                       tt_desc1 = pt_desc1
                                       .
                               END.
                               ELSE DO:
                                    ASSIGN
                                       tt_part = prh_part
                                       tt_desc1 = ""
                                       .
                               END.
                          
        
                       END.
                       ELSE DO:
                           ASSIGN
                
/*                                tt_qty = tt_qty + prh_rcvd */
                               tt_amt =  tt_amt + ap_amt
                               .
                
                       END.
               END.
               ELSE DO:
                    FIND FIRST tt WHERE tt_type = "3" AND  tt_vend = ap_vend AND tt_nbr = prh_nbr AND tt_date = ap_date
                           AND tt_part = prh_part  NO-ERROR .
                      IF NOT AVAILABLE tt THEN DO:
                           CREATE tt .
                           ASSIGN
                               tt_date = ap_date
                               tt_vend = prh_vend
                               tt_name = ad_name
                               tt_nbr = prh_nbr
                               tt_part = prh_part
                               tt_user = vo_type
                               tt_qty = 0
                               tt_cost = 0
                               tt_amt = ap_amt
                               tt_type = "3"
                               .
                         
                               FIND FIRST pt_mstr WHERE pt_domain = GLOBAL_domain AND pt_part = prh_part NO-LOCK NO-ERROR .
                               IF AVAILABLE pt_mstr  THEN DO:
                                   ASSIGN
                                       tt_part = pt_part
                                       tt_desc1 = pt_desc1
                                       .
                               END.
                               ELSE DO:
                                    ASSIGN
                                       tt_part = prh_part
                                       tt_desc1 = ""
                                       .
                               END.
                          
        
                       END.
                       ELSE DO:
                           ASSIGN
                
/*                                tt_qty = tt_qty + prh_rcvd */
                               tt_amt =  tt_amt + ap_amt
                               .
                       END.

        
               END.
        END. /* availab prh_hist */
   END.
   /* 应付*/
   */
        /* 应付，预付*/
         /* 借用28.17.4*/
     
    {gprun.i ""xxrap001002.p"" "(
      INPUT vendor,
      INPUT vendor1,
      INPUT due,
      INPUT buyer,
      INPUT buyer1
      
      )"}
       
        /* 应付，预付*/
    
/*    for each pt_mstr no-lock:              */
/*        PUT UNFORMATTED pt_part ";".       */
/*        PUT UNFORMATTED pt_um ";".         */
/*        PUT UNFORMATTED pt_desc1 ";".      */
/*        PUT UNFORMATTED pt_loc ";".        */
/*        PUT UNFORMATTED pt_prod_line ";".  */
/*        PUT UNFORMATTED pt_mrp ";".        */
/*        PUT UNFORMATTED pt_abc ";".        */
/*        PUT UNFORMATTED pt_buyer ";" skip. */
/*                                           */
/*    end.                                   */
  
   FOR EACH tt NO-LOCK :
       IF tt_type = "1" THEN DO:

           PUT UNFORMATTED  
              tt_vend   
              vv tt_name 
               vv tt_nbr 
             vv tt_date 
            vv tt_user
            vv tt_part 
            vv tt_desc1 
            vv tt_qty 
            vv tt_cost 
            vv tt_amt 
            vv "" 
            vv ""
            vv "" vv  SKIP
                       .

       END.
       ELSE IF tt_type = "2"  THEN DO:
            PUT UNFORMATTED  
              tt_vend  
              vv tt_name 
               vv tt_nbr 
             vv tt_date 
            vv tt_user
            vv tt_part 
            vv tt_desc1 
            vv tt_qty 
            vv tt_cost 
            vv ""
            vv tt_amt 
            vv "" 
            vv "" vv SKIP
                       .

       END.
       ELSE DO:

           PUT UNFORMATTED  
              tt_vend  
              vv tt_name 
               vv tt_nbr 
                 vv tt_date 
                vv tt_user
                vv tt_part 
                vv tt_desc1 
                vv tt_qty 
                vv tt_cost 
                vv ""
                vv ""
                vv tt_amt
                vv "" vv SKIP
                           .

       END.
   END.

   {mfreset.i}
 /* {mfrtrail.i} */
end.

{wbrp04.i &frame-spec = a}
