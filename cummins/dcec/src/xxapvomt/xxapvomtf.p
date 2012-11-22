/* apvomtf.p - AP VOUCHER MAINTENANCE SUBPROGRAM                            */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/* $Revision: 1.5.1.10 $                                                       */
/*V8:ConvertMode=Maintenance                                                */
/* REVISION: 7.3            CREATED: 02/24/93   BY: JMS  *G698*             */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane        */
/*                    DATE MODIFIED: 04/28/94   BY: srk  *FN75*             */
/*                                   08/24/94   BY: cpp  *GL39*             */
/*                                   09/91/94   BY: str  *FR59*             */
/*                                   01/05/95   BY: jzw  *F0D0*             */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan       */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan       */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B3* Michael Amaladhas  */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane     */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00 BY: *N0KK* jyn                  */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Old ECO marker removed, but no ECO header exists *G1XC*                    */
/* Revision: 1.5.1.5    BY: Mamata Samant        DATE: 03/19/02  ECO: *P04F*  */
/* Revision:      BY: Gnanasekar            DATE: 09/11/02  ECO: *N1PG*  */
/* Revision: 1.5.1.7    BY: Piotr Witkowicz      DATE: 03/17/03  ECO: *P0NP*  */
/* Revision: 1.5.1.8  BY: Orawan S. DATE: 04/21/03 ECO: *P0Q8* */
/* $Revision: 1.5.1.10 $ BY: Paul Donnelly (SB) DATE: 06/26/03 ECO: *Q00B* */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdeclre.i}
{cxcustom.i "APVOMTF.P"}
/* EXTERNAL LABEL INCLUDE */
{gplabel.i}
{&APVOMTF-P-TAG1}
{&APVOMTF-P-TAG6}
define shared variable batch             like ap_batch label "Batch".
define shared variable bactrl            like ba_ctrl.
define shared variable ba_recno          as   recid.
define shared variable first_vo_in_batch like mfc_logical.
define shared variable desc1             like bk_desc format "x(30)".
define        variable inbatch           like ba_batch no-undo.
define shared variable l_flag            like mfc_logical no-undo.
define shared frame a.

/* DEFINE FORM A */
{apvofma.i}

/* GET BATCH DATA */
do transaction:
   view frame a.

   status input.
   assign
      bactrl = 0
      batch = "".
   set batch with frame a.
   if batch <> ""
   then do:
      {&APVOMTF-P-TAG4}
      for first ba_mstr
         fields( ba_domain ba_batch ba_ctrl ba_doc_type ba_module ba_total)
          where ba_mstr.ba_domain = global_domain and  ba_batch  = batch
           and ba_module = "AP"
      no-lock :
      {&APVOMTF-P-TAG5}
         bactrl = ba_ctrl.
      end. /* FOR FIRST ba_mstr */
      {&APVOMTF-P-TAG2}
      {&APVOMTF-P-TAG8}
      inbatch = batch.
      {gprun.i ""gpgetbat.p""
         "(input  inbatch,   /*IN-BATCH #     */
           input  ""AP"",    /*MODULE         */
           input  ""VO"",    /*DOC TYPE       */
           input  bactrl,    /*CONTROL AMT    */
           output ba_recno,  /*NEW BATCH RECID*/
           output batch)"}   /*NEW BATCH  #   */

      {&APVOMTF-P-TAG3}
      {&APVOMTF-P-TAG7}
      display batch bactrl with frame a.
      for first ap_mstr
         fields( ap_domain ap_amt ap_batch ap_type)
          where ap_mstr.ap_domain = global_domain and  ap_batch = batch
      no-lock:
      end. /* FOR FIRST ap_mstr */
      if  available ap_mstr
      and ap_type <> "VO"
      then do:
         /* NOT A VALID BATCH */
         {pxmsg.i &MSGNUM=1170 &ERRORLEVEL=3}

         /* IF AN ERROR IS ENCOUNTERED IN BATCH MODE l_flag IS SET TO true */
         if batchrun
         then
            l_flag = true.

         pause.
         next-prompt batch with frame a.
         undo, retry.
      end. /* IF AVAILABLE ap_mstr AND ... */
      find ba_mstr
          where ba_mstr.ba_domain = global_domain and  ba_batch  = batch
           and ba_module = "AP"
      exclusive-lock no-error.
      if available ba_mstr
      then do:
         if ba_doc_type <> "VO"
         then do:
            /* NOT A VALID BATCH */
            {pxmsg.i &MSGNUM=1170 &ERRORLEVEL=3}

            if batchrun
            then
               l_flag = true.

            pause.
            next-prompt batch with frame a.
            undo, retry.
         end. /* IF ba_doc_type <> "VO" */
         else do:
            assign
               bactrl = ba_ctrl
               /*INSURE BATCH TOTAL = SUM OF VOUCHERS*/
               ba_total = 0.
            for each ap_mstr
               fields( ap_domain ap_amt ap_batch ap_type)
                where ap_mstr.ap_domain = global_domain and  ap_batch = ba_batch
            no-lock:
               ba_total = ba_total + ap_amt.
            end. /* FOR EACH ap_mstr */
            display ba_total with frame a.
         end. /* IF ba_doc_type <> "VO" ELSE */
      end. /* IF available ba_mstr */
      else
         display 0 @ ba_total with frame a.
   end. /* IF batch <> " " */
   else
      display 0 @ bactrl 0 @ ba_total with frame a.

   if batchrun
   then
      l_flag = true.

   update bactrl with frame a.

   /* IF NO ERROR IS ENCOUNTERED IN BATCH MODE SET l_flag TO false */
   if batchrun
   then
      l_flag = false.

   ba_recno = 0.
   if available ba_mstr
   then
      assign
         ba_ctrl  = bactrl
         ba_recno = recid(ba_mstr).

   assign
      first_vo_in_batch = yes
      desc1 = "".
end. /* TRANSACTION */
