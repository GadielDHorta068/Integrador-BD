# Informe de Proyecto: ISFPP Base de Datos
![image](https://github.com/user-attachments/assets/528fefef-93d3-4835-800d-2d5d39a44411)

## Integrantes
- **D'Horta Gadiel**
- **Martínez Gonzalo**
- **Aguilar Rocio**

**Facultad de Ingeniería 2024**  
**Universidad Nacional de la Patagonia San Juan Bosco (UNPSJB)**  

---

## Contenido

1. [Introduccion](#1-introduccion)
2. [Diagramas UML](#2-diagramas-uml)
3. [Diseño](#3-diseño)
4. [Desarrollo del proyecto](#4-desarrollo-del-proyecto)
5. [Experiencia grupal](#5-experiencia-grupal)
6. [División de tareas](#6-división-de-tareas)
7. [Dificultades](#7-dificultades)
8. [Mejoras propuestas](#8-mejoras-propuestas)


---

## 1. Introduccion

Entre todo nuestro curso, Nos dedicamos a diseñar una base de datos para una empresa de viajes llamada Bosco Viajes que le permita gestionar eficazmente sus aspectos operativos y permitir desarrollar nuevos sistemas internos y aplicaciones comerciales.
La empresa ofrece una amplia gama de servicios relacionados con viajes, tales como reservas de alojamiento, transporte, excursiones, entre otros. 
La tarea de nuestro grupo, denominado **Grupo Rosa**, incluyó el diseño de varias tablas clave para gestionar la información asociada a los distintos servicios y operaciones de la empresa. Las relaciones diseñadas son las [siguientes](https://github.com/GadielDHorta068/Integrador-BD/wiki/Tablas):

**Personal**: Se debe mantener registro de la información sobre los empleados de la empresa, incluyendo nombres, roles y datos de contacto. Algunos estarán asignados a reservas y registra su tipo de participación (agente de reserva, guía turístico, chofer, etc.).

**Calificaciones**:
La tabla Calificaciones permite a los clientes calificar los `servicios` ofrecidos por la empresa, registrando un puntaje (del 1 al 10) y una breve reseña (máximo 50 caracteres) sobre el servicio recibido.

**Servicios**:
La tabla Servicios gestiona la información de los servicios ofrecidos, relacionados con diferentes tipos de actividades como alquiler de vehículos, transporte, excursiones y alojamiento. Cada servicio tiene un identificador único y se asocia a uno de los tipos mencionados. La restricción en la tabla asegura que solo uno de los campos de referencia (`ID_Vehiculo_alquiler`, `ID_Transporte`, `ID_excursion`, `ID_alojamiento`) pueda estar presente en un servicio en particular, lo que permite garantizar que cada servicio esté relacionado de manera exclusiva con un tipo específico.

**Adicionales de Paquete**:
La tabla adicionales_paquete es la tabla intermedia entre la  `seguros_viaje`.  Cada registro contiene un identificador de paquete, un identificador de seguro y el precio del adicional. Se asegura que tanto el paquete como el seguro existan en sus respectivas tablas (paquetes y seguroViaje) mediante claves foráneas. Y por medio de un trigger.

**Adicionales de Reserva**:
La tabla `adicionales_reserva` gestiona los adicionales de seguros asociados a las reservas. Cada registro incluye un identificador de seguro, un identificador de reserva y el precio del seguro adicional. Las claves foráneas aseguran que tanto el seguro como la reserva existan en sus respectivas tablas (`SeguroViaje` y `Reservas`). 

**Ítem reserva**:
Cada servicio asociado a una reserva es registrado en la tabla `item_reserva`. Esta tabla mantiene el precio del servicio para la reserva específica y asegura que cada servicio se encuentre vinculado correctamente a una reserva existente.

---

## 2. Diagramas UML
(se recomienda abrir en drawio)
[**Diagrama grupo rosa**](https://drive.google.com/file/d/18KB_bKpanMqm5qf03HjQkoYbr68eKxME/view?usp=sharing)

![ClaseProyect (4)-Página-1 drawio](https://github.com/user-attachments/assets/aba17dd5-c11c-4c92-a871-dea6634c95f8)

[**Diagrama General**](https://drive.google.com/file/d/1Ykn8lkEBHSvq9y2VLVi17AjAItZ2oybQ/view?usp=sharing)

![Bosco viajes F drawio](https://github.com/user-attachments/assets/d903b052-4d7c-4442-b2d8-8870b733a3c9)

---

## 3. Diseño
### consideraciones, decisiones y/o limitaciones del sistema.

- Algunas de las consideraciones iniciales del proyecto fueron descartadas, como la necesidad de verificar que los `clientes` hayan utilizado un servicio antes de calificarlo. Para simplificar, tomamos como referencia el modelo de reseñas de Google, donde cualquier usuario puede opinar sobre un servicio, independientemente de si lo ha utilizado o no.

- La tabla de `personal` solo permite que los empleados que están asociados directamente con la empresa figuren en la tabla de servicios como encargados. No se permite la tercerización de servicios.

- Las tablas adicionales de servicio/paquete podrían implementar herencia, ya que comparten atributos comunes, como la ID de seguro y su precio. La única diferencia radica en el tipo de entidad (`paquete` o `reserva`). Sin embargo, se optó por la tercera forma de herencia, en la cual cada tabla hija es completamente independiente y contiene todos los datos relevantes para simplificar la inserción.

- En el diagrama general, también se observan similitudes entre las tablas `ítem_reserva` e `ítem_paquete`, Inicialmente se tenía la intención de unificar ambas tablas en una sola. Sin embargo, la tabla `ítem_paquete` fue retirada de nuestro grupo, por lo que ahora son dos tablas distintas.

- La tabla de `servicios` presenta herencia en la segunda forma, en la cual nuestro grupo posee la tabla base y el grupo amarillo tiene las tablas de subclase.

---
## 4. Desarrollo del proyecto

### **Creación de tablas**
Una tabla es una estructura que organiza los datos en filas y columnas. Cada tabla tiene un nombre único en la base de datos, y está compuesta por:

- **Columnas (Campos):** Cada columna tiene un nombre y un tipo de datos (por ejemplo, `INTEGER`, `VARCHAR`, `DATE`), definiendo el tipo de información que puede almacenar.
- **Filas (Registros):** Cada fila representa un conjunto de datos relacionado, donde cada valor corresponde a una columna específica.

Las tablas son fundamentales en las bases de datos relacionales, ya que permiten organizar, almacenar y consultar grandes cantidades de datos de manera estructurada y eficiente.

[Documentación de **Tablas**](https://github.com/GadielDHorta068/Integrador-BD/wiki/Tablas)


### **Creación de vistas**
Una vista es una tabla virtual basada en el resultado de una consulta SQL. Las vistas no almacenan datos por sí mismas, sino que representan un conjunto de datos almacenados en una o más tablas.

[Documentación de **Vistas**](https://github.com/GadielDHorta068/Integrador-BD/wiki/Vistas)


### **Creación de las funciones**
Una función es un bloque de código que realiza una tarea específica y devuelve un valor. Las funciones en SQL se utilizan para encapsular lógica compleja, reutilizar código y realizar operaciones sobre datos de manera consistente.

[Documentación de **Funciones**](https://github.com/GadielDHorta068/Integrador-BD/wiki/Funciones)


### **Creación de los triggers**
Un trigger (o disparador) es un tipo especial de procedimiento almacenado que se ejecuta automáticamente en respuesta a ciertos eventos en una tabla o vista. Los triggers se utilizan para asegurar la integridad de los datos, realizar validaciones automáticas o llevar a cabo tareas específicas cuando ocurren cambios en los datos.

[Documentación de **Triggers**](https://github.com/GadielDHorta068/Integrador-BD/wiki/Triggers)


### **Creación de procedimientos**
Un procedimiento almacenado en SQL es un conjunto de instrucciones SQL predefinidas y guardadas en la base de datos. Los procedimientos almacenados permiten encapsular lógica compleja en una única unidad reutilizable, lo que mejora la modularidad y facilita el mantenimiento del código.

[Documentación de **Procedimientos**](https://github.com/GadielDHorta068/Integrador-BD/wiki/Procedimientos)

---

## 5. Experiencia grupal

El proyecto ofreció una experiencia similar a un entorno laboral real, siendo el mayor desafío la **coordinación y comunicación entre los grupos**. La asignación inicial de tareas fue complicada debido a la falta de acuerdo entre los integrantes.

### Experiencia individual

- **Aguilar:**  
   La falta de comunicación con mis compañeros de grupo (por mi culpa) provocó que termine realizando procedimientos que ya se realizaron, las vistas de calificaciones plantearon un desafío a la hora de realizar joins con tablas, hay que decir que también como servicio posee muchas claves foráneas, cuando otros grupos eliminaban o modificaban tabla nos tiraban muchos de los datos cargados, como calificaciones, item reserva,etc.

- **Martínez:**  
  El planteamiento de los procedimiento y funciones relacionadas con la tabla de servicios resultó complicado, ya que implicaba considerar las diferentes dependencias, claves foráneas que daban las tablas relacionadas. De igual manera, el planteamiento de sus triggers y views tuvo sus complicaciones.

- **D’Horta:**  
  Tuve dificultades a la hora de poblar las tablas, ya que fue la segunda tarea luego de que las tablas estuvieran creadas. Ocurría que las FK y algunas restricciones estaban deshabilitadas por falta de tablas intermedias o filas de otros grupos. Eso hizo que tuviera que cargarlas con mucha conciencia, pero, aun así, después tuve que revisar todos los datos ingresados. Hace poco desaparecieron muchos datos que había cargado, lo cual fue descubierto por mi compañera al querer probar procedimientos y funciones. 
Otra dificultad fueron algunas inconsistencias entre el diagrama, las tablas y los nombres de los atributos, y la realidad de cómo estaba implementada la base de datos, lo que me generaba errores en métodos que tendrían que haber funcionado a la primera. 
Por otro lado, me gustó el tema de hacer un trabajo práctico grupal dividido entre todo el curso con un tema bien completo, pero si lográbamos empezarlo antes seguro se lograban 
mejores resultados.

---

## 6. División de tareas

| Tarea                 | Creación          | Procedimientos     | Triggers           | Correcciones       | Inserción de datos | Vistas   |
|-----------------------|-------------------|--------------------|--------------------|--------------------|--------------------|----------|
| **Servicio**          | Martínez          | Martínez          | Martínez           | Aguilar, Martínez, D'Horta  | D'Horta    |Aguilar, Martínez|
| **Calificaciones**    | Aguilar           | Aguilar           |             | Aguilar, Martínez, D'Horta  | D'Horta           |Aguilar,D'Horta |
| **Ítem Reserva**      | Martínez          | Martínez           | Aguilar            | Aguilar, Martínez, D'Horta  | D'Horta   |Aguilar|
| **Adicionales Paquete**|Aguilar           | Aguilar           | D'Horta            | Aguilar, Martínez, D'Horta  | D'Horta    |Aguilar|
| **Adicionales Reserva**| D'Horta          | D'Horta           | D’Horta   | Aguilar, Martínez, D'Horta  | D'Horta            |Aguilar|
| **Personal**          |Aguilar            | Aguilar           |           | Aguilar, Martínez, D'Horta  | D'Horta            |D'Horta,Martínez|

---


## 7. Dificultades

1. **Triggers:**  
   - En el contexto de un trabajo grupal, el reto principal de los triggers fue asegurarse de que no interfieran con otras partes del proyecto y confirmar su correcto funcionamiento

2. **Tabla Servicio:**  
   - El planteamiento de la tabla servicio, en particular requirió un análisis en profundidad en la inserción ,modificación ya que posee  cuatro claves foráneas pertenecientes a diferentes tablas, para lo cual es imperativo que fueran diseñados métodos de inserción para cada uno de los tipos y un método general el cual posee una lógica que permite una inserción de un solo tipo de equipo a la vez.

3. **Discrepancias de diseño:**  
   - Se identificaron discrepancias entre las estructuras y procedimientos diseñados por los distintos grupos. Esto evidencia que no hubo una alineación adecuada en cuanto a los criterios de diseño y las dependencias entre los módulos. En particular, la falta de sincronización afectó la integración de las tablas y procedimientos, ya que algunas dependencias clave, como las claves foráneas o la normalización de las tablas, no estaban completamente definidas o implementadas al momento de realizar pruebas conjuntas.

4. **Retroalimentación insuficiente:**  
   - Creemos que la retroalimentación es una parte clave para mejorar continuamente. En este proyecto, quizá podríamos haber dedicado más tiempo a compartir opiniones sobre nuestras contribuciones con los profesores, lo que nos habría permitido pulir aún más nuestro trabajo en conjunto

---

## 8. Mejoras propuestas

1. **Tabla temporal:**  
   Implementar una tabla para guardar el precio histórico de los servicios.

2. **Procedimientos DDL en vistas:**  
   Preparar vistas para soportar usuarios con roles, limitando su acceso a las tablas principales.

3. **Campo Rol en la tabla Personal:**  
   Actualmente es solo descriptivo; debería determinar permisos y privilegios para establecer un control más detallado sobre las acciones que cada miembro puede realizar.
---


