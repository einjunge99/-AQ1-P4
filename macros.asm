
;--------------------------MANEJO ARCHIVOS---------------------
abrir macro buffer,handler
local error,fin
mov ah,3dh
mov al,00h
lea dx,buffer
int 21h
jc error
mov handler,ax
jmp fin

error:
print error1
getChar
jmp Menu
fin:
endm 

cerrar macro handler 
local error, fin
mov ah, 3eh
mov bx,handler
int 21h
jc  error
jmp fin
error:
print error2
getChar
jmp Menu
fin:
endm

leer macro handler,buffer,numBytes
local error, fin
mov ah,3fh
mov bx,handler
mov cx,numBytes
lea dx,buffer
int 21h
jc error
jmp fin
error:
print error3
getChar
jmp Menu
fin:
endm

crear macro buffer,handler
LOCAL error,fin
mov ah,3ch
mov cx,00h
lea dx,buffer
int 21h
jc error
mov handler,ax
jmp fin

error:
print error4
fin:
endm

escribir macro handler,buffer,numBytes
LOCAL error,fin
mov ah,40h
mov bx,handler
mov cx ,numBytes
lea dx,buffer
int 21h
jc error
jmp fin
error:
print error5
fin:
endm

sobrantes macro buffer,numBytes
LOCAL ciclo1,ciclo2,fin
xor si,si
xor cx,cx
mov cx,numBytes
ciclo1:
cmp buffer[si],24h    
je ciclo2
inc si
loop ciclo1
jmp fin
ciclo2:
mov buffer[si],20h
inc si
loop ciclo2
fin:

endm





;-------------------------VISUALES TABLERO---------------------

print macro buffer
mov ax,@data
mov ds,ax
mov ah,09h
mov dx,offset buffer
int 21h
endm


functLimpiar macro fil,entrada
lea si,entrada
setEntrada entrada,fil
endm

setDato macro fil
LOCAL fin
    sub al,30h
    mov fil[di],al
    cmp al,01h
    je fin
    cmp al,02h
    je fin
    mov fil[di],000b
fin:    
endm

functEntrada macro entrada
push si
lea si,entrada
setEntrada entrada,f1
setEntrada entrada,f2
setEntrada entrada,f3
setEntrada entrada,f4
setEntrada entrada,f5
setEntrada entrada,f6
setEntrada entrada,f7
setEntrada entrada,f8
pop si
endm

setEntrada macro entrada,fil
LOCAL ciclo,error,fin

mov di,0
dec di

ciclo:
lodsb
inc di
cmp al,0dh
je fin
setDato fil
jmp ciclo


error:
print errorDebbug;
jmp fin

fin:
endm

setTablero macro
pushear
print num1
setFila f1
setAux
print num2
setFila f2
setAux
print num3
setFila f3
setAux
print num4
setFila f4
setAux
print num5
setFila f5
setAux
print num6
setFila f6
setAux
print num7
setFila f7
setAux
print num8
setFila f8
poppear
print fBot
print salto
endm

setAux macro
LOCAL columna
print menosVacio
mov cx, 7
columna:
print dosPuntos
print masVacio
loop columna
print dosPuntos
print salto
endm

setFila macro fil
LOCAL columna
print menosVacio
    push si
    mov cx, 8
    mov si,0
columna:
    setColumna fil[si],si
    inc si
    loop    columna
    pop si
    print salto
endm

setColumna macro col,pos
LOCAL columna,setNegra,setBlanca,setNada,setEspacio,ultimo,fin

columna:
cmp col,000b
je setNada
cmp col,001b
je setNegra
cmp col,010b
je setBlanca
jmp ultimo
setNegra:
 print negra
 jmp ultimo
setBlanca:
print blanca
jmp ultimo
setNada:
print vacio
jmp ultimo

ultimo:
cmp pos,7
je fin
jmp setEspacio
setEspacio:
print espacio
jmp fin
fin:
endm

limpiarConsola macro
LOCAL ciclo
mov dx,50h
ciclo:
    print salto
    loop ciclo
endm

;----------------------CAPTURA Y ANALISIS DE DATOS------------------

recorrerPuntaje macro fil
LOCAL ciclo,fin,negras,salto
mov si,0
mov cx,7
ciclo:
cmp fil[si],000b
je salto
cmp fil[si],001b
je negras
mov al,bPuntos
add al,1
mov bPuntos,al
jmp salto
negras:
mov al,nPuntos
add al,1
mov nPuntos,al
salto:  
inc si
loop ciclo
jmp fin
fin:
endm

