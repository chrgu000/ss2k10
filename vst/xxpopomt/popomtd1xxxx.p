/* popomtd1.p - PO MAINTENANCE VALIDATE REMOTE DB WORK ORDERS                 */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.8.3.6 $                                                       */
/*                                                                            */
/* This program displays, updates and validates the work order frame for      */
/* subcontract purchase order.                                                */
/*                                                                            */
/* REVISION: 7.3      LAST MODIFIED: 11/01/93   BY: *H221* afs                */
/* REVISION: 8.5      LAST MODIFIED: 08/09/94   BY: *J014* tjs                */
/* REVISION: 7.4      LAST MODIFIED: 10/10/94   BY: *FS27* dpm                */
/* REVISION: 7.4      LAST MODIFIED: 02/06/95   BY: *F0H3* jxz                */
/* REVISION: 7.4      LAST MODIFIED: 03/09/95   BY: *H0BY* dxk                */
/* REVISION: 7.4      LAST MODIFIED: 03/16/95   BY: *G0HM* pcd                */
/* REVISION: 7.4      LAST MODIFIED: 03/31/95   BY: *G0JZ* JPM                */
/* REVISION: 7.4      LAST MODIFIED: 04/10/95   BY: *G0KL* YEP                */
/* REVISION: 7.4      LAST MODIFIED: 09/11/95   BY: *G0WR* ais                */
/* REVISION: 7.4      LAST MODIFIED: 01/02/96   BY: *G1HS* ais                */
/* REVISION: 8.5      LAST MODIFIED: 05/20/96   BY: *G1NZ* rxm                */
/* REVISION: 8.5      LAST MODIFIED: 11/20/96   BY: *J191* Suresh Nayak       */
/* REVISION: 8.6      LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 08/17/98   BY: *L062* Steve Nugent       */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 10/25/99   BY: *N002* Steve Nugent       */
/* REVISION: 9.1      LAST MODIFIED: 11/17/99   BY: *N04H* Vivek Gogte        */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED:            BY: *F0PN* Missing ECO        */
/* Revision: 1.8.3.5   BY: John Corda        DATE: 03/02/00    ECO: *N059*    */
/* REVISION: 9.1      LAST MODIFIED: 08/17/00   BY: *N0LJ* Mark Brown         */
/* $REVISION:1.8.3.5 $ BY: Adeline Kinehan   DATE: 10/23/01    ECO: *N13P*    */
/*V8:ConvertMode=Maintenance                                                  */
/*                     by *ADM*  ShiyuHe    DATE: 09/22/04  -Check pod_qty_ord */ 

/*============================================================================*/
/* **************************** Definitions ********************************* */
/*============================================================================*/

/* ********** Begin Translatable Strings Definitions ********** */
&SCOPED-DEFINE popomtd1_p_1 "Subcontract Type"
/* Maxlen: Comment: */

&SCOPED-DEFINE popomtd1_p_2 "Lot/Serial"
/* Maxlen: Comment: */

/* ********** End Translatable Strings Definitions ********** */

/* STANDARD INCLUDE FILES */
{mfdeclre.i}
{pxmaint.i}

/* EXTERNAL LABEL INCLUDE */
{gplabel.i}

/* SHARED VARIABLES */
define shared variable workord   like wo_nbr.
define shared variable worklot   like wo_lot.
define shared variable routeop   like wr_op.
define shared variable workpart  like wo_part.
define shared variable workproj  like wo_project.
define shared variable subtype   as character format "x(12)"
   label {&popomtd1_p_1} no-undo.
define shared variable pod_recno as recid.
/*ADM*/ define shared variable poqty  like pod_qty_ord.
/*ADM*/ define shared variable new_pod        like mfc_logical.

/* LOCAL VARIABLES */
define variable cont_yn             like mfc_logical initial true.
define variable using_lot_trace     like mfc_logical no-undo.
define variable wiplot              as character format "x(18)" no-undo.
define variable h_wiplottrace_funcs as handle no-undo.

/* WIP LOT TRACE FUNCTION FORWARD DECLARATIONS */
/* SEE WARNING IN wlfnc.i - THIS IS A BOLT ON. */
{wlfnc.i}

