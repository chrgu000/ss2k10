/* xxrqpobldlk01.i - LOCK A GROUP OF RECORDS                                                  */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                                        */
/* All rights reserved worldwide.  This is an unpublished work.                               */
/* $Revision: 1.0 $                                                                           */
/*V8:ConvertMode=Maintenance                                                                  */
/* Revision: 1.0    CREATE BY: Softspeed RogerXiao   DATE: 2007/12/25   ECO: *xp001*          */
/* $MODIFIED BY: softspeed Roger Xiao                DATE: 2008/07/17   ECO: *xp002*          */ /*加显示用户名*/
/******************************************************************************/

/*xp001*/
/*use the file like this:*未离开mainloop之前记录都是锁定的. */
/*
mainloop:
do on error undo,retry:
    {xxrqpobldlk01.i  
        &file-name      = rqd_det
        &group-criteria = "rqd_det.rqd_site = site "
        &undo-block     = mainloop
        &retry          = "retry mainloop"
    } 
    
end.
*/ 

/*----------------------------------------------------------------------------------------------------*/





find first {&file-name} exclusive-lock
   where  {&group-criteria}
no-wait no-error.

if locked {&file-name} then do:
    /*xp002*/
    find first {&file-name} where  {&group-criteria} no-lock no-error.
    vv_recid = if avail {&file-name} then integer(recid({&file-name})) else 0.
    vv_user = "other users" . 

    find first _file where _file-name = "{&file-name}" no-lock no-error .
    if avail _file then do:
        find first _lock where _lock-table =  _file-num and _lock-recid = vv_recid no-lock no-error .
        vv_user = if avail _lock then _lock-name else "other users".
    end.

    message "{&file-name}" ",Locked by Linux User: " vv_user view-as alert-box .  /*xp002*/
    undo {&undo-block}, {&retry}. 
end.


repeat:

   find next {&file-name} exclusive-lock
      where {&group-criteria}
   no-wait no-error.

   if locked {&file-name} then do:
        /*xp002*/
        find prev {&file-name} where  {&group-criteria} no-lock no-error.
        find next {&file-name} where  {&group-criteria} no-lock no-error.
        vv_recid = if avail {&file-name} then integer(recid({&file-name})) else 0.
        vv_user = "other users" . 

        find first _file where _file-name = "{&file-name}" no-lock no-error .
        if avail _file then do:
            find first _lock where _lock-table =  _file-num and _lock-recid = vv_recid no-lock no-error .
            vv_user = if avail _lock then _lock-name else "other users".
        end.

        message "{&file-name}" ",Locked by Linux User: " vv_user view-as alert-box .  /*xp002*/
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