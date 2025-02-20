.586
.model flat, stdcall
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;includem biblioteci, si declaram ce functii vrem sa importam
includelib msvcrt.lib
extern exit: proc
extern malloc: proc
extern memset: proc
extern printf: proc

includelib canvas.lib

extern BeginDrawing: proc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;declaram simbolul start ca public - de acolo incepe executia
public start
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;sectiunile programului, date, respectiv cod
.data
;aici declaram date
spatiu db 10, 0
window_title DB "Exemplu proiect desenare",0
area_width EQU 960
area_height EQU 800
matrice_width dd 640
matrice_height dd 640
area DD 0
nr_patrate EQU 256

counter DD 0 ; numara evenimentele de tip timer

arg1 EQU 8
arg2 EQU 12
arg3 EQU 16
arg4 EQU 20

symbol_width EQU 10
symbol_height EQU 20

image_width DD 0
image_height DD 0
format_d db "%d ",0
formatd db "%d",0

include digits.inc
include letters.inc
include final_bomb.inc
include zero.inc
include unuf.inc
include doi.inc
include treif.inc
include patru.inc
include cinci.inc
include sase.inc
include sapte.inc
include opt.inc
include tabela.inc
include steag.inc

matrice dd 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
        dd 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
        dd 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
        dd 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
        dd 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
        dd 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
        dd 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
        dd 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
        dd 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
        dd 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
        dd 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
        dd 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
        dd 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
        dd 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
        dd 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
        dd 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
		
matrice_final dd 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
              dd 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
              dd 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
              dd 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
              dd 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
              dd 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
              dd 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
              dd 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
              dd 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
              dd 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
              dd 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
              dd 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
              dd 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
              dd 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
              dd 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
              dd 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
		
x dd 0
y dd 0

lung_patrat dd 30
linii dd 16
coloane dd 16

gameover dd 0 ;presupunem ca jocul nu s-a incheiat
counter2 dd 0 ; counter secundar ca sa micsoram frecventa, de la 200ms la 1s

nr_spatii_ramase dd 0
gamewin dd 0

flag dd 0
nr_flag_folosite dd 40

.code
; procedura make_text afiseaza o litera sau o cifra la coordonatele date
; arg1 - simbolul de afisat (litera sau cifra)
; arg2 - pointer la vectorul de pixeli
; arg3 - pos_x
; arg4 - pos_y
linie_orizontala macro x, y, len, color
local bucla_linia
    pusha
	mov eax, y
	mov ebx, area_width
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	mov ecx, len
bucla_linia:
	mov dword ptr[eax], color
	add eax, 4
	loop bucla_linia
	popa
endm

patrat macro x,y,len,color
local final_bucla,bucla
    mov EAX,590
    mov EBX,y
bucla:
    cmp EAX,0
    jbe final_bucla
    push EAX
    push EBX
    linie_orizontala x , EBX ,len, color
    pop EBX
    pop EAX
    dec EAX
    inc EBX
    jmp bucla
final_bucla:
endm

patrat_mic macro x,y,len,color
local final_bucla,bucla
    mov EAX,30
    mov EBX,y
bucla:
    cmp EAX,0
    jbe final_bucla
    push EAX
    push EBX
    linie_orizontala x , EBX ,len, color
    pop EBX
    pop EAX
    dec EAX
    inc EBX
    jmp bucla
final_bucla:
endm

linie_verticala macro x,y,len, color
  local bucla_linie
	pusha
	mov eax, y
	mov ebx,area_width
	mul ebx
	add eax,x
	shl eax,2
	add eax, area
	mov ecx,len
bucla_linie:
    mov dword ptr[eax],color
    add eax, area_width*4
    loop bucla_linie
	popa

endm

generare_bomba macro bomba
local generare_bomba
  mov ecx,40
  generare_bomba:
    rdtsc
    shl eax,24
    shr eax,24
    cmp matrice[eax*4],bomba
    je generare_bomba
    mov dword ptr matrice[eax*4],bomba
    loop generare_bomba
    mov esi, 0
	mov ecx, 256
endm

