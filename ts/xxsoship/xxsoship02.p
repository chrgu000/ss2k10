/* SS - 111020.1 BY KEN */
/******************************************************************************/
/* SCHEDULE MAINTENANCE DETAIL SUBPROGRAM */
/* DISPLAYS/MAINTAINS CUSTOMER LAST RECEIPT INFO */
/*by Ken chen 111220.1*/
/*V8:ConvertMode=Maintenance                                                  */
{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */



DEFINE SHARED VARIABLE file_name AS CHARACTER FORMAT "x(50)".
DEFINE SHARED VARIABLE v_qty_oh LIKE IN_qty_oh.
DEFINE SHARED VARIABLE fn_i AS CHARACTER.
DEFINE SHARED VARIABLE v_tr_trnbr LIKE tr_trnbr.


   DEFINE SHARED TEMP-TABLE xxso
       FIELD xxso_nbr LIKE so_nbr
       FIELD xxso_effdate LIKE tr_effdate
       FIELD xxso_site LIKE so_site
       FIELD xxso_line LIKE sod_line
       FIELD xxso_part LIKE sod_part
       FIELD xxso_qty LIKE sod_qty_ord
       FIELD xxso_loc LIKE loc_loc
       FIELD xxso_error AS CHARACTER FORMAT "x(24)"
       INDEX index1 xxso_nbr.


   DEFINE SHARED TEMP-TABLE xxso1
       FIELD xxso1_nbr LIKE so_nbr
       FIELD xxso1_effdate LIKE tr_effdate
       FIELD xxso1_site LIKE so_site
       FIELD xxso1_line LIKE sod_line
       FIELD xxso1_part LIKE sod_part
       FIELD xxso1_qty LIKE sod_qty_ord
       FIELD xxso1_loc LIKE loc_loc
       FIELD xxso1_lot LIKE tr_lot
       FIELD xxso1_lot_qty LIKE ld_qty_oh
       FIELD xxso1_error AS CHARACTER FORMAT "x(24)"
       INDEX index1 xxso1_nbr.


   fn_i = "xxsoship-" + STRING(TIME).
   OUTPUT TO VALUE(".\" + fn_i + ".bpi" ).
   FOR EACH xxso1 no-lock break by xxso1_nbr by xxso1_line:
       if first-of(xxso1_nbr) then do:
          PUT UNFORMATTED xxso1_nbr " " xxso1_effdate " - - " xxso1_site SKIP.
       end.
           PUT UNFORMATTED xxso1_line SKIP.
           PUT UNFORMATTED xxso1_lot_qty ' "' xxso1_site '" "' xxso1_loc '" "'
                           xxso1_lot '"' SKIP.
       if last-of(xxso1_nbr) then do:
          PUT UNFORMATTED "." SKIP.
          put unformatted "-" skip.
          PUT UNFORMATTED "-" SKIP.
          PUT UNFORMATTED "-" SKIP.
          PUT UNFORMATTED "." SKIP.
       end.
   END.
   OUTPUT CLOSE .

   batchrun = yes.
   INPUT FROM VALUE(".\" + fn_i + ".bpi" ).
   OUTPUT TO VALUE(".\" + fn_i + ".bpo" ).
   {gprun.i ""xxsois1112.p""}
   INPUT CLOSE .
   OUTPUT CLOSE .
   batchrun = NO.

 FOR EACH xxso1:
     if can-find (first tr_hist use-index tr_nbr_eff
       WHERE tr_domain = global_domain
         AND tr_nbr = xxso1_nbr
         AND tr_effdate = xxso1_effdate
         AND tr_line = xxso1_line
         AND tr_part = xxso1_part
         AND tr_loc = xxso1_loc
         AND tr_serial = xxso1_lot
         AND tr_qty_loc = - xxso1_lot_qty
         AND tr_trnbr > v_tr_trnbr
         AND tr_type = "ISS-SO" )
     THEN DO:
         xxso1_error = "导入成功".
      END.
      ELSE DO:
         xxso1_error = "导入失败".
      END.
end.



/**ken****************************
  /*cimload */
  FOR EACH xxso1:
      fn_i = "".
      fn_i = "xxsoship-" + replace(STRING(TIME,"HH:MM:SS"),":","-").

      OUTPUT TO VALUE( fn_i + ".inp" ).
      PUT UNFORMATTED xxso1_nbr " " xxso1_effdate " - - " xxso1_site SKIP.
      PUT UNFORMATTED xxso1_line SKIP.
      PUT UNFORMATTED xxso1_lot_qty " " xxso1_site " " xxso1_loc " " xxso1_lot SKIP.
      PUT UNFORMATTED "." SKIP.
      PUT UNFORMATTED "-" SKIP.
      PUT UNFORMATTED "-" SKIP.
      PUT UNFORMATTED "-" SKIP.
      PUT UNFORMATTED "-" SKIP.

      PUT UNFORMATTED "." SKIP.

      OUTPUT CLOSE .


      FIND LAST tr_hist WHERE tr_domain = GLOBAL_domain NO-LOCK NO-ERROR.
      v_tr_trnbr = tr_trnbr .

      batchrun = yes.
      INPUT FROM VALUE( fn_i + ".inp" ) .
      OUTPUT TO VALUE( fn_i + ".cim" ) .
      {gprun.i ""sosois.p""}
      INPUT CLOSE .
      OUTPUT CLOSE .
      batchrun = NO.


      /*111220.1 add index*/

      FIND LAST tr_hist WHERE tr_domain = GLOBAL_domain
         AND tr_nbr = xxso1_nbr
         AND tr_effdate = xxso1_effdate
         AND tr_line = xxso1_line
         AND tr_part = xxso1_part
         AND tr_loc = xxso1_loc
         AND tr_serial = xxso1_lot
         AND tr_qty_loc = - xxso1_lot_qty
         AND tr_trnbr > v_tr_trnbr
         AND tr_type = "ISS-SO" USE-INDEX tr_nbr_eff NO-LOCK NO-ERROR .
      IF AVAIL tr_hist THEN DO:
         xxso1_error = "导入成功".
         OS-DELETE VALUE( fn_i + ".inp").
         OS-DELETE VALUE( fn_i + ".cim").
      END.
      ELSE DO:
         xxso1_error = "导入失败".
      END.

  END.

*********************************/