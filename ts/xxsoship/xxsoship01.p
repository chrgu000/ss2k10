/* SS - 111020.1 BY KEN                                                       */
/******************************************************************************/
/* SCHEDULE MAINTENANCE DETAIL SUBPROGRAM                                     */
/* DISPLAYS/MAINTAINS CUSTOMER LAST RECEIPT INFO                              */
/*V8:ConvertMode=Maintenance                                                  */

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

DEFINE SHARED VARIABLE file_name AS CHARACTER FORMAT "x(50)".
DEFINE SHARED VARIABLE v_qty_oh LIKE IN_qty_oh.
DEFINE SHARED VARIABLE fn_i AS CHARACTER.
DEFINE SHARED VARIABLE v_tr_trnbr LIKE tr_trnbr.
DEFINE SHARED VARIABLE v_flag AS CHARACTER.
DEFINE VARIABLE vdate as date.
DEFINE TEMP-TABLE ttld_det LIKE ld_det.
define variable vdata as character.

DEFINE SHARED TEMP-TABLE xxso
   FIELD xxso_nbr LIKE so_nbr
   FIELD xxso_effdate LIKE tr_effdate
   FIELD xxso_site LIKE so_site
   FIELD xxso_line LIKE sod_line
   FIELD xxso_part LIKE sod_part
   FIELD xxso_qty LIKE sod_qty_ord
   FIELD xxso_loc LIKE loc_loc
   FIELD xxso_error AS CHARACTER FORMAT "x(24)"
   INDEX index1 xxso_nbr.


DEFINE SHARED TEMP-TABLE xxso1
   FIELD xxso1_nbr LIKE so_nbr
   FIELD xxso1_effdate LIKE tr_effdate
   FIELD xxso1_site LIKE so_site
   FIELD xxso1_line LIKE sod_line
   FIELD xxso1_part LIKE sod_part
   FIELD xxso1_qty LIKE sod_qty_ord
   FIELD xxso1_loc LIKE loc_loc
   FIELD xxso1_lot LIKE tr_lot
   FIELD xxso1_lot_qty LIKE ld_det.ld_qty_oh
   FIELD xxso1_error AS CHARACTER FORMAT "x(24)"
   INDEX index1 xxso1_nbr.

FUNCTION str2Date RETURNS DATE(INPUT datestr AS CHARACTER):
    DEFINE VARIABLE sstr AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cfg  as CHARACTER NO-UNDO INITIAL "-".
    DEFINE VARIABLE iY   AS INTEGER   NO-UNDO.
    DEFINE VARIABLE iM   AS INTEGER   NO-UNDO.
    DEFINE VARIABLE id   AS INTEGER   NO-UNDO.
    DEFINE VARIABLE od   AS DATE      NO-UNDO.
    if datestr = "" OR datestr = ? then do:
        assign od = ?.
    end.
    else do:
        ASSIGN sstr = datestr.
        IF INDEX(sstr,"/") > 0 then assign cfg = "/".
        ASSIGN iY = INTEGER(SUBSTRING(sstr,1,INDEX(sstr,cfg) - 1)).
        ASSIGN sstr = SUBSTRING(sstr,INDEX(sstr,cfg) + 1).
        ASSIGN iM = INTEGER(SUBSTRING(sstr,1,INDEX(sstr,cfg) - 1)).
        ASSIGN iD = INTEGER(SUBSTRING(sstr,INDEX(sstr,cfg) + 1)).
        ASSIGN od = DATE(im,id,iy) NO-ERROR.
    end.
    RETURN od.
END FUNCTION.

/*V8+*/
/******* New Import data from xls for gui application *************************/
/*V8!
DEFINE VARIABLE excelAppl AS COM-HANDLE.
define variable xworkbook as com-handle.
define variable xworksheet as com-handle.
*/
DEFINE VARIABLE xpath AS CHARACTER.
DEFINE VARIABLE v_i AS INTEGER.
DEFINE VARIABLE v_j AS INTEGER.

