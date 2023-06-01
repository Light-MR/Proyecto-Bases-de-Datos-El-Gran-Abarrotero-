
--mostrar la cantidad de productos electronicos que hay en la sucursal S.
create or replace procedure totalstock(S varchar) as
$$
declare
fila record;
cur_electronica cursor for select * from POSEERE where IDSUCURSAL=S;
-- variable stock en la cual iremos acumulando la cantidad en stock de cada producto.
stock int := 0;
begin 
open cur_electronica;
fetch cur_electronica into fila;
-- realizamos la operación de acumulación mientras aún haya filas.
while (found) loop
	  stock := stock + fila.CANTIDADESTOCK;
	  fetch cur_electronica into fila;  
end loop;
raise notice 'Cantidad total de productos electrónicos en la sucursal %: %:',S, stock;
end;
$$
language plpgsql;	 

--call totalstock('S-00007');

-- Verificar que los produtos perecederos en la sucursal 1 no caduquen en menos de 1 semana a partir de la fecha en que son 
--agregados.
create or replace function check_cad_suc1() returns trigger
as
$$
declare 
--variable que guardará la fecha de caducidad del producto.
fcc date;
begin 
    if(TG_OP='INSERT') then 
	    select fechacadcorta into fcc from perecedero natural join POSEERP
	    where idproductop = NEW.idproductop;
		--si la el producto es agregado a la sucursal S-0001, verificamos que su fecha de caducidad 
		--supere los 7 días desde que fue agregado.
		if (NEW.IDSUCURSAL='S-00001' and fcc<=(current_date + integer '7')) then
		    RAISE EXCEPTION 'la caducidad debe ser mayor a 7 días contando desde que se agrega el producto.';
		end if;
	end if;
	return null;
end;
$$
language plpgsql;
--realizamos pruebas.
create trigger cad_suc1
after insert on POSEERP
for each row
execute procedure check_cad_suc1();

insert into perecedero (idproductop, nombre, marca, precio, cantidad, descripcion, presentacion, fechapreparado, fechacadcorta, tiporefrigeracion) values ('P-00000003', 'CARNE PARA HAMBURGESA', 'STEAKOS', 88998, 22064, 'CARNES', 'plato', '2023-05-13', '2023-06-10', 'MAQUINA DE HIELO');

insert into POSEERP (IDSUCURSAL, IDPRODUCTOP, CANTIDADESTOCK) values ('S-00001', 'P-00000003', 368);
	
-- Funcion que nos da el numero de encargados de una sucursal
CREATE or replace FUNCTION cantidad_encargados(idsucursal_par CHAR(7))
RETURNS INTEGER
AS $$
DECLARE
    cantidad INTEGER;
BEGIN
    SELECT COUNT(*) INTO cantidad
    FROM encargado
    WHERE idsucursal = idsucursal_par;
    
    RETURN cantidad;
END;
$$
LANGUAGE plpgsql;
-- _____________________________________________________________________________________________
-- Funcion que devuelve una tabla con la cantidad de ventas por cajero en una sucursal
CREATE or replace FUNCTION cantidad_ventas(idsucursalC CHAR(7))
RETURNS table (idsucursal CHAR(7), curpcajero CHAR(18), numeroventas int)
as 
$$
    select idsucursal, curpcajero, count(*) as numeroventas
	from venta
	where idsucursal = idsucursalC
	group by idsucursal, curpcajero;
$$
language sql;
--Prueba
select* 
from  cantidad_ventas('S-00008');


-- Disparador para no permitir insertar ventas que no sean del día actual
-- Nota: Solo deberá activarse una vez poblada la base.
create or replace function checa_fecha_venta() returns trigger 
as
$$
declare 
	fv date;
begin
	if(TG_OP = 'INSERT') then 
		select fechaventa into fv from venta
		where idventa = new.idventa;
		if(fv != current_date ) then
			raise exception 'Solo se pueden agregar ventas del día actual';
		end if;
	end if;
	return null;
end;
$$
language plpgsql;

