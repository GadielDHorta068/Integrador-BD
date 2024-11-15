/*
Procedimiento: sp_insertar_adicionales_seguro

Propósito: Inserta un nuevo adicional de seguro en la tabla adicionales_paquete.

Parámetros:
id_paqueteS: ID del paquete.
id_seguroS: ID del seguro.

Lógica: Verifica la existencia del paquete y seguro antes de insertar el adicional.

*/
CREATE or replace PROCEDURE sp_insertar_adicionales_seguro( id_paqueteS INTEGER,id_seguroS INTEGER)
LANGUAGE plpgsql
AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM paquetes WHERE id_paquetes = id_paqueteS) THEN
        RAISE EXCEPTION 'El servicio con ID % no está activo o no existe ', id_paquete;
    END IF;
	IF NOT EXISTS (SELECT 1 FROM seguroViaje WHERE id_seguro = id_seguroS) THEN
        RAISE EXCEPTION 'El paquete con la ID % no existe', id_seguro;
    END IF;

    INSERT INTO adicionales_paquete( id_seguro,id_reserva)
    VALUES (id_paqueteS, id_reserva);
END;$$;

/*
sp_modificar_adicionales_seguro

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
CREATE or replace PROCEDURE sp_modificar_adicionales_seguro( id_paquete INTEGER,id_seguro_old INTEGER,id_seguro_new INTEGER)
LANGUAGE plpgsql
AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM paquetes WHERE id_paquetes = id_paquete) THEN
        RAISE EXCEPTION 'El servicio con ID % no está activo o no existe ', id_paquete;
    END IF;
	IF NOT EXISTS (SELECT 2 FROM seguroViaje WHERE id_seguro = id_seguro_old or id_seguro_new) THEN
        RAISE EXCEPTION 'Error alguna id de seguro invalida % % ', id_seguro_old,id_seguro_new;
    END IF;

    INSERT INTO adicionales_paquete( id_seguro,id_reserva,  precio)
    VALUES (id_paquete, id_reserva, precio);

	UPDATE adicionales_paquete
	SET id_seguro = id_seguro_new
	WHERE id_seguro=id_seguro_old and id_paquetes=id_paquete;

END;$$;

/*
Procedimiento: sp_modificar_adicionales_precio

Propósito: Modifica el precio de un adicional de seguro en la tabla adicionales_paquete.

Parámetros:
id_paquete: ID del paquete.
id_seguro: ID del seguro.
precio: Nuevo precio del adicional.

Lógica: Verifica la existencia del paquete y seguro antes de actualizar el precio.
*/
CREATE or replace PROCEDURE sp_modificar_adicionales_precio( id_paquete INTEGER,id_seguro INTEGER,precio numeric(40,2))
LANGUAGE plpgsql
AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM paquetes WHERE id_paquetes = id_paquete) THEN
        RAISE EXCEPTION 'El servicio con ID % no está activo o no existe ', id_paquete;
    END IF;
	IF NOT EXISTS (SELECT 1 FROM seguroViaje WHERE id_seguro = id_seguro) THEN
        RAISE EXCEPTION 'El paquete con la ID % no existe', id_seguro;
    END IF;
	UPDATE adicionales_paquete
	SET precio=precio
	WHERE id_seguro=id_seguro and id_paquetes=id_paquete;

END;$$;


/*
Procedimiento: sp_eliminar_adicionales

Propósito: Elimina un adicional de seguro de la tabla adicionales_paquete.

Parámetros:
id_paquete: ID del paquete.
id_seguro: ID del seguro.

Lógica: Verifica la existencia del paquete y seguro antes de eliminar el adicional.
*/
CREATE or replace PROCEDURE sp_modificar_adicionales_precio( id_paquete INTEGER,id_seguro INTEGER)
LANGUAGE plpgsql
AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM paquetes WHERE id_paquetes = id_paquete) THEN
        RAISE EXCEPTION 'El servicio con ID % no está activo o no existe ', id_paquete;
    END IF;
	IF NOT EXISTS (SELECT 1 FROM seguroViaje WHERE id_seguro = id_seguro) THEN
        RAISE EXCEPTION 'El paquete con la ID % no existe', id_seguro;
    END IF;
	   delete from adicionales_paquete 	WHERE id_seguro=id_seguro and id_paquetes=id_paquete;

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
    puntaje INTEGER,
    tipo char(1)
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Verificar si el servicio está activo
    IF NOT EXISTS (SELECT 1 FROM Servicios WHERE id_servicio = id_servicios AND status = FALSE) THEN
        RAISE EXCEPTION 'El servicio con ID % no está activo o no existe.', id_servicio;
    END IF;

    -- Insertar en la tabla Calificaciones
    INSERT INTO Calificaciones (ID_cliente, ID_servicio, detalle, puntaje, TipoServicio)
    VALUES (id_cliente, id_servicios, detalle, puntaje, UPPER(tipo));
