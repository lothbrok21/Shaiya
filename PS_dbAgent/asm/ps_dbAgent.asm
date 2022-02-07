%include    "asm/pe.asm"
bits        32

va_section  .text

; ==============================================================================================================================================================
; Custom PS_dbAgent (built on top of the original Ep5 ps_dbAgent found at https://archive.shaiya.net/server/ep5.4/PSM_Client/Bin/ps_dbAgent.exe)
; ==============================================================================================================================================================

; Patch: Itemmall fix.
va_org      0x404651
jmp         CUser_OnDispatch

; Include read-only resources
va_section  .rdata

; Include mutable data
va_section  .data

; Include custom code.
va_section  .custom
%include    "asm/itemmall.asm"

; Include the remaining data.
va_org      end