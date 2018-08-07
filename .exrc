set autoindent
"set t_ti= t_te=
set showmatch
"set tags=tags\ /usr/src/contrib/tags\ /usr/src/lib/libthr/tags\ /usr/src/lib/libc/tags\ /home/ping/src/NP/FreeBSD/sys/tags
"set tags=tags\ /home/pingm/p4/main_ib_bib/FreeBSD/sys/tags\ /home/pingm/p4/main_ib_bib/ontap/prod/tags
map  :tagn
set tabstop=4
set shiftwidth=4
set hardtabs=4

" convert tabs to spaces with 4 space indents
map \4 1G!G pr -te4
" convert tabs to spaces with 2 space indents
map \5 1G!G pr -te2
" convert tabs to spaces with 8 space indents
map \5 1G!G pr -te8
