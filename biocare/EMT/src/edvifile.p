/* edvifile.p - View file                                                    */
/* revision: 110712.1   created on: 20110712   by: zhang yun                 */
/*V8:ConvertMode=Report                                                      */ 
/* Environment: Progress:10.1C04  QAD:eb21sp7    Interface:Character         */
/*-Revision end--------------------------------------------------------------*/

/* DISPLAY TITLE */
{mfdtitle.i "110712.1"}
	
/* CONSIGNMENT INVENTORY VARIABLES */
{pocnvars.i}

define variable file_name as character format "x(50)". 
define buffer wkfl for qad_wkfl.
define temp-table tf
		fields tf_txt as character format "x(200)" column-label "CONTENT".

form
   file_name    colon 10   skip(1)
with frame a side-labels width 80 attr-space.


/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

	for each qad_wkfl exclusive-lock where qad_domain = "" and
				   qad_key1 = "edvifile.p" and qad_key5 = global_userid:
			delete qad_wkfl.
	end.

  INPUT FROM OS-DIR(".").
  REPEAT:
      CREATE qad_wkfl.
      IMPORT qad_key3 qad_key2 qad_key4 .
      assign qad_domain = ""
      			 qad_key1 = "edvifile.p"
      			 qad_key5 = global_userid.
  END.
  INPUT CLOSE.

	for each qad_wkfl exclusive-lock where qad_domain = "" and 
					 qad_key1 = "edvifile.p" and qad_key4 <> "F":
			delete qad_wkfl.
	end.
 

/* DETERMINE IF SUPPLIER CONSIGNMENT IS ACTIVE */
{gprun.i ""gpmfc01.p""
         "(input ENABLE_SUPPLIER_CONSIGNMENT,
           input 11,
           input ADG,
           input SUPPLIER_CONSIGN_CTRL_TABLE,
           output using_supplier_consignment)"}

{wbrp01.i}
repeat: 

   if c-application-mode <> 'web' then
      update file_name with frame a.

   {wbrp06.i &command = update &fields = "  file_name" &frm = "a"}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:
     
   end.

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "printer"
               &printWidth = 132
               &pagedFlag = " nopage "
               &stream = " "
               &appendToFile = " "
               &streamedOutputToTerminal = " "
               &withBatchOption = "no"
               &displayStatementType = 1
               &withCancelMessage = "yes"
               &pageBottomMargin = 6
               &withEmail = "yes"
               &withWinprint = "yes"
               &defineVariables = "yes"}
		empty temp-table tf no-error.

  	for each qad_wkfl no-lock where qad_domain = "" and
  	         qad_key1 = "edvifile.p" and qad_key5 = global_userid and
  			     index(qad_key3,file_name)>0 break by qad_key3 desce:
  			create tf.
  			assign tf_txt = "File:" + qad_key2.
  			create tf.
  			assign tf_txt = fill("-",60).
  			input from value(qad_key2).
  		  repeat:
  		  	create tf.
  		  	import unformat tf_txt.
  		  end.
  			input close.
  			create tf.
  			assign tf_txt = fill("-",60).
  	end.
  	
  	for each tf no-lock with frame b with width 220:
  			display tf_txt no-label.
    end.
   
		setFrameLabels(frame b:handle).
   {mfrtrail.i}

end.

{wbrp04.i &frame-spec = a}
