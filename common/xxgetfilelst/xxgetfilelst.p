/* xxgetfilelst.p - common program getFileList to uxrw_wkfl                  */
/*V8:ConvertMode=Maintenance                                                 */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 24YP LAST MODIFIED: 04/24/12 BY: zy expand xrc length to 120    */
/* REVISION END                                                              */

{mfdeclre.i}
define input parameter iDirname as character.
define input parameter iMaxFileCount as integer.

define variable i as integer.
define variable var2 as character.
define variable var4 as character.
define variable var5 as character.
for each usrw_wkfl exclusive-lock where {xxusrwdom.i} {xxand.i}
         usrw_key1 = "xxvifile.p":
    delete usrw_wkfl.
end.

assign i = 0.
INPUT FROM OS-DIR(iDirname).
getfileList:
REPEAT:
    IMPORT var4 var2 var5.
    if not can-find(first usrw_wkfl where {xxusrwdom.i} {xxand.i}
           usrw_key1 = "xxvifile.p" and usrw_key2 = var2) then do:
       CREATE usrw_wkfl. {xxusrwdom.i}.
       ASSIGN usrw_key1 = "xxvifile.p"
              usrw_key2 = var2
              usrw_key3 = global_userid
              usrw_key4 = var4
              usrw_key5 = var5.
        if iMaxFileCount > 0 then do:
           if usrw_key5 <> "F"  then do:
              assign i = i + 1.
           end.
           if i > iMaxFileCount then leave getfileList.
        end.
    end.
END.
INPUT CLOSE.

for each usrw_wkfl exclusive-lock where {xxusrwdom.i} {xxand.i}
         usrw_key1 = "xxvifile.p"
     and usrw_key5 <> "F":
    delete usrw_wkfl.
end.
