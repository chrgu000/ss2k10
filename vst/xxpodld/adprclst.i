/* adprclst.i - VALIDATE THE PRICE LIST                                       */
/* Copyright 1986-2000 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/*------------------------------------------------------------------------
    File        : adprclst.i
    Description : Include File to Validate List/ Discount Price Lists
    Notes       :
    History     :
    REVISION: 7.2     LAST MODIFIED:       03/29/95  BY: *F0PN* dzn
    REVISION: 7.4     LAST MODIFIED:       09/29/94  BY: *H541* bcm
    REVISION: 8.6     LAST MODIFIED:       05/20/98  BY: *K1Q4* Alfred Tan
    REVISION: 8.6E    LAST MODIFIED:       08/05/98  BY: *K1QS* Dana Tunstall
    REVISION: 8.6E    LAST MODIFIED:       08/05/98  BY: *K1RJ* Dana Tunstall
    REVISION: 9.0     LAST MODIFIED:       03/10/99  BY: *M0B3* Michael Amaladhas
    REVISION: 9.0     LAST MODIFIED:       03/13/99  BY: *M0BD* Alfred Tan
    REVISION: 9.1     LAST MODIFIED:       01/20/00  BY: *N03S* Poonam Bahl
    REVISION: 9.1     LAST MODIFIED:       07/21/00  BY: *M0PQ* Falguni Dalal
  ----------------------------------------------------------------------*/
/*V8:ConvertMode=NoConvert                                              */
/*V8:RunMode=Character,Windows                                          */
/*----------------------------------------------------------------------*/

/***************************************************************************/
/*!
*/
/*!
&price-list  =   price list field to validate : like so_pr_list2
&curr        =   currency
&pr-list-req =   yes - blanks not allowed, no - blank allowed
&undo-label  =   undo block label
&with-frame  =   with frame phrase
&disp-msg    =   yes - message will be displayed,
                 no - message will not be displayed
&warning     =   yes - displays a warning, no -  displays an error.
*/
/***************************************************************************/

/* define variable price-list-failed as logical                         **M0PQ*/
define variable price-list-failed like mfc_logical                      /*M0PQ*/
                                  initial false no-undo.
define variable price-list-msg    as integer no-undo.

define variable p-currency        as   character  format "x(3)"    no-undo.
define variable p-price-list-req  like mfc_logical                 no-undo.
define variable p-warning_yn      like mfc_logical                 no-undo.
define variable p-list-type       as   character                   no-undo.

/* pxmaint.i should Not be included in this .i, after all the programs  */
/* calling adprclst.i have been restructured and have a pxmaint.i       */
{pxmaint.i}


{ppprlst.i}

assign
   p-currency        = {&curr}
   p-price-list-req  = {&price-list-req}
   p-warning_yn      = {&warning}
   p-list-type       = {&list-type}.

{pxrun.i &PROC    = 'validatePriceList' &PROGRAM = 'ppplxr.p'
         &PARAM   = "(input {&price-list},
                      input p-currency,
                      input p-price-list-req,
                      input p-warning_yn,
                      input p-list-type,
                      output price-list-failed,
                      output price-list-msg)"
         &NOAPPERROR = true
         &CATCHERROR = true
}


if {&disp-msg} and
   price-list-failed and not batchrun then
do:
   {pxmsg.i &MSGNUM=price-list-msg &ERRORLEVEL={&WARNING-RESULT}
            &CONFIRM=price-list-failed}
   if not price-list-failed then do:
      next-prompt {&price-list} {&with-frame}.
      undo {&undo-label}, retry.
   end. /* IF NOT PRICE-LIST-FAILED */
end. /* IF DISP-MSG AND PRICE-LIST-MSG */
