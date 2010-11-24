/* xxsomt04.p  - SALES ORDER COPY                                             */
/* REVISION:101102.1 LAST MODIFIED: 11/02/10 BY: zy                           */
/*-Revision end---------------------------------------------------------------*/
/* Environment: Progress:10.1B   QAD:eb21sp5    Interface:character           */

/* DISPLAY TITLE */
{mfdtitle.i "101102.1"}

&SCOPED-DEFINE xxsomt04_i_1 "销售订单明细"
&SCOPED-DEFINE xxsomt04_i_2 "生成"
&SCOPED-DEFINE xxsomt04_i_3 "项次"
&SCOPED-DEFINE xxsomt04_i_4 "料号"
&SCOPED-DEFINE xxsomt04_i_5 "订单量"
&SCOPED-DEFINE xxsomt04_i_6 "料号说明"

define variable msg-yn  as logical.
define variable sonbr   like so_nbr.
define variable newnbr  like so_nbr.
define variable tmpnbr  like so_nbr.
define variable cimfile as character.

define temp-table tmpso
  fields yn as   logical initial yes
  fields tmpso_line like sod_line
  fields tmpso_part like sod_part
  fields tmpso_qty_ord like sod_qty_ord format "->>>>>>9.9<<<"
  fields tmpso_desc as character format "x(32)".

DEFINE QUERY qsod FOR tmpso SCROLLING.
DEFINE BROWSE b1 QUERY qsod no-lock DISPLAY
    yn            column-label {&xxsomt04_i_2}
    tmpso_line    column-label {&xxsomt04_i_3}
    tmpso_part    column-label {&xxsomt04_i_4}
    tmpso_qty_ord column-label {&xxsomt04_i_5}
    tmpso_desc    column-label {&xxsomt04_i_6}
    WITH 10 DOWN no-assign separators TITLE {&xxsomt04_i_1} FIT-LAST-COLUMN.

DEFINE FRAME f1
             sonbr validate (sonbr <> "" and
                   can-find (first so_mstr where so_nbr = input sonbr),"")
             so_cust
             so_site
             so_ord_date skip(1)
             b1 skip(1)
             newnbr
        WITH SIDE-LABELS.

setFrameLabels(frame f1:handle).
ENABLE sonbr b1 newnbr WITH FRAME f1.

/* mainloop:                                                                 */
/* repeat with frame f1:                                                     */
/*     prompt-for sonbr with frame f1 editing:                               */
/*       {mfnp.i so_mstr sonbr                                               */
/*           " so_mstr.so_domain = global_domain and so_nbr "                */
/*           sonbr so_nbr so_nbr}                                            */
/*        if recno <> ? then do:                                             */
/*           assign sonbr = so_nbr.                                          */
/*           display sonbr so_cust so_site so_ord_date with frame f1.        */
/*        end.                                                               */
/*     end.                                                                  */
/* end.                                                                      */

on "Enter":U of sonbr do:
   assign sonbr.
    if sonbr = "" then do:
       {pxmsg.i &MSGNUM=81011 &ERRORLEVEL=3}
       run clearF1.
       return.
    end.
    find first so_mstr no-lock where so_domain = global_domain
           and so_nbr = sonbr no-error.
    if available so_mstr then do:
        display so_cust so_site so_ord_date with frame f1.
        empty temp-table tmpso no-error.
        for each sod_det no-lock where sod_domain = global_domain and
             sod_nbr = sonbr:
            find first pt_mstr no-lock where pt_domain = global_domain
                 and pt_part = sod_part no-error.
            create tmpso.
            assign tmpso_line = sod_line
                   tmpso_part = sod_part
                   tmpso_qty_ord = sod_qty_ord.
            if available pt_mstr then assign tmpso_desc = pt_desc1.
        end.
        OPEN QUERY qsod FOR EACH tmpso.
    end.
    else do:
       {pxmsg.i &MSGNUM=81012 &ERRORLEVEL=3 &MSGARG1=sonbr}
        return.
    end.
