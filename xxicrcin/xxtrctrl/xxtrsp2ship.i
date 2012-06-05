/* xtrsp2ship.i - xxtrsp2ship.i record splited item to xxship_det           */
/*V8:ConvertMode=Maintenance                                                 */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 24YP LAST MODIFIED: 04/24/12 BY: zy expand xrc length to 120    */
/* REVISION END                                                              */

/* -----------------------------------------------------------
   Purpose: 单个物料调拨时将已拆分物料的记录在xxship_det.
   Parameters: 
             {1} Item_Number
             {2} Lot/Serial
   Notes:
 -------------------------------------------------------------*/

 find first xxship_det exclusive-lock where xxship_part2 = {1} 
  		  and xxship__chr01 = {2} and xxship__chr03 = "" no-error.
 if available xxship_det then do:
 	    assign xxship__chr03 = "SPLITED".
 end.
 