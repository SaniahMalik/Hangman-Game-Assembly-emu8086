; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt
         
         
org 100h


jmp start

tries db 6
score db 0


word1 db 'ASSEM', 0
word2 db 'JAVA', 0
word3 db 'PYTHON', 0
word4 db 'BINARY', 0
word5 db 'OBJECT', 0
word6 db 'CODING', 0
word7 db 'SCRIPT', 0
word8 db 'DEBUG', 0
word9 db 'METHOD', 0
word10 db 'VIRTUAL', 0

hint1 db ' Low-level language',13,10,'$'
hint2 db ' Object-oriented language',13,10,'$'
hint3 db ' Interpreted language',13,10,'$'
hint4 db ' Consists of 0s and 1s',13,10,'$'
hint5 db ' Related to compiled files',13,10,'$'
hint6 db ' Another word for programming',13,10,'$'
hint7 db ' Used in scripting languages',13,10,'$'
hint8 db ' Process of fixing bugs',13,10,'$'
hint9 db ' Function inside class',13,10,'$'
hint10 db ' Used by JVM in Java',13,10,'$'   
high_score db 0
high_score_msg db 13,10, '         High Score: $'
new_high_msg db 13,10, '?          New High Score! ?$',13,10,'$'




word_ptr dw 0
hint_ptr dw 0
word_len db 0


guessed db 20 dup('_'), 0
letters_guessed db 26 dup(0)
input_char db ?
newline db 13,10,'$'    


; Banner
banner db 13,10,'         __   __  _______  __    _  _______  __   __  _______  __    _',13,10
       db '        |  | |  ||   _   ||  |  | ||       ||  |_|  ||   _   ||  |  | |',13,10
       db '        |  |_|  ||  |_|  ||   |_| ||    ___||       ||  |_|  ||   |_| |',13,10
       db '        |       ||       ||       ||   | __ |       ||       ||       |',13,10
       db '        |       ||       ||  _    ||   ||  ||       ||       ||  _    |',13,10
       db '        |   _   ||   _   || | |   ||   |_| || ||_|| ||   _   || | |   |',13,10
       db '        |__| |__||__| |__||_|  |__||_______||_|   |_||__| |__||_|  |__|',13,10
       db 13,10,'$'


prompt db 13,10,'         Enter a letter: $'
tries_label db 13,10,'         Tries left: $'
score_label db 13,10,'         Score: $'
hint_label db 13,10,'         Hint: $'
win_msg db 13,10,'         You Win!$'
lose_msg db 13,10,'         You Lose! The word was: $'
guessed_msg db 13,10,'         Word: $'
guessed_letters_msg db 13,10,'         Guessed letters: $'
play_again_msg db 13,10,'         Play again? (Y/N): $'
                                                
difficulty_prompt db 13,10,'         Select Difficulty (E=Easy / M=Medium / H=Hard): $'



drawings db 13,10,'          +---+',13,10,'          |   |',13,10,'              |',13,10,'              |',13,10,'              |',13,10,'              |',13,10,'         =======','$'
         db 13,10,'          +---+',13,10,'          |   |',13,10,'          O   |',13,10,'              |',13,10,'              |',13,10,'              |',13,10,'         =======','$'
         db 13,10,'          +---+',13,10,'          |   |',13,10,'          O   |',13,10,'          |   |',13,10,'              |',13,10,'              |',13,10,'         =======','$'
         db 13,10,'          +---+',13,10,'          |   |',13,10,'          O   |',13,10,'         /|   |',13,10,'              |',13,10,'              |',13,10,'         =======','$'
         db 13,10,'          +---+',13,10,'          |   |',13,10,'          O   |',13,10,'         /|\  |',13,10,'              |',13,10,'              |',13,10,'         =======','$'
         db 13,10,'          +---+',13,10,'          |   |',13,10,'          O   |',13,10,'         /|\  |',13,10,'         /    |',13,10,'              |',13,10,'         =======','$'
         db 13,10,'          +---+',13,10,'          |   |',13,10,'          O   |',13,10,'         /|\  |',13,10,'         / \  |',13,10,'              |',13,10,'         =======','$'


