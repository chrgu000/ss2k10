os-delete value(vWorkLog) no-error.
if '{1}' <> 'log' then do:
   os-delete value(vworkfile) no-error.
end.
