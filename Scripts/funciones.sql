
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
