{mfdtitle.i "2+ "}
{yyedcomlib.i}
IF f-howareyou("HAHA") = NO THEN LEAVE.

def var v_app as logical.
define variable disp_abs_id       like abs_id.
define variable abs_recid         as recid.
define shared variable global_recid as recid.
DEF    VAR      v_showdetail      AS LOGICAL NO-UNDO INITIAL NO.



DEF TEMP-TABLE xxwk1
    FIELDS xxwk1_nbr_asn LIKE ABS_id
    FIELDS xxwk1_order   LIKE so_nbr
    FIELDS xxwk1_line    LIKE sod_line
    FIELDS xxwk1_part    LIKE sod_part
    FIELDS xxwk1_desc    LIKE pt_desc1
    FIELDS xxwk1_qty     LIKE sod_qty_ord
    FIELDS xxwk1_um      LIKE pt_um
    FIELDS xxwk1_price   LIKE sod_price
    FIELDS xxwk1_amt     LIKE glt_amt
    FIELDS xxwk1_cumord  AS DECIMAL
    FIELDS xxwk1_cumrct  AS DECIMAL
    FIELDS xxwk1_err     AS CHAR
    .
DEF TEMP-TABLE xxwk2
    FIELDS xxwk2_nbr_asn     LIKE ABS_id
    FIELDS xxwk2_shp_date    LIKE ABS_shp_date
    FIELDS xxwk2_shipfr      LIKE ABS_shipfrom
    FIELDS xxwk2_name_shipfr LIKE ad_name
    FIELDS xxwk2_shipto      LIKE ABS_shipto
    FIELDS xxwk2_name_shipto LIKE ad_name
    FIELDS xxwk2_soldto      LIKE so_cust
    FIELDS xxwk2_name_soldto LIKE ad_name
    FIELDS xxwk2_st_app      AS LOGICAL INITIAL NO LABEL "已批准"
    FIELDS xxwk2_st_iss      AS LOGICAL INITIAL NO LABEL "已发货"
    .
     


/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A
FORM
    RECT-FRAME       AT ROW 1.4 COLUMN 1.25
    RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
    SKIP(.1)  /*GUI*/

   abs_mstr.abs_shipfrom colon 25 label "发货地点"
   si_desc               at 45    no-label
   abs_mstr.abs_id       colon 25 label "发货单号"
   ABS_mstr.ABS_shipto  COLON 25  LABEL "货物发往"
    ad_name               AT 45    NO-LABEL
    ad_line1              at 45    no-label
   ABS_mstr.ABS_shp_date COLON 25 LABEL "发货日期"

    v_showdetail        COLON 25  LABEL "查看明细"
    v_app                COLON 25  LABEL "批准"
    SKIP
    SKIP(.4)  /*GUI*/
    WITH FRAME a SIDE-LABELS WIDTH 80 NO-BOX THREE-D.

DEFINE VARIABLE F-a-title AS CHARACTER.
F-a-title = &IF (DEFINED(SELECTION_CRITERIA) = 0)
            &THEN " Selection Criteria "
            &ELSE {&SELECTION_CRITERIA}
            &ENDIF .
RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
RECT-FRAME-LABEL:WIDTH-PIXELS in frame a =
                 FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
                 RECT-FRAME-LABEL:SCREEN-VALUE in frame a + " ", 
                 RECT-FRAME-LABEL:FONT).
RECT-FRAME:HEIGHT-PIXELS in frame a = FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5. /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).


for first abs_mstr
fields (abs_cum_qty abs_id abs_line abs_loc abs_lotser abs_order
        abs_qty abs_ref abs_shipfrom abs_shipto abs_ship_qty
        abs_shp_date abs_site abs_status abs_type abs__qad06
        abs__qad02)
where recid(abs_mstr) = global_recid
no-lock: end.

if available abs_mstr and abs_id begins "S" and abs_type = "S"
then do:

   for first ad_mstr
      fields (ad_addr ad_edi_ctrl ad_line1 ad_name)
   where ad_addr = abs_shipto
   no-lock: end.

   for first si_mstr
      fields (si_site si_desc)
   where si_site = abs_shipfrom
   NO-LOCK: END.

   display
      abs_shipfrom
      substring(abs_id,2,50) @ abs_id
      ad_name
      ad_line1

       ABS_shipto
       ABS_shp_date
   with frame a.

   IF substring(abs_mstr.abs_status,11,1) = "Y" THEN v_app = yes.
   ELSE v_app = NO.

   display
      v_app
   with frame a.

end.

