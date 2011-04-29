/* mfguirpb.i - Report include file #4 for converted std reports        */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */


/******************************** Tokens ********************************/
/*V8:ConvertMode=NoConvert                                              */
/*V8:RunMode=Windows                                                    */
/************************************************************************/
/******************************** History *******************************/
/* Revision: 8.3           Created: 05/02/94     By: gui                */
/* Revision: 8.5     Last Modified: 03/04/96     By: jpm      /*J0CF*/  */
/* Revision: 9.1     Last Modified: 08/13/00     By: *N0KR* myb         */
/************************************************************************/
/********************************* Notes ********************************/
/*!
   Parameters:
    &flds = list of fields to set/enable/display/assign, separated by spaces
*/
/************************************************************************/

  PROCEDURE p-action-fields :
  /* -----------------------------------------------------------
    Purpose:
    Parameters:  <none>
    Notes:
  -------------------------------------------------------------*/
  define input parameter action-parm as character.

    CASE action-parm:
      when "SET":U then do:
        set
          {&flds}
        with frame a.
        set dev batch_id with frame frame-printer.
      end.
      when "ENABLE":U then do:
        view frame a.
        enable
          {&flds}
        with frame a.
        enable
          Button-Clear
          Button-Report
          Button-Exit
        with frame frame-but.
        if valid-handle(widget-first) and widget-first:SENSITIVE then do:
          widget-first:auto-zap = true.
          apply "ENTRY":U to widget-first.
        end.
      end.
      when "DISPLAY":U then do:
        display
          {&flds}
        with frame a.
      end.
      when "ASSIGN":U then do with frame a:
        assign
          {&flds}.
      end.
    END CASE.

  END PROCEDURE.

  if batchrun then do:    /* If report is being run in batch mode */
    view frame a.
    run p-action-fields
      (INPUT "SET":U).
    run p-report-quote.
    pause 0 before-hide.
    run p-report.
  end.
  else                    /* else if report is being run interactively */
  do on error undo, leave on endkey undo, leave:
    run p-print-init.
    run p-enable-ui.
    local-handle = frame a:FIRST-CHILD. /* field group */
    widget-first = local-handle:FIRST-TAB-ITEM.
    repeat while widget-first:SENSITIVE = false:
      widget-first = widget-first:NEXT-TAB-ITEM.
    end.

    run p-field-store-values.
    wait-for WINDOW-CLOSE of CURRENT-WINDOW focus widget-first.
  end.
