/* xxpopoim02.p - pod_due_date,pod_per_date,pod_need,pod_stat cim modify     */
/* SS - 111020.1 BY KEN                                                      */
/*****************************************************************************/
/* SCHEDULE MAINTENANCE DETAIL SUBPROGRAM                                    */
/* DISPLAYS/MAINTAINS CUSTOMER LAST RECEIPT INFO                             */
/*by Ken chen 111220.1                                                       */
/*by Ken chen 120113.1                                                       */
/*V8:ConvertMode=Maintenance                                                 */
/*V8:RunMode=Character,Windows                                               */
/*-Revision end--------------------------------------------------------------*/

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */
{pxpgmmgr.i}

DEFINE SHARED VARIABLE file_name AS CHARACTER FORMAT "x(50)".
DEFINE SHARED VARIABLE v_qty_oh LIKE IN_qty_oh.
DEFINE SHARED VARIABLE fn_i AS CHARACTER.
DEFINE SHARED VARIABLE v_tr_trnbr LIKE tr_trnbr.
define variable poc_pt_req1 like mfc_logical.

define variable vprice-list-failed like mfc_logical initial false no-undo.
define variable vprice-list-msg as integer no-undo.

DEFINE SHARED TEMP-TABLE xxpod_det
   FIELD xxpod_nbr LIKE po_nbr
   FIELD xxpod_line LIKE pod_line
   FIELD xxpod_due_date LIKE pod_due_date
   FIELD xxpod_per_date LIKE pod_per_date
   FIELD xxpod_need LIKE pod_need
   FIELD xxpod_status LIKE pod_status
   FIELD xxpod_error AS CHARACTER FORMAT "x(48)"
   INDEX index1 xxpod_nbr xxpod_line.

define variable v-use-log-acctg as logical no-undo.
  /*cimload */
{gprun.i ""lactrl.p"" "(output v-use-log-acctg)"}

  FOR EACH xxpod_det:
      FIND FIRST po_mstr NO-LOCK WHERE po_domain = global_domain AND
                 po_nbr = xxpod_nbr NO-ERROR.
      FIND FIRST pod_det NO-LOCK  WHERE pod_domain = global_domain AND
                 pod_nbr = xxpod_nbr AND pod_line = xxpod_line NO-ERROR.
      if (pod_status = "c" or pod_status = "x") then do:
         assign xxpod_error = "ERROR:PO Line is closed or canceled".
         next.
      end.
      fn_i = "".
      fn_i = "xxpopoim-" + pod_nbr + "-" + string(pod_line) + "-"
           + replace(STRING(TIME,"HH:MM:SS"),":","-").

      OUTPUT TO VALUE(fn_i + ".bpi" ).
      PUT UNFORMATTED xxpod_nbr SKIP.
      PUT UNFORMATTED "-" SKIP. /*供应商*/
      PUT UNFORMATTED "-" SKIP. /*发货至*/
      PUT UNFORMATTED "-" SKIP. /*订货日期*/

      /*ss - 120113.1 b*/
      FIND FIRST gl_ctrl WHERE gl_domain = global_domain NO-LOCK NO-ERROR.
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
      PUT UNFORMATTED "-" SKIP. /*税*/
      if v-use-log-acctg then do:
           PUT UNFORMATTED "-" SKIP. /*贸易条款*/
      end.
      IF po_consignment = YES THEN DO:  /*寄存*/
         FIND FIRST cns_ctrl WHERE cns_domain = global_domain NO-LOCK NO-ERROR.
         IF AVAIL cns_ctrl AND cns_active = YES THEN DO:
             PUT UNFORMATTED "-" SKIP.
         END.
      END.
      IF po_cmtindx <> 0 then DO:      /*说明 = YES*/
         PUT UNFORMATTED "." SKIP.
      END.
      PUT UNFORMATTED xxpod_line SKIP.
      IF NOT pod_sched AND (pod_type = "B" or pod_qty_rcvd = 0) THEN DO:
         PUT UNFORMATTED "-" SKIP. /*地点*/
      END.
      PUT UNFORMATTED "-" SKIP. /*已订购量*/
      PUT UNFORMATTED "-" SKIP. /*单位成本 折扣*/
      PUT UNFORMATTED "- - " .
      if pod_qty_rcvd = 0 and
         can-find(pt_mstr where pt_mstr.pt_domain = global_domain and
                  pt_part = pod_part and pt_lot_ser <> "s") then do:
         put UNFORMATTED "- ". /*单批*/
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

      IF pod_consignment = YES THEN DO:  /*寄存*/
         PUT UNFORMATTED "-" SKIP.
         PUT UNFORMATTED "-" SKIP.
      END.

      if pod_cmtindx <> 0 then do:        /*说明 = YES*/
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
      FIND FIRST pod_det no-lock WHERE pod_domain = global_domain
             AND pod_nbr = xxpod_nbr AND pod_line = xxpod_line no-error.
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
