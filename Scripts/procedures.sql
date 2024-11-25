/*
sp_modificar_adicionales_paqute_seguro

Propósito: Modifica un adicional de seguro en la tabla adicionales_paquete.

Parámetros:
id_paquete: ID del paquete al que pertenece el adicional.
id_seguro_old: ID del seguro actual que se desea modificar.
id_seguro_new: Nuevo ID del seguro que reemplazará al actual.

Lógica:
Verifica si el id_paquete existe en la tabla paquetes. Si no existe, lanza una excepción indicando que el servicio no está activo o no existe.

Verifica si ambos id_seguro_old y id_seguro_new existen en la tabla seguroViaje. Si alguno no existe, lanza una excepción indicando que alguna ID de seguro es inválida.

Inserta un nuevo registro en la tabla adicionales_paquete con el id_paquete, id_reserva, y precio proporcionados.
*/
CREATE OR REPLACE PROCEDURE sp_modificar_adicionales_paqute_seguro(id_paquete INTEGER, id_seguro_old INTEGER, id_seguro_new INTEGER)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Validar que el paquete existe
    IF NOT EXISTS (SELECT 1 FROM adicionales_paquete WHERE id_paquete = $1) THEN
        RAISE EXCEPTION 'El paquete con ID % no está activo o no existe', id_paquete;
    END IF;

    -- Validar que los seguros existen
    IF NOT EXISTS (SELECT 1 FROM seguroViaje WHERE id_seguro = id_seguro_old) THEN
        RAISE EXCEPTION 'El seguro antiguo con ID % no existe', id_seguro_old;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM seguroViaje WHERE id_seguro = id_seguro_new) THEN
        RAISE EXCEPTION 'El seguro nuevo con ID % no existe', id_seguro_new;
    END IF;

    -- Actualizar el seguro en la tabla de adicionales
    UPDATE adicionales_paquete
    SET id_seguro = id_seguro_new
    WHERE id_seguro = id_seguro_old AND id_paquete = $1;

    -- Mensaje de confirmación
    RAISE NOTICE 'El seguro % fue reemplazado por el seguro % en el paquete %', id_seguro_old, id_seguro_new, id_paquete;

EXCEPTION
    WHEN foreign_key_violation THEN
        RAISE EXCEPTION 'Error: Se produjo una violación de clave foránea.';
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Ocurrió un error durante la operación: %', SQLERRM;
END;
$$;

/*
Procedimiento: sp_modificar_adicionales_precio

Propósito: Modifica el precio de un adicional de seguro en la tabla adicionales_paquete.

Parámetros:
id_paquete: ID del paquete.
id_seguro: ID del seguro.
precio: Nuevo precio del adicional.

Lógica: Verifica la existencia del paquete y seguro antes de actualizar el precio.
*/
CREATE OR REPLACE PROCEDURE sp_modificar_adicionales_precio(id_paquete INTEGER, id_seguro INTEGER, precio NUMERIC(40, 2))
LANGUAGE plpgsql
AS $$
BEGIN
    -- Validar existencia del paquete
    IF NOT EXISTS (SELECT 1 FROM paquetes p WHERE p.id_paquete = id_paquete) THEN
        RAISE EXCEPTION 'El paquete con ID % no existe', id_paquete;
    END IF;

    -- Validar existencia del seguro
    IF NOT EXISTS (SELECT 1 FROM seguroViaje v WHERE v.id_seguro = id_seguro) THEN
        RAISE EXCEPTION 'El seguro con ID % no existe', id_seguro;
    END IF;

	-- Actualizar el precio del adicional
    UPDATE adicionales_paquete pq
    SET pq.precio = $3
    WHERE pq.id_seguro = $2 AND pq.id_paquete = $1;

    -- Confirmar éxito de la operación
    RAISE NOTICE 'El precio del adicional ha sido modificado correctamente para el paquete % y seguro %', id_paquete, id_seguro;

	EXCEPTION
	WHEN foreign_key_violation THEN
		RAISE EXCEPTION 'Error: Se produjo una violación de clave foránea.';
	WHEN OTHERS THEN
	RAISE EXCEPTION 'Ocurrió un error durante la operación: %', SQLERRM;
END;
$$;