END;
$$;
SELECT proname, proargtypes FROM pg_proc WHERE proname = 'sp_insertar_calificacion';

CALL  sp_insertar_calificacion(12345678, 3, 'Deficiente', 2, 'E');

/*
Procedimiento: sp_eliminar_calificacion

Propósito: Elimina una calificación de la tabla Calificaciones.

Parámetros:
id_s: ID del servicio.
id_cliente: ID del cliente.

Lógica: Elimina la calificación correspondiente al cliente y servicio especificados.
*/

CREATE or replace PROCEDURE sp_eliminar_calificacion(id_s INTEGER,id_cliente INTEGER)
LANGUAGE plpgsql
AS $$
declare
BEGIN
   delete from Calificaciones c where c.id_servicio=id_s and c.id_cliente=id_cliente;
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
create or replace procedure sp_añadir_empleado(dni INTEGER,rol varchar(10),salario  double precision,nombre varchar(20),apellido varchar(20))
LANGUAGE plpgsql
AS $$
declare
begin
INSERT INTO Calificaciones (dni_personal,rol,salario,nombre,apellido)
    VALUES (dni , INITCAP(rol) ,salario, INITCAP(nombre), INITCAP(apellido));

end;
$$;


/*
Procedimiento: sp_eliminar_empleado

Propósito: Elimina un empleado y reasigna sus tareas a otro empleado.

Parámetros:
dni: DNI del empleado a eliminar.
nuevoEmpleado: DNI del empleado que asumirá las tareas.

Lógica: Actualiza las referencias al empleado en otras tablas y elimina el registro del empleado.
*/
CREATE or replace PROCEDURE sp_eliminar_empleado(dni INTEGER,nuevoEmpleado INTEGER)
LANGUAGE plpgsql
AS $$
BEGIN
    IF NOT EXISTS (SELECT FROM Servicios WHERE dni_personal =dni or dni_personal=nuevoEmpleado) THEN
        RAISE EXCEPTION 'Alguno de los dni no existe %,%',dni,nuevoEmpleado;
    END IF;

UPDATE servicios
SET dni_personal = nuevoEmpleado
WHERE dni_personal = dni;

UPDATE reservas
SET dni_personal = nuevoEmpleado
WHERE dni_personal = dni;

UPDATE excursiones
SET guia = nuevoEmpleado
WHERE guia = dni;
delete from personal where dni_personal=dni;
commit;
EXCEPTION
    WHEN foreign_key_violation THEN
        RAISE NOTICE 'Violación de clave foránea. No se puede actualizar el dni_personal a %', nuevoEmpleado;
    WHEN others THEN
        RAISE NOTICE 'Ocurrió un error inesperado: %', SQLERRM;
end;$$;


/*
Procedimiento: sp_personal_modificar_rol

Propósito: Modifica el rol de un empleado en la tabla personal.

Parámetros:
dni: DNI del empleado.
nuevo_rol: Nuevo rol del empleado.

Lógica: Actualiza el rol del empleado especificado.
*/
CREATE or replace PROCEDURE sp_personal_modificar_rol(dni INTEGER,nuevo_rol varchar(10))
LANGUAGE plpgsql
AS $$
declare
BEGIN
update  personal e
SET e.rol =nuevo_rol
WHERE e.dni_personal = dni;
end;$$;

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
declare
BEGIN
update  personal e
SET e.salario =nuevo_salario
WHERE e.dni_personal = dni;
end;
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
declare
BEGIN
update  personal e
SET e.nombre =nuevo_nombre
WHERE e.dni_personal = dni;
end;
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
declare
BEGIN
update  personal e
SET e.apellido =nuevo_apellido
WHERE e.dni_personal = dni;
end;
$$;

/*
Procedimiento: sp_insertar_adicionalCrear un nuevo adicional

Propósito: Inserta un nuevo adicional en la tabla adicionales_seguro.

Parámetros:
id_seguro: ID del seguro.
id_reserva: ID de la reserva.
precio: Precio del adicional.

Lógica: Verifica la existencia del seguro y reserva antes
*/
CREATE OR REPLACE PROCEDURE sp_insertar_adicional(id_seguro INTEGER, id_reserva INTEGER, precio numeric)
AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM "ISFPP2024".seguroviaje WHERE id_seguro = id_seguro) THEN
        RAISE EXCEPTION 'El seguro con ID % no está activo o no existe', id_seguro;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM "ISFPP2024".reservas WHERE id_reserva = id_reserva) THEN
        RAISE EXCEPTION 'La reserva con la ID % no existe', id_reserva;
    END IF;

    INSERT INTO "ISFPP2024".adicionales_seguro (id_seguro, id_reserva, precio)
    VALUES (id_seguro, id_reserva, precio);
