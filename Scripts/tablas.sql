
/*
Tabla calificaciones

ID_cliente: Clave foránea que referencia a la tabla Clientes en la columna Idnombre. También tiene una restricción de clave foránea adicional que referencia a clientes(dni).
ID_servicio: Clave foránea que referencia a la tabla Servicio en la columna Idnombre. También tiene una restricción de clave foránea adicional que referencia a servicios(id_servicio).

detalle: Columna de tipo varchar(50) que no permite valores nulos.
puntaje: Columna de tipo SMALLINT que no permite valores nulos y debe estar entre 1 y 10.

Clave primaria compuesta: Compuesta por ID_cliente y ID_servicio.
*/
CREATE TABLE IF NOT EXISTS Calificaciones(
    -- Claves foráneas
    ID_cliente SMALLINT CONSTRAINT fk_Cliente FOREIGN KEY
        (ID_cliente) REFERENCES Clientes(/Idnombre/),
    ID_servicio SMALLINT CONSTRAINT fk_Servicio FOREIGN KEY
        (ID_servicio) REFERENCES Servicio(/Idnombre/),

    -- Clave primaria compuesta
    CONSTRAINT pk_calificaciones PRIMARY KEY (ID_cliente, ID_servicio),

    -- Otras columnas
    detalle varchar(50) NOT NULL,
    puntaje SMALLINT NOT NULL CONSTRAINT chk_puntaje
        CHECK (puntaje BETWEEN 1 AND 10)
);
alter table calificaciones
ADD CONSTRAINT fk_dni_cliente_calificaciones_foreign FOREIGN KEY (id_cliente)
REFERENCES clientes(dni);
alter table calificaciones
ADD CONSTRAINT fk_dni_servicios_calificaciones_foreign FOREIGN KEY (id_servicio)
REFERENCES servicios(id_servicio);



/*
Tabla Servicios

ID_Servicio: Clave primaria de tipo SMALLINT.
ID_Vehiculo_alquiler: Clave foránea que referencia a Vehiculos_de_alquiler(ID_Vehiculo).
ID_Transporte: Clave foránea que referencia a Vehiculos_de_alquiler(ID_Transporte).
ID_excursion: Clave foránea que referencia a Excursiones(ID_Excursion).
ID_alojamiento: Clave foránea que referencia a Alojamiento(ID_alojamiento).

nombre: Columna de tipo TEXT que no permite valores nulos.
precio: Columna de tipo double precision que no permite valores nulos y debe ser mayor a 0.

Restricción de un solo ID: Asegura que solo uno de los IDs (ID_Vehiculo_alquiler, ID_Transporte, ID_excursion, ID_alojamiento) sea no nulo.
*/
CREATE TABLE IF NOT EXISTS Servicios(
    ID_Servicio SMALLINT CONSTRAINT ID_pk PRIMARY KEY,

    -- Claves foráneas
    ID_Vehiculo_alquiler SMALLINT CONSTRAINT fk_Vehiculos_de_alquiler FOREIGN KEY
        (ID_Vehiculo_alquiler) REFERENCES Vehiculos_de_alquiler(ID_Vehiculo),
    ID_Transporte SMALLINT CONSTRAINT fk_Transporte FOREIGN KEY
        (ID_Transporte) REFERENCES Vehiculos_de_alquiler(ID_Transporte),
    ID_excursion SMALLINT CONSTRAINT fk_excursion FOREIGN KEY
        (ID_excursion) REFERENCES Excursiones(ID_Excursion),
    ID_alojamiento SMALLINT CONSTRAINT fk_Alojamiento FOREIGN KEY
        (ID_alojamiento) REFERENCES Alojamiento(ID_alojamiento),

    -- Columna nombre
    nombre TEXT NOT NULL,

    -- Columna precio
    precio double precision NOT NULL CONSTRAINT chk_precio CHECK (precio > 0),

    -- Restricción para asegurar que solo un ID sea no nulo
    CONSTRAINT chk_un_solo_id CHECK (
        (ID_Vehiculo_alquiler IS NOT NULL)::int +
        (ID_Transporte IS NOT NULL)::int +
        (ID_excursion IS NOT NULL)::int +
        (ID_alojamiento IS NOT NULL)::int = 1
    )
);

/*
Tabla Personal

DNI_Personal: Clave primaria de tipo integer.
rol: Columna de tipo varchar(10) que no permite valores nulos y debe comenzar con una letra mayúscula.
salario: Columna de tipo double precision que no permite valores nulos y debe ser mayor a 0.
nombre: Columna de tipo varchar(20) que no permite valores nulos y debe comenzar con una letra mayúscula.
apellido: Columna de tipo varchar(20) que no permite valores nulos y debe comenzar con una letra mayúscula.

*/
CREATE TABLE IF NOT EXISTS Personal(
    DNI_Personal integer NOT NULL
        CONSTRAINT pk_dni_Personal primary key (DNI_Personal),
    rol varchar(10) NOT NULL
        CONSTRAINT chk_rol_format CHECK (rol ~* '^[A-Z].*'),
    salario double precision NOT NULL
        CONSTRAINT chk_salario_Personal check (salario > 0),
    nombre varchar(20)NOT NULL
        CONSTRAINT chk_nombre_format CHECK (rol ~* '^[A-Z].*'),
    apellido varchar(20)NOT NULL
        CONSTRAINT chk_apellido_format CHECK (rol ~* '^[A-Z].*')
);

/*
Tabla de adicionales paquete

id_paquetes: Clave foránea que referencia a paquetes(id_paquete).
id_seguro: Clave foránea que referencia a seguroViaje(id_seguro).
precio: Columna de tipo numeric(40,2) que no permite valores nulos y debe ser mayor a 0.

*/
CREATE TABLE  adicionales_paquete (
    id_paquetes SMALLINT,
    id_seguro SMALLINT,
	 precio numeric(40,2) NOT NULL check (precio>0),
	 CONSTRAINT paquete_reserva_constraint  FOREIGN KEY (id_paquetes) REFERENCES paquetes(id_paquete),
	 CONSTRAINT adicional_seguro_constraint  FOREIGN KEY (id_seguro) REFERENCES seguroViaje(id_seguro)
);

/*
Tabla de adicionales reserva

id_seguro: Clave foránea que referencia a SeguroViaje(id_seguro).
id_reserva: Clave foránea que referencia a Reservas(id_reserva).
precio: Columna de tipo numeric(40,2) que no permite valores nulos y debe ser mayor a 0.
*/
CREATE TABLE  adicionales_reserva (
    id_seguro SMALLINT,
	id_reserva SMALLINT,
    precio numeric(40,2) not  NULL check (precio>0),
	CONSTRAINT seguro_reserva_constraint  FOREIGN KEY (id_reserva) REFERENCES Reservas(id_reserva),
	constraint adicional_seguro_constraint foreign key (id_seguro) references SeguroViaje(id_seguro)
);



CREATE TABLE IF NOT EXISTS "ISFPP2024".item_reserva
(
    id_servicio smallint,
    id_reserva smallint,
    precio double precision,
    CONSTRAINT paquete_reserva_constraint FOREIGN KEY (id_reserva)
        REFERENCES "ISFPP2024".reservas (id_reserva) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