/*
Procedimiento: sp_eliminar_adicionales_paquete

Propósito: Elimina un adicional de seguro de la tabla adicionales_paquete.

Parámetros:
id_paquete: ID del paquete.
id_seguro: ID del seguro.

Lógica: Verifica la existencia del paquete y seguro antes de eliminar el adicional.
*/
CREATE or replace PROCEDURE sp_eliminar_adicionales_paquete( id_paquete INTEGER,id_seguro INTEGER)
LANGUAGE plpgsql
AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM paquetes WHERE id_paquetes = id_paquete) THEN
        RAISE EXCEPTION 'El servicio con ID % no está activo o no existe ', id_paquete;
    END IF;
	IF NOT EXISTS (SELECT 1 FROM seguroViaje WHERE id_seguro = id_seguro) THEN
        RAISE EXCEPTION 'El paquete con la ID % no existe', id_seguro;
    END IF;
	   DELETE from adicionales_paquete 	
	   WHERE id_seguro = $2 and id_paquetes = $1;

END;$$;

/*
Procedimiento: sp_eliminar_adicionales_reserva

Propósito: Elimina un adicional de seguro de la tabla adicionales_paquete.

Parámetros:
id_paquete: ID del paquete.
id_seguro: ID del seguro.

Lógica: Verifica la existencia del paquete y seguro antes de eliminar el adicional.
*/
CREATE or replace PROCEDURE sp_eliminar_adicionales_reserva( id_reserva INTEGER,id_seguro INTEGER)
LANGUAGE plpgsql
AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM reservas WHERE id_reserva = $1) THEN
        RAISE EXCEPTION 'El servicio con ID % no está activo o no existe ', id_paquete;
    END IF;
	IF NOT EXISTS (SELECT 1 FROM seguroViaje WHERE id_seguro = $2) THEN
        RAISE EXCEPTION 'El paquete con la ID % no existe', id_seguro;
    END IF;
	   DELETE from adicionales_reserva	
	   WHERE id_seguro = $2 and id_reserva = $1;

END;$$;

/*
Procedimiento: sp_insertar_calificacion

Propósito: Inserta una nueva calificación en la tabla Calificaciones.

Parámetros:
id_cliente: ID del cliente.
id_servicios: ID del servicio.
detalle: Detalle de la calificación.
puntaje: Puntaje de la calificación.
tipo: Tipo de servicio.

Lógica: Verifica si el servicio está activo antes de insertar la calificación.
*/
CREATE OR REPLACE PROCEDURE sp_insertar_calificacion(
    id_cliente INTEGER,
    id_servicios INTEGER,
    detalle varchar(50),
    puntaje INTEGER
)
LANGUAGE plpgsql
AS $$
BEGIN
   IF NOT EXISTS (
        SELECT 1
        FROM Servicios 
        WHERE id_servicio = id_servicios 
          AND status = TRUE
    ) THEN
        RAISE EXCEPTION 'El servicio con ID % no está activo o no existe.', id_servicios;
    END IF;

    -- Insertar en la tabla Calificaciones
    INSERT INTO Calificaciones (ID_cliente, ID_servicio, detalle, puntaje)
    VALUES (id_cliente, id_servicios, detalle, puntaje);

	EXCEPTION
		   WHEN foreign_key_violation THEN
            RAISE EXCEPTION 'Ese cliente no existe';

        WHEN others THEN
            -- Si ocurre un error, revertir la transacción
            RAISE EXCEPTION 'Ocurrió un error durante la operación: %', SQLERRM;
END;
$$;


/*
Procedimiento: sp_eliminar_calificacion

Propósito: Elimina una calificación de la tabla Calificaciones.

Parámetros:
id_s: ID del servicio.
id_cliente: ID del cliente.

Lógica: Elimina la calificación correspondiente al cliente y servicio especificados.
*/
CREATE OR REPLACE PROCEDURE sp_eliminar_calificacion(id_s INTEGER, id_cliente INTEGER)
LANGUAGE plpgsql
AS $$
BEGIN
    DELETE FROM Calificaciones c
    WHERE c.id_servicio = id_s AND c.id_cliente = id_cliente;

    RAISE NOTICE 'Calificación eliminada correctamente.';