make_text proc
	push ebp
	mov ebp, esp
	pusha
	mov eax, [ebp+arg1] ; citim simbolul de afisat
	cmp eax, 'A'
	jl make_digit
	cmp eax, 'Z'
	jg make_digit
	sub eax, 'A'
	lea esi, letters
	jmp draw_text
	
make_digit:
	cmp eax, '0'
	jl make_space
	cmp eax, '9'
	jg make_space
	sub eax, '0'
	lea esi, digits
	jmp draw_text
	
make_space:	
	mov eax, 26 ; de la 0 pana la 25 sunt litere, 26 e space
	lea esi, letters
	
draw_text:
	mov ebx, symbol_width
	mul ebx
	mov ebx, symbol_height
	mul ebx
	add esi, eax
	mov ecx, symbol_height
	
bucla_simbol_linii:
	mov edi, [ebp+arg2] ; pointer la matricea de pixeli
	mov eax, [ebp+arg4] ; pointer la coord y
	add eax, symbol_height
	sub eax, ecx
	mov ebx, area_width
	mul ebx
	add eax, [ebp+arg3] ; pointer la coord x
	shl eax, 2 ; inmultim cu 4, avem un DWORD per pixel
	add edi, eax
	push ecx
	mov ecx, symbol_width
	
bucla_simbol_coloane:
	cmp byte ptr [esi], 0
	je simbol_pixel_alb
	mov dword ptr [edi], 0   ;culoare litere
	jmp simbol_pixel_next
	
simbol_pixel_alb:
	mov dword ptr [edi], 0FFFFFFh
	
simbol_pixel_next:
	inc esi
	add edi, 4
	loop bucla_simbol_coloane
	pop ecx
	loop bucla_simbol_linii
	popa
	mov esp, ebp
	pop ebp
	ret
make_text endp

make_img_macro macro var,drawArea, x, y, inaltime, latime
mov image_height,inaltime
mov image_width,latime
    push eax
	mov eax, offset[var]
	push y
	push x
	push drawArea
	call make_img
	add esp, 12
	pop eax
endm

; pentru a afisa peste patrate un alt rand de mine, folosesc alta metoda, si anume cea cu functii.
; avem nevoie de macro-ul pt crearea unui patrat si mai avem nevoie de: distanta dintre patratele pe axa x si axa y si sa stim pozitia primului patrat din stanga sus
; vom avea nevoie de 2 loop-uri

make_img proc
	push ebp
	mov ebp, esp
	pusha
	lea esi,[eax]
	
draw_image:
	mov ecx, image_height

loop_draw_lines:
	mov edi, [ebp+arg1] ; pointer to pixel area
	mov eax, [ebp+arg3] ; pointer to coordinate y
	
	add eax, image_height 
	sub eax, ecx ; current line to draw (total - ecx)
	
	mov ebx, area_width
	mul ebx	; get to current line
	
	add eax, [ebp+arg2] ; get to coordinate x in current line
	shl eax, 2 ; multiply by 4 (DWORD per pixel)
	add edi, eax
	
	push ecx
	mov ecx, image_width ; store drawing width for drawing loop
	
loop_draw_columns:

	push eax
	mov eax, dword ptr[esi] 
	mov dword ptr [edi], eax ; take data from variable to canvas
	pop eax
	
	add esi, 4
	add edi, 4 ; next dword (4 Bytes)
	
	loop loop_draw_columns
	
	pop ecx
	loop loop_draw_lines
	popa
	
	mov esp, ebp
	pop ebp
	ret
make_img endp

; un macro ca sa apelam mai usor desenarea simbolului
make_text_macro macro symbol, drawArea, x, y
	push y
	push x
	push drawArea
	push symbol
	call make_text
	add esp, 16
endm
   
   ; am realizat initial un program in c pentru generarea nr, dupa care l-am realizat in asamblare 
generare_numere macro
    xor esi, esi    ; i = 0
    
outer_loop:
    cmp esi, linii
    jge afara   ; Exit daca i >= linii 
    xor edi, edi    ; j = 0
        
