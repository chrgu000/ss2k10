
/* DISPLAY TITLE */
{mfdtitle.i "923"}

form
   skip
   cm_addr    colon 10
   ad_name    colon 10 /*V8! view-as fill-in size 35 by 1 */
   ad_line1   colon 10 /*V8! view-as fill-in size 35 by 1 */
   ad_line2   colon 10 /*V8! view-as fill-in size 35 by 1 */
   ad_line3   colon 10 /*V8! view-as fill-in size 35 by 1 */
              
   ad_city    colon 10
   ad_state   
   ad_zip     
   ad_format  
              
   ad_country colon 10
   ad_ctry    no-label
   ad_county  colon 56
              
   ad_attn    colon 10
   ad_attn2   colon 43 label "[2]"
              
   ad_phone   colon 10
   ad_ext     
   ad_phone2  colon 43 label "[2]"
   ad_ext2    
              
   ad_fax     colon 10
   ad_fax2    colon 43 label "[2]"
   ad_date    
   skip(2)    
   ad_pst_id  colon 16 format "x(120)" view-as fill-in size 60 by 1            
   cm__qadc01 colon 16 format "x(120)" view-as fill-in size 60 by 1 label "Bank"

with frame a title color normal
   (getFrameTitle("CUSTOMER_ADDRESS",24))
   side-labels width 80 attr-space.
{&ADCSMT02-I-TAG2}

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* DISPLAY */
repeat with frame a:


      prompt-for
         cm_mstr.cm_addr
         /* Prompt for batchdelete only during CIM */
      editing:

         /* FIND NEXT/PREVIOUS RECORD */
         {mfnp.i cm_mstr cm_addr
               " cm_mstr.cm_domain = global_domain and cm_addr "
                 cm_addr cm_addr cm_addr}

         if recno <> ? then do:

            find ad_mstr
               where ad_domain = global_domain
                and  ad_addr = cm_addr and ad_type = "customer"
            no-lock no-error.

            display
               cm_addr ad_name ad_line1 ad_line2 ad_line3
               ad_city ad_state ad_zip ad_format ad_country
               ad_ctry
               ad_attn ad_phone ad_ext ad_attn2 ad_phone2 ad_ext2
               ad_fax ad_fax2 ad_date
               ad_county ad_pst_id cm__qadc01.

         end. /* if recno <> ? then do: */
      end. /* editing: */

   if input cm_addr = "" then do:
      {mfmsg.i 7044 3}
      undo, retry.
   end.

   find cm_mstr where cm_mstr.cm_domain = global_domain
    and cm_addr = input cm_addr no-error.
   if not available cm_mstr then do:
      {mfmsg.i 7044 3}
      undo,retry.
   end.

   ststatus = stline[2].
   status input ststatus.
     find ad_mstr where ad_domain = global_domain
                   and  ad_addr = cm_addr and ad_type = "customer"
          exclusive-lock no-error.
     update ad_pst_id when available ad_mstr cm__qadc01.
 
end.
status input.
