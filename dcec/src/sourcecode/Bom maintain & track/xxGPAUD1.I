/* GUI CONVERTED from gpaud1.i (converter v1.69) Sat Mar 30 01:10:26 1996 */
/* gpaud1.i - AUDIT TRAIL SUBROUTINE                                    */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/* REVISION: 7.3       LAST MODIFIED: 11/05/92   BY: mpp *G282*           */
/* REVISION: 7.3       LAST MODIFIED: 11/18/92   BY: mpp *G333*           */
/* REVISION: 7.3       LAST MODIFIED: 02/09/93   BY: mpp *G440*           */
/* REVISION: 7.3       LAST MODIFIED: 02/18/93   BY: gjp *G705*           */
/* REVISION: 7.3       LAST MODIFIED: 09/07/93   BY: gjp *GE84*           */
/* REVISION: 7.3       LAST MODIFIED: 10/05/03   BY: *DCEC101* Kevin   */

/*!

   This procedure is used to create "before-change" records.

   &uniq_num1   a unique 1-3 digit number to identify filenames and vars
		This number corresponds to the "before" file.
   &uniq_num2   ditto, but this number corresponds to the after file.
   &db_file     the name of the database file that will be exported
   &db_field    name of a field to search on
   
   note: audit_on is defined and assigned a value in gpaud.i
*/

/*G333*/if audit_on{&uniq_num1} then do:
/*G705*/  rec_gone{&uniq_num1} = no.
/*G440*/  /*delete old temp files before new ones are created*/
/*G440*/  if s_nameb{&uniq_num1} <> ? then
/*G440*/     {gpfldel2.i &filename = s_nameb{&uniq_num1} }		/*GE84*/
	  output stream a_stream{&uniq_num1} to value(s_name{&uniq_num1}).
	  export stream a_stream{&uniq_num1} {&db_file}.
	  output stream a_stream{&uniq_num1} close.
/*G333*/end.
