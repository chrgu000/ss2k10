/* xxpold0.p - import from xls                                            */
{mfdeclre.i}
{xxloaddata.i}
{xxpild.i}
DEFINE VARIABLE i AS INTEGER.
assign i  = 0.
FOR EACH xxtmppi EXCLUSIVE-LOCK:
    assign i = i + 1.
    assign xxpi_sn = i.
    if xxpi_start < today then do:
       assign xxpi_chk = getMsg(728).
       next.
    end.
    if xxpi_cs <> "" then do:
      find an_mstr where an_mstr.an_domain = global_domain and
           an_type = "9" and an_code = xxpi_cs no-lock no-error.
      if not available an_mstr then do:
         /* Look for customer number   */
         /* (This assumes type is "9") */
         find cm_mstr  where cm_mstr.cm_domain = global_domain and
         cm_addr = xxpi_cs no-lock no-error.
         if not available cm_mstr then do:
            xxpi_chk = xxpi_cs + " " + getMsg(6901). /* AC must exist */
         end.   /* if not available cm_mstr then do: */
      end. /* if not available an_mstr then do: */
      else do:
         if not an_active then do:
            xxpi_chk = xxpi_cs + " " + getMsg(6907). /* AC is inactive */
         end. /* if not an_active then do: */
      end. /* else do: */
   end. /* if xxpi_cs <> all_token then do: */
   if xxpi_part = "" then do:
      xxpi_chk = "Áã¼þ²»¿É¿Õ°×".
   end.
   else do:
        find an_mstr where an_mstr.an_domain = global_domain and
             an_type = "6" and an_code = xxpi_part no-lock no-error.
        if not available an_mstr then do:
           /* Look for item */
           /* (This assumes type is "6") */
           find pt_mstr  where pt_mstr.pt_domain = global_domain and
                pt_part = xxpi_part no-lock no-error.
           if not available pt_mstr then do:
              xxpi_chk = xxpi_part + " " + getMsg(6901).  /* AC must exist */
           end. /* if not available pt_mstr then do: */
        end. /* if not available an_mstr then do: */
        else do:
           if not an_active then do:
              xxpi_chk = xxpi_part + " " + getMsg(6907). /* AC is inactive */
           end. /* if not an_active then do: */
        end. /* else do: */
   end.
END.
