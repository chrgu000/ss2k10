/*xxromtex.p ---- Program to DownLoad Routing Code Master (14.13.1) - Eb                      */
/*COPYRIGHT JCI. INC ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.                        */
/*V8:ConvertMode=Report                                                                       */
/*V8:WebEnabled=No                                                                            */
/*V8:RunMode=Character,Windows                                                                */
/* This program Extracts the Routing  Master Data from Mfg/Pro EB  into  .CSV File            */
/**********************************************************************************************/
/* POCEDURE NAME            : xxromtex.p                                                      */              
/* PROCEDURE TYPE           : Process                                                         */
/* DESCRIPTION              :                                                                 */
/* INCLUDE FILES            :                                                                 */
/* CALLED BY                :                                                                 */
/* CALLED PROCEDURES        :                                                                 */
/**********************************************************************************************/
/* CREATED BY               : SACHIN P (TCSL)                            DATE:06/06/2005      */
/* REVISION                 : 01          LAST  MODIFIED BY: Sachin P    DATE:10/06/2005      */
/* REVISION                 : 02          LAST  MODIFIED BY: Mahesh K    DATE:13/06/2005      */
/**********************************************************************************************/



        {mfdtitle.i}

        &SCOPED-DEFINE xxromtex_p_1  "Extraction File Name"
        &SCOPED-DEFINE xxromtex_p_2  "ERROR: Blank Filename Not Allowed"   

        /* Variable Declaration */
        DEFINE VARIABLE m_filename AS CHARACTER FORMAT "x(40)" NO-UNDO.
        DEFINE VARIABLE cmt-yn     AS LOGICAL   NO-UNDO.


        /* Form Definition */
        FORM
           SKIP(1)
           m_filename VALIDATE( m_filename <> "", {&xxromtex_p_2} ) LABEL {&xxromtex_p_1}
        WITH FRAME a SIDE-LABELS TITLE "Routing Code Extraction" WIDTH 80.

        {pxmsg.i &MSGNUM = 9000 &ERRORLEVEL = 1}


        /*Accepting the File Name */
        UPDATE m_filename  WITH FRAME a.

        /* Extracting the Data into the File */
        OUTPUT TO VALUE(m_filename).
           FOR EACH ro_det NO-LOCK : 
              /* EACH opm_mstr WHERE opm_std_op = ro_std_op NO-LOCK :  for KOREA */

               FIND FIRST cd_det WHERE cd_ref = string(ro_op) /*opm_std_op*/ NO-LOCK NO-ERROR.
               IF AVAILABLE cd_det THEN cmt-yn = YES.
               ELSE cmt-yn = NO.

               EXPORT DELIMITER ","
                       ro_routing
                       ro_op
                       ro_start
                       ro_std_op
                       ro_wkctr
                       ro_mch
                       ro_desc
                       ro_mch_op
                       ro_tran_qty
                       ro_queue
                       ro_wait
                       ro_milestone
                       ro_sub_lead
                       ro_setup_men
                       ro_men_mch
                       ro_setup
                       ro_run
                       ro_move
                       ro_start
                       ro_end
                       ro_yield_pct
                       ro_tool
                       ro_vend
                       ro_inv_value
                       ro_sub_cost
                       cmt-yn
                       ro_wipmtl_part
                       ro_po_nbr
                       ro_po_line
                       ro_mv_nxt_op
                       ro_auto_lbr.
           
           END. /* For Each rsn_ref */
        OUTPUT CLOSE.
