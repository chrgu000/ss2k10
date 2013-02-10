/* GUI CONVERTED from yyscximp0.p (converter v1.78) Thu Dec  6 14:46:56 2012 */
/* yyscximp0.p - procedureDesc                                               */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION END                                                              */


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT
{mfdeclre.i}
{yyscximp.i}

define variable intI as integer.
define variable intJ as integer.
define variable excelAppl as com-handle.
define variable xworkbook as com-handle.
define variable xworksheet as com-handle.
define variable fn as character.
define variable errorst as logical.
define variable errornum as integer.
define variable xx as character initial "schtype3".


FUNCTION c2d RETURNS date(idate as character) forward.
empty temp-table xsch_data no-error.

  assign fn = file_name.
  CREATE "Excel.Application" excelAppl.

   xworkbook = excelAppl:Workbooks:OPEN(fn,,true).
   xworksheet = excelAppl:sheets:item(1).

   assign rlseid_from = trim(string(xworksheet:cells(2,4):FormulaR1C1)).
   if rlseid_from = "" then do:
       {gprun.i ""gpnrmgv.p"" "(xx,input-output rlseid_from, output errorst
                                 ,output errornum)" }
       if errornum <> 0 then do:
          {pxmsg.i &MSGNUM=errornum
                   &MSGARG1=xx
                   &ERRORLEVEL=3}
          undo,leave.
       end.
   end.
   DO intI = 5 TO xworksheet:UsedRange:Rows:Count:
      intJ = 6.
      if rlseid_from = "" then leave.
         test:
         do while xworksheet:cells(3,intJ):FormulaR1C1 <> "":
            if trim(xworksheet:cells(inti,intJ):FormulaR1C1) <> ? then do:
            CREATE xsch_data.
            ASSIGN xsd_nbr = string(xworksheet:cells(intI,1):FormulaR1C1)
                   xsd_line = xworksheet:cells(intI,2):FormulaR1C1
                   xsd_part = string(xworksheet:cells(intI,3):FormulaR1C1)
                   xsd_pcr_qty = xworksheet:cells(intI,4):FormulaR1C1
                   xsd_pcs_date = c2d(xworksheet:cells(intI,5):FormulaR1C1)
                   xsd_fc_qual = xworksheet:cells(2,intJ):FormulaR1C1
                   xsd_date = c2d(xworksheet:cells(3,intJ):FormulaR1C1)
                   xsd_time = string(xworksheet:cells(4,intJ):FormulaR1C1)
                   xsd_upd_qty = xworksheet:cells(inti,intJ):FormulaR1C1
                   .
            end.
            if trim(xworksheet:cells(2,intJ):FormulaR1C1) = ? then leave test.
            intj = intj + 1.
            if intJ > 256 then leave test.
         end.
   END.

   excelAppl:quit.
   release OBJECT xworksheet.
   release OBJECT xworkbook.
   release object excelAppl.

FUNCTION c2d RETURNS date(idate as character):
 /* -----------------------------------------------------------
    Purpose:
    Parameters:  <none>
    Notes:
  -------------------------------------------------------------*/
  define variable odate as date.
  if idate = "" then do:
     assign odate = today.
  end.
  else do:
    assign odate = date(integer(substring(idate,6,2)),
                        integer(substring(idate,9,2)),
                        integer(substring(idate,1,4))).
  end.
  return odate.
END FUNCTION. /*FUNCTION c2d*/
