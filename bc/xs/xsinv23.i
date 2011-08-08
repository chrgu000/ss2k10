/* xsinv23.i - 物料入库优先级选择                                            */
/*V8:ConvertMode=NoConvert                                                   */
/* REVISION: 0CYH LAST MODIFIED: 05/30/11   BY: zy                           */
/* Environment: Progress:9.1D   QAD:eb2sp4    Interface:Character            */
/*-revision end--------------------------------------------------------------*/    

/*-----------------------------------------------------------------------------
 *
 *         {xsinv23.i
 *            &REC_PART = Recive part number
 *            &REC_QTY  = Recive qty
 *          }
 *
 *----------------------------------------------------------------------------*/
                                                              
for each pt_mstr no-lock where pt_part = {&rec_part}                                                            

 {&rec_qty}