create trigger checa_fecha_venta
after insert on venta
for each row
execute procedure checa_fecha_venta();
-- Pruebas
-- insert rechazado
--insert into VENTA (IDVENTA, IDSUCURSAL, CURPCLIENTE, CURPCAJERO, FECHAVENTA, TICKET, FORMAPAGO) values ('V-12595307', 'S-00001', 'LWBX730531SOLWBE79', 'VCWN197579LMQCKJ11', '2023/04/06', 'ztlrumggdk', 'EFECTIVO');
-- insert aceptado (depende del dìa, por obvias razones)
--insert into VENTA (IDVENTA, IDSUCURSAL, CURPCLIENTE, CURPCAJERO, FECHAVENTA, TICKET, FORMAPAGO) values ('V-12595307', 'S-00001', 'LWBX730531SOLWBE79', 'VCWN197579LMQCKJ11', '2023/05/31', 'ztlrumggdk', 'EFECTIVO');

-- ____________________________________________________________________________________________________________

-- Disparador: No dejara actualizar la curp
CREATE OR REPLACE FUNCTION restringir_actualizacion_curp() RETURNS TRIGGER AS $$
BEGIN
  IF OLD.curpcliente <> NEW.curpcliente THEN
    RAISE EXCEPTION 'No se puede cambiar la CURP de un cliente';
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER restringir_actualizacion_curp_trigger
BEFORE UPDATE OF curpcliente ON cliente
FOR EACH ROW
EXECUTE PROCEDURE restringir_actualizacion_curp();

-- Prueba
-- UPDATE cliente
-- SET curpcliente = 'CURP098765FGGLAB56'
-- WHERE curpcliente = 'WFMP034982PYNOBI40';


-- Procedimiento almacenado para calcular el total de ventas (dinero) de un cajero en un día específico.
DROP PROCEDURE IF EXISTS calcula_cajero_ventas(CHAR(18), DATE);


CREATE OR REPLACE PROCEDURE calcula_cajero_ventas (
  _curpcajero CHAR(18),
  _fecha DATE
)
LANGUAGE plpgsql AS $$
DECLARE
  total_electronica INT;
  total_noperecedero INT;
  total_perecedero INT;
  total_ventas INT;
BEGIN
  SELECT COALESCE(SUM(e.precio * ve.cantidadproducto), 0) 
  INTO total_electronica
  FROM vendere ve 
  JOIN electronica e ON ve.idproductoe = e.idproductoe 
  WHERE ve.idventa IN (SELECT idventa FROM venta WHERE curpcajero = _curpcajero AND fechaventa = _fecha);

  SELECT COALESCE(SUM(np.precio * vnp.cantidadproducto), 0) 
  INTO total_noperecedero
  FROM vendernp vnp 
  JOIN noperecedero np ON vnp.idproductonp = np.idproductonp 
  WHERE vnp.idventa IN (SELECT idventa FROM venta WHERE curpcajero = _curpcajero AND fechaventa = _fecha);

  SELECT COALESCE(SUM(p.precio * vp.cantidadproducto), 0) 
  INTO total_perecedero
  FROM venderp vp 
  JOIN perecedero p ON vp.idproductop = p.idproductop 
  WHERE vp.idventa IN (SELECT idventa FROM venta WHERE curpcajero = _curpcajero AND fechaventa = _fecha);

  --Calculando el total de ventas sumando las tres categorías
  total_ventas := total_electronica + total_noperecedero + total_perecedero;

  RAISE NOTICE 'Curp Cajero: %, Fecha: %, Total Ventas Electronica $: %, Total Ventas No Perecedero $: %, Total Ventas Perecedero $: %, Total Ventas $: %', _curpcajero, _fecha, total_electronica, total_noperecedero, total_perecedero, total_ventas;
END;
$$;
-- prueba
CALL calcula_cajero_ventas('CCPX773939HDSYII53', '2023/09/22');

-- Funcion que nos da el numero de encargados de una sucursal
CREATE FUNCTION cantidad_encargados(idsucursal_par CHAR(7))
RETURNS INTEGER
AS $$
DECLARE
    cantidad INTEGER;
BEGIN
    SELECT COUNT(*) INTO cantidad
    FROM encargado
    WHERE idsucursal = idsucursal_par;
    
    RETURN cantidad;
END;
$$
LANGUAGE plpgsql;

CALL cantidad_encargados('S-00002')

-- Evitar el borrado de un cajero en caso de que no haya otro

