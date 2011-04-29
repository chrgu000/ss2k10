/* mrprapa1.p - Get Next GRS Requisition Number                             */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                       */
/*J34G*/ /*V8:RunMode=Character,Windows                                     */
/* REVISION: 8.5       LAST MODIFIED: 08/15/97  BY: *J1Q2* Patrick Rowan    */
/* REVISION: 8.5       LAST MODIFIED: 11/12/98  BY: *J34G* Alfred Tan       */
/* REVISION: 9.1       LAST MODIFIED: 08/13/00  BY: *N0KR* myb              */
/* $Revision: 1.8 $ BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00J* */




/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 090828.1  By: Roger Xiao */

/*-Revision end---------------------------------------------------------------*/



/*!
 ----------------------------------------------------------------------------
 DESCRIPTION: Bolt-on code to retrieve next GRS requisition number.
              Supports the Global Requisition Module of MFG/PRO (GRS).

 Notes:
 1) The requisition number is taken from the requisition control file.
 2) Output parameters
       {1} return code      {2} requisition number

 ============================================================================
 !*/
         {mfdeclre.i}

         /* PARAMETERS */
         define output parameter out_return_code as integer no-undo.
         define output parameter out_rqm_nbr   like rqm_mstr.rqm_nbr no-undo.
/* SS - 090828.1 - B */
         define output parameter out_rqf_pre   like rqf_ctrl.rqf_pre no-undo.
         define output parameter out_rqf_nbr   like rqf_ctrl.rqf_nbr no-undo.
/* SS - 090828.1 - E */

         /* VARIABLES */
     define variable rqmnbr         like rqm_mstr.rqm_nbr no-undo.



         /* INITIALIZATION */
     out_return_code = -1.
/* SS - 090828.1 - B */
out_rqf_pre = "" .
out_rqf_nbr = 1 .
/* SS - 090828.1 - E */

         {gprun.i ""rqpma.p""}
     find first rqf_ctrl  where rqf_ctrl.rqf_domain = global_domain no-lock.

         /* GET NEXT REQUISITION NUMBER */
     rqmnbr = "".

         /***********
         . {mfnctrlc.i rqf_ctrl rqf_pre rqf_nbr rqm_mstr rqm_nbr rqmnbr}
         ***********/



         /*BEGIN MFNCTRLC.I REPLACEMENT CODE.  THIS IS BECAUSE
     RQF_CTRL MAY EXIST IN A SIDE DATABASE WHICH CAUSED THE
     FIND OF _FIELD TO FAIL. WHEN THIS MODULE BECOMES FULLY
     STANDARD, MFNCTRLC.I ABOVE CAN BE REINSTATED.*/

         find first rqf_ctrl  where rqf_ctrl.rqf_domain = global_domain
         exclusive-lock.

         if length(rqf_pre) + length(string(rqf_nbr)) > 8 then
            rqf_nbr = 1.

         rqmnbr = rqf_pre + string(rqf_nbr).
 /* SS - 090828.1 - B */
out_rqf_pre = rqf_pre .
out_rqf_nbr = rqf_nbr .
 /* SS - 090828.1 - E */

         do while can-find(first rqm_mstr  where rqm_mstr.rqm_domain =
         global_domain and  rqm_nbr = rqmnbr):
            rqf_nbr = rqf_nbr + 1.

            if length(rqf_pre) + length(string(rqf_nbr)) > 8 then
               rqf_nbr = 1.

            rqmnbr = rqf_pre + string(rqf_nbr).
 /* SS - 090828.1 - B */
out_rqf_pre = rqf_pre .
out_rqf_nbr = rqf_nbr .
 /* SS - 090828.1 - E */
         end.

         rqf_nbr = rqf_nbr + 1.

         if length(rqf_pre) + length(string(rqf_nbr)) > 8 then
            rqf_nbr = 1.

         release rqf_ctrl.
     /*END MFNCTRLC.I REPLACEMENT CODE*/

         /* EXECUTION COMPLETE */
     out_rqm_nbr     = rqmnbr.
     out_return_code = 0.
