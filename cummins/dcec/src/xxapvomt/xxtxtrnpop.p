/* txtrnpop.p - GLOBAL TAX MANAGEMENT - TRANSACTION TAX PARAMETERS POP-UP   */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                       */
/*K1Q4*/ /*V8:RunMode=Character,Windows                                     */
/*                    CREATED:       01/23/96             BY: jzw *H0J6*    */
/* REVISION: 8.6    LAST MODIFIED: 05/20/98 BY: *K1Q4* Alfred Tan           */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00 BY: *N0KC* myb                */


/*!
 *------------------------------------------------------------------------------
    txtrnpop.p  Handle transaction tax parameters pop-up window

    Parameters:-                      INPUT        OUTPUT
                      ACTION       ACTION
      input-output tax_usage          display      set if set_usage is true
      input        set_usage   yes/no
      input-output tax_env            display      set if set_env is true
      input        set_env     yes/no
      input-output tax_class          display      set if set_class is true
      input        set_class   yes/no
      input-output tax_taxable        display      set if set_taxable is true
      input        set_taxable yes/no
      input-output tax_in             display      set if set_in is true
      input        set_in      yes/no
      input        start_row   integer (row on screen to start panel)
      output       undo_popup  yes/no              set true if leave with error
                           set false if all fields ok
 *------------------------------------------------------------------------------
*/

        {mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

     define input-output parameter tax_usage   like sod_tax_usage.
     define input        parameter set_usage   like mfc_logical.
     define input-output parameter tax_env     like sod_tax_env.
     define input        parameter set_env     like mfc_logical.
     define input-output parameter tax_class   like sod_taxc.
     define input        parameter set_class   like mfc_logical.
     define input-output parameter tax_taxable like sod_taxable.
     define input        parameter set_taxable like mfc_logical.
     define input-output parameter tax_in      like sod_tax_in.
     define input        parameter set_in      like mfc_logical.
     define input        parameter start_row   as integer.
     define       output parameter undo_popup  like mfc_logical.

     form
        tax_usage   colon 20
        tax_env     colon 20 space(2)
        tax_class   colon 20
        tax_taxable colon 20
        tax_in      colon 20
     with frame set_tax
        row (start_row)
        centered overlay
        side-labels
        attr-space.

        /* SET EXTERNAL LABELS */
        setFrameLabels(frame set_tax:handle).

     display tax_usage
         tax_env
         tax_class
         tax_taxable
         tax_in
     with frame set_tax.

     /* DEFAULT TO UNDOING ALL DATA (ASSUME DATA IS INVALID) */
     undo_popup = true.

     set_tax_data:
     do on error undo set_tax_data, retry
        on endkey undo set_tax_data, leave:

        /* SET ONLY THE FIELDS REQUESTED */
        set tax_usage   when (set_usage)
        tax_env     when (set_env)
        tax_class   when (set_class)
        tax_taxable when (set_taxable)
        tax_in      when (set_in)
        with frame set_tax.

        /* VALIDATE TAX USAGE */
        if not {gptxu.v tax_usage ""yes""}
        /* "YES" MEANS BLANK IS ALLOWED */
        then do:
           {mfmsg.i 874 3} /* TAX USAGE DOES NOT EXIST */
           next-prompt tax_usage with frame set_tax.
           undo set_tax_data, retry.
        end.

        /* VALIDATE TAX ENVIRONMENT */
        if tax_env = ""
        then do:
           {mfmsg.i 944 3} /* BLANK TAX ENVIRONMENT NOT ALLOWED */
           next-prompt tax_env with frame set_tax.
           undo set_tax_data, retry.
        end.

        if not {gptxe.v tax_env ""no""}
        /* "NO" MEANS BLANK IS NOT ALLOWED */
        then do:
           {mfmsg.i 869 3} /* TAX ENVIRONMENT DOES NOT EXIST */
           next-prompt tax_env with frame set_tax.
           undo set_tax_data, retry.
        end.

        /* VALIDATE TAX CLASS */
        if not {gptaxc.v tax_class ""yes""}
        /* "YES" MEANS BLANK IS ALLOWED */
        then do:
           {mfmsg.i 7524 3} /* TAX CLASS NOT DEFINED */
           next-prompt tax_class with frame set_tax.
           undo set_tax_data, retry.
        end.

        /* SIGNAL THAT POPUP WAS NOT UNDONE (DATA IS VALID) */
        undo_popup = false.

     end. /* SET_TAX_DATA */

     hide frame set_tax.
