
{mfdeclre.i}
DEFINE INPUT PARAMETER mydate        like tr_date.
DEFINE INPUT PARAMETER mypart        like pt_part.
DEFINE INPUT PARAMETER myqty         like wo_qty_ord.
DEFINE INPUT PARAMETER myweight        like wo_qty_ord.
DEFINE INPUT PARAMETER mycustpart    like cp_cust_part.
DEFINE INPUT PARAMETER mylog    as logic.
DEFINE INPUT PARAMETER mylog1    as logic.
define var desc1 like pt_desc1.
define var desc2 like pt_desc2.
define var toloc  like ld_loc.
define var totqty  like wo_qty_ord.
define var mytotqty  like wo_qty_ord.
define var myint as int.
define var mytotint as int.
define var myflag as logic.
    DEFINE TEMP-TABLE tt
      FIELD tt_c1 AS CHARACTER
    .
    DEFINE TEMP-TABLE tt1
      FIELD tt1_c1 AS CHARACTER
    .


totqty = 0.
mypart = caps(mypart).
mycustpart = caps(mycustpart).
define temp-table myld
    field myld_sel        as char format "x(1)"
    field myld_domain     like ld_domain
    FIELD myld_date       like ld_date
    FIELD myld_part       LIKE ld_part
    field myld_lot        like ld_lot
    field myld_ref        like ld_ref
    field myld_qty        like ld_qty_oh
    field myld_prn        like ld_qty_oh
    field myld_wolot        like wo_lot
    field myld_optr       like op_trnbr
    index index1 myld_optr  myld_lot myld_ref
    .
define temp-table mypack
   field mypa_seq as int
   field mypa_lots as int
   field mypa_qty as int
   field mypa_lot as char extent 30
   field mypa_ref as char extent 30
   field mypa_um  as char extent 30
   field mypa_date as char extent 30
   field mypa_num as int extent 30
   index index1 mypa_seq
   .

run myfresh.

if mylog then run mysum.


form
  myld_part               label "料号"        colon 15
  pt_desc1                no-label          colon 15
  pt_desc2                no-label          colon 45
  myld_lot                label "批号"        colon 15
  myld_ref                label "参考"        colon 45
  myld_qty                label "库存数量"    colon 15
  myld_prn                label "打印数量"    colon 15
  mytotqty                label "汇总数量"    colon 15
with frame c side-label.

form
with frame b
6 down
width 80
title color normal "Recv List" .

define var vv_recid as recid .
define var vv_first_recid as recid .
vv_recid = ? .
vv_first_recid = ? .

swloop1:
repeat:

    clear frame b.
    view frame b.
    find first myld no-lock no-error.
    if not avail myld then do:
      message "没有符合条件的库存记录! "  view-as alert-box .
      leave swloop1.
    end.



    scroll_loop:
    do with frame b:
    {xxswview.i
        &domain       = "true and "
        &buffer       = myld
        &scroll-field = myld_sel
        &searchkey    = " myld_domain = global_domain "
        &index-phrase = "use-index index1 "
        &framename    = "b"
        &framesize    = 6
        &display1     = "myld_part format ""x(18)"" label ""物料号"" "
        &display2     = "myld_lot label ""批号"" "
        &display3     = "myld_ref label ""参考"" "
        &display4     = "myld_qty label ""库存数"" "
        &display5     = "myld_prn label ""打印数"" "
        &display6     = "  "
        &display7     = "  "
        &display8     = "  "
        &exitlabel    = "scroll_loop"
        &exit-flag    = "true"
        &record-id    = vv_recid
        &first-recid  = vv_first_recid
        &logical1     = true
        &exec_cursor  = "
                    disp myld_part myld_lot myld_ref  myld_qty  myld_prn   mytotqty  with frame c.
                          find first pt_mstr no-lock where pt_domain = global_domain and pt_part = myld_part no-error.
                          if avail pt_mstr then do:
                            disp pt_desc1 pt_desc2  with frame c.
                          end.
                         "
        &spacebarexec = "

      "
    }
    /*&exec_cursor  = "update pt_pm_code."   xxshp_recv_qty format "->>>>9<<"     label "收货数量"    */

    end. /* do with frame b */

    if keyfunction(lastkey) = "end-error" then do:
  run mycreatepack.  /* 产生包装记录 */
      myflag = yes.
  repeat on end-key undo ,retry:
          message "是否打印？" update myflag.
    leave.
  end.
      if myflag then do:

        /* print label  转仓 */
    run mycreatelabel.
    /* print label 转仓 */
      end.
  repeat on end-key undo ,retry:
          message "是否转仓？" update myflag .
    leave.
  end.
      if myflag then do:
    repeat on end-key undo ,retry:
            message "转仓库位" update  toloc.
      leave .
      end.
      find first loc_mstr no-lock where loc_domain = global_domain  and loc_site = "PDC" and loc_loc = toloc no-error.
      if avail loc_mstr then do:
                    run myictr(input toloc).
      end.
      else do:
        message "库位不存在,没有转仓".
      end.
  end.

        leave swloop1.
    end.
 if keyfunction(lastkey) = "Go" or keyfunction(lastkey) = "return" then do:
   setloop1:
   do on error undo setloop1, leave setloop1 with frame c:
      /* display current bautocreate record */
      if vv_recid <> ? then  do:
        find first myld where recid(myld) = vv_recid  no-error .
        if avail myld then do:
          update myld_prn with frame c.
    if myld_prn > myld_qty then do:
      message "超出库存数量".
      undo,retry.
    end.
        end.
        else do:
          message "数据错误! "  view-as alert-box .
          vv_recid = ?.
        end.
      end.
      run myfresh.
      if mylog then run mysum.
      disp mytotqty with frame c.
      /* save recid for re-positioning in down frame */
   end. /* setloop1 */
   clear frame c no-pause.
