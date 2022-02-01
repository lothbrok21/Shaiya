Quotation_Mark  equ 34

; The sql statement for executing the login check. This is written slightly strange as NASM doesn't have a way to escape
; strings, so we concatenate multiple strings. The end result string is the following:
;
; EXEC usp_Try_GameLogin_Taiwan "%s","%s",%I64d,"%s"
GameLogin_Exec:
    db "EXEC usp_Try_GameLogin_Taiwan "
    db Quotation_Mark, "%s", Quotation_Mark
    db ","
    db Quotation_Mark, "%s", Quotation_Mark
    db ","
    db "%I64d"
    db ","
    db Quotation_Mark, "%s", Quotation_Mark
    db 0