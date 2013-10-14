/* bccomm.i - bacrcode common program                                         */
/*V8:RunMode=Character                                                        */
/*V8:ConvertMode=NoConvert                                                    */

FUNCTION getBcRootMenu RETURNS character:
    define variable rootmenu as character initial "99".
    find first code_mstr no-lock where code_domain = GLOBAL_DOMAIN
           and code_fldnam = "BC_MENUROOT" no-error.
    if available code_mstr then do:
       for first mnt_det fields(mnt_label mnt_lang mnt_nbr mnt_select)
          where mnt_nbr = code_value
            and mnt_select = 0
            and mnt_lang = global_user_lang
          no-lock :
          assign rootmenu = trim(code_value).
       end.
    end.
    return rootmenu.
END FUNCTION. /*FUNCTION getBcRootMenu*/
