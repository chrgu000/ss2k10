/***********************************************************************/
/*                                                                     */
/*                   DO NOT MODIFY THIS PROGRAM.                       */
/*                                                                     */
/*    Name       : tijscroll.i                                         */
/*                                                                     */
/*    Function   : Generic scrolling template for                      */
/*                 Triumph International Japan.                        */
/*                                                                     */
/*    Programmer : Raphael Thoppil                                     */
/*                                                                     */
/*    Usage      : {tijscroll.i                                        */
/*                   &argument = " value "                             */
/*                   &argument = " value "}                            */
/*                 See bellow for arguments, some are mandatory.       */
/*                                                                     */
/***********************************************************************/
/* MODID   USER       REASONS                                          */
/* -----   --------   -------                                          */
/*                                                                     */
/***********************************************************************/
/*    scroll.i Arguments                                               */
/*    ==================                                               */
/*                                                                     */
/*  Mandatory Arguments:                                               */
/*    &file        Database table-name to scroll.                      */
/*    &where       Where clause for record selection. If no where      */
/*                 clause aplies use "where true".                     */
/*    &fieldlist   List of fields and variables to be displayed.       */
/*    &prompt      The fieldname to highlight and select on.           */
/*    &frame       The down frame to use for scrolling records.        */
/*                                                                     */
/*  Optional Arguments:                                                */
/*  If an argument is not to be used, do not define it.                */
/*    &index       Index name to force ordering of records. If no      */
/*                 index is to be used do not define argument.         */
/*    &prestart    Code to be executed before initiating scrolling.    */
/*    &predisplay  Code to be executed just prior to displaying a      */
/*                 line on the scroller.                               */
/*    &postdisplay Code to be executed just after displaying a line on */
/*                 the scroller.                                       */
/*    &prechoose   Code to be executed just before choose.             */
/*    &midchoose   Extra options to be used by the choose statement.   */
/*    &postchoose  Code to be executed just after choose.              */
/*    &gokeys      Additional keys to GO ON from within the choose.    */
/*    &exit        Code to be executed on exiting scroller.            */
/*    &homekey     Keylabel of home key.                               */
/*    &endkey      Keylabel of end key.                                */
/*    &pgupkey     Keylabel for page up key.                           */
/*    &pgdnkey     Keylabel for page down key.                         */
/*    &inskey      Keylabel for insert function.                       */
/*    &inscode     Code to be executed by insert function.             */
/*    &delkey      Keylabel for delete function.                       */
/*    &delcode     Code to be executed by delete function.             */
/*    &updkey      Keylabel for update function.                       */
/*    &updcode     Code to be executed by update function.             */
/*    &key1..5     Additional keys, 1 to 5, pass Keylabel as argument. */
/*    &code1..5    Code to be executed on respective additional key.   */
/*                                                                     */
/***********************************************************************/



{&nodef} /* Option to remove variable definitions. */

define variable w-rid      as recid extent 500 no-undo.
define variable w-i        as integer no-undo.
define variable w-offset   as integer no-undo.
define variable w-newrecid as recid no-undo.
define variable w-prvrecid as recid no-undo.

/* {&nodef}  End option to remove variable definitions. */
