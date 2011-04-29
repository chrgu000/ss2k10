/*xxporp001.p     */
/* REVISION: 110314.1   Created On: 20110314   By: Softspeed Roger Xiao                               */
/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 110314.1  By: Roger Xiao */
/*-Revision end---------------------------------------------------------------*/




/******
Public Sub Query_BeforeRefreshData(nMaxRows As Long, bCancel As Boolean)
	params = """date_from=" & Query.Param("date_from") & ";vend_from=" & Query.Param("vend_from")& ";vend_to=" & Query.Param("vend_to")& """"
	prg = "C:\qadguicli\bicallprogress\xxporp001.p"
	cmd = """C:\Program Files\PROGRESS\bin\prowin32.exe"" mfgprod -b -ld qaddb -H 192.168.0.92 -S mfgprod -N TCP -d ymd"
	cmdline = cmd & " -param " & params & " -p " & prg
	hr = App.RunAndWait(cmdline, False)

	If(hr < 0) Then
		App.ShowMsg(hr)
		bCancel = True
	End If

End Sub
*******/


function getfield returns character (input src as char, input idx as int, input deli as char).
    def var val as char.
    def var startpos as int.
    def var findpos as int.
    def var i as int.

    startpos = 1.
    i = 0.
    repeat while(i <= idx):
      findpos = index(src, deli, startpos).
      if(findpos = 0 and i < idx) then
        return "".

      if(i < idx) then
        startpos = findpos + 1.

      i = i + 1.
    end.

    if(findpos = 0) then
      val = substring(src, startpos).
    else
      val = substring(src, startpos, findpos - startpos).

    return val.

end function.

function getparam returns char (input pname as char).
    def var str as char.
    def var str1 as char.
    def var str2 as char.
    def var i as int.

    i = 0.
    repeat while true:
        str = getfield(session:parameter, i, ";").
        if(str = "") then
            return "".

        str1 = getfield(str, 0, "=").
        str1 = trim(str1).
        if(str1 = pname) then do:
            str2 = getfield(str, 1, "=").
            trim(str2).
            return str2.
        end.
        
        i = i + 1.
    end.

    return "".
    
end function.


function todate returns date (input datestring as char).
    def var stryear as char.
    def var strmonth as char.
    def var strday as char.
    def var findpos as int.

    stryear = getfield(datestring, 0,"-").
    strmonth = getfield(datestring, 1, "-").
    strday = getfield(datestring, 2, "-").

    return date(integer(strmonth), integer(strday), integer(stryear)).

end function.




define var v_qty_today like pod_qty_rcvd .

define var date_from       like prh_rcp_date no-undo.
define var vend_from       like po_vend no-undo.
define var vend_to         like po_vend no-undo.




date_from = todate(GetParam("date_from")).
vend_from = GetParam("vend_from").
vend_to   = GetParam("vend_to").


define temp-table temp1 
    field t1_nbr         like po_nbr 
    field t1_newnbr      like po_nbr 
    field t1_due_date    like pod_due_date
    field t1_line        like pod_line
    field t1_part        like pod_part 
    field t1_vend        like po_vend 
    field t1_pt_draw     like pt_draw 
    field t1_pt_Desc     like pt_Desc1 
    field t1_qty_ord     like pod_qty_ord
    field t1_qty_rct     like pod_qty_rcvd
    field t1_qty_today   like pod_qty_rcvd
    field t1_qty_left    like pod_qty_rcvd
    field t1_userid      like tr_userid
    field t1_vdname      like ad_name
    field t1_buyer       like po_buyer
    .                    

for each po_mstr 
        use-index po_vend
        where po_vend >= vend_from and po_vend <= vend_to 
        and po_vend begins "J" /*日供*/
        and po_stat = "" 
        no-lock,
    each pod_det 
        where pod_nbr = po_nbr 
        and pod_status = "" 
        and pod_qty_ord > pod_qty_rcvd 
    no-lock:

    find first pt_mstr where pt_part = pod_part no-lock no-error.
    find first ad_mstr where ad_addr = po_vend and ad_type = "supplier" no-lock no-error.
    

    find first temp1 
        where t1_nbr = pod_nbr
        and   t1_line  = pod_line 
    no-error.
    if not avail temp1 then do:
        create temp1.
        assign  t1_nbr       = pod_nbr   
                t1_newnbr    = if pod_so_job = "AC" then pod_nbr + "(*)" else pod_nbr 
                t1_due_date  = pod_due_date
                t1_line      = pod_line
                t1_part      = pod_part
                t1_vend      = po_Vend
                t1_pt_draw   = if avail pt_mstr then pt_draw  else "" 
                t1_pt_Desc   = if avail pt_mstr then pt_desc1 else "" 
                t1_qty_ord   = pod_qty_ord
                t1_qty_rct   = pod_qty_rcvd 
                t1_qty_today = 0
                t1_qty_left  = t1_qty_ord - t1_qty_rct
                t1_userid    = "" 
                t1_vdname    = if avail ad_mstr then ad_name else ""
                t1_buyer     = po_buyer
                .
    end.
