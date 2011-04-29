/* rcsqps.p - PROGRAM TO PRINT SEQUENCE SCHED RANGES ON AN INVOICE      */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*V8:ConvertMode=Report                                                 */
/*V8:RunMode=Character,Windows                                          */
/* REVISION: 9.1   CREATED       : 07/30/99     BY: *N003* Steve Nugent */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 05/02/00 BY: *N09M* Inna Lyubarsky */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00 BY: *N0KP* myb              */
/* $Revision: 1.13 $ BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00K* */
/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 100726.1  By: Roger Xiao */
/*-Revision end---------------------------------------------------------------*/



/*                                                                          */
/* -----  W A R N I N G  -----  W A R N I N G  -----  W A R N I N G  -----  */
/*                                                                          */
/*         THIS PROGRAM IS A BOLT-ON TO STANDARD PRODUCT MFG/PRO.           */
/* ANY CHANGES TO THIS PROGRAM MUST BE PLACED ON A SEPARATE ECO THAN        */
/* STANDARD PRODUCT CHANGES.  FAILURE TO DO THIS CAUSES THE BOLT-ON CODE TO */
/* BE COMBINED WITH STANDARD PRODUCT AND RESULTS IN PATCH DELIVERY FAILURES.*/
/*                                                                          */
/* -----  W A R N I N G  -----  W A R N I N G  -----  W A R N I N G  -----  */
/*                                                                          */
          {mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

 /* ********** Begin Translatable Strings Definitions ********** */
/*N09M* --- DELETED TRANSLATABLE STRINGS DEFINITIONS ------------*
* &SCOPED-DEFINE rcsqps_p_1 "Sequence Ranges"
*  /* Maxlen: 30 Comment: */
*
* &SCOPED-DEFINE rcsqps_p_2 "Customer Job: "
* /* Maxlen: 30 Comment: */
* ---------------------------------------------------------------*/

 /* ********** End Translatable Strings Definitions ********** */

          define input parameter l_inv_nbr like so_inv_nbr no-undo.
          define shared variable sonbr like sod_nbr.
          define shared variable soline like sod_line.
          define shared variable sopart like sod_part.
          define variable v_par_string like abs_par_id no-undo.

          /* ADD FOLLOWING TABLES TO PRINT CUSTOMER SEQUENCES */

          define new shared temp-table t_abss_det no-undo
            field t_abss_ship_id like abss_ship_id
            field t_abss_from_cust_job like abss_cust_job
            field t_abss_from_cust_seq like abss_cust_seq
            field t_abss_to_cust_job like abss_cust_job
            field t_abss_to_cust_seq like abss_cust_seq.

          /* FORM FOR CUSTOMER SEQUENCE RANGES */

          form
            t_abss_from_cust_seq  at 10
            t_abss_to_cust_seq    label {t001.i}
            with down frame seq2 width 80
            title color normal (getFrameTitle("SEQUENCE_RANGES",20)).

            /* SET EXTERNAL LABELS */
            setFrameLabels(frame seq2:handle).

          for first so_mstr  where so_mstr.so_domain = global_domain and
          so_nbr = sonbr no-lock: end.
          for first rcf_ctrl  where rcf_ctrl.rcf_domain = global_domain
          no-lock: end.

          /* CHECK TO SEE IF SEQUENCE SHOULD PRINT ON INVOICE */
          for first rcc_mstr  where rcc_mstr.rcc_domain = global_domain and
            rcc_addr = so_ship no-lock: end.

          if available rcc_mstr and rcc_invoice_print
                    or
            (not available rcc_mstr and
                 available rcf_ctrl and
                 rcf_invoice_print) then do:

                        /* GET SEQUENCE SCHEDULE DATA */
                        {gprun.i ""rcsqprt.p""
                                 "(input '', input l_inv_nbr)"}

                        /* PRINTING THE SEQUENCE RANGE */
                        for each t_abss_det
                            break by t_abss_ship_id
                                  by t_abss_from_cust_job:

                            {&PAGEBREAK}

                            if first-of(t_abss_from_cust_job) and
                            t_abss_from_cust_job <> "" then
/*N09M                        put {&rcsqps_p_2} at 5 */
/* SS - 100726.1 - B 
                  put {gplblfmt.i
                  &FUNC=getTermLabel(""CUSTOMER_JOB"",16)
                  &CONCAT="': '"
                  } at 5
                                  t_abss_from_cust_job.

                            display
                               t_abss_from_cust_seq
                               t_abss_to_cust_seq
                               with frame seq2.
                               down with frame seq2.
   SS - 100726.1 - E */

                        end. /* FOR EACH t_abss_det */

                        /* DELETE THE WORKFILES */
                        for each t_abss_det exclusive-lock:
                            delete t_abss_det.
                        end.

          end.  /* if available rcc_mstr and rcc_invoice_print  */
