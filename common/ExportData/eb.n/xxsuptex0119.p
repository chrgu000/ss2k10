/*xxsuptex.p ---- Program to DownLoad Supplier Item Master (1.19) -     Eb                    */
/*COPYRIGHT JCI. INC ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.                        */
/*V8:ConvertMode=Report                                                                       */
/*V8:WebEnabled=No                                                                            */
/*V8:RunMode=Character,Windows                                                                */
/*This program Extracts the Supplier Item Master from Mfg/Pro EB  into  .CSV File             */
/**********************************************************************************************/
/* PROCEDURE NAME           : xxsuptex.p                                                      */
/* PROCEDURE TYPE           : Process                                                         */
/* DESCRIPTION              :                                                                 */
/* INCLUDE FILES            :                                                                 */
/* CALLED BY                :                                                                 */
/* CALLED PROCEDURES        :                                                                 */
/**********************************************************************************************/
/* CREATED BY               : Mahesh K (TCSL)                            DATE:10/06/2005      */
/* REVISION                 : 01          LAST  MODIFIED BY: Mahesh K    DATE:10/06/2005      */
/**********************************************************************************************/


        {mfdtitle.i}

        &SCOPED-DEFINE xxsuptex_p_1  "Extraction File Name"
        &SCOPED-DEFINE xxsuptex_p_2  "ERROR: Blank Filename Not Allowed"   
               
      
        /* Variable Declaration */
        DEFINE VARIABLE m_filename AS CHARACTER FORMAT "x(40)" NO-UNDO.

        /* Form Definition */
        FORM
           SKIP(1)
           m_filename VALIDATE( m_filename <> "",{&xxsuptex_p_2} ) LABEL {&xxsuptex_p_1}
        WITH FRAME a SIDE-LABELS TITLE "Supplier Item Extraction" WIDTH 80.

        {pxmsg.i &MSGNUM = 9000 &ERRORLEVEL = 1}

        /*Accepting the File Name */
        UPDATE m_filename  WITH FRAME a.

        /* Extracting the Data into the File */
        OUTPUT TO VALUE(m_filename).
          EXPORT DELIMITER ","
 "vp_part"	 "vp_vend"	 "vp_vend_part"	 "vp_um"	 "vp_vend_lead"	 "vp_tp_use_pct"	 "vp_tp_pct"	 "vp_curr"	 "vp_q_price"	 "vp_q_date"	 "vp_q_qty"	 "vp_pr_list"	 "vp_mfgr"	 "vp_mfgr_part"	 "vp_comment."

          .
           FOR EACH vp_mstr NO-LOCK : 
                  EXPORT DELIMITER ","
                          vp_part
                          vp_vend
                          vp_vend_part
                          vp_um
                          vp_vend_lead
                          vp_tp_use_pct
                          vp_tp_pct
                          vp_curr
                          vp_q_price
                          vp_q_date
                          vp_q_qty
                          vp_pr_list
                          vp_mfgr
                          vp_mfgr_part
                          vp_comment.
           END. /* For Each vp_mstr */
        OUTPUT CLOSE.