start:
    mov ax, @data
    mov ds, ax


new_game:
    call clear_screen   
        ; Show High Score
    mov dx, offset high_score_msg
    call print_string
    mov al, high_score
    add al, '0'
    mov ah, 0Eh
    int 10h


    ; Choose Difficulty
    mov dx, offset difficulty_prompt
    call print_string
    call get_char

    cmp al, 'E'
    je set_easy
    cmp al, 'e'
    je set_easy
    cmp al, 'H'
    je set_hard
    cmp al, 'h'
    je set_hard

set_medium:
    mov tries, 6
    jmp continue_game

set_easy:
    mov tries, 6
    jmp continue_game

set_hard:
    mov tries, 6

continue_game:

    ; Clear guessed letters
    mov cx, 26
    mov si, offset letters_guessed 

clear_letters:
    mov byte ptr [si], 0
    inc si
    loop clear_letters

    mov dx, offset banner
    call print_string

    call random_word
    call init_guessed
    mov score, 0
    mov si, 0
    mov di, 0
    mov bx, 0
    mov cx, 0


    
    
main_loop:
    call show_guessed
    call show_hint
    call show_guessed_letters
    call show_tries
    call show_score
    call draw_hangman

    mov dx, offset prompt
    call print_string

    call get_char
    mov input_char, al

    cmp al, 'a'
    jl skip_upper
    cmp al, 'z'
    jg skip_upper
    sub al, 20h   
    
    
skip_upper:

    mov bl, al
    sub bl, 'A'
    mov al, letters_guessed[bx]
    cmp al, 1
    je main_loop
    mov letters_guessed[bx], 1

    call check_guess
    call check_win
    cmp al, 1
    je you_win
    mov al, tries
    cmp al, 0
    je you_lose
    jmp main_loop
    
    
you_win:
    mov dx, offset win_msg
    call print_string  
        ; Check High Score
    mov al, score
    cmp al, high_score
    jbe skip_high_update
    mov high_score, al
    mov dx, offset new_high_msg
    call print_string
skip_high_update:

    jmp ask_play_again
    
    

you_lose:
    mov dx, offset lose_msg
    call print_string
       mov si, word_ptr
    mov cl, word_len

print_lost_word:
    lodsb           ; load letter from [si] into AL, and increment SI
    cmp al, 0
    je done_lost_print
    mov ah, 0Eh     ; teletype output
    int 10h
    mov al, ' '
    int 10h
    dec cl
    jnz print_lost_word

done_lost_print:


    ; Check High Score ??
    mov al, score
    cmp al, high_score
    jbe skip_high_update2
    mov high_score, al
    mov dx, offset new_high_msg
    call print_string
skip_high_update2:

    jmp ask_play_again

    
    
ask_play_again:
    mov dx, offset play_again_msg
    call print_string
    call get_char
    cmp al, 'Y'
    je new_game
    cmp al, 'y'
    je new_game
    jmp exit
    
    
exit:
    mov ah, 4Ch
    int 21h
    
    
print_string:
    mov ah, 09h
    int 21h
    ret
    
    
get_char:
    mov ah, 01h
    int 21h
    and al, 0DFh
    ret
    
    
show_hint:
    mov dx, offset hint_label
    call print_string
    mov dx, hint_ptr
    call print_string
    ret
    
    
show_score:
    mov dx, offset score_label
    call print_string
    mov al, score
    add al, '0'
    mov ah, 0Eh
    int 10h
    ret
    
    
show_guessed:
    mov dx, offset guessed_msg
    call print_string
    mov si, offset guessed     
    
    
print_loop1:
    mov al, [si]
    cmp al, 0
    je print_done1
    mov ah, 0Eh
    int 10h
    mov al, ' '
    int 10h
    inc si
    jmp print_loop1  
    
    
print_done1:
    ret

show_guessed_letters:
    mov dx, offset guessed_letters_msg
    call print_string
    mov cx, 26
    mov si, 0  
    
    
