
/*
Trigger: nombre_servicio_trigger

Función Asociada: agregar_servicio_nombre
Propósito: Asigna un nombre al servicio basado en el tipo de servicio (alojamiento, vehículo de alquiler, transporte, excursión).
Evento: Se ejecuta antes de insertar o actualizar una fila en la tabla servicios.
Lógica: Determina el nombre del servicio según el ID no nulo y asigna un valor predeterminado de 'Otro' si no se encuentra un tipo específico.

*/
CREATE OR REPLACE FUNCTION agregar_servicio_nombre()
RETURN TRIGGER AS $$
BEGIN
	nombre = CASE
    WHEN id_alojamiento IS NOT NULL THEN 'Alojamiento'
    WHEN id_Vehiculo_alquiler IS NOT NULL THEN 'Vehiculo de Alquiler'
    WHEN id_transporte IS NOT NULL THEN 'Transporte'
    WHEN id_excursion IS NOT NULL THEN 'Excursion'
    ELSE 'Otro'
	END;

	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER nombre_servicio_trigger
BEFORE INSERT OR UPDATE ON servicios
FOR EACH ROW
EXECUTE FUNCTION agregar_servicio_nombre();

select * from

/*
Trigger: tr_actualizar_item_reserva_no_pagos

Función Asociada: actualizar_item_reserva_no_pagos
Propósito: Actualiza los registros en item_reserva con el nuevo id_servicio y precio si el servicio no ha sido pagado.
Evento: Se ejecuta después de insertar una fila en la tabla servicios.
Lógica: Busca el id_servicio anterior basado en el tipo de servicio y actualiza los registros correspondientes en item_reserva.
*/
-- Crear la función para actualizar los servicios no pagados
CREATE OR REPLACE FUNCTION actualizar_item_reserva_no_pagos()
RETURNS TRIGGER AS $$
BEGIN
    -- Verificamos si el servicio relacionado no ha sido pagado
    IF NOT EXISTS ( SELECT 1 FROM item_reserva i WHERE i.servicio = OLD.id_servicio AND i.paga = false) THEN
        -- Actualiza los servicios en item_reserva si no ha sido pagado
        UPDATE item_reserva
        SET id_servicio = NEW.id_servicio
        WHERE id_servicio = OLD.id_servicio;
    END IF;

	CALL sp_desabilitar_servicio(OLD.id_servicio);

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Crear la función para actualizar los servicios no pagados
CREATE OR REPLACE FUNCTION actualizar_item_reserva_no_pagos()
RETURNS TRIGGER AS $$
DECLARE
    vieja_id_servicio INTEGER;
BEGIN
    -- Determina el antiguo id_servicio para buscar los correspondientes precios a actualizar
    SELECT id_servicio INTO vieja_id_servicio
    FROM servicios
    WHERE
    	-- Determina el antiguo id_servicio según el tipo de servicio no nulo
        CASE
            WHEN NEW.id_excursion IS NOT NULL THEN id_excursion = NEW.id_excursion
            WHEN NEW.id_alojamiento IS NOT NULL THEN id_alojamiento = NEW.id_alojamiento
            WHEN NEW.id_vehiculo_alquiler IS NOT NULL THEN id_vehiculo_alquiler = NEW.id_vehiculo_alquiler
            WHEN NEW.id_transporte IS NOT NULL THEN id_transporte = NEW.id_transporte
        END
    ORDER BY id_servicio DESC
    LIMIT 1;

    -- Actualiza los registros en item_reserva con el nuevo id_servicio y precio
    UPDATE item_reserva
    SET id_servicio = NEW.id_servicio, precio = NEW.precio
    WHERE id_servicio = vieja_id_servicio;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger para ejecutar la función después de insertar en la tabla 'servicios'
CREATE TRIGGER tr_actualizar_item_reserva_no_pagos
AFTER INSERT ON servicios
FOR EACH ROW
EXECUTE FUNCTION actualizar_item_reserva_no_pagos();

select *
from seguroviaje

