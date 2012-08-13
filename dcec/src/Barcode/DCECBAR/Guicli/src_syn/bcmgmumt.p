{bcdeclre.i}
DEFINE VARIABLE w AS HANDLE.
DEFINE BUTTON btn_addnew LABEL "AddNew".
DEFINE BUTTON btn_save LABEL "Save".
DEFINE BUTTON btn_delete LABEL "Delete".

DEFINE VARIABLE v AS LOGICAL.

DEFINE QUERY q_mnd FOR b_mnd_det.
DEFINE BROWSE b_mnd QUERY q_mnd 
    DISP b_mnd_nbr
           b_mnd_select
           b_mnd_name
           b_mnd_exec
           b_mnd_module
    ENABLE ALL
    WITH 10 DOWN SEPARATORS SIZE 98 BY 15 TITLE "²Ëµ¥Î¬»¤"
    THREE-D EXPANDABLE .


DEFINE FRAME a
   
    b_mnd
    SKIP
    btn_addnew btn_save btn_delete SKIP(2)
    WITH WIDTH 100 THREE-D CENTERED.

CREATE WINDOW w
    ASSIGN TITLE = bc_name
                 HEIGHT-CHARS = 25
                 WIDTH-CHARS = 100.

ON 'choose':U OF btn_addnew
DO:
    /*b_mnd:READ-ONLY = FALSE.*/
    GET LAST q_mnd.
    REPOSITION q_mnd TO ROW NUM-RESULTS("q_mnd").
    b_mnd:INSERT-ROW("after").
    RETURN.
END.


ON 'CHOOSE':U OF btn_save
DO:
    IF b_mnd:NEW-ROW IN FRAME a THEN DO:
       CREATE b_mnd_det.
       ASSIGN INPUT BROWSE b_mnd b_mnd_nbr b_mnd_select b_mnd_name b_mnd_exec b_mnd_module.

        /* b_mnd_nbr = BROWSE b_mnd  b_mnd_det.b_mnd_nbr.
                     b_mnd_select = BROWSE b_mnd  b_mnd_det.b_mnd_select.
                     b_mnd_name = BROWSE b_mnd  b_mnd_det.b_mnd_name.
                     b_mnd_exec = BROWSE b_mnd  b_mnd_det.b_mnd_exec.
                     b_mnd_module = BROWSE b_mnd  b_mnd_det.b_mnd_module.*/
        /*ASSIGN  b_mnd_nbr = BROWSE b_mnd  b_mnd_det.b_mnd_nbr
                     b_mnd_select = BROWSE b_mnd  b_mnd_det.b_mnd_select
                     b_mnd_name = BROWSE b_mnd  b_mnd_det.b_mnd_name
                     b_mnd_exec = BROWSE b_mnd  b_mnd_det.b_mnd_exec
                     b_mnd_module = BROWSE b_mnd  b_mnd_det.b_mnd_module.*/

    END.
    ELSE DO:
     DEFINE VARIABLE i AS INTEGER.
        DO i = b_mnd:NUM-SELECTED-ROWS TO 1 by -1:
        GET CURRENT q_mnd EXCLUSIVE-LOCK NO-WAIT.
         ASSIGN  INPUT BROWSE b_mnd  b_mnd_det.b_mnd_nbr
                                                        b_mnd_det.b_mnd_select
                                                        b_mnd_det.b_mnd_name
                                                        b_mnd_det.b_mnd_exec
                                                        b_mnd_det.b_mnd_module.
         b_mnd:FETCH-SELECTED-ROW(i).
        END.
    END.
    /*b_mnd:READ-ONLY = TRUE.*/
    RETURN.
END.

ON 'choose':U OF btn_delete
DO:
    /*b_user:READ-ONLY=FALSE.*/
    DEFINE VARIABLE i AS INTEGER.
    DEFINE VARIABLE usr AS CHARACTER.
        DO i = b_mnd:NUM-SELECTED-ROWS TO 1 by -1:
            v = b_mnd:FETCH-SELECTED-ROW(i).
            GET CURRENT q_mnd EXCLUSIVE-LOCK.
            DELETE b_mnd_det.
            b_mnd:DELETE-SELECTED-ROWS().
        END. 
        /*v = b_mnd:DELETE-SELECTED-ROWS().*/
    /*b_mnd:READ-ONLY = TRUE.*/
    RETURN.
END.

REPEAT:


OPEN QUERY q_mnd FOR EACH b_mnd_det BY b_mnd_nbr BY b_mnd_select.
CURRENT-WINDOW = w.

UPDATE b_mnd btn_addnew  btn_delete btn_save  WITH FRAME a.

/*b_mnd:READ-ONLY = TRUE.*/


END.

DELETE WIDGET W.



