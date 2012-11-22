/* Generate By Barcode Generator , Copyright by Softspeed */ 
/* STANDARD */
/* Generate date / time  2005-1-20 12:38:45 */
define variable sectionid as integer init 0 .
define variable WMESSAGE as char format "x(20)" init "".
define variable wtm_num as char format "x(20)" init "0".
define variable wsection as char format "x(16)".
/* Create VARIABLE  location START */
define variable wloc as CHAR format "x(8)" .
/* Create VARIABLE  location END */

/* Create VARIABLE  Quantity START */
define variable wqty as decimal init 0.
define variable wtimeout as integer init 99999 .
find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="wtimeout" no-lock no-error. /*  Timeout - All Level */
if AVAILABLE(code_mstr) Then wtimeout = 60 * decimal(code_cmmt).
find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="xsinq01wtimeout" no-lock no-error. /*  Timeout - Program Level */
if AVAILABLE(code_mstr) Then wtimeout = 60 * decimal(code_cmmt).

/* Create VARIABLE  Quantity START */

define variable i as integer .
mainloop:
REPEAT:
     /* CYCLE COUNTER -SECTION ID -- START*/
      sectionid = sectionid + 1 .
     /* SECTION ID -- END  */

     /* START  LINE :1300  物料  */
     V1300L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1300           as char format "x(26)".
        define variable PV1300          as char format "x(26)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[畐琩高-畐]"   format "x(20)" skip with fram F1300 no-box.

                /* LABEL 1 - START */ 
                display " 珇:" + V1300 format "x(20)" skip with fram F1300 no-box.
                /* LABEL 1 - END */ 

                /* LABEL 2 - START */ 
                find first pt_mstr where pt_part = ENTRY(1, V1300, "@")  no-lock no-error.
If AVAILABLE ( pt_mstr )  then
                  display pt_desc1      format "x(20)" skip with fram F1300 no-box.
                  else display  skip with fram F1300 no-box.
                /* LABEL 2 - END */

                /* LABEL 3 - START */
                find first pt_mstr where pt_part = ENTRY(1, V1300, "@")  no-lock no-error.
If AVAILABLE ( pt_mstr ) then
                  display pt_desc2      format "x(20)" skip with fram F1300 no-box.
                  else display  skip with fram F1300 no-box.
                /* LABEL 3  - END */

                /* LABEL 4 - START */
                find first pt_mstr where pt_part = ENTRY(1, V1300, "@")  no-lock no-error.
If AVAILABLE ( pt_mstr ) then
                  display pt_um         format "x(20)" skip with fram F1300 no-box.
                  else display  skip with fram F1300 no-box.
                /* LABEL 4 - END */

                display "E癶 ┪ 块? "  format "x(20)" skip
        skip with fram F1300 no-box.
        Update V1300
        WITH  fram F1300 NO-LABEL
        /* ROLL BAR START */
        EDITING:
	          readkey pause wtimeout.
          if lastkey = -1 Then quit.

            IF LASTKEY = keycode("F10") or keyfunction(lastkey) = "CURSOR-DOWN"
            THEN DO:
                  IF recid(PT_MSTR) = ? THEN find first PT_MSTR where 
                              PT_PART >=  INPUT V1300  no-lock no-error.
                  ELSE find first PT_MSTR where 
                              PT_PART >  INPUT V1300  no-lock no-error.
                  IF AVAILABLE PT_MSTR then display skip 
            PT_PART @ V1300 PT_DESC1 @ WMESSAGE NO-LABEL with fram F1300.
                  else   display skip "" @ WMESSAGE with fram F1300.
            END.
            IF LASTKEY = keycode("F9") or keyfunction(lastkey) = "CURSOR-UP"
            THEN DO:
                  IF recid(PT_MSTR) = ? THEN find first PT_MSTR where 
            PT_PART <=  INPUT V1300  no-lock no-error.
                  ELSE find last PT_MSTR where 
                              PT_PART <  INPUT V1300  no-lock no-error.
                  IF AVAILABLE PT_MSTR then display skip 
            PT_PART @ V1300 PT_DESC1 @ WMESSAGE NO-LABEL with fram F1300.
                  else   display skip "" @ WMESSAGE with fram F1300.
            END.
