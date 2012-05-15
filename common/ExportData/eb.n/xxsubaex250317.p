/*xxsubaex.p ---- Program to DownLoad Sub Account Master (25.3.17) Eb                         */
/*COPYRIGHT JCI. INC ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.                        */
/*V8:ConvertMode=Report                                                                       */
/*V8:WebEnabled=No                                                                            */
/*V8:RunMode=Character,Windows                                                                */
/* This program Extracts the Sub Account Master Data from Mfg/Pro EB  into  .CSV File         */
/**********************************************************************************************/
/* PROCEDURE NAME           : xxslacex.p                                                      */  
/* PROCEDURE TYPE           : Process                                                         */
/* DESCRIPTION              :                                                                 */
/* INCLUDE FILES            :                                                                 */
/* CALLED BY                :                                                                 */
/* CALLED PROCEDURES        :                                                                 */
/**********************************************************************************************/
/* CREATED BY               : MAHESH K (TCSL)                            DATE:01/06/2005      */
/* REVISION                 : 01           LAST  MODIFIED BY: Mahesk K   DATE:10/06/2005      */
/**********************************************************************************************/


               {mfdtitle.i}

               &SCOPED-DEFINE xxsubaex_p_1  "Extraction File Name"
               &SCOPED-DEFINE xxsubaex_p_2  "ERROR: Blank Filename Not Allowed"   

               /* Variable Declaration */
               DEFINE VARIABLE m_filename AS CHARACTER FORMAT "x(40)" NO-UNDO.

               /* form Definition */
               FORM
                    SKIP(1)
                    m_filename VALIDATE(m_filename <> "",{&xxsubaex_p_2}) LABEL {&xxsubaex_p_1}
               WITH FRAME a SIDE-LABELS TITLE "Sub Account Master Extraction" WIDTH 80.

               {pxmsg.i  &MSGNUM = 9000 &ERRORLEVEL = 1}
               
               
               /* Accepting File Name */
               UPDATE m_filename WITH FRAME a.

               
               /* Extracting the Data into the file */
               OUTPUT TO VALUE(m_filename).
   EXPORT DELIMITER ","
    "sb_sub"	 "sb_desc"	 "sb_active"	 "string(cr_code_begX(8))"	 "string(cr_code_endX(8))"

   .
               FOR EACH sb_mstr NO-LOCK ,
                  EACH cr_mstr NO-LOCK WHERE 
                       cr_code = sb_sub AND 
                       cr_type = "Sub_acct" :
                           EXPORT DELIMITER ","
                                 sb_sub
                                 sb_desc
                                 sb_active  
                                 string(cr_code_beg,"X(8)")
                                 string(cr_code_end,"X(8)").
               END. /* For Each sb_mstr */
               OUTPUT CLOSE.
