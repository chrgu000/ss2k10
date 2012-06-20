
/* xxrepkrp0.p - REPETITIVE PICKLIST report                                  */
/*V8:ConvertMode=FullGUIReport                                               */
/* REVISION: 0CYH LAST MODIFIED: 05/30/11   BY: zy                           */
/* Environment: Progress:9.1D   QAD:eb2sp4    Interface:Character            */
/*-revision end--------------------------------------------------------------*/

/*注:产生取料单,配送单的excle宏文件在..\..\showa\xxicstrp\xxicstrp.xla       */

{mfdtitle.i "120620.1"}

/* {xxtimestr.i}  */
define variable site   like si_site no-undo.
define variable site1  like si_site no-undo.
define variable line   like ln_line no-undo.
define variable line1  like ln_line no-undo.
define variable ln     as   integer no-undo.
define variable ln1    as   integer no-undo.
define variable part   like pt_part no-undo. /* initial "MHTA03-N60-0-CK". */
define variable part1  like pt_part no-undo. /* initial "MHTA03-N60-0-CK". */
define variable issue   as date no-undo initial today.
define variable issue1  as date no-undo initial today.
define variable nbr  as character format "x(12)" label "Picklist Number".
define variable nbr1 as character format "x(12)".
define variable cate as character format "x(1)" initial "A".
define variable vMultiple like pt_ord_mult label "Order_Multiple".
define variable vtype  as character format "x(2)" label "ABC_ALLOCATE".
define variable vdesc1 like pt_desc1.
define variable pnbr like xxwa_nbr.
define variable vqty  as decimal no-undo.
define variable tax_bonded as logical no-undo.
define variable del-yn   as logical no-undo.
define variable startTime as integer no-undo.
define variable endTime as integer no-undo.
find first usrw_wkfl no-lock where usrw_key1 = "xxrepkup0.p.param.ref" and
           usrw_key2 = global_userid no-error.
if available usrw_wkfl then do:
assign issue = usrw_datefld[1]
       issue1 = usrw_datefld[1].
end.

/* SELECT FORM */
form
   site   colon 20
   site1  label {t001.i} colon 50 skip
   line   colon 20
   line1  label {t001.i} colon 50 skip
   ln     colon 20
   ln1    label {t001.i} colon 50 skip
   part   colon 20
   part1  label {t001.i} colon 50 skip
   issue  colon 20
   issue1  label {t001.i} colon 50 skip
   nbr    colon 20
   nbr1   label {t001.i} colon 50 skip(1)
   cate   colon 20 skip
   tax_bonded  colon 20 skip(1)
   del-yn    colon 20 skip(2)

with frame a side-labels width 80.
/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* REPORT BLOCK */
{wbrp01.i}
repeat:
    if site1 = hi_char then site1 = "".
    if line1 = hi_char then line1 = "".
    if nbr1 = hi_char then nbr1 = "".
    if part1 = hi_char then part1 = "".
    if ln1   = 999999 then ln1 = 0.
    if issue = low_date then issue = ?.
    if issue1 = hi_date then issue1 = ?.

if c-application-mode <> 'web' then
update site site1 line line1 ln ln1 part part1 issue issue1 nbr nbr1
       cate tax_bonded del-yn
       with frame a.
if index("APS",cate) = 0 then do:
    {mfmsg.i 4212 3}
    undo,retry.
end.
{wbrp06.i &command = update
          &fields = " site site1 line line1 ln ln1 part part1 issue issue1
                      nbr nbr1 cate tax_bonded del-yn"
          &frm = "a"}

if (c-application-mode <> 'web') or
(c-application-mode = 'web' and
(c-web-request begins 'data')) then do:

   bcdparm = "".
   {mfquoter.i site}
   {mfquoter.i site1}
   {mfquoter.i line}
   {mfquoter.i line1}
   {mfquoter.i ln1}
   {mfquoter.i part}
   {mfquoter.i part1}
   {mfquoter.i nbr}
   {mfquoter.i nbr1}
   {mfquoter.i issue}
   {mfquoter.i issue1}

   site1 = site1 + hi_char.
   line1 = line1 + hi_char.
   part1 = part1 + hi_char.
   nbr1 = nbr1 + hi_char.
   if issue = ? then issue = low_date.
   if issue1 = ? then issue1 = hi_date.
   if ln1 = 0 then ln1 = 999999.

end.
        /* SELECT PRINTER  */
{gpselout.i &printtype = "printer"
            &printwidth = 132
            &pagedflag = "nopage"
            &stream = " "
            &appendtofile = " "
            &streamedoutputtoterminal = " "
            &withbatchoption = "yes"
            &displaystatementtype = 1
            &withcancelmessage = "yes"
            &pagebottommargin = 6
            &withemail = "yes"
            &withwinprint = "yes"
            &definevariables = "yes"}
