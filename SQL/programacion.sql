
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



