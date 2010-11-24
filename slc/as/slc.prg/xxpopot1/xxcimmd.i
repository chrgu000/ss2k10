/* By: neil Gao Date: 08/02/29 ECO: * ss 20080229 * */

cim:
DO:	

OUTPUT TO value("./ssi" + mfguser).

&if defined(dputline1) <> 0
&then
 put unformat {&putline1} skip.
&ENDIF
&if defined(dputline2) <> 0
&then
 put unformat {&putline2} skip.
&ENDIF
&if defined(dputline3) <> 0
&then
 put unformat {&putline3} skip.
&ENDIF
&if defined(dputline4) <> 0
&then
 put unformat {&putline4} skip.
&ENDIF
&if defined(dputline5) <> 0
&then
 put unformat {&putline5} skip.
&ENDIF
&if defined(dputline6) <> 0
&then
 put unformat {&putline6} skip.
&ENDIF
&if defined(dputline7) <> 0
&then
 put unformat {&putline7} skip.
&ENDIF
&if defined(dputline8) <> 0
&then
 put unformat {&putline8} skip.
&ENDIF
&if defined(dputline9) <> 0
&then
 put unformat {&putline9} skip.
&ENDIF
&if defined(dputline10) <> 0
&then
 put unformat {&putline10} skip.
&ENDIF
&if defined(dputline11) <> 0
&then
 put unformat {&putline11} skip.
&ENDIF
&if defined(dputline12) <> 0
&then
 put unformat {&putline12} skip.
&ENDIF
&if defined(dputline13) <> 0
&then
 put unformat {&putline13} skip.
&ENDIF
&if defined(dputline14) <> 0
&then
 put unformat {&putline14} skip.
&ENDIF
&if defined(dputline15) <> 0
&then
 put unformat {&putline15} skip.
&ENDIF
&if defined(dputline16) <> 0
&then
 put unformat {&putline16} skip.
&ENDIF

OUTPUT CLOSE.

INPUT FROM VALUE("./ssi" + mfguser).	
OUTPUT TO  VALUE("./sso" + mfguser).		
batchrun = YES.  /* In order to	disable the "Pause" message */
{gprun.i ""{&execname}""} 
batchrun = NO.
INPUT CLOSE.
OUTPUT CLOSE.

end.  /* cim */

OS-DELETE VALUE("./ssi" + mfguser).
OS-DELETE VALUE("./sso" + mfguser).
