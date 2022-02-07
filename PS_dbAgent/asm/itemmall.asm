CUser_OnDispatch_Return     equ     0x404656   
DBCharacter_ReloadPoint     equ     0x4235D0    ; The address to call DBCharacter::ReloadPoint.

CUser_OnDispatch:
mov ebp,esp
and esp,-0x8
pushad
call DBCharacter_ReloadPoint
popad
jmp CUser_OnDispatch_Return