inner_loop:
    cmp edi, coloane ; j a ajuns la capat
    jge next_outer    ; continuam la urmatorul outer loop iteration daca j >= coloane
    mov eax, esi    ; eax = i
    mul coloane   ; eax = i * coloane
    add eax, edi    ; eax = i * coloane + j
    mov ebx, [matrice + eax * 4]    ; ebx = matrice[i][j]
    cmp ebx, 10
    je skip    ; trecem peste daca matrice[i][j] == 10 (10 reprezinta bomba)
    xor ecx, ecx    ; count = 0
            
    ; verificam cele 8 celule vecine 
check_top_left:
    cmp esi, 0
    jle check_top_center
    cmp edi, 0
    jle check_top_center
                
    ; verificam matrice[i-1][j-1]
    mov eax, esi
    dec eax
    mul coloane
    mov edx, edi
    dec edx
    add eax, edx
    cmp dword ptr matrice[eax*4], 10
	jne check_top_center
    inc ecx
            
check_top_center:
    cmp edi, 0
    jle check_top_right
                
    ; verificam matrice[i-1][j]
    mov eax, esi
    dec eax
    mul coloane
    add eax, edi
    cmp dword ptr matrice[eax*4], 10
	jne check_top_right
    inc ecx
            
check_top_right:
    cmp esi, 0
    jle check_middle_left
    cmp edi, 15
    jge check_middle_left
                
   ; verificam matrice[i-1][j+1]
     mov eax, esi
     dec eax
     mul coloane
     mov edx, edi
     inc edx
     add eax, edx
     cmp dword ptr matrice[eax*4], 10
	 jne check_middle_left
     inc ecx
            
check_middle_left:
     cmp edi, 0
     jle check_middle_right
                
    ; verificam matrice[i][j-1]
     mov eax, esi
     mul coloane
     dec eax
     add eax, edi
     cmp dword ptr matrice[eax*4], 10
	 jne check_middle_right
     inc ecx
            
check_middle_right:
     cmp edi, 15
     jge check_bottom_left
                
   ; verificam matrice[i][j+1]
     mov eax, esi
     mul coloane
     inc eax
     add eax, edi
     cmp dword ptr matrice[eax*4], 10
	 jne check_bottom_left
     inc ecx
            
check_bottom_left:
     cmp esi, 15
     jge check_bottom_center
     cmp edi, 0
     jle check_bottom_center
                
   ; verificam matrice[i+1][j-1]
     mov eax, esi
     inc eax
     mul coloane
     mov edx, edi
     dec edx
     add eax, edx
     cmp dword ptr matrice[eax*4], 10
	 jne check_bottom_center
     inc ecx
            
check_bottom_center:
     cmp esi, 15
     jge check_bottom_right
                
   ; verificam matrice[i+1][j]
     mov eax, esi
     inc eax
     mul coloane
     add eax, edi
     cmp dword ptr matrice[eax*4], 10
	 jne check_bottom_right
     inc ecx
            
check_bottom_right:
     cmp esi, 15 
     jge increment_board
     cmp edi, 15
     jge increment_board
                
    ; verificam matrice[i+1][j+1]
     mov eax, esi
     inc eax
     mul coloane
     mov edx, edi
     inc edx
     add eax, edx
     cmp dword ptr matrice[eax*4], 10
	 jne increment_board
     inc ecx
            
increment_board:
     mov eax, esi    ; eax =i
     mul coloane   ; eax = i * coloane
     add eax, edi    ; eax = i * coloane + j
     mov [matrice + eax * 4], ecx    ; matrice[i][j] = count
            
skip:
     inc edi
     jmp inner_loop
            
next_outer:
     inc esi
     jmp outer_loop
	 
afara:

endm

    ; macro care verifica daca jocul a fost castigat
win macro
local numarare_matrice, sare, urmat
	mov ecx, 256
	mov esi, 0
	mov nr_spatii_ramase, 0
numarare_matrice:
    push ecx
    cmp matrice_final[esi*4], 0
	jne sare
    inc nr_spatii_ramase
