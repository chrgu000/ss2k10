/* xxquottrs.i - bom load                                                      */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 120703.1 LAST MODIFIED: 07/03/12 BY:                            */
/* REVISION END                                                              */

/* quotuser.i  /app/mfg/deprg/mfg001/quotuser.mstr                           */
DEFINE {1} shared VARIABLE fileF AS CHARACTER.
DEFINE {1} shared VARIABLE fileT AS CHARACTER.
DEFINE {1} shared VARIABLE cmd as CHARACTER.
assign  fileF = SUBSTRING (DBNAME, R-INDEX (DBNAME, "/") + 1).
assign  fileF = search(fileF + "/quotuser.mstr").
assign  fileT = SUBSTRING (fileF,1, R-INDEX (fileF, "/")) + "quotuser.bak".

procedure enableQuot:
   assign cmd = "mv " + fileF + " " + fileT.
   os-command silent value(cmd).
   assign cmd = "echo " + global_userid + " >>" + fileF.
   os-command silent value(cmd).
end.

procedure disableQuot:
       assign cmd = "mv " + fileT + " " + fileF.
       os-command silent value(cmd).
end.