getPuntaje macro
recorrerPuntaje f1
recorrerPuntaje f2
recorrerPuntaje f3
recorrerPuntaje f4
recorrerPuntaje f5
recorrerPuntaje f6
recorrerPuntaje f7
recorrerPuntaje f8
endm

getFecha macro buffer
    xor     ax, ax
    xor     bx, bx
    mov     ah, 2ah             
    int     21h

    mov     di,0
    mov     al,dl
    bcd buffer

    inc     di           
    mov     al, dh
    bcd buffer

    inc     di                
    mov buffer[di], 32h
    inc di  
    mov buffer[di], 30h 
    inc di 
    mov buffer[di], 32h
    inc di  
    mov buffer[di], 30h  


    endm

    getHora macro buffer
    xor     ax, ax
    xor     bx, bx
    mov     ah, 2ch
    int     21h

    mov     di,0
    mov     al, ch
    bcd buffer

    inc     di  
    mov     al, cl
    bcd buffer

    inc     di
    mov     al, dh
    bcd buffer


endm

bcd macro entrada     
    push dx
    xor dx,dx
    mov dl,al
    xor ax,ax
    mov bl,0ah
    mov al,dl
    div bl
    push ax
    add al,30h
    mov entrada[di], al        
    inc  di

    pop ax
    add ah,30h
    mov entrada[di], ah
    inc  di
    pop dx
endm


bcdTotal macro entrada,num     ; <---------BCD PARA PUNTAJE FINAL
    mov di,0
    xor ax,ax
    mov bl,0ah
    mov al,num
    div bl
    push ax
    add al,30h
    mov entrada[di], al        
    inc  di

    pop ax
    add ah,30h
    mov entrada[di], ah
endm



getChar macro
mov ah,01h
int 21h
endm

getTexto macro buffer
LOCAL concat,fin
xor si,si

concat:
getChar
cmp al,0dh
je fin
mov buffer[si],al
inc si
jmp concat
fin:
mov al,0
mov buffer[si],al
endm

newLine macro 
MOV dl, 10
MOV ah, 02h
INT 21h
MOV dl, 13
MOV ah, 02h
INT 21h
endm



recorrer macro texto,buffer        ; <----------------INICIO HTML DINAMICO
LOCAL ciclo,error,fin
push di
xor di,di
mov di,0
dec di
dec si
ciclo:
inc si
inc di
cmp texto[di],ah
je fin
mov al,texto[di]
mov buffer[si],al
jmp ciclo

fin:
pop di
dec si
endm

setHtml macro buffer,tipo
LOCAL fin,setNegra,setBlanca,setVacio
    mov al,[di]
    cmp al,001b
    je setNegra
    cmp al,010b
    je setBlanca
    mov al,tipo
    cmp al,0
    je setVacio
    recorrer tFicha,buffer
    jmp fin

setNegra:
recorrer nFicha,buffer
jmp fin

setBlanca:
recorrer bFicha,buffer
jmp fin

setVacio:
recorrer vFicha,buffer

fin: 
endm

functHtml macro fil,entrada,tipo
LOCAL ciclo,error,fin
recorrer abrirFila,entrada
xor di,di
lea di,fil
dec di
ciclo:
inc si
inc di
cmp [di],ah
je fin
setHtml entrada,tipo
jmp ciclo


error:
print errorDebbug
jmp fin

fin:
recorrer vFicha,entrada         ;  <-------------a esta onda tengo que enviarle una validacion para ver si es vacio o triangulo
recorrer cerrarFila,entrada
endm

html macro buffer,tipo
getFecha date
getHora time
xor ah,ah
mov ah,24h
mov si,0

recorrer abrirTitulo,buffer
recorrer date,buffer
recorrer time,buffer
recorrer cerrarTitulo,buffer
recorrer estiloTabla,buffer
recorrer abrirTabla,buffer
functHtml f1,buffer,tipo
functHtml f2,buffer,tipo
functHtml f3,buffer,tipo
functHtml f4,buffer,tipo
functHtml f5,buffer,tipo
functHtml f6,buffer,tipo
functHtml f7,buffer,tipo
functHtml f8,buffer,tipo
functHtml f9,buffer,0
recorrer cerrarTabla,buffer
endm                                        ; <-------------FIN HMTL DINAMICO




funcSalir macro
functLimpiar f1,limpiar
functLimpiar f2,limpiar
functLimpiar f3,limpiar
functLimpiar f4,limpiar
functLimpiar f5,limpiar
functLimpiar f6,limpiar
functLimpiar f7,limpiar
functLimpiar f8,limpiar
jmp Menu
endm

