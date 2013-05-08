/* xxgetcimerr.p - get cimload err information                               */
/*V8:ConvertMode=Maintenance                                                 */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION END                                                              */

 /* -----------------------------------------------------------
    Purpose: get cimload err information
    Parameters:
      iFile : cim_load output log file name
      oerr  : error information
    Notes:
  -------------------------------------------------------------*/

{mfdeclre.i}
{gplabel.i}
define input parameter ifile as character.
define output parameter oerr as character.

define variable verr as character.

assign verr = trim(getTermLabel("ERROR",24)).
if opsys = "unix" then do:
     input through grep -e verr value(ifile) 2> /dev/null no-echo.
end.
else if opsys = "msdos" or opsys = "win32" then do:
     input from value(ifile).
end.
repeat:
  import unformat verr.
  if index(verr,trim(getTermLabel("ERROR",24))) > 0 then do:
     if oerr = "" then
        oerr = trim(substring(verr,index(verr,trim(getTermLabel("ERROR",24)))
            + length(trim(getTermLabel("ERROR",24)),"RAW"))).
     else
        /*重复的错误只显示一次*/
        if index(oerr,trim(substring(verr,index(verr,trim(getTermLabel("ERROR",24)))
             + length(trim(getTermLabel("ERROR",24)),"RAW")))) = 0 then do:
           oerr = oerr + " ; " + trim(substring(verr,index(verr,trim(getTermLabel("ERROR",24)))
                + length(trim(getTermLabel("ERROR",24)),"RAW"))).
        end.
  end.
end.
input close.
assign oerr = replace(oerr,"请重新输入。","").