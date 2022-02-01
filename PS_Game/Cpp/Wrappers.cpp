#include "pch.h"

DWORD CGameDataGetItemInfo = 0x4059B0;
DWORD CUserItemCreate = 0x46BD10;

__declspec(naked) void GiveItem() {
	_asm
	{
		push ebp // Save EBP
		mov ebp, esp // Move the current stack to EBP
		mov ecx, [ebp + 0x8] // TypeID
		mov eax, [ebp + 0xC] // Type
		mov edi, [ebp + 0x10] // Player
		call CGameDataGetItemInfo // Result is now in EAX
		// If the item info pointer is 0, don't create the item
		cmp eax, 0x0
		je GiveItem_exit

		// Player needs to be in ECX
		mov ecx, edi
		push 0x1 // Item count
		push eax // Item data
		call CUserItemCreate

		GiveItem_exit :
		pop ebp // Restore EBP to it's previous value
		retn 0xC // Restore the stack
	}
}

DWORD CUserItemDelete = 0x46C6A0;
__declspec(naked) void DeleteItem() {
	_asm
	{
		push ebp
		mov ebp, esp

		// Preserve the state of our registers
		pushad
		pushfd

		mov edi, [ebp + 0x08] // Item
		mov ebx, [ebp + 0x0C] // Player

		// ECX = Type, EDX = TypeID
		movzx ecx, [edi + 0x40]
		movzx edx, [edi + 0x41]

		// Delete the item
		push edx
		push ecx
		push ebx
		call CUserItemDelete

		// Restore the stack
		popfd
		popad
		pop ebp
		retn 0x8
	}
}

DWORD CGameDataGetSkillInfo = 0x41BB30;
DWORD CUserUseItemSkill = 0x4725B0;

__declspec(naked) void UseSkill() {
	_asm
	{
		// Use a skill for a player instance (player, id, level)	
		push ebp // Save EBP
		mov ebp, esp // Move the current stack to EBP
		mov edx, [ebp + 0x8] // Skill Level
		mov eax, [ebp + 0xC] // Skill ID
		mov edi, [ebp + 0x10] // Player
		call CGameDataGetSkillInfo // Result is now stored in EAX
		call CUserUseItemSkill
		pop ebp // Restore EBP to it's previous value
		retn 0xC // Restore the stack
	}
}


__declspec(naked) void Teleport() {
	_asm
	{
		// Preserve the stack
		push ebp
		mov ebp, esp
		pushad
		pushfd

		mov ecx, [ebp + 0x18] // Player
		mov edi, [ebp + 0x14] // Map
		mov edx, [ebp + 0x10] // X
		mov esi, [ebp + 0x0C] // Z
		mov eax, [ebp + 0x08] // Height

		// Set the teleport data
		mov[ecx + 0x58B8], 0x3E8 // TeleportDelay
		mov[ecx + 0x58B4], 0x1	 // TeleportType
		mov[ecx + 0x58BC], edi	 // TeleportMapId
		mov[ecx + 0x58C0], edx	 // TeleportDestX
		mov[ecx + 0x58C4], esi	 // TeleportDestZ
		mov[ecx + 0x58C8], eax	 // TeleportDestX

		// Restore the stack
		popfd
		popad
		pop ebp
		retn 0x10
	}
}
