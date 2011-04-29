/* popodel.p - PURCHASE ORDER MAINTENANCE SUBROUTINE                    */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*V8:ConvertMode=Maintenance                                            */
/* $Revision: 1.3 $                                                         */

/* REVISION: 8.5          CREATED: 10/29/99    BY: *J39R* Reetu Kapoor  */
/* $Revision: 1.3 $  BY: Julie Milligan        DATE: 03/26/00  ECO: *N059*  */
/* REVISION: 9.1    LAST MODIFIED: 08/17/00    BY: *N0LJ* Mark Brown        */

         {mfdeclre.i}

         define input parameter l_pod_req_nbr  like pod_req_nbr  no-undo.
         define input parameter l_pod_req_line like pod_req_line no-undo.
         define input parameter pOpenRequisitionResponse as logical no-undo.

         define variable l_yn  like mfc_logical no-undo.
         define variable yn    like mfc_logical no-undo.

         /** REOPENING A CLOSED REQ AND OR REQ LINE WHEN A  **/
         /** PO REFERENCING A REQ IS DELETED                **/

         find rqd_det
            where rqd_nbr    = l_pod_req_nbr
              and rqd_line   = l_pod_req_line
              and rqd_status = "c" exclusive-lock no-error.
         if available rqd_det then
         do:
            find rqm_mstr
               where rqm_nbr = l_pod_req_nbr exclusive-lock no-error.
            if available rqm_mstr then
            do:
/******************
               /*IF IN API MODE, DON'T ASK THE QUESTION, JUST PROVIDE */
               /* THE RESPONSE VIA THE INPUT PARAMETER                */
               /* pOpenRequisitionResponse                            */
               if c-application-mode = 'API' then do:
                  yn = pOpenRequisitionResponse.
               end.
               else do:
                  if l_yn = no then
                  do:
                     yn = yes.
                     /* REQ AND/OR REQ LINE CLOSED OR CANCELLED - REOPEN? */
                     {mfmsg01.i 3327 1 yn}
                     l_yn  = yes.
                  end. /* IF L_YN = NO */
               end.

               if yn then do:
                  assign rqd_status = ""
                         rqd_open   = true
                         rqm_status = ""
                         rqm_open   = true.
               end. /* IF YN THEN */
*************/
  assign rqd_status = ""
         rqd_open   = true
         rqm_status = ""
         rqm_open   = true.


            end. /* IF AVAILABLE RQM_MSTR */
         end. /* IF AVAILABLE RQD_DET */
