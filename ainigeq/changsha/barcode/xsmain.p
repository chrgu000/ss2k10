define shared variable global_userid as char format "x(30)".
define shared variable global_gblmgr_handle as handle no-undo.
run pxgblmgr.p persistent set global_gblmgr_handle.
/* SS - 110316.1 - B
global_userid = trim ( userid(sdbname('qaddb')) ).
SS - 110316.1 - E */

/* SS - 110316.1 - B */
input through whoami no-echo.
set global_userid format "x(20)" .
input close.
/* SS - 110316.1 - E */

run xsmf001.p.
quit.
