/* xxgpdescm.p - Multi-Lines Description Pop-up Window  */
/* REVISION: 101221.1   Created On: 20101221   By: Softspeed Roger Xiao                               */

        /********************************************************************
                Warning: xxgpdescm.p is used by many programs !
                         to display and update a field within a 6-line-frame
         ********************************************************************/

/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 101221.1  By: Roger Xiao */
/*-Revision end---------------------------------------------------------------*/


&SCOPED-DEFINE gpgldesc_p_1 " Description "

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

define input         parameter i-row        as integer   no-undo.
define input-output  parameter i-desc       as character format "x(24)" no-undo.

define var v_desc                 like glt_desc format "x(20)" extent 6 no-undo. 

form
    space(2) v_desc[1] no-label skip  /*colon 13  label "Remark" */
    space(2) v_desc[2] no-label skip
    space(2) v_desc[3] no-label skip
    space(2) v_desc[4] no-label skip
    space(2) v_desc[5] no-label skip
    space(2) v_desc[6] no-label skip
with frame a 
width 24 centered overlay attr-space
title color normal (getFrameTitle("DESCRIPTION",15)).
setFrameLabels(frame a:handle).



/*
define var row-location           as decimal   no-undo.
row-location = min(max(i-row,3), 21 - 3).
frame a:ROW  = row-location.
*/

frame a:ROW = i-row .


main-blk:
do transaction:

     assign 
        v_desc[1] = substring(i-desc,1,  20,"raw") 
        v_desc[2] = substring(i-desc,21, 20,"raw") 
        v_desc[3] = substring(i-desc,41, 20,"raw") 
        v_desc[4] = substring(i-desc,61, 20,"raw") 
        v_desc[5] = substring(i-desc,81, 20,"raw") 
        v_desc[6] = substring(i-desc,101,20,"raw") 
        .



    pause 0.

    up-blk:
    do on endkey undo main-blk, leave main-blk:

        update
            v_desc[1] v_desc[2] v_desc[3] v_desc[4] v_desc[5] v_desc[6]
        with frame a.

         assign i-desc = string(trim(v_desc[1]),"x(20)") 
                       + string(trim(v_desc[2]),"x(20)")
                       + string(trim(v_desc[3]),"x(20)") 
                       + string(trim(v_desc[4]),"x(20)") 
                       + string(trim(v_desc[5]),"x(20)") 
                       + string(trim(v_desc[6]),"x(20)") .

    end.   /* UP-BLK */

end.   /* MAIN-BLK */

hide frame a no-pause.