
/*
Vista: vw_top10_servicios

Propósito: Muestra los 10 mejores servicios basados en el puntaje promedio de las calificaciones.

Columnas:
servicio: ID del servicio.
puntaje_promedio: Puntaje promedio truncado a un decimal.
tiposervicio: Tipo de servicio.

Orden: Descendente por puntaje_promedio.
*/
 CREATE OR REPLACE VIEW vw_top10_servicios AS
  SELECT  c.id_servicio as servicio,TRUNC(avg(c.puntaje),1) as puntaje_promedio,tiposervicio
FROM Calificaciones c
GROUP BY
   c.id_servicio,c.tiposervicio
ORDER BY
    puntaje_promedio DESC
LIMIT 10;

/*
Vista: vw_top10_peores_servicios

Propósito: Muestra los 10 peores servicios basados en el puntaje promedio de las calificaciones.

Columnas:
servicio: ID del servicio.
puntaje_promedio: Puntaje promedio truncado a un decimal.
tiposervicio: Tipo de servicio.

Orden: Ascendente por puntaje_promedio.
*/
SELECT * FROM vw_top10_servicios;
    CREATE OR REPLACE VIEW vw_top10_peores_servicios AS
    SELECT  c.id_servicio as servicio,TRUNC(avg(c.puntaje),1) as puntaje_promedio,tiposervicio

    FROM Calificaciones c

    GROUP BY    c.id_servicio,c.tiposervicio
ORDER BY
    puntaje_promedio ASC
LIMIT 10;


/*
Vista: promedio_servicios

Propósito: Muestra el puntaje promedio de todos los servicios.

Columnas:
servicio: ID del servicio.
puntaje_promedio: Puntaje promedio truncado a un decimal.
tiposervicio: Tipo de servicio.

Orden: Ascendente por puntaje_promedio.
*/
 CREATE OR REPLACE VIEW promedio_servicios AS
  SELECT  c.id_servicio as servicio,TRUNC(avg(c.puntaje),1) as puntaje_promedio,c.tiposervicio
FROM Calificaciones c
GROUP BY
    c.id_servicio,c.tiposervicio
ORDER BY
    puntaje_promedio ASC;
SELECT * FROM promedio_servicios;

/*
Vista: vw_historial_personal_reservas

Propósito: Muestra el historial de reservas gestionadas por el personal.

Columnas:
Dni_del_personal: DNI del personal.
Nombre_Completo: Nombre completo del personal.
Rol_del_personal: Rol del personal.
id_de_la_Reserva: ID de la reserva.
Estado_de_la_Reserva: Estado de la reserva.
Inicio_de_la_reserva: Fecha de inicio de la reserva.
Fin_de_la_reserva: Fecha de fin de la reserva.

*/
CREATE VIEW vw_historial_personal_reservas AS
SELECT p.dni_personal AS Dni_del_personal,
		CONCAT(p.nombre, ' ', p.apellido) AS Nombre_Completo,
		p.rol AS Rol_del_personal,
		r.id_reserva AS id_de_la_Reserva,
		r.estado AS Estado_de_la_Reserva,
		r.inicio_viaje AS Inicio_de_la_reserva,
		r.fin_viaje AS Fin_de_la_reserva
FROM personal p JOIN reservas r ON (p.dni_personal = r.dni_personal)
GROUP BY
    p.dni_personal, p.nombre, p.apellido, p.rol, r.id_reserva;


/*
Vista: vw_historial_personal_servicios

Propósito: Muestra el historial de servicios gestionados por el personal.

Columnas:
Dni_del_personal: DNI del personal.
Nombre_Completo: Nombre completo del personal.
Rol_del_personal: Rol del personal.
Salario_del_personal: Salario del personal.
Id_del_servicio: ID del servicio.
tipo_de_servicio: Tipo de servicio.
id_del_tipo_de_servicio: ID del tipo de servicio.
Estado_del_servicio: Estado del servicio.
precio_del_servicio: Precio del servicio.
*/
CREATE VIEW vw_historial_personal_servicios AS
SELECT p.dni_personal AS Dni_del_personal,
		CONCAT(p.nombre, ' ', p.apellido) AS Nombre_Completo,
		p.rol AS Rol_del_personal,
		p.salario AS Salario_del_personal,
		s.id_servicio AS Id_del_servicio,
		s.nombre AS tipo_de_servicio,
		CASE
			WHEN s.id_alojamiento IS NOT NULL THEN s.id_alojamiento::VARCHAR
	           	WHEN s.id_vehiculo_alquiler IS NOT NULL THEN s.id_vehiculo_alquiler::VARCHAR
	           	WHEN s.id_transporte IS NOT NULL THEN s.id_transporte::VARCHAR
	           	WHEN s.id_excursion IS NOT NULL THEN s.id_excursion::VARCHAR
		ELSE NULL
		END AS id_del_tipo_de_servicio,
		s.status AS Estado_del_servicio,
		s.precio AS precio_del_servicio