end.
end. /* swloop1 */
      hide frame b no-pause.
      hide frame c no-pause.


procedure mysum :
totqty = 0 .
for each myld where myld_domain = global_domain  and myld_part = mypart break by myld_date by myld_lot by myld_ref:
  totqty = totqty + myld_prn.
end.
myint = TRUNCATE(totqty / myqty,0).
if myint > 0 and mylog then totqty = myint * myqty .
mytotqty = totqty.
for each myld where myld_domain = global_domain and myld_part = mypart break by myld_optr by myld_lot by myld_ref:
   if totqty >= myld_prn then do:
     totqty = totqty - myld_prn.
   end.
   else do:
     myld_prn = totqty.
     totqty = 0 .
   end.
end.
end procedure.

procedure myfresh:
for each ld_det no-lock where ld_domain = global_domain
  and ld_site = "PDC" and ld_loc = "201" and ld_part = mypart and ld_qty_oh > 0
  break by ld_lot by ld_ref
  :
  find first myld where myld_domain = ld_domain and  myld_part   = ld_part   and
    myld_lot    = ld_lot    and myld_ref    = ld_ref    no-error.
  if not avail myld then do:
    create myld.
    assign
      myld_domain = ld_domain
      myld_date   = ld_date
      myld_part   = ld_part
      myld_lot    = ld_lot
      myld_ref    = ld_ref
      myld_prn    =  0
      .
  if mylog1 then myld_prn    = ld_qty_oh.
  end.
  myld_qty    = ld_qty_oh.
end.
for each myld :
  find first ld_det no-lock where ld_domain = global_domain and ld_site = "PDC" and ld_loc = "201" and
    ld_lot = myld_lot and ld_ref = myld_ref and ld_qty_oh > 0 no-error.
  if avail ld_det then do:
    myld_qty = ld_qty_oh.
    myld_wolot = "".
    if myld_prn > myld_qty then myld_prn = myld_qty.
    if length(myld_lot ) < 9 then do:
       find first wo_mstr no-lock where wo_domain = global_domain and wo_lot = myld_lot no-error.
    end.
    else do:
       find first wo_mstr no-lock where wo_domain = global_domain and wo_user1 = myld_lot no-error.
    end.
    if avail wo_mstr then myld_wolot = wo_lot.
    if myld_wolot > "" then do:
      myld_optr = 0 .
      for each op_hist no-lock where op_domain = global_domain and op_wo_lot = myld_wolot and
        op_wo_op = 260 and op_date = mydate
  break by op_trnbr :
        myld_optr = op_trnbr.
  leave.
      end.
    end.
  end.
  else delete myld.
end.
end procedure.

