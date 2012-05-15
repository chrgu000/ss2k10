/*xxsop1ex.p ---- Program to DownLoad So Price List  Master (1.10.1.1) -    Eb                */
/*COPYRIGHT JCI. INC ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.                        */
/*V8:ConvertMode=Report                                                                       */
/*V8:WebEnabled=No                                                                            */
/*V8:RunMode=Character,Windows                                                                */
/* This program Extracts the So Price List  Master Data from Mfg/Pro EB  into  .CSV File      */
/* Parameters : Amount type   = List Price                                                    */              
/*              Qty type      = Amount                                                        */
/*              Comb Type     = Combinable                                                    */
/**********************************************************************************************/
/* PROCEDURE NAME           : xxsop1ex.p                                                      */
/* PROCEDURE TYPE           : Process                                                         */
/* DESCRIPTION              :                                                                 */
/* INCLUDE FILES            :                                                                 */
/* CALLED BY                :                                                                 */
/* CALLED PROCEDURES        :                                                                 */
/**********************************************************************************************/
/* CREATED BY               : MAHESH K (TCSL)                            DATE:07/06/2005      */
/* REVISION                 : 01          LAST  MODIFIED BY: Mahesh K    DATE:10/06/2005      */
/* REVISION                 : 02          LAST  MODIFIED BY: Mahesh K    DATE:13/06/2005      */
/**********************************************************************************************/




               {mfdtitle.i}

               &SCOPED-DEFINE xxsop1ex_p_1  "Extraction File Name"
               &SCOPED-DEFINE xxsop1ex_p_2  "ERROR: Blank Filename Not Allowed"   

               /* Variable Declaration */
               DEFINE VARIABLE m_filename AS CHARACTER FORMAT "x(40)" NO-UNDO.
               DEFINE VARIABLE m_cmtyn    AS LOGICAL                  NO-UNDO.


               /* form Definition */
               FORM
               SKIP(1)
               m_filename VALIDATE( m_filename <> "", {&xxsop1ex_p_2}) LABEL {&xxsop1ex_p_1}
               WITH FRAME a SIDE-LABELS TITLE "SO Price List Master Extraction(LAC)" WIDTH 80.

               {pxmsg.i &MSGNUM = 9000 &ERRORLEVEL = 1}

               /*Accepting File Name */
               UPDATE m_filename  WITH FRAME a.

               /*Extracting the Data into the File */
               OUTPUT TO VALUE(m_filename).
 EXPORT DELIMITER ","
  "pi_list"	 "pi_cs_code"	 "pi_part_code"	 "pi_curr"	 "pi_um"	 "pi_start"	 "pi_expire"	 "pi_desc"	 "pi_amt_type"	 "pi_qty_type"	 "pi_comb_type"	 "pi_min_net"	 "pi_max_qty"	 "pi_break_cat"	 "pi_confg"	 "pi_manual"	 "pi_max_ord"	 "pi_disc_seq"	 "pi_print"	 "m_cmtyn"	 "pi_list_price"	 "pi_min_price"	 "pi_max_price."

 .
               /*Amt  Type = List Price */
               /*Qty  Type = Amount    */
               /*Comb Type = Combinable*/

               FOR EACH pi_mstr  NO-LOCK WHERE
                       pi_amt_type  = "1" AND    
                       pi_qty_type  = "2" AND    
                       pi_comb_type = "2":       

                  FIND FIRST cmt_det WHERE cmt_ref  = pi_list AND 
                                           cmt_indx = pi_cmtindx NO-LOCK NO-ERROR.
                       IF AVAILABLE cmt_det THEN
                             m_cmtyn = YES.
                           ELSE
                             m_cmtyn = NO.
                          
                             EXPORT DELIMITER ","
                               pi_list
                               pi_cs_code
                               pi_part_code
                               pi_curr
                               pi_um
                               pi_start
                               pi_expire
                               pi_desc
                               pi_amt_type
                               pi_qty_type
                               pi_comb_type
                               pi_min_net
                               pi_max_qty
                               pi_break_cat
                               pi_confg
                               pi_manual
                               pi_max_ord
                               pi_disc_seq
                               pi_print
                               m_cmtyn
                               pi_list_price
                               pi_min_price
                               pi_max_price.
               END. /* for each pi_mstr */
               OUTPUT CLOSE.
