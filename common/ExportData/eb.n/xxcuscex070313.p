
/*xxcuscex.p ---- Program to DownLoad Customer Schedule Order (7.3.13) EB2                    */
/*COPYRIGHT JCI. INC ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.                        */
/*V8:ConvertMode=Report                                                                       */
/*V8:WebEnabled=No                                                                            */
/*V8:RunMode=Character,Windows                                                                */
/* This program Extracts the Customer Schedule Order Data from Mfg/Pro EB2 into  .CSV File    */
/**********************************************************************************************/
/* PROCEDURE NAME           : xxcuscex.p                                                      */  
/* PROCEDURE TYPE           : Process                                                         */
/* DESCRIPTION              :                                                                 */
/* INCLUDE FILES            :                                                                 */
/* CALLED BY                :                                                                 */
/* CALLED PROCEDURES        :                                                                 */
/**********************************************************************************************/
/* CREATED BY               : MAHESH K (TCSL)                            DATE: 10-09-2005     */
/* REVISION                 : MK07        LAST  MODIFIED BY:             DATE: 28-09-2005     */
/**********************************************************************************************/



               {mfdtitle.i}

               &SCOPED-DEFINE xxcuscex_p_1  "Extraction File Name"
               &SCOPED-DEFINE xxcuscex_p_2  "ERROR: Blank Filename Not Allowed"   


               /* Variable Declaration */
               DEFINE VARIABLE m_filename     AS CHARACTER  FORMAT "x(40)"  NO-UNDO.
               DEFINE VARIABLE m_impexp       AS LOGICAL                    NO-UNDO.
               DEFINE VARIABLE m_print_ih     AS LOGICAL                    NO-UNDO.
               DEFINE VARIABLE m_edi_ih       AS LOGICAL                    NO-UNDO.
               DEFINE VARIABLE m_wk_offset    AS INT        FORMAT "9"      NO-UNDO.
               DEFINE VARIABLE m_socmmts      AS LOGICAL                    NO-UNDO.
               DEFINE VARIABLE m_multsp       AS LOGICAL                    NO-UNDO.
               DEFINE VARIABLE m_multsp1      AS LOGICAL                    NO-UNDO.
               DEFINE VARIABLE m_inv_auth     AS LOGICAL                    NO-UNDO.
               DEFINE VARIABLE m_cumulative   AS LOGICAL                    NO-UNDO.
               DEFINE VARIABLE m_auto_inv     AS LOGICAL                    NO-UNDO.
               DEFINE VARIABLE m_translt_days AS DECIMAL                    NO-UNDO.
               DEFINE VARIABLE m_taxin        AS LOGICAL                    NO-UNDO.
               DEFINE VARIABLE m_psd_pat      AS CHARACTER  FORMAT "X(2)"   NO-UNDO.         
               DEFINE VARIABLE m_psd_time     AS CHARACTER  FORMAT "X(2)"   NO-UNDO.
               DEFINE VARIABLE i              AS INTEGER                    NO-UNDO.
               DEFINE VARIABLE m_ssd_pat      AS CHARACTER  FORMAT "X(2)"   NO-UNDO.          
               DEFINE VARIABLE m_ssd_time     AS CHARACTER  FORMAT "X(2)"   NO-UNDO.
               DEFINE VARIABLE m_cmmts        AS LOGICAL                    NO-UNDO.
               DEFINE VARIABLE m_ship_cmplt   LIKE          so_ship_cmplt   NO-UNDO.
               DEFINE VARIABLE m_merge_rss    LIKE          so_merge_rss    NO-UNDO.
               DEFINE VARIABLE m_auth_days    LIKE          so_auth_days    NO-UNDO.
               DEFINE VARIABLE m_terms_deliv  LIKE          ie_terms_deliv	NO-UNDO.
               DEFINE VARIABLE m_nat_trans    LIKE          ie_nat_trans    NO-UNDO.
               DEFINE VARIABLE m_ctry_desdisp LIKE          ie_ctry_desdisp NO-UNDO.
               DEFINE VARIABLE m_mode_transp  LIKE          ie_mode_transp  NO-UNDO.
               DEFINE VARIABLE m_port_arrdisp LIKE          ie_port_arrdisp NO-UNDO.
               DEFINE VARIABLE m_stat_proc    LIKE          ie_stat_proc    NO-UNDO.
               DEFINE VARIABLE m_port_transh  LIKE          ie_port_transh  NO-UNDO.
               DEFINE VARIABLE m_incl_memo    LIKE          ie_incl_memo    NO-UNDO.
               DEFINE VARIABLE ctype          AS  CHARACTER FORMAT "X(10)"  NO-UNDO.
                
               DEFINE VARIABLE m_alt_cn       LIKE          pt_part  EXTENT 7             NO-UNDO.
               DEFINE VARIABLE m_std_qty     AS   DECIMAL  FORMAT "->>>>>>>>9.99"  EXTENT 7 NO-UNDO.  
               DEFINE VARIABLE m_ctype       AS   CHARACTER FORMAT "X(10)"  EXTENT 7 NO-UNDO.   
               DEFINE VARIABLE cntr AS INTEGER.
               
                   
               /* form Definition */
               FORM
               SKIP(1)
               m_filename VALIDATE( m_filename <> "", {&xxcuscex_p_2} )  LABEL {&xxcuscex_p_1}
               WITH FRAME a SIDE-LABELS TITLE "Customer Schedule Order Extraction" WIDTH 80.

               {pxmsg.i &MSGNUM = 9000 &ERRORLEVEL = 1}

               

               /*Accepting File Name */
               UPDATE m_filename  WITH FRAME a.


               FIND FIRST  soc_ctrl NO-LOCK .
               
               /*Extracting the Data into the File */
               OUTPUT TO VALUE(m_filename).
