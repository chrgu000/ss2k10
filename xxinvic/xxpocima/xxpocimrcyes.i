/*----rev history------------------------------------------------------------*/
/*原版{mfdtitle.i "2+ "}*/
/* SS - 110307.1 By: Roger Xiao */
/* vp_mstr 区分保税非保税,vp_part : P,M开头区分 */
/*-Revision end---------------------------------------------------------------*/
repeat:
find first po_mstr no-lock where po_nbr = usrw_charfld[1] no-error.
if available po_mstr then do:
    tmp_fix_rate = if po_mstr.po_fix_rate = yes then "Y" else "N".
end.
else do:
    leave.
end.
find first pod_det no-lock where pod_nbr = usrw_charfld[1] and
           pod_line =  usrw_intfld[2] no-error.
if not available pod_det then do:
    leave.
end.
find first xxship_det where xxship_vend = usrw_key3 and
           xxship_nbr = usrw_key4 and xxship_line = usrw_intfld[1] no-error.
if not available xxship_det then do:
    leave.
end.
/*  如果是保税的(P开头的物料)收到PT非保税的收到WT.  */
assign tmp_loc = "WT".
if pod_det.pod_part begins "P" then do:
    assign tmp_loc = "PT".
end.
else do:
     find first code_mstr no-lock where code_fldname = "xxpocima.p"
            and code_value = "DefRcLoc" no-error.
     if available code_mstr then do:
        assign tmp_loc = code_cmmt.
     end.
end.
usection = "porc" + TRIM (string(year(TODAY)) +
                          string(MONTH(TODAY)) +
                          string(DAY(TODAY))) +
                          trim(STRING(TIME)) +
                          trim(usrw_key2).
output to value(usection + ".bpi") .
      PUT  UNFORMATTED trim(po_mstr.po_nbr) format "x(50)"  skip .
      PUT  UNFORMATTED xxship_nbr + " - " + string(rcvddate) +  " N N N" skip.
      /* 判断采购币与本位币是否相同，是否固定汇率*/
      If po_curr <> glbasecurr AND tmp_fix_rate  = "N"
         then PUT UNFORMATTED " -" SKIP.
      PUT UNFORMATTED trim(string(pod_det.pod_line)) skip .
      PUT UNFORMATTED trim(string(usrw_decfld[1])) + ' - N - - - '
                    + trim(xxship_site) + ' ' + trim( tmp_loc ) + ' "'
                    + trim(xxship__chr01) + '" - "'
                    + xxship_nbr + ':' + string(xxship_line) + ':'
                    + string(xxship_case) '" N N N' skip.
      PUT UNFORMATTED "." skip.
      PUT UNFORMATTED "Y" skip.
      PUT UNFORMATTED "Y" skip.
      PUT UNFORMATTED "." skip.
      PUT UNFORMATTED "." skip.
output close.

assign vtrrecid = current-value(tr_sq01).


    input from value (usection + ".bpi") .
    output to  value (usection + ".bpo") keep-messages.
    hide message no-pause.
    batchrun  = yes.
    {gprun.i ""poporc.p""}
    batchrun = no.
    hide message no-pause.
    input close.
    output close.
  find first tr_hist use-index tr_trnbr no-lock where
             tr_trnbr   > integer(vtrrecid) and
             tr_nbr     = trim(po_mstr.po_nbr) and
             tr_effdate = rcvddate and
             tr_line    = pod_det.pod_line and
             tr_type    = "rct-po" and
             tr_part    = trim(pod_det.pod_part) and
             tr_site    = trim(xxship_site) and
             tr_loc     = trim(tmp_loc) and
             tr_serial  = trim(xxship__chr01) and
             tr_qty_loc = usrw_decfld[1]
         no-error.
  if available tr_hist then do:
/*        assign                                                            */
/*            xxship_rcvd_qty     = xxship_rcvd_qty + usrw_decfld[1]        */
/*            xxship_rcvd_effdate = rcvddate                                */
/*            xxship_rcvd_date    = v_rctdate                               */
/*            xxship_rcvd_loc     = ""  /*在条码打印时分配*/                */
/*            .                                                             */

        assign
            xxship_rcvd_qty     = xxship_rcvd_qty + usrw_decfld[1]
            xxship_rcvd_effdate = tr_effdate
            xxship_rcvd_date    = v_rctdate
            xxship__chr02       = tr_loc
            xxship_rcvd_loc     = ""  /*在条码打印时分配*/
            .
        /*xxship_status 可以等于:收货OK'RCT-PO',转仓OK'RCT-TR',未收货留空 */
        if xxship_rcvd_qty >= xxship_qty then xxship_status = 'RCT-PO'.
        os-delete value(Trim(usection) + ".bpi") no-error.
        os-delete value(Trim(usection) + ".bpo") no-error.
  end.
/*  errstr = "".                           */
/*  ciminputfile = usection + ".bpi".      */
/*  cimoutputfile = usection + ".bpo".     */
/*  {xserrlg5.i}                           */
leave.
end.

