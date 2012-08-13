/* GUI CONVERTED from gpaud.i (converter v1.69) Sat Mar 30 01:10:26 1996 */
/* gpaud.i - AUDIT TRAIL DEFINES                                        */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/* REVISION: 7.3       LAST MODIFIED: 11/05/92   BY: mpp *G282*           */
/* REVISION: 7.3       LAST MODIFIED: 11/18/92   BY: mpp *G333*           */
/* REVISION: 7.3       LAST MODIFIED: 12/11/92   BY: mpp *G440*           */
/* REVISION: 7.3       LAST MODIFIED: 10/05/03   BY: *DCEC101* Kevin   */

/*!

      &uniq_num1    A unique 1-3 digit number to be appended to variable
		    names and external filenames.  This number corresponds
		    to the file used to store the record before changes
		    have been made.
      &uniq_num2    Same as above, unique, corresponds to after changes.
      &db_file	    Name of database file being audited.
      &db_field     A field in the file above that the user may want to
		    search on.

*/


         define variable s_name{&uniq_num1} as character.
         define variable s_name{&uniq_num2} as character.
/*G440*/ define variable s_nameb{&uniq_num1} as character.
/*G440*/ define variable s_nameb{&uniq_num2} as character.
         define stream a_stream{&uniq_num1}.
	 define variable rec_gone{&uniq_num1} like mfc_logical initial no.
/*G333*/ define variable audit_on{&uniq_num1} like mfc_logical initial no.
/*G333*/ find first gl_ctrl no-lock no-error.
/*G333*/ if gl__qad01 = 1 then audit_on{&uniq_num1} = yes.
/*G333*/ if audit_on{&uniq_num1} then do:
	    s_name{&uniq_num1} = string(mfguser) + ".{&uniq_num1}".
	    s_name{&uniq_num2} = string(mfguser) + ".{&uniq_num2}".
/*G440*/    s_nameb{&uniq_num1} = search(s_name{&uniq_num1}).
/*G440*/    s_nameb{&uniq_num2} = search(s_name{&uniq_num2}).
/*G333*/ end.
