/* mfoutexi.p - GENERAL PROCEDURE TO CHECK WHETHER OUTPUT DESTINATION EXISTS  */
/* COPYRIGHT qad.inc./Origin -  ALL RIGHTS RESERVED                           */
/*CR7771*/ /*V8:ConvertMode=NoConvert*/
/*                                                                            */
/* REVISION: 7.3       CREATED: 20feb96  BY: PKR SRS: CR3658 CD: 540  REV: 01 */
/* REVISION: 8.5eLAST MODIFIED: 16oct97  BY: kdh SRS: CR7771                  */
 
def input  param    ip_output_dest      as char format "x(80)"          no-undo.
def output param    op_output_ok        as logi                                .
 
def var             l_output_file       as char                         no-undo.
 
def stream ls_output.

if opsys = "unix" then do:
  assign l_output_file = "TMP" + string(time,"99999") + "." +
                         string(random(0,999),"999").
  output to value(l_output_file) no-echo.
  input from /dev/null.
end.                                                           /*CR7771*/  
else if opsys = "msdos" or opsys = "win32" then do:            /*CR7771*/
  assign l_output_file = "TM" + string(time,"99999") + "." +   /*CR7771*/
                         string(random(0,999),"999").          /*CR7771*/
  output to value(l_output_file) no-echo.                      /*CR7771*/
  input from "nul".                                            /*CR7771*/
end.                                                           /*CR7771*/
else if opsys = "vms" then do:                                 /*CR7771*/
  assign l_output_file = "TMP" + string(time,"99999") + "." +  /*CR7771*/
                         string(random(0,999),"999").          /*CR7771*/
  output to value(l_output_file) no-echo.                      /*CR7771*/
  input from "nl:".                                            /*CR7771*/
end.                                                           /*CR7771*/  
  
do transaction on error undo,leave:
  assign op_output_ok = yes.
  output stream ls_output to value(ip_output_dest) no-echo.
end.
output stream ls_output close.
input close.
output close.
/* {osdelete.i &filen = l_output_file }                         *CR7771*/
/* {osdelete.i &filen = ip_output_dest}                         *CR7771*/
os-delete value(l_output_file).                                 /*CR7771*/
os-delete value(ip_output_dest).                                /*CR7771*/


/* end.                                                         *CR7771*/
