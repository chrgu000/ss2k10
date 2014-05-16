/* bcmenufm.i - barcode menu system form define                               */
/*V8:RunMode=Character                                                        */
/*V8:ConvertMode=NoConvert                                                    */

/*   form                                                                     */
/*      bctitle format "x(14)"                                                */
/*   with frame aa no-labels width 40 no-attr-space page-top                  */
/*   row rownbr overlay no-box /* title color normal name */ .                */

   form
      cselection 
   with frame bb row 10 overlay no-labels no-box width 40 attr-space.

   form
      bctitle   
      proclabel[1] skip
      proclabel[2] skip
      proclabel[3] skip
      proclabel[4] skip
      proclabel[5] skip
      proclabel[6] skip
      proclabel[7] skip
      proclabel[8] skip
   with frame dd no-labels no-box width 40  attr-space.

     form
        bctitle                                                                         
        proclabel[1]  format "x(24)" skip                                         
        proclabel[2]  format "x(24)" skip                                         
        proclabel[3]  format "x(24)" skip                                         
        proclabel[4]  format "x(24)" skip                                         
        proclabel[5]  format "x(24)" skip                                         
        proclabel[6]  format "x(24)" skip                                         
        proclabel[7]  format "x(24)" skip                                         
        proclabel[8]  format "x(24)" skip                                         
     with frame ee no-labels no-box width 40 attr-space.                          
