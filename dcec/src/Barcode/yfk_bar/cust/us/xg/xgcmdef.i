/******************************************
* Program: aostdcm.i
* Author : Li Wei
* Date   : 2005-7-15
* Description : Define the shared table
******************************************/


/*CimLoad Log Table*/
define {1} shared temp-table cim_mstr no-undo
   field cim_fileid as character format "x(20)" label "File ID"
   field cim_group  as character label "Cim Grp ID"
   field cim_line   as character label "Data Line"
   field cim_desc   as character format "x(80)" label "Message"
   field cim_date   as date label "Date"
   field cim_time   as character label "Time"
   field cim_usrid  as character label "User"
   index cim_fileid is primary 
   cim_fileid asc.