end.

ON ENTRY OF b1 IN FRAME f1
DO:
  {pxmsg.i &MSGNUM=81010 &ERRORLEVEL=1}.
END.

ON LEAVE OF b1 IN FRAME f1
DO:
  {pxmsg.i &MSGTEXT='' &ERRORLEVEL=1}.
END.

ON n OF b1 IN FRAME f1 DO:
    for each tmpso exclusive-lock:
        assign yn = no.
    end.
    OPEN QUERY querybrowse1 FOR EACH tmpso no-LOCK.
    b1:REFRESH() NO-ERROR.
END.

ON CURSOR-LEFT OF b1 IN FRAME f1
DO:
    DEFINE VARIABLE ibrowse       AS INTEGER NO-UNDO.
    DEFINE VARIABLE method-return AS LOGICAL NO-UNDO.
    OPEN QUERY querybrowse1 FOR EACH tmpso EXCLUSIVE-LOCK.
    DO ibrowse = 1 TO  b1:NUM-SELECTED-ROWS IN FRAME f1 :
        method-return = b1:FETCH-SELECTED-ROW(ibrowse).
        if not yn then ASSIGN yn = YES.
    END.
    b1:REFRESH() NO-ERROR.
END.

ON CURSOR-Right OF b1 IN FRAME f1
DO:
    DEFINE VARIABLE ibrowse       AS INTEGER NO-UNDO.
    DEFINE VARIABLE method-return AS LOGICAL NO-UNDO.
    OPEN QUERY querybrowse1 FOR EACH tmpso EXCLUSIVE-LOCK.
    DO ibrowse = 1 TO  b1:NUM-SELECTED-ROWS IN FRAME f1 :
        method-return = b1:FETCH-SELECTED-ROW(ibrowse).
        if yn then ASSIGN yn = no.
    END.
    b1:REFRESH() NO-ERROR.
END.

on "enter":U of newnbr do:
  assign sonbr newnbr.

  if sonbr = "" then do:
     {pxmsg.i &MSGNUM=81011 &ERRORLEVEL=3}
     return.
  end.

  find first so_mstr no-lock where so_domain = global_domain
     and so_nbr = sonbr no-error.
  if not available so_mstr then do:
     {pxmsg.i &MSGNUM=81012 &ERRORLEVEL=3 &MSGARG1=sonbr}
  end.

  find first so_mstr no-lock where so_domain = global_domain
         and so_nbr = newnbr no-error.
  if available so_mstr then do:
     {pxmsg.i &MSGNUM=2142 &ERRORLEVEL=3}
      undo,return.
  end.

  find first tmpso no-lock where yn no-error.
  if not available tmpso then do:
      assign msg-yn = no.
      {mfmsg01.i 81000 2 msg-yn}
      if not msg-yn then do:
         undo,return.
      end.
  end.

  /*generate new so_nbr.*/
  if newnbr = "" then do:
    find first soc_ctrl where soc_domain = global_domain no-error.
    if available soc_ctrl then do:
       assign tmpnbr = soc_so_pre + string(soc_so).
    end.
    find first so_mstr no-lock where so_domain = global_domain
           and so_nbr = tmpnbr no-error.
    if available so_mstr then do:
       {mfnctrlc.i "soc_domain = global_domain"
          "soc_domain" "so_domain = global_domain"
          soc_ctrl soc_so_pre soc_so so_mstr so_nbr newnbr}
      assign newnbr:screen-value = newnbr.
      assign newnbr.
      display newnbr with frame f1.
    end.
    else do:
      assign newnbr:screen-value = tmpnbr.
      assign newnbr.
      display newnbr with frame f1.
    end.
  end.
  if newnbr <> "" then do:
     if can-find (first so_mstr no-lock where so_domain = global_domain
                    and so_nbr = newnbr) then do:
        {pxmsg.i &MSGNUM=2142 &ERRORLEVEL=3}.
      end.
      else do: /*can copy so*/
        assign msg-yn = no.
        {mfmsg01.i 81001 1 msg-yn}
        if msg-yn then do:  /* gen and cimload so */
           assign cimfile = "xxsomt04.p" + newnbr + string(time) + ".cim".
           output to value(cimfile).
           find first so_mstr no-lock where so_domain = global_domain
                  and so_nbr = sonbr no-error.
           if available so_mstr then do:
