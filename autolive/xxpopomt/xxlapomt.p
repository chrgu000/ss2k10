/* lapomt.p - TERMS OF TRADE MAINTENANCE VIA PURCHASE ORDER MAINT.            */
/* Copyright 1986 QAD Inc. All rights reserved.                               */
/* $Id:: lapomt.p 27571 2013-01-15 07:42:15Z j2x                           $: */
/*                                                                            */
/* Revision: 1.17      BY: Tiziana Giustozzi     DATE: 05/24/02  ECO: *P03Z*  */
/* Revision: 1.18      BY: Jean Miller           DATE: 06/06/02  ECO: *P080*  */
/* Revision: 1.21      BY: Tiziana Giustozzi     DATE: 09/11/02  ECO: *P0DR*  */
/* Revision: 1.23      BY: Paul Donnelly (SB)    DATE: 06/28/03  ECO: *Q00G*  */
/* Revision: 1.24      BY: Jean Miller           DATE: 02/17/04  ECO: *Q04Y*  */
/* Revision: 1.25      BY: Jean Miller           DATE: 08/19/04  ECO: *Q0CG*  */
/* $Revision: 1.26 $       BY: Changlin Zeng         DATE: 04/26/06  ECO: *R045*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*-Revision end---------------------------------------------------------------*/

/* This procedure displays the Terms of Trade frame for a PO. This is where */
/* a Terms of Trade code is assigned to a PO                                */

{us/bbi/mfdeclre.i}
{us/bbi/gplabel.i}
{us/px/pxmaint.i}
{us/ap/apconsdf.i}

{us/px/pxphdef.i ppitxr}

/* COMMON API CONSTANTS AND VARIABLES */
{us/mf/mfaimfg.i}
{us/la/ladspomt.i "reference-only"}

/* DEFINE INPUT PARAMETERS */
define input parameter po_recno as recid.
define input parameter show-lc-detail as logical   no-undo.
define input-output parameter upd_okay as logical  no-undo.

define variable oldtotcode like po_tot_terms_code  no-undo.
define variable type-po as character format "x(2)" no-undo.
define variable err-flag         as integer        no-undo.
define variable old_db           like si_db        no-undo.
define variable transport-resp   as character format "x(8)" no-undo.
define variable use-category as character           no-undo.
define variable transit  like delt_transit          no-undo.
define variable yn      like mfc_logical initial no no-undo.
define variable transport-lbl as character          no-undo.
define variable vErrorMsgNbr as integer no-undo.
define variable vErrorMsgType as integer no-undo.
/* DEFINE FRAME */
form
   po_tot_terms_code label "Terms of Trade"     colon 22
   show-lc-detail    label "Show Charge Detail" colon 66
   po_translt_days   format ">>9" label "Transport Days" colon 22
   transport-resp    label "Transportation Resp" colon 66
with frame termsoftrade width 80 side-labels
title color normal (getFrameTitle("LOGISTICS_ACCOUNTING_DATA",35)).

/* SET EXTERNAL LABELS */
setFrameLabels(frame termsoftrade:handle).

for first po_mstr where recid(po_mstr) = po_recno
exclusive-lock: end.

if new po_mstr
then do:

   for first vd_mstr
      fields(vd_domain vd_tot_terms_code)
      where vd_domain = global_domain and vd_addr = po_vend
   no-lock: end.

   po_tot_terms_code = vd_tot_terms_code.
end.

for first tot_mstr
   where tot_domain = global_domain
   and tot_terms_code = po_tot_terms_code
   no-lock:
end.

/*    DISPLAY TRANSPORT LEAD TIME FOR FIRST RECORD */
transport-resp = "".
{us/gp/gplngn2a.i &file = ""tot_mstr""
            &field = ""tot_transport_resp""
            &code = tot_transport_resp
            &mnemonic = transport-resp
            &label =  transport-lbl}

po_translt_days = round(po_translt_days,0).

/* DISPLAY FRAME */
if c-application-mode <> "API" then
   display
      po_tot_terms_code
      show-lc-detail
      po_translt_days
      transport-resp
   with frame termsoftrade.

oldtotcode = po_tot_terms_code.

{us/gp/gpapinit.i "dsLogisticsAccountDataInfo" "getDataset" "input ""dsLogisticsAccountDataInfo"","}