loop_letters:
    mov al, letters_guessed[si]
    cmp al, 1
    jne next_letter
    mov ax, si
    mov al, al
    add al, 'A'
    mov ah, 0Eh
    int 10h
    mov al, ' '
    int 10h 
    
    
next_letter:
    inc si
    loop loop_letters
    ret

show_tries:
    mov dx, offset tries_label
    call print_string
    mov al, tries
    add al, '0'
    mov ah, 0Eh
    int 10h
    ret

check_guess:
    mov si, word_ptr
    mov di, offset guessed
    mov cl, word_len
    mov bl, input_char
    xor dx, dx   
    
    
guess_loop:
    mov al, [si]
    cmp al, 0
    je guess_done
    cmp al, bl
    jne guess_next
    mov [di], bl
    mov dx, 1
    inc score
    
    
guess_next:
    inc si
    inc di
    dec cl
    jnz guess_loop
    
    
guess_done:
    cmp dx, 0
    jne no_decrement
    dec tries 
    
    
no_decrement:
    mov al, dl
    ret

check_win:
    mov si, offset guessed
    mov cl, word_len
    mov al, 1 
    
    
win_loop:
    cmp [si], '_'
    je not_win
    inc si
    dec cl
    jnz win_loop
    ret 
    
    
not_win:
    xor al, al
    ret

draw_hangman:
    mov al, 6
    sub al, tries
    mov bl, al
    mov si, offset drawings
    
    
find_drawing:
    cmp bl, 0
    je drawing_done 
    
    
skip_drawing:
    lodsb
    cmp al, '$'
    jne skip_drawing
    dec bl
    jmp find_drawing
    
    
drawing_done:
    mov dx, si
    call print_string
    ret

init_guessed:
    mov cl, word_len       ; use actual length of selected word
    mov si, offset guessed 
    
    
fill_loop:
    mov byte ptr [si], '_'
    inc si
    dec cl
    jnz fill_loop
    mov byte ptr [si], 0   ; null-terminate the guessed word
    ret


clear_screen:
    mov ax, 0600h
    mov bh, 3Fh     ; Background: Dark Cyan (3), Text: Bright White (15)
    mov cx, 0
    mov dx, 184Fh
    int 10h
    ret




random_word:
    mov ah, 2Ch         ; Get system time
    int 21h
    mov al, dl
    xor ah, ah
    mov bl, 10          ; 10 words total
    div bl              ; ah = remainder (0–9)

    cmp ah, 0
    je pick1
    cmp ah, 1
    je pick2
    cmp ah, 2
    je pick3
    cmp ah, 3
    je pick4
    cmp ah, 4
    je pick5
    cmp ah, 5
    je pick6
    cmp ah, 6
    je pick7
    cmp ah, 7
    je pick8
    cmp ah, 8
    je pick9
    jmp pick10

pick1:
    mov word_ptr, offset word1
    mov hint_ptr, offset hint1
    mov word_len, 5
    ret

pick2:
    mov word_ptr, offset word2
    mov hint_ptr, offset hint2
    mov word_len, 4
    ret

pick3:
    mov word_ptr, offset word3
    mov hint_ptr, offset hint3
    mov word_len, 6
    ret

pick4:
    mov word_ptr, offset word4
    mov hint_ptr, offset hint4
    mov word_len, 6
    ret

pick5:
    mov word_ptr, offset word5
    mov hint_ptr, offset hint5
    mov word_len, 6
    ret

pick6:
    mov word_ptr, offset word6
    mov hint_ptr, offset hint6
    mov word_len, 6
    ret

pick7:
    mov word_ptr, offset word7
    mov hint_ptr, offset hint7
    mov word_len, 6
    ret

pick8:
    mov word_ptr, offset word8
    mov hint_ptr, offset hint8
    mov word_len, 5
    ret

pick9:
    mov word_ptr, offset word9
    mov hint_ptr, offset hint9
    mov word_len, 6
    ret

pick10:
    mov word_ptr, offset word10
    mov hint_ptr, offset hint10
    mov word_len, 7
    ret



ret