
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
