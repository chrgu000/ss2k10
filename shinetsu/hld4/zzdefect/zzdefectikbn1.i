/* ss - 120305.1 by: kaine zhang */

if wk_def_kikaku_cd = "" then do:
    /*
     * bad reason master search
     * def_chk_kbn  00016  under_type
     * def_size_cho 00017  defect_size_over
     * def_size_ika 00018  defect_size_under
     * kizu_kbn     00008  scratch
     * defect_io_kbn 00021 defect_in_out
     */

    for each mpd_det
        where mpd_domain = global_domain 
            and mpd_nbr = "xc" + {1}
            and
            (
                mpd_type = "00008" or mpd_type = "00016" or mpd_type = "00017" or
                mpd_type = "00018" or mpd_type = "00021"
            )
        no-lock:
        if mpd_type = "00016" then do:
            wk_def_chk_kbn = mpd_tol.
        end.

        if mpd_type = "00017" then do:
            wk_def_size_cho = decimal(mpd_tol).
        end.

        if mpd_type = "00018" then do:
            wk_def_size_ika = decimal(mpd_tol).
        end.

        if mpd_type = "00008" then do:
            wk_def_kizu_kbn = mpd_tol.
        end.

        if mpd_type = "00021" then do:
            wk_defect_io_kbn = mpd_tol.
        end.
    end.
end.
else do:
    for each mpd_det where mpd_domain = global_domain and mpd_nbr = "xc" + {1}
        and mpd_type = "00021"
        no-lock:
        wk_defect_io_kbn = mpd_tol.
    end.
    
    /*
     * defect type masterb??search
     * wk_def_chk_kbn  00001   under_type
     * wk_def_size_cho 00002   defect_size_over
     * wk_def_size_ika 00003   defect_size_under
     * wk_def_kizu_kbn 00004   scrach
     */
    for each mpd_det where mpd_domain = global_domain and mpd_nbr = "xr" + wk_def_kikaku_cd + {1} no-lock:
        if mpd_type = "00001" then do:
            wk_def_chk_kbn = mpd_tol.
        end.
    
        if mpd_type = "00002" then do:
            wk_def_size_cho = decimal(mpd_tol).
        end.
    
        if mpd_type = "00003" then do:
            wk_def_size_ika = decimal(mpd_tol).
        end.
    
        if mpd_type = "00004" then do:
            wk_def_kizu_kbn = mpd_tol.
        end.
    end.
end.



if wk_defect_io_kbn = '1' then do:
    wk_rowsf  =  wk_rowsf + 1.
    wk_apf[wk_rowsf] = {2}.
    wk_sizef[wk_rowsf] = {3}.
    wk_bad_cdf[wk_rowsf] = {1}.
    wk_chk_kbnf[wk_rowsf] = wk_def_chk_kbn.
    wk_size_chof[wk_rowsf] = wk_def_size_cho.
    wk_size_ikaf[wk_rowsf] = wk_def_size_ika.
    wk_kizu_kbnf[wk_rowsf] = wk_def_kizu_kbn.
end.
else do:
    wk_rowsi = wk_rowsi + 1.
    wk_api[wk_rowsi] = {2}.
    wk_sizei[wk_rowsi] = {3}.
    wk_bad_cdi[wk_rowsi] = {1}.
    wk_chk_kbni[wk_rowsi] = wk_def_chk_kbn.
    wk_size_choi[wk_rowsi] = wk_def_size_cho.
    wk_size_ikai[wk_rowsi] = wk_def_size_ika.
    wk_kizu_kbni[wk_rowsi] = wk_def_kizu_kbn.
end.


