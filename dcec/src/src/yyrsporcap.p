{mfdtitle.i "2+ "}
{yyzzut001a.i}
{yyedcomlib.i}
IF f-howareyou("HAHA") = NO THEN LEAVE.

def var v_app as logical.
define variable disp_abs_id       like abs_id.
define variable abs_recid         as recid.
define shared variable global_recid as recid.


DEF TEMP-TABLE xxwk1
    FIELDS xxwk1_nbr_asn AS CHAR
    FIELDS xxwk1_order   AS CHAR
    FIELDS xxwk1_line    AS INTEGER
    FIELDS xxwk1_part    AS CHAR
    FIELDS xxwk1_desc    AS CHAR
    FIELDS xxwk1_qty     AS DECIMAL
    FIELDS xxwk1_um      AS CHAR
    FIELDS xxwk1_price   AS DECIMAL
    FIELDS xxwk1_amt     AS DECIMAL
    FIELDS xxwk1_cumord  AS DECIMAL
    FIELDS xxwk1_cumrct  AS DECIMAL
    FIELDS xxwk1_err     AS CHAR
    .

/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A
FORM
    RECT-FRAME       AT ROW 1.4 COLUMN 1.25
    RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
    SKIP(.1)  /*GUI*/

   abs_mstr.abs_shipfrom colon 25 label "供应商"
   ad_name               at 45    no-label
   abs_mstr.abs_id       colon 25 label "发货单号"
   ad_line1              at 45    no-label
   ABS_mstr.ABS_shipto  COLON 25  LABEL "货物发往"
   ABS_mstr.ABS_shp_date COLON 25 LABEL "发货日期"
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

DEF FRAME f-b
    xxwk1_part   FORMAT "x(12)"  COLUMN-LABEL "零件号"
    xxwk1_desc   FORMAT "x(24)"  COLUMN-LABEL "描述"
    xxwk1_qty                    COLUMN-LABEL "数量"
    xxwk1_um     FORMAT "x(2)"   COLUMN-LABEL "单位"
    xxwk1_price                  COLUMN-LABEL "单价"
    xxwk1_amt                    COLUMN-LABEL "金额"
    xxwk1_order  FORMAT "x(8)"   COLUMN-LABEL "订单"
    xxwk1_line   FORMAT ">>9"   COLUMN-LABEL "行"
    xxwk1_cumord            COLUMN-LABEL "累计计划量"     
    xxwk1_cumrct            COLUMN-LABEL "累计收货量"     
    xxwk1_err    FORMAT "x(30)"  COLUMN-LABEL "提示信息"
WITH WIDTH 180 ROW 7 10 DOWN TITLE "".



for first abs_mstr
fields (abs_cum_qty abs_id abs_line abs_loc abs_lotser abs_order
        abs_qty abs_ref abs_shipfrom abs_shipto abs_ship_qty
        abs_shp_date abs_site abs_status abs_type abs__qad06
        abs__qad02)
where recid(abs_mstr) = global_recid
no-lock: end.

if available abs_mstr and abs_id begins "S" and abs_type = "R"
then do:

   for first ad_mstr
      fields (ad_addr ad_edi_ctrl ad_line1 ad_name)
   where ad_addr = abs_shipfrom
   no-lock: end.

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
               "abs_id begins ""s"" and abs_type = ""r"""
               abs_shipfrom
               "input abs_shipfrom"}

            if recno <> ? then do:

               for first ad_mstr
                  fields (ad_addr ad_edi_ctrl ad_line1 ad_name)
               where ad_addr = abs_shipfrom
               no-lock: end.

               assign
                  disp_abs_id = substring(abs_id,2,50).

               display
                  abs_shipfrom
                  disp_abs_id     @ abs_id
                   ABS_shipto
                   ABS_shp_date

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
                               abs_id begins ""S"" and abs_type = ""R"""
                               abs_id """S"" + input abs_id"}

            if recno <> ? then do:

               for first ad_mstr
                  fields (ad_addr ad_edi_ctrl ad_line1 ad_name)
               where ad_addr = abs_shipfrom
               no-lock: end.

               assign
                  disp_abs_id = substring(abs_id,2,50).

               display
                  abs_shipfrom
                  disp_abs_id     @ abs_id
                   ABS_shipto
                   ABS_shp_date

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

      for first vd_mstr
         fields (vd_addr vd_type)
      where vd_addr = input abs_shipfrom
      no-lock: end.

      if not available vd_mstr then do:
         /* Not a valid Supplier */
         {pxmsg.i &MSGNUM=2 &ERRORLEVEL=3}
         next-prompt abs_shipfrom.
         undo, retry.
      end.

      for first ad_mstr
         fields (ad_addr ad_edi_ctrl ad_line1 ad_name)
      where ad_addr = input abs_shipfrom
      no-lock: end. /* FOR FIRST AD_MSTR */

      display
         ad_name
         ad_line1.

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
      and abs_type     = "R"
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
   IF substring(abs_mstr.abs_status,11,1) = "Y" THEN v_app = yes.
   ELSE v_app = NO.
   ABS_recid = RECID(ABS_mstr).

   display
      v_app
      ABS_shipto
      ABS_shp_date
   with frame a.
     RUN xxpro-bud (INPUT ABS_recid).
	 run xxpro-view.
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


