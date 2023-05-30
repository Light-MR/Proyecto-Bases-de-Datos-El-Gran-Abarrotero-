--Mostrar el nombre y el precio de todos los productos electróncos de la marca apple.

select marc666666a,nombre,precio from ELECTRONICA where marca='APPLE';

-- mostrar nombre del producto,marca y cantidad total vendida, or66denados de manera descendente.
--select total.idproductonp,max(totalp) from
select nombre,marca,totales.totalvendidos from noperecedero natural join 
(select idproductonp,sum(cantidadproducto) totalvendidos from NOPERECEDERO natural join vendernp group by idproductonp) 
as totales order by totales.totalvendidos DESC;

--mostrar los nombres de productos perecederos que ya caducaron en la sucursal 'El Gran Abarrotero Guerrero'.
select nombre,cad.nombrep,fechacadcorta from sucursal natural join (select idsucursal,nombre as nombrep,fechacadcorta 
from poseerp natural join perecedero where fechacadcorta<(current_date)) as cad where nombre='El Gran Abarrotero Guerrero';

--Venta total de cada producto vendido el día 31 de mayo del 2023, así como su nombre y marca.

select productos.nombre,productos.marca,productos.preciototal as preciototalproducto,fechaventa from venta natural join (select nombre,marca,idventa, precio*cantidadproducto as preciototal from venderp natural join perecedero 
union select nombre,marca,idventa, precio*cantidadproducto as preciototal from vendernp natural join noperecedero
union select nombre,marca,idventa, precio*cantidadproducto as preciototal from vendere natural join electronica) as productos
where fechaventa='2023-05-31';
