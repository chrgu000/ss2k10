/*xxvdscex.p ---- Program to DownLoad Supplier Schedule Order (5.5.1.13) EB2                  */
/*COPYRIGHT JCI. INC ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.                        */
/*V8:ConvertMode=Report                                                                       */
/*V8:WebEnabled=No                                                                            */
/*V8:RunMode=Character,Windows                                                                */
/* This program Extracts the Supplier Schedule Order Data from Mfg/Pro EB2 into  .CSV File    */
/**********************************************************************************************/
/* PROCEDURE NAME           : xxvdscex.p                                                      */  
/* PROCEDURE TYPE           : Process                                                         */
/* DESCRIPTION              :                                                                 */
/* INCLUDE FILES            :                                                                 */
/* CALLED BY                :                                                                 */
/* CALLED PROCEDURES        :                                                                 */
/**********************************************************************************************/
/* CREATED BY               : MAHESH K (TCSL)                            DATE:                */
/* REVISION                 :             LAST  MODIFIED BY:             DATE:                */
/* REVISION                 : MK07         LAST  MODIFIED BY:            DATE:  28 sep        */
/**********************************************************************************************/



               {mfdtitle.i}

           &SCOPED-DEFINE xxvdscex_p_1  "Extraction File Name"
           &SCOPED-DEFINE xxvdscex_p_2  "ERROR: Blank Filename Not Allowed"   
           
           /* Variable Declaration */
           DEFINE VARIABLE m_filename     AS CHARACTER  FORMAT "x(40)"  NO-UNDO.
	       DEFINE VARIABLE m_printsch     AS LOGICAL                    NO-UNDO.
	       DEFINE VARIABLE m_edisch       AS LOGICAL                    NO-UNDO.
	       DEFINE VARIABLE m_faxsch       AS LOGICAL                    NO-UNDO.
	       DEFINE VARIABLE m_pocmmts      AS LOGICAL                    NO-UNDO.
	       DEFINE VARIABLE m_impexp       AS LOGICAL                    NO-UNDO.
	       DEFINE VARIABLE m_podcmmts     AS LOGICAL                    NO-UNDO.
               
               /* form Definition */
               FORM
               SKIP(1)
               m_filename VALIDATE( m_filename <> "", {&xxvdscex_p_2} )  LABEL {&xxvdscex_p_1}
               WITH FRAME a SIDE-LABELS TITLE "Supplier Schedule Order Extraction" WIDTH 80.

               {pxmsg.i &MSGNUM = 9000 &ERRORLEVEL = 1}
               
               /*Accepting File Name */
               UPDATE m_filename  WITH FRAME a.

               /*Extracting the Data into the File */
               OUTPUT TO VALUE(m_filename).
                 FOR EACH pod_det NO-LOCK,
                       EACH scx_ref NO-LOCK WHERE scx_order = pod_nbr and        
                                                  scx_line  = pod_line AND 
                                                  scx_type = 2  ,
                       EACH po_mstr NO-LOCK WHERE po_nbr    = pod_nbr :                

                      
                      FOR FIRST iec_ctrl NO-LOCK:
                      END. /* FOR FIRAT iec_ctrl*/

                      FOR FIRST poc_ctrl
                      FIELDS(poc_ers_proc poc_hcmmts poc_insp_loc poc_lcmmts)
                        NO-LOCK:
                      END. /* FOR FIRST poc_ctrl */


                      ASSIGN
                            m_pocmmts   = (po_cmtindx <> 0)
                            m_printsch  = (po_sch_mthd = "" or
                                           substring(po_sch_mthd,1,1) = "p" or
                                           substring(po_sch_mthd,1,1) = "b" or
                                           substring(po_sch_mthd,1,1) = "y")
                            m_edisch    = (substring(po_sch_mthd,1,1) = "e" or
                                           substring(po_sch_mthd,1,1) = "b" or
                                           substring(po_sch_mthd,2,1) = "y")
                            m_faxsch    =  substring(po_sch_mthd,3,1) = "y"
                            m_podcmmts  = (pod_cmtindx <> 0  )or (new pod_det and poc_lcmmts). 
                      
                       IF AVAILABLE iec_ctrl THEN
                            m_impexp = iec_impexp.

                       EXPORT DELIMITER ","
                           	           po_nbr
			                           po_vend
         			                   po_ap_acct
         			                   po_ap_sub
         			                   po_ap_cc
         			                   po_taxable
         			                   po_taxc
         			                   po_cr_terms
         			                   po_bill
         			                   po_ship
         			                   m_printsch
         			                   m_edisch
         			                   m_faxsch
         			                   po_site
         			                   po_shipvia
         			                   po_fob
         			                   po_buyer
         			                   po_contact
         			                   po_contract
                                       po_curr
         			                   m_pocmmts
         			                   m_impexp
                                       po_ex_rate   /*MK07*/
                                       po_tax_usage
         			                   po_tax_env
                                       po_ers_opt
                                       po_pr_lst_tp 
         			                   scx_part
         			                   scx_shipto
         			                   scx_line
         			                   pod_pr_list
         			                   pod_pur_cost
         			                   pod_acct
         			                   pod_sub
         			                   pod_cc
         			                   pod_taxable
         			                   pod_taxc
         			                   pod_type
         			                   pod_cst_up
         			                   pod_loc
         			                   pod_um
         			                   pod_rev
         			                   pod_tax_usage
         			                   pod_tax_env
         			                   pod_tax_in
         			                   pod_um_conv
                                       pod_ers_opt
                                       pod_pr_lst_tp
         			                   pod_firm_days
         			                   pod_plan_days
         			                   pod_plan_weeks
         			                   pod_plan_mths
         			                   pod_fab_days
         			                   pod_raw_days
         			                   pod_translt_days
         			                   pod_sftylt_days
         			                   pod_vpart
         			                   pod_pkg_code
         			                   pod_sd_pat
         			                   pod_cum_qty[1]
         			                   pod_ord_mult
         			                   pod_cum_date[1]
         			                   m_podcmmts
         			                   pod_start_eff[1]
         			                   pod_end_eff[1]
                                       pod__qad05
                                       pod__qad07.
                    END. /* for each pod_Det */
               OUTPUT CLOSE.
