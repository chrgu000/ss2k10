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

/*define variable v-use-log-acctg as logical no-undo. */
/* {gprun.i ""lactrl.p"" "(output v-use-log-acctg)"} */



FOR EACH xxpod_det exclusive-lock where xxpod_chk = "":
    assign fn_i = "xxpodld-" + xxpod_nbr + "-" + string(xxpod_line).
    OUTPUT TO VALUE(fn_i + ".bpi" ).
      FIND FIRST po_mstr NO-LOCK WHERE po_nbr = xxpod_nbr NO-ERROR.
      find first pod_det no-lock where pod_nbr = po_nbr AND pod_line = xxpod_line NO-ERROR.
      if not available pod_det then do:
         next.
      end.
      /* if (pod_status = "c" or pod_status = "x") then do:   */
      /*   /* errnbr 2395*/                                   */
      /*    assign xxpod_chk = getMsg(2395).                  */
      /*    next.                                             */
      /* end.                                                 */

      PUT UNFORMATTED xxpod_nbr SKIP.
      PUT UNFORMATTED "-" SKIP. /*Supplier*/
      PUT UNFORMATTED "-" SKIP. /*Ship-To*/
      PUT UNFORMATTED "-" SKIP. /*Order date*/

      /*ss - 120113.1 b*/
      FIND FIRST vd_mstr NO-LOCK where vd_addr = po_vend NO-ERROR.
      IF AVAIL vd_mstr THEN DO:
          IF po_curr <> vd_curr THEN DO:
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
/*      if v-use-log-acctg then do:                                   */
/*           PUT UNFORMATTED "-" SKIP. /*Terms of Trade*/             */
/*      end                                                           */
/*       IF po_consignment = YES THEN DO:  /*Consignment*/            */
/*          FIND FIRST cns_ctrl NO-LOCK NO-ERROR.                     */
/*          IF AVAIL cns_ctrl AND cns_active = YES THEN DO:           */
/*              PUT UNFORMATTED "-" SKIP.                             */
/*          END.                                                      */
/*       END.                                                         */
      IF po_cmtindx <> 0 then DO:      /*comm = YES*/
         PUT UNFORMATTED "." SKIP.
      END.
      PUT UNFORMATTED xxpod_line SKIP.
/*    IF NOT pod_sched AND (pod_type = "B" or pod_qty_rcvd = 0) THEN DO:     */
/*       PUT UNFORMATTED "-" SKIP. /*site*/                                  */
/*    END.                                                                   */
      PUT UNFORMATTED "-" SKIP. /*qty_ord*/
      PUT UNFORMATTED "-" SKIP. /*Unit Cost   Disc%*/
      PUT UNFORMATTED "- - " .
      if pod_qty_rcvd = 0 and
         can-find(pt_mstr where pt_part = pod_part and pt_lot_ser <> "s") then do:
         put UNFORMATTED "- ". /*S/M*/
      end.
      IF xxpod_stat <> "" THEN
         PUT UNFORMATTED xxpod_stat.
      ELSE
         PUT UNFORMATTED "-".

      PUT UNFORMATTED " - " .

      IF xxpod_due_date <> ? THEN
         PUT UNFORMATTED xxpod_due_date.
      ELSE
         PUT UNFORMATTED "-".

      PUT UNFORMATTED " - - - - - - - - - - - N" SKIP.

      IF POD_TYPE = "S" then DO:
         PUT UNFORMATTED "-" SKIP.
      END.

      IF pod_taxable = YES THEN DO:
         PUT UNFORMATTED "-" SKIP.
      END.

 /*      IF pod_consignment = YES THEN DO:  /*Consignment*/                  */
 /*         PUT UNFORMATTED "-" SKIP.                                        */
 /*         PUT UNFORMATTED "-" SKIP.                                        */
 /*      END.                                                                */
                                                                             
 /*     if pod_cmtindx <> 0 then do:        /*CMMT = YES*/                   */
 /*        PUT UNFORMATTED "." skip.                                         */
 /*     end.                                                                 */
      PUT UNFORMATTED "." SKIP.
      PUT UNFORMATTED "." SKIP.
      PUT UNFORMATTED "-" SKIP.
      PUT UNFORMATTED "-" SKIP.
      OUTPUT CLOSE .
      if cloadfile then do:
         do transaction on endkey undo, leave:
            batchrun = yes.
            INPUT FROM VALUE( fn_i + ".bpi" ) .
            OUTPUT TO VALUE( fn_i + ".bpo" ) keep-messages.
            {gprun.i ""popomt.p""}
            INPUT CLOSE .
            OUTPUT CLOSE .
            batchrun = NO.
        FIND FIRST pod_det no-lock WHERE
                   pod_nbr = xxpod_nbr AND pod_line = xxpod_line no-error.
        IF AVAIL pod_det THEN DO:
            if (pod_due_date <> xxpod_due_date and xxpod_due_date <> ?) then do:
               assign xxpod_chk = "ERROR:POD_DUE_DATE".
            end.
            if (pod_status <> xxpod_stat) then do:
               if xxpod_chk = ""
                  then assign xxpod_chk = "ERROR:POD_STATUS".
                  else assign xxpod_chk = xxpod_chk + ";POD_STATUS".
            end.
            if xxpod_chk = "" then do:
               assign xxpod_chk = "OK".
               OS-DELETE VALUE(fn_i + ".bpi").
               OS-DELETE VALUE(fn_i + ".bpo").
            end.
        END. /*IF AVAIL pod_det THEN DO:*/
        else do:
            undo,next.
        end.
      end. /*do transaction on endkey undo, leave:*/
    end. /* if cloadfile then do: */
END. /*FOR EACH xxpod_det no-lock where xxpod_chk = "":*/

