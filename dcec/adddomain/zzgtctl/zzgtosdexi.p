/* zzgtosdexi.p - GENERAL PROCEDURE TO CHECK WHETHER OUTPUT DESTINATION EXISTS  */
/* COPYRIGHT qad.inc./Origin -  ALL RIGHTS RESERVED                           */
/*                                                                            */
/* REVISION: 7.3       CREATED: 20feb96  BY: PKR SRS: CR3658 CD: 540  REV: 01 */
/* REVISION: 7.3 LAST MODIFIED: __/__/__ BY: ___ SRS: ______ CD: ____ REV: __ */

def input  param    ip_output_dest      as char format "x(80)"          no-undo.
def output param    op_output_ok        as logi                                .

def var             l_output_file       as char                         no-undo.

def stream ls_output.


if opsys = "unix" then do:
  assign l_output_file = "TMP" + string(time,"99999") + "." +
			 string(random(0,999),"999").
  output to value(l_output_file) no-echo.
  input from /dev/null.
  do transaction on error undo,leave:
    assign op_output_ok = yes.
    output stream ls_output to value(ip_output_dest) no-echo.
  end.
  output stream ls_output close.
  input close.
  output close.
  {zzgtosfdel.i &filen = l_output_file }
  {zzgtosfdel.i &filen = ip_output_dest}
end.
else
if opsys = "win32" then do:
  assign l_output_file = "TMP" + string(time,"99999") + "." + string(random(0,999),"999").
  output to value(l_output_file) no-echo.
  disp "dammy".
  do transaction on error undo,leave:
    assign op_output_ok = yes.
    output stream ls_output to value(ip_output_dest) no-echo.
  end.
  output stream ls_output close.
  input close.
  output close.
  {zzgtosfdel.i &filen = l_output_file }
  {zzgtosfdel.i &filen = ip_output_dest}
end.
