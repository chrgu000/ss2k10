/* osprint1.p - PROCESSES OUTPUT TO WINDOWS PRINTER                          */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */
/*V8:ConvertMode=NoConvert                                                   */
/* REVISION: 9.1        CREATED: 10/01/99       BY: *N03C* Kieran O Dea      */
/* REVISION: 9.1  LAST MODIFIED: 08/13/00       BY: *N0KR* myb               */


/*
PURPOSE:
This program is a modified version of Progress's utility program _osprint.p.
_osprint.p clears the printer-control-handle before calling proprint.dll.
This version of the program uses an extra parameter to determine whether
or not to clear the printer-control-handle before calling proprint.dll.
The modified section is highlighted with the marker *N03C*.

NOTES:
This file is available to all environments even though it is only used in the
Windows environment. This was done to overcome a problem encountered during
ECO submittal of patchmarker N03C. The problem is that gpprtrpa.i makes a
call to gpwinprt.p using gprunp.i. Because the call is not within a GUI only
(V8!) block the ECO submittal process thinks it should be available to all
environments. The file gpprtrpa is available to all environments and has a
ConvertMode=NoConvert. If the Runmode for gpprtrpa.i can be changed to
Windows then this file and gpwinprt.p can have RunMode=Windows.
*/
/****************************************************************************
These are the comments from the original PSC utility program.
    File       _osprint.p

    Syntax
               RUN adecomm/_osprint.p ( INPUT  p_Window,
                                        INPUT  p_PrintFile,
                                        INPUT  p_FontNumber,
                                        INPUT  p_PrintFlags,
                                        INPUT  p_PageSize,
                                        INPUT  p_PageCount,
                                        OUTPUT p_Printed ).

    Purpose    Send a specified operating system text file to the default
               printer.

    Remarks    Output is sent to printer as PAGED output, with a default
               page size of zero. This lets the printer handle the paging.
               The page size can be specified using p_PageSize.

               Max characters per line: 255.

               Under MS-Windows, the MSW Print Setup dialog box
               is called via a PROGRESS DLL (PROPRINT.DLL) and the
               SESSION:PRINTER-CONTROL-HANDLE is always cleared.

    Author     J. Palazzo
    Created    Mar  1994
    Updated    Sept 1996  Changed p_UseDialog parameter to p_PrintFlags.
****************************************************************************/

DEFINE INPUT  PARAMETER p_Window      AS WIDGET    NO-UNDO.
    /* Parent window for Dialogs and Message boxes. Default
       to CURRENT-WINDOW if p_Window is not valid. */

DEFINE INPUT  PARAMETER p_PrintFile   AS CHAR      NO-UNDO.
    /* Text file to print. Can be specified relative to PROPATH. */

DEFINE INPUT  PARAMETER p_FontNumber  AS INTEGER   NO-UNDO.
    /* PROGRESS Font Number to use when printing file.  MSW Only.
       This may not match screen font exactly and the printer
       driver will make the ultimate choice, not PROGRESS. */

DEFINE INPUT  PARAMETER p_PrintFlags  AS INTEGER   NO-UNDO.
    /*  Integer expression that specifies various print options.
        The table below lists the flag values that correspond to
        each print option. If a zero (0) value is passed, option
        defaults are used.

        Print Option        Flag Value  Meaning

        useDialog               1       Display the MSW Print Setup Dialog.
                                        Default is to not display the Print
                                        dialog.

        useLandscape            2       Set print orientation to Landscape.
                                        Default orientation is Portrait.

        You can specify any combination of these flags. For
        example, you can pass three (1 + 2) as an input parameter to
        specify that the Print Setup Dialog be displayed and that
        the print orientation be landscape. */

DEFINE INPUT  PARAMETER p_PageSize    AS INTEGER  NO-UNDO.
    /* Page length - number of lines per page. */

DEFINE INPUT  PARAMETER p_PageCount   AS INTEGER  NO-UNDO.
    /* If non-zero, then enable the page range selection controls
       in the printer setup dialog. If zero, the entire text file
       is printed. */

/*N03C*/DEFINE INPUT  PARAMETER p_ClearPrinterContext   AS LOGICAL  NO-UNDO.
/*N03C*/    /* If non-zero, then enable the page range selection controls
/*N03C*/       in the printer setup dialog. If zero, the entire text file
/*N03C*/       is printed. */


DEFINE OUTPUT PARAMETER p_Printed     AS LOGICAL INIT TRUE NO-UNDO .
    /* Returns TRUE if able to complete the OUTPUT TO PRINTER. */

DEFINE STREAM In_Stream.
DEFINE STREAM Out_Stream.

DEFINE VAR Text_Line      AS CHARACTER FORMAT "x(255)" NO-UNDO .
DEFINE VAR PrintResult    AS INTEGER   INITIAL 0       NO-UNDO .


