
/*
Función: fc_nro_transportes_activos

Propósito: Calcula la cantidad de transportes activos en la tabla servicios.
Retorno: Un entero que representa el número de transportes activos.
Lógica: Cuenta las filas en la tabla servicios donde id_transporte no es nulo y el status es verdadero.

*/
CREATE OR REPLACE FUNCTION fc_nro_transportes_activos()
RETURNS INTEGER
LANGUAGE plpgsql
AS $$
DECLARE
    contador INTEGER;
BEGIN
    SELECT COUNT(*) INTO contador
    FROM servicios
    WHERE id_transporte != null and  status = TRUE;

    RETURN contador;
END;
$$;

/*
Función: fc_nro_excursiones_activos

Propósito: Calcula el número de excursiones activas en la tabla servicios.
Retorno: Un entero que representa el número de excursiones activas.
Lógica: Cuenta las filas en la tabla servicios donde id_excursion no es nulo y el status es verdadero.
*/
CREATE OR REPLACE FUNCTION fc_nro_excursiones_activos()
RETURNS INTEGER
LANGUAGE plpgsql
AS $$
DECLARE
    contador INTEGER;
BEGIN
    SELECT COUNT(*) INTO contador
    FROM servicios
    WHERE id_excursion != null and  status = TRUE;

    RETURN contador;
END;
$$;


/*
Función: fc_nro_alojamientos_activos

Propósito: Calcula el número de alojamientos activos en la tabla servicios.
Retorno: Un entero que representa el número de alojamientos activos.
Lógica: Cuenta las filas en la tabla servicios donde id_alojamiento no es nulo y el status es verdadero.

*/
CREATE OR REPLACE FUNCTION fc_nro_alojamientos_activos()
RETURNS INTEGER
LANGUAGE plpgsql
AS $$
DECLARE
    alojamientos INTEGER;
BEGIN
    SELECT COUNT(*) INTO alojamientos
    FROM servicios
    WHERE id_alojamiento != null and  status = TRUE;

    RETURN alojamientos;
END;
$$;

/*
Función: fc_nro_vehiculo_alquiler_activos

Propósito: Calcula la cantidad de vehículos de alquiler activos en la tabla servicios.
Retorno: Un entero que representa el número de vehículos de alquiler activos.
Lógica: Cuenta las filas en la tabla servicios donde id_vehiculo_alquiler no es nulo y el status es verdadero.

*/
CREATE OR REPLACE FUNCTION fc_nro_vehiculo_alquiler_activos()
RETURNS INTEGER
LANGUAGE plpgsql
AS $$
DECLARE
    contador INTEGER;
BEGIN
    SELECT COUNT(*) INTO contador
    FROM servicios
    WHERE id_vehiculo_alquiler != null and  status = TRUE;

    RETURN contador;
END;
$$;
/*
Función: sf_servicios_por_reserva

Propósito: Recupera los servicios asociados a una reserva específica.

Parámetros:
    reserva_a_buscar: El ID de la reserva para la cual se desea obtener los servicios.

Columnas devueltas:
    tipo_de_servicio: Tipo de servicio asociado a la reserva.
    detalles: Detalles del servicio asociado a la reserva.
    precio: Precio del servicio asociado a la reserva.
*/

CREATE OR REPLACE FUNCTION "ISFPP2024".sf_servicios_por_reserva(IN reserva_a_buscar INTEGER)
RETURNS TABLE(tipo_de_servicio TEXT, detalles TEXT,precio double precision) 
LANGUAGE plpgsql
AS $$
BEGIN
  IF NOT EXISTS (
        SELECT 1
        FROM "ISFPP2024".vw_servicios_por_reserva r
        WHERE r.id_reserva = reserva_a_buscar
    ) THEN
        RAISE EXCEPTION 'No se encontraron servicios para la reserva con id_reserva: %', reserva_a_buscar;
    END IF;
    RETURN QUERY
    SELECT r.tipo_de_servicio, r.detalles,r.precio
    FROM "ISFPP2024".vw_servicios_por_reserva r
    WHERE r.id_reserva = reserva_a_buscar ;

END $$;
-- se llama asi
SELECT * FROM "ISFPP2024".sp_servicios_por_reserva(10);



/*
Funcion: fc_opiniones_servicio

Propósito: Devuelve las calificiaciones y los detalles de un servicio

Retorno: Devuelve una tabla

Logica:
*/

CREATE OR REPLACE FUNCTION "ISFPP2024".fc_opiniones_servicio(
    servicio_buscar INTEGER
)
RETURNS TABLE (
    Servicio TEXT,
    Nombre VARCHAR(30),
    Detalle VARCHAR(50),
    Puntaje SMALLINT
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF servicio_buscar IS NULL THEN
        RAISE EXCEPTION 'No se encuentra servicio con la id: %', servicio_buscar;
    END IF;

    RETURN QUERY
    SELECT
        sv.nombre   AS Servicio,
        cl.nombre   AS Nombre,
        cal.detalle AS Detalle,
        cal.puntaje AS Puntaje
    FROM "ISFPP2024".calificaciones cal
    JOIN "ISFPP2024".servicios sv
        ON cal.id_servicio = sv.id_servicio
    JOIN "ISFPP2024".clientes cl
        ON cal.id_cliente = cl.dni
    WHERE sv.id_servicio = servicio_buscar;
END;
$$;