EXCEPTION
    WHEN foreign_key_violation THEN
        RAISE WARNING 'No se puede eliminar la calificación debido a una restricción de clave foránea.';
    WHEN OTHERS THEN
        RAISE WARNING 'Ocurrió un error inesperado: %', SQLERRM;
END;
$$;

/*
Procedimiento: sp_añadir_empleado

Propósito: Añade un nuevo empleado a la tabla personal.

Parámetros:
dni: DNI del empleado.
rol: Rol del empleado.
salario: Salario del empleado.
nombre: Nombre del empleado.
apellido: Apellido del empleado.

Lógica: Inserta un nuevo registro en la tabla personal con los datos proporcionados.
*/
create or replace procedure sp_insertar_empleado(dni INTEGER,rol varchar(10),salario  double precision,nombre varchar(20),apellido varchar(20))
LANGUAGE plpgsql
AS $$
declare
begin
	IF rol IS NULL OR rol = '' THEN
    RAISE EXCEPTION 'El nombre no puede estar vacío';
	END IF;	
	IF nombre IS NULL OR nombre = '' THEN
    RAISE EXCEPTION 'El nombre no puede estar vacío';
	END IF;
	IF apellido IS NULL OR apellido = '' THEN
    RAISE EXCEPTION 'El apellido no puede estar vacío';
	END IF;

    BEGIN
    INSERT INTO "ISFPP2024".personal (dni_personal,rol,salario,nombre,apellido)
    VALUES (dni , INITCAP(rol) ,salario, INITCAP(nombre), INITCAP(apellido));
EXCEPTION
    WHEN others THEN
        -- Maneja cualquier error durante la operación
        RAISE EXCEPTION 'Ocurrió un error durante la operación: %', SQLERRM;
END;
end;
$$;