END;
$$ LANGUAGE plpgsql;

/*
Procedimiento: sp_borrar_adicional

Propósito: Elimina un adicional de la tabla adicionales_seguro.
Parámetros:
id_seguro: ID del seguro.
id_reserva: ID de la reserva.

Lógica: Verifica la existencia del seguro y reserva antes de eliminar el adicional.
*/
CREATE OR REPLACE PROCEDURE sp_borrar_adicional(id_seguro INTEGER, id_reserva INTEGER)
AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM "ISFPP2024".seguroviaje WHERE id_seguro = id_seguro) THEN
        RAISE EXCEPTION 'El seguro con ID % no está activo o no existe', id_seguro;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM "ISFPP2024".reservas WHERE id_reserva = id_reserva) THEN
        RAISE EXCEPTION 'La reserva con la ID % no existe', id_reserva;
    END IF;

    DELETE FROM "ISFPP2024".adicionales_seguro
    WHERE id_seguro = id_seguro AND id_reserva = id_reserva;
END;
$$ LANGUAGE plpgsql;


/*
Procedimiento: sp_actualizar_adicional

Propósito: Actualiza el precio o la reserva de un adicional en la tabla adicionales_seguro.

Parámetros:
id_seguro: ID del seguro.
id_reserva: ID de la reserva.
nuevo_id_reserva: Nueva ID de la reserva (opcional).
nuevo_precio: Nuevo precio del adicional (opcional).

Lógica: Verifica la existencia del seguro y reserva antes de actualizar el adicional.
*/
CREATE OR REPLACE PROCEDURE sp_actualizar_adicional(id_seguro INTEGER, id_reserva INTEGER, nuevo_precio numeric)
AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM "ISFPP2024".seguroviaje WHERE id_seguro = id_seguro) THEN
        RAISE EXCEPTION 'El seguro con ID % no está activo o no existe', id_seguro;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM "ISFPP2024".reservas WHERE id_reserva = id_reserva) THEN
        RAISE EXCEPTION 'La reserva con la ID % no existe', id_reserva;
    END IF;

    UPDATE "ISFPP2024".adicionales_seguro
    SET precio = nuevo_precio
    WHERE id_seguro = id_seguro AND id_reserva = id_reserva;
END;
$$ LANGUAGE plpgsql;

/*
Sobrecarga del método para actualizar id_reserva, precio o ambos */
CREATE OR REPLACE PROCEDURE sp_actualizar_adicional(id_seguro INTEGER, id_reserva INTEGER, nuevo_id_reserva INTEGER DEFAULT NULL, nuevo_precio numeric DEFAULT NULL)
AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM "ISFPP2024".seguroviaje WHERE id_seguro = id_seguro) THEN
        RAISE EXCEPTION 'El seguro con ID % no está activo o no existe', id_seguro;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM "ISFPP2024".reservas WHERE id_reserva = id_reserva) THEN
        RAISE EXCEPTION 'La reserva con la ID % no existe', id_reserva;
    END IF;
    IF nuevo_id_reserva IS NOT NULL AND NOT EXISTS (SELECT 1 FROM "ISFPP2024".reservas WHERE id_reserva = nuevo_id_reserva) THEN
        RAISE EXCEPTION 'La nueva ID de reserva % no existe', nuevo_id_reserva;
    END IF;

    UPDATE "ISFPP2024".adicionales_seguro
    SET id_reserva = COALESCE(nuevo_id_reserva, id_reserva),
        precio = COALESCE(nuevo_precio, precio)
    WHERE id_seguro = id_seguro AND id_reserva = id_reserva;
END;$$ LANGUAGE plpgsql;

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
CREATE OR REPLACE PROCEDURE sp_Agregar_Servicio(id_alojamiento INTEGER, id_VA TEXT, id_Transporte INTEGER,
	id_Excurcion INTEGER, precio double precision)
	LANGUAGE plpgsql
