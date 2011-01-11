/* xxsomt03.p ----                                                           */
/* Copyright 2010 SoftSpeed gz                                               */
/* All rights reserved worldwide.  This is an unpublished work.              */
/* SS - 101111.1 By: zhangyun                                    *b7*        */


/* SS - 100510.1 - RNB
[100510.1]
ref: 0020.内销销售订单维护.docx
程序主逻辑,参考neil的程序xxbomst1.p.
[100510.1]
SS - 100510.1 - RNE */

/* SS - 101111.1 - ZYB
   如果订单价格为零不允许做SO单。
SS - 101111.1 - ZYE */

{mfdtitle.i "110112.1"}

{xxdeclre.i "new"}
{xxdeclre1.i}

define variable site  like ld_site initial "11000".
define variable sonbr like so_nbr.
define variable cust like so_cust.
define variable shipto like so_ship.
define variable reqdate like so_req_date.
define variable part like sod_part.
define variable qty like sod_qty_ord.
define variable i as integer.
define variable tt_recid as recid no-undo.
define variable sonbrtype as char.
define variable errorst        as logical no-undo.
define variable errornum       as integer no-undo.
define variable v_number       as char  no-undo.
define var xxchannel as char.
define var curr like cu_curr.
define var xxcmmt as char format "x(76)" extent 5.
define var outrst as int.
define variable decPrice as decimal no-undo.

define temp-table tsod_det
    field tsod_sel  as char format "x(1)"
    field tsod_line like sod_line
    field tsod_part like sod_part
    field tsod_desc1 like pt_desc1
    field tsod_desc2 like pt_desc2
    field tsod_qty  like  qty
    field tsod_price as decimal.

{xxdrsomt.i "new"}

form
    sonbr     label "销售订单"
    cust
    shipto
    xxchannel label "订单类型"
    skip
    reqdate   label "需求日期"
    curr      label "币别"
    part      label "物料号"
with frame a side-labels width 80 attr-space.
setFrameLabels(frame a:handle).

form
    tsod_sel   label "选"
    tsod_line  label "项"
    tsod_part  label "物料号"
    tsod_desc1 label "名称"     format "x(20)"
    tsod_qty   label "数量"     format "->>>>>>9.9<<<"
    tsod_price label "价格" format ">>>>>>9.9<<<"
with frame b down width 80 attr-space.
setFrameLabels(frame b:handle).

form
    xxcmmt no-label
with frame c side-labels with width 80 attr-space.

/*  find first xrate_ctrl                             */
/*      no-lock                                       */
/*      where xrate_domain = global_domain            */
/*      no-error.                                     */
/*  if not(available(xrate_ctrl)) then do:            */
/*      message "未设置加价比例.".                    */
/*      do on endkey undo, retry:                     */
/*          pause 3 no-message.                       */
/*      end.                                          */
/*      return.                                       */
/*  end.                                              */

assign
    xxchannel = "S4"
    reqdate = today.

mainloop:
repeat:

    update sonbr with frame a editing:
        if frame-field = "sonbr" then do:
          {mfnp05.i so_mstr so_nbr
                   "so_domain = global_domain and so_nbr begins 's' "
                    so_nbr "input sonbr"}
        end.
        else do:
            status input.
            readkey.
            apply lastkey.
        end.
        if recno <> ? then do:
            disp
            so_nbr @ sonbr
            so_cust @ cust
            so_ship @ shipto
            so_curr @ curr
            so_req_date @ reqdate
            with frame a.
        end.
    end.

    if sonbr = "" then do:
        {gprun.i
            ""gpnrmgv.p""
            "(
                'sonbr3',
                input-output sonbr,
                output errorst,
                output errornum
            )"
        }
        if errorst then do:
            message "订单号没有产生".
            next mainloop.
        end.
    end.
    display sonbr with frame a.

    if not ( sonbr begins "s" ) then do:
        message "不是内销订单".
        next.
    end.

    find first so_mstr where so_domain = global_domain and so_nbr = sonbr
         no-lock no-error.
    if avail so_mstr then do:
