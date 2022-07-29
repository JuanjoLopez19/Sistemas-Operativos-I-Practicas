#Funciones para sacar valores del elemento

#Funcion SimboloQuimico: permite obtener las caracteristicas del metal cuyo simbolo quimico ha sido pasado como argumento
function SimboloQuimico 
{
        Flag="0" #Variable Bandera que nos permite ver si la busqueda del metal ha tenido exito
        echo "Ha elegido mostrar las caracteristicas a partir del nombre" #presentacion de la funcion
        sleep 1
        #bucle while que recorre el archivo de texto que se le pasa (done<metales.txt)
        #se utiliza read -r (opcion -r para que no se altere el funcionamiento con los retornos de carro) para que el bucle while funcione como 
        #un fscanf de C; Las variables despues del read son en las que se van a almacenar el valor de la linea que se lee, como estan separados 
        #por espacios en blanco que es el delimitador por defecto no hace falta cambiar nada(si fuese otro se cambiaria el valor de IFS por el 
        #que sea), asignando el valor de cada columna y comparando el valor de sq(en la que se almacena el simbolo quimico de la linea que se 
        #esta leyendo) con el del argumento, hasta que sea igual, en ese caso se imprime por pantalla toda la linea y se levanta el flag si no al 
        #acabar de leerse el fichero se mostrara el mensaje de error de que no se ha encontrado ningun valor igual en el fichero
        while read -r sq nombre nAtom res T mAtom ; 
        do 
                if(test "$sq" = "$1") #comprobacion de que es el mismo simbolo quimico que de la linea que se esta leyendo
                then
                        echo " Simbolo quimico: $sq "
                        echo " Nombre: $nombre "
                        echo " Numero Atomico: $nAtom " #presentacion de los datos
                        echo " Resistividad: $res "
                        echo " Temperatura de fusion: $T"
                        echo " Masa Atomica: $mAtom "
                        Flag="1" # se levanta la bandera significando que la busqueda ha tenido exito
                fi
                
        done < /home/p1777031/PE1/metales.txt
        #comprobacion con la opcion -ne (not equal), es decir si no se ha encontrado el elemento se ejecutan las sentencias 
        #del if
        if (test "$Flag" -ne 1 )
                then
                echo "El simbolo quimico $1 no pertenece a ningun elemento del archivo de texto"
        fi              
}


#funcion Nombre: permite obtener las caracteristicas del metal cuyo Nombre se le pasa como argumento(mismo funcionamiento a SimboloQuimico)

function Nombre
{
  Flag="0"
  echo "Ha elegido mostrar las caracteristicas a partir del nombre"
  sleep 1
  while read -r sq nombre nAtom res T mAtom ;
        do
        #Comprobacion de si esa linea tiene el mismo nombre de metal que el argumento que se le ha pasado a la funcion
                if(test "$nombre" = "$1") 
                then
                        echo " Simbolo quimico: $sq "
                        echo " Nombre: $nombre "
                        echo " Numero Atomico: $nAtom "
                        echo " Resistividad: $res "
                        echo " Temperatura de fusion: $T "
                        echo " Masa Atomica: $mAtom "
                        Flag="1"
                fi
        
 done </home/p1777031/PE1/metales.txt
                
        if test "$Flag" -ne 1
                then
                echo "El nombre $1 no pertenece a ningun elemento del archivo de texto"
        fi
}