/*Trigger cuando se modifica una fila, se crea una nueva de servicio*/
CREATE OR REPLACE FUNCTION agregar_nueva_fila_servicio()
RETURNS TRIGGER AS $$
BEGIN
	CALL sp_desabilitar_servicio(OLD.id_servicio);

	IF (OLD.id_alojamiento IS NOT NULL) THEN
		CALL sp_agregar_servicio_tipo_alojamiento(OLD.id_servicio, OLD.id_alojamiento);
	ELSIF (OLD.id_excursion IS NOT NULL) THEN
		CALL sp_agregar_servicio_tipo_alojamiento(OLD.id_servicio, OLD.id_excursion);
	ELSIF (OLD.id_transporte IS NOT NULL) THEN
		CALL sp_agregar_servicio_tipo_alojamiento(OLD.id_servicio, OLD.id_transporte);
	ELSIF (OLD.id_vehiculo_alquiler IS NOT NULL) THEN
		CALL sp_agregar_servicio_tipo_alojamiento(OLD.id_servicio, OLD.id_vehiculo_alquiler);
	END IF;

	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

/*
Trigger: agregar_nueva_fila_servicio_trigger

Función Asociada: agregar_nueva_fila_servicio
Propósito: Deshabilita el servicio antiguo y agrega un nuevo servicio basado en el tipo de servicio modificado.
Evento: Se ejecuta antes de actualizar una fila en la tabla servicios.
Lógica: Llama a procedimientos almacenados específicos para deshabilitar el servicio antiguo y agregar uno nuevo según el tipo de servicio.
*/
CREATE TRIGGER agregar_nueva_fila_servicio_trigger
BEFORE UPDATE ON servicios
FOR EACH ROW
EXECUTE FUNCTION agregar_nueva_fila_servicio();


/*
Trigger: tr_actualizar_item_paquete_servicio

Función Asociada: actualizar_item_paquete_servicio
Propósito: Actualiza los registros en item_paquete con el nuevo id_servicio.
Evento: Se ejecuta después de insertar una fila en la tabla servicios.
Lógica: Determina el id_servicio anterior basado en el tipo de servicio y actualiza los registros correspondientes en item_paquete mediante la función actualizar_servicio_en_paquetes.
*/
CREATE OR REPLACE FUNCTION actualizar_item_paquete_servicio()
RETURNS TRIGGER AS $$
DECLARE
    vieja_id_servicio INTEGER;
BEGIN
    -- Determina el antiguo id_servicio para buscar los correspondientes filas item_paquetes a actualizar
    SELECT id_servicio INTO vieja_id_servicio
    FROM servicios
    WHERE
    	-- Determina el antiguo id_servicio según el tipo de servicio no nulo
        CASE
            WHEN NEW.id_excursion IS NOT NULL THEN id_excursion = NEW.id_excursion
            WHEN NEW.id_alojamiento IS NOT NULL THEN id_alojamiento = NEW.id_alojamiento
            WHEN NEW.id_vehiculo_alquiler IS NOT NULL THEN id_vehiculo_alquiler = NEW.id_vehiculo_alquiler
            WHEN NEW.id_transporte IS NOT NULL THEN id_transporte = NEW.id_transporte
        END
    ORDER BY id_servicio DESC
    LIMIT 1;

    -- Actualiza los registros en item_paquete con el nuevo id_servicio
	PERFORM actualizar_servicio_en_paquetes(vieja_id_servicio, NEW.id_servicio);

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tr_actualizar_item_paquete_servicio
AFTER INSERT ON servicios
FOR EACH ROW
EXECUTE FUNCTION actualizar_item_paquete_servicio();


/* Trigger que elimina una fila de servicio si no tiene ningún tipo de servicio asociado */
CREATE OR REPLACE FUNCTION eliminar_servicios_sin_tipo_servicio()
RETURNS TRIGGER AS $$
BEGIN
    IF (OLD.id_alojamiento IS NULL
        AND OLD.id_excursion IS NULL
        AND OLD.id_transporte IS NULL
        AND OLD.id_vehiculo_alquiler IS NULL) THEN
        PERFORM sp_eliminar_servicios(OLD.id_servicio);
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER tr_eliminar_servicios_sin_tipo_servicio
BEFORE UPDATE ON servicios
FOR EACH ROW
EXECUTE FUNCTION eliminar_servicios_sin_tipo_servicio();
/*trigger que le asigna el precio a itemproducto cuando se crea o modifica una fila
*/
CREATE OR REPLACE FUNCTION "ISFPP2024".agregar_precio_paquete_servicio()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
DECLARE
    nuevo_precio NUMERIC(40,2);
BEGIN
    -- Obtener el precio del servicio desde la tabla servicios
    SELECT precio
    INTO nuevo_precio
    FROM servicios
    WHERE id_servicio = NEW.id_servicio
    LIMIT 1;

    -- Actualizar el precio en la tabla item_paquete
    UPDATE item_paquete
    SET precio = nuevo_precio
    WHERE id_servicio = NEW.id_servicio
      AND id_paquete = NEW.id_paquete;

    RETURN NEW;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE NOTICE 'No se encontró el id_servicio % en la tabla servicios', NEW.id_servicio;
        RETURN NEW;
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Ocurrió un error inesperado: %', SQLERRM;
END;
$BODY$;

