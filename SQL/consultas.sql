--Mostrar el nombre y el precio de todos los productos electróncos de la marca apple.

select marca,nombre,precio from ELECTRONICA where marca='APPLE';

-- mostrar nombre del producto,marca y cantidad total vendida, ordenados de manera descendente.
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




-- _________________________________________________________________________________________________________

-- Cantidad de productos vendidos por cada sucursal ordenados de manera descendente
SELECT sucursal.idsucursal, sucursal.nombre, 
       (COALESCE(SUM(venderp.cantidadproducto), 0) + 
        COALESCE(SUM(vendernp.cantidadproducto), 0) + 
        COALESCE(SUM(vendere.cantidadproducto), 0)) as total_vendidos
FROM sucursal 
LEFT JOIN venta ON venta.idsucursal = sucursal.idsucursal
LEFT JOIN venderp ON venderp.idventa = venta.idventa
LEFT JOIN vendernp ON vendernp.idventa = venta.idventa
LEFT JOIN vendere ON vendere.idventa = venta.idventa
GROUP BY sucursal.idsucursal, sucursal.nombre
ORDER BY total_vendidos DESC
--LIMIT 1;


--10 Clientes que han realizado el mayor numero de compras(ventas)

SELECT cliente.curpcliente, cliente.nombrecliente, cliente.paternocliente, cliente.maternocliente,
       COUNT(venta.idventa) as total_compras
FROM cliente
LEFT JOIN venta ON venta.curpcliente = cliente.curpcliente
GROUP BY cliente.curpcliente, cliente.nombrecliente, cliente.paternocliente, cliente.maternocliente
ORDER BY total_compras DESC
LIMIT 10;

-- Los 10 clientes que mas dinero  han gastado
SELECT cliente.curpcliente, cliente.nombrecliente, cliente.paternocliente, cliente.maternocliente,
       (COALESCE(SUM(venderp.cantidadproducto * perecedero.precio), 0) + 
        COALESCE(SUM(vendernp.cantidadproducto * noperecedero.precio), 0) + 
        COALESCE(SUM(vendere.cantidadproducto * electronica.precio), 0)) as total_gastado
FROM cliente
LEFT JOIN venta ON venta.curpcliente = cliente.curpcliente
LEFT JOIN venderp ON venderp.idventa = venta.idventa
LEFT JOIN perecedero ON perecedero.idproductop = venderp.idproductop
LEFT JOIN vendernp ON vendernp.idventa = venta.idventa
LEFT JOIN noperecedero ON noperecedero.idproductonp = vendernp.idproductonp
LEFT JOIN vendere ON vendere.idventa = venta.idventa
LEFT JOIN electronica ON electronica.idproductoe = vendere.idproductoe
GROUP BY cliente.curpcliente, cliente.nombrecliente, cliente.paternocliente, cliente.maternocliente
ORDER BY total_gastado DESC
LIMIT 10;

-- 15 estados que mas clientes tienen
SELECT estado, COUNT(*) as num_clientes
FROM cliente
GROUP BY estado
ORDER BY num_clientes DESC
LIMIT 15;

-- Ventas totales por dia (fecha)
SELECT fechaventa, COUNT(*) as ventas_totales
FROM venta
GROUP BY fechaventa
ORDER BY fechaventa;

-- ________________________________________________________________________