/*COMMON API CONSTANTS AND VARIABLES*/
{mfaimfg.i}

 /*PURCHASE ORDER API TEMP-TABLE, NAMED USING THE "api" PREFIX*/
{popoit01.i}

if c-application-mode = "API" then do on error undo, return error:

    /*GET HANDLE OF API CONTROLLER*/
   {gprun.i ""gpaigh.p"" "(output ApiMethodHandle,
                           output ApiProgramName,
                           output ApiMethodName,
                           output apiContextString)"}


    /*GET LOCAL PURCHASE ORDER DET TEMP-TABLE*/
   create ttPurchaseOrderDet.
   run getPurchaseOrderDetRecord in ApiMethodHandle
              (buffer ttPurchaseOrderDet).

end.  /* If c-application-mode = "API" */
/*============================================================================*/
/* ****************************** Main Block ******************************** */
/*============================================================================*/

if is_wiplottrace_enabled() then do:
   for first pod_det
      where recid(pod_det) = pod_recno
      exclusive-lock:
   end.

   wiplot = pod_wip_lotser.

   if wiplot = ? then
      wiplot = "".

   using_lot_trace = yes.

end.

setd_sub:
do on error undo, retry on endkey undo, leave:
   /* DO NOT RETRY WHEN PROCESSING API REQUEST */
   if retry and c-application-mode = "API" then
      undo setd_sub, return error.
   if c-application-mode <> "API" then
      pause 0.

   form
      workord     colon 17
      /*V8! space(2) */
      worklot     colon 17
      routeop     colon 17
      subtype     colon 17
      wiplot      colon 17 label {&popomtd1_p_2}
      with frame dsub attr-space overlay side-labels
      centered row 15.

   /* SET EXTERNAL LABELS */
   setFrameLabels(frame dsub:handle).

   {pxrun.i &PROC='processRead' &PROGRAM='wowoxr.p'
            &PARAM="(input worklot,
                     buffer wo_mstr,
                     input {&NO_LOCK_FLAG},
                     input {&NO_WAIT_FLAG})"
            &NOAPPERROR=True
            &CATCHERROR=True}

   if return-value = {&SUCCESS-RESULT} then
      workord = wo_nbr.
   else
      workord = "".
   if c-application-mode <> "API" then
      display
         workord
         worklot
         routeop
         subtype
         wiplot  when (using_lot_trace)
      with frame dsub.

   setd_sub1:
   do on error undo, retry:
      if retry and c-application-mode = "API" then
         undo setd_sub1, return error.
      if c-application-mode <> "API" then
      do:

         set
            workord
            worklot
            routeop
            subtype
            wiplot when (using_lot_trace)
            with frame dsub
         editing:
         if frame-field = "workord" then do:
            readkey.
            apply lastkey.

            /* LOOK UP NEW ID # IF WE DO NOT HAVE A VALID MATCH */
            if input workord <> "" and
               can-find(first wo_mstr where wo_nbr = input workord) and
               not can-find(first wo_mstr where wo_nbr = input workord
                                          and   wo_lot = input worklot)
            then do:
               for first wo_mstr
                  fields(wo_nbr wo_part wo_lot)
                  where wo_nbr  = input workord
                  and   wo_part = workpart no-lock: end.

               if available wo_mstr then do:
                  worklot = wo_lot.
                  display worklot with frame dsub.
               end.
               else do:
                  display "" @ worklot with frame dsub.
               end. /* ELSE */
            end.

         end.
         else do:
            ststatus = stline[3].
            status input ststatus.
            readkey.
            apply lastkey.
         end. /* ELSE */
      end. /* FRAME dsub EDITING */
      end.  /* If c-application-mode <> "API" */
      else /* c-application-mode = "API" */
      do:
         assign
            {mfaiset.i worklot ttPurchaseOrderDet.woLot}
            {mfaiset.i routeop ttPurchaseOrderDet.poOp}
            {mfaiset.i workord ttPurchaseOrderDet.nbr}
            .
      end.

      {pxrun.i &PROC='validateSubTypeCode' &PROGRAM='popoxr1.p'
               &PARAM="(input subtype)"
               &NOAPPERROR=True
               &CATCHERROR=True}

      if return-value <> {&SUCCESS-RESULT} then
         if c-application-mode <> "API" then
         do:
            next-prompt subtype with frame dsub.
            undo, retry.
         end.
         else
            undo, return error.


      {pxrun.i &PROC='validatePOSubcontractData' &PROGRAM='popoxr1.p'
               &PARAM="(input workord,
                        input worklot,
                        input workpart,
                        input workproj,
                        input routeop)"
               &NOAPPERROR=True
               &CATCHERROR=True}

      if return-value = {&APP-ERROR-RESULT} then
         if c-application-mode <> "API" then
            undo setd_sub, retry.
         else
            undo setd_sub, return error.

      else if return-value = {&RECORD-NOT-FOUND} then
      do:
         cont_yn = true.

         if c-application-mode <> "API" then
         do:
            /* MESSAGE #8500 - DO YOU WISH TO CONTINUE? */
            if not batchrun then do:
            {pxmsg.i
               &MSGNUM=8500
               &ERRORLEVEL={&INFORMATION-RESULT}
               &CONFIRM=cont_yn}
            end.
         end.

         if not cont_yn then do:
            if c-application-mode <> "API" then
            do:
               next-prompt workord with frame dsub.
               undo, retry setd_sub1.
            end.
            else.
               undo, return error.
         end. /* IF NOT cont_yn */
      end. /* WHEN RECORD-NOT-FOUND */
      else do:
         if worklot = "" then do:
            for first wo_mstr
               fields(wo_nbr wo_lot)
               where wo_nbr = workord no-lock:
               if c-application-mode <> "API" then
                  display wo_lot @ worklot with frame dsub.
            end. /* FOR FIRST wo_mstr */
         end. /* IF worklot = "" */