-- Crear el trigger asociado
CREATE TRIGGER trigger_agregar_precio_paquete_servicio
AFTER INSERT ON item_paquete
FOR EACH ROW
EXECUTE FUNCTION "ISFPP2024".agregar_precio_paquete_servicio();


/*trigger que le asigna el precio a itemreserva cuando se crea o modifica una fila
*/
CREATE OR REPLACE FUNCTION "ISFPP2024".agregar_precio_reserva_servicio()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
DECLARE
    nuevo_precio NUMERIC(40,2);
BEGIN
    -- Obtener el precio del servicio
    SELECT precio INTO nuevo_precio
    FROM "ISFPP2024".servicios
    WHERE id_servicio = NEW.id_servicio
    LIMIT 1;

    -- Actualizar el precio en reservas_servicios
    UPDATE "ISFPP2024".item_reserva
    SET precio = nuevo_precio
    WHERE id_reserva = NEW.id_reserva AND id_servicio = NEW.id_servicio;

    RETURN NEW;
EXCEPTION WHEN NO_DATA_FOUND THEN
    RAISE NOTICE 'No se encontró el id_servicio % en la tabla servicios', NEW.id_servicio;
    RETURN NEW;
WHEN OTHERS THEN
    RAISE EXCEPTION 'Ocurrió un error: %', SQLERRM;
END;
$BODY$;

ALTER FUNCTION "ISFPP2024".agregar_precio_reserva_servicio()
    OWNER TO estudiante;

/*
Trigger: trg_agregar_adicionales_paquete

Función Asociada: agregar_precio_adicionales_paquete
Propósito: agrega precio del seguro a adicionales paquete
*/

CREATE OR REPLACE FUNCTION agregar_precio_adicionales_paquete()
RETURNS TRIGGER AS $$
DECLARE
 nuevo_precio NUMERIC(40,2);
BEGIN
    SELECT precio INTO nuevo_precio
    FROM segurosviaje
    WHERE id_seguro = NEW.id_seguro
    LIMIT 1;

    UPDATE adicionales_paquete
    SET precio = nuevo_precio
    WHERE id_seguro = NEW.id_seguro AND id_paquete = NEW.id_paquete;

    RETURN NEW;

END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_agregar_adicionales_paquete
AFTER INSERT OR UPDATE On adicionales_paquete
FOR EACH ROW
EXECUTE FUNCTION agregar_precio_adicionales_paquete();

/*
Trigger: trg_agregar_adicionales_reserva

Función Asociada: agregar_precio_adicionales_reserva
Propósito: agrega precio del seguro a adicionales reserva
*/

CREATE OR REPLACE FUNCTION agregar_precio_adicionales_reserva()
RETURNS TRIGGER AS $$
DECLARE
 nuevo_precio NUMERIC(40,2);
BEGIN

    SELECT costo INTO nuevo_precio
    FROM "ISFPP2024".seguroviaje
    WHERE id_seguro = NEW.id_seguro
    LIMIT 1;

    UPDATE "ISFPP2024".adicionales_reserva
    SET precio = nuevo_precio
    WHERE id_seguro = NEW.id_seguro;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_agregar_adicionales_reserva
AFTER INSERT OR UPDATE On adicionales_reserva
FOR EACH ROW
EXECUTE FUNCTION agregar_precio_adicionales_reserva();


/*
Trigger: tr_validar_cliente_califica

Función Asociada: validar_cliente_puede_calificar
Propósito: verifica que la calificacion dada por un cliente sea valida
*/
CREATE OR REPLACE FUNCTION validar_cliente_puede_calificar()
RETURNS TRIGGER AS $$
BEGIN
    -- Verificar que el cliente tiene un viaje finalizado
    IF NOT EXISTS (
        SELECT 1
        FROM "ISFPP2024".reservas r
        WHERE r.dni_cliente = NEW.id_cliente
			AND r.estado = 1
          	AND r.fin_viaje < NOW()
    ) THEN
        RAISE EXCEPTION 'El cliente no puede calificar porque no tiene viajes finalizados';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

--trigger en la tabla calificaciones
CREATE TRIGGER tr_validar_cliente_califica
BEFORE INSERT OR UPDATE ON calificaciones
FOR EACH ROW
EXECUTE FUNCTION validar_cliente_puede_calificar();
