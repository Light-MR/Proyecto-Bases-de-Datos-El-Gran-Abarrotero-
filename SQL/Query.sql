select nombregerente as nombreempleado
from gerente
where nombregerente like 'C%'
union
select nombrecajero
from cajero
where nombrecajero like 'C%'
union
select nombreencargado
from encargado
where nombreencargado like 'C%';

select *
from cliente
where cast(fechanacimiento as char (10)) like '%-06-%';

(select * from perecedero where presentacion='lata') union (select * from NOPERECEDERO where presentacion='LATA') ;

(Select * from perecedero where fechacadcorta >= '2023-01-01' and fechacadcorta <= '2023-05-07' ) union (Select * from NOPERECEDERO where FECHACADLARGA >= '2023-01-01' and FECHACADLARGA <= '2023-05-07' );

select *
from cliente;
