/* xxpoporc.p  -  PURCHASE ORDER RECEIPT W/ SERIAL NUMBER CONTROL            */
/*             - copy forom poporc.p                                         */
/* REVISION: 0BYP LAST MODIFIED: 12/01/10   BY: zy                           */
/* Environment: Progress:10.1B   QAD:eb21sp6    Interface:Character          */
/* REVISION END                                                              */

/* DISPLAY TITLE */
{mfdtitle.i "101201.1"}
{mfaititl.i} /* SUPPRESS DISPLAY OF SCREEN TITLE IN API MODE */
{cxcustom.i "POPORC.P"}
{gldydef.i new}
{gldynrm.i new}

define new shared variable porec       like mfc_logical                no-undo.
define new shared variable ports       as   character                  no-undo.
define new shared variable is-return   like mfc_logical                no-undo.
define new shared variable tax_tr_type like tx2_tax_type  initial "21" no-undo.
define new shared variable nbr like prh_nbr.
define new shared variable nbr1 like prh_nbr.
define new shared variable ordernum like po_nbr                        no-undo.
define variable yn-print like mfc_logical.
{&POPORC-P-TAG1}

/* Let poporcm.p know that we're receiving purchase orders. */
assign
   ports     = ""
   porec     = yes
   is-return = no.

do on error undo, return error return-value:
   {gprun.i ""xxpoporcm.p""}
   assign yn-print = no.
   {pxmsg.i &MSGNUM=80400 &ERRORLEVEL=1 &CONFIRM=yn-print}
   if yn-print then do:
      assign nbr = ordernum
             nbr1 = ordernum.
      {gprun.i ""xxporcrp1.p""}
   end.
end.
