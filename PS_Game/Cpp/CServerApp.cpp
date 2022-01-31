#include "pch.h"

DWORD SConsoleAddCommand = 0x4F5BE0;

LPCSTR ntcn_command = "/ntcn";
LPCSTR ntcid_command = "/ntcid";
LPCSTR reload_command = "/reload";

void __declspec(naked) InitConsoleCommand() {
	__asm {

		push 0x0
		push -0x1
		push 0x2 // Param count
		push ntcn_command
		push 0x45 // Switch case
		mov ecx, esi
		call SConsoleAddCommand

		push 0x0
		push - 0x1
		push 0x2 // Param count
		push ntcid_command
		push 0x46 // Switch case
		mov ecx, esi
		call SConsoleAddCommand

		push 0x1
		push -0x1
		push 0x0 // Param count
		push reload_command
		push 0x47 // Switch case
		mov ecx, esi
		call SConsoleAddCommand

		originalcode :
		pop esi
		retn
	}
}


LPCSTR ntcn_command_output = "cmd send notice by char name ok!";
LPCSTR ntcid_command_output = "cmd send notice by char id ok!";
LPCSTR reload_command_output = "cmd reload ok";
LPCSTR ntcn_command_output_failed = "cmd send notice by char name(%s) failed";
LPCSTR ntcid_command_output_failed = "cmd send notice by char id(%s) failed";

DWORD OnConsoleCommandBreak = 0x40B3D4;
DWORD OnConsoleCommandRetn = 0x409498;

DWORD Atoi = 0x51BA99;
DWORD Sprintf = 0x51A8CD;
DWORD ReLoad = 0x40D410;
DWORD CWorldFindUser = 0x414CC0;
DWORD CWorldFindCharacter = 0x414CE0;
DWORD SConnectionSend = 0x4ED0E0;

void __declspec(naked) OnConsoleCommand() {
	__asm {

		cmp eax, 0x45
		je ntcn_command_code
		cmp eax, 0x46
		je ntcid_command_code
		cmp eax, 0x47
		je reload_command_code

		originalcode :
		cmp eax, 0x44
		ja OnConsoleCommandExit
		jmp OnConsoleCommandRetn

		ntcn_command_code :
		cmp dword ptr[ebp + 0x0C], 0x2  // Input count
		jne OnConsoleCommandExit
		add ebx, 0x4
		mov eax, ebx //ebx = Charname input
		call CWorldFindCharacter // CWorld::FindCharacter
		mov esi, eax
		test esi, esi // Check null return
		je ntcn_command_fail

		mov eax, [ebx + 0x100] // Notice input
		cmp eax, 0x80 // 128 Length limit
		ja ntcn_command_fail

		lea edx, [ebx + 0x104]
		sub esp, 0x100
		mov edi, esp
		mov edi, edx
		mov word ptr[esp], 0xF90B
		mov byte ptr[esp + 0x2], al
		xor edi, edi

		ntcn_str_len :
		cmp edi, eax
		je ntcn_command_success
		mov ecx, [edx + edi]
		mov[esp + edi + 0x3], ecx
		inc ecx
		inc edi
		jmp ntcn_str_len

		ntcn_command_success :
		mov edx, esp
		add eax, 0x3
		mov ecx, esi // User = esi
		push eax // Packet length
		push edx // Packet data
		call SConnectionSend 
		add esp, 0x100

		mov eax, [esp + 0x3C]
		push ntcn_command_output
		push eax
		call Sprintf
		add esp, 0x08
		jmp OnConsoleCommandExit

		ntcn_command_fail :
		push ebx
		push ntcn_command_output_failed
		push edi
		call Sprintf 
		add esp, 0x0C
		jmp OnConsoleCommandExit


		ntcid_command_code :
		cmp dword ptr[ebp + 0x0C], 0x2 // Input count
		jne OnConsoleCommandExit
		add ebx, 0x04
		push ebx // CharID input
		call Atoi 
		mov ecx, eax //eax = CharID
		add esp, 0x04
		test ecx, ecx // Check null return
		je ntcid_command_fail

		push ecx // CharID
		call CWorldFindUser 
		mov esi, eax
		test esi, esi // Check null return
		je ntcid_command_fail

		mov eax, [ebx + 0x100] // Notice input
		cmp eax, 0x80 // 128 Length limit
		ja ntcid_command_fail

		lea edx, [ebx + 0x104]
		sub esp, 0x100
		mov edi, esp
		mov edi, edx
		mov word ptr[esp], 0xF90B
		mov byte ptr[esp + 0x2], al
		xor edi, edi

		ntcid_str_len :
		cmp edi, eax
		je ntcid_command_success
		mov ecx, [edx + edi]
		mov[esp + edi + 0x3], ecx
		inc ecx
		inc edi
		jmp ntcid_str_len

		ntcid_command_success :
		mov edx, esp
		add eax, 0x3
		mov ecx, esi // User = esi
		push eax // Packet length
		push edx // Packet data
		call SConnectionSend
		add esp, 0x100

		mov eax, [esp + 0x3C]
		push ntcid_command_output
		push eax
		call Sprintf 
		add esp, 0x08
		jmp OnConsoleCommandExit

		ntcid_command_fail :
		push ebx
		push ntcid_command_output_failed
		push edi
		call Sprintf 
		add esp, 0x0C
		jmp OnConsoleCommandExit

		reload_command_code :
		call ReLoad
		push reload_command_output
		push edi
		call Sprintf
		add esp, 0x8
		jmp OnConsoleCommandExit

		OnConsoleCommandExit:
		jmp OnConsoleCommandBreak
	}
}

void CServerApp() {
	Hook((void*)0x409459, InitConsoleCommand, 5);
	Hook((void*)0x40948F, OnConsoleCommand, 9);
}