/*MAIN-BEGIN*/
mainloop:
do on endkey undo, leave:
   if c-application-mode = "API" and retry then do:
      upd_okay = no.
      return.
   end.
   if c-application-mode = "API" then do:
      run getNextRecord in ApiMethodHandle (input "ttLogisticsAccountDataInfo").
      if return-value = {&RECORD-NOT-FOUND} then do:
         upd_okay = no.
         return.
      end.
   end.

   if c-application-mode <> "API" then do:
      set
         po_tot_terms_code
         show-lc-detail
      with frame termsoftrade
         editing:

         /* SCROLLING */
         if frame-field = "po_tot_terms_code" then do:
            {us/mf/mfnp.i tot_mstr
               po_tot_terms_code
               " tot_domain = global_domain and tot_terms_code "
               po_tot_terms_code
               tot_terms_code
               tot_terms}

            if recno <> ? then  do:

               /* DISPLAY TRANSPORT LEAD TIME WITH SCROLLING */
               transport-resp = "".
               {us/gp/gplngn2a.i &file = ""tot_mstr""
                           &field = ""tot_transport_resp""
                           &code = tot_transport_resp
                           &mnemonic = transport-resp
                           &label =  transport-lbl}

         display
            tot_terms_code @ po_tot_terms_code
            show-lc-detail
            po_translt_days
            transport-resp
         with frame termsoftrade.

            end. /* if recno <> ? */

         end. /* if frame-field = "po_tot_terms_code" */
         else do:
            status input.
            readkey.
            apply lastkey.
         end.

      end.  /* SET .. EDITING */
   end. /* if c-application-mode <> "API" */
   else
      assign
         {us/mf/mfaiset.i po_tot_terms_code  ttLogisticsAccountDataInfo.poTotTermsCode}
         {us/mf/mfaiset.i show-lc-detail     ttLogisticsAccountDataInfo.showLcDetail}.

   /* VALIDATE TERMS OF TRADE */
   /* BLANK TERMS OF TRADE ALLOWED */
   if po_tot_terms_code <> ""
   then do:

      for first pod_det where pod_domain = global_domain and
         pod_nbr = po_nbr and
         pod_consignment = yes no-lock:

         /* PO LINES IN CONSIGNMENT EXIST. TOT MUST BE BLANK */
         {us/bbi/pxmsg.i &MSGNUM=11434 &ERRORLEVEL=3}
         undo.
      end.
      for first tot_mstr
         where tot_domain = global_domain and
               tot_terms_code = po_tot_terms_code
      no-lock: end.

      if not available tot_mstr
      then do:

         /* TERMS OF TRADE CODE DOES NOT EXIST */
         {us/bbi/pxmsg.i &MSGNUM=5029 &ERRORLEVEL=3}
         undo mainloop, retry mainloop.

      end. /* if not available tot_mstr */
      else do:

         /* DISPLAY TRANSPORT LEAD TIME WITHOUT SCROLLING */
         transport-resp = "".
         {us/gp/gplngn2a.i &file = ""tot_mstr""
                     &field = ""tot_transport_resp""
                     &code = tot_transport_resp
                     &mnemonic = transport-resp
                     &label =  transport-lbl}

         if c-application-mode <> "API" then
            display
               tot_terms_code @ po_tot_terms_code
               show-lc-detail
               po_translt_days
               transport-resp
            with frame termsoftrade.

         if new po_mstr then do:

            if tot_transport_resp = "02" or po_site = "" then

               po_translt_days = 0.

            else do:

               for first ad_mstr
                  where ad_domain = global_domain
                  and ad_addr = po_vend
                  no-lock:
               end.
               if not available ad_mstr then leave.

               /* FIND THE DELT_MSTR RECORD */
               {us/bbi/gprun.i ""addelt.p""
                  "(input po_site,
                    input ad_ctry,
                    input ad_state,
                    input ad_city,
                    input '01',
                    output transit)"}

               if transit <> 0 then
                   po_translt_days = transit.
               else po_translt_days = 0.

            end.

         end. /* if new po_mstr */

      end. /* if available tot_mstr */
   end. /* IF PO_TOT_TERMS <> "" */
   /* VERIFY CHARGES DEFINED IN LOGISTIC A/C FOR THIS CHARGE CODE */
   /* AND ENSURE THAT THE SHIPPING WEIGHT UM IS NOT LEFT AS BLANK */
   /* WHEN THE APPORTION METHOD IS SET TO '02' */
   /* VOLUME UM MAY NOT BE BLANK WHEN THE APPORTION METHOD IS SET TO '04' */
   if available tot_mstr then do:
      {us/px/pxrun.i &PROC ='validateShippingAndVolumeUMInControlFile'
               &PROGRAM='ppitxr.p'
               &HANDLE = ph_ppitxr
               &PARAM ="(input tot_terms_code,
                         output vErrorMsgNbr)"}
      if vErrorMsgNbr > 0 then do:
         {us/bbi/pxmsg.i &MSGNUM=vErrorMsgNbr &ERRORLEVEL=3}
         undo, retry.
      end.
   end.

   /*LETS CHECK FOR PO_TOT_TERMS CODE AND SEE IF THIS ITEM HAS ANY ISSUES*/
   /* LETS VALIDATE THE ITEMS IN PO FOR THE RULES IN TERMS OF TRADE*/
   {us/px/pxrun.i &PROC ='validateShippingAndVolumeInPOLinesForTot'
            &PROGRAM='ppitxr.p'
            &HANDLE = ph_ppitxr
            &PARAM ="(input po_nbr,
                      input 0,
                      output vErrorMsgNbr,
                      output vErrorMsgType)"}
   if vErrorMsgNbr > 0 then do:
      {us/bbi/pxmsg.i &MSGNUM=vErrorMsgNbr &ERRORLEVEL=vErrorMsgType}
      if vErrorMsgType  = 3 then
         undo, retry.
   end.

   if not new po_mstr and po_tot_terms_code <> oldtotcode
   then do:

      /* TERMS OF TRADE HAVE CHANGED. PLEASE VERIFY PO COSTS */
      {us/bbi/pxmsg.i &MSGNUM=5047 &ERRORLEVEL=2}
      pause.

      {us/bbi/gprun.i ""lacdel.p"" "(input po_nbr)"}

      for first tot_mstr no-lock
         where tot_domain = global_domain
         and tot_terms_code = po_tot_terms_code:
      end.

      if po_tot_terms_code <> ""
         and available tot_mstr
         and tot_transport_resp = "01" then do:

         for first ad_mstr
            where ad_domain = global_domain
            and ad_addr = po_vend
            no-lock:
         end.
         if not available ad_mstr then leave.

         /* FIND THE DELT_MSTR RECORD */
         {us/bbi/gprun.i ""addelt.p""
            "(input po_site,
              input ad_ctry,
              input ad_state,
              input ad_city,
              input '01',
              output transit)"}

         if transit <> 0 then
             po_translt_days = transit.
         else po_translt_days = 0.

      end. /* if available tot_mstr  */

      old_db = global_db.

      for each pod_det
            fields(pod_domain pod_nbr pod_site)
            where pod_domain = global_domain and pod_nbr = po_nbr
         no-lock
            break by pod_site:

         for first si_mstr
            fields(si_domain si_site si_db)
            where si_domain = global_domain and si_site = pod_site
         no-lock:
         end.

         if first-of(pod_site)
            and pod_site <> "" then do:

            if available si_mstr
               and si_db <> global_db then do:

               {us/bbi/gprun.i ""gpmdas.p"" "(input si_db, output err-flag)"}

               if err-flag = 0 then do:
                  {us/bbi/gprun.i ""lacdel.p"" "(input po_nbr)"}
               end.

            end. /* if available si_mstr */

         end. /* if first-of(pod_site) */

      end. /* for each pod_det */

      if old_db <> global_db then do:
         {us/bbi/gprun.i ""gpmdas.p"" "(old_db, output err-flag)"}
      end.

   end.  /* if po_tot_terms_code */

   if c-application-mode <> "API" and keyfunction(lastkey) = "endkey" then
      undo mainloop, leave mainloop.

   seta:
   do on error undo, retry:
      if c-application-mode = "API" and retry then do:
         upd_okay = no.
         return.
      end.

      if po_tot_terms_code <> "" then do:

         po_translt_days = round(po_translt_days,0).

         if c-application-mode <> "API" then
            update
               po_translt_days
               show-lc-detail
            with frame termsoftrade.
         else
            assign
               {us/mf/mfaistvl.i po_translt_days   ttLogisticsAccountDataInfo.poTransltDays}
               {us/mf/mfaistvl.i show-lc-detail    ttLogisticsAccountDataInfo.showLcDetail}.

         if c-application-mode <> "API" and keyfunction(lastkey) = "endkey" then
            undo mainloop, retry mainloop.

         if available tot_mstr then

            if tot_transport_resp = "02"
            and po_translt_days > 0 then do:

               /* SUPPLIER IS RESPONSIBLE FOR TRANSPORTATION */
               {us/bbi/pxmsg.i &MSGNUM=6102 &ERRORLEVEL=2}

               /* TRANSPORT DAYS SHOULD BE ZERO. CONTINUE YES/NO */
               if c-application-mode <> "API" then do:
                  {us/bbi/pxmsg.i &MSGNUM=6103 &ERRORLEVEL=2 &CONFIRM=yn}
                  if not yn or keyfunction(lastkey) = "endkey" then
                     undo seta, retry seta.
               end. /* if c-application-mode <> "API" */

            end. /* if tot_transport_resp = "02" */

      end. /*  if input po_tot_terms_code <> "" */
      else
         po_translt_days = 0.

   end. /* seta */

   upd_okay = true.

end.  /* MAINLOOP */

if c-application-mode <> "API" then
   hide frame termsoftrade no-pause.

type-po = {&TYPE_PO}.

if c-application-mode = "API" then do:
   run setCommonDataBuffer in ApiMethodHandle
      (input "ttCmnLogisticsAccountingCharge").
end.

/*324*/ {us/bbi/gprun.i ""xxlaisupp.p""
   "(input po_nbr,
     input type-po,
     input po_vend,
     input show-lc-detail)"}

if c-application-mode = "API" then do:
   run setCommonDataBuffer in ApiMethodHandle
      (input "").
end.