/*            READKEY. */
            APPLY LASTKEY.
        END.
        /* ROLL BAR END */


        /* PRESS e EXIST CYCLE */
        IF V1300 = "e" THEN  LEAVE MAINLOOP.

         /*  ---- Valid Check ---- START */

        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        find first PT_MSTR where PT_PART = ENTRY(1, V1300, "@")  no-lock no-error.
        IF NOT AVAILABLE PT_MSTR then do:
                display skip "Error,Retry" @ WMESSAGE NO-LABEL with fram F1300.
                undo, retry.
        end.
         /*  ---- Valid Check ---- END */

        leave V1300L.
     END.
     PV1300 = ENTRY(1, V1300, "@").
     V1300 =  ENTRY(1, V1300, "@").
     /* END    LINE :1300  物料  */


     /* START  LINE :1400  库位  */
     V1400L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1400           as char format "x(20)".
        define variable PV1400          as char format "x(20)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
	 V1400 = "".
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[畐琩高-畐]"   format "x(20)" skip with fram F1400 no-box.

                /* LABEL 1 - START */ 
                display " 畐?"    format "x(20)" skip with fram F1400 no-box.
                /* LABEL 1 - END */ 

                /* LABEL 2 - START */ 
                  display skip(1) with fram F1400 no-box.
                /* LABEL 2 - END */



                /* LABEL 6 - START */
                find first pt_mstr where pt_part = V1300  no-lock no-error.
If AVAILABLE (pt_mstr) then
                  display PT_LOC        format "x(20)" skip with fram F1400 no-box.
                  else display  skip with fram F1400 no-box.
                /* LABEL 6 - END */
                display "E癶 ┪ 块? "  format "x(20)" skip
        skip with fram F1400 no-box.
        Update V1400
        WITH  fram F1400 NO-LABEL
        /* ROLL BAR START */
        EDITING:
          readkey pause wtimeout.
          if lastkey = -1 Then quit.

            IF LASTKEY = keycode("F10") or keyfunction(lastkey) = "CURSOR-DOWN"
            THEN DO:
                  IF recid(LOC_MSTR) = ? THEN find first LOC_MSTR where 
                              LOC_LOC >=  INPUT V1400  no-lock no-error.
                  ELSE find first LOC_MSTR where 
                              LOC_LOC >  INPUT V1400  no-lock no-error.
                  IF AVAILABLE LOC_MSTR then display skip 
            LOC_LOC @ V1400 LOC_DESC @ WMESSAGE NO-LABEL with fram F1400.
                  else   display skip "" @ WMESSAGE with fram F1400.
            END.
            IF LASTKEY = keycode("F9") or keyfunction(lastkey) = "CURSOR-UP"
            THEN DO:
                  IF recid(LOC_MSTR) = ? THEN find first LOC_MSTR where 
            LOC_LOC <=  INPUT V1400  no-lock no-error.
                  ELSE find last LOC_MSTR where 
                              LOC_LOC <  INPUT V1400  no-lock no-error.
                  IF AVAILABLE LOC_MSTR then display skip 
            LOC_LOC @ V1400 LOC_DESC @ WMESSAGE NO-LABEL with fram F1400.
                  else   display skip "" @ WMESSAGE with fram F1400.
            END.
/*            READKEY.   */
            APPLY LASTKEY.
        END.
        /* ROLL BAR END */


        /* PRESS e EXIST CYCLE */
        IF V1400 = "e" THEN  LEAVE MAINLOOP.

         /*  ---- Valid Check ---- START */

        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
       /* find first LOC_MSTR where LOC_LOC = V1400  no-lock no-error.
        IF NOT AVAILABLE LOC_MSTR then do:
                display skip "Error , Retry." @ WMESSAGE NO-LABEL with fram F1400.
                undo, retry.
        end. */
         /*  ---- Valid Check ---- END */

        leave V1400L.
     END.
     PV1400 = V1400.
     /* END    LINE :1400  库位  */


     /* START  LINE :1500  显示1  */
     V1500L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1500           as char format "x(20)".
        define variable PV1500          as char format "x(20)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */

                /* LABEL 1 - START */ 
                  display " 珇:" + V1300
                                        format "x(20)" skip with fram F1500 no-box.
                /* LABEL 1 - END */ 
                
                /* LABEL 2 - START */ 

                  display " 畐:  计秖:" format "x(20)" skip with fram F1500 no-box.

		/* LABEL 2 - END */

                /* LABEL 3 - START */
                FOR EACH ld_Det WHERE ld_loc >= V1400 and ld_part = V1300 and ld_qty_oh <> 0  NO-LOCK  BREAK BY ld_loc  :
        	    ACCUMULATE ld_qty_oh (TOTAL BY ld_loc).
		    IF LAST-OF(ld_loc) THEN DO:
		       display " " + trim(ld_loc) + " " + string( ACCUM TOTAL BY Ld_loc ld_qty_oh)
		       format "x(20)" skip with fram F1500 no-box.
		       V1400 = ld_loc + "!" .
		       leave.
		    END.
                END.
                /* LABEL 3  - END */

                /* LABEL 4 - START */
                FOR EACH ld_Det WHERE ld_loc >= V1400 and ld_part = V1300 and ld_qty_oh <> 0  NO-LOCK  BREAK BY ld_loc  :
        	    ACCUMULATE ld_qty_oh (TOTAL BY ld_loc).
		    IF LAST-OF(ld_loc) THEN DO:
		       display " " + trim(ld_loc) + " " + string( ACCUM TOTAL BY Ld_loc ld_qty_oh)
		       format "x(20)" skip with fram F1500 no-box.
		       V1400 = ld_loc + "!" .
		       leave.
		    END.
                END.
                /* LABEL 4 - END */

                /* LABEL 5 - START */ 
                FOR EACH ld_Det WHERE ld_loc >= V1400 and ld_part = V1300 and ld_qty_oh <> 0  NO-LOCK  BREAK BY ld_loc  :
        	    ACCUMULATE ld_qty_oh (TOTAL BY ld_loc).
		    IF LAST-OF(ld_loc) THEN DO:
		       display " " + trim(ld_loc) + " " + string( ACCUM TOTAL BY Ld_loc ld_qty_oh)
		       format "x(20)" skip with fram F1500 no-box.
		       V1400 = ld_loc + "!" .
		       leave.
		    END.
                END.
                /* LABEL 5 - END */

                display "E癶 ┪ 块? "  format "x(20)" skip
        skip with fram F1500 no-box.
	V1500 ="".
        Update V1500
        WITH  fram F1500 NO-LABEL
