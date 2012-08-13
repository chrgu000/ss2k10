/**
 @File: xkpsmo.p
 @Description: Internal pull sheet monitor
 @Version: 1.0
 @Author: Xiang Wenhui
 @Created: 2006-2-16
 @History:
**/

{mfdtitle.i}

define variable interval  as   integer label "间隔时间(秒)".
DEFINE BUFFER xkromstr FOR xkro_mstr.


FORM 
        
    SKIP(.1)  
    interval       COLON 20 SKIP
    SKIP(.4)  
WITH FRAME a SIDE-LABELS WIDTH 80 ATTR-SPACE THREE-D .
setFrameLabels(frame a:handle).

form
with down frame b width 80 no-labels three-d.


update interval validate(interval > 0, "时间间隔不可为零") with frame a.


REPEAT ON ERROR UNDO,LEAVE : 
   
    HIDE MESSAGE NO-PAUSE.
    CLEAR FRAME b ALL NO-PAUSE.
    FOR EACH xkro_mstr NO-LOCK 
        WHERE xkro_print AND xkro_type <> 'P' 
             AND ((xkro_ord_date = TODAY AND xkro_ord_time <= TIME)
                  OR xkro_ord_date < TODAY)    with frame b: 
       FIND FIRST xkromstr WHERE xkromstr.xkro_nbr = xkro_mstr.xkro_nbr EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
       IF AVAILABLE xkromstr THEN DO:     
         {gprun.i ""xkpsprt.p"" "(input xkromstr.xkro_nbr)" }
       END.
    end.
    
    pause interval.
    

end. /*repeat*/