/*
Procedimiento: sp_personal_modificar_rol

Propósito: Modifica el rol de un empleado en la tabla personal.

Parámetros:
dni: DNI del empleado.
nuevo_rol: Nuevo rol del empleado.

Lógica: Actualiza el rol del empleado especificado.
*/
CREATE OR REPLACE PROCEDURE sp_personal_modificar_rol(
    dni INTEGER,
    nuevo_rol VARCHAR(10)
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Validar existencia del personal
    IF NOT EXISTS (SELECT 1 FROM personal WHERE dni_personal = dni) THEN
        RAISE EXCEPTION 'No existe un personal con el DNI %', dni;
    END IF;
	
    -- Actualizar el rol del personal
    UPDATE personal
    SET rol = nuevo_rol
    WHERE dni_personal = dni;
	
    -- Mensaje de confirmación
    RAISE NOTICE 'Rol actualizado correctamente para el personal, de DNI: %', dni;

	EXCEPTION
	WHEN OTHERS THEN
		RAISE EXCEPTION 'Ocurrió un error durante la operación: %', SQLERRM;
END;
$$;

/*
Procedimiento: sp_personal_modificar_salario

Propósito: Modifica el salario de un empleado en la tabla personal.

Parámetros:
dni: DNI del empleado.
nuevo_salario: Nuevo salario del empleado.

Lógica: Actualiza el salario del empleado especificado.
*/
CREATE or replace PROCEDURE sp_personal_modificar_salario(dni INTEGER,nuevo_salario double precision)
LANGUAGE plpgsql
AS $$
BEGIN
	 -- Validar existencia del personal
	IF NOT EXISTS (SELECT 1 FROM personal WHERE dni_personal = dni) THEN
        	RAISE EXCEPTION 'No existe un personal con el DNI %', dni;
    	END IF;

	UPDATE  personal 
	SET salario = nuevo_salario
	WHERE dni_personal = dni;

	 -- Mensaje de confirmación
    	RAISE NOTICE 'salario actualizado correctamente para el personal, de DNI: %', dni;

	EXCEPTION
	    WHEN OTHERS THEN
		RAISE EXCEPTION 'Ocurrió un error durante la operación: %', SQLERRM;
END;
$$; 

/*
Procedimiento: sp_personal_modificar_nombre

Propósito: Modifica el nombre de un empleado en la tabla personal.

Parámetros:
dni: DNI del empleado.
nuevo_nombre: Nuevo nombre del empleado.

Lógica: Actualiza el nombre del empleado especificado.
*/
CREATE or replace PROCEDURE sp_personal_modificar_nombre(dni INTEGER,nuevo_nombre varchar(20))
LANGUAGE plpgsql
AS $$
BEGIN
	-- Validar existencia del personal
    	IF NOT EXISTS (SELECT 1 FROM personal WHERE dni_personal = dni) THEN
	        RAISE EXCEPTION 'No existe un personal con el DNI %', dni;
    	END IF;
	
	UPDATE  personal
	SET nombre = nuevo_nombre
	WHERE dni_personal = dni;

	 -- Mensaje de confirmación
	RAISE NOTICE 'nombre actualizado correctamente para el personal, de DNI: %', dni;

	EXCEPTION
	    WHEN OTHERS THEN
		RAISE EXCEPTION 'Ocurrió un error durante la operación: %', SQLERRM;
END;
$$;

/*
Procedimiento: sp_personal_modificar_apellido

Propósito: Modifica el apellido de un empleado en la tabla personal.

Parámetros:
dni: DNI del empleado.
nuevo_apellido: Nuevo apellido del empleado.

Lógica: Actualiza el apellido del empleado especificado.
*/
CREATE or replace PROCEDURE sp_personal_modificar_apellido(dni INTEGER,nuevo_apellido varchar(20))
LANGUAGE plpgsql
AS $$
BEGIN
	-- Validar existencia del personal
    	IF NOT EXISTS (SELECT 1 FROM personal WHERE dni_personal = dni) THEN
        	RAISE EXCEPTION 'No existe un personal con el DNI %', dni;
    	END IF;
	
	UPDATE personal
	SET apellido = nuevo_apellido
	WHERE dni_personal = dni;

	-- Mensaje de confirmación
 	RAISE NOTICE 'nombre actualizado correctamente para el personal, de DNI: %', dni;

	EXCEPTION
	    WHEN OTHERS THEN
		RAISE EXCEPTION 'Ocurrió un error durante la operación: %', SQLERRM;
END;
$$;

/*
Procedimiento: sp_insertar_adicionales_paquete Crear un nuevo adicional

Propósito: Inserta un nuevo adicional en la tabla adicionales_seguro.

Parámetros:
id_seguroS: ID del seguro.
id_paqueteS: ID de la paquete.

Lógica: Verifica la existencia del seguro y reserva antes
*/
CREATE OR REPLACE PROCEDURE sp_insertar_adicionales_paquete(id_paqueteS INTEGER, id_seguroS INTEGER)
AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM paquetes WHERE id_paquetes = id_paqueteS) THEN
        RAISE EXCEPTION 'El servicio con ID % no está activo o no existe ', id_paquete;
    END IF;
	IF NOT EXISTS (SELECT 1 FROM seguroViaje WHERE id_seguro = id_seguroS) THEN
        RAISE EXCEPTION 'El paquete con la ID % no existe', id_seguro;
    END IF;

    INSERT INTO adicionales_paquete( id_seguro,id_paquete)
    VALUES (id_seguroS, id_paqueteS);
END;
$$ LANGUAGE plpgsql;

/*
Procedimiento: sp_insertar_adicionales_reserva Crear un nuevo adicional

Propósito: Inserta un nuevo adicional en la tabla adicionales_seguro.

Parámetros:
id_seguro: ID del seguro.
id_reserva: ID de la reserva.

Lógica: Verifica la existencia del seguro y reserva antes
*/
CREATE OR REPLACE PROCEDURE sp_insertar_adicionales_reserva(id_seguroS INTEGER, id_reservaS INTEGER, precio numeric)
AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM reservas WHERE id_reserva = id_reservaS) THEN
        RAISE EXCEPTION 'El servicio con ID % no está activo o no existe ', id_paquete;
    END IF;
	IF NOT EXISTS (SELECT 1 FROM seguroViaje WHERE id_seguro = id_seguroS) THEN
        RAISE EXCEPTION 'El paquete con la ID % no existe', id_seguro;
    END IF;

    INSERT INTO adicionales_reserva( id_seguro,id_reserva)
    VALUES (id_paqueteS, id_reservaS);
END;
$$ LANGUAGE plpgsql;