functMostrar macro tipo
print ing
getTexto ruta
crear ruta,handlerRuta
html reporteHtml,tipo
sobrantes reporteHtml,3501
escribir handlerRuta,reporteHtml,SIZEOF reporteHtml
cerrar handlerRuta
endm

functGuardar macro
pushear
print ing
getTexto ruta
crear ruta,handlerRuta
functLlenar informacion
escribir handlerRuta,informacion,SIZEOF informacion
cerrar handlerRuta
poppear
endm

functLimpiar macro fil,entrada
lea si,entrada
setEntrada entrada,fil
endm

setDatoBuffer macro buffer
LOCAL fin,setNegra,setBlanca
    mov al,[di]
    cmp al,001b
    je setNegra
    cmp al,010b
    je setBlanca
    mov buffer[si],33h
    jmp fin

setNegra:
mov buffer[si],31h   
jmp fin

setBlanca:
mov buffer[si],32h   
jmp fin

fin:    
endm

setLlenar macro entrada,fil
LOCAL ciclo,error,fin
xor di,di
lea di,fil
dec di
ciclo:
inc si
inc di
cmp [di],ah
je fin
setDatoBuffer entrada
jmp ciclo


error:
print errorDebbug
jmp fin

fin:
mov entrada[si],0dh 
endm

functLlenar macro entrada
xor ah,ah
mov ah,24h
mov si,0
dec si
setLlenar entrada,f1
setLlenar entrada,f2
setLlenar entrada,f3
setLlenar entrada,f4
setLlenar entrada,f5
setLlenar entrada,f6
setLlenar entrada,f7
setLlenar entrada,f8
pop si
endm


suicidio macro y,x ;   <-------------TENGO QUE MANDARLE LA FICHA DEL EQUIPO CONTRARIO
LOCAL setF1,setF2,setF3,setF4,setF5,setF6,setF7,setF1,setF1,setValor,inicio,case1,esquina1,esquina2,esquina3,esquina4,case2,case3,case4F2,case5F2,case4F3,case5F3,case4F4,case5F4,case4F5,case5F5,case4F6,case5F6,case4F7,case5F7,case6,otros,fin,error,correcto
xor ax,ax
xor bx,bx

mov bl,comparar




xor ax,ax
inicio:
mov al,x
sub al,1
mov x,al
mov ah,y
sub ah,31h
mov y,ah


cmp al,0
je case1
cmp al,7
je case2
jmp otros

case1:
cmp ah,0
je esquina1
cmp ah,7
je esquina2
jmp otros

case2:
cmp ah,0
je esquina3
cmp ah,7
je esquina4
jmp otros



esquina1:
cmp f1[1],bl
jne correcto
cmp f2[0],bl
jne correcto
jmp error
esquina2:
cmp f8[1],bl
jne correcto
cmp f7[0],bl
jne correcto
jmp error
esquina3:
cmp f1[6],bl
jne correcto
cmp f2[7],bl
jne correcto
jmp error
esquina4:
cmp f7[7],bl
jne correcto
cmp f8[6],bl
jne correcto
jmp error


otros:
;print nombre
cmp ah,0
je case3
cmp ah,1
je setF2
cmp ah,2
je setF3
cmp ah,3
je setF4
cmp ah,4
je setF5
cmp ah,5
je setF6
cmp ah,6
je setF7
cmp ah,7
je case6
jmp fin


setF2:
cmp al,0
je case4F2
cmp al,7
je case5F2
setOtros f1,f2,f3,x,y
jmp fin

setF3:
cmp al,0
je case4F3
cmp al,7
je case5F3
setOtros f2,f3,f4,x,y
jmp fin

setF4:
cmp al,0
je case4F4
cmp al,7
je case5F4
setOtros f3,f4,f5,x,y
jmp fin

setF5:
cmp al,0
je case4F5
cmp al,7
je case5F5
setOtros f4,f5,f6,x,y
jmp fin

setF6:
cmp al,0
je case4F6
cmp al,7
je case5F6
setOtros f5,f6,f7,x,y
jmp fin

setF7:
cmp al,0
je case4F7
cmp al,7
je case5F7
setOtros f6,f7,f8,x,y
jmp fin


case3:
xor ax,ax
xor di,di
mov al,x
sub al,1
mov di,ax

cmp f1[di],bl
jne correcto


mov al,x
add al,1
xor di,di
mov di,ax

cmp f1[di],bl
jne correcto


mov al,y
add al,1
mov di,ax