AS $$
declare
	check_solo INTEGER;

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
	IF (id_servicio IS NULL) THEN
		RAISE EXCEPTION 'La id de servicio dada es nula';
	ELSE
		DELETE FROM servicio e WHERE e.id_servicio = id_servicio;
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
    IF id_servicio IS NULL THEN
        RAISE EXCEPTION 'La id de servicio dada es nula';
    ELSE
        -- Cambia el estado del servicio a falso
        UPDATE servicio
        SET status = FALSE
        WHERE id_servicio = id_servicio;
    END IF;
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
    -- Verificar si el id_servicio es nulo
    IF id_servicio IS NULL THEN
        RAISE EXCEPTION 'El id del servicio no puede ser nulo';
    END IF;

    -- Intentar actualizar el precio del servicio
    UPDATE Servicios
    SET precio = precio
    WHERE id_servicio = id_servicio;

    -- Comprobar si el servicio fue encontrado y actualizado
    IF NOT FOUND THEN
        RAISE EXCEPTION 'El servicio con id % no existe', id_servicio;
    END IF;
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
CREATE OR REPLACE PROCEDURE sp_Agregar_servicio_tipo_alojamiento(id_alojamiento INTEGER, precio double precision)
LANGUAGE plpgsql
AS $$
DECLARE
    chk_id INTEGER;
BEGIN
    -- Validación del ID de alojamiento
    IF id_alojamiento IS NULL THEN
        RAISE EXCEPTION 'Error: la id de alojamiento es nula';
    END IF;

    -- Verificación de existencia del ID en la tabla alojamientos
    SELECT id INTO chk_id FROM alojamientos WHERE id = id_alojamiento;

    -- Inserción si el ID es válido
    IF chk_id IS NOT NULL THEN
        INSERT INTO Servicios (id_alojamiento, id_VA, id_Transporte, id_Excurcion, precio)
        VALUES (id_alojamiento, NULL, NULL, NULL, precio);
    ELSE
        RAISE EXCEPTION 'El id de alojamiento no existe';
    END IF;
END;
$$;

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
CREATE OR REPLACE PROCEDURE sp_Agregar_servicio_tipo_Vehiculo_alquiler(id_VA TEXT, precio double precision)
LANGUAGE plpgsql
AS $$
DECLARE
    chk_id text;
BEGIN
    -- Validación del ID de vehículo
    IF id_VA IS NULL THEN
        RAISE EXCEPTION 'Error: la id de vehículo es nula';
    END IF;

    -- Verificación de existencia del ID en la tabla Vehiculo_de_alquiler
    SELECT id_Vehiculo INTO chk_id FROM Vehiculo_de_alquiler WHERE id_Vehiculo = id_VA;

    -- Inserción si el ID es válido
    IF chk_id IS NOT NULL THEN
        INSERT INTO Servicios (id_alojamiento, id_VA, id_Transporte, id_Excurcion, precio, status)
        VALUES (NULL, id_VA, NULL, NULL, precio, true);
    ELSE
        RAISE EXCEPTION 'El id de vehículo no existe';
    END IF;
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
CREATE OR REPLACE PROCEDURE sp_Agregar_servicio_tipo_Excurcion(id_Excurcion INTEGER, precio double precision)
LANGUAGE plpgsql
AS $$
DECLARE
    chk_id INTEGER;
BEGIN
    -- Validación del ID de excurción
    IF id_Excurcion IS NULL THEN
        RAISE EXCEPTION 'Error: la id de excurcion es nula';
    END IF;

    -- Verificación de existencia del ID en la tabla Excurcion
    SELECT id INTO chk_id FROM Excurcion WHERE id = id_Excurcion;

    -- Inserción si el ID es válido
    IF chk_id IS NOT NULL THEN
        INSERT INTO Servicios (id_alojamiento, id_VA, id_Transporte, id_Excurcion, precio)
        VALUES (NULL, NULL, NULL, id_Excurcion, precio);
    ELSE
        RAISE EXCEPTION 'El id de excurcion no existe';
    END IF;
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
CREATE OR REPLACE PROCEDURE sp_Agregar_servicio_tipo_Transporte(id_Transporte INTEGER, precio double precision)
LANGUAGE plpgsql
AS $$
DECLARE
    chk_id INTEGER;
BEGIN
    -- Validación del ID de transporte
    IF id_Transporte IS NULL THEN
        RAISE EXCEPTION 'Error: la id de transporte es nula';
    END IF;

    -- Verificación de existencia del ID en la tabla Transporte
    SELECT id INTO chk_id FROM Transporte WHERE id = id_Transporte;

    -- Inserción si el ID es válido
    IF chk_id IS NOT NULL THEN
        INSERT INTO Servicios (id_alojamiento, id_VA, id_Transporte, id_Excurcion, precio)
        VALUES (NULL, NULL, id_Transporte, NULL, precio);
    ELSE
        RAISE EXCEPTION 'El id de transporte no existe';
    END IF;
END;
$$;