/*
Procedimiento: sp_actualizar_adicionales_reserva_precio

Propósito: Actualiza el precio o la reserva de un adicional en la tabla adicionales_seguro.

Parámetros:
id_seguro: ID del seguro.
id_reserva: ID de la reserva.
nuevo_precio: Nuevo precio del adicional.

Lógica: Verifica la existencia del seguro y reserva antes de actualizar el adicional.
*/
CREATE OR REPLACE PROCEDURE sp_actualizar_adicionales_reserva_precio(id_seguro INTEGER, id_reserva INTEGER, nuevo_precio NUMERIC)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Validar que el seguro existe
    IF NOT EXISTS (SELECT 1 FROM seguroviaje s WHERE s.id_seguro = id_seguro) THEN
        RAISE EXCEPTION 'El seguro con ID % no está activo o no existe', id_seguro;
    END IF;

    -- Validar que la reserva existe
    IF NOT EXISTS (SELECT 1 FROM reservas r WHERE r.id_reserva = id_reserva) THEN
        RAISE EXCEPTION 'La reserva con la ID % no existe', id_reserva;
    END IF;

    -- Actualizar el precio del adicional
    UPDATE adicionales_reserva re
    SET re.precio = $3 -- Usando alias $3 para nuevo_precio
    WHERE re.id_seguro = $1 AND re.id_reserva = $2;

    -- Mensaje de confirmación
    RAISE NOTICE 'Precio actualizado correctamente para el adicional con ID Seguro % y Reserva %', id_seguro, id_reserva;

	EXCEPTION
	    WHEN OTHERS THEN
	        -- Revertir los cambios en caso de error
	        RAISE EXCEPTION 'Ocurrió un error durante la operación: %', SQLERRM;
END;
$$;

/*
Procedimiento: sp_actualizar_adicionales_paquete_precio

Propósito: Actualiza el precio o la reserva de un adicional en la tabla adicionales_seguro.

Parámetros:
id_seguro: ID del seguro.
id_reserva: ID de la reserva.
nuevo_precio: Nuevo precio del adicional.

Lógica: Verifica la existencia del seguro y reserva antes de actualizar el adicional.
*/
CREATE OR REPLACE PROCEDURE sp_actualizar_adicionales_paquete_precio(id_seguro INTEGER, id_paquete INTEGER, nuevo_precio NUMERIC)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Validar que el seguro existe
    IF NOT EXISTS (SELECT 1 FROM seguroviaje s WHERE s.id_seguro = id_seguro) THEN
        RAISE EXCEPTION 'El seguro con ID % no está activo o no existe', id_seguro;
    END IF;

    -- Validar que la reserva existe
    IF NOT EXISTS (SELECT 1 FROM paquetes p WHERE p.id_paquete = id_paquete) THEN
        RAISE EXCEPTION 'La reserva con la ID % no existe', id_paquete;
    END IF;

    -- Actualizar el precio del adicional
    UPDATE adicionales_paquetes re
    SET re.precio = $3 -- Usando alias $3 para nuevo_precio
    WHERE re.id_seguro = $1 AND re.id_reserva = $2;

    -- Mensaje de confirmación
    RAISE NOTICE 'Precio actualizado correctamente para el adicional con ID Seguro % y Reserva %', id_seguro, id_reserva;

	EXCEPTION
	    WHEN OTHERS THEN
	        -- Revertir los cambios en caso de error
	        RAISE EXCEPTION 'Ocurrió un error durante la operación: %', SQLERRM;
END;
$$;

