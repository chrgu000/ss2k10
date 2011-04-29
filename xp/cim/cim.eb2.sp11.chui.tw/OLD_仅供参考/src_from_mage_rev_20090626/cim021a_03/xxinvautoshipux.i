/* Creation: eb2 sp11  chui  modified: ??/??/??   BY: Ivan?  *this line added by kaine*       */
/* REVISION: eb2 sp11  chui  modified: 11/??/06   BY: Kaine Zhang  *ss-200611??.1*            */
/* REVISION: eb2 sp11  chui  modified: 12/10/06   BY: Kaine Zhang  *ss-20061210.1*            */

/* {xxinvautoshipu.i} */

/* define variable global_user_lang_dir as char format "x(40)" init "/app/mfgpro/eb2/". */
define variable usection as char format "x(16)". 

usection = TRIM ( string(year(TODAY)) + string(MONTH(TODAY)) + string(DAY(TODAY)))  + trim(STRING(TIME)) + trim(string(RANDOM(1,100))) + "invotr" .

output to value( trim(usection) + ".i") .

		display 
		trim ( xxshd_so_nbr ) format "x(50)"
		/*ss-200611??.1*  " - N N " format "x(50)"  */
		
		/* ***********************ss-200611??.1 B Add********************** */
		"    "
		xxshm_date
		"  N  N  " FORMAT "x(50)"
		/* ***********************ss-200611??.1 E Add********************** */
		
		skip
		
		trim (string(xxshd_so_line))  format "x(50)"  	" - " format "x(50)" skip
		 string(xxshipqty) +  " " + trim (lad_site) + " " +  trim( lad_loc ) format "X(50)"   trim( lad_lot )  format "X(50)" trim( lad_ref )  format "X(50)" skip
		"." skip
		"Y" skip
		"Y" skip
		"-" skip
		"- - - - " + trim(xxshd_inv_no) 
		/* *ss-20061210.1*  + " N Y "   */
		/* *ss-20061210.1* */ + " y n "
		format "x(50)" skip
		"."
		     with fram finput no-box no-labels width 200.

output close.

input from value ( usection + ".i") .
output to  value ( usection + ".o") .
        {gprun.i ""sosois.p""}
input close.
output close.

unix silent value ( "rm "  + Trim(usection) + ".i").
unix silent value ( "rm "  + Trim(usection) + ".o"). 
