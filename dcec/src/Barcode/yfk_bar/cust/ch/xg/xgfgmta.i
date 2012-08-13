UpdBlock:
DO ON ENDKEY UNDO, LEAVE
    ON ERROR UNDO, LEAVE :

    FIND ttkb WHERE RECID(ttkb) = w-rid[FRAME-LINE(f-kb)] NO-ERROR .
    IF NOT AVAILABLE ttkb THEN LEAVE UpdBlock .

    if ttkb_kbid <> 0 then ttkb_active = not ttkb_active  .

END.