#funcion Temperatura: permite obtener las caracteristicas del metal cuya Tªfusion se le pasa como argumento(mismo funcionamiento a 
#SimboloQuimico)
function Temperatura
{
  Flag="0"
  entero=${1%.*} #Coge el valor proporcionado desde el principio hasta el punto y resto lo descarta.
  decimal=${1#*.} #Coge el valor proporcionado desde el final hasta el punto y el resto lo descarta.

  echo "Ha elegido mostrar las caracteristicas a partir de la temperatura de fusion"
  sleep 1
  while read -r sq nombre nAtom res T mAtom
  do
  	#A la función temperatura se le pueden pasar numeros con parte decimal y la bash de encina no los lee correctamente, por eso es 
	#necesario separar el numero proporcionado en parte entera y parte decimal.
        I=${T%.*} 
        D=${T#*.} 
 
 	#Se comprueba que cada uno de los valores coincidan con alguno del del fichero.
        if(test "$entero" = "$I")
        then
                if(test "$decimal" = "$D")
                then
                        echo " Simbolo quimico: $sq "
                        echo " Nombre: $nombre "
                        echo " Numero Atomico: $nAtom "
                        echo " Resistividad: $res "
                        echo " Temperatura de fusion: $T "
                        echo " Masa Atomica: $mAtom "
                        Flag="1"
                fi
        fi
 
 done < /home/p1777031/PE1/metales.txt 
                
        if test "$Flag" -ne 1
                then
                echo "La temperatura de fusion $1 no pertenece a ningun elemento del archivo de texto"
        fi
}


#funcion nAtom: permite obtener las caracteristicas del metal cuyo nº Atomico se le pasa como argumento(mismo funcionamiento a SimboloQuimico)
function nAtom
{
  Flag="0"
  echo "Ha elegido mostrar las caracteristicas a partir del Numero Atomico"
  sleep 1
  while read -r sq nombre nAtom res T mAtom ;
        do
                if(test "$nAtom" = "$1") #comprobacion de la igualdad de con el argumento que se le ha pasado
                then
                        echo " Simbolo quimico: $sq "
                        echo " Nombre: $nombre "
                        echo " Numero Atomico: $nAtom "
                        echo " Resistividad: $res "
                        echo " Temperatura de fusion: $T "
                        echo " Masa Atomica: $mAtom "
                        Flag="1"
                fi
        
 done < metales.txt
                
        if test "$Flag" -ne 1
                then
                echo "No hay ningun elemento en el archivo de texto con un numero atomico de $1"
        fi
}


#funcion mAtom: permite obtener las caracteristicas del metal cuya masa atomica se le pasa como argumento(mismo funcionamiento a SimboloQuimico)
#funcion anterior
function mAtom
{
  Flag="0"
  #Comportamiento análogo a Temperatura con parte entera y parte decimal
  entero=${1%.*} 
  decimal=${1#*.}
  echo "Ha elegido mostrar las caracteristicas a partir de la masa atomica"
  sleep 1
  while read -r sq nombre nAtom res T mAtom 
  do
	I=${mAtom%.*}
	D=${mAtom#*.}
	
	if(test "$entero" = "$I")
	then
		if(test "$decimal" = "$D")
		then
			echo " Simbolo quimico: $sq "
                        echo " Nombre: $nombre "
                        echo " Numero Atomico: $nAtom "
                        echo " Resistividad: $res "
                        echo " Temperatura de fusion: $T "
                        echo " Masa Atomica: $mAtom "
                        Flag="1"	
        	fi
	fi
 done < /home/p1777031/PE1/metales.txt
 
        if (test "$Flag" -ne 1)
        	then
        		echo "No hay ningun elemento en el archivo de texto con una masa atomica de $1"
        fi

}

#funcion mAtom_nAtom: permite obtener las caracteristicas del metal cuyo nº atomico y masa atomica se le pasa como argumentos 
#(mismo funcionamiento a SimboloQuimico)
function mAtom_nAtom
{
  Flag="0"
  #Comportamiento análogo a Temperatura con parte entera y parte decimal
  entero=${1%.*}
  decimal=${1#*.}
  echo "Ha elegido mostrar las caracteristicas a partir de la masa atomica y el numero atomico"
  sleep 1
  while read -r sq nombre nAtom res T mAtom ;
        do
		I=${mAtom%.*}
        	D=${mAtom#*.}
				
                if( test "$nAtom" = "$2") #comprobacion de la igualdad de con los argumentos que se le han pasado
                then
			if(test "$entero" = "$I")
			then
				if(test "$decimal" = "$D")
				then
                        		echo " Simbolo quimico: $sq "
                        		echo " Nombre: $nombre "
                        		echo " Numero Atomico: $nAtom "
                        		echo " Resistividad: $res "
                        		echo " Temperatura de fusion: $T "
                        		echo " Masa Atomica: $mAtom "
                        		Flag="1"
				fi
                	fi
		fi        
 done < /home/p1777031/PE1/metales.txt 
                
        if test "$Flag" -ne 1
                then
                echo "No hay ningun elemento con masa atomica $1 y numero atomico $2 en el archivo de texto"
        fi
}


#funcion mAtom_T: permite obtener las caracteristicas del metal cuya Tª de fusion y masa atomica se le pasa como argumentos 
#(mismo funcionamiento a SimboloQuimico)
function mAtom_T
{
  Flag="0"
  #Comportamiento análogo a Temperatura con parte entera y parte decimal, pero en este caso al tratase de dos numeros se necesitan el doble de 
  #varibles y el doble de comprobaciones.
  e1=${1%.*}
  d1=${1#*.}
  e2=${2%.*}
  d2=${2#*.}

  echo "Ha elegido mostrar las caracteristicas a partir de la masa atomica y la temperatura de fusion"
  sleep 1
  while read -r sq nombre nAtom res T mAtom ;
        do
		I1=${mAtom%.*}
		D1=${mAtom#*.}
                
		I2=${T%.*}
		D2=${T#*.}
                
                if(test "$e2" = "$I2")
		then
                	if( test "$d2" = "$D2") #comprobacion de la igualdad de con los argumentos que se le han pasado
                	then
                        	if(test "$e1" = "$I1") 
                        	then
                                	if(test "$d1" = "$D1")
                                	then
                                        	echo " Simbolo quimico: $sq "
                                        	echo " Nombre: $nombre "
                                        	echo " Numero Atomico: $nAtom "
                                        	echo " Resistividad: $res "
                                        	echo " Temperatura de fusion: $T "
                                        	echo " Masa Atomica: $mAtom "
                                        	Flag="1"
                                	fi
                        	fi
                	fi
		fi
        
 done < /home/p1777031/PE1/metales.txt 
                
        if test "$Flag" -ne 1
                then
                echo "No hay ningun elemento con masa atomica $1 y 
temperatura de fusion $2 en el archivo de texto"
        fi
}


#funcion nAtom_T: permite obtener las caracteristicas del metal cuyo nº atomico y Tª de fusion se le pasa como argumentos 
#(mismo funcionamiento a SimboloQuimico)
function nAtom_T
{
  Flag="0"
  #Comportamiento análogo a Temperatura con parte entera y parte decimal
  e=${2%.*}
  d=${2#*.}
  echo "Ha elegido mostrar las caracteristicas a partir del numero atomico y la temperatura de fusion"
  sleep 1
  while read -r sq nombre nAtom res T mAtom ;
        do
		I=${T%.*}
                D=${T#*.}
                if(test "$nAtom" = "$1") #comprobacion de la igualdad de con los arguments que se le han pasado
                then
			if( test "$e" = "$I")
			then
				if(test "$d" = "$D")
				then
                        		echo " Simbolo quimico: $sq "
                        		echo " Nombre: $nombre "
                        		echo " Numero Atomico: $nAtom "
                        		echo " Resistividad: $res "
                        		echo " Temperatura de fusion: $T "
                        		echo " Masa Atomica: $mAtom "
                        		Flag="1"
				fi
                	fi
		fi
        
 done < /home/p1777031/PE1/metales.txt
                
        if test "$Flag" -ne 1
                then
                echo "No hay ningun elemento con numero atomico $1 y temperatura de fusion $2 en el archivo de texto"
        fi
}

#Funciones para el calculo de las longitudes, las resistencias y las secciones

#funcion resistencia: calcula la resistencia electrica del metal que se le pasa como argumento, a partir de la seccion y la longitud 
#introducidos como argumentos
function resistencia
{ 
  Flag="0" #Variable bandera para la busqueda de la resistividad
  VAR="0.0" #Variable auxiliar para las comparaciones posteriores
  echo "Ha elegido calcular la resistencia electrica del metal a partir de su resististividad, la longitud y la seccion del mismo"
  echo ""
  sleep 3
  while read -r sq nombre nAtom res T mAtom ;
        do
                if(test "$sq" = "$1") # se busca la linea que contenga el simbolo quimico al igual que en la funcion SimboloQuimico
                then
                        Resistividad="$res" #Se asigna la resistividad a una variable auxiliar para ser utilizada luego en los calculos
                        Flag="1" #Bandera para comprobar la correcta busqueda del metal
                fi
        
 done < /home/p1777031/PE1/metales.txt
                
        if test "$Flag" -ne 1 #comprobacion de la variable bandera
                then
                echo "El nombre del elemento no coincide con ninguno del archivo"
        else
        	echo "Bien, el metal existe en el fichero se va a hacer una comprobacion de errores"
        	
        	echo ""
        	      
        	sleep 3
        	#comprobaciones de los argumentos son valores logico para el calculo de las operaciones
        	#se utiliza el bc(bash calculator) para las comparaciones porque esta version de la shell(bash) no interpreta correctamente los 
        	#decimales asique es mejor usar el bc que si que los permite sin mayor problema, el canal de errores se asigna al fichero nulo 
        	#porque cuando la expresion es falsa no devuelve ningun valor lo que hace que se de un mensaje de error(si la shell estuviera 
        	#actualizada se podria haber hecho con un if-else pero en este caso esa sentencia da error y no funciona por lo que hemos optado 
        	#por hacerlo de esta forma que funciona perfectamente
        	#si la longitud es menor o igual que cero se ejecuta el if
        	if(test "$(echo "if  ($2<=$VAR)" 1 | bc)" -eq 1) 2>/dev/null #si la longitud es menor o igual que cero se ejecuta el if
        	then
        		echo "No has introducido una longitud valida"
        		echo "No se puede continuar el calculo"
        		
        		sleep 3
        		clear
        		
        	elif(test "$(echo "if  ($3<=$VAR)" 1 | bc)" -eq 1) 2>/dev/null #si la seccion es menor o igual que cero se ejecuta el if
        	then 
        		echo "No has introducido una seccion valida"
        		echo "No se puede continuar el calculo"
        		
        		sleep 3
        		clear
        		
        	else
        		echo "Perfecto, todos los argumentos estan bien, se puede proceder al calculo de la resistencia electrica"
			sleep 3
			clear
			
			
			echo "Los valores para el metal $1 son: "
			echo "Resistividad(ohmio*mm^2/m): $Resistividad" #presentacion de los datos introducidos y buscados
			echo "Longitud(m): $2"
			echo "Seccion(mm^2):$3"
			
			sleep 2
			echo " "
			
			#calculo de la resistencia otra vez a traves de bc, para asignar valor a una variable sigue la sintaxis que se presenta
			#scale sirve para mostrar un numero de decimales, y para que esa operacion sea relizada por bc es con | bc
			resistencia=$(echo "scale=3; (($Resistividad)*$2)/$3" | bc)
			
			
			echo "La formula para calcular la resistencia electrica es: (resistividad*longitud)/seccion"
			
			echo " "
			sleep 3
			
			echo "Por lo que la resistencia electrica con los parametros anteriores es: $resistencia ohmios" 
			#presentacion de la resistencia calculada
			sleep 5
        	fi 		
        fi
}

#funcion seccion: calcula la seccion del metal que se le pasa como argumento, a partir de la resistencia electrica y la longitud 
#introducidos como argumentos(funcina igual que resistencia)
function seccion 
{
  Flag="0"
  VAR="0.0"
  echo "Ha elegido calcular la seccion del metal a partir de su resistividad, la resistencia electrica y la longitud del mismo"
  echo ""
  sleep 3
  while read -r sq nombre nAtom res T mAtom ;
        do
                if(test "$sq" = "$1")
                then
                        Resistividad="$res" #obtencion de la resistividad del metal
                        Flag="1"
                fi
        
 done < /home/p1777031/PE1/metales.txt
                
        if test "$Flag" -ne 1
                then
                echo "El nombre del elemento no coincide con ninguno del archivo"
        else
        	echo "Bien, el metal existe en el fichero se va a hacer una comprobacion de errores"
        	
        	echo ""
        	      
        	sleep 3
        	#comprobacion de que los argumentos son mayores que 0
		if(test "$(echo "if  ($2<=$VAR)" 1 | bc)" -eq 1) 2>/dev/null        	
        	then
        		echo "No has introducido una longitud valida"
        		echo "No se puede continuar el calculo"
        		
        		sleep 3
        		clear

        	elif(test "$(echo "if  ($3<=$VAR)" 1 | bc)" -eq 1) 2>/dev/null	
        	then 
        		echo "No has introducido una resistencia valida"
        		echo "No se puede continuar el calculo"
        		
        		sleep 3
        		clear
        		
        	else
        		echo "Perfecto, todos los argumentos estan bien, se puede proceder al calculo de la seccion"
			sleep 3
			clear
			
			echo "Los valores para el metal $1 son: "
			echo "Resistividad (ohmio*mm^2/m): $Resistividad"
			echo "longitud(m): $2"
			echo "Resistencia electrica (Ohmio):$3"
			sleep 2
			
			echo " "
			
			#calculo de la seccion 
			seccion=$(echo "scale=3; (($Resistividad)*$2)/$3" | bc)
			
			
			echo "La formula para calcular la seccion es: (resistividad*longitud)/resistencia electrica"
			echo " "
			sleep 3
			echo "Por lo que la seccion con los parametros anteriores es: $seccion milimetros cuadrados"
			sleep 5
			#presentacion de la seccion calculada
        	fi 		
        fi
}

#funcion longitud: calcula la longitud del metal que se le pasa como argumento, a partir de la seccion y la resistencia electrica 
#introducidos como argumentos (funcina igual que resistencia)
function longitud 
{
  Flag="0"
  VAR="0.0"
  echo "Ha elegido calcular la longitud del metal a partir de su resististividad, la resistencia electrica y la seccion del mismo"
  echo ""
  sleep 3
  while read -r sq nombre nAtom res T mAtom ;
        do
                if(test "$sq" = "$1")
                then
                        Resistividad="$res" #obtencion de la resistividad del metal
                        Flag="1"
                fi
        
 done < /home/p1777031/PE1/metales.txt
                
        if test "$Flag" -ne 1
                then
                echo "El nombre del elemento no coincide con ninguno del archivo"
        else
        	echo "Bien, el metal existe en el fichero se va a hacer una comprobacion de errores"
        	
        	echo ""
        	      
        	sleep 3
        	#comprobacion de las argumentos, si son erroneos se finaliza el programa
		if(test "$(echo "if  ($2<=$VAR)" 1 | bc)" -eq 1) 2>/dev/null        	
        	then
        		echo "No has introducido una resistencia electrica valida"
        		echo "No se puede continuar el calculo"
        		
        		sleep 3
        		clear
        	
		elif(test "$(echo "if  ($3<=$VAR)" 1 | bc)" -eq 1) 2>/dev/null	
        	then 
        		echo "No has introducido una seccion valida"
        		echo "No se puede continuar el calculo"
        		
        		sleep 3
        		clear
        	
		
        	else
        		echo "Perfecto, todos los argumentos estan bien, se puede proceder al calculo de la longitud"
			sleep 3
			clear		
			
			echo "Los valores para el metal $1 son: "
			echo "Resistividad (ohmio*mm^2/m): $Resistividad"
			echo "Resistencia electrica (Ohmio): $2"
			echo "Seccion (mm^2):$3"
			
			sleep 2
			
			echo " "
			#calculo de la longitud
			longitud=$(echo "scale=3; ($3*$2)/($Resistividad)" | bc)
			
			echo "La formula para calcular la longitud es: (seccion*resistencia)/resistividad"
			
			echo ""
			
			sleep 3
			
			echo "Por lo que la longitud con los parametros anteriores es: $longitud metros"
			
			sleep 5
			#presentacion de la longitud calculada
        	fi 		
        fi
}

#funcion Ayuda: muestra el manual del programa con el funcionamiento de cada opcion del programa
function Ayuda
{
    echo "Ha elegido que se le muestre el manual de ayuda del shell Script 
metales.sh."
    echo ""

    echo "El programa consta de 12 opciones incluyendo esta misma."
    
    echo ""

    echo "Opciones: "
    
    echo ""

    echo "-met: Muestra el metal cuyo nombre se le ha pasado de segundo 
      argumento al ejecutar el Script
      (si no existe da un mensaje de error)"

    echo ""

    echo "-sq: Muestra el metal cuyo simbolo quimico se le ha pasado de 
     segundo argumento al ejecutar el Script
     (si no existe da un mensaje de error)"
    
    echo ""

    echo "-tf: Muestra el metal cuya temperatura de fusion se le ha 
     pasado de segundo argumento al ejecutar el Script
     (si no existe da un mensaje de error)"
    
    echo ""

    echo "-z: Muestra el metal cuyo numero atomico se le ha pasado de 
    segundo argumento al ejecutar el Script
    (si no existe da un mensaje de error)"
    
    echo ""

    echo "-u: Muestra el metal cuya masa atomica se le ha pasado de 
    segundo argumento al ejecutar el Script
    (si no existe da un mensaje de error)"
    
    echo ""

    echo "-u -z: Muestra el metal cuya masa atomica y numero atomico se 
       le ha pasado como segundo y cuarto argumento al ejecutar el Script 
       (si no existe da un mensaje de error)"

    echo ""
    
    echo "-u -tf: Muestra el metal cuyo masa atomica y temperatura de 
        fusion se le ha pasado como segundo y cuarto argumento 
        al ejecutar el Script 
        (si no existe da un mensaje de error)"
    
    echo ""

    echo "-z -tf: Muestra el metal cuyo numero atomico y temperatura de 
        fusion se le ha pasado como segundo y cuarto argumento
        al ejecutar el Script
        (si no existe da un mensaje de error)"
    
    echo " "

    echo "-r -m -l -s: Calcula la resistencia electrico del elemento(ohmios) 
             que se le ha pasado como cuarto argumento
             (si no existe da un mensaje de error)
             a partir de la resistividad (ohmios*mm2/m),
             la longitud(m) y la seccion(mm2)."
    
    echo ""

    echo "-s -m -l -r: Calcula la seccion del elemento(mm2) 
             que se le ha pasado como cuarto argumento
             (si no existe da un mensaje de error),
             a partir de la resistividad (ohmios*mm2/m), 
             la longitud(m) y la resistencia electrica(ohmios)."

    echo ""

    echo "-l -m -r -s: Calcula la longitud del elemento(m)
             que se le ha pasado como cuarto argumento
             (si no existe da un mensaje de error),
             a partir de la resistividad (ohmios*mm2/m),
             la resistencia electrica (ohmios) y la seccion(mm2)."
    
    echo ""

    echo "-h: Muestra el manual del programa"
    
    echo ""

}


#MAIN DEL PROGRAMA

echo "Bienvenido a metales.sh, la opcion introducida es $1 $2 $3 $4 $5 $6 $7" #presentacion de las opciones elegidas
sleep 2

echo " "

clear

#seleccion de las opciones a partir del primer argumento introducido al ejecutar el programa
case $1 in 
        -met)
               Nombre $2 #mostrar datos a partir del nombre
        ;;
        -sq)
                SimboloQuimico $2 #mostrar datos a partir del simbolo quimico
        ;;
        -tf)
                Temperatura $2 #mostrar datos a partir de la temperatura de fusion
        ;;
        -z)
        #como la opcion -z puede tener dos opciones hay que comprobar si la siguiente opcion es la correcta, esta vacia o es incorrecta
                if(test "$3" = "-tf") #si el tercer argumento es -tf se ejcuta esta opcion y se va a la funcion mostrada
                then    
                        nAtom_T $2 $4
                elif($3) #si el tercer argumento esta vacio se ejecuta esta opcion
                then
                        nAtom $2
                else
                	echo "Se han introducido argumentos no validos"
                fi
                #si no es ninguna de esas opciones sale del programa
                
        ;;
        -u)
        #como la opcion -u puede tener tres opciones hay que comprobar si la siguiente opcion es la correcta, esta vacia o es incorrecta
                if(test "$3" = "-z") #si el tercer argumento es -z se ejcuta esta opcion y se va a la funcion mostrada
                then    
                        mAtom_nAtom $2 $4
                elif(test "$3" = "-tf") #si el tercer argumento es -tf se ejcuta esta opcion y se va a la funcion mostrada
                then
                        mAtom_T $2 $4
                elif($3) #si el tercer argumento esta vacio se ejecuta esta opcion
                then
                        mAtom $2
                else
                	echo "Se han introducido argumentos no validos"
                fi
                #si no es ninguna de esas opciones sale del programa
        ;;

        -r)
            #comprueba si las opciones introducidas son validas, los valores se compreuban dentro de la funcion
            if(test "$2" = -m && test "$4" = -l && test "$6" = -s) 
            then
                resistencia $3 $5 $7
            else
                echo "No se han introducido unos argumentos validos"
            fi       
        ;;

        -l)
            #comprueba si las opciones introducidas son validas, los valores se compreuban dentro de la funcion
            if(test "$2" = "-m" && test "$4" = "-r" && test "$6" = "-s")
            then
                longitud $3 $5 $7
            else
                echo "No se han introducido unos argumentos validos"
            fi
        ;;

        -s)
            #comprueba si las opciones introducidas son validas, los valores se compreuban dentro de la funcion
            if(test "$2" = "-m" && test "$4" = "-l" && test "$6" = "-r")
            then
                seccion $3 $5 $7
            else
                echo "No se han introducido unos argumentos validos"
            fi
        ;;

        -h)
        	#muestra el manual de ayuda
                Ayuda
        ;;
	*)
		echo "No se han introducido argumentos validos para realizar el programa"
		echo "Vuelva a intentarlo"
	;;

esac




