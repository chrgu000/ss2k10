/*xxbomex.p ---- Program to DownLoad Product Structure (13.5) Eb                              */
/*COPYRIGHT JCI. INC ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.                        */
/*V8:ConvertMode=Report                                                                       */
/*V8:WebEnabled=No                                                                            */
/*V8:RunMode=Character,Windows                                                                */
/*This program Extracts the Product Structure Data from Mfg/Pro EB into  .CSV File            */
/**********************************************************************************************/
/* PROCEDURE NAME           : xxbomex.p                                                       */
/* PROCEDURE TYPE           : Process                                                         */
/* DESCRIPTION              :                                                                 */
/* INCLUDE FILES            :                                                                 */
/* CALLED BY                :                                                                 */
/* CALLED PROCEDURES        :                                                                 */
/**********************************************************************************************/
/* CREATED BY               : MAHESH K (TCSL)                            DATE:09/06/2005      */
/* REVISION                 : 01          LAST  MODIFIED BY: Mahesh K    DATE:10/06/2005      */
/**********************************************************************************************/


        {mfdtitle.i}

        &SCOPED-DEFINE xxbomex_p_1  "Extraction File Name"
        &SCOPED-DEFINE xxbomex_p_2  "ERROR: Blank Filename Not Allowed"   
       

        /* Variable Declaration */
        DEFINE VARIABLE m_filename AS CHARACTER FORMAT "x(40)" NO-UNDO.

        /* Form Definition */
        FORM
           SKIP(1)
           m_filename VALIDATE( m_filename <> "", {&xxbomex_p_2} )  LABEL {&xxbomex_p_1}
        WITH FRAME a SIDE-LABELS TITLE "Product Structure / Bom Extraction" WIDTH 80.

        {pxmsg.i &MSGNUM = 9000 &ERRORLEVEL = 1}

        /*Accepting the File Name */
        UPDATE m_filename  WITH FRAME a.

        /* Extracting the Data into the File */
        OUTPUT TO VALUE(m_filename).
           FOR EACH ps_mstr NO-LOCK : 
               
                  EXPORT DELIMITER ","
                          ps_par
                          ps_comp
                          ps_ref
                          ps_start
                          ps_qty_per
                          ps_ps_code
                          ps_start
                          ps_end
                          ps_rmks
                          ps_scrp_pct
                          ps_lt_off
                          ps_op
                          ps_item_no
                          ps_fcst_pct
                          ps_group
                          ps_process.
                            
           END. /* For Each ps_mstr */
        OUTPUT CLOSE.
