FUNCTION chkPeriod RETURNS integer (iPrid as character):
    define variable i as integer initial 0.
    if (int(substring(iprid,1,4)) <= year(today) - 5) or
       (int(substring(iprid,1,4)) > year(today)) then do:
       assign i = 3008.
    end.
    if int(substring(iprid,5,2)) <= 0 or
       int(substring(iprid,5,2)) >= 13 then do:
       assign i = 495.
    end.
    return i.
END FUNCTION.

FUNCTION getPeriod RETURNS CHARACTER:
DEFINE VARIABLE vdate AS date.
   ASSIGN vdate = date(month(today),1,year(today)) - 1.
   RETURN string(year(vdate),"9999") + string(month(vdate),"99").
END FUNCTION.

Function getNextPeriod returns character(iPeriod as character):
    define variable prd as character.
    define variable dte as date.
    assign dte = date(int(substring(iperiod,5,2))
                      ,1,int(substring(iperiod,1,4))) + 32.
    if dte = ? then assign dte = today.
    assign prd = string(year(dte),"9999") + string(month(dte),"99").
    return prd.
end function.

Function getPervPeriod returns character(iperiod as character):
    define variable prd as character.
    define variable dte as date.
    assign dte = date(int(substring(iperiod,5,2))
                      ,1,int(substring(iperiod,1,4))) - 1.
    if dte = ? then assign dte = today.
    message dte view-as alert-box.
    assign prd = string(year(dte),"9999") + string(month(dte),"99").
    return prd.
end function.

Function getEnddayofmonth returns date(iperiod as character):
    define variable dte as date.
    assign dte = date(int(substring(iperiod,5,2))
                      ,1,int(substring(iperiod,1,4))) + 32.
    assign dte = dte - day(dte).
    return dte.
end.

Function get1stdayofmonth returns date(iperiod as character):
    define variable dte as date.
    assign dte = date(int(substring(iperiod,5,2))
                      ,1,int(substring(iperiod,1,4))).
    return dte.
end.