/*     {mfphead.i}    */
mainloop:
do on error undo, return error on endkey undo, return error:
  export delimiter "~011" ""
         "xxrepkrp0.p" "" "" ""
         getTermLabel("P_I_C_K_U_P_S_E_N_D_P_R_I_N_T",30).
  export delimiter "~011"
         getTermLabel("Type",12)
         getTermLabel("NUMBER",12)
         getTermLabel("PRODUCTION_LINE",12)
         getTermLabel("PRODUCTION_HOURS",12)
         getTermLabel("START",12)
         getTermLabel("END",12)
         getTermLabel("Serial",12)
         getTermLabel("PICKLIST_NUMBER",12)
         getTermLabel("ITEM_NUMBER",12)
         getTermLabel("DESCRIPTION",12)
         getTermLabel("PLAN_CUM_QTY",12)
         getTermLabel("Order_Multiple",12)
         getTermLabel("ABC_CLASS",12)
         getTermLabel("QTY_PLANNED",12)
         getTermLabel("LOCATION",12)
         getTermLabel("LOT/SERIAL",12)
         getTermLabel("ISSUED",12)
         getTermLabel("STATUS",12)
         getTermLabel("Date",12)
         .

 for each xxwd_det no-lock where
          xxwd_site >= site and xxwd_site <= site1 and
          (xxwd_line >= line and xxwd_line <= line1) and
          (xxwd_sn >= ln and xxwd_sn <= ln1) and
          xxwd_part >= part and xxwd_part <= part1 and
          xxwd_date >= issue and xxwd_date <= issue1 and
          xxwd_nbr >= substring(nbr,2) and xxwd_nbr <= nbr1
          break by xxwd_type by xxwd_date by xxwd_time by xxwd_part:
       find first pt_mstr no-lock where pt_mstr.pt_part = xxwd_part no-error.
       if available pt_mstr then do:
          assign vMultiple = pt__qad19
                 vtype = pt__chr10
                 vdesc1 = pt_desc1.
       end.
       else do:
          assign vMultiple = 0
                 vtype = ""
                 vdesc1 = "".
       end.

       run print (input xxwd_part,
                  input (if xxwd_type = "S" then "P-ALL" else xxwd_loc),
                  input xxwd_lot,
                  input string(xxwd_date,"9999-99-99") + " " + string(xxwd__int02,"HH:MM:SS"),
                  input xxwd_type + xxwd_nbr,
                  input xxwd_qty_plan).
     export delimiter "~011"
            xxwd_type
            lower(xxwd_type) + xxwd_nbr
            xxwd_line
            string(xxwd_time,"hh:mm:ss")
            string(xxwd__int01,"hh:mm:ss")
            string(xxwd__int02,"hh:mm:ss")
            xxwd_sn
            substring(xxwd_ladnbr,9)
            xxwd_part
            vdesc1
            truncate(xxwd_qty_plan,0)
            vMultiple
            vtype
            truncate(xxwd_qty_plan,0)
            if xxwd_type = "s" then "P-ALL" else xxwd_loc
            xxwd_lot
            xxwd_qty_iss
            xxwd_stat
            xxwd_date.
end.

end.

 {mfreset.i}
end.  /* repeat: */

{wbrp04.i &frame-spec = a}

procedure getSEtime:
    define input parameter iType as character.
    define input parameter iSite as character.
    define input parameter iLine as character.
    define input parameter iRuntime as integer.
    define output parameter ostime as integer.
    define output parameter oetime as integer.
    find first xxlnw_det no-lock where xxlnw_site = isite and
              (xxlnw_line = iLine or iLine = "") and
               xxlnw_ptime = iRunTime no-error.
    if available xxlnw_det then do:
       if iType = "p" then do:
          assign ostime = xxlnw_pstime
                 oetime = xxlnw_petime.
       end.
       else do:
          assign ostime = xxlnw_sstime
                 oetime = xxlnw_setime.
       end.
    end.
end procedure.