/*
Procedimiento: sp_Agregar_Servicio

Propósito: Agrega un nuevo servicio a la tabla Servicios.

Parámetros:
id_tipo_Servicio: ID del tipo de servicio.
tipo_servicio: Tipo de servicio.
precio: Precio del servicio.

Lógica: Llama a procedimientos específicos para agregar el servicio según su tipo.
*/
CREATE OR REPLACE PROCEDURE sp_Agregar_Servicio(id_tipo_Servicio INTEGER,tipo_servicio TEXT, precio double precision)
LANGUAGE plpgsql
AS $$
BEGIN
	IF (tipo_servicio IS NULL) THEN
		RAISE EXCEPTION 'Error a la hora de llamar al procedimiento, se debe especificar el tipo de servicio';
	ELSIF(id_tipo_servicio IS NULL) THEN
		RAISE EXCEPTION 'Error a la hora de llamar al procedimiento, la id dada es nula';
	END IF;

	IF (tipo_servicio = 'Alojamiento')THEN
		CALL Agregar_servicio_tipo_alojamiento(id_tipo_servicio, precio);
	ELSIF (tipo_servicio = 'Vehiculo alquiler') THEN
		CALL Agregar_servicio_tipo_Vehiculo_alquiler(id_tipo_servicio, precio);
	ELSIF (tipo_servicio = 'Trasporte') THEN
		CALL Agregar_servicio_tipo_Transporte(id_tipo_servicio, precio);
	ELSIF (tipo_servicio = 'Excurcion') THEN
		CALL Agregar_servicio_tipo_Excurcion(id_tipo_servicio, precio);
	END IF;
END;
$$;

/*
Procedimiento: sp_Agregar_Servicio

Propósito: Agrega un nuevo servicio a la tabla Servicios.

Parámetros:
id_alojamiento: ID del alojamiento.
id_VA: ID del vehículo de alquiler.
id_Transporte: ID del transporte.
id_Excurcion: ID de la excursión.
precio: Precio del servicio.

Lógica:
Calcula check_solo para asegurar que solo uno de los IDs de servicio es no nulo.
Lanza una excepción si más de un ID es no nulo o si todos son nulos.
Llama al procedimiento correspondiente para agregar el servicio según el tipo de ID no nulo.
*/
CREATE OR REPLACE PROCEDURE sp_insertar_servicio(id_alojamiento INTEGER, id_VA TEXT, id_Transporte INTEGER,
	id_Excurcion INTEGER, precio double precision)
	LANGUAGE plpgsql
AS $$
declare
	check_solo INTEGER;

BEGIN
    BEGIN
	check_solo := (id_VA IS NOT NULL)::int +
        		(id_Transporte IS NOT NULL)::int +
        		(id_Excurcion IS NOT NULL)::int +
        		(id_alojamiento IS NOT NULL)::int;

	IF (check_solo > 1) THEN
		RAISE EXCEPTION 'Error a la hora de llamar al procedimiento, solo uno de los tipos de servicios puede ser no nulo';
	ELSIF(check_solo < 1) THEN
		RAISE EXCEPTION 'Error a la hora de llamar al procedimiento, una de las IDs dadas debe ser no nula';
	END IF;

	IF (id_alojamiento IS NOT NULL)THEN
		CALL Agregar_servicio_tipo_alojamiento(id_alojamiento, precio);
	ELSIF (id_VA IS NOT NULL) THEN
		CALL Agregar_servicio_tipo_Vehiculo_alquiler(id_VA, precio);
	ELSIF (id_Transporte IS NOT NULL) THEN
		CALL Agregar_servicio_tipo_Transporte(id_Transporte, precio);
	ELSIF (id_excurcion IS NOT NULL) THEN
		CALL Agregar_servicio_tipo_Excurcion(id_Excurcion, precio);
	END IF;
EXCEPTION
        WHEN others THEN
            -- Si ocurre un error, revertir la transacción
            RAISE EXCEPTION 'Ocurrió un error durante la operación: %', SQLERRM;
    END;
END;
$$;


/*
Procedimiento: sp_Eliminar_Servicio

Propósito: Elimina un servicio de la tabla Servicios.

Parámetros:
id_servicio: ID del servicio a eliminar.
Lógica:
Verifica si el id_servicio es nulo y lanza una excepción si lo es.
Elimina el servicio con el id_servicio especificado.
*/
CREATE OR REPLACE PROCEDURE sp_Eliminar_Servicio(id_servicio INTEGER)
LANGUAGE plpgsql
AS $$
BEGIN
    IF id_servicio IS NULL THEN
        RAISE EXCEPTION 'La id de servicio dada es nula';
    ELSE
        BEGIN
            DELETE FROM servicio s WHERE s.id_servicio = id_servicio;
            RAISE NOTICE 'El servicio con id % fue eliminado correctamente.', id_servicio;
        EXCEPTION
            WHEN foreign_key_violation THEN
                RAISE WARNING 'No se puede eliminar el servicio con id % debido a restricciones de clave foránea.', id_servicio;
            WHEN OTHERS THEN
                RAISE WARNING 'Ocurrió un error inesperado: %', SQLERRM;
        END;
    END IF;
