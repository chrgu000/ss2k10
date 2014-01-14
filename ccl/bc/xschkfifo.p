define input parameter checklot like ld_lot.  /**/
define input parameter MinLot like ld_lot.
define output parameter ErrorRetry as logical.
define output parameter wtr__chr04 like tr__chr04.
define variable TMESSAGE  as char format "x(80)" init "".
define variable wtimeout as integer init 99999 .


     V1505L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1505           as char format "x(48)".
        define variable PV1505          as char format "x(48)".
        define variable L15051          as char format "x(40)".
        define variable L15052          as char format "x(40)".
        define variable L15053          as char format "x(40)".
        define variable L15054          as char format "x(40)".
        define variable L15055          as char format "x(40)".
        define variable L15056          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


              display "[FIFO CONTROL]"  format "x(40)" skip with fram F1505 no-box.

                /* LABEL 1 - START */ 
                L15051 = "MIN LOT:" .
                display L15051  + MinLot        format "x(40)" skip with fram F1505 no-box.
                /* LABEL 1 - END */ 

                L15052 = "ISS LOT:" . 
                display L15052 + checklot         format "x(40)" skip with fram F1505 no-box.
                /* LABEL 2 - END */ 


                L15053 = "*违反FIFO逻辑*" . 
                display L15053          format "x(40)" skip with fram F1505 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                L15054 = "" .
                display L15054          format "x(40)" skip with fram F1505 no-box.
                /* LABEL 4 - END */ 
                display "确定按Y或E退回 "      format "x(40)" skip
        skip with fram F1505 no-box.
        Update V1505
        WITH  fram F1505 NO-LABEL
        EDITING:
          readkey pause wtimeout.
          if lastkey = -1 Then quit.
        if LASTKEY = 404 Then Do: /* DISABLE F4 */
           pause 0 before-hide.
           undo, retry.
        end.
           apply lastkey.
        end.





        /* PRESS e EXIST CYCLE */
        IF V1505 = "e" then do:
	   ErrorRetry = yes.
           wtr__chr04 = "".
	   LEAVE V1505L.
	END.
        display  skip TMESSAGE NO-LABEL with fram F1505.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ TMESSAGE NO-LABEL with fram F1505.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        IF trim(V1505) <> "Y"  THEN DO:
                display skip "Y E Only , Retry" @ TMESSAGE NO-LABEL with fram F1505.
                pause 0 before-hide.
                undo, retry.
        end.

        /*  ---- Valid Check ---- END */

        display  "" @ TMESSAGE NO-LABEL with fram F1505.
        pause 0.
        wtr__chr04 = "".
        ErrorRetry = no.
	leave V1505L.
     END.
     
     if V1505 = "Y" then do:
	     V1506xL:
	     REPEAT:

		/* --DEFINE VARIABLE -- START */
		hide all.
		define variable V1506x           as char format "x(48)".
		define variable PV1506x          as char format "x(48)".
		define variable L1506x1          as char format "x(40)".
		define variable L1506x2          as char format "x(40)".
		define variable L1506x3          as char format "x(40)".
		define variable L1506x4          as char format "x(40)".
		define variable L1506x5          as char format "x(40)".
		define variable L1506x6          as char format "x(40)".
		/* --DEFINE VARIABLE -- END */


		      display "[FIFO CONTROL]"  format "x(40)" skip with fram F1506x no-box.

			/* LABEL 1 - START */ 
			L1506x1 = " " .
			display L1506x1           format "x(40)" skip with fram F1506x no-box.
			/* LABEL 1 - END */ 

			L1506x2 = " " . 
			display L1506x2           format "x(40)" skip with fram F1506x no-box.
			/* LABEL 2 - END */ 


			L1506x3 = "" . 
			display L1506x3          format "x(40)" skip with fram F1506x no-box.
			/* LABEL 3 - END */ 


			/* LABEL 4 - START */ 
			L1506x4 = "" .
			display L1506x4          format "x(40)" skip with fram F1506x no-box.
			/* LABEL 4 - END */ 
			display "输入原因/单号或E退回 "      format "x(40)" skip
		skip with fram F1506x no-box.
		Update V1506x
		WITH  fram F1506x NO-LABEL
		EDITING:
		  readkey pause wtimeout.
		  if lastkey = -1 Then quit.
		if LASTKEY = 404 Then Do: /* DISABLE F4 */
		   pause 0 before-hide.
		   undo, retry.
		end.
		   apply lastkey.
		end.





		/* PRESS e EXIST CYCLE */
		IF V1506x = "e" then do:
		   ErrorRetry = yes.
		   wtr__chr04 = "".
		   LEAVE V1506xL.
		END.
		display  skip TMESSAGE NO-LABEL with fram F1506x.

		 /*  ---- Valid Check ---- START */

		display "...PROCESSING...  " @ TMESSAGE NO-LABEL with fram F1506x.
		pause 0.
		/* CHECK FOR NUMBER VARIABLE START  */
		/* CHECK FOR NUMBER VARIABLE  END */
		IF trim(V1506x) = ""  THEN DO:
			display skip "Can't Blank , Retry" @ TMESSAGE NO-LABEL with fram F1506x.
			pause 0 before-hide.
			undo, retry.
		end.

		/*  ---- Valid Check ---- END */

		display  "" @ TMESSAGE NO-LABEL with fram F1506x.
		pause 0.
		wtr__chr04 = V1506x.
		ErrorRetry = no.
		leave V1506xL.
	     END.
      end.  /* if V1505 = "Y" then do: */