/*xxsiplex.p ---- Program to DownLoad Item Site Planning (1.4.17) -     Eb                    */
/*COPYRIGHT JCI. INC ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.                        */
/*V8:ConvertMode=Report                                                                       */
/*V8:WebEnabled=No                                                                            */
/*V8:RunMode=Character,Windows                                                                */
/*This program Extracts the Item Site Planning  Data from Mfg/Pro EB  into  .CSV File         */
/**********************************************************************************************/
/* PROCEDURE NAME           : xxsiplex.p                                                      */
/* PROCEDURE TYPE           : Process                                                         */
/* DESCRIPTION              :                                                                 */
/* INCLUDE FILES            :                                                                 */
/* CALLED BY                :                                                                 */
/* CALLED PROCEDURES        :                                                                 */
/**********************************************************************************************/
/* CREATED BY               : Sachin P (TCSL)                            DATE:09/06/2005      */
/* REVISION                 : 01          LAST  MODIFIED BY: Sachin P    DATE:10/06/2005      */
/* REVISION                 : 02          LAST  MODIFIED BY: Mahesh K    DATE:16/06/2005      */
/* REVISION                 : 03   *MK03* LAST  MODIFIED BY: Mahesh K    DATE:04/07/2005      */
/* REVISION                 : 04          LAST  MODIFIED BY: Sachin P    DATE:13/07/2005      */ 
/*                          : ECO# SP001 Modified for Eb version Compatibility                */       
/* REVISION                 : 05          LAST  MODIFIED BY: Mahesh K    DATE:05/08/2005      */ 
/*                          : ECO# MK001 Modified for Eb version Compatibility                */       
/**********************************************************************************************/


        {mfdtitle.i}

        &SCOPED-DEFINE xxsiplex_p_1  "Extraction File Name"
        &SCOPED-DEFINE xxsiplex_p_2  "ERROR: Blank Filename Not Allowed"   
        
            
            /* Variable Declaration */
        DEFINE VARIABLE m_filename AS CHARACTER FORMAT "x(40)" NO-UNDO.
        DEFINE VARIABLE m_config   AS CHARACTER FORMAT "x(3)"  NO-UNDO.
        DEFINE VARIABLE m_atpenf   AS CHARACTER FORMAT "x(8)"  NO-UNDO. 
        DEFINE VARIABLE m_btbtype  AS CHARACTER FORMAT "x(8)"  NO-UNDO. 

        /* Form Definition */
        FORM
           SKIP(1)
           m_filename VALIDATE( m_filename <> "", {&xxsiplex_p_2} )  LABEL {&xxsiplex_p_1}
        WITH FRAME a SIDE-LABELS TITLE "Item Site Planning Data Extraction" WIDTH 80.

       {pxmsg.i &MSGNUM = 9000 &ERRORLEVEL = 1}

        /*Accepting the File Name */
        UPDATE m_filename WITH FRAME a.
EXPORT DELIMITER ","
 "ptp_part"	 "ptp_site"	 "ptp_ms"	 "ptp_plan_ord"	 "ptp_timefnce"	 "ptp_ord_pol"	 "ptp_ord_qty"	 "ptp_ord_per"	 "ptp_sfty_stk"	 "ptp_sfty_tme"	 "ptp_rop"	 "ptp_rev"	 "ptp_iss_pol"	 "ptp_buyer"	 "ptp_vend"	 "ptp_po_site"	 "ptp_pm_code"	 "m_config"	 "ptp_ins_rqd"	 "ptp_ins_lead"	 "ptp_cum_lead"	 "ptp_mfg_lead"	 "ptp_pur_lead"	 "m_atpenf"	 "no"	 "ptp_run_seq1"	 "ptp_run_seq2"	 "ptp_phantom"	 "ptp_ord_min"	 "ptp_ord_max"	 "ptp_ord_mult"	 "ptp_op_yield"	 "ptp_yld_pct"	 "ptp_run"	 "ptp_setup"	 "m_btbtype"	 "pt__qad15"	 "ptp_network"	 "ptp_routing"	 "ptp_bom_code."

.
        /* Extracting the Data into the File */
        OUTPUT TO VALUE(m_filename).
           FOR EACH pt_mstr NO-LOCK ,
               EACH ptp_det WHERE ptp_part = pt_part NO-LOCK: 

                 IF ptp_pm_code = "C" THEN DO:
                    IF ptp_cfg_type = "1" THEN
                          m_config = "ATO".
                       ELSE 
                    IF ptp_cfg_type = "2"  THEN
                          m_config = "KIT".
                 END.
                 ELSE
                 m_config = ptp_cfg_type.                                                       /*MK03*/

 /*SP001*/ /*    IF ptp_atp_enforcement = "0" THEN m_atpenf = "NONE" .
                 ELSE IF ptp_atp_enforcement = "1" THEN m_atpenf = "WARNING".
                 ELSE m_atpenf = "ERROR". */

 /*SP001*/       m_atpenf = "NONE".

                 IF ptp_btb_type = "01" THEN m_btbtype = "NON-EMT".
                 ELSE IF ptp_btb_type = "02" THEN m_btbtype = "TRANSHIP".
                 ELSE m_btbtype = "DIR-SHIP".


                  EXPORT DELIMITER ","
                          ptp_part
                          ptp_site
                          ptp_ms
                          ptp_plan_ord
                          ptp_timefnce
                          ptp_ord_pol
                          ptp_ord_qty
                          ptp_ord_per
                          ptp_sfty_stk
                          ptp_sfty_tme
                          ptp_rop
                          ptp_rev
                          ptp_iss_pol
                          ptp_buyer
                          ptp_vend
                          ptp_po_site
                          ptp_pm_code
                          m_config 
                          ptp_ins_rqd
                          ptp_ins_lead
                          ptp_cum_lead
                          ptp_mfg_lead
                          ptp_pur_lead
                          m_atpenf
  /*MK001*/               "no"                     /* ptp_atp_family */
                          ptp_run_seq1
                          ptp_run_seq2
                          ptp_phantom
                          ptp_ord_min
                          ptp_ord_max
                          ptp_ord_mult
                          ptp_op_yield
                          ptp_yld_pct
                          ptp_run
                          ptp_setup
                          m_btbtype
                          pt__qad15
                          ptp_network
                          ptp_routing
                          ptp_bom_code.
           END. /* For Each pt_mstr */
        OUTPUT CLOSE.