cmp f2[di],bl
jne correcto
jmp error


case6:
xor ax,ax
xor di,di
mov al,x
sub al,1
mov di,ax

cmp f8[di],bl
jne correcto


mov al,x
add al,1
xor di,di
mov di,ax

cmp f8[di],bl
jne correcto


mov al,y
add al,1
mov di,ax


cmp f7[di],bl
jne correcto
jmp error




case4F2:
setOtrosIzquierda f1,f2,f3,x,y
jmp fin
case5F2:
setOtrosDerecha f1,f2,f3,x,y
jmp fin
case4F3:
setOtrosIzquierda f2,f3,f4,x,y
jmp fin
case5F3:
setOtrosDerecha f2,f3,f4,x,y
jmp fin
case4F4:
setOtrosIzquierda f3,f4,f5,x,y
jmp fin
case5F4:
setOtrosDerecha f3,f4,f5,x,y
jmp fin
case4F5:
setOtrosIzquierda f4,f5,f6,x,y
jmp fin
case5F5:
setOtrosDerecha f4,f5,f6,x,y
jmp fin
case4F6:
setOtrosIzquierda f5,f6,f7,x,y
jmp fin
case5F6:
setOtrosDerecha f5,f6,f7,x,y
jmp fin
case4F7:
setOtrosIzquierda f6,f7,f8,x,y
jmp fin
case5F7:
setOtrosIzquierda f6,f7,f8,x,y
jmp fin




error:
mov cx,0
jmp fin



correcto:
mov cx,5

fin:
endm

setOtros macro arriba,fila,abajo,xPos,yPos
LOCAL fin,error,correcto
xor ax,ax
xor di,di
mov al,xPos
sub al,1
mov di,ax

cmp fila[di],bl
jne correcto


mov al,xPos
add al,1
xor di,di
mov di,ax

cmp fila[di],bl
jne correcto


mov al,yPos
add al,1
mov di,ax


cmp arriba[di],bl
jne correcto

cmp abajo[di],bl
jne correcto

error:
mov cx,0
jmp fin

correcto:
mov cx,5

fin:
endm

setOtrosIzquierda macro arriba,fila,abajo,xPos,yPos
LOCAL fin,error,correcto
xor ax,ax
xor di,di

mov al,xPos
add al,1
xor di,di
mov di,ax

cmp fila[di],bl
jne correcto


mov al,yPos
add al,1
mov di,ax


cmp arriba[di],bl
jne correcto

cmp abajo[di],bl
jne correcto

error:
mov cx,0
jmp fin

correcto:
mov cx,5

fin:
endm


;---------------
setOtrosDerecha macro arriba,fila,abajo,xPos,yPos
LOCAL fin,error,correcto
xor ax,ax
xor di,di
mov al,xPos
sub al,1
mov di,ax

cmp fila[di],bl
jne correcto


mov al,yPos
add al,1
mov di,ax


cmp arriba[di],bl
jne correcto

cmp abajo[di],bl
jne correcto

error:
mov cx,0
jmp fin

correcto:
mov cx,5

fin:
endm

;----------




functMover macro pos, valor
LOCAL muerte,ciclo,ocupado,case1,case2,case3,case4,case5,case6,case7,case8,fin,nel,simon,error,setBlancas,setNegras

mov al,pos[0]
sub al,40h
mov resColumna,al


mov al,pos[1]
mov resFila,al

xor ah,ah
mov al,resColumna
mov si,0
ciclo:
    inc si
    cmp si,ax
    jne ciclo 
    mov cont,si

case1:
cmp resFila,31h
jne case2
push si
mov si,cont
dec si
cmp f1[si],000b
jne error
suicidio resFila,resColumna
cmp cx,0                ;  <-----COMPROBACION DE NO SUICIDIO
je muerte
mov f1[si],valor
pop si
jmp fin

case2:
cmp resFila,32h
jne case3 
push si
mov si,cont
dec si
cmp f2[si],000b
jne error
suicidio resFila,resColumna
cmp cx,0                ;  <-----COMPROBACION DE NO SUICIDIO
je muerte
mov f2[si],valor
pop si
jmp fin

case3:
cmp resFila,33h
jne case4 
push si
mov si,cont
dec si
cmp f3[si],000b
jne error
suicidio resFila,resColumna
cmp cx,0                ;  <-----COMPROBACION DE NO SUICIDIO
je muerte
mov f3[si],valor
pop si
jmp fin

