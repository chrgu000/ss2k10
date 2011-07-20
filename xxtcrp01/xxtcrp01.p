/* xxtcrp01.p - 台车状态报表                                                 */
/*V8:ConvertMode=Report                                                      */
/* REVISION: 0CYH LAST MODIFIED: 07/20/11   BY: zy                           */
/* Environment: Progress:9.1D   QAD:eb2sp4    Interface:Character            */
/*-revision end--------------------------------------------------------------*/
 

define variable cmsort like cm_sort.
define variable nbr like rsn_type.
define variable nbr1 like rsn_type.
define variable cust like rsn_code.
define variable cust1 like rsn_code.

/*K1D1*/ /* DISPLAY TITLE */
/*K1D1*/  {mfdtitle.i "110720.1"}

form
   nbr   colon 20
   nbr1  colon 46 label {t001.i}
   cust  colon 20
   cust1 colon 46 label {t001.i}
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/*K1D1*/ {wbrp01.i}

repeat:

   if nbr1 = hi_char then nbr1 = "".
   if cust1 = hi_char then cust1 = "".

/*K1D1*/ if c-application-mode <> 'web' then
   update nbr nbr1 cust cust1 with frame a.

/*K1D1*/ {wbrp06.i &command = update &fields = "  nbr nbr1 cust cust1 "
          &frm = "a"}

/*K1D1*/ if (c-application-mode <> 'web') or
/*K1D1*/ (c-application-mode = 'web' and
/*K1D1*/ (c-web-request begins 'data')) then do:

   if nbr1 = "" then nbr1 = hi_char.
   if cust1 = "" then cust1 = hi_char.

/*K1D1*/ end.

   /* SELECT PRINTER */
   {mfselprt.i "printer" 132}
   {mfphead2.i}

   for each xxtc_hst
      where xxtc_nbr >= nbr and xxtc_nbr <= nbr1
        and xxtc_cust >= cust and xxtc_cust <= cust1
   use-index xxtc_nbr
   no-lock with frame b width 132 no-attr-space:
                /* SET EXTERNAL LABELS */
                setFrameLabels(frame b:handle).
                {mfrpchk.i}         /*G348*/
		  find first cm_mstr where cm_addr = xxtc_cust no-lock no-error.
		  if available cm_mstr then do:
		  	 assign cmsort = cm_sort.
		  end.
		  else do:
		  	 assign cmsort = "".
		  end.
      display xxtc_nbr        
							xxtc_cust     
							cmsort  
							xxtc_stat  
							xxtc_date       
							xxtc_mod_date   
							xxtc_mod_usr.    

   end.
   {mftrl080.i}
end.

/*K1D1*/ {wbrp04.i &frame-spec = a}
