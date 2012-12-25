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

input from value(ifile).
repeat:
	import unformat verr.
	if index(verr,getTermLabel("ERROR",12)) > 0 then do:
  	 oerr = substring(verr,index(verr,trim(getTermLabel("ERROR",12))) 
  	 										  + length(trim(getTermLabel("ERROR",12)),"RAW") - 1).
  	 leave.
  end.
end.
input close.