sare:	
	inc esi
	pop ecx
    loop numarare_matrice

	cmp nr_spatii_ramase, 40 
	jne urmat
	mov gamewin, 1
urmat:

endm

; functia de desenare - se apeleaza la fiecare click
; sau la fiecare interval de 200ms in care nu s-a dat click
; arg1 - evt (0 - initializare, 1 - click, 2 - s-a scurs intervalul fara click)
; arg2 - x
; arg3 - y
draw proc
	push ebp
	mov ebp, esp
	pusha
	
	mov eax, [ebp+arg1]
	cmp eax, 1
	jz evt_click
	cmp eax, 2
	jz evt_click ; nu s-a efectuat click pe nimic
	cmp eax, 3
	jz evt_click
	;mai jos e codul care intializeaza fereastra cu pixeli albi
	mov eax, area_width
	mov ebx, area_height
	mul ebx
	shl eax, 2
	push eax
	push 255
	push area
	call memset
	add esp, 12
	
	; generam bombele pe pozitii aleatoare
	; cream tabela cu ajutorul unui fisier
	; generam numerele
	
	generare_bomba 10
	creare_tabela
	
	; ingrosam marginile
	; linie_verticala 151,100,590,0
	; linie_verticala 150,100,590,0
	; linie_verticala 631,100,590,0
	; linie_verticala 630,100,590,0
	
	; linie_orizontala  150,101,480,0
	; linie_orizontala  150,102,480,0
	; linie_orizontala  150,691,480, 0
	; linie_orizontala  150,692,480, 0

	generare_numere
	 
	mov ebx, 0
	mov esi, 0
	mov ecx, 256
	
	; afisam matricea
afisare_matrice1:
    push ecx
    push dword ptr matrice[esi*4]
	push offset format_d
	call printf                    ;eax se modifica cand se apeleaza
    add esp, 8
	inc esi
	
	inc ebx
	cmp ebx, 16
	jne sari
	push offset spatiu
	call printf
	add esp, 4
	mov ebx, 0
	
sari:
	pop ecx
    loop afisare_matrice1
	jmp afisare_litere
	
evt_click:
    win ;apelam functia care verif daca am castigat
	cmp gamewin, 1
	je msg_win
	;
	cmp gameover, 1
	je msg_stop
	
	; ca sa punem un steag pe un patrat, va trebui sa apasam initial tasta 'F', dupa care vom da click pe patratul unde ne dorim sa afisam steagul
	cmp dword ptr[ebp+arg2], 'F'
	jne mergi_mai_departe
	mov flag, 1 ;flagul e activ
	jmp final_draw
	
mergi_mai_departe:
	; verificam daca se afla in tabel
	cmp dword ptr[ebp+arg2], 152
	jl nu_e_in_tabel
	cmp dword ptr[ebp+arg2], 632
	jg nu_e_in_tabel
	
	cmp dword ptr[ebp+arg3], 210
	jl nu_e_in_tabel
	cmp dword ptr[ebp+arg3], 690
	jg nu_e_in_tabel
	
	; actualizam cele 2 coordonate x si y pentru a putea incadra perfect imaginea in patrat, indiferent de coltul in care apasam in patrat
	; actualizam coordonata x
	mov ecx, dword ptr[ebp+arg2]
	mov x,ecx ; salvam in x coordonata x
	sub x,152 ; click-margine
	mov eax,x ; mutam in eax val rez scaderii
	mov edx,0 
	div lung_patrat ; in edx stocam restul
	mov esi,eax
	sub [ebp+arg2],edx  ; in x avem noua coordonata
	
	; actualizam coordonata y
    mov ecx, dword ptr[ebp+arg3]
	mov y,ecx ; salvam in y coordonata y
	sub y,210 ; click-margine
	mov eax,y ; mutam in eax val rez scaderii
	mov edx,0 
	div lung_patrat ; in edx stocam restul
	sub [ebp+arg3],edx  ; in x avem noua coordonata
	;mov esp,eax
	mov ecx, 64
	mul ecx
	
	pusha
	push flag
	push offset format_d
	call printf
	add esp,8
	popa
	
	;cazul flag
	cmp flag, 1
	jne continuare
	make_img_macro steag_0,area,[ebp+arg2], [ebp+arg3],30,30
	dec nr_flag_folosite
	mov flag, 0  ;flag se reseteaza
	jmp af
	
