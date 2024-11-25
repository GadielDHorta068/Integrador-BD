--insert de empleados
CALL "ISFPP2024".sp_insertar_empleado(
    87654321,          -- DNI del empleado
    'guia',   -- Rol del empleado
    32000.00,          -- Salario del empleado
    'María',           -- Nombre del empleado
    'Gómez'            -- Apellido del empleado
);
--insert de servicios transporte
CALL "ISFPP2024".sp_insertar_servicio(
	null,
	null,
	20,
	null,
	12000
)
--insert de servicios vehiculo alquiler
CALL "ISFPP2024".sp_insertar_servicio(
	null,
 'AA-101-AA',
	null,
	null,
	15000
)
--insert de servicios alojamiento
CALL "ISFPP2024".sp_insertar_servicio(
	10,
    null,
	null,
	null,
	35000
)
--insert de servicio excursion
CALL "ISFPP2024".sp_insertar_servicio(
	null,
    null,
	null,
	10,
	5000
) 
--ejemplo sobrecarga 
CALL "ISFPP2024".sp_insertar_servicio(
	1,
    'AA-101-AA',
	3,
	10,
	5000
)

--insert de item reserva
CALL "ISFPP2024".sp_insertar_item_reserva(
	10,
	10
)
--insert de adicionales paquete
CALL "ISFPP2024".sp_insertar_adicionales_paquete(
	 10,
	9
);
--insert de adicionales reserva
CALL "ISFPP2024".sp_insertar_adicionales_reserva(
	 3,
	12
);
--insert calificacio invalida
CALL "ISFPP2024".sp_insertar_calificacion(
	23456789,
	9,
	'bueno',
	7);
	--insert calificacio valida
CALL "ISFPP2024".sp_insertar_calificacion(
	23456789,
	1,
	'regular',
	3);

