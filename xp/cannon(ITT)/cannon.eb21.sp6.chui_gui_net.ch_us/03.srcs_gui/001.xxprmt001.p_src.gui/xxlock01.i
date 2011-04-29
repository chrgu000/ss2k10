/* xxlock01.i - LOCK A GROUP OF RECORDS                                  */
/* REVISION: 1.0         Last Modified: 2008/11/02   By: Roger           */
/*-Revision end------------------------------------------------------------*/


/*
Roger:
1.*未离开mainloop之前记录都是锁定的.
2.use the file like this: 
mainloop:
do on error undo,retry:
    {xxlock01.i  
        &file-name      = rqd_det
        &group-criteria = "rqd_det.rqd_site = site "
        &undo-block     = mainloop
        &retry          = "retry mainloop"
    } 
    
end.

3. define vars outside (不然不可多次调用):
define var vv_user as char format "x(12)" .   
define var vv_recid as integer .    

*/ 

/*----------------------------------------------------------------------------------------------------*/




find first {&file-name} exclusive-lock
   where  {&group-criteria}
no-wait no-error.

if locked {&file-name} then do:
    
    find first {&file-name} where  {&group-criteria} no-lock no-error.
    vv_recid = if avail {&file-name} then integer(recid({&file-name})) else 0.
    vv_user = "other users" . 

    find first _file where _file-name = "{&file-name}" no-lock no-error .
    if avail _file then do:
        find first _lock where _lock-table =  _file-num and _lock-recid = vv_recid no-lock no-error .
        vv_user = if avail _lock then _lock-name else "other users".
    end.

    message /*"{&file-name}" ",*/ "This Record Is Locked By User: " vv_user /*view-as alert-box*/ .  
    undo {&undo-block}, {&retry}. 
end.


repeat:

   find next {&file-name} exclusive-lock
      where {&group-criteria}
   no-wait no-error.

   if locked {&file-name} then do:
        
        find prev {&file-name} where  {&group-criteria} no-lock no-error.
        find next {&file-name} where  {&group-criteria} no-lock no-error.
        vv_recid = if avail {&file-name} then integer(recid({&file-name})) else 0.
        vv_user = "other users" . 

        find first _file where _file-name = "{&file-name}" no-lock no-error .
        if avail _file then do:
            find first _lock where _lock-table =  _file-num and _lock-recid = vv_recid no-lock no-error .
            vv_user = if avail _lock then _lock-name else "other users".
        end.

        message /*"{&file-name}" ",*/ "This Record Is Locked By User: " vv_user  /*view-as alert-box*/  .  
        undo {&undo-block}, {&retry}.
   end.
   if not available {&file-name} then leave.
end.  /* repeat */

if locked {&file-name} then
   undo {&undo-block}, {&retry}.

find first {&file-name} exclusive-lock
   where {&group-criteria}
no-wait no-error.


/*----------------------------------------------------------------------------------------------------*/