/*Autores:
	Juan José López Gómez 
	David Perez Velasco   
*/

#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <string.h>
#include <signal.h>
#include <errno.h>
#include <time.h>

//Definicion de las macros de los limites de procesos
#define MAX_PROC 33 
#define MIN_PROC 3

//Prototipos de las funciones del programa
void zonaCriticadebug();

void zonaCritica();

void exterminio();

void espera();

void nada();

int crearProcesos(int, int *);

void setManejadora(int, int *);

int main (int argc, char *argv[])
{	
	
		
	//+Definicion de datos a usar en el transcurso del programa
	
		//·Datos atomicos: 
			
	char buffer[100]; //Se utiliza como medio para escribir por pantalla
	int nPro; //Numero de procesos que va a manejar el programa en la ejecucion.
	int last; //Variable del tipo PID en el que se va a almacenar el PID del proceso al que van a tener que enviar la señal testigo
	int i; //Variable iteradora de bucles for
	
		//·Datos definidos:
		
	struct timespec time, time2; //Struct timespec, necesario para la funcion nanosleep( const *timespec t1, const *timespec t2)
	time.tv_sec=0;
	time.tv_nsec=150000000;
	
	sigset_t maskF, maskC, bloqueo; //mascaras que seran utilizadas mas adelante
		
	int PIDS[MAX_PROC+1]; // Array en el que se van a almacenar todos los PIDS de los procesos
	
	//+Ejecucion del programa:	
		//·Comprobacion de los argumentos del programa
			
	if(argc==1) //Solo se ha introducido el nombre del ejecutable
		{
			fprintf(stderr,"No se han introducido argumentos validos para la ejecución del programa\n");
			return -1;
		}
	else if(argc==2) //Se introduce el nombre del ejecutable y un argumento mas
		{
			nPro=atoi(argv[1]); //Conversion del argumento a entero y siguiente comprobacion de los limites
			if(nPro<MIN_PROC || nPro>MAX_PROC)
			{
				fprintf(stderr,"No se han un numero valido de procesos para ejecutar el programa\n");
				return -2;
			}
			
			else //todo correcto vas al funcionamiento normal
			{
				sprintf(buffer,"Se va a ejecutar el programa en modo normal\n");
				write(1,buffer,strlen(buffer));
				
				PIDS[0]=getpid(); //Se guarda el PID del padre en la primera posicion del array
				
				sigfillset(&bloqueo);
				sigprocmask(SIG_SETMASK,&bloqueo,NULL); //Se inicializa y activa las mascara para no permitir ninguna señal 
				
				last=crearProcesos(nPro,PIDS); 
				//Llamada a la funcion para crear los procesos, devuelve al proceso que sale de la funcion el PID del proceso al 
				//que le va a tener que pasar el testigo
					
				if(PIDS[0]==getpid()) //Zona unicamente accesible por el padre
					{ 						
						//Iniciacion de la mascara que va a hacer que se suspenda el proceso padre, solo permite el testigo 
						//y la señal de finalizacion
						
						sigfillset(&maskF);
						sigdelset(&maskF,SIGUSR1);
						sigdelset(&maskF,SIGINT);
						
						//Iniciacion de las capturaduras de las señales con sus respectivas manejadoras 
						//una por cada señal que permite la mascara anterior
						
						setManejadora(argc,PIDS);
						
						//Iniciacion del testigo a su colindante con la señal SIGUSR1
						kill(last,SIGUSR1);
												
						//Bucle infinito en el que el padre permanece suspendido hasta que recibe o SIGINT o SIGSUR1
						//Si recibe esta ultima entra en la zona critica y despues pasa el testigo
						while(1){
								sigsuspend(&maskF);
								zonaCritica();
								kill(last,SIGUSR1);	
							}
					}
				else //Zona unicamente accesible por los hijos
					{
						//Iniciacion de la mascara que va a hacer que se suspenda el proceso hijo, solo permite el testigo 
						//y la señal de finalizacion
						sigfillset(&maskC);
						sigdelset(&maskC,SIGUSR1);
						sigdelset(&maskC,SIGINT);
						
						//Iniciacion de las capturaduras de las señales una por cada señal que permite la mascara anterior
						setManejadora(argc,PIDS);
						
						//Bucle infinito en el que el hijo permanece suspendido hasta que recibe o SIGINT o SIGSUR1
						//Si recibe esta ultima entra en la zona critica y despues pasa el testigo
						while(1){
								sigsuspend(&maskC);
								zonaCritica();
								kill(last,SIGUSR1);	
							}
					}
			}
		}
		
	else if(argc==3) //Se ha introducido el nombre y dos argumentos mas
	{
		nPro=atoi(argv[1]);
		if(nPro<MIN_PROC || nPro>MAX_PROC)
			{
				fprintf(stderr,"No se han un numero valido de procesos para ejecutar el programa");
				return -2;
			}
		if(!strcmp(argv[2],"debug")) //Comprobacion de si el tercer argumento coincide con debug, si es asi entra al programa
			{
				sprintf(buffer,"Se va a ejecutar el programa en modo depurador\n");
				write(1,buffer,strlen(buffer));
				
				PIDS[0]=getpid();
				
				sigfillset(&bloqueo);
				sigprocmask(SIG_SETMASK,&bloqueo,NULL);
				
				last=crearProcesos(nPro,PIDS);//Mismo funcionamiento que la otra parte del programa
				
				if(PIDS[0]==getpid()) //Zona del padre
					{						
						//En este zona se desbloquea una señal mas, SIGALRM que sera necesaria para las pausas
						sigfillset(&maskF); 
						sigdelset(&maskF,SIGUSR1);
						sigdelset(&maskF,SIGINT);
						sigdelset(&maskF,SIGALRM);	
						
						setManejadora(argc,PIDS); //Mismo funcionamiento
						
						kill(last,SIGUSR1);
												
						while(1){
								sigsuspend(&maskF);
								zonaCriticadebug();
								nanosleep(&time,&time2); //Funcion para la espera de la decima y media
								kill(last,SIGUSR1);	
							}
					}
				else //Zona de los hijos
					{
						//Mismo funcionamiento a su analoga del funcionamiento normal con la excepcion de la señal SIGALRM
						sigfillset(&maskC);
						sigdelset(&maskC,SIGUSR1);
						sigdelset(&maskC,SIGINT);
						sigdelset(&maskC,SIGALRM);
						
						setManejadora(argc,PIDS);
						
						while(1){
								sigsuspend(&maskC);
								zonaCriticadebug();
								nanosleep(&time,&time2);
								kill(last,SIGUSR1);	
							}
					}
			}	
	}

}