procedure mycreatepack:
  define var neednew as logical .
  define var mypacks as int .
  for each mypack : delete mypack. end.
  neednew = true .
  mypacks = 1 .
  for each myld where myld_domain = global_domain and myld_part = mypart and myld_prn > 0
    break by myld_optr by myld_lot by myld_ref:
    do while myld_prn > 0 :
      if neednew  then do:  /* 生成新的一箱记录 */
        create mypack.
        assign
           mypa_seq = mypacks
           mypa_qty  = 0
           mypa_lots  = 0
           mypa_lot   = ""
           mypa_um = "PCS"
           mypa_date = ""
           mypa_num = 0
        .
        mypacks = mypacks + 1.
      end.
      mypa_lots = mypa_lots + 1 .
      if myqty - mypa_qty > myld_prn  then do:
        mypa_num[mypa_lots] = myld_prn.
        mypa_lot[mypa_lots] = myld_lot.
        mypa_ref[mypa_lots] = myld_ref.
        mypa_date[mypa_lots] = string(year(myld_date),"9999")
                             + string(month(myld_date),"99")
                             + string(day(myld_date),"99").
        mypa_qty = mypa_qty + myld_prn.
        myld_prn = 0 .
        neednew = false .
      end.
      else do:
        mypa_num[mypa_lots] =  myqty - mypa_qty .
        mypa_lot[mypa_lots] = myld_lot.
        mypa_ref[mypa_lots] = myld_ref.
        mypa_date[mypa_lots] = string(year(myld_date),"9999")
                             + string(month(myld_date),"99")
                             + string(day(myld_date),"99").
        myld_prn = myld_prn - ( myqty - mypa_qty ).
        mypa_qty = myqty .
        neednew = true.
      end.
    end.
  end.
end procedure.

