
{mfdeclre.i }
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

/* SHARED VARIABLES*/
{xxqmexmt01.i }

form
   t_nbr      label "货运单号"
   t_line     label "项"
   t_part     label "零件号"
   t_rcp_date label "发货日期"
   t_rcvd     label "发货数"
   /*t_vend     label "供应商"*/
   t_cu_ln    label "序"
   t_cu_part  label "商品编码"
   t_yn       label "添"
with frame y down scroll 1 width 80.


/* FOR BOOLEAN VALUE IN DOWN FRAME,    */
/* ENSURE TRANSLATION TO USER LANGUAGE */
{gpfrmdis.i &fname = "y"}

repeat for temp on endkey undo, leave
   with frame y width 80 no-attr-space down:
   {swindowd.i 
      temp 
      "y"
      t_nbr
      t_line
      t_nbr
      "t_rcvd t_yn"
      t_nbr
      t_line
      t_part
      t_rcp_date
      t_rcvd
      t_cu_ln
      t_cu_part
      t_yn 
      }

   /* {1}=file name  {2}=frame name {3}=key1 field    */
   /* {4}=key2 field {5}=scrolling field name         */
   /* {6}=field to update  {7}...{14}=display fields  */

   if keyfunction(lastkey) = "go" 
   then do:

      {mfmsg01.i 12 1 info_correct}  /* IS ALL INFO CORRECT? */
      if info_correct
      then do:
         leave.
      end.
   end. /* IF KEYFUNCTION(LASTKEY) = "GO" */

   if keyfunction(lastkey) = "end-error"
   or keyfunction(lastkey) = "return"
   then do:
         leave.
   end.

end.  /* REPEAT */

hide frame y no-pause.
