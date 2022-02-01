%ifndef ps_dbagent_asm
%define ps_dbagent_asm

%ifndef ptarget
    %define ptarget "bin\ps_dbAgent.exe"
%endif

imagebase       equ         0x400000

; .hdrs
virt.hdrs       equ         imagebase
raw.hdrs        equ         0x0
rsize.hdrs      equ         0x400
hdrs_vsize      equ         0x2b0
hdrs_end        equ         virt.hdrs + hdrs_vsize

; .text
virt.text       equ         imagebase + 0x1000
raw.text        equ         0x400
rsize.text      equ         0x7c200
text_vsize      equ         0x7c0ca
text_end        equ         virt.text + text_vsize

; .rdata
virt.rdata      equ         imagebase + 0x7e000
raw.rdata       equ         0x7c600
rsize.rdata     equ         0x10a00
rdata_vsize     equ         0x1094a
rdata_end       equ         virt.rdata + rdata_vsize

; .data
virt.data       equ         imagebase + 0x8f000
raw.data        equ         0x8d000
rsize.data      equ         0x2c00
data_vsize      equ         0x82c0
data_end        equ         virt.data + data_vsize

; .rsrc
virt.rsrc       equ         imagebase + 0x98000
raw.rsrc        equ         0x8fc00
rsize.rsrc      equ         0x200
rsrc_vsize      equ         0x1b4
rsrc_end        equ         virt.rsrc + rsrc_vsize

; .custom
virt.custom     equ         imagebase + 0x99000
raw.custom      equ         0x8fe00
rsize.custom    equ         0x2000
custom_vsize    equ         0x2000
custom_end      equ         virt.custom + custom_vsize

; pre-define all sections
                section     .hdrs vstart=virt.hdrs
                section     .text vstart=virt.text follows=.hdrs
                section     .rdata vstart=virt.rdata follows=.text
                section     .data vstart=virt.data follows=.rdata
                section     .rsrc vstart=virt.rsrc follows=.data
                section     .custom vstart=virt.custom follows=.rsrc

; start in the .hdrs pseudo section
                section     .hdrs
%assign cur_raw raw.hdrs
%assign cur_virt virt.hdrs
%assign cur_rsize rsize.hdrs

; move assembly position to the start of a new section
%macro va_section 1
                incbin      ptarget, cur_raw + ($-$$), raw%1 - (cur_raw + ($-$$))
                section     %1
    %assign cur_raw  raw%1
    %assign cur_virt virt%1
    %assign cur_rsize rsize%1
%endmacro

; move assembly position forward within the current section.
; use 'va_org end' at the end of the code to append the remainder of the original data
%macro va_org 1
    %ifidn %1, end
                incbin      ptarget, cur_raw + ($-$$)
    %elif %1 >= cur_virt && %1 < cur_virt + cur_rsize
                incbin      ptarget, cur_raw + ($-$$), %1 - (cur_virt + ($-$$))
    %else
        %error address %1 out of section range
    %endif
%endmacro

%endif
