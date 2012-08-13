/* GUI CONVERTED from gpaud3.i (converter v1.69) Sat Mar 30 01:10:26 1996 */
/* gpaud3.i - AUDIT TRAIL FILE DELETE                                   */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/* REVISION: 7.3      LAST MODIFIED: 11/18/92   by: mpp *G333*/
/* REVISION: 7.3      LAST MODIFIED: 12/14/92   by: mpp *G440*/
/* REVISION: 7.3      LAST MODIFIED: 10/05/03   by: *DCEC101* Kevin*/ 

/*!

In cases where a delete of a record cannot be allowed, it's easier to
call this file followed by "next mainloop" as opposed to directing flow
to the end of the program and calling gpaud.p.

      &uniq_num1    A unique 1-3 digit number to be appended to variable
		    names and external filenames.  This number corresponds
		    to the file used to store the record before changes
		    have been made.
      &uniq_num2    Same as above, unique, corresponds to after changes.
      &db_file	    Name of database file being audited.
      &db_field     A field in the file above that the user may want to
		    search on.

note: audit_on is defined and assigned its proper value in gpaud.i.

*/

	    /*delete whatever temp files were created*/
if audit_on{&uniq_num1} then do:
/*G440*/    s_nameb{&uniq_num1} = search(s_name{&uniq_num1}).
/*G440*/    s_nameb{&uniq_num2} = search(s_name{&uniq_num2}).
/*G440*/    if s_nameb{&uniq_num1} <> ? then 
/*G440*/       {gpfldel2.i &filename = s_nameb{&uniq_num1} }
/*G440*/    if s_nameb{&uniq_num2} <> ? then
/*G440*/       {gpfldel2.i &filename = s_nameb{&uniq_num2} }
end.