/*        if so_cust <> "1919" then do:                        */
/*            message "客户不是进出口".                        */
/*            undo, retry.                                     */
/*        end.                                                 */

        cust = so_cust.
        shipto = so_ship.
        reqdate = so_req_date.
        xxchannel = so_channel.
        curr = so_curr.
        disp cust shipto reqdate xxchannel with frame a.
        update part with frame a.
    end.
    else do:
        update cust shipto xxchannel reqdate curr part with frame a.

        find first cm_mstr where cm_domain = global_domain and cm_addr = cust
            no-lock no-error.
        if not avail cm_mstr then do:
            {pxmsg.i &msgnum = 3 &errorlevel = 3}
            next.
        end.
        if shipto = "" then shipto = cust .
        disp shipto with frame a.

        if curr = "" then curr = cm_curr.
        disp curr with frame a.

        if lookup(xxchannel,"S1,S2,S3,S4") = 0 then do:
            message "错误:订单类型只能为S1,S2,S3,S4".
            next.
        end.

        if reqdate = ? or reqdate < today  then do:
            message "错误: 日期不能小于今天".
            next.
        end.

        find first ps_mstr where ps_domain = global_domain and ps_par = part
             no-lock no-error.
        if not avail ps_mstr then do:
            {pxmsg.i &msgnum = 5642 &errorlevel = 3}
            undo, retry.
        end.
    end.

    empty temp-table tsod_det.

    find last sod_det where sod_domain = global_domain and sod_nbr = sonbr
         no-lock no-error.
    if not avail sod_det then i = 1.
    else i = sod_line + 1.

    {xxzkbommt.i "tsod_det" "part" "tsod_part" "today" "tsod_qty" }
    for each tsod_det exclusive-lock,
    each pt_mstr where pt_domain = global_domain and pt_part = tsod_part
         no-lock:
        tsod_line = i.
        tsod_qty = 0.
        tsod_desc1 = pt_desc1.
        tsod_desc2 = pt_desc2.
        tsod_price = 0.
        i = i + 1.
        assign decPrice = 0.
        for each xxpc_mstr
            no-lock
            where xxpc_domain = global_domain
                and xxpc_part = tsod_part
                and xxpc_um = pt_um
                and xxpc_curr = curr
                and (xxpc_start <= today or xxpc_start = ?)
                and (xxpc_expire >= today or xxpc_expire = ?)
            use-index xxpc_part
            break
            by xxpc_domain
            by xxpc_part
            by xxpc_um
            by xxpc_curr
            by xxpc_list
            by xxpc_start :
            if last-of(xxpc_list) then do:
                if decPrice < xxpc_amt[1] then decPrice = xxpc_amt[1].
            end.
        end.
        tsod_price = decPrice.
    end.


    find first tsod_det no-lock no-error.
    if not avail tsod_det then do:
        {pxmsg.i &msgnum = 5011 &error = 3}
    end.

    hide frame a no-pause.
    hide frame c no-pause.

    scroll_loop:
    do with frame b:
        {xxusel.i
            &detfile = tsod_det
            &scroll-field = tsod_sel
            &framename = "b"
            &framesize = 8
            &display1  = tsod_sel
            &display2  = tsod_line
            &display3  = tsod_part
            &display4  = tsod_desc1
            &display5  = tsod_qty
/*b7*/      &display6  = tsod_price
            &sel_on    = ""*""
            &sel_off   = """"
/*b7*/      &errmsgnbr = 81020
/*b7*/      &noallow   = "tsod_price = 0"
            &include2  = "update tsod_qty tsod_price with frame b."
            &include1  = "tsod_qty = 0. disp tsod_qty with frame b."
            &CURSORDOWN = " if avail tsod_det then
                            run dispmv ( input tsod_part). "
            &CURSORUP   = " if avail tsod_det then
                            run dispmv ( input tsod_part). "
            &exitlabel = scroll_loop
            &exit-flag = true
            &record-id = tt_recid
        }

        hide frame a no-pause.
        hide frame b no-pause.
        hide frame c no-pause.

        if keyfunction(lastkey) = "end-error" then do:
            next mainloop.
        end.

        empty temp-table tt_tb.
        for each tsod_det where tsod_sel = "*" no-lock break by tsod_line :
            find first in_mstr where in_domain = global_domain
                   and in_site = site and in_part = tsod_part no-lock no-error.
            if not avail in_mstr then do:
               {gprun.i ""xxdycrtsiin.p""
                        "(input site,input tsod_part,output outrst)"}
            end.
            if first(tsod_line) then do:
                create tt_tb. assign tt_sel = 1 tt_f1 = "@@begin".
                create tt_tb.
                assign tt_sel = 2 tt_f1 = sonbr + "," + cust + "," + shipto.
                if not avail so_mstr then do:
                    create tt_tb.
                    assign tt_sel = 3
                           tt_f1 = string(today) + " " + string(reqdate)
                                 + " - " + string(reqdate) + " - " + " - "
                                 + " - " +  part + " - " + " - " + site + " "
                                 + xxchannel + " - - " + curr.
                end.
                else do:
                    create tt_tb. assign    tt_sel = 3 tt_f1 = "-".
                end.
            end.
            create tt_tb.
            assign tt_sel = 4
                   tt_f1 =  """" + """" + "," + tsod_part + ","
                         + string(tsod_qty) + "," + string(tsod_price)
                   tt_recid = recid(xtsod_det).
            if last(tsod_line) then do:
                create tt_tb. assign tt_sel = 4 tt_f1 =  "@@end" .
            end.
        end.

        pause 0.
        find first tt_tb no-lock no-error.
        if avail tt_tb then
        {gprun.i ""xxk1drsosomt.p""}

        find first so_mstr where so_domain = global_domain and so_nbr = sonbr
             no-lock no-error.
        if avail so_mstr then do:
            empty temp-table tt_tb.
            create tt_tb.
            assign tt_sel = 1 tt_f1 = "@@begin".
            create tt_tb.
            assign tt_sel = 2 tt_f1 = sonbr + "," + so_cust + "," + so_ship.
            create tt_tb.
            assign tt_sel = 4 tt_f1 = "@@end" .
            {gprun.i ""xxk1drsosomt.p""}
        end.
    end.
end. /* Mainloop */

procedure dispmv:
    define input parameter iptpart like pt_part.
    find first cd_det where cd_domain = global_domain and cd_ref = iptpart
         no-lock no-error.
    if avail cd_det then do:
      xxcmmt[1] = cd_cmmt[1].
      xxcmmt[2] = cd_cmmt[2].
      xxcmmt[3] = cd_cmmt[3].
      xxcmmt[4] = cd_cmmt[4].
      xxcmmt[5] = cd_cmmt[5].
  end.
    else xxcmmt = "".
    disp xxcmmt with frame c.
end procedure.