/*ss201203110 b*/
	define variable msg1 as char format "x(50)".
	define shared var myflag as logical no-undo.
	myflag = no.
	msg1 = "".
	if not batchrun then do:
	find first wr_route where wr_nbr = workord no-lock no-error.
		if available wr_route then do: 
			if trim(wr_wkctr) <> "9999" then do:
				msg1 = "工單制程不是委外類型，請先修改制程".
					{mfmsg03.i 2685 3 msg1 """" """"}
					myflag = yes.
					pause.				
					undo setd_sub,leave.
			end.
		end.
		else do:
			msg1 =  "該工單沒有相應制程，請先維護".
					{mfmsg03.i 2685 3 msg1 """" """"}
					myflag = yes.
					pause.
					undo setd_sub,leave.
		end.
  end.
/*ss20120310 e*/
			   
/*ADM  begin add*/ 
      define var woqty like wo_qty_ord.
      define var msgstr as char format "x(50)".
      define var podqty like pod_qty_ord.
      
      podqty = 0.
      woqty = 0.  
      if not batchrun then do:
         define buffer bufpoddet for pod_det. /* fields(pod_wo_lot pod_part pod_qty_ord pod_type).*/
/*         define buffer bufwoddet for wo_mstr.*/
         for each bufpoddet where pod_wo_lot = worklot and pod_part = workpart and pod_status <> "X":
             podqty = podqty + pod_qty_ord.
         end.
         find wo_mstr where wo_lot = worklot no-lock no-error.
         if available wo_mstr then 
             woqty =  wo_qty_ord.
         if  (new_pod and (podqty + poqty) > woqty) 
             or (not new_pod and podqty > woqty) then do:
                if new_pod then podqty = woqty - podqty. else podqty = woqty - podqty + poqty.
                msgstr = """" + "Qty ordered is too big,only less than " +  string(podqty) + """".
               {mfmsg03.i 2685 3 msgstr """" """"}
               pause.
               undo setd_sub, retry.      
         end. 
      end.
/*ADM  end add*/               

     end. /* else */
   end. /* SETD_SUB1 */

   if c-application-mode <> "API" then
      hide frame dsub no-pause.
end. /* Setd_sub */

if using_lot_trace then
   assign pod_wip_lotser = wiplot.
if not batchrun then do:
    if c-application-mode <> "API" then do:
       hide frame dsub no-pause.
       message.
       message.
    end.
end.
