/*xxcctrex.p  ---- Program to DownLoad Cost Center Master (25.3.20) Eb                        */
/*COPYRIGHT JCI. INC ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.                        */
/*V8:ConvertMode=Report                                                                       */
/*V8:WebEnabled=No                                                                            */
/*V8:RunMode=Character,Windows                                                                */
/* This program Extracts the Cost Center Master Data from Mfg/Pro EB2 into  .CSV File         */
/**********************************************************************************************/
/* PROCEDURE NAME           : xxcctrex.p                                                      */
/* PROCEDURE TYPE           : Process                                                         */
/* DESCRIPTION              :                                                                 */
/* INCLUDE FILES            :                                                                 */
/* CALLED BY                :                                                                 */
/* CALLED PROCEDURES        :                                                                 */
/**********************************************************************************************/
/* CREATED BY               : SACHIN P (TCSL)                            DATE:02/06/2005      */
/* REVISION                 : 01          LAST  MODIFIED BY: Sachin P    DATE:13/06/2005      */
/**********************************************************************************************/

        
        
        {mfdeclre.i}

        /* Scope Definitions */
        &SCOPED-DEFINE xxcctrex_p_1  "Extraction File Name"
        &SCOPED-DEFINE xxcctrex_p_2  "ERROR: Blank Filename Not Allowed"    

        /* Variable Declaration */
        DEFINE VARIABLE m_filename AS CHARACTER FORMAT "x(40)" NO-UNDO.

        /* Buffer Definition */
        DEFINE  buffer cr_mstr1 for cr_mstr.


        /* Temp-Table Definition */
        DEFINE TEMP-TABLE tt_cost_ctr
            FIELDS tt_ctr    LIKE cc_ctr
            FIELDS tt_desc   LIKE cc_desc
            FIELDS tt_active LIKE cc_active
            FIELDS tt_accbeg LIKE ar_acct
            FIELDS tt_accend LIKE ar_acct
            FIELDS tt_subbeg LIKE sb_sub
            FIELDS tt_subend LIKE sb_sub.

        
        /* Form Definition */
        FORM
           SKIP(1)
           m_filename VALIDATE( m_filename <> "",{&xxcctrex_p_2}) LABEL {&xxcctrex_p_1}
        WITH FRAME a SIDE-LABELS TITLE "Cost Center Master Extraction" WIDTH 80.

        {pxmsg.i &MSGNUM = 9000 &ERRORLEVEL = 1}

        /* Accepting the File Name */
        UPDATE m_filename  WITH FRAME a.

        
        FOR EACH cc_mstr  NO-LOCK :
                        
            FIND FIRST cr_mstr WHERE cr_mstr.cr_code = cc_ctr
                                 AND cr_mstr.cr_type = "CC_SUB"
            NO-LOCK NO-ERROR.

            FOR EACH cr_mstr1 WHERE cr_code = cc_ctr
                                AND cr_type = "CC_ACCT" NO-LOCK 
            BREAK BY cr_code:
                
             CREATE tt_cost_ctr.
                ASSIGN
                    tt_ctr = cr_code
                    tt_desc = cc_desc
                    tt_active = cc_active.
                 
            ASSIGN tt_accbeg = cr_mstr1.cr_code_beg.
                    IF (cr_mstr1.cr_code_end <> hi_char) THEN tt_accend = cr_mstr1.cr_code_end.
                    ELSE IF (cr_mstr1.cr_code_end = hi_char) THEN tt_accend = "".
                    IF AVAILABLE cr_mstr THEN tt_subbeg = cr_mstr.cr_code_beg.
                    IF (AVAILABLE cr_mstr and cr_mstr.cr_code_end <> hi_char) THEN  tt_subend = cr_mstr.cr_code_end.
                    IF (NOT AVAILABLE cr_mstr OR cr_mstr.cr_code_end = hi_char) THEN tt_subend = "".
                   
            
            FIND NEXT cr_mstr WHERE cr_mstr.cr_code = cc_ctr
                                AND cr_mstr.cr_type = "CC_SUB"
            NO-LOCK NO-ERROR.
            IF LAST-OF(cr_mstr1.cr_code) AND cr_mstr1.cr_type = "CC_ACCT"
            THEN 
               REPEAT:
                  IF AVAILABLE cr_mstr THEN DO:

                   
                    CREATE tt_cost_ctr.
                    ASSIGN
                        tt_ctr = cc_ctr
                        tt_desc = cc_desc
                        tt_active = cc_active.
                    
                
                   ASSIGN tt_accbeg  = "" 
                          tt_accend  = "".
                   IF (available cr_mstr) THEN tt_subbeg  = cr_mstr.cr_code_beg.
                   IF (available cr_mstr and cr_mstr.cr_code_end <> hi_char) THEN tt_subend  = cr_mstr.cr_code_end.
                   IF (not available cr_mstr OR cr_mstr.cr_code_end = hi_char) THEN tt_subend = "".
                         
                   
                   FIND NEXT cr_mstr WHERE cr_code = cc_ctr
                                       AND cr_type = "CC_SUB"
                   NO-LOCK NO-ERROR.
               END. /* repeat*/
               ELSE DO:
                 LEAVE.
               END.
            END. /* end of last-of */
        END. /* end of each cr_mstr1 */         
    END. /* end for each cc_mstr */

    /* Extracting Data into File */
    OUTPUT TO VALUE(m_filename).
       FOR EACH tt_cost_ctr WHERE tt_ctr <> "" NO-LOCK  :
           EXPORT DELIMITER "," tt_cost_ctr.
       END.
    OUTPUT CLOSE.

    

   
    