EXPORT DELIMITER ","
 "scx_shipfrom"	 "scx_shipto"	 "scx_order"	 "so_ar_acct"	 "so_ar_sub"	 "so_ar_cc"	 "so_taxable"	 "so_taxc"	 "m_wk_offset"	 "m_inv_auth"	 "so_incl_iss"	 "m_cumulative"	 "no"	 "so_bill"	 "m_auto_inv"	 "m_impexp"	 "so_bump_all"	 "so_shipvia"	 "so_fob"	 "m_translt_days"	 "no"	 "m_print_ih"	 "m_edi_ih"	 "so_print_pl"	 "m_socmmts"	 "so_site"	 "so_channel"	 "so_cum_acct"	 "so_curr"	 "so_rmks"	 "so_ex_rate"	 "so_tax_usage"	 "so_tax_env"	 "so_taxc"	 "so_taxable"	 "m_taxin"	 "so_slspsn[1]"	 "m_multsp"	 "so_comm_pct[1]"	 "BLANK"	 "BLANK"	 "ZERO"	 "no"	 "m_terms_deliv"	 "m_nat_trans"	 "m_ctry_desdisp"	 "m_mode_transp"	 "m_port_arrdisp"	 "m_stat_proc"	 "m_port_transh"	 "m_incl_memo"	 "m_ship_cmplt"	 "m_merge_rss"	 "m_auth_days"	 "so__qadl02"	 "scx_part"	 "scx_po"	 "BLANK"	 "BLANK"	 "scx_line"	 "sod_pr_list"	 "sod_list_pr"	 "sod_price"	 "sod_acct"	 "sod_sub"	 "sod_cc"	 "sod_dsc_acct"	 "sod_dsc_sub"	 "sod_dsc_cc"	 "sod_consume"	 "sod_type"	 "sod_loc"	 "sod_taxable"	 "sod_taxc"	 "BLANK"	 "no"	 "sod_tax_usage"	 "sod_tax_env"	 "sod_tax_in"	 "sod_slspsn[1]"	 "m_multsp1"	 "sod_comm_pct[1]"	 "ZERO"	 "ZERO"	 "0"	 "no"	 "sod_rbkt_days"	 "sod_rbkt_weeks"	 "sod_rbkt_mths"	 "sod_fab_days"	 "sod_raw_days"	 "sod_custpart"	 "sod_pkg_code"	 "BLANK"	 "sod_alt_pkg"	 "sod_dock"	 "sod_start_eff[1"	 "sod_end_eff[1]"	 "sod_cum_qty[1]"	 "sod_ord_mult"	 "m_psd_pat"	 "m_psd_time"	 "m_ssd_pat"	 "m_ssd_time"	 "sod_conrep"	 "sod_cum_date[1]"	 "m_cmmts"	 "so_slspsn[2]"	 "so_comm_pct[2]"	 "so_slspsn[3]"	 "so_comm_pct[3]"	 "so_slspsn[4]"	 "so_comm_pct[4]"	 "sod_slspsn[2]"	 "sod_comm_pct[2]"	 "sod_slspsn[3]"	 "sod_comm_pct[3]"	 "sod_slspsn[4]"	 "sod_comm_pct[4]"	 "m_alt_cn[1]"	 "m_alt_cn[2]"	 "m_alt_cn[3]"	 "m_alt_cn[4]"	 "m_alt_cn[5]"	 "m_alt_cn[6]"	 "m_alt_cn[7]"

