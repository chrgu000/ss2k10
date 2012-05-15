/*xxempmex.p ---- Program to DownLoad Employee  Master (2.7.1)-    Eb                         */
/*COPYRIGHT JCI. INC ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.                        */
/*V8:ConvertMode=Report                                                                       */
/*V8:WebEnabled=No                                                                            */
/*V8:RunMode=Character,Windows                                                                */
/* This program Extracts the Employee Master Data from Mfg/Pro EB  into  .CSV File            */
/**********************************************************************************************/
/* PROCEDURE NAME           : xxempmex.p                                                      */
/* PROCEDURE TYPE           : Process                                                         */
/* DESCRIPTION              :                                                                 */
/* INCLUDE FILES            :                                                                 */
/* CALLED BY                :                                                                 */
/* CALLED PROCEDURES        :                                                                 */
/**********************************************************************************************/
/* CREATED BY               : MAHESH K (TCSL)                            DATE:06/06/2005      */
/* REVISION                 : 01          LAST  MODIFIED BY: Mahesh K    DATE:10/06/2005      */
/* REVISION                 : 02          LAST  MODIFIED BY: Mahesh K    DATE:13/06/2005      */
/* REVISION                 : 03          LAST  MODIFIED BY: Sachin P    DATE:13/07/2005      */ 
/*                          : ECO# SP001 Modified for Eb version Compatibility                */       
/**********************************************************************************************/



               {mfdtitle.i}

               &SCOPED-DEFINE xxempmex_p_1  "Extraction File Name"
               &SCOPED-DEFINE xxempmex_p_2  "ERROR: Blank Filename Not Allowed"   


               /* Variable Declaration */
               DEFINE VARIABLE m_filename AS CHARACTER FORMAT "x(40)" NO-UNDO.

               /* form Definition */
               FORM
               SKIP(1)
               m_filename VALIDATE( m_filename <> "", {&xxempmex_p_2}) LABEL {&xxempmex_p_1}
               WITH FRAME a SIDE-LABELS TITLE "Employee Master Extraction" WIDTH 80.

               {pxmsg.i &MSGNUM = 9000 &ERRORLEVEL = 1}

               /*Accepting File Name */
               UPDATE m_filename  WITH FRAME a.

               /*Extracting the Data into the File */
               OUTPUT TO VALUE(m_filename).
                   EXPORT DELIMITER ","
 "emp_addr"	 "emp_lname"	 "emp_fname"	 "emp_line1"	 "emp_line2"	 "emp_line3"	 "emp_city"	 "emp_state"	 "emp_zip"	 "emp_country"	 "emp_phone"	 "emp_bs_phone"	 "emp_ext"	 "emp_ssn"	 "emp_birthday"	 "emp_title"	 "emp_emp_date"	 "emp_trm_date"	 "emp_dept"	 "emp_project"	 "emp_status."

               .
               FOR EACH emp_mstr NO-LOCK:
                   EXPORT DELIMITER ","
                          emp_addr
                          emp_lname
                          emp_fname
                          emp_line1
                          emp_line2
                          emp_line3
                          emp_city
                          emp_state
                          emp_zip
 /*SP001*/                emp_country  /* emp_ctry */
                          emp_phone
                          emp_bs_phone
                          emp_ext
                          emp_ssn
                          emp_birthday
                          emp_title
                          emp_emp_date
                          emp_trm_date
                          emp_dept
                          emp_project
                          emp_status.
               END. /* for each emp_mstr */
               OUTPUT CLOSE.
