/* ss - 090903.1 by: jack */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/* ss - 091116.1 by: jack */
/******************************************************************************/

/* DISPLAY TITLE */

{mfdtitle.i "090916.1 "}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE ppxxpi_mt_p_1 "Comments"
/* MaxLen: Comment: */

&SCOPED-DEFINE ppxxpi_mt_p_7 "Acct"
/* MaxLen: Comment: */

&SCOPED-DEFINE ppxxpi_mt_p_8 "Project"
/* MaxLen: Comment: */

&SCOPED-DEFINE ppxxpi_mt_p_9 "Promotion"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

define var v_desc like pt_desc1 .
define var v_desc1 like pt_desc1 .
/* Variable to handle delete functionality using CIM */
define variable batchdelete as character format "x(1)" no-undo.

 

/* DISPLAY SELECTION FORM */
form
   xxpi_list      colon 27  v_desc1 no-label
   skip
   xxpi_part      colon 27  v_desc no-label
   skip
   xxpi_curr      colon 27
   xxpi_um        colon 27
   xxpi_start     colon 27
   xxpi_expire    colon 27
   xxpi_list_price format "->>>,>>>,>>>9.99<<<" colon 27
with frame a width 80 side-labels no-attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).



/* Set default types */
/* (Eventually, one or both of these fields might become     */
/* user accessble; for now we only allow customer and item). */


mainloop:
repeat:

   
       display
         base_curr when (input xxpi_curr = "") @ xxpi_curr with frame a.
      view frame a.

     
      prompt-for
         xxpi_list
	 xxpi_part
	 xxpi_curr
         xxpi_um
         xxpi_start
          /* ss - 091116.1 -b
	 xxpi_expire
     xxpi_list_price
         ss - 091116.1 -e */
         /* Prompt-for batchdelete variable only during CIM */
         batchdelete no-label when (batchrun)
	 with frame a 
         editing:

         if frame-field = "xxpi_list" then do:  /* scroll full list */
	     {mfnp.i xxpi_mstr xxpi_list xxpi_list xxpi_list xxpi_list xxpi_list}
            if recno <> ? then do:
               find first pt_mstr where pt_part = xxpi_part no-lock no-error .
	       if available pt_mstr then
	       v_desc = pt_desc1 .
	       find first ad_mstr where ad_addr = xxpi_list no-lock no-error .
	       if available ad_mstr then
	       v_desc1 = ad_name .
               display
                  xxpi_list
		  v_desc1
		  xxpi_part
		  v_desc
		  xxpi_curr
		  xxpi_um
		  xxpi_start
		  xxpi_expire
		  xxpi_list_price  format "->>>,>>>,>>>9.99<<<" with frame a
                 .

            end. /* if recno <> ? then do: */
         end. /* if frame-field = "xxpi_list" then do:  /* scroll full list */ */
         else do:
            status input.
            readkey.
            apply lastkey.
         end. /* else do: */
      end.  /* prompt-for xxpi_list... */  

      
      

       ststatus = stline[1].
       status input ststatus.

      find xxpi_mstr where xxpi_list      = input xxpi_list
         and xxpi_part = input xxpi_part
         and xxpi_curr      = input xxpi_curr
         and xxpi_um        = input xxpi_um
         and xxpi_start     = input xxpi_start
         exclusive-lock
         no-error.


       if not available xxpi_mstr then do:

         create xxpi_mstr.

         assign xxpi_list
	        xxpi_part 
	        xxpi_curr
	        xxpi_um
	        xxpi_start
             .
         SET xxpi_expire xxpi_list_price format "->>>,>>>,>>>9.99<<<"  WITH FRAME a.
         ASSIGN xxpi_expire xxpi_list_price .

        

      end.  /* if not avail xxpi_mstr */
      else do:

          /* ss - 091116.1 -b */
          DISPLAY  xxpi_expire xxpi_list_price  format "->>>,>>>,>>>9.99<<<"  WITH FRAME a .

          /* ss - 091116.1 -e */

         assign
	       xxpi_list
	       xxpi_part
	       xxpi_curr
	       xxpi_um
	       xxpi_start
             .
         SET xxpi_expire xxpi_list_price  format "->>>,>>>,>>>9.99<<<"  WITH FRAME a.
         ASSIGN xxpi_expire xxpi_list_price .

      end .
    
end.  /* mainloop */

status input.

