
include macros.asm

.model small
;----------------------------------------------------
;-----------------SEGMENTO DE PILA-------------------
;----------------------------------------------------
.stack
;----------------------------------------------------
;-----------------SEGMENTO DE DATO------------------
;----------------------------------------------------
.data

;----------------------CADENAS A MOSTRAR-------------------------
universidad db 0ah,0dh,'UNIVERSIDAD DE SAN CARLOS DE GUATEMALA','$'
facultad db 0ah,0dh,'FACULTAD DE INGENIERIA','$'
carrera db 0ah,0dh,'CIENCIAS Y SISTEMAS','$'
curso db 0ah,0dh,'ARQUITECTURA DE COMPUTADORES Y ENSAMBLADORES','$'
nombre db 0ah,0dh,'NOMBRE: JULIAN ISAAC MALDONADO LOPEZ','$'
carnet db 0ah,0dh,'CARNET: 201806839','$'
seccion db 0ah,0dh,'A','$'

primOpcion db 0ah,0dh,'1) Iniciar juego','$'
secOpcion db 0ah,0dh,'2) Cargar juego','$'
tercOption db 0ah,0dh,'3) Salir','$'

ing db 0ah,0dh,'Ingrese el nombre del archivo:','$'

t db 'Turno','$'
n db 0ah,0dh,'Negras:','$'
b db 0ah,0dh,'Blancas:','$'

bRes db 0ah,0dh,'Ganan blancas!:','$'
nRes db 0ah,0dh,'Ganan negras!:','$'

espacio db '---','$'
dosPuntos db ':','$'

vacio db '  ','$'
menosVacio db '  ','$' 
masVacio db '    ','$'

num1 db 31h,'$'
num2 db 32h,'$'
num3 db 33h,'$'
num4 db 34h,'$'
num5 db 35h,'$'
num6 db 36h,'$'
num7 db 37h,'$'
num8 db 38h,'$'


salto db 0ah,0dh,'$'
negra db 'FN','$'
blanca db 'FB','$'

divisor dw 0000h

;-------------------REPORTE HTML--------------
abrirTitulo db 0ah,0dh,'<h1> ','$'
cerrarTitulo db 0ah,0dh,'</h1> ','$'
abrirTabla db 0ah,0dh,'<table width="400" height="400"> ','$'
cerrarTabla db 0ah,0dh,'</table>','$'
nFicha db 0ah,0dh,'<td><img src=fn.png></td>','$'
bFicha db 0ah,0dh,'<td><img src=fb.png></td>','$'
vFicha db 0ah,0dh,'<td><img src=fv.png ></td> ','$'
tFicha db 0ah,0dh,'<td><img src=ft.png ></td> ','$'
abrirFila db 0ah,0dh,'<tr>','$'
cerrarFila db 0ah,0dh,'</tr> ','$'
estiloTabla db '<style>',0ah,0dh,'table{',0ah,0dh,'background: url(tableroGo.png) no-repeat;',0ah,0dh,'background-size:100% 100%;',0ah,0dh,'}',0ah,0dh,'img {',0ah,0dh,'  width: 100%;',0ah,0dh,'  display: block;',0ah,0dh,'}',0ah,0dh,'</style> ','$'

;--------------------TABLERO -------------------
f1 db 000b,000b,000b,000b,000b,000b,000b,000b,'$'
f2 db 000b,000b,000b,000b,000b,000b,000b,000b,'$'
f3 db 000b,000b,000b,000b,000b,000b,000b,000b,'$'
f4 db 000b,000b,000b,000b,000b,000b,000b,000b,'$'
f5 db 000b,000b,000b,000b,000b,000b,000b,000b,'$'
f6 db 000b,000b,000b,000b,000b,000b,000b,000b,'$'
f7 db 000b,000b,000b,000b,000b,000b,000b,000b,'$'
f8 db 000b,000b,000b,000b,000b,000b,000b,000b,'$'

fBot db '  A    B    C    D    E    F    G    H','$'