DO ON STOP  UNDO, RETRY ON ERROR UNDO, RETRY:
  IF NOT RETRY THEN
  DO:
    /* Point to a valid window handle. */
    ASSIGN p_Window = IF VALID-HANDLE( p_Window ) THEN
                        p_Window
                      ELSE IF VALID-HANDLE( CURRENT-WINDOW ) THEN
                        CURRENT-WINDOW
                      ELSE
                         DEFAULT-WINDOW.

    /* Get file info on file to print. */
    ASSIGN FILE-INFO:FILE-NAME = p_PrintFile NO-ERROR .
    IF ( FILE-INFO:FULL-PATHNAME = ? ) THEN
    DO:
      MESSAGE "Unable to find file to print."
        VIEW-AS ALERT-BOX ERROR BUTTONS OK IN WINDOW p_Window.
      STOP.
    END.
    ASSIGN p_PrintFile = FILE-INFO:FULL-PATHNAME.
    /* Run Proprint DLL for Windows and 32bit Windows Char Console. */
/*N03C*/    If p_ClearPrinterContext then do:
/*N03C*/        IF (SESSION:WINDOW-SYSTEM BEGINS "MS-WIN") OR
/*N03C*/            (OPSYS = "WIN32" AND SESSION:WINDOW-SYSTEM = "TTY") THEN
/*N03C*/         DO:
/*N03C*/     /* Clear the current print handle. */
/*N03C*/          ASSIGN SESSION:PRINTER-CONTROL-HANDLE = ?.
/*N03C*/       end.
/*N03C*/    end.

       IF (SESSION:WINDOW-SYSTEM BEGINS "MS-WIN") OR
          (OPSYS = "WIN32" AND SESSION:WINDOW-SYSTEM = "TTY") THEN
        DO:

      IF OPSYS = "WIN32" THEN
        RUN ProPrintFile ( INPUT  SESSION:PRINTER-CONTROL-HANDLE,
                           INPUT  p_PrintFlags ,
                           INPUT  p_Window:HWND,
                           INPUT  p_FontNumber,
                           INPUT  p_PrintFile,
                           INPUT  p_PageCount,
                           OUTPUT PrintResult ).
      ELSE
        RUN ProPrintFile16 ( INPUT  SESSION:PRINTER-CONTROL-HANDLE,
                           INPUT  p_PrintFlags ,
                           INPUT  p_Window:HWND,
                           INPUT  p_FontNumber,
                           INPUT  p_PrintFile,
                           INPUT  p_PageCount,
                           OUTPUT PrintResult ).

      /* Return value from DLL of 0 indicates a successful request to
         print the file. It does NOT indicate the file has finished
         printing.
      */
      ASSIGN p_Printed = ( PrintResult = 0 ).
    END.
    ELSE
    DO:
        /* All other operating environments/windowing systems.
           Break out into a CASE statement to customize.  */
        RUN PrintFile.
    END.
  END. /* NOT RETRY */
  ELSE
    ASSIGN p_Printed = FALSE.

  INPUT  STREAM In_Stream  CLOSE.
  OUTPUT STREAM Out_Stream CLOSE.
END.


/* -----------------------------------------------------------------------*/
PROCEDURE ProPrintFile EXTERNAL "PROPRINT.DLL":
  /* Internal Procedure call to MS-Windows DLL to Print Setup dialog.  */

  DEFINE INPUT  PARAMETER hControl        AS LONG.
  DEFINE INPUT  PARAMETER fPrintFlags     AS LONG.
  DEFINE INPUT  PARAMETER hWndParent      AS LONG.
  DEFINE INPUT  PARAMETER nFontNo         AS LONG.
  DEFINE INPUT  PARAMETER lpszFile        AS CHARACTER.
  DEFINE INPUT  PARAMETER nPages          AS LONG.
  DEFINE RETURN PARAMETER Print_Result    AS LONG.
END.

/* -----------------------------------------------------------------------*/
PROCEDURE ProPrintFile16 EXTERNAL "PROPRINT.DLL" ORDINAL 2:
  /* Internal Procedure call to MS-Windows DLL to Print Setup dialog.  */

  DEFINE INPUT  PARAMETER hControl        AS SHORT.
  DEFINE INPUT  PARAMETER fPrintFlags     AS SHORT.
  DEFINE INPUT  PARAMETER hWndParent      AS SHORT.
  DEFINE INPUT  PARAMETER nFontNo         AS SHORT.
  DEFINE INPUT  PARAMETER lpszFile        AS CHARACTER.
  DEFINE INPUT  PARAMETER nPages          AS SHORT.
  DEFINE RETURN PARAMETER Print_Result    AS SHORT.
END.

/* -----------------------------------------------------------------------*/
PROCEDURE PrintFile:
  /* Print an operating system file via simple OUTPUT TO PRINTER. */

  INPUT  STREAM In_Stream  FROM VALUE(p_PrintFile) NO-ECHO NO-MAP.
  OUTPUT STREAM Out_Stream TO   PRINTER PAGE-SIZE VALUE( p_PageSize ).

  /* Frame must be down frame, so scope to REPEAT. */
  REPEAT ON STOP UNDO, LEAVE WITH FRAME f_Print:
    IMPORT STREAM In_Stream UNFORMATTED Text_Line.
    DISPLAY STREAM Out_Stream Text_Line
      WITH FRAME f_Print NO-LABELS STREAM-IO
      NO-BOX USE-TEXT WIDTH 255.
  END.
END PROCEDURE.

/* _osprint.p - end of file */
