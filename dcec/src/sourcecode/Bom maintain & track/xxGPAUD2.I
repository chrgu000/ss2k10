/* GUI CONVERTED from gpaud2.i (converter v1.69) Tue May  7 12:36:39 1996 */
/* gpaud2.i - AUDIT TRAIL SUBROUTINE                                    */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/* REVISION: 7.3      LAST MODIFIED: 11/04/92   BY: mpp *G282*            */
/* REVISION: 7.3      LAST MODIFIED: 11/18/92   by: mpp *G333*            */
/* REVISION: 7.3      LAST MODIFIED: 12/10/92   by: mpp *G440*            */
/*                                   02/22/93   by: jms *G724*            */
/* REVISION: 7.3      LAST MODIFIED: 05/01/96   by: rxm *G1SM*            */
/* REVISION: 7.3      LAST MODIFIED: 10/05/03   by: *DCEC101* Kevin    */

/*!
    &uniq_num1
    &uniq_num2
    &db_file    the name of the database file to being audited
    &db_field   the name of a field to be searched on in gpaudrp
    &db_field1  the name of the secondary field to be searched on.

*DCEC101*begin
    &db_field2  the name of the secondary field to be searched on.
    &db_field3  the name of the secondary field to be searched on.
*DCEC101*end

    &db_buffer  the name of a buffer (if any) associated with the database
		file to be audited
    &del_rec    whether or not the named buffer has been deleted
*/
/*G333*/ if audit_on{&uniq_num1} then do:
/*G1SM      if not available({&db_file}) then /*record's been deleted*/ */
/*G1SM*/    if not available({&db_file}) or "{&del_rec}" = "true" then
	       rec_gone{&uniq_num1} = yes.
	    else do:                         /*output after image*/

/*G440*/                                     /*delete old tmp file*/
/*G440*/       if s_nameb{&uniq_num2} <> ? then
/*G440*/          {gpfldel2.i &filename = s_nameb{&uniq_num2} }

	       output stream a_stream{&uniq_num1}
		  to value(s_name{&uniq_num2}).
/*G1SM*/       if "{&db_buffer}" <> ""  then
/*G1SM*/          export stream a_stream{&uniq_num1} {&db_buffer}.
/*G1SM*/       else
		  export stream a_stream{&uniq_num1} {&db_file}.
	       output stream a_stream{&uniq_num1} close.
	    end.

/*DCEC101***begin marked
/*G724*/    {gprun.i ""gpaud.p"" "("string(s_name{&uniq_num1})",
				   "string(s_name{&uniq_num2})",
				   """{&db_file}""",
				   """{&db_field}""",
				   """{&db_field1}""",
				   "rec_gone{&uniq_num1}")"}
end marked*/
/*DCEC101*/ {gprun.i ""xxgpaud.p"" "("string(s_name{&uniq_num1})",
                   "string(s_name{&uniq_num2})",
                   """{&db_file}""",
                   """{&db_field}""",
                   """{&db_field1}""",
                    """{&db_field2}""",
                    """{&db_field3}""",
                    "rec_gone{&uniq_num1}")"} 
				   
/*GUI*/ if global-beam-me-up then undo, leave.

/*G333*/end.
