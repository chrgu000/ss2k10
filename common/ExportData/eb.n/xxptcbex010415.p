/*xxptcbex.p ---- Program to DownLoad Item Element Cost Batch Load (1.4.15) Eb                */
/*COPYRIGHT JCI. INC ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.                        */
/*V8:ConvertMode=Report                                                                       */
/*V8:WebEnabled=No                                                                            */
/*V8:RunMode=Character,Windows                                                                */
/* This program Extracts the Item Elment Cost  Data from Mfg/Pro EB  into  .CSV File          */
/**********************************************************************************************/
/* POCEDURE NAME            : xxptcbex.p                                                      */  
/* PROCEDURE TYPE           : Process                                                         */
/* DESCRIPTION              :                                                                 */
/* INCLUDE FILES            :                                                                 */
/* CALLED BY                :                                                                 */
/* CALLED PROCEDURES        :                                                                 */
/**********************************************************************************************/
/* CREATED BY               : MAHESH K (TCSL)                            DATE:09/06/2005      */
/* REVISION                 : 01          LAST  MODIFIED BY: Mahesh K    DATE:10/06/2005      */
/* REVISION                 : 02          LAST  MODIFIED BY: Mahesh K    DATE:14/06/2005      */
/**********************************************************************************************/


                {mfdtitle.i}
               
               &SCOPED-DEFINE xxptcbex_p_1  "Extraction File Name"
               &SCOPED-DEFINE xxptcbex_p_2  "ERROR: Blank Filename Not Allowed"   
               
               /* Variable Declaration */
               DEFINE VARIABLE m_filename AS CHARACTER FORMAT "X(40)" NO-UNDO.
               DEFINE VARIABLE m_init     AS LOGICAL                  NO-UNDO.

               /* form Definition */
               FORM
               SKIP(1)
               m_filename   VALIDATE( m_filename <> "",{&xxptcbex_p_2}) LABEL {&xxptcbex_p_1}
               WITH FRAME a SIDE-LABELS TITLE "Item Element Cost Batch Load Master Extraction"  WIDTH 80.

               {pxmsg.i &MSGNUM = 9000 &ERRORLEVEL = 1}

               /*Accepting File Name */
               UPDATE m_filename  WITH FRAME a.

               /*Extracting the Data into the File */
               ASSIGN m_init = yes.
               OUTPUT TO VALUE(m_filename).
	                      EXPORT DELIMITER ","
                "m_init"	 "spt_part"	 "spt_site"	 "spt_sim"	 "spt_element"	 "spt_cst_tl."

.

                  FOR EACH spt_det NO-LOCK :
                        EXPORT DELIMITER ","
                                   m_init 
                                   spt_part
                                   spt_site
                                   spt_sim
                                   spt_element
                                   spt_cst_tl.
                  END.
               OUTPUT CLOSE.
