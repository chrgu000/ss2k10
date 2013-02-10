/* xxptcld1.p - xxppctmt.p cim load                                                */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 120706.1 LAST MODIFIED: 07/06/12 BY:Zy                          */
/* REVISION END                                                              */

{mfdeclre.i}
{xxporcld.i}
define variable vfile as character.
define variable vchk as character no-undo.
define variable trrecid as recid.
define stream bf.
define stream bf1.

for each xxtmp where xx_chk = "" break by xx_nbr by xx_rc:
	  if first-of(xx_rc) then do:
 	     assign vfile = execname + "." + mfguser + "." + string(xx_sn,"999999").
	     output stream bf to value(vfile + ".bpi").
			 put stream bf unformatted '"' trim(xx_nbr) '"' skip.
		   put stream bf unformatted '"' trim(xx_pkg) '" "' xx_rc '" "' xx_eff '" - N' skip.
    end.
    assign xx_recid = current-value(tr_sq01).
    put stream bf unformatted trim(string(xx_line)) skip.
    put stream bf unformatted trim(string(xx_qty)) ' - - - - - "' trim(xx_site) '" "' trim(xx_loc) '"' skip.
    if last-of(xx_rc) then do:
		   put stream bf unformatted '.' skip.
		   put stream bf unformatted 'N' skip.
		   put stream bf unformatted 'Y' skip.
		   output stream bf close.
		   cimrunprogramloop:
		   do transaction:
		   		message 'POD_NBR:' xx_nbr ' POD_LINE:' xx_line ' SERIAL:' xx_sn .
		      input from value(vfile + ".bpi").
		      output to value(vfile + ".bpo") keep-messages.
		      hide message no-pause.
		         batchrun = yes.
		         {gprun.i ""poporc.p""}
		         batchrun = no.
		      hide message no-pause.
		      output close.
		      input close.
		   end.  /* do transaction:  */
    end.
end.

output stream bf1 to value(errload).
for each xxtmp exclusive-lock where xx_chk = "" break by xx_nbr by xx_rc:
    assign vchk = "".
		find first prh_hist no-lock where prh_domain = global_domain and
				       prh_nbr = xx_nbr and prh_receiver = xx_rc and
				       prh_line = xx_line no-error.
	  if available prh_hist then do:
	  	 if prh_rcvd = xx_qty then do:
	  	 		assign vchk = "OK".
	  	 end.
	  end.

/*			 find first tr_hist no-lock where tr_domain = global_domain and    */
/*			            tr_trnbr > xx_recid and tr_type = "RCT-PO" and         */
/*			            tr_nbr = xx_nbr and tr_line = xx_line and              */
/*			            tr_site = xx_site and tr_loc = xx_loc                  */
/*			 no-error.                                                         */
/*  		 if available tr_hist then do:                                     */
/*             assign vchk = "OK:" + string(recid(tr_hist)).               */
/*        end.                                                             */
/*        else do:                                                         */
/*        	 export stream bf1 delimiter "," xxtmp.                        */
/*           assign vchk = "CIM Data Error!".                              */
/*        end.                                                             */
          assign xx_chk = vchk.
end.
output stream bf1 close.