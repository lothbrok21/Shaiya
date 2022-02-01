### PS_Game
#### Scripts
`Reload` Adds a command to help us reload data.

### PS_Login

A modified version of the original `Episode 4 PS_Login` binary, where we can apply fixes or add new packets.

### PS_dbAgent

A modified version of the original `Episode 5 PS_dbAgent` binary, where we can apply fixes.

# Building
- PS_Login project is built with  [NASM]. Simply run `nasm -o ps_dbAgent.exe asm/ps_dbAgent.asm` in the root directory.
- PS_dbAgent project is built with [NASM]. Simply run `nasm -o ps_login.exe asm/ps_login.asm` in the root directory.
## PE
- To create the pe.asm file simply run `./pe exename.exe` in the PE directory.
- Use [petools] to add section for your custom code.

[petools]:https://github.com/petoolse/petools
[NASM]:https://nasm.us/
[Visual Studio]:https://visualstudio.microsoft.com