procedure print:
    define input parameter vv_part  like pt_part.
    define input parameter vv_loc   like ld_loc.
    define input parameter vv_lot   like ld_lot.
    define input parameter vv_date  as character .
    define input parameter vv_nbr  as character.
    define input parameter vv_qty   like wo_qty_ord.

    define variable wsection as character.
    define variable ts9030 as character.
    define variable av9030 as character.
    define variable labelspath as character format "x(100)" init "/app/bc/labels/".

    find first code_mstr where code_fldname = "barcode" and code_value ="labelspath" no-lock no-error.
    if available(code_mstr) then labelspath = trim ( code_cmmt ).
    if substring(labelspath, length(labelspath), 1) <> "/" then labelspath = labelspath + "/".

    wsection    = "lap03" + trim ( string(year(today)) + string(month(today),'99') + string(day(today),'99'))  + trim(string(time)) + trim(string(random(1,100))) .

    input from value(labelspath + "lap03" ).
    output to value(trim(wsection) + ".l") .
       repeat:
          import unformatted ts9030.

          /*条码和条码下文字*/
          if index(ts9030, "&B") <> 0 then do:
             av9030 = trim(vv_part).
             ts9030 = substring(ts9030, 1, index(ts9030 , "&B") - 1) + av9030
                    + substring( ts9030 , index(ts9030 ,"&B")
                    + length("&B"), length(ts9030) - ( index(ts9030 , "&B") + length("&B") - 1 )).
          end.

          /*日期*/
          if index(ts9030, "$D") <> 0 then do:
             av9030 = vv_date.
             ts9030 = substring(ts9030, 1, index(ts9030 , "$D") - 1) + av9030
                    + substring( ts9030 , index(ts9030 ,"$D")
                    + length("$D"), length(ts9030) - ( index(ts9030 , "$D") + length("$D") - 1 )).
          end.

          /*数量*/
          if index(ts9030, "$Q") <> 0 then do:
             av9030 = string(vv_qty).
             ts9030 = substring(ts9030, 1, index(ts9030 , "$Q") - 1) + av9030
                    + substring( ts9030 , index(ts9030 ,"$Q")
                    + length("$Q"), length(ts9030) - ( index(ts9030 , "$Q") + length("$Q") - 1 )).
          end.

          /*批序号*/
          if index(ts9030, "$L") <> 0 then do:
             av9030 = trim(vv_lot).
             ts9030 = substring(ts9030, 1, index(ts9030 , "$L") - 1) + av9030
                    + substring( ts9030 , index(ts9030 ,"$L")
                    + length("$L"), length(ts9030) - ( index(ts9030 , "$L") + length("$L") - 1 )).
          end.

          /*库位*/
          if index(ts9030, "$C") <> 0 then do:
             av9030 = string(vv_loc).
             ts9030 = substring(ts9030, 1, index(ts9030 , "$C") - 1) + av9030
                    + substring( ts9030 , index(ts9030 ,"$C")
                    + length("$C"), length(ts9030) - ( index(ts9030 , "$C") + length("$C") - 1 )).
          end.

          /*单据号*/
          if index(ts9030, "$O") <> 0 then do:
             av9030 = vv_nbr.
             ts9030 = substring(ts9030, 1, index(ts9030 , "$O") - 1) + av9030
                    + substring( ts9030 , index(ts9030 ,"$O")
                    + length("$O"), length(ts9030) - ( index(ts9030 , "$O") + length("$O") - 1 )).
          end.
          /*料号*/
          if index(ts9030, "$P") <> 0 then do:
             av9030 = vv_part.
             ts9030 = substring(ts9030, 1, index(ts9030 , "$P") - 1) + av9030
                    + substring( ts9030 , index(ts9030 ,"$P")
                    + length("$P"), length(ts9030) - ( index(ts9030 , "$P") + length("$P") - 1 )).
          end.
          /*料号说明1*/
          if index(ts9030, "$F") <> 0 then do:
            find first pt_mstr where pt_part = vv_part  no-lock no-error.
            If AVAILABLE ( pt_mstr )  then
            av9030 = trim(pt_desc1).

             ts9030 = substring(ts9030, 1, index(ts9030 , "$F") - 1) + av9030
                    + substring( ts9030 , index(ts9030 ,"$F")
                    + length("$F"), length(ts9030) - ( index(ts9030 , "$F") + length("$F") - 1 )).
          end.
          /*料号说明2*/
          if index(ts9030, "$E") <> 0 then do:
            find first pt_mstr where pt_part = vv_part  no-lock no-error.
            If AVAILABLE ( pt_mstr )  then
            av9030 = trim(pt_desc2).

             ts9030 = substring(ts9030, 1, index(ts9030 , "$E") - 1) + av9030
                    + substring( ts9030 , index(ts9030 ,"$E")
                    + length("$E"), length(ts9030) - ( index(ts9030 , "$E") + length("$E") - 1 )).
          end.
          /*料号单位*/
          if index(ts9030, "$U") <> 0 then do:
            find first pt_mstr where pt_part = vv_part  no-lock no-error.
            If AVAILABLE ( pt_mstr )  then
            av9030 = pt_um .

             ts9030 = substring(ts9030, 1, index(ts9030 , "$U") - 1) + av9030
                    + substring( ts9030 , index(ts9030 ,"$U")
                    + length("$U"), length(ts9030) - ( index(ts9030 , "$U") + length("$U") - 1 )).
          end.
          /*检验OK*/
          if index(ts9030, "&R") <> 0 then do:
             /*av9030 = /*if trim ( V1520 ) = "Y" then "受检章" else*/ "检验OK" . */
             av9030 = if substring(vv_nbr,1,1) = "P" then "取料" else "配送".
             ts9030 = substring(ts9030, 1, index(ts9030 , "&R") - 1) + av9030
                    + substring( ts9030 , index(ts9030 ,"&R")
                    + length("&R"), length(ts9030) - ( index(ts9030 , "&R") + length("&R") - 1 )).
          end.

          put unformatted ts9030 skip.
       end.

    input close.
    output close.

    unix silent value ("chmod 777  " + trim(wsection) + ".l").

    find first prd_det where prd_dev = trim(dev) no-lock no-error.
    if available prd_det then do:
        unix silent value (trim(prd_path) + " " + trim(wsection) + ".l").
        unix silent value ("rm " + trim(wsection) + ".l").
    end.
end. /*procedure*/