END;
$$;


/*
Procedimiento: sp_Desabilitar_Servicio

Propósito: Deshabilita un servicio, cambiando su estado a no disponible.

Parámetros:
id_servicio: ID del servicio a deshabilitar.

Lógica:
Verifica si el id_servicio es nulo y lanza una excepción si lo es.
Actualiza el estado del servicio a FALSE para deshabilitarlo.
*/
CREATE OR REPLACE PROCEDURE sp_Desabilitar_Servicio(id_servicio INTEGER)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Validar que la ID no sea nula
    IF $1 IS NULL THEN
        RAISE EXCEPTION 'La id de servicio dada es nula';
    END IF;

    -- Validar que exista el servicio
    IF NOT EXISTS (SELECT 1 FROM servicios WHERE servicios.id_servicio = $1) THEN
        RAISE EXCEPTION 'No se encontró el servicio con la id: %', $1;
    END IF;

    -- Cambiar el estado del servicio a falso
    UPDATE servicios
    SET status = FALSE
    WHERE servicios.id_servicio = $1;  -- Aquí estamos siendo explícitos con la tabla 'servicios'

EXCEPTION
    WHEN OTHERS THEN
        -- Manejo del error (sin ROLLBACK)
        RAISE EXCEPTION 'Ocurrió un error durante la operación: %', SQLERRM;
END;
$$;

/*
Procedimiento: sp_Modificar_Servicio_precio

Propósito: Modifica el precio de un servicio en la tabla Servicios.

Parámetros:
id_servicio: ID del servicio cuyo precio se desea modificar.
precio: Nuevo precio que se asignará al servicio.

Lógica:
Verifica si el id_servicio es nulo. Si es así, lanza una excepción indicando que el ID no puede ser nulo.
Intenta actualizar el precio del servicio en la tabla Servicios usando el id_servicio proporcionado.
Si no se encuentra ningún servicio con el id_servicio especificado, lanza una excepción indicando que el servicio no existe.

*/
CREATE OR REPLACE PROCEDURE sp_Modificar_Servicio_precio(id_servicio INTEGER, precio double precision)
LANGUAGE plpgsql
AS $$
BEGIN
	IF NOT EXISTS (SELECT 1 FROM servicios WHERE id_servicio = $1) THEN
    		RAISE EXCEPTION 'No se encontró el servicio con la id: %', $1;
	END IF;
    	-- Verificar si el id_servicio es nulo
    	IF id_servicio IS NULL THEN
        	RAISE EXCEPTION 'El id del servicio no puede ser nulo';
    	END IF;

    	-- Intentar actualizar el precio del servicio
    	UPDATE Servicios
    	SET precio = precio
    	WHERE id_servicio = $1;

	EXCEPTION
		WHEN OTHERS THEN
        	-- Revertir los cambios en caso de error
        	RAISE EXCEPTION 'Ocurrió un error durante la operación: %', SQLERRM;	
END;
$$;

/*
Procedimiento: sp_Agregar_servicio_tipo_alojamiento

Propósito: Agrega un servicio de tipo alojamiento.

Parámetros:
id_alojamiento: ID del alojamiento.
precio: Precio del servicio.

Lógica:
Verifica si el id_alojamiento es nulo y lanza una excepción si lo es.
Verifica la existencia del id_alojamiento en la tabla alojamientos.

Inserta el servicio si el ID es válido
*/
CREATE OR REPLACE PROCEDURE "ISFPP2024".sp_agregar_servicio_tipo_alojamiento(
	new_id_alojamiento integer,
	precio double precision)
LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
   BEGIN
        -- Validación del ID de alojamiento
        IF new_id_alojamiento IS NULL THEN
            RAISE EXCEPTION 'Error: la id de alojamiento es nula';
        END IF;

	    -- Inserción si el ID es válido
            INSERT INTO servicios (id_alojamiento, precio)
            VALUES (new_id_alojamiento, precio);

    EXCEPTION
	WHEN foreign_key_violation THEN
            RAISE EXCEPTION 'Error: El id de alojamiento no existe';
        -- Reversión en caso de error
        WHEN others THEN
            RAISE EXCEPTION 'Ocurrió un error durante la operación: %', SQLERRM;
    END;
