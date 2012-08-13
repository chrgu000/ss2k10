/***************************************************
* Program: aocmlog.i
* Author : Li Wei
* Date   : 2005-7-15
* Description: Create the Log record in the 
* temporary table
* {1} as character, input file id
* {2} as character, cimload group, 
*      if not cimload group available you 
*      can use any value.
* {3} as character, error description
***************************************************/
     
     create cim_mstr.
     assign 
     cim_fileid = {1}
     cim_group  = {2}
     cim_desc   = {3}
     cim_date   = today
     cim_time   = string(time,"HH:MM:SS")
     cim_usrid  = global_userid. 
     if {2} <> "00" then
     cim_line   = string(int({2}) - int(Last_bdl_id)).
     release cim_mstr.