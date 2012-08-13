
         {mfdeclre.i}
         {gplabel.i}    /* EXTERNAL LABEL INCLUDE */
        /*     DEFINE NEW SHARED VARIABLE START_date AS DATE.
             DEFINE NEW SHARED VARIABLE END_date AS DATE.
             DEFINE NEW SHARED VARIABLE START_time AS CHARACTER.
             DEFINE NEW SHARED VARIABLE END_time AS CHARACTER.
             define NEW SHARED VARIABLE   i_recid         as recid   no-undo.
             DEFINE NEW SHARED VARIABLE i_start_v LIKE xwo_seq.
             DEFINE NEW SHARED VARIABLE i_end_v  LIKE xwo_seq.
             ASSIGN START_date = 01/01/01.
             END_date = 05/05/05.
             FIND FIRST ABS_mstr WHERE ABS_id = "s00000002".
             ASSIGN i_recid = RECID(ABS_mstr). */
             /****
	     DEFINE SHARED VARIABLE START_date AS DATE.
             DEFINE SHARED VARIABLE END_date AS DATE.
             DEFINE SHARED VARIABLE START_time AS CHARACTER.
             DEFINE SHARED VARIABLE END_time AS CHARACTER.
             define SHARED VARIABLE ii_recid         as recid   no-undo.
             DEFINE SHARED VARIABLE i_start_v LIKE xwo_seq.
             DEFINE SHARED VARIABLE i_end_v  LIKE xwo_seq.
        ******Jane Wang*****/
	 
         DEFINE INPUT PARAMETER II_RECID AS RECID NO-UNDO.

	 DEFINE VAR t_DESC AS CHARACTER.
         DEFINE VAR t_part    LIKE cp_cust_part.
         DEFINE VAR shipfrom  LIKE ABS_shipfrom.
         DEFINE VAR id        LIKE ABS_id.
         DEFINE BUFFER absmstr FOR ABS_mstr.
         DEFINE VAR   temp_vx AS CHARACTER.

         find abs_mstr no-lock where recid(abs_mstr) = ii_recid
               no-error.
         if not available abs_mstr then return.
         ASSIGN shipfrom = ABS_shipfrom
             id = ABS_id.
         FIND FIRST ABSmstr WHERE absmstr.abs_shipfrom = abs_mstr.abs_shipfrom AND absmstr.ABS_par_id = ABS_mstr.ABS_id USE-INDEX abs_par_id NO-LOCK NO-ERROR.
/***	Jane***
 *	 FIND LAST xwo_srt WHERE xwo_seq = i_start_v AND xwo_lnr = "z700" NO-LOCK NO-ERROR.
 *        IF AVAILABLE xwo_srt THEN DO:
 *            ASSIGN START_date =  xwo_date
 *                START_time = string(xwo_time,"HH:MM:SS").
 *        END.
 *        FIND LAST xwo_srt WHERE xwo_seq = i_end_v AND xwo_lnr = "z700" NO-LOCK NO-ERROR.
 *        IF AVAILABLE xwo_srt THEN DO:
 *            ASSIGN end_date =  xwo_date
 *                end_time = string(xwo_time,"HH:MM:SS").
 *        END.
 *   /*      FORM HEADER
 *            SKIP(6)
 *            START_date COLON 50 
 *            START_time COLON 60  FORMAT "x(8)" 
 *            END_date     COLON 50 
 *            END_time     COLON 60 FORMAT "x(8)"  
 *        /*    absmstr.ABS_order    COLON 60 */ 
 *           SKIP(2)
 *            i_start_v          COLON 12 FORMAT ">>>>>>9"  
 *            i_end_v           COLON 12 FORMAT ">>>>>>9"  
 *            WITH STREAM-IO FRAME b NO-LABELS WIDTH 120 . */
 *   /*     FORM 
 *            SKIP(8)
 *            t_desc          COLON 10 NO-LABEL FORMAT "x(20)"
 *            t_part           NO-LABEL                  FORMAT "x(18)" 
 *            absmstr.ABS__qad02 COLON 58 NO-LABEL FORMAT "x(2)"
 *            absmstr.ABS_qty       COLON 66 NO-LABEL FORMAT  "->>>>9"
 *            WITH STREAM-IO NO-LABELS FRAME c  PAGE-TOP WIDTH 120. */
 *        PUT 
 *            SKIP(13)
 *            START_date AT 66 
 *            START_time AT 76  FORMAT "x(8)" SKIP
 *            END_date     AT 66 
 *            END_time     AT 76 FORMAT "x(8)"   SKIP
 *        /*    absmstr.ABS_order    AT 70 */ 
 *           SKIP(3)
 *            i_start_v          AT 14 FORMAT ">>>>>>9"  SKIP
 *            i_end_v           AT 14 FORMAT ">>>>>>9"  SKIP .
 *        PUT SKIP(15).
 ****************/
	 {mfselbpr.i "printer" 132} /*Jane***/
	 FOR EACH ABSmstr NO-LOCK WHERE absmstr.ABS_shipfrom = abs_mstr.abs_shipfrom AND absmstr.ABS_par_id = abs_mstr.abs_id USE-INDEX ABS_par_id:
             /*  VIEW FRAME b. */
                FIND FIRST so_mstr WHERE so_nbr = absmstr.ABS_order NO-LOCK NO-ERROR.
                IF NOT AVAILABLE so_mstr THEN NEXT.
                FIND FIRST cp_mstr WHERE cp_cust = so_cust AND cp_part = absmstr.ABS_item NO-LOCK NO-ERROR.
                IF AVAILABLE cp_mstr THEN DO:
                    t_DESC = cp_comment.
                    t_part =  cp_cust_part.
                END.
                ELSE do:
                    t_desc = "客户零件号不存在".
                    t_part = "".
                END.
                IF trim(t_desc) =  "" THEN DO:
                    FIND FIRST pt_mstr WHERE pt_part = absmstr.ABS_item NO-LOCK NO-ERROR.
                    IF AVAILABLE pt_mstr THEN DO:
                        t_desc = pt_desc1.
                    END.
                END.
/*Jane ****
 *               temp_vx = "".
 *               FOR EACH xwvxy_yfv NO-LOCK WHERE xwvxy_part = absmstr.ABS_item:
 *                   temp_vx = temp_vx  + xwvxy_vxcode + " ".
 *               END.
 *******/
		PUT 
                 t_desc AT 11 FORMAT "x(20)" " "
                    t_part at 38 FORMAT "x(18)" 
                    absmstr.ABS__qad02  AT 60 FORMAT "x(2)"
                    absmstr.ABS_qty AT 66  FORMAT  "->>>>9" SKIP.
 /*Jane**
  *		PUT temp_vx AT 11 FORMAT "x(40)" SKIP.
  *             put skip(1).
  ******/
		PUT skip(2).
           /*     DOWN 2 WITH FRAME c. */
                IF LINE-COUNTER + 2 > PAGE-SIZE THEN DO:
               /*     PUT GLOBAL_userid AT 20.   */
                    PAGE.
                END.
         END.

   	    
         if page-size - line-counter < 2 then page.
         do while page-size - line-counter >2:
            put skip(1).
         end.
          /*   PUT GLOBAL_userid AT 12 SKIP.   */
             PAGE.

	 {mfreset.i}     

