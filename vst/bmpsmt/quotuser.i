/**** quotuser.i QUOT USER INCLUDE FILE *****/
/** ADM  05/21/2004              By Derek Chu **/

define variable tmpuserid as char.
define variable isquotuser as logical.
define variable compmsg as character format "x(30)" no-undo.
define temp-table quotuser
    field quot_userid as char. 

/** Search admaud.mstr - assume this file stored in /app/mfg/deprg/mfg001 **/
DEFINE VARIABLE dbpath AS CHARACTER.
ASSIGN dbpath = SUBSTRING (DBNAME, R-INDEX (DBNAME, "/") + 1).
INPUT from VALUE (SEARCH (dbpath + "/quotuser.mstr")).

repeat:
   import delimiter "|" tmpuserid.
      create quotuser.
      assign quot_userid = tmpuserid.
end.
input close.
isquotuser = False.
find quotuser where quot_userid = global_userid no-lock no-error.
if available quotuser then isquotuser = True.
