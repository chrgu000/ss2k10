/* SS - 100704.1 By: Kaine Zhang */

/* SS - 100704.1 - RNB
[100704.1]
库存收发明细报表.
ref # 0440.库存收发明细报表.docx
ref # 20100704.何红宇邮件.
[100704.1]
SS - 100704.1 - RNE */

{mfdtitle.i "120703.1"}

define variable dteA as date no-undo.
define variable dteB as date no-undo.
define variable sSite like ld_site no-undo.
define variable sLocA like ld_loc no-undo.
define variable sLocB like ld_loc no-undo.
define variable sPartA like ld_part no-undo.
define variable sPartB like ld_part no-undo.
define variable sType as character format "x(1)" no-undo.
define variable sDeptDesc as character no-undo.
define variable sUmDesc as character no-undo.
define variable sUserName as character no-undo.

define variable sWoPart as character no-undo.
define variable sVendorID as character no-undo.
define variable sVendorName as character no-undo.
define variable sBuyerID as character no-undo.
define variable sBuyerName as character no-undo.
define variable sTypeDesc as character no-undo.

form
    dteA    colon 15    label "生效日期"
    dteB    colon 45    label "至"
    sSite   colon 15    label "地点"
    sLocA   colon 15    label "库位"
    sLocB   colon 45    label "至"
    sPartA  colon 15    label "物料"
    sPartB  colon 45    label "至"
    stype   colon 15 "*(全部)"
    skip(2)
with frame a side-labels width 80.
setframelabels(frame a:handle).

find first si_mstr
    no-lock
    where si_domain = global_domain
    no-error.
if available(si_mstr) then sSite = si_site.
display sSite with frame a.




{wbrp01.i}
repeat on endkey undo, leave:
    if dteA = low_date then dteA = ?.
    if dteB = hi_date then dteB = ?.
    if sLocB = hi_char then sLocB = "".
    if sPartB = hi_char then sPartB = "".

    if c-application-mode <> 'web' then
        update
            dteA
            dteB
            sSite
            sLocA
            sLocB
            sPartA
            sPartB
            stype
        with frame a .

    {wbrp06.i
        &command = update
        &fields = "
            dteA
            dteB
            sSite
            sLocA
            sLocB
            sPartA
            sPartB
            stype
            "
        &frm = "a"
    }



    if (c-application-mode <> 'web')
        or (c-application-mode = 'web' and (c-web-request begins 'data'))
    then do:
        bcdparm = "".
        {mfquoter.i dteA   }
        {mfquoter.i dteB   }
        {mfquoter.i sSite     }
        {mfquoter.i sLocA     }
        {mfquoter.i sLocB     }
        {mfquoter.i sPartA     }
        {mfquoter.i sPartB     }
        {mfquoter.i stype     }

        if dteA = ? then dteA = low_date.
        if dteB = ? then dteB = hi_date.
        if sLocB = "" then sLocB = hi_char.
        if sPartB = "" then sPartB = hi_char.
    end.

    /* output destination selection */
    {gpselout.i
        &printtype = "printer"
        &printwidth = 132
        &pagedflag = " "
        &stream = " "
        &appendtofile = " "
        &streamedoutputtoterminal = " "
        &withbatchoption = "yes"
        &displaystatementtype = 1
        &withcancelmessAge = "yes"
        &pagebottommargin = 6
        &withemail = "yes"
        &withwinprint = "yes"
        &definevariables = "yes"
    }


    put
        unformatted
        "ExcelFile;mfgrp30" at 1
        "SaveFile;"
            + string(today, "99999999")
            + replace(string(time, "HH:MM:SS"), ":", "")
            + "mfgrp30" at 1
        "BeginRow;1" at 1
        .

    put unformatted
        "生效日期;部门;仓库;物料;名称;规格;单位;批号;数量;单号;ID;类别;生产物料;供应商;供应商名称;采购员;采购员名称;事务类型;事务类型说明;事务备注;用户" at 1
        .

    for each tr_hist
        no-lock
        where tr_domain = global_domain
            and tr_effdate >= dteA
            and tr_effdate <= dteB
            and tr_part >= sPartA
            and tr_part <= sPartB
            and tr_site = sSite
            and tr_loc >= sLocA
            and tr_loc <= sLocB
            and tr_qty_loc <> 0
            and (tr_ship_type = stype or stype = "*")
        use-index tr_eff_trnbr
    :
        find first dpt_mstr
            no-lock
            where dpt_domain = global_domain
                and dpt_dept = tr__chr01
            no-error.
        sDeptDesc = if available(dpt_mstr) then dpt_desc else "".

        {xxgetcodedesc.i ""pt_um"" tr_um sUmDesc}
        {xxgetcodedesc.i ""ss_20100704_001"" tr_type sTypeDesc}


        find first usr_mstr
            no-lock
            where usr_userid = tr_userid
            no-error.
        sUserName = if available(usr_mstr) then usr_name else "".

        assign
            sWoPart = ""
            sVendorID = ""
            sVendorName = ""
            sBuyerID = ""
            sBuyerName = ""
            .
        if tr_type = "ISS-WO" then do:
            find first wo_mstr
                no-lock
                where wo_domain = global_domain
                    and wo_lot = tr_lot
                no-error.
            if available(wo_mstr) then sWoPart = wo_part.
        end.
        else if tr_type = "RCT-PO" or tr_type = "ISS-PRV" then do:
            find first po_mstr
                no-lock
                where po_domain = global_domain
                    and po_nbr = tr_nbr
                no-error.
            if available(po_mstr) then do:
                assign
                    sVendorID = po_vend
                    sBuyerID = po_buyer
                    .
                find first vd_mstr
                    no-lock
                    where vd_domain = global_domain
                        and vd_addr = sVendorID
                    no-error.
                if available(vd_mstr) then sVendorName = vd_sort.
                {xxgetcodedesc.i "po_buyer" sBuyerID sBuyerName}
            end.
        end.

        find first pt_mstr
            no-lock
            where pt_domain = tr_domain
                and pt_part = tr_part
            no-error.

        put
            unformatted
            tr_effdate at 1 ";"
            sDeptDesc ";"
            tr_loc ";"
            tr_part ";"
            (if available(pt_mstr) then pt_desc1 else "") ";"
            (if available(pt_mstr) then pt_desc2 else "") ";"
            sUmDesc ";"
            tr_serial ";"
            tr_qty_loc ";"
            tr_nbr ";"
            tr_lot ";"
            tr_ship_type ";"
            sWoPart ";"
            sVendorID ";"
            sVendorName ";"
            sBuyerID  ";"
            sBuyerName ";"
            tr_type   ";"
            sTypeDesc ";"
            tr_rmks ";"
            sUserName
            .
    end.



    {xxmfreset.i}
  {mfgrptrm.i}
end.
{wbrp04.i &frame-spec = a}