case4:
cmp resFila,34h
jne case5 
push si
mov si,cont
dec si
cmp f4[si],000b
jne error
suicidio resFila,resColumna
cmp cx,0                ;  <-----COMPROBACION DE NO SUICIDIO
je muerte
mov f4[si],valor
pop si
jmp fin

case5:
cmp resFila,35h
jne case6 
push si
mov si,cont
dec si
cmp f5[si],000b
jne error
suicidio resFila,resColumna
cmp cx,0                ;  <-----COMPROBACION DE NO SUICIDIO
je muerte
mov f5[si],valor
pop si
jmp fin

case6:
cmp resFila,36h
jne case7
push si
mov si,cont
dec si
cmp f6[si],000b
jne error
suicidio resFila,resColumna
cmp cx,0                ;  <-----COMPROBACION DE NO SUICIDIO
je muerte
mov f6[si],valor
pop si
jmp fin

case7:
cmp resFila,37h
jne case8 
push si
mov si,cont
dec si
cmp f7[si],000b
jne error
suicidio resFila,resColumna
cmp cx,0                ;  <-----COMPROBACION DE NO SUICIDIO
je muerte
mov f7[si],valor
pop si
jmp fin

case8:
cmp resFila,38h
jne fin 
push si
mov si,cont
dec si
cmp f8[si],000b
jne error
suicidio resFila,resColumna
cmp cx,0                ;  <-----COMPROBACION DE NO SUICIDIO
je muerte
mov f8[si],valor
pop si
jmp fin

setBlancas:
mov faux[si],100b
ret

setNegras:
mov faux[si],000b
ret

muerte:
print error7
print salto
jmp fin

error:
mov cx,0

fin:
;print faux[0]
endm



analizar macro entrada, valor
LOCAL doblePass,case1,case2,case3,case4,case5,error,fin,restaPass,nPass,contPass,finEspecial

case1:
comandos prim,entrada,1
cmp cx,1
jne case2
mov al,banderaPass
add al,1
mov banderaPass,al
cmp al,2
je doblePass
jmp fin


case2:
mov banderaPass,0
comandos sec,entrada,2
cmp cx,2
jne case3
funcSalir
jmp fin
case3:
comandos ter,entrada,3
cmp cx,3
jne case4
functGuardar
jmp finEspecial
case4:
comandos cuar,entrada,4
cmp cx,4
jne case5
functMostrar 0
jmp finEspecial

case5:
posicion entrada,5
cmp cx,5
jne fin
functMover entrada,valor
jmp fin


finEspecial:
print salto
print t
cmp actual,0
je Blancas
jmp Negras


doblePass:
getPuntaje
bcdTotal bTotal,bPuntos
bcdTotal nTotal,nPuntos

mov al,bPuntos
mov ah,nPuntos
cmp al,ah
jl nPass
print bRes
print salto
contPass:

print bTotal
print vacio
print nTotal
print salto



functMostrar 1           ;   <-----------------------AQUIAKSJFHASDKF
funcSalir
jmp Menu

nPass:
print nRes
jmp contPass


fin:
endm

comandos macro comando, evaluar, num
LOCAL ciclo,error,fin
lea si,comando
lea di,evaluar
dec di

ciclo:
inc di                             
lodsb                       
                       
cmp [di], al            
jne error
cmp al, 0                       
jne ciclo
mov cx,num
jmp fin
error:
mov cx,0
fin:
endm


;-----------------------------------------
posicion macro evaluar,num
LOCAL letra,numero,test1,test2,correcto,error,fin
lea si,evaluar

letra:
lodsb  
cmp al, 41h               ;----->A, si es menor, no es letra      
jl error                  ;--------------Rango permitido
cmp al, 48h               ;----->H, si es menor, es letra
jle test1
jmp error

test1:                    ;-----Verifica si el siguiente caracter no es nulo,
lodsb                     ;-----en caso que no pasa al estado numero
cmp al, 0                       
jne numero
jmp fin

numero:
cmp al, 31h              ;----->1, 
jl error                 ;--------------Rango permitido
cmp al, 38h              ;----->8,  
jle test2             
jmp error

test2:                    ;-----Verifica si el siguiente caracter no es nulo,
lodsb                     ;-----en caso que si, la cadena es correcta
cmp al, 0                       
je correcto
jmp error

correcto:
mov cx,num
jmp fin

error:
mov cx,0
jmp fin
fin:
endm



;------------------------SALVAR REGISTROS E INDICES--------------
pushear macro
    push ax;
    push bx
    push cx
    push dx
    push si
    push di
endm

poppear macro
    pop ax;
    pop bx
    pop cx
    pop dx
    pop si
    pop di
endm