//////////////////////////////////////
//	void zonaCritica()            
//  Input:no                         
//  output: Impresion por pantalla   
//	    No valor de retorno      	
//  Realiza la impresion de seguida  
//  de una E y una S sin espera      
///////////////////////////////////////

void zonaCritica(){
	char buffer[20];
	
	sprintf(buffer,"E");
	write(1,buffer,strlen(buffer));
	sprintf(buffer,"S");
	write(1,buffer,strlen(buffer));
}

//////////////////////////////////////////
//	void zonaCriticadebug()            
//  Input:no                         
//  output: Impresion por pantalla   
//	    No valor de retorno      	
//  Realiza la impresion de una E con el 
//  PID del proceso, produce una espera
//  Imprime una S con el PID del proceso 
//  En la ejecucion se realizan pausas 
//  que son registradas con SIGALRM    
//////////////////////////////////////////

void zonaCriticadebug(){

	char buffer[20];
	
	sigset_t mask;
	sigfillset(&mask);
	sigdelset(&mask,SIGALRM);
	sigdelset(&mask,SIGINT);
		
	alarm(1);
	sigsuspend(&mask);
	
	sprintf(buffer,"E(%d)",getpid());
	write(1,buffer,strlen(buffer));
	
	alarm(2);
	sigsuspend(&mask);
	
	sprintf(buffer,"S(%d)",getpid());
	write(1,buffer,strlen(buffer));
	
}

//////////////////////////////////////////
//	void exterminio()            
//  Input:no                         
//  output: no   
//	          	
//  Finaliza el proceso con un valor de
//  retorno de 1	
//////////////////////////////////////////

void exterminio(){
	exit(1);
}

///////////////////////////////////////////////////////////////
//	void espera()            
//  Input:no                         
//  output: Impresion por pantalla   
//	          	
//  Zona en la que el padre espera a la muerte de los hijo
//  ignorando su señal de muerte
//  cuando todos han muerto imprime por pantalla
//  la finalizacion y acaba el proceso con un valor de retorno 
//  a la shell de la macro EXIT_SUCCESS	
///////////////////////////////////////////////////////////////

void espera(){
	char buffer[50];
	int status;
	struct sigaction ignore;	
	ignore.sa_handler = SIG_IGN;
	ignore.sa_flags = 0;
	sigaction(SIGCHLD, &ignore, NULL);
	
	while(wait(&status) > 0);
	
	sprintf(buffer,"\nPrograma Finalizado Correctamente\n");
	write(1,buffer,strlen(buffer));
	
	exit(EXIT_SUCCESS);		
}

//////////////////////////////////////////
//	void nada()            
//  Input:no                         
//  output: no   
//	          	
//  Funcion auxiliar sin ningun uso
//////////////////////////////////////////

void nada(){
}