FROM personal p JOIN servicios s ON (p.dni_personal = s.dni_personal)
GROUP BY
    p.dni_personal, p.nombre, p.apellido, p.rol, s.id_servicio;

/*
Vista: vw_servicios

Propósito: Muestra todos los servicios disponibles.

Columnas:
Id_del_servicio: ID del servicio.
tipo_de_servicio: Tipo de servicio.
id_tipo_dservicio: ID del tipo de servicio.
detalle: detalles sobre el tipo de servicio.
Estado_del_servicio: Estado del servicio.
precio_del_servicio: Precio del servicio.
personal_del_servicio: Personal asignado al servicio.
*/
CREATE OR REPLACE VIEW vw_servicios AS
SELECT 
    s.id_servicio AS Id_del_servicio,
    s.nombre AS tipo_de_servicio,
    CASE 
        WHEN s.id_alojamiento IS NOT NULL THEN s.id_alojamiento::VARCHAR
        WHEN s.id_vehiculo_alquiler IS NOT NULL THEN s.id_vehiculo_alquiler::VARCHAR
        WHEN s.id_transporte IS NOT NULL THEN s.id_transporte::VARCHAR
        WHEN s.id_excursion IS NOT NULL THEN s.id_excursion::VARCHAR
        ELSE NULL
    END AS id_tipo_servicio,
    CASE
        WHEN s.id_alojamiento IS NOT NULL THEN
            CONCAT('Nombre: ', a.nombre, 
                   ', Capacidad: ', a.capacidad_personas, 
                   ', Precio/Dia: ', a.precio_por_dia,
                   ', Ubicacion: ', d.nombre)
        WHEN s.id_vehiculo_alquiler IS NOT NULL THEN
            CONCAT('Tipo: ', tv.categoria,  -- utilizando tipo_vehiculo
                   ', Ubicacion: ', d.nombre,
                   ', Modelo: ', v.modelo,
                   ', Capacidad: ', v.capacidad_personas,
                   ', Kilometraje: ', v.kilometraje)
        WHEN s.id_transporte IS NOT NULL THEN 
            CONCAT('Tipo: ', tv.categoria,  -- utilizando tipo_vehiculo
                   ', Origen: ', d.nombre,
                   ', Destino: ', d.nombre,
                   ', Fecha: ', TO_CHAR(tr.fecha_inicio, 'DD/MM/YYYY'), ' <-> ', TO_CHAR(tr.fecha_fin, 'DD/MM/YYYY'))
        WHEN s.id_excursion IS NOT NULL THEN 
            CONCAT('Destino: ', d.nombre,
                   ', Tipo: ', e.tipo_actividad,
                   ', Idioma: ', e.idioma,
                   ', Rec. edad: ', e.rest_edad,
                   ', Rest. salud:', e.rest_salud,
                   ', Fecha: ', TO_CHAR(e.fecha_inicio, 'DD/MM/YYYY'), ' <-> ', TO_CHAR(e.fecha_fin, 'DD/MM/YYYY'))
        ELSE NULL
    END AS detalles,
    s.precio AS precio_del_servicio,
    s.status AS Estado_del_servicio,
    s.dni_personal AS personal_del_servicio
FROM 
    servicios s
    LEFT JOIN alojamientos a ON a.id_alojamiento = s.id_alojamiento
    LEFT JOIN vehiculos_de_alquiler v ON s.id_vehiculo_alquiler = v.id_vehiculo
    LEFT JOIN excursiones e ON s.id_excursion = e.id
    LEFT JOIN transporte tr ON s.id_transporte = tr.id_transporte
    LEFT JOIN tipo_vehiculo tv ON (tv.id_tipo = v.tipo OR tv.id_tipo = tr.tipo)
	    LEFT JOIN destinos d ON 
        (d.id_destino = a.ubicacion OR 
         d.id_destino = v.ubicacion OR 
         d.id_destino = tr.origen OR
         d.id_destino = tr.destino OR 
         d.id_destino = e.destino)
ORDER BY 
    s.id_servicio, s.nombre, id_tipo_servicio;

