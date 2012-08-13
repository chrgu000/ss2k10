                           for each tx2d_det                   
                        where  tx2d_ref = "0001"  OR tx2d_nbr = "abc"  /*tx2d_tr_type = "13" */
                    no-lock:
                        DISPLAY tx2d_ref  tx2d_nbr tx2d_line tx2d_tr_type tx2d_tax_code  tx2d_cur_tax_amt tx2d_tax_amt 
                                WITH WIDTH 132.

                    END.


   
       for EACH tx2d_det  WHERE tx2d_tr_type = "16"  AND tx2d_ref = "iv10021":

        DISPLAY tx2d_by_line tx2d_cur_nontax_amt tx2d_edited     tx2d_line
                tx2d_nbr     tx2d_nontax_amt     tx2d_ref        tx2d_taxc
                tx2d_tax_env tx2d_tax_usage      tx2d_totta .

   END.