procedure mycreatelabel:
/*GN*/ define variable v_number as character format "x(12)".
/*GN*/ define variable errorst as logical.
/*GN*/ define variable errornum as integer.
/*GN*/ define variable xx as character initial "xxbcid".
    define var usection as char.
    define var vqrcode as char.
    define var vqty as decimal format "->>>>>>>9.<".
   Define variable LabelsPath as character format "x(100)" init "/app/bc/labels/".
        Find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="LabelsPath"no-lock no-error.
        If AVAILABLE(code_mstr) Then LabelsPath = trim ( code_cmmt ).
        If substring(LabelsPath, length(LabelsPath), 1) <> "/" Then
        LabelsPath = LabelsPath + "/".
  IF NOT (SEARCH(LabelsPath + "label.prn") <> ?) THEN DO:
     /* 文件不存在 */
     message "模版文件不存在" view-as alert-box.
     RETURN.
  END.

  /* TEMP */
  EMPTY TEMP-TABLE tt NO-ERROR.
  INPUT FROM VALUE(LabelsPath + "label.prn").
  REPEAT:
     CREATE tt.
     IMPORT UNFORMATTED tt.
  END.

  define var curpr as int .
  define var curpage as int .
  define var mypages as int .

  for each mypack:
    curpage = 0.
    curpr = 0 .
    mypages = TRUNCATE(mypa_lots / 3 ,0).
    if mypages * 3 < mypa_lots then mypages = mypages + 1.
    vqrcode = myPart.
    vqty = 0.
    do while curpage < mypages :

      EMPTY TEMP-TABLE tt1 NO-ERROR.
      for each tt:
        create tt1 .
        tt1_c1 = tt_c1.
        if index(tt1_c1,"[+TODAY+]") > 0  then do:
           tt1_c1 = replace(tt1_c1,"[+TODAY+]", string(year(mydate)) + "-" + string(month(mydate)) + "-" + string(day(mydate))  ).
           next.
        end.
        if index(tt1_c1,"[+CSPART+]") > 0  then do:
           tt1_c1 = replace(tt1_c1,"[+CSPART+]", mycustpart  ).
           next.
        end.
        if index(tt1_c1,"[+PART+]") > 0  then do:
           tt1_c1 = replace(tt1_c1,"[+PART+]", mypart   ).
           next.
        end.
        if index(tt1_c1,"[+LOT1+]") > 0  then do:
          if curpage * 3 + 1 <= mypa_lots then do:
             tt1_c1 = replace(tt1_c1,"[+LOT1+]", mypa_lot[ curpage * 3 + 1]).
             vqrcode = vqrcode + "@" + mypa_lot[ curpage * 3 + 1]
                     + "@" + trim(string(mypa_num[ curpage * 3 + 1])).
             vqty = vqty + mypa_num[ curpage * 3 + 1].
          end.
          else tt1_c1 = replace(tt1_c1,"[+LOT1+]", ""  ).
          next.
        end.
        if index(tt1_c1,"[+LOT2+]") > 0  then do:
          if curpage * 3 + 1 <= mypa_lots then do:
              tt1_c1 = replace(tt1_c1,"[+LOT2+]", mypa_lot[ curpage * 3 + 2]).
              vqrcode = vqrcode + "@" + mypa_lot[ curpage * 3 + 2]
                      + "@" + trim(string(mypa_num[ curpage * 3 + 2])).
              vqty = vqty + mypa_num[ curpage * 3 + 2].
          end.
          else tt1_c1 = replace(tt1_c1,"[+LOT2+]", "").
          next.
        end.
        if index(tt1_c1,"[+LOT3+]") > 0  then do:
          if curpage * 3 + 1 <= mypa_lots then do:
              tt1_c1 = replace(tt1_c1,"[+LOT3+]", mypa_lot[ curpage * 3 + 3]).
              vqrcode = vqrcode + "@" + mypa_lot[ curpage * 3 + 3]
                      + "@" + trim(string(mypa_num[ curpage * 3 + 3])).
              vqty = vqty + mypa_num[ curpage * 3 + 3].
          end.
          else tt1_c1 = replace(tt1_c1,"[+LOT3+]", ""  ).
          next.
        end.
        if index(tt1_c1,"[+QTY1+]") > 0  then do:
          if curpage * 3 + 1 <= mypa_lots then do:
              tt1_c1 = replace(tt1_c1,"[+QTY1+]",trim(string(mypa_num[ curpage * 3 + 1]))).
          end.
          else delete tt1. next.
        end.
          if index(tt1_c1,"[+QTY2+]") > 0  then do:
          if curpage * 3 + 2 <= mypa_lots then do:
              tt1_c1 = replace(tt1_c1,"[+QTY2+]",trim(string(mypa_num[ curpage * 3 + 2]))).
          end.
          else delete tt1. next.
        end.
        if index(tt1_c1,"[+QTY3+]") > 0  then do:
          if curpage * 3 + 3 <= mypa_lots then do:
              tt1_c1 = replace(tt1_c1,"[+QTY3+]",trim(string(mypa_num[ curpage * 3 + 3]))).
          end.
          else delete tt1. next.
        end.
        if index(tt1_c1,"[+UM1+]") > 0  then do:
          if curpage * 3 + 1 <= mypa_lots then
              tt1_c1 = replace(tt1_c1,"[+UM1+]",trim(string(mypa_um[ curpage * 3 + 1]))).
          else delete tt1. next.
        end.
        if index(tt1_c1,"[+UM2+]") > 0  then do:
          if curpage * 3 + 2 <= mypa_lots then
              tt1_c1 = replace(tt1_c1,"[+UM2+]",trim(string(mypa_um[ curpage * 3 + 2]))).
          else delete tt1. next.
        end.
        if index(tt1_c1,"[+UM3+]") > 0  then do:
          if curpage * 3 + 3 <= mypa_lots then
              tt1_c1 = replace(tt1_c1,"[+UM3+]",trim(string(mypa_um[ curpage * 3 + 3]))).
          else delete tt1. next.
        end.
        if index(tt1_c1,"[+DATE1+]") > 0  then do:
          if curpage * 3 + 1 <= mypa_lots then
              tt1_c1 = replace(tt1_c1,"[+DATE1+]",trim(string(mypa_date[curpage * 3 + 1]))).
          else delete tt1. next.
        end.
          if index(tt1_c1,"[+DATE2+]") > 0  then do:
          if curpage * 3 + 2 <= mypa_lots then
              tt1_c1 = replace(tt1_c1,"[+DATE2+]",trim(string(mypa_date[curpage * 3 + 2]))).
          else delete tt1. next.
        end.
        if index(tt1_c1,"[+DATE3+]") > 0  then do:
          if curpage * 3 + 3 <= mypa_lots then
              tt1_c1 = replace(tt1_c1,"[+DATE3+]",trim(string(mypa_date[curpage * 3 + 3]))).
              else delete tt1. next.
        end.
/*        if index(tt1_c1,"[+SUM+]") > 0  then do:                          */
/*          if ( curpage + 1 ) = mypages then    /* 本箱最后一张标签 */     */
/*              tt1_c1 = replace(tt1_c1,"[+SUM+]", string( mypa_qty )  ).   */
/*                else tt1_c1 = replace(tt1_c1,"[+SUM+]", "").              */
/*          next.                                                           */
/*        end.                                                              */
        if index(tt1_c1,"[+WT+]") > 0  then do:
          tt1_c1 = replace(tt1_c1,"[+WT+]", trim(string( myweight ) + "g") ).
          next.
        end.
      end.
      curpage = curpage + 1.
       v_number = "".
