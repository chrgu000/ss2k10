/*xxfmpoex.p ---- Program to DownLoad Format Position Master (25.3.7) Eb                      */
/*COPYRIGHT JCI. INC ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.                        */
/*V8:ConvertMode=Report                                                                       */
/*V8:WebEnabled=No                                                                            */
/*V8:RunMode=Character,Windows                                                                */
/* This program Extracs the Format Position Master Data from Mfg/Pro EB  into  .CSV File      */
/**********************************************************************************************/
/* POCEDURE NAME             : xxfmpoex.p                                                     */
/* PROCEDURE TYPE           : Process                                                         */
/* DESCRIPTION              :                                                                 */
/* INCLUDE FILES            :                                                                 */
/* CALLED BY                :                                                                 */
/* CALLED PROCEDURES        :                                                                 */
/**********************************************************************************************/
/* CREATED BY               : MAHESH K (TCSL)                            DATE:01/06/2005      */
/* REVISION                 : 01            LAST  MODIFIED BY: Mahesk K  DATE:10/06/2005      */
/**********************************************************************************************/

               {mfdtitle.i}
               
               &SCOPED-DEFINE xxfmpoex_p_1  "Extraction File Name"
               &SCOPED-DEFINE xxfmpoex_p_2  "ERROR: Blank Filename Not Allowed"   
               
               /* Variable Declaration */
               DEFINE VARIABLE m_filename AS CHARACTER FORMAT "x(40)" NO-UNDO.

               /* form Definition */
               FORM
                 SKIP(1)
                 m_filename VALIDATE(m_filename <> " ",{&xxfmpoex_p_2})  LABEL {&xxfmpoex_p_1}
                 WITH FRAME a SIDE-LABELS TITLE "Format Position Master Extraction" WIDTH 80.

               {pxmsg.i &MSGNUM = 9000 &ERRORLEVEL = 1}

               /* Accepting FileName */ 
               UPDATE m_filename  WITH FRAME a.

               /*Extracting the Data into the file */
               OUTPUT TO VALUE(m_filename).
                  FOR EACH fm_mstr NO-LOCK :
                      EXPORT DELIMITER ","
                         fm_fpos
                         fm_desc
                         fm_sums_into  
                         fm_type
                         IF fm_dr_cr THEN "DR" ELSE "CR"
                         fm_sub_sort
                         fm_cc_sort
                         fm_page_brk
                         fm_header
                         fm_total
                         fm_skip
                         fm_underln.  
                  END. /* For Each fm_mstr */
                OUTPUT CLOSE.
