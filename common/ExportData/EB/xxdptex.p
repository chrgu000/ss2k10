/*xxdptex.p  ---- Program to DownLoad dpt_mstr (14.1)  Eb                                     */
/*COPYRIGHT JCI. INC ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.                        */
/*V8:ConvertMode=Report                                                                       */
/*V8:WebEnabled=No                                                                            */
/*V8:RunMode=Character,Windows                                                                */
/* This program Extracts the Location Master Data from Mfg/Pro EB  into  .CSV File            */
/**********************************************************************************************/
/* PROCEDURE NAME           : xxdptex.p                                                       */          
/* PROCEDURE TYPE           : Process                                                         */
/* DESCRIPTION              :                                                                 */
/* INCLUDE FILES            :                                                                 */
/* CALLED BY                :                                                                 */
/* CALLED PROCEDURES        :                                                                 */
/**********************************************************************************************/
/* CREATED BY               : SACHIN P (TCSL)                            DATE:03/06/2005      */
/* REVISION                 : 01          LAST  MODIFIED BY: Sachin P    DATE:10/06/2005      */
/* REVISION                 : 03          LAST  MODIFIED BY: Sachin P    DATE:13/07/2005      */ 
/*                          : ECO# SP001 Modified for Eb version Compatibility                */       
/**********************************************************************************************/


        {mfdtitle.i}

        &SCOPED-DEFINE xxlocex_p_1  "Extraction File Name"
        &SCOPED-DEFINE xxlocex_p_2  "ERROR: Blank Filename Not Allowed"   


        /* Variable Declaration */
        DEFINE VARIABLE m_filename AS CHARACTER FORMAT "x(40)" NO-UNDO.

        /* Form Definition */
        FORM
           SKIP(1)
           m_filename VALIDATE( m_filename <> "", {&xxlocex_p_2} ) LABEL {&xxlocex_p_1}
        WITH FRAME a SIDE-LABELS TITLE "Location Master Extraction" WIDTH 80.

        {pxmsg.i &MSGNUM = 9000 &ERRORLEVEL = 1}

        /* Accepting the File Name */
        UPDATE m_filename  WITH FRAME a.

        /* Extracting the Data into the File */
        OUTPUT TO VALUE(m_filename).
           FOR EACH dpt_mstr NO-LOCK: 
                  EXPORT DELIMITER ","
                            dpt_dept
                            dpt_desc
                            dpt_lbr_cap
                            dpt_cop_acct
                            dpt_cop_sub
                            dpt_cop_cc
                            dpt_lbr_acct
                            dpt_lbr_sub
                            dpt_lbr_cc
                            dpt_bdn_acct
                            dpt_bdn_sub
                            dpt_bdn_cc
                            dpt_lvar_acct
                            dpt_lvar_sub
                            dpt_lvar_cc
                            dpt_lvrr_acct
                            dpt_lvrr_sub
                            dpt_lvrr_cc
                            dpt_bvar_acct
                            dpt_bvar_sub
                            dpt_bvar_cc
                            dpt_bvrr_acct
                            dpt_bvrr_sub
                            dpt_bvrr_cc.
           END. /* For Each loc_mstr */
        OUTPUT CLOSE.
