/*xxbcrp001.p 按半成品工单下达日期打印半成品条码                                */
/* REVISION: 1.0         Last Modified: 2010/03/05  By: Roger   ECO:*100305.1*  */
/*-Revision end-----------------------------------------------------------------*/

{mfdtitle.i "100305.1"} 
define var effdate   like wo_rel_date .
define var effdate1  like wo_rel_date  .
define var part      like pt_part.
define var part1     like pt_part.
define var wolot     like wo_lot.
define var wolot1    like wo_lot.
define var buyer     like pt_buyer .

define var wsection      as char . /*for barcode print*/
define var ts9130        as char . /*for barcode print*/
define var av9130        as char . /*for barcode print*/




FORM 
    buyer       colon 20 
    effdate     colon 20 
    effdate1    colon 49 label {t001.i} 
    part        colon 20
    part1       colon 49 label {t001.i} 
    wolot       colon 20
    wolot1      colon 49 label {t001.i} 
    
    skip(3)         
with frame a attr-space side-labels width 80.


effdate = today .
effdate1 = today .

{wbrp01.i}
mainloop:
repeat:
    if part1 = hi_char then part1  = "".
    if wolot1 = hi_char then wolot1  = "".
    if effdate  = low_date then effdate = ? .
    if effdate1 = hi_date  then effdate1 = ? .

    update buyer effdate effdate1 part part1 wolot wolot1   with frame a.
    

    if part1 = "" then part1 = hi_char.
    if wolot1 = "" then wolot1 = hi_char.
    if effdate  = ? then effdate = low_date .
    if effdate1 = ? then effdate1 = hi_date .

    {mfselbpr.i "printer" 80}
    
printloop:
do on error undo,retry :

    for each pt_mstr where pt_buyer = buyer 
                     and   pt_part >= part and pt_part <= part1 
                     no-lock ,
        each wo_mstr use-index wo_part_rel 
                     where wo_part  = pt_part 
                     and (wo_rel_date >= effdate and wo_rel_date <= effdate1)
                     and wo_lot >= wolot and wo_lot <= wolot1  
                     no-lock :

            /*实际打印*/ 
            run print (input wo_part ).            

        
        {mfrpexit.i}
    end.  /*for each pt_mstr*/
    


end. /*printloop*/



{mfreset.i}
end. /*mainloop:*/



procedure print:
    define input parameter v_part  like pt_part.

    define variable labelspath as character format "x(100)" .

    find first code_mstr where code_fldname = "barcode" and code_value ="labelspath" no-lock no-error.
    if available(code_mstr) then labelspath = trim ( code_cmmt ).
    if substring(labelspath, length(labelspath), 1) <> "/" then labelspath = labelspath + "/".

    wsection    = "xswosn10" + trim ( string(year(today)) + string(month(today),'99') + string(day(today),'99'))  + trim(string(time)) + trim(string(random(1,100))) .

    input from value(labelspath + "xswosn10" ).
    output to value(trim(wsection) + ".l") .
       repeat:
          import unformatted ts9130.

          if index(ts9130, "$p") <> 0 then do:
             av9130 = v_part.
             ts9130 = substring(ts9130, 1, index(ts9130 , "$p") - 1) + av9130 
                    + substring( ts9130 , index(ts9130 ,"$p") 
                    + length("$p"), length(ts9130) - ( index(ts9130 , "$p") + length("$p") - 1 ) ).
          end.


          put unformatted ts9130 skip.
       end.

    input close.
    output close.

    unix silent value ("chmod 777  " + trim(wsection) + ".l").

    find first prd_det where prd_dev = trim(dev) no-lock no-error.
    if available prd_det then do:
        unix silent value (trim(prd_path) + trim(wsection) + ".l").
        unix silent value ("rm " + trim(wsection) + ".l").
    end.
end. /*procedure*/