/////////////////////////////////////////////////////////////
//	int crearProcesos(int nPro, int * PIDS)            
//  Input: nPro(numero de procesos a crear) 
//         PIDS(Vector de PIDS de todos los procesos)                         
//  output: el PID del proceso al que mandar el testigo   
//	          	
//  Mediante un bucle while crea tantos procesos como valor 
//  tenga el argumento que se le pasa a la funcion.
//  Se crea cada proceso y se le devuelve el PID del proceso 
//  anterior que es al que se le va a tener que pasar
//  el testigo 
//////////////////////////////////////////////////////////////

int crearProcesos(int nPro,int * PIDS){
	int procesos=1;
	int pid;
	
	while(procesos<nPro)
		{
			pid=fork();	
			if(pid==-1)
				{
					perror("Error en el fork");
					exit(-1);
				}
			if(pid==0)
				{
					return PIDS[procesos-1];
					break;
				}
			else
				{
					PIDS[procesos]=pid;
					procesos++;
				}	
		}
		return PIDS[procesos-1]; 
}

///////////////////////////////////////////////////////////
//	void setManejadora(int argc, int * PIDS)          
//  Input: argc(longitud del vector del prototipo de main)
//	   PIDS(Vector de PIDS de todos los procesos)                       
//  output: no  
//	          	
//  Esta funcion identifica en que parte del programa esta
//  y setea las manejadoras distinguiendo entre padres e 
//  hijos correctamente.
//  Utilizando un struct por señal que puede obtener en esa 
//  rama del programa para mas seguridad y diferenciacion 
//  de las distintas señales que se pueden recibir
///////////////////////////////////////////////////////////

void setManejadora(int argc,int * PIDS){
	struct sigaction sINT,sALRM,sUSR;
	
	if(argc==2)
		{
			if(getpid()==PIDS[0])
				{
					sUSR.sa_handler=nada;
					sigfillset(&sUSR.sa_mask);
					sUSR.sa_flags=0;
					if(sigaction(SIGUSR1,&sUSR,NULL)==-1)
						{
							perror("ERROR SIGUSR1 PADRE");
							exit(-2);
						}
						
						
					sINT.sa_handler=espera;
					sigfillset(&sINT.sa_mask);
					sINT.sa_flags=0;
					if(sigaction(SIGINT,&sINT,NULL)==-1)
						{
							perror("ERROR SIGINT PADRE");
							exit(-2);
						}
				}
			else
				{
					sUSR.sa_handler=nada;
					sigfillset(&sUSR.sa_mask);
					sUSR.sa_flags=0;
					if(sigaction(SIGUSR1,&sUSR,NULL)==-1)
						{
							perror("ERROR SIGUSR1 HIJO");
							exit(-2);
						}
						
						
					sINT.sa_handler=exterminio;
					sigfillset(&sINT.sa_mask);
					sINT.sa_flags=0;
					if(sigaction(SIGINT,&sINT,NULL)==-1)
						{
							perror("ERROR SIGINT HIJO");
							exit(-2);
						}
				}
		}
	else if(argc==3)
		{
			if(getpid()==PIDS[0])
				{
					sUSR.sa_handler=nada;
					sigfillset(&sUSR.sa_mask);
					sUSR.sa_flags=0;
					if(sigaction(SIGUSR1,&sUSR,NULL)==-1)
						{
							perror("ERROR SIGUSR1 PADRE");
							exit(-2);
						}
						
					sALRM.sa_handler=nada;
					sigfillset(&sALRM.sa_mask);
					sALRM.sa_flags=0;
					if(sigaction(SIGALRM,&sALRM,NULL)==-1)
						{
							perror("ERROR SIGALRM PADRE");
							exit(-2);
						}
						
					sINT.sa_handler=espera;
					sigfillset(&sINT.sa_mask);
					sINT.sa_flags=0;
					if(sigaction(SIGINT,&sINT,NULL)==-1)
						{
							perror("ERROR SIGINT PADRE");
							exit(-2);
						}
				}
			else
				{
					sUSR.sa_handler=nada;
					sigfillset(&sUSR.sa_mask);
					sUSR.sa_flags=0;
					if(sigaction(SIGUSR1,&sUSR,NULL)==-1)
						{
							perror("ERROR SIGUSR1 HIJO");
							exit(-2);
						}
						
					sALRM.sa_handler=nada;
					sigfillset(&sALRM.sa_mask);
					sALRM.sa_flags=0;
					if(sigaction(SIGALRM,&sALRM,NULL)==-1)
						{
							perror("ERROR SIGALRM HIJO");
							exit(-2);
						}
						
					sINT.sa_handler=exterminio;
					sigfillset(&sINT.sa_mask);
					sINT.sa_flags=0;
					if(sigaction(SIGINT,&sINT,NULL)==-1)
						{
							perror("ERROR SIGINTHIJO");
							exit(-2);
						}
					
				}		
		}
}

