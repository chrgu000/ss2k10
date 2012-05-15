/*xxptplex.p ---- Program to DownLoad Item Planning Data  Master (1.4.7) - Eb                 */
/*COPYRIGHT JCI. INC ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.                        */
/*V8:ConvertMode=Report                                                                       */
/*V8:WebEnabled=No                                                                            */
/*V8:RunMode=Character,Windows                                                                */
/*This program Extracts the Item Planning Data from Mfg/Pro EB  into  .CSV File               */
/**********************************************************************************************/
/* PROCEDURE NAME           : xxptplex.p                                                      */
/* PROCEDURE TYPE           : Process                                                         */
/* DESCRIPTION              :                                                                 */
/* INCLUDE FILES            :                                                                 */
/* CALLED BY                :                                                                 */
/* CALLED PROCEDURES        :                                                                 */
/**********************************************************************************************/
/* CREATED BY               : MAHESH K (TCSL)                            DATE:09/06/2005      */
/* REVISION                 : 01          LAST  MODIFIED BY: Mahesh K    DATE:10/06/2005      */
/* REVISION                 : 02          LAST  MODIFIED BY: Mahesh K    DATE:14/06/2005      */
/* REVISION                 : 03          LAST  MODIFIED BY: Mahesh K    DATE:16/06/2005      */
/* REVISION                 : 04          LAST  MODIFIED BY: Sachin P    DATE:13/07/2005      */ 
/*                          : ECO# SP001 Modified for Eb version Compatibility                */       
/* REVISION                 : 05          LAST  MODIFIED BY: Mahesh K    DATE:05/08/2005      */ 
/*                          : ECO# MK001 Modified for Eb version Compatibility                */       
/**********************************************************************************************/

               {mfdtitle.i}

               &SCOPED-DEFINE xxptplex_p_1  "Extraction File Name"
               &SCOPED-DEFINE xxptplex_p_2  "ERROR: Blank Filename Not Allowed"   

               /* Variable Declaration */
               DEFINE VARIABLE m_filename AS CHARACTER FORMAT "x(40)" NO-UNDO.
               DEFINE VARIABLE m_btbtype  AS CHAR FORMAT "X(8)"       NO-UNDO.
               DEFINE VARIABLE m_atpenf   AS CHAR FORMAT "x(8)"       NO-UNDO.

               /* form Definition */
               FORM
               SKIP(1)
               m_filename VALIDATE( m_filename <> "", {&xxptplex_p_2}) LABEL {&xxptplex_p_1}
               WITH FRAME a SIDE-LABELS TITLE "Item Planning Data Master Extraction" WIDTH 80.

               {pxmsg.i &MSGNUM = 9000 &ERRORLEVEL = 1}

               /*Accepting File Name */
               UPDATE m_filename  WITH FRAME a.

               /*Extracting the Data into the File */
               OUTPUT TO VALUE(m_filename).
               FOR EACH pt_mstr NO-LOCK :

                    
   /*SP001*/        /*IF  pt_atp_enforcement = "0" THEN m_atpenf = "NONE" .
                      ELSE IF pt_atp_enforcement = "1" THEN m_atpenf = "WARNING".
                     ELSE m_atpenf = "ERROR". */

   /*SP001*/        m_atpenf = "NONE" .

                    IF pt_btb_type = "01" THEN m_btbtype = "NON-EMT".
                    ELSE IF pt_btb_type = "02" THEN m_btbtype = "TRANSHIP".
                    ELSE m_btbtype = "DIR-SHIP".
                     
                    EXPORT DELIMITER ","
                               pt_part
                               pt_ms
                               pt_plan_ord
                               pt_timefence
                               pt_ord_pol
                               pt_ord_qty
                               pt_ord_per
                               pt_sfty_stk
                               pt_sfty_time
                               pt_rop
                               pt_rev
                               pt_iss_pol
                               pt_buyer
                               pt_vend
                               pt_po_site
                               pt_pm_code
                               pt_cfg_type 
                               pt_insp_rqd
                               pt_insp_lead
                               pt_mfg_lead
                               pt_pur_lead
                               m_atpenf
  /* MK001 */                  "no"   /* pt_atp_family*/
                               pt_run_seq1
                               pt_run_seq2
                               pt_phantom
                               pt_ord_min
                               pt_ord_max
                               pt_ord_mult
                               pt_op_yield
                               pt_yield_pct
                               pt_run
                               pt_setup
                               m_btbtype
                               pt__qad15
                               pt_network
                               pt_routing
                               pt_bom_code.
                 END. /* for each pt_mstr*/
               OUTPUT CLOSE.