continuare:
    ; inseram poza cu bomba la fiecare pozitie generata random
	cmp matrice[esi*4][eax], 10
	jne jump
	make_img_macro bomb_0,area,[ebp+arg2], [ebp+arg3],30,30; [ebp+arg2]- coordonata x si [ebp+arg3]-coordonata y
	jmp nu_incrementeaza_matrice_final
	
jump:
   mov matrice_final[esi*4][eax],1
   
nu_incrementeaza_matrice_final:
	cmp matrice[esi*4][eax],0
	jne jump1
	make_img_macro zero_0,area,[ebp+arg2], [ebp+arg3],30,30; [ebp+arg2]- coordonata x si [ebp+arg3]-coordonata y
	jmp af
	
	; am realizat 8 jump-uri pentru inserarea pozelor cu cifrele de la 0->8 la pozitiile generate in matricea logica din spatele tabelei
jump1:
    cmp matrice[esi*4][eax],1
	jne jump2
	make_img_macro unuf_0,area,[ebp+arg2], [ebp+arg3],30,30; [ebp+arg2]- coordonata x si [ebp+arg3]-coordonata y
	jmp af
	
jump2:
    cmp matrice[esi*4][eax],2
	jne jump3
	make_img_macro doi_0,area,[ebp+arg2], [ebp+arg3],30,30; [ebp+arg2]- coordonata x si [ebp+arg3]-coordonata y
	jmp af
	
jump3:
    cmp matrice[esi*4][eax],3
	jne jump4
	make_img_macro treif_0,area,[ebp+arg2], [ebp+arg3],30,30; [ebp+arg2]- coordonata x si [ebp+arg3]-coordonata y
	jmp af
	
jump4:
    cmp matrice[esi*4][eax],4
	jne jump5
	make_img_macro patru_0,area,[ebp+arg2], [ebp+arg3],30,30; [ebp+arg2]- coordonata x si [ebp+arg3]-coordonata y
	jmp af
	
jump5:
    cmp matrice[esi*4][eax],5
	jne jump6
	make_img_macro cinci_0,area,[ebp+arg2], [ebp+arg3],30,30; [ebp+arg2]- coordonata x si [ebp+arg3]-coordonata y
	jmp af
	
jump6:
    cmp matrice[esi*4][eax],6
	jne jump7
	make_img_macro sase_0,area,[ebp+arg2], [ebp+arg3],30,30; [ebp+arg2]- coordonata x si [ebp+arg3]-coordonata y
	jmp af
	
jump7:
    cmp matrice[esi*4][eax],7
	jne jump8
	make_img_macro sapte_0,area,[ebp+arg2], [ebp+arg3],30,30; [ebp+arg2]- coordonata x si [ebp+arg3]-coordonata y
	jmp af
	
jump8:
    cmp matrice[esi*4][eax],8
	jne jump9
	make_img_macro opt_0,area,[ebp+arg2], [ebp+arg3],30,30; [ebp+arg2]- coordonata x si [ebp+arg3]-coordonata y
	jmp af
	
jump9: 
    ; caz game over
    mov gameover, 1
    jmp msg_stop
	
nu_e_in_tabel:
	
	; am facut o variabila noua, counter2, pe care o vom incrementa inaintea counter-ului principal, care mai apoi dupa incrementarea counter-ului principal va fi resetat
	; am folosit aceasta variabila pentru a micsora frecventa de functionalitate a timer-ului, de la 200ms la 1s
evt_timer:
    inc counter2
	cmp counter2,5
	jne  af
	inc counter
	mov counter2,0
	
af:

