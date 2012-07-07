/* xxpodld1.p - popomt.p cim load                                            */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 120706.1 LAST MODIFIED: 07/06/12 BY:Zy                          */
/* REVISION END                                                              */

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */
{pxpgmmgr.i}
{xxpodld.i}

define variable poc_pt_req1 like mfc_logical.

define variable vprice-list-failed like mfc_logical initial false no-undo.
define variable vprice-list-msg as integer no-undo.
 
define variable v-use-log-acctg as logical no-undo.
  /*cimload */
{gprun.i ""lactrl.p"" "(output v-use-log-acctg)"}

  FOR EACH xxpod_det:
      FIND FIRST po_mstr NO-LOCK WHERE po_nbr = xxpod_nbr NO-ERROR.
      FIND FIRST pod_det NO-LOCK  WHERE 
                 pod_nbr = xxpod_nbr AND pod_line = xxpod_line NO-ERROR.
      if (pod_status = "c" or pod_status = "x") then do:
      	 /* errnbr 2395*/
         assign xxpod_error = getMsg(2395).
         next.
      end.
      fn_i = "".
      fn_i = "xxpodld-" + pod_nbr + "-" + string(pod_line) + "-"
           + replace(STRING(TIME,"HH:MM:SS"),":","-").

      OUTPUT TO VALUE(fn_i + ".bpi" ).
      PUT UNFORMATTED xxpod_nbr SKIP.
      PUT UNFORMATTED "-" SKIP. /*Supplier*/
      PUT UNFORMATTED "-" SKIP. /*Ship-To*/
      PUT UNFORMATTED "-" SKIP. /*Order date*/

      /*ss - 120113.1 b*/
      FIND FIRST gl_ctrl NO-LOCK NO-ERROR.
      IF AVAIL gl_ctrl THEN DO:
          IF po_curr <> gl_base_curr THEN DO:
             PUT UNFORMATTED "-" SKIP.
          END.
      END.
      /* check po_pr_list2 */
      {xxadprclst.i
         &price-list     = "po_pr_list2"
         &curr           = "po_curr"
         &price-list-req = "no"
         &disp-msg       = "yes"
         &warning        = "no"}
      PUT UNFORMATTED "-" SKIP. /*TAX*/
      if v-use-log-acctg then do:
           PUT UNFORMATTED "-" SKIP. /*Terms of Trade*/
      end.
      IF po_consignment = YES THEN DO:  /*Consignment*/
         FIND FIRST cns_ctrl NO-LOCK NO-ERROR.
         IF AVAIL cns_ctrl AND cns_active = YES THEN DO:
             PUT UNFORMATTED "-" SKIP.
         END.
      END.
      IF po_cmtindx <> 0 then DO:      /*comm = YES*/
         PUT UNFORMATTED "." SKIP.
      END.
      PUT UNFORMATTED xxpod_line SKIP.
      IF NOT pod_sched AND (pod_type = "B" or pod_qty_rcvd = 0) THEN DO:
         PUT UNFORMATTED "-" SKIP. /*site*/
      END.
      PUT UNFORMATTED "-" SKIP. /*qty_ord*/
      PUT UNFORMATTED "-" SKIP. /*Unit Cost   Disc%*/
      PUT UNFORMATTED "- - " .
      if pod_qty_rcvd = 0 and
         can-find(pt_mstr where pt_part = pod_part and pt_lot_ser <> "s") then do:
         put UNFORMATTED "- ". /*S/M*/
      end.
      IF xxpod_status <> "" THEN
         PUT UNFORMATTED xxpod_status.
      ELSE
         PUT UNFORMATTED "-".

      PUT UNFORMATTED " - " .

      IF xxpod_due_date <> ? THEN
         PUT UNFORMATTED xxpod_due_date.
      ELSE
         PUT UNFORMATTED "-".

      PUT UNFORMATTED " ".

      IF xxpod_per_date <> ? THEN
         PUT UNFORMATTED xxpod_per_date.
      ELSE
         PUT UNFORMATTED "-".

      PUT UNFORMATTED " ".
      IF xxpod_need <> ? THEN
         PUT UNFORMATTED xxpod_need.
      ELSE
         PUT UNFORMATTED "-".
      PUT UNFORMATTED " -" SKIP.

      IF pod_taxable = YES THEN DO:
         PUT UNFORMATTED "-" SKIP.
      END.

      IF pod_consignment = YES THEN DO:  /*Consignment*/
         PUT UNFORMATTED "-" SKIP.
         PUT UNFORMATTED "-" SKIP.
      END.

      if pod_cmtindx <> 0 then do:        /*CMMT = YES*/
         PUT UNFORMATTED "." skip.
      end.
      PUT UNFORMATTED "." SKIP.
      PUT UNFORMATTED "." SKIP.
      PUT UNFORMATTED "-" SKIP.
      PUT UNFORMATTED "-" SKIP.
      OUTPUT CLOSE .

      batchrun = yes.
      INPUT FROM VALUE( fn_i + ".bpi" ) .
      OUTPUT TO VALUE( fn_i + ".bpo" ) .
      {gprun.i ""popomt.p""}
      INPUT CLOSE .
      OUTPUT CLOSE .
      batchrun = NO.

/*120119.1 B*/
      FIND FIRST pod_det no-lock WHERE
                 pod_nbr = xxpod_nbr AND pod_line = xxpod_line no-error.
      IF AVAIL pod_det THEN DO:
          assign xxpod_error = "".
          if (pod_due_date <> xxpod_due_date and xxpod_due_date <> ?) then do:
             assign xxpod_error = "ERROR:POD_DUE_DATE".
          end.
          if (pod_per_date <> xxpod_per_date and xxpod_per_date <> ?) then do:
             if xxpod_error = ""
                then assign xxpod_error = "ERROR:POD_PER_DATE".
                else assign xxpod_error = xxpod_error + ";POD_PER_DATE".
          end.
          if (pod_need <> xxpod_need and xxpod_need <> ?) then do:
             if xxpod_error = ""
                then assign xxpod_error = "ERROR:POD_NEED".
                else assign xxpod_error = xxpod_error + ";POD_NEED".
          end.
          if (pod_status <> xxpod_status) then do:
             if xxpod_error = ""
                then assign xxpod_error = "ERROR:POD_STATUS".
                else assign xxpod_error = xxpod_error + ";POD_STATUS".
          end.

         if xxpod_error = "" then do:
            assign xxpod_error = "OK".
            OS-DELETE VALUE(fn_i + ".bpi").
            OS-DELETE VALUE(fn_i + ".bpo").
         end.
      END.
      ELSE DO:
          assign xxpod_error = "ERROR:PO Line not available".
      END.
/*120119.1 E*/
  END.
