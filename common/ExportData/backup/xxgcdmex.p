/*xxgcdmex.p ---- Program to DownLoad Generallized Code Master (36.2.13) Eb                   */
/*COPYRIGHT JCI. INC ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.                        */
/*V8:ConvertMode=Report                                                                       */
/*V8:WebEnabled=No                                                                            */
/*V8:RunMode=Character,Windows                                                                */
/* This program Extracts the Generallized Code Master Data from Mfg/Pro EB  into  .CSV File   */
/**********************************************************************************************/
/* POCEDURE  NAME           : xxgcdmex.p                                                      */
/* PROCEDURE TYPE           : Process                                                         */
/* DESCRIPTION              :                                                                 */
/* INCLUDE FILES            :                                                                 */
/* CALLED BY                :                                                                 */
/* CALLED PROCEDURES        :                                                                 */
/**********************************************************************************************/
/* CREATED BY               : MAHESH K (TCSL)                            DATE:02/06/2005      */
/* REVISION                 : 01            LAST  MODIFIED BY: Mahesh K  DATE:10/06/2005      */
/**********************************************************************************************/


               {mfdtitle.i}

               &SCOPED-DEFINE xxgcdmex_p_1  "Extraction File Name"
               &SCOPED-DEFINE xxgcdmex_p_2  "ERROR: Blank Filename Not Allowed"   

               /* Variable Declaration */
               DEFINE VARIABLE m_filename AS CHARACTER FORMAT "x(40)" NO-UNDO.

               /* form Definition */
               FORM
               SKIP(1)
               m_filename VALIDATE( m_filename <> "", {&xxgcdmex_p_2} ) LABEL {&xxgcdmex_p_1}
               WITH FRAME a SIDE-LABELS TITLE "Generallised Code Master Extraction" WIDTH 80.

               {pxmsg.i &MSGNUM = 9000 &ERRORLEVEL = 1}

               /*Accepting File Name */
               UPDATE m_filename  WITH FRAME a.

               /*Extracting the Data into the File */
               OUTPUT TO VALUE(m_filename).
               FOR EACH code_mstr NO-LOCK:
                   EXPORT DELIMITER ","
                         code_fldname
                         code_value
                         code_cmmt.
               END. /* for each code_mstr */
               OUTPUT CLOSE.
