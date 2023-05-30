-- El correo de los cajeros que vendieron en la primera mitad del año en la sucursal del Distrito Federal
select idsucursal, correo, fechaventa
from correocajero
natural join venta
natural join sucursal
where estado = 'Distrito Federal' and fechaventa between '2023-01-01' and '2023-06-30';