CREATE TRIGGER evitar_eliminacion_c
BEFORE DELETE ON cajero
FOR EACH ROW
BEGIN
    DECLARE num_cajeros INT;

    -- Verificar si hay otros cajeros en la misma sucursal
    SELECT COUNT(*)
    INTO num_cajeros
    FROM cajero
    WHERE idsucursal = OLD.idsucursal
      AND curpcajero != OLD.curpcajero;

    -- Si no hay otro cajero, evitar la eliminación del cajero
    IF num_cajeros = 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'No se puede eliminar al unico cajero de la sucursal.';
    END IF;
END;

--Prueba 
DELETE FROM cajero WHERE curpcajero = ''KUQN504726AYRFCB98'';

--______________________________________________________________________________________________

-- Actualización de datos
-- Queremos eliminar de la base de datos aquellas personas que concluyeron el registro como cliente
-- pero que no concluyeron ninguna compra, puesto que no nos interesa guardar datos de personas que no son clientes.
delete from cliente
where curpcliente in
	(select curpcliente
	from
	(SELECT cliente.curpcliente, cliente.nombrecliente, cliente.paternocliente, cliente.maternocliente,
	       COUNT(venta.idventa) as total_compras
	FROM cliente
	LEFT JOIN venta ON venta.curpcliente = cliente.curpcliente
	GROUP BY cliente.curpcliente, cliente.nombrecliente, cliente.paternocliente, cliente.maternocliente
	ORDER BY total_compras asc) as Ventas
	where total_compras = 0);

--______________________________________________________________________________________________
-- Disparador :Verificar la disponibilidad de productos al insertar una nueva venta en la tabla vendernp, venderp, vendere
-- verificar que la cantidad de producto a vender no exceda la cantidad en stock en las tablas poseerp, poseernp y poseere.
CREATE OR REPLACE FUNCTION verificar_disponibilidad_np()
RETURNS TRIGGER
AS $$
DECLARE
    cantidad_vendida INT;
    cantidad_en_stock INT;
    id_sucursal CHAR(7);
BEGIN
    cantidad_vendida := NEW.cantidadproducto;

    -- Obtener el idsucursal de la tabla venta
    SELECT idsucursal INTO id_sucursal
    FROM venta
    WHERE idventa = NEW.idventa;

    SELECT cantidadestock INTO cantidad_en_stock
    FROM poseernp
    WHERE idsucursal = id_sucursal AND idproductonp = NEW.idproductonp;

    IF cantidad_vendida > cantidad_en_stock THEN
        RAISE EXCEPTION 'No hay suficientes productos en stock.';
    END IF;

    RETURN NEW;
END;
$$
LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS verificar_disponibilidad_np_trigger ON vendernp;
CREATE TRIGGER verificar_disponibilidad_np_trigger
BEFORE INSERT
ON vendernp
FOR EACH ROW
EXECUTE PROCEDURE verificar_disponibilidad_np();

-- Disparador :Verificar la disponibilidad de productos al insertar una nueva venta en la tabla venderp

CREATE OR REPLACE FUNCTION verificar_disponibilidad_p()
RETURNS TRIGGER
AS $$
DECLARE
    cantidad_vendida INT;
    cantidad_en_stock INT;
    id_sucursal CHAR(7);
BEGIN
    cantidad_vendida := NEW.cantidadproducto;

    -- Obtener el idsucursal de la tabla venta
    SELECT idsucursal INTO id_sucursal
    FROM venta
    WHERE idventa = NEW.idventa;

    SELECT cantidadestock INTO cantidad_en_stock
    FROM poseerp
    WHERE idsucursal = id_sucursal AND idproductop = NEW.idproductop;

    IF cantidad_vendida > cantidad_en_stock THEN
        RAISE EXCEPTION 'No hay suficientes productos en stock.';
    END IF;

    RETURN NEW;
END;
$$
LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS verificar_disponibilidad_p_trigger ON venderp;
CREATE TRIGGER verificar_disponibilidad_p_trigger
BEFORE INSERT
ON venderp
FOR EACH ROW
EXECUTE PROCEDURE verificar_disponibilidad_p();


-- Disparador :Verificar la disponibilidad de productos al insertar una nueva venta en la tabla vendere