mainloop:
repeat:

   do transaction with frame a:

      prompt-for abs_shipfrom abs_id
      editing:

         if frame-field = "abs_shipfrom" then do:

            {mfnp05.i abs_mstr abs_id
               "abs_id begins ""s"" and abs_type = ""s"""
               abs_shipfrom
               "input abs_shipfrom"}

            if recno <> ? then do:

                for first si_mstr
                   fields (si_site si_desc)
                where si_site = abs_shipfrom
                NO-LOCK: END.

               for first ad_mstr
                  fields (ad_addr ad_edi_ctrl ad_line1 ad_name)
               where ad_addr = abs_shipto
               no-lock: end.

               assign
                  disp_abs_id = substring(abs_id,2,50).

               display
                  abs_shipfrom
                  disp_abs_id     @ abs_id
                   ABS_shipto
                   ABS_shp_date
                  si_desc         WHEN(AVAILABLE si_mstr)
                  ""              when(not available si_mstr) @ si_desc
                  ad_name         when(available ad_mstr)
                  ""              when(not available ad_mstr) @ ad_name
                  ad_line1        when(available ad_mstr)
                  ""              when(not available ad_mstr) @ ad_line1.

            end.

         end. /* if frame-field = abs_shipfrom */

         else if frame-field = "abs_id" then do:

            global_addr = input abs_shipfrom.

            {mfnp05.i abs_mstr abs_id
               "abs_shipfrom = input abs_shipfrom and
                               abs_id begins ""S"" and abs_type = ""S"""
                               abs_id """S"" + input abs_id"}

            if recno <> ? then do:

                for first si_mstr
                   fields (si_site si_desc)
                where si_site = abs_shipfrom
                NO-LOCK: END.
               
                for first ad_mstr
                  fields (ad_addr ad_edi_ctrl ad_line1 ad_name)
               where ad_addr = abs_shipto
               no-lock: end.

               assign
                  disp_abs_id = substring(abs_id,2,50).

               display
                  abs_shipfrom
                  disp_abs_id     @ abs_id
                   ABS_shipto
                   ABS_shp_date
                   si_desc         WHEN(AVAILABLE si_mstr)
                   ""              when(not available si_mstr) @ si_desc

                  ad_name         when(available ad_mstr)
                  ""              when(not available ad_mstr) @ ad_name
                  ad_line1        when(available ad_mstr)
                  ""              when(not available ad_mstr) @ ad_line1.

            end.

         end. /* if frame-field = abs_id */

         else do:
            status input.
            readkey.
            apply lastkey.
         end.

      end.

      for first si_mstr
         fields (si_site si_desc)
      where si_site = input abs_shipfrom
      no-lock: end.

      if not available si_mstr then do:
         /* Not a valid Supplier */
         {pxmsg.i &MSGNUM=2 &ERRORLEVEL=3}
         next-prompt abs_shipfrom.
         undo, retry.
      end.
        /*        
      for first ad_mstr
         fields (ad_addr ad_edi_ctrl ad_line1 ad_name)
      where ad_addr = input abs_shipfrom
      no-lock: end. /* FOR FIRST AD_MSTR */

      display
         ad_name
         ad_line1.
      */
      DISP si_desc WITH FRAME a.

      if input abs_id = "" then do:
         /* Shipper ID Required */
         {pxmsg.i &MSGNUM=8188 &ERRORLEVEL=3}
         undo, retry.
      end.

   end.

   for first abs_mstr
   fields (abs_cum_qty abs_id abs_line abs_loc abs_lotser abs_order
           abs_qty abs_ref abs_shipfrom abs_shipto abs_ship_qty
           abs_shp_date abs_site abs_status abs_type abs__qad06
           abs__qad02)
    where abs_shipfrom = input abs_shipfrom
      and abs_id       = "S" + input abs_id
      and abs_type     = "S"
   no-lock: end.

   if not available abs_mstr then do:
      /* Shipper ID does not exist */
      {pxmsg.i &MSGNUM=8189 &ERRORLEVEL=3}
      undo, retry.
   end.



   if substring(abs_status,2,1) = "y" then do:
      /* Shipper previously confirmed */
      {pxmsg.i &MSGNUM=8146 &ERRORLEVEL=3}
      undo mainloop, retry.
   end.

   /*james*/
   IF substring(abs_mstr.ABS_status,11,1) = "Y" THEN v_app = yes.
   ELSE v_app = NO.
   ABS_recid = RECID(ABS_mstr).

   display
       v_showdetail
      v_app

      ABS_shipto
      ABS_shp_date
   with frame a.
   UPDATE v_showdetail WITH FRAME a.
   IF v_showdetail = YES THEN DO:
        /*review*/ 
        {mfselprt.i "terminal" 80}
        RUN xxpro-report (INPUT ABS_recid).
        {mfreset.i}
        {mfgrptrm.i} /*Report-to-Window*/

   END.
   UPDATE v_app WITH FRAME a.
   RUN xxpro-update (INPUT ABS_recid, v_app).

END.

/*---------*/
PROCEDURE xxpro-update:
    DEF INPUT PARAMETER X_recid AS RECID.
    DEF INPUT PARAMETER X_app   AS LOGICAL.
    FIND FIRST ABS_mstr WHERE RECID(ABS_mstr) = X_recid NO-ERROR.
    IF AVAILABLE ABS_mstr THEN DO:
        IF x_app = YES THEN OVERLAY(ABS_mstr.ABS_status,11,1) = "Y".
        ELSE OVERLAY(ABS_mstr.ABS_status,11,1) = "N".
        RELEASE ABS_mstr.
    END.
END.
/***************************/
PROCEDURE xxpro-report:
    DEF INPUT PARAMETER X_recid AS RECID.
    FIND FIRST ABS_mstr WHERE RECID(ABS_mstr) = X_recid NO-LOCK NO-ERROR.
    IF NOT AVAILABLE ABS_mstr THEN DO:
        LEAVE.
    END.
    FOR EACH xxwk1:
        DELETE xxwk1.
    END.
    FOR EACH xxwk2:
        DELETE xxwk2.
    END.
    CREATE xxwk2.
    ASSIGN 
        xxwk2_nbr_asn  = SUBSTRING(ABS_id,2)
        xxwk2_shipfr   = ABS_shipfrom
        xxwk2_shipto   = ABS_shipto
        xxwk2_shp_date = ABS_shp_date.
    IF SUBSTRING(ABS_status,2,1) = "y" THEN xxwk2_st_iss = YES. ELSE xxwk2_st_iss = NO.
    IF SUBSTRING(ABS_status,11,1) = "y" THEN xxwk2_st_app = YES. ELSE xxwk2_st_app = NO.

    FOR EACH ABS_mstr NO-LOCK
        WHERE ABS_type = "S"
        AND ABS_shipfrom = xxwk2_shipfr
        AND ABS_par_id = "S" + xxwk2_nbr_asn
        AND ABS_id BEGINS "I":

        FIND FIRST xxwk1 WHERE xxwk1_order = ABS_mstr.ABS_order AND integer(ABS_mstr.ABS_line) = xxwk1_line NO-ERROR.
        IF NOT AVAILABLE xxwk1 THEN DO:
            CREATE xxwk1.
            ASSIGN 
                xxwk1_order = ABS_mstr.ABS_order
                xxwk1_line  = integer(ABS_mstr.ABS_line)
                xxwk1_part  = abs_mstr.abs_item
                xxwk1_price = abs_price
                .
        END.
        ASSIGN
            xxwk1_qty   = xxwk1_qty + abs_mstr.abs_qty.
    END.

    DEF BUFFER bbabs_mstr FOR ABS_mstr.
    FOR EACH bbABS_mstr NO-LOCK
        WHERE ABS_type = "S"
        AND ABS_shipfrom = xxwk2_shipfr
        AND ABS_par_id = "S" + xxwk2_nbr_asn
        AND bbABS_mstr.ABS_id BEGINS 'C':
        

        FOR EACH abs_mstr WHERE abs_mstr.ABS_shipfrom = bbabs_mstr.ABS_shipfrom
            AND abs_mstr.ABS_par_id = bbabs_mstr.abs_id
            AND ABS_mstr.abs_type = 's'
            AND ABS_mstr.ABS_id BEGINS 'I'
            NO-LOCK:

            FIND FIRST xxwk1 WHERE xxwk1_order = ABS_mstr.ABS_order AND integer(ABS_mstr.ABS_line) = xxwk1_line NO-ERROR.
            IF NOT AVAILABLE xxwk1 THEN DO:
                CREATE xxwk1.
                ASSIGN 
                    xxwk1_order = ABS_mstr.ABS_order
                    xxwk1_line  = integer(ABS_mstr.ABS_line)
                    xxwk1_part  = abs_mstr.abs_item
                    xxwk1_price = abs_price
                    .
            END.
            ASSIGN
                xxwk1_qty   = xxwk1_qty + abs_mstr.abs_qty.
        END.
    END.

    FOR EACH xxwk2:
        DISP xxwk2 WITH FRAME f-a WIDTH 132 2 COLUMNS STREAM-IO.
        FOR EACH xxwk1:
            find first pt_mstr where pt_part = xxwk1_part no-lock no-error.
            if available pt_mstr then assign
                xxwk1_desc = pt_desc1
                xxwk1_um   = pt_um.
            xxwk1_amt = xxwk1_qty * xxwk1_price.

            DISP 
                xxwk1_order 
                xxwk1_line  
                xxwk1_part  
                xxwk1_desc  
                xxwk1_qty   
                xxwk1_um    
                /*xxwk1_price 
                xxwk1_amt*/
            WITH FRAME f-b WIDTH 132 DOWN STREAM-IO.
        END.
    END.

END PROCEDURE.
