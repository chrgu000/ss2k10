/* poporca2.p - PO RECEIPT OF WORK ORDER SUBCONTRACT                    */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.14 $      */
/*V8:ConvertMode=Maintenance                                            */
/*V8:RunMode=Character,Windows                                          */
/* REVISION: 7.3     LAST MODIFIED: 04/19/93    BY: tjs *G964**/
/* REVISION: 7.4     LAST MODIFIED: 01/12/94    BY: qzl *H276**/
/* REVISION: 7.5     LAST MODIFIED: 08/09/94    BY: tjs *J014**/
/* REVISION: 7.3     LAST MODIFIED: 10/20/94    BY: dpm *FS27*          */
/* REVISION: 7.3     LAST MODIFIED: 11/17/94    BY: bcm *GO37*          */
/* REVISION: 8.5     LAST MODIFIED: 11/20/96    BY: *J191* Suresh Nayak */
/* REVISION: 9.0     LAST MODIFIED: 04/16/99    BY: *J2DG* Reetu Kappor */
/* Old ECO marker removed, but no ECO header exists *F0PN*               */
/* REVISION: 9.1      LAST MODIFIED: 07/05/00   BY: Strip/Beautify:  3.0 */
/* REVISION: 9.1      LAST MODIFIED: 06/15/00   BY: Zheng Huang *N0DK*   */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KQ* myb           */
/* $Revision: 1.14 $    BY: Dan Herman   DATE: 11/04/04  ECO: *M1V1*  */
/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 110112.1  By: Roger Xiao */  /* auto cimload woworc.p */
/*-Revision end---------------------------------------------------------------*/

/* GROUPED MULTIPLE FIELD ASSIGNMENTS INTO ONE AND ADDED NO-UNDO          */
/* WHEREVER MISSING AND REPLACED FIND STATEMENTS WITH FOR FIRST           */
/* STATEMENTS FOR ORACLE PERFORMANCE                                      */

{mfdeclre.i}
/* SEVERITY PREPROCESSOR CONSTANT DEFINITION INCLUDE FILE */
{pxmaint.i}

define shared variable wolot        like pod_wo_lot  no-undo.
define shared variable woop         like pod_op      no-undo.
define shared variable pod_recno    as   recid.
define shared variable rct_site     like pod_site.
define shared variable undo_all like mfc_logical.
define variable yn                  like mfc_logical no-undo.

define variable vWorkOrderLotExist  like mfc_logical no-undo.
define variable vWorkOrderRouteExist  like mfc_logical no-undo.

{mfaimfg.i}  /* Common API constants and variables */

{popoit01.i} /* Define API purchase order temp tables  */
{mfctit01.i} /* Define API transaction comments temp tables */

if c-application-mode = "API" then do:

   /* Get handle of API controller */
   {gprun.i ""gpaigh.p"" "(output ApiMethodHandle,
                           output ApiProgramName,
                           output ApiMethodName,
                           output ApiContextString)"}

   /* Get current purchase order transaction detail record */
   run getPurchaseOrderTransDetRecord in ApiMethodHandle
      (buffer ttPurchaseOrderTransDet).

end. /* IF c-application-mode = "API" */

/*MAIN-BEGIN*/
/*MAIN-END*/

/*@TO-DO  need find pod_det in control*/
find pod_det where recid(pod_det) = pod_recno exclusive-lock.
/*@TO-DOEND*/

{pxrun.i &PROC='processRead' &PROGRAM='wowoxr.p'
         &PARAM="(input  wolot,
                  buffer wo_mstr,
                  input  {&NO_LOCK_FLAG},
                  input  {&NO_WAIT_FLAG})"
         &NOAPPERROR=True
         &CATCHERROR=True
}

{pxrun.i &PROC='validateSubcontractWorkOrder' &PROGRAM='xxporcxr1x2.p'
         &PARAM="(buffer wo_mstr,
                  input  pod_part,
                  input  pod_project,
                  output vWorkOrderLotExist)"
         &NOAPPERROR=True
         &CATCHERROR=True
} /* SS - 110112.1 */

/* SS - 110112.1 - B 
if return-value <> {&SUCCESS-RESULT} and
   return-value <> {&WARNING-RESULT}
   SS - 110112.1 - E */
if return-value <> {&SUCCESS-RESULT}  /* SS - 110112.1 */
then do:
   undo_all = true.
   leave.
end.

if vWorkOrderLotExist then do:
   if index ("FPC",wo_status) = 0 then
      rct_site = wo_site.

   {pxrun.i &PROC='defaultSubcontractOperation' &PROGRAM='porcxr1.p'
            &PARAM="(input-output woop)"
            &NOAPPERROR=True
            &CATCHERROR=True
   }

   {pxrun.i &PROC='readOperationForFirstWOID' &PROGRAM='wowrxr.p'
            &PARAM="(input  wolot,
                     input  woop,
                     buffer wr_route,
                     input  {&NO_LOCK_FLAG},
                     input  {&NO_WAIT_FLAG})"
            &NOAPPERROR=True
            &CATCHERROR=True
   }

   {pxrun.i &PROC='validateSubcontractOperation' &PROGRAM='porcxr1.p'
            &PARAM="(buffer wr_route,
                     input  wo_status,
                     input  wo_type,
                     input  wo_nbr)"
            &NOAPPERROR=True
            &CATCHERROR=True
   }

   /*@TO-DO - controller will need to execute this function along with
   check against UI control flag*/ /*mxb*/
   /*@TO-DOEND*/

   if {pxfunct.i &FUNCTION='isSubcontractOperationMissing' &PROGRAM='wowrxr.p'
                 &PARAM="input (available wr_route),
                         input wo_status"
      } and
      not {pxfunct.i &FUNCTION='isRepetitiveProduction' &PROGRAM='rewoxr.p'
                     &PARAM="input wo_type,
                             input wo_nbr"
      }
   then do:
      yn = no.
      if c-application-mode = "API" then
         assign {mfaiset.i yn ttPurchaseOrderTransDet.addWoOperation}.

      /* MESSAGE #5422 - WO OPERATION DOES NOT EXIST, DO YOU WISH TO ADD */
      {pxmsg.i
         &MSGNUM=5422
         &ERRORLEVEL={&WARNING-RESULT}
         &CONFIRM=yn}
      if yn then do:
         {pxrun.i &PROC='createSubcontractOperation' &PROGRAM='wowrxr.p'
                  &PARAM="(buffer wo_mstr,
                           buffer wr_route,
                           input  woop)"
                  &NOAPPERROR=True
                  &CATCHERROR=True
         }
      end. /*if yn*/
   end.
end. /*else (if not vWorkOrderLotExist) do*/


{pxrun.i &PROC='setSubcontractOperation' &PROGRAM='porcxr1.p'
         &PARAM="(buffer pod_det,
                  input  wolot,
                  input  woop)"
         &NOAPPERROR=True
         &CATCHERROR=True
}