CREATE OR REPLACE FUNCTION verificar_disponibilidad_e()
RETURNS TRIGGER
AS $$
DECLARE
    cantidad_vendida INT;
    cantidad_en_stock INT;
    id_sucursal CHAR(7);
BEGIN
    cantidad_vendida := NEW.cantidadproducto;

    -- Obtener el idsucursal de la tabla venta
    SELECT idsucursal INTO id_sucursal
    FROM venta
    WHERE idventa = NEW.idventa;

    SELECT cantidadestock INTO cantidad_en_stock
    FROM poseere
    WHERE idsucursal = id_sucursal AND idproductoe = NEW.idproductoe;

    IF cantidad_vendida > cantidad_en_stock THEN
        RAISE EXCEPTION 'No hay suficientes productos en stock.';
    END IF;

    RETURN NEW;
END;
$$
LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS verificar_disponibilidad_e_trigger ON vendere;
CREATE TRIGGER verificar_disponibilidad_e_trigger
BEFORE INSERT
ON vendere
FOR EACH ROW
EXECUTE PROCEDURE verificar_disponibilidad_e();


-- probar 
--insert into ELECTRONICA (idproductoe, nombre, marca, precio, cantidad, descripcion, categoria, consumowatts) values ('E-51148575', 'PROYECTOR MAX', 'STEREN', 7357, 80, 'LÍNEA MARRÓN', 'EQUIPO DE INFORMÁTICA Y TELECOMUNICACIONES', 1000);
--insert into POSEERE (IDSUCURSAL, IDPRODUCTOE, CANTIDADESTOCK) values ('S-00005', 'E-51148575', 212);
--insert into VENTA (IDVENTA, IDSUCURSAL, CURPCLIENTE, CURPCAJERO, FECHAVENTA, TICKET, FORMAPAGO) values ('V-22256667', 'S-00005', 'POXG122017UIVUDU28', 'LYMW190541NOCQMR49', '2023/02/17', 'oypztyklac', 'TARJETA');
-- Al ejecutar la linea siguiente se enviara un mensaje de error  'No hay suficientes productos en stock.'
--insert into VENDERE (IDVENTA, IDPRODUCTOE, CANTIDADPRODUCTO) values ('V-22256667', 'E-51148575', 378);


-- Procedimiento para: Obtener el total de ventas de cada producto en una sucursal específica:
DROP PROCEDURE IF EXISTS  total_ventas_sucursal(idsucursal CHAR(7));
CREATE OR REPLACE PROCEDURE total_ventas_sucursal(idsucursal CHAR(7))
LANGUAGE plpgsql
AS $$
DECLARE
    producto CHAR(10);
    total INT;
BEGIN
    FOR producto IN (SELECT DISTINCT idproductop FROM venderp)
    LOOP
        SELECT SUM(cantidadproducto) INTO total
        FROM venderp
        WHERE idproductop = producto AND idsucursal = idsucursal;

        RAISE NOTICE 'El total de ventas del producto % en la sucursal % es %.', producto, idsucursal, total;
    END LOOP;
END;
$$;

--Prueba
-- CALL total_ventas_sucursal('S-00004');


-- Procedimiento: Obtener la cantidad total de productos en stock de cada categoría (electronica) en una sucursal específica:

DROP PROCEDURE IF EXISTS  total_productos_categoria_sucursal(idsucursal CHAR(7));

CREATE OR REPLACE PROCEDURE total_productos_categoria_sucursal(sucursal_id CHAR(7))
LANGUAGE plpgsql
AS $$
DECLARE
    categoria_producto VARCHAR(50);
    total INT;
BEGIN
    FOR categoria_producto IN (SELECT DISTINCT categoria FROM electronica)
    LOOP
        SELECT SUM(cantidadestock) INTO total
        FROM poseere
        WHERE idsucursal = sucursal_id AND idproductoe IN (SELECT idproductoe FROM electronica WHERE categoria = categoria_producto);

        RAISE NOTICE 'Cantidad total de productos de categoría % en sucursal % es %.', categoria_producto, sucursal_id, total;
    END LOOP;
END;
$$;

-- Prueba 
-- call total_productos_categoria_sucursal('S-00004')