/*
Vista: vw_servicios_activos

Propósito: Muestra los servicios activos.

Columnas:
Id_del_servicio: ID del servicio.
tipo_de_servicio: Tipo de servicio.
id_del_tipo_de_servicio: ID del tipo de servicio.
precio_del_servicio: Precio del servicio.
personal_del_servicio: Personal asignado al servicio.

Condición: status es verdadero.
*/
CREATE VIEW vw_servicios_activos AS
SELECT s.id_servicio AS Id_del_servicio,
		s.nombre AS tipo_de_servicio,
		CASE
			WHEN s.id_alojamiento IS NOT NULL THEN s.id_alojamiento::VARCHAR
           	WHEN s.id_vehiculo_alquiler IS NOT NULL THEN s.id_vehiculo_alquiler::VARCHAR
           	WHEN s.id_transporte IS NOT NULL THEN s.id_transporte::VARCHAR
           	WHEN s.id_excursion IS NOT NULL THEN s.id_excursion::VARCHAR
			ELSE NULL
		END AS id_del_tipo_de_servicio,
		s.precio AS precio_del_servicio,
		s.dni_personal AS personal_del_servicio
FROM servicios s
WHERE s.status = true
ORDER BY s.id_servicio, s.nombre, id_del_tipo_de_servicio

/*
Vista: vw_servicios_inactivos

Propósito: Muestra los servicios inactivos.

Columnas:
Id_del_servicio: ID del servicio.
tipo_de_servicio: Tipo de servicio.
id_del_tipo_de_servicio: ID del tipo de servicio.
precio_del_servicio: Precio del servicio.
personal_del_servicio: Personal asignado al servicio.

Condición: status es falso.
*/
CREATE VIEW vw_servicios_inactivos AS
SELECT s.id_servicio AS Id_del_servicio,
		s.nombre AS tipo_de_servicio,
		CASE
			WHEN s.id_alojamiento IS NOT NULL THEN s.id_alojamiento::VARCHAR
           	WHEN s.id_vehiculo_alquiler IS NOT NULL THEN s.id_vehiculo_alquiler::VARCHAR
           	WHEN s.id_transporte IS NOT NULL THEN s.id_transporte::VARCHAR
           	WHEN s.id_excursion IS NOT NULL THEN s.id_excursion::VARCHAR
			ELSE NULL
		END AS id_del_tipo_de_servicio,
		s.precio AS precio_del_servicio,
		s.dni_personal AS personal_del_servicio
FROM servicios s
WHERE s.status = false
ORDER BY s.id_servicio, s.nombre, id_del_tipo_de_servicio

/*
Vista: vw_cant_servicios_empleados

Propósito: Muestra la cantidad de servicios gestionados por cada empleado.

Columnas:
Dni_del_personal: DNI del personal.
Nombre_Completo: Nombre completo del personal.
Rol_del_personal: Rol del personal.
salario_del_personal: Salario del personal.
Cantidad_de_Servicios: Número de servicios gestionados.

*/
CREATE VIEW vw_cant_servicios_empleados AS
SELECT
    p.dni_personal AS Dni_del_personal,
    CONCAT(p.nombre, ' ', p.apellido) AS Nombre_Completo,
    p.rol AS Rol_del_personal,
	P.salario AS salario_del_personal,
    COUNT(s.id_servicio) AS Cantidad_de_Servicios
FROM
    personal p JOIN servicios s ON p.dni_personal = s.dni_personal
GROUP BY
    p.dni_personal, p.nombre, p.apellido, p.rol;

/*
Vista: vw_clientes_calificaciones

Propósito: Muestra las calificaciones dadas por los clientes.

Columnas:
dni: DNI del cliente.
nombre: Nombre del cliente.
puntaje: Puntaje dado.
id_servicio: ID del servicio calificado.

*/
CREATE VIEW vw_clientes_calificaciones AS

SELECT
    c.dni,
	c.nombre,
    cal.puntaje,
    cal.id_servicio
FROM
    calificaciones cal
JOIN
    clientes c
ON
    cal.id_cliente = c.dni;

/*
Vista: vw_servicios_alojamientos

Propósito: Muestra la relación entre servicios y alojamientos.

Columnas:
nombre: Nombre del alojamiento.
id_alojamiento: ID del alojamiento.
*/
CREATE VIEW vw_servicios_alojamientos AS

SELECT
    a.nombre,
    s.id_alojamiento
FROM
    servicios s
JOIN
    alojamientos a
ON
    s.id_alojamiento = a.id_alojamiento;