END;
$BODY$;

/*
Procedimiento: sp_Agregar_servicio_tipo_Vehiculo_alquiler

Propósito: Agrega un servicio de tipo vehículo de alquiler.

Parámetros:
id_VA: ID del vehículo de alquiler.
precio: Precio del servicio.

Lógica:
Verifica si el id_VA es nulo y lanza una excepción si lo es.
Verifica la existencia del id_VA en la tabla Vehiculo_de_alquiler.
Inserta el servicio si el ID es válido.
*/
CREATE OR REPLACE PROCEDURE sp_Agregar_servicio_tipo_Vehiculo_alquiler(
    id_VA TEXT, 
    precio double precision
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Inicio de la transacción dentro del procedimiento
    BEGIN
        -- Validación del ID de vehículo
        IF id_VA IS NULL THEN
            RAISE EXCEPTION 'Error: la id de vehículo es nula';
        END IF;

        -- Si el ID existe, realizamos la inserción en la tabla Servicios
        INSERT INTO Servicios (id_vehiculo_alquiler, precio, status)
        VALUES (id_VA, precio, true);

    EXCEPTION
        WHEN foreign_key_violation THEN
            RAISE EXCEPTION 'Error: El id de vehículo de alquiler no existe';

        WHEN others THEN
            RAISE EXCEPTION 'Ocurrió un error durante la operación: %', SQLERRM;

    END;

END;
$$;
/*
Procedimiento: sp_Agregar_servicio_tipo_Excurcion

Propósito: Agrega un servicio de tipo excursión.

Parámetros:
id_Excurcion: ID de la excursión.
precio: Precio del servicio.

Lógica:
Verifica si el id_Excurcion es nulo y lanza una excepción si lo es.
Verifica la existencia del id_Excurcion en la tabla Excurcion.
Inserta el servicio si el ID es válido.
*/
CREATE OR REPLACE PROCEDURE sp_Agregar_servicio_tipo_Excurcion(id_Excurcion INTEGER, precio double precision, guia INTEGER, activo BOOLEAN)
LANGUAGE plpgsql
AS $$
BEGIN
	begin
    -- Validación del ID de excurción
    IF id_Excurcion IS NULL THEN
        RAISE EXCEPTION 'Error: la id de excurcion es nula';
    END IF;

	insert into servicios(id_excursion,precio,dni_personal,status)
	values (id_Excurcion,precio,guia,activo);

    EXCEPTION
        WHEN foreign_key_violation THEN
          	RAISE EXCEPTION 'El id de excurcion no existe';

        WHEN others THEN
            RAISE EXCEPTION 'Ocurrió un error durante la operación: %', SQLERRM;

    END;
END;
$$;

/*
Procedimiento: sp_Agregar_servicio_tipo_Transporte

Propósito: Agrega un servicio de tipo transporte.

Parámetros:
id_Transporte: ID del transporte.
precio: Precio del servicio.

Lógica:
Verifica si el id_Transporte es nulo y lanza una excepción si lo es.
Verifica la existencia del id_Transporte en la tabla Transporte.
Inserta el servicio si el ID es válido.
*/
CREATE OR REPLACE PROCEDURE sp_Agregar_servicio_tipo_Transporte(
    id_Transporte INTEGER, 
    precio double precision
)
LANGUAGE plpgsql
AS $$
BEGIN
    BEGIN
        -- Validación del ID de transporte
        IF id_Transporte IS NULL THEN
            RAISE EXCEPTION 'Error: la id de transporte es nula';
        END IF;

        -- Inserción en la tabla Servicios si el ID es válido
        INSERT INTO Servicios (id_Transporte, precio)
        VALUES (id_Transporte, precio);

    EXCEPTION
        WHEN foreign_key_violation THEN
            RAISE EXCEPTION 'El id de transporte no existe';

        WHEN others THEN
            RAISE EXCEPTION 'Ocurrió un error durante la operación: %', SQLERRM;
    END;
END;
$$;