f9 db 000b,000b,000b,000b,000b,000b,000b,000b,'$'
limpiar db 33h,33h,33h,33h,33h,33h,33h,33h,0dh

faux db 64 dup(8),'$'


;-------------------COMANDOS ESPECIALES-----------------
prim db 'PASS',0
sec db 'EXIT',0
ter db 'SAVE',0
cuar db 'SHOW',0
;-------------------ERRORES-----------------------------
error1 db 'Error al cargar el archivo','$'
error2 db 'Error al cerrar el archivo','$'
error3 db 'Error al leer el archivo','$'
error4 db 'Error al crear el archivo','$'
error5 db 'Error al escribir el archivo','$'
error6 db 'Comando invalido','$'
error7 db 'Suicidio detectado','$'

errorDebbug db 'Error','$'
;--------------------VARIABLES DINAMICAS----------------


comparar db 001b
actual db 1,'$'
banderaPass db 0
activo db 1,'$'
arreglo db 7 dup(0),0
cont dw 0
resFila db 0,'$'
resColumna db 0,'$'

bPuntos db 0
nPuntos db 0

bTotal  db "00",'$'
nTotal  db "00",'$'

ruta db 50 dup(0),0
handlerRuta dw ?
informacion db 71 dup('$'),'$'

reporteHtml db 3500 dup('$'),'$'

date  db "00/00/0000",0dh, 0ah,'$'
time db      "00:00:00", 0dh, 0ah, '$'





;----------------------------------------------------
;-----------------SEGMENTO DE CODIGO-----------------
;----------------------------------------------------
.code 
main proc


    ;LISTADO DE PENDIENTES:
        ;1. HACER MEJOR UN CONTADOR DE FICHAS GENERAL, PORQUE ESO DE AGREGAR A CADA TURNO NO SALE XD
            ;ADEMAS DE QUE CUANDO SE USE UN COMANDO ESPECIAL, SE QUEDE EN SU TURNO
        ;2. AGREGAR LA IMAGEN DE TRIANGULO A LOS ESPACIOS VACIOS

    Menu:


        print universidad
        print facultad
        print carrera
        print curso
        print nombre
        print carnet
        print seccion
        print salto
  
        
        print primOpcion
        print secOpcion
        print tercOption    


        print salto
        getChar
        cmp al,31h
        je Jugar
        cmp al,32h
        je Cargar
        cmp al,33h
        je Salir
        jmp Menu
 
    Jugar:
    print salto
    mov comparar,010b
    mov bPuntos,0
    mov nPuntos,0
    mov banderaPass,0
    jmp Inicio

        Inicio:
        setTablero
        cmp activo,1
        je Turno
        jmp Fin

                Turno:
                print t
                cmp actual,0
                je Blancas
                jmp Negras
                
          
                Blancas:
                print b
                jmp turnoBlancas

                   turnoBlancas:
                        getTexto arreglo
                        analizar arreglo,010b        
                        cmp cx,0
                        jne bMov
                        
                       
                        print error6
                        getChar
                        print salto
                        print t
                        print b


                        jmp turnoBlancas
                    bMov:
              
                        mov actual[0],1
                        mov comparar,010b
                        jmp Inicio
                   
                Negras:
                print n
                jmp turnoNegras
                
                    turnoNegras:
                        getTexto arreglo 
                        analizar arreglo,001b
                        cmp cx,0
                        jne nMov

             
                        print error6
                        getChar
                        print salto
                        print t
                        print n
       
        

                        jmp turnoNegras
                    nMov:
             
                         mov actual[0],0
                         mov comparar,001b
                         jmp Inicio  
                     
                
    Fin:
    jmp Menu



    Cargar:
    pushear 
    print salto
    print ing
    getTexto ruta
    abrir ruta,handlerRuta
    leer handlerRuta,informacion,SIZEOF informacion
    print informacion
    poppear
    functEntrada informacion
    getPuntaje
    getChar   
    jmp Menu

    

    Salir:
        mov ah,4ch
        xor al,al
        int 21h


main endp
end main