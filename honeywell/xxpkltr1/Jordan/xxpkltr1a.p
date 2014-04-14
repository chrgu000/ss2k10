/* $Revision: eb21sp3 $ BY: Jordan Lin  DATE: 06/28/12 ECO: *ss - 20120628.1 */

{mfdeclre.i }

define   variable usection as char format "x(36)" .  
define shared  variable errstr as char no-undo  .
define   variable ciminputfile   as char .
define   variable cimoutputfile  as char .
define   variable c  as char .
define   variable c2  as char .

define  shared variable tmpRECID  as RECID no-undo .
define   shared var rknbr as char format "x(8)".

define  shared temp-table tt1
	field tt1_seq like xxpkld_line
	field tt1_pkl like xxpkld_nbr
	field tt1_part like pt_part
	field tt1_desc1 like pt_desc1
	field tt1_loc_from like ld_loc
	field tt1_qty_req like pod_qty_ord
	field tt1_loc_to like ld_loc
	field tt1_qty_iss like ld_qty_oh
	field tt1_site like si_site
	field tt1_qty2 like ld_qty_oh
	field tt1_xx like pt_desc2
  index  tt1_index is primary 
         tt1_pkl tt1_seq  .

loadloop:
   do  on error undo, LEAVE :


      for each  tt1 where tt1_qty_iss <> 0 :

        errstr = "".
	usection = TRIM ( string(year(TODAY)) + string(MONTH(TODAY)) + string(DAY(TODAY)))  + trim(STRING(TIME)) + trim(string(RANDOM(1,100)))  + trim(tt1_pkl) + trim(string(tt1_seq))  .
	output to value( trim(usection) + ".i") .

        put UNFORMATTED  trim(tt1_part)  format "x(40)" skip.
	put UNFORMATTED string(tt1_qty_iss) + " - " + trim(tt1_pkl) + " " + rknbr   skip.
	put UNFORMATTED "-" skip.
	put UNFORMATTED tt1_site + " " + tt1_loc_from  skip.
	put UNFORMATTED tt1_site + " " + tt1_loc_to  skip.
	put UNFORMATTED "y"  skip.
        put UNFORMATTED "." skip.
        put UNFORMATTED "." skip.

	output close.
	input from value ( usection + ".i") .
	output to  value ( usection + ".o") .
        batchrun = yes. 
		{gprun.i ""iclotr04.p""}
        batchrun = no.  
	input close.
	output close.

	ciminputfile = usection + ".i".
	cimoutputfile = usection + ".o".
	{xxpkltr1b.i}

        if errstr <> "" then do:
	  message "转仓出错！ " tt1_pkl  "第"  tt1_seq "项" errstr .          
	  undo loadloop.
        end.

         OS-DELETE VALUE(Trim(usection) + ".i").
        OS-DELETE VALUE(Trim(usection) + ".o").

      end. /* for each  tt1 : */
   end. /* loadloop: */