/*--------*/
PROCEDURE xxpro-view:
    MainBlock:
    do on error undo,leave on endkey undo,leave:
        { yyzzut001b.i
          &file = "xxwk1"
          &where = "where yes = yes"
          &frame = "f-b"
          &fieldlist = "
            xxwk1_part  
            xxwk1_desc  
            xxwk1_qty   
            xxwk1_um    
            xxwk1_price 
            xxwk1_amt   
            xxwk1_order 
            xxwk1_line  
            xxwk1_cumord
            xxwk1_cumrct
            xxwk1_err   
                       "
          &prompt     = "xxwk1_part"
          &midchoose  = "color mesages"
        }
    end. /*MAIN BLOCK */
END PROCEDURE.


/*--------*/
PROCEDURE xxpro-bud:
    DEF INPUT PARAMETER p_recid AS RECID.
    DEF VAR v_shipper_num AS CHAR.
    DEF VAR v_shipper_fr  AS CHAR.
    DEF VAR v_shipper_dt  AS DATE.

    FOR EACH xxwk1: DELETE xxwk1. END.
    FIND FIRST ABS_mstr WHERE RECID(ABS_mstr) = p_recid NO-LOCK NO-ERROR.
    IF AVAILABLE ABS_mstr THEN ASSIGN
        v_shipper_num = abs_id
        v_shipper_fr  = ABS_shipfrom
        v_shipper_dt  = ABS_shp_date.
    FOR EACH abs_mstr NO-LOCK WHERE ABS_type = "R"
        AND ABS_shipfrom = v_shipper_fr
        AND ABS_par_id   = v_shipper_num:
        CREATE xxwk1.
        ASSIGN 
            xxwk1_part = ABS_item
            xxwk1_qty  = ABS_qty
            xxwk1_order = abs_order
            xxwk1_line  = INTEGER(ABS_line)
            .
        xxwk1_desc = f-getpartdata(xxwk1_part, "pt_desc1").
        xxwk1_um   = f-getpartdata(xxwk1_part, "pt_um").
        xxwk1_price = f-getpoprice(xxwk1_nbr, xxwk1_line, v_shipper_dt,xxwk1_qty).
        xxwk1_amt   = xxwk1_price * xxwk1_qty.

        FIND FIRST pod_det WHERE pod_nbr = xxwk1_nbr AND pod_line = xxwk1_line NO-LOCK NO-ERROR.
        IF AVAILABLE pod_det THEN DO:
            ASSIGN xxwk1_cumrct = pod_cum_qty[1].
            FOR EACH schd_det NO-LOCK 
                where schd_type = 4
                and schd_rlse_id = pod_curr_rlse_id[1] 
                and schd_nbr = pod_nbr 
                and schd_line = pod_line 
                AND schd_fc_qual = "F"
                AND schd_date - pod_translt_days <= v_shipper_dt:

                ASSIGN xxwk1_cumord = xxwk1_cumord + schd_discr_qty.
            END.
        END.
        IF xxwk1_cumord - xxwk1_cumrct - xxwk1_qty < 0 THEN ASSIGN xxwk1_err = "累计收货量超过计划量".
    END.

    
END PROCEDURE.