.

        /* PRESS e EXIST CYCLE */
        IF V1500 = "e" THEN  LEAVE MAINLOOP.

         /*  ---- Valid Check ---- START */

        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        leave V1500L.
     END.
     PV1500 = V1500.
     /* END    LINE :1500  显示1  */


     /* START  LINE :1600  显示2  */
     V1600L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1600           as char format "x(20)".
        define variable PV1600          as char format "x(20)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */

        find first ld_Det WHERE ld_loc >= V1400 and ld_part = V1300 and ld_qty_oh <> 0 no-lock no-error .
        IF NOT AVAILABLE ld_det then leave V1600L.
        
        /* LOGICAL SKIP END */

                /* LABEL 1 - START */ 
                  display " 珇: " + V1300
                                        format "x(20)" skip with fram F1600 no-box.
                /* LABEL 1 - END */ 

                /* LABEL 2 - START */ 

                  display " 畐:  计秖:" format "x(20)" skip with fram F1600 no-box.
                /* LABEL 2 - END */

                /* LABEL 3 - START */
                FOR EACH ld_Det WHERE ld_loc >= V1400 and ld_part = V1300 and ld_qty_oh <> 0  NO-LOCK  BREAK BY ld_loc  :
        	    ACCUMULATE ld_qty_oh (TOTAL BY ld_loc).
		    IF LAST-OF(ld_loc) THEN DO:
		       display " " + trim(ld_loc) + " " + string( ACCUM TOTAL BY Ld_loc ld_qty_oh)
		       format "x(20)" skip with fram F1600 no-box.
		       V1400 = ld_loc + "!" .
		       leave.
		    END.
                END.
                /* LABEL 3  - END */

                /* LABEL 4 - START */
                FOR EACH ld_Det WHERE ld_loc >= V1400 and ld_part = V1300 and ld_qty_oh <> 0  NO-LOCK  BREAK BY ld_loc  :
        	    ACCUMULATE ld_qty_oh (TOTAL BY ld_loc).
		    IF LAST-OF(ld_loc) THEN DO:
		       display " " + trim(ld_loc) + " " + string( ACCUM TOTAL BY Ld_loc ld_qty_oh)
		       format "x(20)" skip with fram F1600 no-box.
		       V1400 = ld_loc + "!" .
		       leave.
		    END.
                END.
                /* LABEL 4 - END */

                /* LABEL 5 - START */ 
                FOR EACH ld_Det WHERE ld_loc >= V1400 and ld_part = V1300 and ld_qty_oh <> 0  NO-LOCK  BREAK BY ld_loc  :
        	    ACCUMULATE ld_qty_oh (TOTAL BY ld_loc).
		    IF LAST-OF(ld_loc) THEN DO:
		       display " " + trim(ld_loc) + " " + string( ACCUM TOTAL BY Ld_loc ld_qty_oh)
		       format "x(20)" skip with fram F1600 no-box.
		       V1400 = ld_loc + "!" .
		       leave.
		    END.
                END.
                /* LABEL 5 - END */




                display "Select Or E "  format "x(20)" skip
        skip with fram F1600 no-box.
	V1600 = "".
        Update V1600
        WITH  fram F1600 NO-LABEL
.

        /* PRESS e EXIST CYCLE */
        IF V1600 = "e" THEN  LEAVE MAINLOOP.

         /*  ---- Valid Check ---- START */

        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        leave V1600L.
     END.
     PV1600 = V1600.
     /* END    LINE :1600  显示2  */


end.
