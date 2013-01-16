

procedure print:
/* copy from xxbcrp001.p*/
    define input parameter vv_part  like pt_part.
    define input parameter vv_loc   like ld_loc.
    define input parameter vv_lot   like ld_lot.
    define input parameter vv_date  as date .
    define input parameter vv_nbr   like pt_part.
    define input parameter vv_qty   like wo_qty_ord.

    define var wsection as char . /*for barcode print*/
    define var ts9030   as char . /*for barcode print*/
    define var av9030   as char . /*for barcode print*/
    define variable v_invnbr as character.
    define variable labelspath as character format "x(100)" init "/app/bc/labels/".
    find first code_mstr where code_fldname = "barcode" and code_value ="labelspath" no-lock no-error.
    if available(code_mstr) then labelspath = trim ( code_cmmt ).
    if substring(labelspath, length(labelspath), 1) <> "/" then labelspath = labelspath + "/".

    wsection    = "lap03" + trim ( string(year(today)) + string(month(today),'99') + string(day(today),'99'))  + trim(string(time)) + trim(string(random(1,100))) .

    assign v_invnbr = trim(substring(vv_nbr,1,index(vv_nbr,"No.") - 1)).
    input from value(labelspath + "lap03" ).
    output to value(trim(wsection) + ".l") .
       repeat:
          import unformatted ts9030.

          /*条码和条码下文字*/
          if index(ts9030, "&B") <> 0 then do:
             av9030 = trim(vv_part) + "@" + trim(vv_lot) .
             ts9030 = substring(ts9030, 1, index(ts9030 , "&B") - 1) + av9030
                    + substring( ts9030 , index(ts9030 ,"&B")
                    + length("&B"), length(ts9030) - ( index(ts9030 , "&B") + length("&B") - 1 )).
          end.

          /*日期*/
          if index(ts9030, "$D") <> 0 then do:
             av9030 = string(vv_date) .
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
             av9030 = substring(vv_lot,1,6) + "/" + substring(vv_lot,7,4).
             ts9030 = substring(ts9030, 1, index(ts9030 , "$L") - 1) + av9030
                    + substring( ts9030 , index(ts9030 ,"$L")
                    + length("$L"), length(ts9030) - ( index(ts9030 , "$L") + length("$L") - 1 )).
          end.
          /*库位-实际条码打印发票号*/
          if index(ts9030, "库位") <> 0 then do:
             av9030 = "发票".
             ts9030 = substring(ts9030, 1, index(ts9030 , "库位") - 1) + av9030
                    + substring( ts9030 , index(ts9030 ,"库位")
                    + length("库位"), length(ts9030) - ( index(ts9030 , "库位") + length("库位") - 1 )).
          end.

          if index(ts9030, "$C") <> 0 then do:
             av9030 = string(v_invnbr).
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
             av9030 = /*if trim ( V1520 ) = "Y" then "受检章" else*/ "检验OK" .
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