/*              put unformat "@@batchload sosomt.p" skip.   */
              put unformat newnbr skip.
              put unformat so_cust skip.
              put unformat so_bill skip.
              put unformat so_ship skip.
              put unformat so_ord_date ' ' so_req_date ' - ' so_due_date ' - '.
              put unformat so_pricing_dt ' "' so_po '" "' so_rmks '" yes "' .
              put unformat so_pr_list '" "' so_site '" "' so_channel '" "'.
              put unformat so_project '" YES "' so_curr '" "' so_lang '" "'.
              put unformat so_taxable '" "' so_taxc '" ' so_tax_date ' "'.
              put unformat  so_fix_pr '"' skip.
              find first cm_mstr no-lock where cm_domain = global_domain
                     and cm_addr = so_cust no-error.
              if available cm_mstr and cm_curr <> so_curr then do:
                 put unformat '-' skip.  /*兑换率*/
              end.
              put unformat '"' so_tax_usage '" "' so_tax_env '" "' so_taxc.
              put unformat '" ' so_taxable skip.
              put unformat '"' so_slspsn '" no ' so_comm_pct[1] ' "'.
              put unformat so_fr_list '" "'so_fr_min_wt '" "'.
              put unformat so_fr_terms '"' skip.
              for each sod_det no-lock where sod_domain = global_domain
                   and sod_nbr = so_nbr:
                   if can-find(first tmpso where tmpso_line = sod_line
                      and yn) then do:
                  put '-' skip.
                  put unformat sod_part skip.
                  put unformat sod_site skip.
                  put unformat sod_qty_ord ' ' sod_um skip.
                  put unformat '-' skip. /*价格表*/
                  put unformat '- ' sod_disc_pct skip. /*价目表/折扣*/
                  put unformat '-' skip. /*净价*/
                  put unformat '"' sod_loc '" - - - - - - - - - - - - - '.
                  put unformat '- - - - - - - - - - "' sod_fr_list '"' skip.
                  if sod_fr_list <> "" then do:
                     put unformat "-" skip.
                  end.
                  put unformat '-' skip.
                   end.
              end.
              put unformat '.' skip.
              put unformat '.' skip.
              put unformat '-' skip.
              put unformat '-' skip.
/*              put unformat "@@end" skip.   */
           end.
           output close.

             batchrun  = yes.                                                
             input from value(cimfile).                                      
             output to value(cimfile + ".out") keep-messages.                
             hide message no-pause.                                          
             {gprun.i ""sosomt.p""}                                          
             hide message no-pause.                                          
             output close.                                                   
             input close.                                                    
             batchrun  = no.                                                 
             run clearf1.                                                    
/*           os-delete value(cimfile).             */
/*           os-delete value(cimfile + ".out").    */
           {pxmsg.i &MSGNUM=7 &ERRORLEVEL=1}.

        end. /* gen and cimload so */
      end. /*can copy so*/
  end.
end.

procedure clearf1:
  do with frame f1.
    sonbr:screen-value = "".
    so_cust:screen-value = "".
    so_site:screen-value = "".
    so_ord_date:screen-value = "".
    empty temp-table tmpso no-error.
    OPEN QUERY qsod FOR EACH tmpso.
    newnbr:screen-value= "".
  end.
end.

WAIT-FOR WINDOW-CLOSE OF CURRENT-WINDOW.
