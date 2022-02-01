%ifndef ps_login_pe_inc
%define ps_login_pe_inc

%ifndef ptarget
    %define ptarget "bin/ps_login.exe"
%endif

imagebase       equ         0400000h

; .hdrs
virt.hdrs       equ         imagebase
raw.hdrs        equ         00h
rsize.hdrs      equ         01000h
hdrs_vsize      equ         02a0h
hdrs_end        equ         virt.hdrs + hdrs_vsize

; .text
virt.text       equ         imagebase + 01000h
raw.text        equ         01000h
rsize.text      equ         03f000h
text_vsize      equ         03e0c4h
text_end        equ         virt.text + text_vsize

; .rdata
virt.rdata      equ         imagebase + 040000h
raw.rdata       equ         040000h
rsize.rdata     equ         0c000h
rdata_vsize     equ         0be0ch
rdata_end       equ         virt.rdata + rdata_vsize

; .data
virt.data       equ         imagebase + 04c000h
raw.data        equ         04c000h
rsize.data      equ         02000h
data_vsize      equ         02de88h
data_end        equ         virt.data + data_vsize

; .custom
virt.custom       equ         imagebase + 07a000h
raw.custom        equ         04e000h
rsize.custom      equ         02000h
custom_vsize      equ         02000h
custom_end        equ         virt.custom + custom_vsize

; pre-define all sections
                section     .hdrs vstart=virt.hdrs
                section     .text vstart=virt.text follows=.hdrs
                section     .rdata vstart=virt.rdata follows=.text
                section     .data vstart=virt.data follows=.rdata
                section     .custom vstart=virt.custom follows=.data

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
