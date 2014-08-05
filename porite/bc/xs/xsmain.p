define shared variable global_userid as char format "x(30)".
define shared variable global_gblmgr_handle as handle no-undo.
define shared variable global_domain as char format "x(8)".
run pxgblmgr.p persistent set global_gblmgr_handle.
global_userid = trim ( userid(sdbname('qaddb')) ).
run xsmf001.p.
quit.