DEFINE VARIABLE v_sum_part_qty AS DECIMAL.

   /*检查数据&cimload*/
   FOR EACH xxso:
       DELETE xxso.
   END.
   FOR EACH xxso1:
       DELETE xxso1.
   END.

   v_flag = "".
   xpath = FILE_name.

   if opsys = "unix" then do:
      input from value(xpath).
      repeat:
          import vdata.
          if vdata < "ZZZZZZZZZZZZZZ" then do:
          	 vdate = str2Date(entry(2,vdata,",")).
             create xxso.
             assign xxso_nbr = entry(1,vdata,",")
                    xxso_effdate = vdate
                    xxso_site = entry(3,vdata,",")
                    xxso_line = integer(entry(4,vdata,","))
                    xxso_qty = dec(entry(5,vdata,","))
                    xxso_loc = entry(6,vdata,",") no-error.
          end.
      end.
      input close.
   end. /* if opsys = "unix" then do: */

/*V8+*/
/******* New Import data from xls for gui application *************************/
/*V8!
else if opsys = "msdos" or opsys = "win32" then do:
   CREATE "Excel.Application" excelAppl.
   xworkbook = excelAppl:Workbooks:OPEN(xpath).
   xworksheet = excelAppl:sheets:item(1).
   DO v_i = 2 TO xworksheet:UsedRange:Rows:Count:
      IF xworksheet:cells(v_i,1):FormulaR1C1 <> "" and
         xworksheet:cells(v_i,1):FormulaR1C1 <> ?
          THEN DO:
      	 vdate = str2Date(xworksheet:cells(v_i,2):FormulaR1C1).
         CREATE xxso.
         ASSIGN xxso_nbr = string(xworksheet:cells(v_i,1):FormulaR1C1)
                xxso_effdate = vdate
                xxso_site = xworksheet:cells(v_i,3):FormulaR1C1
                xxso_line = xworksheet:cells(v_i,4):FormulaR1C1
                xxso_qty = xworksheet:cells(v_i,5):FormulaR1C1
                xxso_loc = string(xworksheet:cells(v_i,6):FormulaR1C1).
      END.
      ELSE DO:
         next.
      END.
   END.
   excelAppl:quit.
   release object excelAppl.
   RELEASE OBJECT xworkbook.
   RELEASE OBJECT xworksheet.
end. /* if opsys = "msdos" or opsys = "win32" then do:  */
*/

   for each xxso exclusive-lock:
       if xxso_nbr = "" then do:
          delete xxso.
       end.
   end.

   FIND FIRST xxso  NO-ERROR.
   IF NOT AVAIL xxso THEN DO:
      MESSAGE "无数据,请重新输入" VIEW-AS ALERT-BOX.
      v_flag = "1".
      /*
      PUT  "无数据,请重新输".
      */

   END.
   ELSE DO:

      FOR EACH xxso:
          FIND FIRST sod_det WHERE sod_domain = GLOBAL_domain
             AND sod_nbr = xxso_nbr
             AND sod_line = xxso_line
             NO-LOCK NO-ERROR.
          IF NOT AVAIL sod_det THEN DO:
             xxso_error = "订单不存在,请重新输入".
          END.
        else do:
            xxso_part = sod_part.
        end.
      END.


      FOR EACH xxso BREAK BY xxso_loc BY xxso_part:

         IF xxso_qty <=0 THEN DO:
              xxso_error = "错误:数量必须大于0".
         END.

         IF FIRST-OF(xxso_part) THEN DO:
            v_sum_part_qty = 0.
            v_qty_oh = 0.
            FOR EACH ld_det
              WHERE ld_domain = GLOBAL_domain
              AND ld_site = xxso_site
              AND ld_loc = xxso_loc
              AND ld_part = xxso_part
              AND ld_qty_oh <> 0
                NO-LOCK:
               v_qty_oh = v_qty_oh + ld_qty_oh.
            END.
         END.

         v_sum_part_qty = v_sum_part_qty + xxso_qty.

         IF v_qty_oh < v_sum_part_qty THEN DO:
            xxso_error = "错误:库存不足".
            FIND FIRST loc_mstr WHERE loc_domain = GLOBAL_domain
                   AND loc_loc = xxso_loc NO-LOCK NO-ERROR.
            IF NOT AVAIL loc_mstr THEN DO:
               xxso_error = "错误:库位不存在".
            END.
         END.
      END.

      FIND FIRST xxso WHERE xxso_error <> "" NO-LOCK NO-ERROR.
      IF AVAIL xxso THEN DO:
         v_flag = "2".
         /*
         FOR EACH xxso WHERE xxso_error <> "" NO-LOCK:
             DISP xxso WITH WIDTH 200 STREAM-IO.
         END.
         */
      END.
      ELSE DO:
          /*分配批号,发货*/

          EMPTY TEMP-TABLE ttld_det.
          FOR EACH xxso NO-LOCK BREAK BY xxso_site BY xxso_loc BY xxso_part:
              IF FIRST-OF(xxso_part) THEN DO:
                  FOR EACH ld_det WHERE ld_domain = GLOBAL_domain
                       AND ld_site = xxso_site AND ld_loc = xxso_loc
                       AND ld_part = xxso_part AND ld_qty_oh <> 0
                  NO-LOCK BY ld_lot:
                      CREATE ttld_det.
                      BUFFER-COPY ld_det TO ttld_det.
                  END.
              END.
          END.

          FOR EACH xxso:
             v_qty_oh = xxso_qty.
             /*分配批号和库存*/
             FOR EACH ttld_det WHERE ttld_det.ld_domain = GLOBAL_domain
                  AND ttld_det.ld_site = xxso_site
                  AND ttld_det.ld_loc = xxso_loc
                  AND ttld_det.ld_part = xxso_part
                  AND ttld_det.ld_qty_oh <> 0
             BY ttld_det.ld_lot:
                IF v_qty_oh <> 0 THEN DO:
                    IF v_qty_oh >= ttld_det.ld_qty_oh THEN DO:
                        CREATE xxso1.
                        ASSIGN xxso1_nbr = xxso_nbr
                            xxso1_effdate = xxso_effdate
                            xxso1_site = xxso_site
                            xxso1_line = xxso_line
                            xxso1_part = xxso_part
                            xxso1_qty = xxso_qty
                            xxso1_loc = xxso_loc
                            xxso1_lot = ttld_det.ld_lot
                            xxso1_lot_qty = ttld_det.ld_qty_oh.
                            v_qty_oh = v_qty_oh - ttld_det.ld_qty_oh.
                            ttld_det.ld_qty_oh = 0.
                    END.
                    ELSE DO:
                        CREATE xxso1.
                        ASSIGN xxso1_nbr = xxso_nbr
                            xxso1_effdate = xxso_effdate
                            xxso1_site = xxso_site
                            xxso1_line = xxso_line
                            xxso1_part = xxso_part
                            xxso1_qty = xxso_qty
                            xxso1_loc = xxso_loc
                            xxso1_lot = ttld_det.ld_lot
                            xxso1_lot_qty = v_qty_oh.
                            ttld_det.ld_qty_oh = ttld_det.ld_qty_oh - v_qty_oh.
                            v_qty_oh = 0.
                    END.
                END.
             END.
          END. /* for each xxso */

          FIND FIRST xxso1 WHERE xxso1_lot_qty <= 0 NO-LOCK NO-ERROR.
          IF AVAIL xxso1 THEN DO:
             v_flag = "2".
          END.
          ELSE DO:
              do transaction:
                  /*cimload */
                  {gprun.i ""xxsoship02.p""}
                  v_flag = "3".
              END.
          END.
      END.
   END.
