DEFINE VAR a AS CHAR.
DEFINE VAR b AS CHAR.
DEFINE VAR c AS CHAR.
DEFINE FRAME test-1
    SKIP(1)
    a COLON 20
    b COLON 45
    WITH WIDTH 80 THREE-D SIDE-LABEL.
DEFINE FRAME test-2 
    SKIP(1)
    c COLON 20
    WITH WIDTH 80 THREE-D SIDE-LABEL.
REPEAT:
    UPDATE a WITH FRAME test-1.
    
       if lastkey = keycode("F2") THEN 
       
            UPDATE c WITH FRAME test-2.
         ELSE
         DO:
         
    UPDATE b WITH FRAME test-1.
    UPDATE c WITH FRAME test-2.
    
    END.
END.
