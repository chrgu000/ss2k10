/* xxgetmac.p - getMacAddress                                                */
/*V8:ConvertMode=Maintenance                                                 */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 120713.1 LAST MODIFIED: 07/13/12 BY: zy                         */
/* REVISION END                                                              */
 define output parameter txt as character  format "x(70)".

{mfdeclre.i}
{gplabel.i}

 if opsys = "UNIX" then do:
    UNIX SILENT "/sbin/ifconfig -a > ip.xxecdc.i.201020.cfg".
    if search("ip.xxecdc.i.201020.cfg") <> ? then do:
       input from "ip.xxecdc.i.201020.cfg".
       repeat:
         import unformat txt.
         if index(txt,"HWaddr") > 0 then do:
            assign txt = substring(txt, index(txt,"HWaddr") + 7).
            leave.
         end.
       end.
       input close.
       os-delete "ip.xxecdc.i.201020.cfg".
    end.
 end. /* if opsys = "UNIX" then do: */
 else if opsys = "msdos" or opsys = "win32" then do:
     dos silent "ipconfig /all > ip.xxecdc.i.201020.cfg".
     if search("ip.xxecdc.i.201020.cfg") <> ? then do:
       input from "ip.xxecdc.i.201020.cfg".
       repeat:
         import unformat txt.
         if index(txt, trim(getTermLabel("PHYSICAL_ADDRESS_.....",12))) > 0
            then do:
            assign txt = trim(entry(2,txt,":")).
            leave.
         end.
       end.
       input close.
       os-delete "ip.xxecdc.i.201020.cfg".
    end.
 end. /* else if opsys = "msdos" or opsys = "win32" then do: */
