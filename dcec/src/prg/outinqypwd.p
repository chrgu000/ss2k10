OUTPUT TO  f:\appeb2\batch\inbox\inqypwd.txt.
FOR EACH usr_mstr WHERE usr_userid <> "".
    PUT usr_userid ";" usr_name ";" usr_groups ";" usr_lang ";" usr_passwd SKIP.
END.
