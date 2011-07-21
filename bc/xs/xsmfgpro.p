/* CopyRight    : Softspeed Consultant Ltd.,*/
/* Design By    : Sam Song */
/* Design Date    : 2006 / 01 /01 */
/* Version    : 3.51a */
/* Issue Method       : License Code*/

define input PARAMETER wMfgproProgram as char format "x(40)".
define input PARAMETER wdtitle as char format "x(40)".

define shared variable execname as char format "x(40)".
define variable global_user_lang_dir as char format "x(40)" init "/app/mfgpro/eb2/us/".
define shared variable global_gblmgr_handle as handle no-undo.
define  shared variable dtitle as character format "x(78)".
run pxgblmgr.p persistent set global_gblmgr_handle.

dtitle = "               Barcode Report - " +  wdtitle  +  "  " + wMfgproProgram + "             " + string( today ).

global_user_lang_dir = "/app/mfgpro/eb2/us/".
find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="global_user_lang_dir" no-lock no-error. /*  Update MFG/PRO Directory */
if AVAILABLE(code_mstr) Then global_user_lang_dir = trim ( code_cmmt ).
if substring(global_user_lang_dir, length(global_user_lang_dir), 1) <> "/" then
 global_user_lang_dir = global_user_lang_dir + "/".
if wMfgproProgram = "" then leave.


find first usrw_wkfl where usrw_key1 = "BARCODE" and usrw_key2 = "LICENSEKEY" no-lock no-error .


find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="ReportWarehouseLICENSEKEY" no-lock no-error.

if NOT available (code_mstr)  then leave.
if available (code_mstr) and  code_cmmt <>   encode ( trim ( usrw_charfld[1] )  + "SOFTSPEED" )  then leave.

pause 0.
clear all.
  find first mnd_det where mnd_exec = wMfgproProgram and ( index ( mnd_exec , ".p") <> 0 or index ( mnd_exec , ".w") <> 0 or index ( mnd_exec , ".r") <> 0 ) no-lock no-error.
  if available mnd_det then do:
     if index ( wMfgproProgram , "br" ) <> 0 then do:
        find first mnds_det where mnds_exec = wMfgproProgram no-lock no-error.
  if available mnds_det then wMfgproProgram = mnds_exec_sub.
     end.
     if length ( wMfgproProgram ) > 2 then  /* Change Program Name */
     execname = "xs" + substring ( wMfgproProgram ,3, length(wMfgproProgram) - 2 ) .
     {gprun.i  wMfgproProgram }
     leave.
  end.
  else do:

    DEF VARIABLE i AS INTEGER.
    define variable mndnbr like mnd_nbr.
    define variable mndselect AS CHAR.
       mndnbr = "".
       mndselect = "".
       if substring ( wMfgproProgram ,1,1) ="." then
             wMfgproProgram = substring(wMfgproProgram ,2, length(wMfgproProgram) - 1 ) .
       /* Get Menu And nbr Start 2006 /06/01 */
       DO i = 1 to length(wMfgproProgram).

        IF substring(wMfgproProgram,i,1) <> "." THEN
           mndselect = mndselect + substring(wMfgproProgram,i,1) .
        ELSE do:

      mndnbr = mndnbr +  trim ( mndselect ) + "." .
      mndselect = "".

        END.
        END.
        /* Get Menu And nbr End 2006 /06/01 */

      IF mndnbr <> ""  THEN  mndnbr = SUBSTRING(mndnbr ,1, LENGTH(mndnbr) - 1 ).

      find first mnd_det where mnd_nbr = mndnbr and string ( mnd_select ) = mndselect  and
                                             ( index ( mnd_exec , ".p") <> 0 or index ( mnd_exec , ".w") <> 0 or index ( mnd_exec , ".r") <> 0 )
                                                   no-lock no-error.
      if available mnd_det then do:
         wMfgproProgram = mnd_exec.
                if index ( mnd_exec , "br" ) <> 0 then do:
                   find first mnds_det where mnds_exec = mnd_exec no-lock no-error.
             if available mnds_det then wMfgproProgram = mnds_exec_sub.
                end.
                if length ( wMfgproProgram ) > 2 then       /* Substitity Menu and Change Program Name */
                execname = "xs" + substring ( wMfgproProgram ,3, length(wMfgproProgram) - 2 ) .
    if substring ( wMfgproProgram ,1, 2 ) = "xs" then
         {gprun.i  wMfgproProgram }


      end.

 end.