/*GN*/ {gprun.i ""gpnrmgv.p"" "(xx,input-output v_number, output errorst
/*GN*/                           ,output errornum)" }
      /* 打印标签 */
       usection =  "TMP_LABOR_Prn_Prod"  + mfguser + "_" + TRIM ( string(year(TODAY)) + string(MONTH(TODAY)) + string(DAY(TODAY)))  + trim(STRING(TIME)) + trim(string(RANDOM(1,10)))  .
       usection = "/app/bc/tmp/" + trim(usection) + ".prn".
       output to value(usection) .
       for each tt1 :
         if index(tt1_c1,"[+QR+]") > 0 then do:
            tt1_c1 = replace(tt1_c1,"[+QR+]",vqrcode).
         end.
         if index(tt1_c1,"[+SUM+]") > 0 then do:
            tt1_c1 = replace(tt1_c1,"[+SUM+]",trim(string(vqty,">>>>>>>9"))).
         end.
         if index(tt1_c1,"1234567") > 0 then do:
            tt1_c1 = replace(tt1_c1,"1234567",trim(v_number)).
         end.
         put unformat tt1_c1 skip.
       end.
       output close.
       vqrcode = myPart.
       vqty = 0.        
        os-command silent value("lp -dbc245 " + usection  + "  > /dev/null") .
        os-delete value(usection).
       /* 
       os-command silent value("rm -f " + usection  ) .
       */
       pause 0 .
    end.
  end.
end procedure.

define variable v_cimload_ok    as logical .
define variable ciminputfile   as char .
define variable cimoutputfile  as char .

     define temp-table mytt field mytt_rec as recid .


procedure myictr:
    define input parameter toloc as char.
    define var i as int.
    define var myflag as log no-undo.
    define variable usection  as char .

    myflag  = false.
    v_cimload_ok = yes.
do transaction on error undo ,leave:
    for each mypack :
      i = 0 .
      do while i < mypa_lots:
        i = i + 1.
  usection = TRIM ( string(year(TODAY)) + string(MONTH(TODAY)) + string(DAY(TODAY)))  + trim(STRING(TIME)) + trim(string(RANDOM(1,100))) + "inv31" .
  output to value( trim(usection) + ".i") .
        display
    """" + trim ( mypart) + """" format "x(50)" skip
    trim ( string(mypa_num[i] )) + " """ + string(mydate) + """ "  + """" + trim ( "" ) + """"  + " - " + """" +  "barprn" + """"   format "x(50)" skip  /*  */
    "Y T Y" format "x(50)" skip
    trim("PDC") + " " +  trim( "201" ) format "X(50)"  if trim( mypa_lot[i] ) = "" then " - " else " """ + trim(mypa_lot[i]) + """ "  format "X(50)"
    if trim( mypa_ref[i] ) = "" then " - " else """" + trim(mypa_ref[i]) + """"  format "X(50)"
    skip
    trim("PDC") + " "  + trim( toloc ) format "x(50)" skip

    "Y" skip
    "." skip
    "."
  with frame finput no-box no-labels width 200.
  output close.

  for each mytt : delete mytt . end .
        on create of tr_hist do:
          find first mytt where mytt_rec = recid(tr_hist) no-lock no-error.
          if not available mytt then do:
            create mytt. mytt_rec = recid(tr_hist).
          end.
        end.
        input from value ( usection + ".i") .
  output to  value ( usection + ".o") .
  {gprun.i ""iclotr04.p""}
  input close.
  output close.
  v_cimload_ok = no.
  for each mytt:
          find first tr_hist where recid(tr_hist) = mytt_rec and tr_domain = "PDC"  and
            tr_type = "iss-tr" no-error .
          if avail tr_hist then do:
                  v_cimload_ok = yes.
                  release tr_hist.
          end.
        end.
  if not v_cimload_ok then myflag = yes.
  unix silent value ( "rm -f "  + Trim(usection) + ".i").
  unix silent value ( "rm -f "  + Trim(usection) + ".o").
      end.
    end.
    if myflag then do:
      message "转仓失败!".
      undo,leave.
    end.
end.
end procedure.