end.  /*for each po_mstr*/


for each prh_hist 
    use-index prh_rcp_date
    where prh_rcp_date = date_from
    and prh_vend  >= vend_from and prh_vend <= vend_to 
    no-lock
    break by prh_rcp_date by prh_vend by prh_nbr by prh_line :
    
    if first-of(prh_line) then do:
        v_qty_today = 0 .
    end.

    v_qty_today = v_qty_today + prh_rcvd .

    if last-of(prh_line) then do:

        find first pt_mstr where pt_part = prh_part no-lock no-error.
        find first pod_Det where pod_nbr = prh_nbr and pod_line = prh_line no-lock no-error.
        find first ad_mstr where ad_addr = prh_vend and ad_type = "supplier" no-lock no-error.

        find first tr_hist
            use-index tr_nbr_eff
            where   tr_nbr = prh_nbr 
            and tr_effdate = prh_rcp_date
            and tr_line  = prh_line 
            and tr_part  = prh_part
            and tr_lot   = prh_receiver 
            and tr_type  = "rct-po"
        no-lock no-error.


        find first temp1 
            where t1_nbr   = prh_nbr
            and   t1_line  = prh_line 
        no-error.
        if not avail temp1 then do:
            create temp1.
            assign  t1_nbr       = prh_nbr   
                    t1_newnbr    = if avail pod_det and pod_so_job = "AC" then prh_nbr + "(*)" else prh_nbr
                    t1_due_date  = if avail pod_det then pod_due_date else ?
                    t1_line      = prh_line
                    t1_part      = prh_part
                    t1_vend      = prh_vend
                    t1_pt_draw   = if avail pt_mstr then pt_draw  else "" 
                    t1_pt_Desc   = if avail pt_mstr then pt_desc1 else "" 
                    t1_qty_ord   = if avail pod_Det then pod_qty_ord else 0 
                    t1_qty_rct   = if avail pod_Det then pod_qty_rcvd else 0 
                    t1_vdname    = if avail ad_mstr then ad_name else ""
                    t1_userid    = if avail tr_hist then tr_userid else "" 
                    t1_buyer     = prh_buyer
                    t1_qty_left  = t1_qty_ord - t1_qty_rct 

                    .
        end.
        t1_qty_today = v_qty_today .


    end. /*if last-of(prh_line)*/
end.  /*for each prh_hist*/

output to "C:\qadguicli\bicallprogress\xxporp001.txt" .
    put unformatted 
         "收货日期;" 
         "供应商ID;" 
         "供应商Nm;" 
         "采购单号;" 
         "项次;"     
         "零件图号;" 
         "图纸图号;" 
         "零件名称;" 
         "采购员;"   
         "应到日期;" 
         "订购数量;" 
         "累计到货;" 
         "当日到货;" 
         "进度;"    
         "收货员;"   
        skip .



for each temp1 
    break by t1_vend by t1_nbr by t1_line :

    put unformatted 
        date_from     ";"    /*收货日期*/  
        t1_vend       ";"    /*供应商ID*/  
        t1_vdname     ";"    /*供应商Nm*/ 
        t1_newnbr     ";"    /*采购单号*/  
        t1_line       ";"    /*项次    */  
        t1_part       ";"    /*零件图号*/  
        t1_pt_draw    ";"    /*图纸图号*/  
        t1_pt_desc    ";"    /*零件名称*/  
        t1_buyer      ";"    /*采购员  */  
        t1_due_date   ";"    /*应到日期*/ 
        t1_qty_ord    ";"    /*订购数量*/  
        t1_qty_rct    ";"    /*累计到货*/  
        t1_qty_today  ";"    /*当日到货*/  
        t1_qty_left   ";"    /*进度    */  
        t1_userid     ";"    /*收货员  */  
        skip .

end. /* for each temp1 */

output close.


