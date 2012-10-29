/* xxfcsimp.p - Forecast import from xls                                      */
/*V8:ConvertMode=Report                                                       */

/* DISPLAY TITLE */
{mfdeclre.i}
def shared var thfile as CHAR FORMAT "x(50)".
define var mymsg as char no-undo.
def shared var bexcel as com-handle.
def shared var bbook as com-handle.
def shared var bsheet as com-handle.
def stream bfi.
def stream bfo.
def stream bfoo.
DEFINE VAR infile AS CHAR   FORMAT "x(50)" .
DEFINE VAR outfile AS CHAR  FORMAT "x(50)" .
DEFINE VAR logfile AS CHAR.

define var flag1 as log no-undo.
define var flag2 as log no-undo.
define var flag3 as log no-undo.

DEFINE VAR myi AS INT NO-UNDO.
DEFINE VAR thchar AS CHAR NO-UNDO.

DEFINE SHARED TEMP-TABLE mytt
    FIELD f01 AS CHAR
    FIELD f02 AS CHAR
    FIELD f03 AS CHAR
    FIELD f04 AS CHAR
    FIELD f05 AS CHAR format "x(18)"
    FIELD f06 AS CHAR
    FIELD f07 AS CHAR format "x(18)"
    FIELD f08 AS CHAR format "x(18)"
    FIELD f09 AS CHAR
    FIELD f10 AS CHAR
    FIELD f11 AS CHAR
    FIELD f12 AS CHAR format "x(48)"
    .


  define temp-table mytr field mytr_rec as recid .

  on create of tr_hist do:
    find first mytr where mytr_rec = recid(tr_hist) no-lock no-error.
    if not available mytr then do:
      create mytr. mytr_rec = recid(tr_hist).
    end.
  end.







  logfile =  mfguser + substring(string(today),1,2) + substring(string(today),4,2)
                      + substring(string(today),7,2) + "_" + substring(string(time,"HH:MM"),1,2)
	              + substring(string(time,"HH:MM"),4,2) + substring(string(time,"HH:MM:SS"),7,2)
      + ".log".
  FOR EACH mytt:
      infile = mfguser + substring(string(today),1,2) + substring(string(today),4,2)
                      + substring(string(today),7,2) + "_" + substring(string(time,"HH:MM"),1,2)
	              + substring(string(time,"HH:MM"),4,2) + substring(string(time,"HH:MM:SS"),7,2).
      outfile = infile + ".out".
      infile = infile + ".in".
      OUTPUT TO value(infile).
      PUT   UNFORMAT F01 "  " F02 "  " skip.
      put   UNFORMAT F06 " " F06 " - - - - " F03 " " F03 " " F05 " " F05 " " F04 " " F06 " " F07 " " .
      put  date(int(substring(F11,5,2)),int(substring(F11,7,2)),int(substring(F11,1,4)))  SKIP.
      put  " " SKIP.
      put  unformat F05 " " SKIP.
      put  UNFORMAT F10 " - " F08 " " F09 SKIP.
      put  " " SKIP.
      put  " " SKIP.
      put  " " SKIP.
      put  "." skip.
      OUTPUT  CLOSE.
      for each mytr : delete mytr . end .
      INPUT FROM VALUE(infile).
      OUTPUT TO VALUE(outfile).
      batchrun = yes.
      {gprun.i ""xxsocnuac.p"" }
      batchrun = no.
      OUTPUT CLOSE.
      INPUT CLOSE.
      flag1 = false.
      flag2 = false.
      flag3 = false.
      for each mytr:
         	find first tr_hist where recid(tr_hist) = mytr_rec no-error .
         	if avail tr_hist    then do:
            if tr_type = "CN_USE" and tr_nbr = F03 and tr_part = F05 then do:
              flag1 = true.
            end.
            if tr_type = "Iss-so" and tr_nbr = F03 and tr_part = F05 then do:
              flag2 = true.
            end.
            release tr_hist.
         	end.
      end.
      if flag1 and flag2 then f12 = "true".
      else f12 = "false".
      run dataout(input outfile,output mymsg).
      f12 = f12 + ";" + mymsg.
  END.
  myi = 3.
  for each mytt:
     Bsheet:cells(myi, 1):VALUE = F01.
     Bsheet:cells(myi, 2):VALUE = F02.
     Bsheet:cells(myi, 3):VALUE = F03.
     Bsheet:cells(myi, 4):VALUE = F04.
     Bsheet:cells(myi, 5):VALUE = F05.
     Bsheet:cells(myi, 6):VALUE = F06.
     Bsheet:cells(myi, 7):VALUE = F07.
     Bsheet:cells(myi, 8):VALUE = F08.
     Bsheet:cells(myi, 9):VALUE = F09.
     Bsheet:cells(myi,10):VALUE = F10.
     Bsheet:cells(myi,11):VALUE = F11.
     Bsheet:cells(myi,12):VALUE = F12.
     myi = myi + 1.
  end.
  bbook:SaveAs(thfile + ".log.xls" ,,,,,,1).
  bbook:CLOSE().
  bexcel:quit.
  release object bsheet.
  release object bbook.
  release object bexcel.

PROCEDURE dataout.
    DEFINE INPUT PARAMETER thPtr AS char.
    define output PARAMETER thmsg AS char no-undo.
    Define variable woutputstatment AS CHARACTER .
    thmsg = "".
    input from value (thPtr) .
        Do While True:
        IMPORT UNFORMATTED woutputstatment.
        IF index (woutputstatment,"ERROR:") <>  0 OR    /* for us langx */
           index (woutputstatment,"´íÎó:")  <>  0 OR    /* for ch langx */
           index (woutputstatment,"¿ù»~:")  <>  0 OR
           index (woutputstatment,"(87)")   <>  0 OR
           index (woutputstatment,"(557)")  <>  0 OR
           index (woutputstatment,"(1896)") <>  0 OR
           index (woutputstatment,"(143)")  <>  0
           then do:
                thmsg = woutputstatment.
                leave.
           end.
        End.
    input close.
END PROCEDURE.