afisare_litere:
	; scriem un mesaj cu titlul jocului
	; scriem numele(semnatura)
	make_text_macro 'B', area, 100, 50
	make_text_macro 'A', area, 110, 50
	make_text_macro 'R', area, 120, 50
	make_text_macro 'N', area, 130, 50
	make_text_macro 'A', area, 140, 50
	make_text_macro ' ', area, 150, 50
	make_text_macro 'M', area, 160, 50
	make_text_macro 'E', area, 170, 50
	make_text_macro 'L', area, 180, 50
	make_text_macro 'I', area, 190, 50
	make_text_macro 'S', area, 200, 50
    make_text_macro 'A', area, 210, 50
	
    make_text_macro 'M', area, 350, 50
	make_text_macro 'I', area, 360, 50
	make_text_macro 'N', area, 370, 50
	make_text_macro 'E', area, 380, 50
	make_text_macro 'S', area, 390, 50
	make_text_macro 'W', area, 400, 50
	make_text_macro 'E', area, 410, 50
	make_text_macro 'E', area, 420, 50
	make_text_macro 'P', area, 430, 50
	make_text_macro 'E', area, 440, 50
	make_text_macro 'R', area, 450, 50

	; inseram un patrat gri cu ajutorul unui macro, iar peste o imagine cu un steag
    patrat_mic 375,140,30,0808080h
	make_img_macro steag_0,area, 375,140, 30,30
	 
    ; afisam valoarea counter-ului curent (sute, zeci si unitati)
	mov ebx, 10
	mov eax, counter
	; cifra unitatilor
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area, 190, 140
	; cifra zecilor
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area, 200, 140
	; cifra sutelor
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area, 210, 140
	
	; afisez contorul, respectiv nr de flaguri, care se va decrementa
	mov ebx, 10
	mov eax, nr_flag_folosite
	; cifra unitatilor
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area, 560, 140
	; cifra zecilor
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area, 550, 140
	jmp final_draw
	
msg_stop:
    make_text_macro 'G',area,360,70
	make_text_macro 'A',area,370,70
	make_text_macro 'M',area,380,70
	make_text_macro 'E',area,390,70
	make_text_macro ' ',area,400,70
	make_text_macro 'O',area,410,70
	make_text_macro 'V',area,420,70
	make_text_macro 'E',area,430,70
	make_text_macro 'R',area,440,70
	jmp final_draw
	
msg_win:
    make_text_macro 'C',area,270,70
	make_text_macro 'O',area,280,70
	make_text_macro 'N',area,290,70
	make_text_macro 'G',area,300,70
	make_text_macro 'R',area,310,70
	make_text_macro 'A',area,320,70
	make_text_macro 'T',area,330,70
	make_text_macro 'S',area,340,70
	make_text_macro ',',area,350,70
	make_text_macro 'Y',area,360,70
	make_text_macro 'O',area,370,70
	make_text_macro 'U',area,380,70
	make_text_macro ' ',area,390,70
	make_text_macro 'W',area,400,70
	make_text_macro 'I',area,410,70
	make_text_macro 'N',area,420,70
	make_text_macro ' ',area,430,70
	make_text_macro 'T',area,440,70
	make_text_macro 'H',area,450,70
	make_text_macro 'E',area,460,70
	make_text_macro ' ',area,470,70
	make_text_macro 'G',area,480,70
	make_text_macro 'A',area,490,70
	make_text_macro 'M',area,500,70
	make_text_macro 'E',area,510,70
	make_text_macro '!',area,520,70
	jmp final_draw
	
final_draw:
	popa
	mov esp, ebp
	pop ebp
	ret
draw endp

start:
	; alocam memorie pentru zona de desenat
	mov eax, area_width
	mov ebx, area_height
	mul ebx
	shl eax, 2
	push eax
	call malloc
	add esp, 4
	mov area, eax
	
	; apelam functia de desenare a ferestrei
	; typedef void (*DrawFunc)(int evt, int x, int y);
	; void __cdecl BeginDrawing(const char *title, int width, int height, unsigned int *area, DrawFunc draw);
	push offset draw
	push area
	push area_height
	push area_width
	push offset window_title
	call BeginDrawing
	add esp, 20

	; terminarea programului
	push 0
	call exit
end start
