/*xxwctrex.p ---- Program to DownLoad Work Center Master (14.5) Eb                            */
/*COPYRIGHT JCI. INC ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.                        */
/*V8:ConvertMode=Report                                                                       */
/*V8:WebEnabled=No                                                                            */
/*V8:RunMode=Character,Windows                                                                */
/* This program Extracts the Work Center Master Data from Mfg/Pro EB  into  .CSV File         */
/**********************************************************************************************/
/* POCEDURE NAME            : xxwctrex.p                                                      */  
/* PROCEDURE TYPE           : Process                                                         */
/* DESCRIPTION              :                                                                 */
/* INCLUDE FILES            :                                                                 */
/* CALLED BY                :                                                                 */
/* CALLED PROCEDURES        :                                                                 */
/**********************************************************************************************/
/* CREATED BY               : MAHESH K (TCSL)                            DATE:06/06/2005      */
/* REVISION                 : 01          LAST  MODIFIED BY: Mahesh K    DATE:10/06/2005      */
/**********************************************************************************************/


               {mfdtitle.i}


               &SCOPED-DEFINE xxwctrex_p_1  "Extraction File Name"
               &SCOPED-DEFINE xxwctrex_p_2  "ERROR: Blank Filename Not Allowed"   

               /* Variable Declaration */
               DEFINE VARIABLE m_filename AS CHARACTER FORMAT "x(40)" NO-UNDO.

               /* form Definition */
               FORM
               SKIP(1)
               m_filename VALIDATE( m_filename <> "", {&xxwctrex_p_2}) LABEL {&xxwctrex_p_1}
               WITH FRAME a SIDE-LABELS TITLE "Work Center Master Extraction" WIDTH 80.

               {pxmsg.i &MSGNUM = 9000 &ERRORLEVEL = 1}

               /*Accepting File Name */
               UPDATE m_filename  WITH FRAME a.

               /*Extracting the Data into the File */
               OUTPUT TO VALUE(m_filename).
                  FOR EACH wc_mstr NO-LOCK:
                       EXPORT DELIMITER ","
                            wc_wkctr
                            wc_mch
                            wc_desc
                            wc_dept
                            wc_queue
                            wc_wait
                            wc_mch_op
                            wc_setup_men
                            wc_men_mch
                            wc_mch_wkctr
                            wc_mch_bdn
                            wc_setup_rte
                            wc_lbr_rate
                            wc_bdn_rate
                            wc_bdn_pct.
                  END. /* for each wc_mstr*/
             OUTPUT CLOSE.
