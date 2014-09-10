/* xxschld0.p - load temp-work file from csv file                             */

{mfdeclre.i}
{yyschld.i}
define variable i as integer.
define stream bf.
define variable vdtelst as character.
define variable vfile as character.

/****
 * define variable vc as character.
 * define variable old-dte-fmt as character.
 * empty temp-table xsch_data no-error.
 *
 * assign i = 1.
 * input from value(flhload).
 * repeat:
 *     create xsch_data.
 *     import unformat xsd_data.
 *     assign xsd_sn = i.
 *     assign i = i + 1.
 * end.
 * input close.
 *
 * /*get MaxEntry.*/
 * find first xsch_data no-lock where index(xsd_data,",") > 0 no-error.
 * if available xsch_data then do:
 *    assign vc = xsd_data
 *           maxEntry = 0.
 *    repeat while vc <> "":
 *       maxEntry = maxEntry + 1.
 *       if index(vc,",") > 0 then do:
 *          assign vc = substring(vc,index(vc,",") + 1).
 *       end.
 *       else do:
 *          assign vc = "".
 *       end.
 *    end.
 * end.
 *
 * old-dte-fmt = session:date-format.
 * session:date-format = 'mdy'.
 * for each xsch_data no-lock where xsd_sn = 1:
 *   do i = 5 to MaxEntry:
 *      message date(entry(i,xsd_data,",")) view-as alert-box.
 *   end.
 * end.
 * session:date-format = old-dte-fmt.
 ****/
assign vfile = "/mnt/hgfs/xrc/TMP_" + execname + string(today,"99999999") + string(time).
output stream bf to value(vfile + ".i.prn").
for each xsch_data no-lock:
    if xsd_sn = 1 then do:
       assign vdtelst = xsd_data.
    end.
    if xsd_sn >= 3 and xsd_chk = "" then do:
/* message reference
6001 激活该日程?
6007 自有效日程复制数据
*/    
       if cate = 1 then do:
          {yyschldf1.i}
       end.
       else if cate = 2 then do:
          {yyschldf2.i}
       end.
       else if cate = 3 then do:
          {yyschldf3.i}
       end.
    end.
end.
output stream bf close.