.

               FOR EACH sod_det NO-LOCK,
                       EACH scx_ref NO-LOCK WHERE scx_order = sod_nbr and        
                                                  scx_line  = sod_line ,
                       EACH so_mstr NO-LOCK WHERE   so_nbr  = sod_nbr :     

                   /*Array intialisation*/
                   ASSIGN cntr = 1.
                   DO i = 1 TO 7:
                       ASSIGN 
                           m_alt_cn[i]    = " " 
                           m_std_qty[i]   = 0
                           m_ctype[i]  = "  ".  
                   END.

                  
                  IF so_slspsn[1] <> " " AND  (so_slspsn[2] <> " " OR so_slspsn[3] <> " " OR so_slspsn[4] <> " ")  THEN
                      m_multsp = YES.

                  IF sod_slspsn[1] <> " " AND (sod_slspsn[2] <> " "  OR sod_slspsn[3] <> " " OR  sod_slspsn[4] <> " " )THEN
                      m_multsp1 = YES.


                 FIND FIRST ie_mstr WHERE ie_nbr = scx_order NO-LOCK NO-ERROR. 
                 IF AVAILABLE ie_mstr THEN DO:
                      ASSIGN
                      m_terms_deliv  =  ie_terms_deliv 
                      m_nat_trans    =  ie_nat_trans   
                      m_ctry_desdisp =  ie_ctry_desdisp 
                      m_mode_transp  =  ie_mode_transp  
                      m_port_arrdisp =  ie_port_arrdisp 
                      m_stat_proc    =  ie_stat_proc    
                      m_port_transh  =  ie_port_transh  
                      m_incl_memo    =  ie_incl_memo  . 
                  END.

                  FIND FIRST act_mstr WHERE act_nbr = sod_nbr AND 
                                            act_line = sod_line NO-LOCK NO-ERROR.
                    IF AVAILABLE act_mstr THEN DO:
                          FOR EACH act_mstr NO-LOCK  WHERE
                               act_nbr  =  sod_nbr AND
                               act_line =  sod_line :
                              ASSIGN 
                                   m_alt_cn[cntr] = act_cont_part.
                                   /*m_std_qty[cntr] = act_ord_mult
                                   m_ctype[cntr]   = act_charge_type.*/
                                   cntr = cntr + 1.
                          END.
                    END.
                    ASSIGN 
                             m_auto_inv     = (substring(so_inv_mthd,2,1) = "y")
                             m_wk_offset    = integer(substring(so_conrep,1,1))
                             m_translt_days = decimal(substring(so_conrep,2,6))
                             m_cumulative   = substring(so_conrep,14,1) = "y"
                             m_socmmts      = (so_cmtindx <> 0 or (new so_mstr and soc_hcmmts))
                             m_print_ih     = (so_inv_mthd begins "b" or so_inv_mthd begins "p"
                                               or so_inv_mthd = "" or so_inv_mthd begins " ")
                             m_edi_ih       = (so_inv_mthd begins "b" or so_inv_mthd begins "e")
                             m_psd_pat      = substring(sod_sch_data,1,2)
                             m_psd_time     = substring(sod_sch_data,3,2)
                             m_ssd_pat      = substring(sod_sch_data,5,2)
                             m_ssd_time     = substring(sod_sch_data,7,2)
                             m_cmmts        = (sod_cmtindx <> 0 OR  (new sod_det and soc_lcmmts))
                             m_inv_auth     =  YES.
                             

                   FIND FIRST  iec_ctrl  NO-LOCK NO-ERROR.
                    IF AVAILABLE iec_ctrl AND iec_impexp = yes THEN 
                       ASSIGN m_impexp = yes.

                   FIND FIRST ad_mstr
                      WHERE ad_addr = so_ship NO-LOCK NO-ERROR.
                   
                   IF NOT AVAILABLE ad_mstr THEN
                      FIND FIRST ad_mstr
                         WHERE ad_addr = so_cust NO-LOCK NO-ERROR.
                      
                   IF AVAILABLE ad_mstr THEN
                      ASSIGN  m_taxin = ad_tax_in.

                   IF so_cum_acct THEN 
                       ASSIGN  m_ship_cmplt =  so_ship_cmplt.
                             ELSE   ASSIGN m_ship_cmplt = 0 .
                                         
                   IF so_cum_acct THEN 
                       ASSIGN  m_merge_rss = so_merge_rss. 
                             ELSE   ASSIGN m_merge_rss  = NO.
                                          
                   IF so_cum_acct THEN
                       ASSIGN  m_auth_days = so_auth_days.  
                             ELSE   ASSIGN m_auth_days  = 0. 
                       
                       EXPORT DELIMITER ","
                                          scx_shipfrom
                                          scx_shipto
                                          scx_order
                                          so_ar_acct
                                          so_ar_sub
                                          so_ar_cc
                                          so_taxable
                                          so_taxc
                                          m_wk_offset
                                          m_inv_auth
                                          so_incl_iss
                                          m_cumulative
                                          "no"                          /*so_consignment*/
                                          so_bill
                                          m_auto_inv
                                          m_impexp
                                          so_bump_all
                                          so_shipvia
                                          so_fob
                                          m_translt_days
                                          "no"                         /*so_custref_val*/
                                          m_print_ih
                                          m_edi_ih
                                          so_print_pl
                                          m_socmmts
                                          so_site
                                          so_channel
                                          so_cum_acct
                                          so_curr    
                                          so_rmks
                                          so_ex_rate                       /*MK07*/
                                          so_tax_usage
                                          so_tax_env
                                          so_taxc
                                          so_taxable
                                          m_taxin
                                          so_slspsn[1]
                                          m_multsp 
                                          so_comm_pct[1]
                                          " "                              /*so_consign_loc*/
                                          " "                              /*so_intrans_loc*/
                                          "0"                              /*so_max_aging_days*/
                                          "no"                             /*so_auto_replenish */
                                          m_terms_deliv	
                                          m_nat_trans
                                          m_ctry_desdisp 
                                          m_mode_transp 
                                          m_port_arrdisp
                                          m_stat_proc
                                          m_port_transh
                                          m_incl_memo   
                                          m_ship_cmplt 
                                          m_merge_rss
                                          m_auth_days 
                                          so__qadl02
                                          scx_part
                                          scx_po
                                          " "                               /*scx_custref*/
                                          " "                               /*scx_modelyr*/
                                          scx_line
                                          sod_pr_list
                                          sod_list_pr
                                          sod_price
                                          sod_acct
                                          sod_sub
                                          sod_cc
                                          sod_dsc_acct
                                          sod_dsc_sub
                                          sod_dsc_cc
                                          sod_consume
                                          sod_type
                                          sod_loc
                                          sod_taxable
                                          sod_taxc
                                          "  "                              /*sod_order_category*/
                                          "no"                              /*sod_consignment*/
                                          sod_tax_usage
                                          sod_tax_env
                                          sod_tax_in
                                          sod_slspsn[1]
                                          m_multsp1 
                                          sod_comm_pct[1]
                                          " "                   /*sod_consign_loc*/
                                          "  "                  /*sod_intrans_loc*/
                                          0                     /*sod_max_aging_days*/
                                          "no"                   /*sod_auto_replenish  */
                                          sod_rbkt_days
                                          sod_rbkt_weeks
                                          sod_rbkt_mths
                                          sod_fab_days 
                                          sod_raw_days
                                          sod_custpart
                                          sod_pkg_code
                                          " "                   /*sod_charge_type*/
                                          sod_alt_pkg
                                          sod_dock
                                          sod_start_eff[1]
                                          sod_end_eff[1]
                                          sod_cum_qty[1]
                                          sod_ord_mult
                                          m_psd_pat
                                          m_psd_time
                                          m_ssd_pat
                                          m_ssd_time
                                          sod_conrep
                                          sod_cum_date[1]
                                          m_cmmts
                                          so_slspsn[2]
                                          so_comm_pct[2]
                                          so_slspsn[3]
                                          so_comm_pct[3]
                                          so_slspsn[4]
                                          so_comm_pct[4]  
                                          sod_slspsn[2]
                                          sod_comm_pct[2]
                                          sod_slspsn[3]
                                          sod_comm_pct[3]
                                          sod_slspsn[4]
                                          sod_comm_pct[4]  
                                          m_alt_cn[1] 
                                          m_alt_cn[2] 
                                          m_alt_cn[3] 
                                          m_alt_cn[4] 
                                          m_alt_cn[5] 
                                          m_alt_cn[6] 
                                          m_alt_cn[7]
                                          "0"    /*m_std_qty[1] */
                                          "0"    /*m_std_qty[2] */
                                          "0"    /*m_std_qty[3] */
                                          "0"    /*m_std_qty[4] */
                                          "0"    /*m_std_qty[5] */
                                          "0"    /*m_std_qty[6] */
                                          "0"    /*m_std_qty[7] */
                                          " "    /*m_ctype[1]   */
                                          " "    /*m_ctype[2]   */
                                          " "    /*m_ctype[3]   */
                                          " "    /*m_ctype[4]   */
                                          " "    /*m_ctype[5]   */
                                          " "    /*m_ctype[6]   */
                                          " "    /*m_ctype[7]   */. 
                                        
                                        ASSIGN cntr = 0.  
                                   END. /* for each cm_mstr */
               OUTPUT CLOSE.
