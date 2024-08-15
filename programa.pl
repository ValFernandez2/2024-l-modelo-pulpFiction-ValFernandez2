%BASE DE CONOCIMIENTO
personaje(pumkin,     ladron([licorerias, estacionesDeServicio])).
personaje(honeyBunny, ladron([licorerias, estacionesDeServicio])).
personaje(vincent,    mafioso(maton)).
personaje(jules,      mafioso(maton)).
personaje(marsellus,  mafioso(capo)).
personaje(winston,    mafioso(resuelveProblemas)).
personaje(mia,        actriz([foxForceFive])).
personaje(butch,      boxeador).

sonPareja(marsellus, mia).
sonPareja(pumkin,    honeyBunny).

sonAmigos(vincent, jules).
sonAmigos(jules, jimmie).
sonAmigos(vincent, elVendedor).

pareja(A,B):- sonPareja(A,B).
pareja(A,B):- sonPareja(B,A).
amigo(A,B):- sonAmigos(A,B).
amigo(A,B):- sonAmigos(B,A).
sonDuo(A,B):- amigo(A,B).
sonDuo(A,B):- pareja(A,B).

%trabajaPara(Empleador, Empleado)
trabajaPara(marsellus, vincent).
trabajaPara(marsellus, jules).
trabajaPara(marsellus, winston).

%encargo(Solicitante, Encargado, Tarea). 
%las tareas pueden ser cuidar(Protegido), ayudar(Ayudado), buscar(Buscado, Lugar)
encargo(marsellus, vincent,   cuidar(mia)).
encargo(vincent,  elVendedor, cuidar(mia)).
encargo(marsellus, winston, ayudar(jules)).
encargo(marsellus, winston, ayudar(vincent)).
encargo(marsellus, vincent, buscar(butch, losAngeles)).

caracteristicas(vincent,  [negro, muchoPelo, tieneCabeza]).
caracteristicas(jules,    [tieneCabeza, muchoPelo]).
caracteristicas(marvin,   [negro]).


%PUNTO 1
%PERSONAJE PELIGROSO
esPeligroso(Personaje):-
    personaje(Personaje,Tarea),
    actividadPeligrosa(Tarea).

esPeligroso(Personaje):-
    trabajaPara(Personaje,Empleado),
    esPeligroso(Empleado).

actividadPeligrosa(Tarea):-
    personaje(Personaje,Tarea),
    personaje(Personaje,mafioso(maton)).
actividadPeligrosa(Tarea):-
    personaje(Personaje,Tarea),
    personaje(Personaje,ladron(Lugares)),
    member(licorerias,Lugares).


%PUNTO 2
%DUO TEMIBLE
duoTemible(Personaje1,Personaje2):-
    esPeligroso(Personaje1),
    esPeligroso(Personaje2),
    sonDuo(Personaje1,Personaje2).


%PUNTO 3
%ESTA EN PROBLEMAS
estaEnProblemas(butch).
estaEnProblemas(Persona):-
    trabajaPara(Jefe,Persona),
    esPeligroso(Jefe),
    pareja(Jefe,Pareja),
    encargo(Jefe,Persona,cuidar(Pareja)).
estaEnProblemas(Persona):-
    encargo(_,Persona,buscar(Buscado,_)),
    personaje(Buscado,boxeador).


%PUNTO 4
%SAN CAYETANO
sanCayetano(Personaje):-
    encargo(Personaje,_,_),
    forall(sonDuo(Personaje,Personas),encargo(Personaje,Personas,_)).


%PUNTO 5
%MAS ATAREADO
%masAtareado(Personaje):-
    %encargo(_,Personaje,_),
    %findall(Encargo,encargo(_,Personaje,Encargo),Encargos),
    %length(Encargo,Cantidad),
    %Cantidad > OtraCantidad.

%PUNTO 6
%PERSONAJES RESPETABLES
personajesRespetables(Personajes):-
    findall(Personaje,(personaje(Personaje,_),esRespetable(Personaje)),Personajes).

esRespetable(Personaje):-
    personaje(Personaje,Tarea),
    respeto(Tarea,Respeto),
    Respeto > 9.

respeto(actriz(Lista),Respeto):-
    length(Lista,Longitud),
    Respeto is Longitud / 10.
respeto(mafioso(maton),1).
respeto(mafioso(capo),20).
respeto(mafioso(resuelveProblemas),10).


%PUNTO 7
%ESTÁ HARTO
hartoDe(Persona,Persona2):- 
    forall(encargo(_,Persona,Encargo),interactuaCon(Encargo,Persona2)).

interactuaCon(cuidar(_),Persona):- encargo(_,_,cuidar(Persona)).
interactuaCon(ayudar(_),Persona):- encargo(_,_,ayudar(Persona)).
interactuaCon(buscar(_),Persona):- encargo(_,_,buscar(Persona,_)).
interactuaCon(Encargo,Persona):-
    amigo(Persona,OtraPersona),
    interactuaCon(Encargo,OtraPersona).


%PUNTO 8
%DUO DIFERENCIABLE
duoDiferenciable(Persona1,Persona2):-
    sonDuo(Persona1,Persona2),
    diferentesCaracteristicas(Persona1,Persona2).

diferentesCaracteristicas(Persona1,Persona2):-
    caracteristicas(Persona1,Lista1),
    caracteristicas(Persona2,Lista2),
    not(forall(member(X,Lista1),member(X,Lista2))).

    diferentesCaracteristicas(Persona1,Persona2):-
        caracteristicas(Persona2,Lista1),
        caracteristicas(Persona1,Lista2),
        not(forall(member(X,Lista1),member(X,Lista2))).
    
    