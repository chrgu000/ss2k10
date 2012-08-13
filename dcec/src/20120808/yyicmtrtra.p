/*zzicmtrtra.p	CREATE BY LONG BO 2004 JUN 21					*/
/*	ITEM TRANSFER ORDER TRANSFER		LINE DISPLAY			*/
/*	移库单移库	显示行											*/



	 {mfdeclre.i}

	define shared variable lad_recno as recid.
	def   shared var nbr like lad_nbr.
	define shared variable site_from like lad_site no-undo.
	define shared variable site_to   like lad_site no-undo.

	define variable sw_reset like mfc_logical.
	define variable desc1	like pt_desc1.
	define variable um		like pt_um.
	def var del-yn as logic.
	
	def var old_loc_from like loc_loc.
	def var old_qty		like lad_qty_all.
	def var old_lot		like ld_lot.
	def var old_ref 	like ld_ref.
	

form
 	lad_line format "x(3)" COLUMN-LABEL "序"
 	lad_part 		colon 10 COLUMN-LABEL "零件"
 	lad_qty_all		colon 30 COLUMN-LABEL "分配数"
 	lad_loc			colon 40 COLUMN-LABEL "调出库位"
 	lad__qadc01		colon 68 COLUMN-LABEL "调入库位"
 	desc1			colon 10 no-label
 	um				colon 32 no-label
 	lad_lot			colon 40 COLUMN-LABEL "批序号" 
  	in__qadc01  	colon 68 COLUMN-LABEL "保管员"  		
	with /*down*/ frame c width 80 /*overlay*/ title color normal "备料明细" THREE-D /*GUI*/.         
	  

	sw_reset = yes.   
	mainloop1:   
        repeat:
/*/*GUI*/ if global-beam-me-up then undo, leave.*/                  /*eyes*/

/*FIND LAST BOM USE-INDEX BOMINDEX. ASSIGN BOM.OPTYPE = "DEL".*/
/*F0PV*/    if not batchrun then do:

               /* {1} = File-name (eg pt_mstr)                    */
               /* {2} = Index to use (eg pt_part)                 */
               /* {3} = Field to select records by (eg pt_part)   */
               /* {4} = Field(s) to display from primary file     */
               /* {5} = Field to highlight (eg pt_part)           */
               /* {6} = Frame name                                */
               /* {7} = Selection Criterion                       */
               /* {8} = Message number for the status line        */
/*G1DT*/       /* {9} = Exclusive lock needed (Y/N)            */

               {yympscradx.i
                  lad_det
                  lad_det              
                  lad_line
                  "lad_line lad_part lad_qty_all lad_loc lad_lot desc1 um lad__qadc01 in__qadc01"
				  lad_line
				  c
				  "lad_dataset = ""itm_det"" and lad_nbr = nbr and lad_qty_all <> 0 "				
                  8808
                  yes
               }    /*judy zz-> yy*/

/*F0PV*/    end.    /* if not batchrun then do */
             
			if keyfunction(lastkey) = "end-error"
			or lastkey = keycode("F4")
			or keyfunction(lastkey) = "."
			or lastkey = keycode("CTRL-E") then do:
            	leave.
            	
            /*   for each tr no-lock:
                   disp tr.
               end.
               ok_yn = no.
               {mfgmsg10.i 12 1 ok_yn}
            
               if not ok_yn then undo mainloop1,leave.
               else if ok_yn then leave.
               if ok_yn = ? then do:
                   sw_reset = yes.
                   undo mainloop1,retry.
               end.
            	*/
            end. /*if keyfunction*/
        
		end. /*mailloop1,repeat*/            
