DROP SCHEMA IF EXISTS public CASCADE;
CREATE SCHEMA public;

CREATE TABLE sucursal(
	idsucursal CHAR(7),
	nombre VARCHAR(50),
	fechaapertura date,
	horaapertura time,
	horacierre time,
	estado  VARCHAR(50),
	municipio VARCHAR(50),
	ciudad  VARCHAR(50),
	colonia  VARCHAR(50),
	calle  VARCHAR(50),
	numero INT,
	codigopostal CHAR(5)
	
);

-- Restricciones sucursal

ALTER TABLE sucursal ALTER COLUMN idsucursal SET NOT NULL;
ALTER TABLE sucursal ADD CONSTRAINT idsucursalD1 CHECK (idsucursal SIMILAR TO 'S-[0-9]{5}');
ALTER TABLE sucursal ADD CONSTRAINT nombreD1 CHECK(nombre <> '');
ALTER TABLE sucursal ALTER COLUMN fechaapertura SET NOT NULL;
ALTER TABLE sucursal ALTER COLUMN horaapertura SET NOT NULL;
ALTER TABLE sucursal ALTER COLUMN horacierre SET NOT NULL;
ALTER TABLE sucursal ADD CONSTRAINT estadoD1 CHECK(estado <>'');
ALTER TABLE sucursal ADD CONSTRAINT municipioD1 CHECK(municipio <>'');
ALTER TABLE sucursal ADD CONSTRAINT ciudadD1 CHECK(ciudad <>'');
ALTER TABLE sucursal ADD CONSTRAINT coloniaD1 CHECK (colonia <>'');
ALTER TABLE sucursal ADD CONSTRAINT calleD1 CHECK(calle <>'');
ALTER TABLE sucursal ADD CONSTRAiNT codigopostalD1 CHECK(codigopostal SIMILAR TO '[0-9]{5}');
ALTER TABLE sucursal ADD CONSTRAiNT numeroD1 CHECK(numero between 0 and 99999);
--Entidad 
ALTER TABLE sucursal ADD CONSTRAINT idsucursalD2 UNIQUE(idsucursal);
ALTER TABLE sucursal ADD CONSTRAINT sucursal_pkey PRIMARY KEY (idsucursal);

comment on table sucursal is 'Tabla que contiene informaciòn sobre las sucursales del negocio';
comment on column sucursal.idsucursal is 'Identificador de la sucursal'; 
comment on column sucursal.nombre is 'Nombre de la sucursal'; 
comment on column sucursal.fechaapertura is 'Fecha de apertura de la sucursal'; 
comment on column sucursal.horaapertura is 'Hora de apertura de la sucursal'; 
comment on column sucursal.horacierre is 'Hora de cierre de la sucursal'; 
comment on column sucursal.estado is 'Estado donde se encuentra la sucursal'; 
comment on column sucursal.municipio is 'Municipio donde se encuentra la sucursal'; 
comment on column sucursal.ciudad is 'Ciudad donde se encuentra la sucursal'; 
comment on column sucursal.colonia is 'Colonia donde se encuentra la sucursal'; 
comment on column sucursal.calle is 'Calle donde se encuentra la sucursal'; 
comment on column sucursal.codigopostal is 'Codigo postal de donde se encuentra la sucursal'; 
comment on column sucursal.numero is 'Numero de edificio donde se encuentra la sucursal'; 
comment on constraint sucursal_pkey on sucursal is 'La llave primaria de la tabla sucursal';
comment on constraint idsucursalD1 on sucursal is 'Restriccion check que nos asegura que idsucursal sea de la forma que definimos los id';
comment on constraint idsucursalD2 on sucursal is 'Restriccion unique para el atributo idsucursal';
comment on constraint nombreD1 on sucursal is 'Restriccion check que nos asegura que nombre no sea la cadena vacía';
comment on constraint estadoD1 on sucursal is 'Restriccion check que nos asegura que estado no sea la cadena vacía';
comment on constraint municipioD1 on sucursal is 'Restriccion check que nos asegura que municipio no sea la cadena vacía';
comment on constraint ciudadD1 on sucursal is 'Restriccion check que nos asegura que ciudad no sea la cadena vacía';
comment on constraint coloniaD1 on sucursal is 'Restriccion check que nos asegura que colonia no sea la cadena vacía';
comment on constraint calleD1 on sucursal is 'Restriccion check que nos asegura que calle no sea la cadena vacía';
comment on constraint numeroD1 on sucursal is 'Restriccion check que nos asegura que numero está entre 0 y 99999';
comment on constraint codigopostalD1 on sucursal is 'Restriccion check que nos asegura que codigopostal sea de la forma indicada';

CREATE TABLE telefonosucursal(
	idsucursal CHAR(7),
	telefono CHAR(10) 
);

--Restricciones telefono
--Dominio
ALTER TABLE telefonosucursal ALTER COLUMN idsucursal SET NOT NULL;
ALTER TABLE telefonosucursal ADD CONSTRAINT tidsucursalD1 CHECK (idsucursal SIMILAR TO 'S-[0-9]{5}');
ALTER TABLE telefonosucursal ADD CONSTRAINT telefonoD1 CHECK (telefono SIMILAR TO '[0-9]{10}');

--Entidad
ALTER TABLE telefonosucursal ADD CONSTRAINT telefonosucursal_pkey PRIMARY KEY (idsucursal,telefono);

--Referencial
ALTER TABLE telefonosucursal ADD CONSTRAINT telefonosucursal_fkey FOREIGN KEY (idsucursal)
REFERENCES sucursal (idsucursal) ON UPDATE CASCADE ON DELETE CASCADE;

comment on table telefonosucursal is 'Tabla que contiene los numeros de telefono de las diferentes sucursales'; 
comment on column telefonosucursal.idsucursal is 'Identificador de la sucursal';
comment on column telefonosucursal.telefono is 'Numero de telefono de la sucursal';
comment on constraint telefonosucursal_pkey on telefonosucursal is 'La llave primaria de la tabla telefonosucursal';
comment on constraint telefonosucursal_fkey on telefonosucursal is 'La llave foránea de la tabla telefonosucursal';
comment on constraint tidsucursalD1 on telefonosucursal is 'Restriccion check que nos asegura que idsucursal sea de la forma que definimos los id';
comment on constraint telefonoD1 on telefonosucursal is 'Restriccion check de que el numero de telefono sea una sucesion de numeros y sean exactamente 10';


-----------------------------------------------------------------------------------------


CREATE TABLE cliente(
	curpcliente CHAR(18),
	nombrecliente VARCHAR(50),
	paternocliente VARCHAR(50),
	maternocliente VARCHAR(50),
	fechanacimiento date,
	estado  VARCHAR(50),
	ciudad  VARCHAR(50),
	colonia  VARCHAR(50),
	calle  VARCHAR(50),
	numero INT,
	codigopostal CHAR(5)
	
);

-- Restricciones cliente

ALTER TABLE cliente ALTER COLUMN curpcliente SET NOT NULL;
ALTER TABLE cliente ADD CONSTRAINT curpclienteD1 CHECK(CHAR_LENGTH(curpcliente)=18);
ALTER TABLE cliente ADD CONSTRAINT curpclienteD2 CHECK(curpcliente SIMILAR TO '[A-Z]{4}[0-9]{6}[A-Z]{6}[0-9]{2}');
ALTER TABLE cliente ADD CONSTRAINT nombreclienteD1 CHECK(nombrecliente <> '');
ALTER TABLE cliente ADD CONSTRAINT paternoclienteD1 CHECK(paternocliente <>'');
ALTER TABLE cliente ADD CONSTRAINT maternoclienteD1 CHECK(maternocliente <>'');
ALTER TABLE cliente ALTER COLUMN fechanacimiento SET NOT NULL;
ALTER TABLE cliente ADD CONSTRAINT estadoD1 CHECK(estado <>'');
ALTER TABLE cliente ADD CONSTRAINT ciudadD1 CHECK(ciudad <>'');
ALTER TABLE cliente ADD CONSTRAINT coloniaD1 CHECK (colonia <>'');
ALTER TABLE cliente ADD CONSTRAINT calleD1 CHECK(calle <>'');
ALTER TABLE cliente ADD CONSTRAiNT codigopostalD1 CHECK(codigopostal SIMILAR TO '[0-9]{5}');
ALTER TABLE cliente ADD CONSTRAiNT numeroD1 CHECK(numero between 0 and 99999);

ALTER TABLE cliente ADD CONSTRAINT curpclienteD3 UNIQUE(curpcliente);
ALTER TABLE cliente ADD CONSTRAINT cliente_pkey PRIMARY KEY (curpcliente);

comment on table cliente is 'Tabla que contiene la información de los clientes';
comment on column cliente.curpcliente is 'Curp del cliente';
comment on column cliente.nombrecliente is 'Nombre del cliente';
comment on column cliente.paternocliente is 'Apellido paterno del cliente';
comment on column cliente.maternocliente is 'Apellido materno del cliente';
comment on column cliente.fechanacimiento is 'Fecha de nacimiento del cliente';
comment on column cliente.estado is 'Estado de la direccion del cliente';  
comment on column cliente.ciudad is 'Ciudad de la direccion del cliente'; 
comment on column cliente.colonia is 'Colonia de la direccion del cliente'; 
comment on column cliente.calle is 'Calle de la direccion del cliente'; 
comment on column cliente.numero is 'Numero de edificio de la direccion del cliente'; 
comment on column cliente.codigopostal is 'Codigo postal de la direccion del cliente'; 
comment on constraint cliente_pkey on cliente is 'Identificador de la tabla cliente';
comment on constraint curpclienteD1 on cliente is 'Restriccion check que nos asegura que la cadena sea de longitud 18';
comment on constraint curpclienteD2 on cliente is 'Restriccion check que nos asegura que la cadena sea de la forma de un curp';
comment on constraint curpclienteD3 on cliente is 'Restriccion unique para el atributo curpcliente';
comment on constraint nombreclienteD1 on cliente is 'Restriccion check que nos asegura que nombrecliente no sea la cadena vacía';
comment on constraint paternoclienteD1 on cliente is 'Restriccion check que nos asegura que paternocliente no sea la cadena vacía';
comment on constraint maternoclienteD1 on cliente is 'Restriccion check que nos asegura que maternocliente no sea la cadena vacía';
comment on constraint estadoD1 on cliente is 'Restriccion check que nos asegura que estado no sea la cadena vacía';
comment on constraint ciudadD1 on cliente is 'Restriccion check que nos asegura que ciudad no sea la cadena vacía';
comment on constraint coloniaD1 on cliente is 'Restriccion check que nos asegura que colonia no sea la cadena vacía';
comment on constraint calleD1 on cliente is 'Restriccion check que nos asegura que calle no sea la cadena vacía';
comment on constraint numeroD1 on cliente is 'Restriccion check que nos asegura que numero está entre 0 y 99999';
comment on constraint codigopostalD1 on cliente is 'Restriccion check que nos asegura que codigopostal sea de la forma indicada';

CREATE TABLE telefonocliente(
	curpcliente CHAR(18),
	telefono CHAR(10) 
);

--Restricciones telefono
--Dominio
ALTER TABLE telefonocliente ALTER COLUMN curpcliente SET NOT NULL;
ALTER TABLE telefonocliente ADD CONSTRAINT tcurpclienteD1 CHECK(CHAR_LENGTH(curpcliente)=18);
ALTER TABLE telefonocliente ADD CONSTRAINT tcurpclienteD2 CHECK(curpcliente SIMILAR TO '[A-Z]{4}[0-9]{6}[A-Z]{6}[0-9]{2}');
ALTER TABLE telefonocliente ADD CONSTRAINT telefonoD1 CHECK (telefono SIMILAR TO '[0-9]{10}');

--Entidad
ALTER TABLE telefonocliente ADD CONSTRAINT telefonocliente_pkey PRIMARY KEY (curpcliente,telefono);

--Referencial
ALTER TABLE telefonocliente ADD CONSTRAINT telefonocliente_fkey FOREIGN KEY (curpcliente)
REFERENCES cliente (curpcliente) ON UPDATE CASCADE ON DELETE CASCADE;

comment on table telefonocliente is 'Tabla que contiene los numeros de telefono de los clientes'; 
comment on column telefonocliente.curpcliente is 'Curp del cliente';
comment on column telefonocliente.telefono is 'Numero de telefono del cliente';
comment on constraint telefonocliente_pkey on telefonocliente is 'La llave primaria de la tabla telefonocliente';
comment on constraint telefonocliente_fkey on telefonocliente is 'La llave foránea de la tabla telefonocliente';
comment on constraint tcurpclienteD1 on telefonocliente is 'Restriccion check que nos asegura que la cadena sea de longitud 18';
comment on constraint tcurpclienteD2 on telefonocliente is 'Restriccion check que nos asegura que la cadena sea de la forma de un curp';
comment on constraint telefonoD1 on telefonocliente is 'Restriccion check de que el numero de telefono sea una sucesion de numeros y sean exactamente 10';

CREATE TABLE correocliente(
	curpcliente CHAR(18),
	correo VARCHAR(50) 
);


--Dominio
ALTER TABLE correocliente ALTER COLUMN curpcliente SET NOT NULL;
ALTER TABLE correocliente ADD CONSTRAINT ccurpclienteD1 CHECK(CHAR_LENGTH(curpcliente)=18);
ALTER TABLE correocliente ADD CONSTRAINT ccurpclienteD2 CHECK(curpcliente SIMILAR TO '[A-Z]{4}[0-9]{6}[A-Z]{6}[0-9]{2}');

ALTER TABLE correocliente ADD CONSTRAINT correoclienteD1 CHECK(correo LIKE '_%@_%._%');

--Entidad
ALTER TABLE correocliente ADD CONSTRAINT correocliente_pkey PRIMARY KEY (curpcliente,correo);

--Referencial
ALTER TABLE correocliente ADD CONSTRAINT correocliente_fkey FOREIGN KEY (curpcliente)
REFERENCES cliente (curpcliente) ON UPDATE CASCADE ON DELETE CASCADE;

comment on table correocliente is 'Tabla que contiene los correos de los clientes'; 
comment on column correocliente.curpcliente is 'Curp del cliente';
comment on column correocliente.correo is 'Correo electronico del cliente';
comment on constraint correocliente_pkey on correocliente is 'La llave primaria de la tabla correocliente';
comment on constraint correocliente_fkey on correocliente is 'La llave foránea de la tabla correocliente';
comment on constraint ccurpclienteD1 on correocliente is 'Restriccion check que nos asegura que la cadena sea de longitud 18';
comment on constraint ccurpclienteD2 on correocliente is 'Restriccion check que nos asegura que la cadena sea de la forma de un curp';
comment on constraint correoclienteD1 on correocliente is 'Restriccion check de que el correo del cliente sea de la forma de un correo electrónico';

-----------------------------------------------------------------------------------------

CREATE TABLE cajero(
	curpcajero CHAR(18),
	idsucursal CHAR(7),
	nombrecajero VARCHAR(50),
	paternocajero VARCHAR(50),
	maternocajero VARCHAR(50),
	fechanacimiento date,
	estado  VARCHAR(50),
	ciudad  VARCHAR(50),
	colonia  VARCHAR(50),
	calle  VARCHAR(50),
	numero INT,
	codigopostal CHAR(5)
	
);

-- Restricciones cajero

ALTER TABLE cajero ALTER COLUMN curpcajero SET NOT NULL;
ALTER TABLE cajero ADD CONSTRAINT curpcajeroD1 CHECK(CHAR_LENGTH(curpcajero)=18);
ALTER TABLE cajero ADD CONSTRAINT curpcajeroD2 CHECK(curpcajero SIMILAR TO '[A-Z]{4}[0-9]{6}[A-Z]{6}[0-9]{2}');
ALTER TABLE cajero ALTER COLUMN idsucursal SET NOT NULL;
ALTER TABLE cajero ADD CONSTRAINT idsucursalD1 CHECK (idsucursal SIMILAR TO 'S-[0-9]{5}');
ALTER TABLE cajero ADD CONSTRAINT nombrecajeroD1 CHECK(nombrecajero <> '');
ALTER TABLE cajero ADD CONSTRAINT paternocajeroD1 CHECK(paternocajero <>'');
ALTER TABLE cajero ADD CONSTRAINT maternocajeroD1 CHECK(maternocajero <>'');
ALTER TABLE cajero ALTER COLUMN fechanacimiento SET NOT NULL;
ALTER TABLE cajero ADD CONSTRAINT estadoD1 CHECK(estado <>'');
ALTER TABLE cajero ADD CONSTRAINT ciudadD1 CHECK(ciudad <>'');
ALTER TABLE cajero ADD CONSTRAINT coloniaD1 CHECK (colonia <>'');
ALTER TABLE cajero ADD CONSTRAINT calleD1 CHECK(calle <>'');
ALTER TABLE cajero ADD CONSTRAiNT codigopostalD1 CHECK(codigopostal SIMILAR TO '[0-9]{5}');
ALTER TABLE cajero ADD CONSTRAiNT numeroD1 CHECK(numero between 0 and 99999);

--Entidad
ALTER TABLE cajero ADD CONSTRAINT curpcajeroD3 UNIQUE(curpcajero);
ALTER TABLE cajero ADD CONSTRAINT cajero_pkey PRIMARY KEY (curpcajero);

--Referencial
ALTER TABLE cajero ADD CONSTRAINT cajero_fkey FOREIGN KEY (idsucursal)
REFERENCES sucursal (idsucursal) ON UPDATE CASCADE ON DELETE CASCADE;

comment on table cajero is 'Tabla que contiene la información de los cajeros';
comment on column cajero.curpcajero is 'Curp del cajero';
comment on column cajero.idsucursal  is 'Identificador de la sucursal';
comment on column cajero.nombrecajero is 'Nombre del cajero';
comment on column cajero.paternocajero is 'Apellido paterno del cajero';
comment on column cajero.maternocajero is 'Apellido materno del cajero';
comment on column cajero.fechanacimiento is 'Fecha de nacimiento del cajero';
comment on column cajero.estado is 'Estado de la direccion del cajero';  
comment on column cajero.ciudad is 'Ciudad de la direccion del cajero'; 
comment on column cajero.colonia is 'Colonia de la direccion del cajero'; 
comment on column cajero.calle is 'Calle de la direccion del cajero'; 
comment on column cajero.numero is 'Numero de edificio de la direccion del cajero'; 
comment on column cajero.codigopostal is 'Codigo postal de la direccion del cajero'; 
comment on constraint cajero_pkey on cajero is 'Identificador de la tabla cajero';
comment on constraint cajero_fkey on cajero is 'La llave foránea de la tabla cajero';
comment on constraint curpcajeroD1 on cajero is 'Restriccion check que nos asegura que la cadena sea de longitud 18';
comment on constraint curpcajeroD2 on cajero is 'Restriccion check que nos asegura que la cadena sea de la forma de un curp';
comment on constraint curpcajeroD3 on cajero is 'Restriccion unique para el atributo curpcajero';
comment on constraint idsucursalD1 on cajero is 'Restriccion check que nos asegura que idsucursal sea de la forma que definimos los id';
comment on constraint nombrecajeroD1 on cajero is 'Restriccion check que nos asegura que nombrecliente no sea la cadena vacía';
comment on constraint paternocajeroD1 on cajero is 'Restriccion check que nos asegura que paternocliente no sea la cadena vacía';
comment on constraint maternocajeroD1 on cajero is 'Restriccion check que nos asegura que maternocliente no sea la cadena vacía';
comment on constraint estadoD1 on cajero is 'Restriccion check que nos asegura que estado no sea la cadena vacía';
comment on constraint ciudadD1 on cajero is 'Restriccion check que nos asegura que ciudad no sea la cadena vacía';
comment on constraint coloniaD1 on cajero is 'Restriccion check que nos asegura que colonia no sea la cadena vacía';
comment on constraint calleD1 on cajero is 'Restriccion check que nos asegura que calle no sea la cadena vacía';
comment on constraint numeroD1 on cajero is 'Restriccion check que nos asegura que numero está entre 0 y 99999';
comment on constraint codigopostalD1 on cajero is 'Restriccion check que nos asegura que codigopostal sea de la forma indicada';

CREATE TABLE telefonocajero(
	curpcajero CHAR(18),
	telefono CHAR(10) 
);

--Restricciones telefono
--Dominio
ALTER TABLE telefonocajero ALTER COLUMN curpcajero SET NOT NULL;
ALTER TABLE telefonocajero ADD CONSTRAINT tcurpcajeroD1 CHECK(CHAR_LENGTH(curpcajero)=18);
ALTER TABLE telefonocajero ADD CONSTRAINT tcurpcajeroD2 CHECK(curpcajero SIMILAR TO '[A-Z]{4}[0-9]{6}[A-Z]{6}[0-9]{2}');

ALTER TABLE telefonocajero ADD CONSTRAINT telefonoD1 CHECK (telefono SIMILAR TO '[0-9]{10}');

--Entidad
ALTER TABLE telefonocajero ADD CONSTRAINT telefonocajero_pkey PRIMARY KEY (curpcajero,telefono);

--Referencial
ALTER TABLE telefonocajero ADD CONSTRAINT telefonocajero_fkey FOREIGN KEY (curpcajero)
REFERENCES cajero (curpcajero) ON UPDATE CASCADE ON DELETE CASCADE;

comment on table telefonocajero is 'Tabla que contiene los numeros de telefono de los cajeros'; 
comment on column telefonocajero.curpcajero  is 'Curp del cajero';
comment on column telefonocajero.telefono is 'Numero de telefono del cajero';
comment on constraint telefonocajero_pkey on telefonocajero is 'La llave primaria de la tabla telefonocajero';
comment on constraint telefonocajero_fkey on telefonocajero is 'La llave foránea de la tabla telefonocajero';
comment on constraint tcurpcajeroD1 on telefonocajero is 'Restriccion check que nos asegura que la cadena sea de longitud 18';
comment on constraint tcurpcajeroD2 on telefonocajero is 'Restriccion check que nos asegura que la cadena sea de la forma de un curp';
comment on constraint telefonoD1 on telefonocajero is 'Restriccion check de que el numero de telefono sea una sucesion de numeros y sean exactamente 10';

CREATE TABLE correocajero(
	curpcajero CHAR(18),
	correo VARCHAR(50) 
);

--Restricciones correo
--Dominio
ALTER TABLE correocajero ALTER COLUMN curpcajero SET NOT NULL;
ALTER TABLE correocajero ADD CONSTRAINT ccurpcajeroD1 CHECK(CHAR_LENGTH(curpcajero)=18);
ALTER TABLE correocajero ADD CONSTRAINT ccurpcajeroD2 CHECK(curpcajero SIMILAR TO '[A-Z]{4}[0-9]{6}[A-Z]{6}[0-9]{2}');
ALTER TABLE correocajero ADD CONSTRAINT correocajeroD1 CHECK(correo LIKE '_%@_%._%');

--Entidad
ALTER TABLE correocajero ADD CONSTRAINT correocajero_pkey PRIMARY KEY (curpcajero,correo);

--Referencial
ALTER TABLE correocajero ADD CONSTRAINT correocajero_fkey FOREIGN KEY (curpcajero)
REFERENCES cajero (curpcajero) ON UPDATE CASCADE ON DELETE CASCADE;

comment on table correocajero is 'Tabla que contiene los correos de los cajeros'; 
comment on column correocajero.curpcajero is 'Curp del cajero';
comment on column correocajero.correo is 'Correo electronico del cajero';
comment on constraint correocajero_pkey on correocajero is 'La llave primaria de la tabla correocajero';
comment on constraint correocajero_fkey on correocajero is 'La llave foránea de la tabla correocajero';
comment on constraint ccurpcajeroD1 on correocajero is 'Restriccion check que nos asegura que la cadena sea de longitud 18';
comment on constraint ccurpcajeroD2 on correocajero is 'Restriccion check que nos asegura que la cadena sea de la forma de un curp';
comment on constraint correocajeroD1 on correocajero is 'Restriccion check de que el correo del cajero sea de la forma de un correo electrónico';

-----------------------------------------------------------------------------------------

CREATE TABLE encargado(
	curpencargado CHAR(18),
	idsucursal CHAR(7),
	nombreencargado VARCHAR(50),
	paternoencargado VARCHAR(50),
	maternoencargado VARCHAR(50),
	fechanacimiento date,
	estado  VARCHAR(50),
	ciudad  VARCHAR(50),
	colonia  VARCHAR(50),
	calle  VARCHAR(50),
	numero INT,
	codigopostal CHAR(5)
	
);

-- Restricciones encargado

ALTER TABLE encargado ALTER COLUMN curpencargado SET NOT NULL;
ALTER TABLE encargado ADD CONSTRAINT curpencargadoD1 CHECK(CHAR_LENGTH(curpencargado)=18);
ALTER TABLE encargado ADD CONSTRAINT curpencargadoD2 CHECK(curpencargado SIMILAR TO '[A-Z]{4}[0-9]{6}[A-Z]{6}[0-9]{2}');
ALTER TABLE encargado ALTER COLUMN idsucursal SET NOT NULL;
ALTER TABLE encargado ADD CONSTRAINT idsucursalD1 CHECK (idsucursal SIMILAR TO 'S-[0-9]{5}');
ALTER TABLE encargado ADD CONSTRAINT nombreencargadoD1 CHECK(nombreencargado <> '');
ALTER TABLE encargado ADD CONSTRAINT paternoencargadoD1 CHECK(paternoencargado <>'');
ALTER TABLE encargado ADD CONSTRAINT maternoencargadoD1 CHECK(maternoencargado <>'');
ALTER TABLE encargado ALTER COLUMN fechanacimiento SET NOT NULL;
ALTER TABLE encargado ADD CONSTRAINT estadoD1 CHECK(estado <>'');
ALTER TABLE encargado ADD CONSTRAINT ciudadD1 CHECK(ciudad <>'');
ALTER TABLE encargado ADD CONSTRAINT coloniaD1 CHECK (colonia <>'');
ALTER TABLE encargado ADD CONSTRAINT calleD1 CHECK(calle <>'');
ALTER TABLE encargado ADD CONSTRAiNT codigopostalD1 CHECK(codigopostal SIMILAR TO '[0-9]{5}');
ALTER TABLE encargado ADD CONSTRAiNT numeroD1 CHECK(numero between 0 and 99999);

--Entidad
ALTER TABLE encargado ADD CONSTRAINT curpencargadoD3 UNIQUE(curpencargado);
ALTER TABLE encargado ADD CONSTRAINT encargado_pkey PRIMARY KEY (curpencargado);

--Referencial
ALTER TABLE encargado ADD CONSTRAINT encargado_fkey FOREIGN KEY (idsucursal)
REFERENCES sucursal (idsucursal) ON UPDATE CASCADE ON DELETE CASCADE;

comment on table encargado is 'Tabla que contiene la información de los encargados';
comment on column encargado.curpencargado is 'Curp del encargado';
comment on column encargado.idsucursal  is 'Identificador de la sucursal';
comment on column encargado.nombreencargado is 'Nombre del encargado';
comment on column encargado.paternoencargado is 'Apellido paterno del encargado';
comment on column encargado.maternoencargado is 'Apellido materno del encargado';
comment on column encargado.fechanacimiento is 'Fecha de nacimiento del encargado';
comment on column encargado.estado is 'Estado de la direccion del encargado';  
comment on column encargado.ciudad is 'Ciudad de la direccion del encargado'; 
comment on column encargado.colonia is 'Colonia de la direccion del encargado'; 
comment on column encargado.calle is 'Calle de la direccion del encargado'; 
comment on column encargado.numero is 'Numero de edificio de la direccion del encargado'; 
comment on column encargado.codigopostal is 'Codigo postal de la direccion del encargado'; 
comment on constraint encargado_pkey on encargado is 'Identificador de la tabla encargado';
comment on constraint encargado_fkey on encargado is 'La llave foránea de la tabla encargado';
comment on constraint curpencargadoD1 on encargado is 'Restriccion check que nos asegura que la cadena sea de longitud 18';
comment on constraint curpencargadoD2 on encargado is 'Restriccion check que nos asegura que la cadena sea de la forma de un curp';
comment on constraint curpencargadoD3 on encargado is 'Restriccion unique para el atributo curpencargado';
comment on constraint idsucursalD1 on encargado is 'Restriccion check que nos asegura que idsucursal sea de la forma que definimos los id';
comment on constraint nombreencargadoD1 on encargado is 'Restriccion check que nos asegura que nombrecliente no sea la cadena vacía';
comment on constraint paternoencargadoD1 on encargado is 'Restriccion check que nos asegura que paternocliente no sea la cadena vacía';
comment on constraint maternoencargadoD1 on encargado is 'Restriccion check que nos asegura que maternocliente no sea la cadena vacía';
comment on constraint estadoD1 on encargado is 'Restriccion check que nos asegura que estado no sea la cadena vacía';
comment on constraint ciudadD1 on encargado is 'Restriccion check que nos asegura que ciudad no sea la cadena vacía';
comment on constraint coloniaD1 on encargado is 'Restriccion check que nos asegura que colonia no sea la cadena vacía';
comment on constraint calleD1 on encargado is 'Restriccion check que nos asegura que calle no sea la cadena vacía';
comment on constraint numeroD1 on encargado is 'Restriccion check que nos asegura que numero está entre 0 y 99999';
comment on constraint codigopostalD1 on encargado is 'Restriccion check que nos asegura que codigopostal sea de la forma indicada';

CREATE TABLE telefonoencargado(
	curpencargado CHAR(18),
	telefono CHAR(10) 
);

--Restricciones telefono
--Dominio
ALTER TABLE telefonoencargado ALTER COLUMN curpencargado SET NOT NULL;
ALTER TABLE telefonoencargado ADD CONSTRAINT tcurpencargadoD1 CHECK(CHAR_LENGTH(curpencargado)=18);
ALTER TABLE telefonoencargado ADD CONSTRAINT tcurpencargadoD2 CHECK(curpencargado SIMILAR TO '[A-Z]{4}[0-9]{6}[A-Z]{6}[0-9]{2}');
ALTER TABLE telefonoencargado ADD CONSTRAINT telefonoD1 CHECK (telefono SIMILAR TO '[0-9]{10}');

--Entidad
ALTER TABLE telefonoencargado ADD CONSTRAINT telefonoencargado_pkey PRIMARY KEY (curpencargado,telefono);

--Referencial
ALTER TABLE telefonoencargado ADD CONSTRAINT telefonoencargado_fkey FOREIGN KEY (curpencargado)
REFERENCES encargado (curpencargado) ON UPDATE CASCADE ON DELETE CASCADE;

comment on table telefonoencargado is 'Tabla que contiene los numeros de telefono de los encargados'; 
comment on column telefonoencargado.curpencargado is 'Curp del encargado';
comment on column telefonoencargado.telefono is 'Numero de telefono del encargado';
comment on constraint telefonoencargado_pkey on telefonoencargado is 'La llave primaria de la tabla telefonoencargado';
comment on constraint telefonoencargado_fkey on telefonoencargado is 'La llave foránea de la tabla telefonoencargado';
comment on constraint tcurpencargadoD1 on telefonoencargado is 'Restriccion check que nos asegura que la cadena sea de longitud 18';
comment on constraint tcurpencargadoD2 on telefonoencargado is 'Restriccion check que nos asegura que la cadena sea de la forma de un curp';
comment on constraint telefonoD1 on telefonoencargado is 'Restriccion check de que el numero de telefono sea una sucesion de numeros y sean exactamente 10';

CREATE TABLE correoencargado(
	curpencargado CHAR(18),
	correo VARCHAR(50) 
);

--Restricciones correo
--Dominio
ALTER TABLE correoencargado ALTER COLUMN curpencargado SET NOT NULL;
ALTER TABLE correoencargado ADD CONSTRAINT ccurpencargadoD1 CHECK(CHAR_LENGTH(curpencargado)=18);
ALTER TABLE correoencargado ADD CONSTRAINT ccurpencargadoD2 CHECK(curpencargado SIMILAR TO '[A-Z]{4}[0-9]{6}[A-Z]{6}[0-9]{2}');
ALTER TABLE correoencargado ADD CONSTRAINT correoencargadoD1 CHECK(correo LIKE '_%@_%._%');

--Entidad
ALTER TABLE correoencargado ADD CONSTRAINT correoencargado_pkey PRIMARY KEY (curpencargado,correo);

--Referencial
ALTER TABLE correoencargado ADD CONSTRAINT correoencargado_fkey FOREIGN KEY (curpencargado)
REFERENCES encargado (curpencargado) ON UPDATE CASCADE ON DELETE CASCADE;

comment on table correoencargado is 'Tabla que contiene los correos de los encargados'; 
comment on column correoencargado.curpencargado is 'Curp del encargado';
comment on column correoencargado.correo is 'Correo electronico del encargado';
comment on constraint correoencargado_pkey on correoencargado is 'La llave primaria de la tabla correoencargado';
comment on constraint correoencargado_fkey on correoencargado is 'La llave foránea de la tabla correoencargado';
comment on constraint ccurpencargadoD1 on correoencargado is 'Restriccion check que nos asegura que la cadena sea de longitud 18';
comment on constraint ccurpencargadoD2 on correoencargado is 'Restriccion check que nos asegura que la cadena sea de la forma de un curp';
comment on constraint correoencargadoD1 on correoencargado is 'Restriccion check de que el correo del encargado sea de la forma de un correo electrónico';

-----------------------------------------------------------------------------------------


CREATE TABLE gerente(
	curpgerente CHAR(18),
	idsucursal CHAR(7),
	nombregerente VARCHAR(50),
	paternogerente VARCHAR(50),
	maternogerente VARCHAR(50),
	fechanacimiento date,
	estado  VARCHAR(50),
	ciudad  VARCHAR(50),
	colonia  VARCHAR(50),
	calle  VARCHAR(50),
	numero INT,
	codigopostal CHAR(5)
	
);

-- Restricciones gerente

ALTER TABLE gerente ALTER COLUMN curpgerente SET NOT NULL;
ALTER TABLE gerente ADD CONSTRAINT curpgerenteD1 CHECK(CHAR_LENGTH(curpgerente)=18);
ALTER TABLE gerente ADD CONSTRAINT curpgerenteD2 CHECK(curpgerente SIMILAR TO '[A-Z]{4}[0-9]{6}[A-Z]{6}[0-9]{2}');
ALTER TABLE gerente ALTER COLUMN idsucursal SET NOT NULL;
ALTER TABLE gerente ADD CONSTRAINT idsucursalD1 CHECK (idsucursal SIMILAR TO 'S-[0-9]{5}');
ALTER TABLE gerente ADD CONSTRAINT nombregerenteD1 CHECK(nombregerente <> '');
ALTER TABLE gerente ADD CONSTRAINT paternogerenteD1 CHECK(paternogerente<>'');
ALTER TABLE gerente ADD CONSTRAINT maternogerenteD1 CHECK(maternogerente <>'');
ALTER TABLE gerente ALTER COLUMN fechanacimiento SET NOT NULL;
ALTER TABLE gerente ADD CONSTRAINT estadoD1 CHECK(estado <>'');
ALTER TABLE gerente ADD CONSTRAINT ciudadD1 CHECK(ciudad <>'');
ALTER TABLE gerente ADD CONSTRAINT coloniaD1 CHECK (colonia <>'');
ALTER TABLE gerente ADD CONSTRAINT calleD1 CHECK(calle <>'');
ALTER TABLE gerente ADD CONSTRAiNT codigopostalD1 CHECK(codigopostal SIMILAR TO '[0-9]{5}');
ALTER TABLE gerente ADD CONSTRAiNT numeroD1 CHECK(numero between 0 and 99999);

--Entidad
ALTER TABLE gerente ADD CONSTRAINT curpgerenteD3 UNIQUE(curpgerente);
ALTER TABLE gerente ADD CONSTRAINT gerente_pkey PRIMARY KEY (curpgerente);

--Referencial
ALTER TABLE gerente ADD CONSTRAINT gerente_fkey FOREIGN KEY (idsucursal)
REFERENCES sucursal (idsucursal) ON UPDATE CASCADE ON DELETE CASCADE;

comment on table gerente is 'Tabla que contiene la información de los gerentes';
comment on column gerente.curpgerente is 'Curp del gerente';
comment on column gerente.idsucursal  is 'Identificador de la sucursal';
comment on column gerente.nombregerente is 'Nombre del gerente';
comment on column gerente.paternogerente is 'Apellido paterno del gerente';
comment on column gerente.maternogerente is 'Apellido materno del gerente';
comment on column gerente.fechanacimiento is 'Fecha de nacimiento del gerente';
comment on column gerente.estado is 'Estado de la direccion del gerente';  
comment on column gerente.ciudad is 'Ciudad de la direccion del gerente'; 
comment on column gerente.colonia is 'Colonia de la direccion del gerente'; 
comment on column gerente.calle is 'Calle de la direccion del gerente'; 
comment on column gerente.numero is 'Numero de edificio de la direccion del gerente'; 
comment on column gerente.codigopostal is 'Codigo postal de la direccion del gerente'; 
comment on constraint gerente_pkey on gerente is 'Identificador de la tabla gerente';
comment on constraint gerente_fkey on gerente is 'La llave foránea de la tabla gerente';
comment on constraint curpgerenteD1 on gerente is 'Restriccion check que nos asegura que la cadena sea de longitud 18';
comment on constraint curpgerenteD2 on gerente is 'Restriccion check que nos asegura que la cadena sea de la forma de un curp';
comment on constraint curpgerenteD3 on gerente is 'Restriccion unique para el atributo curpgerente';
comment on constraint idsucursalD1 on gerente is 'Restriccion check que nos asegura que idsucursal sea de la forma que definimos los id';
comment on constraint nombregerenteD1 on gerente is 'Restriccion check que nos asegura que nombrecliente no sea la cadena vacía';
comment on constraint paternogerenteD1 on gerente is 'Restriccion check que nos asegura que paternocliente no sea la cadena vacía';
comment on constraint maternogerenteD1 on gerente is 'Restriccion check que nos asegura que maternocliente no sea la cadena vacía';
comment on constraint estadoD1 on gerente is 'Restriccion check que nos asegura que estado no sea la cadena vacía';
comment on constraint ciudadD1 on gerente is 'Restriccion check que nos asegura que ciudad no sea la cadena vacía';
comment on constraint coloniaD1 on gerente is 'Restriccion check que nos asegura que colonia no sea la cadena vacía';
comment on constraint calleD1 on gerente is 'Restriccion check que nos asegura que calle no sea la cadena vacía';
comment on constraint numeroD1 on gerente is 'Restriccion check que nos asegura que numero está entre 0 y 99999';
comment on constraint codigopostalD1 on gerente is 'Restriccion check que nos asegura que codigopostal sea de la forma indicada';

CREATE TABLE telefonogerente(
	curpgerente CHAR(18),
	telefono CHAR(10) 
);

--Restricciones telefono
--Dominio
ALTER TABLE telefonogerente ALTER COLUMN curpgerente SET NOT NULL;
ALTER TABLE telefonogerente ADD CONSTRAINT tcurpgerenteD1 CHECK(CHAR_LENGTH(curpgerente)=18);
ALTER TABLE telefonogerente ADD CONSTRAINT tcurpgerenteD2 CHECK(curpgerente SIMILAR TO '[A-Z]{4}[0-9]{6}[A-Z]{6}[0-9]{2}');
ALTER TABLE telefonogerente ADD CONSTRAINT telefonoD1 CHECK (telefono SIMILAR TO '[0-9]{10}');

--Entidad
ALTER TABLE telefonogerente ADD CONSTRAINT telefonogerente_pkey PRIMARY KEY (curpgerente,telefono);

--Referencial
ALTER TABLE telefonogerente ADD CONSTRAINT telefonogerente_fkey FOREIGN KEY (curpgerente)
REFERENCES gerente (curpgerente) ON UPDATE CASCADE ON DELETE CASCADE;

comment on table telefonogerente is 'Tabla que contiene los numeros de telefono de los gerentes'; 
comment on column telefonogerente.curpgerente is 'Curp del gerente';
comment on column telefonogerente.telefono is 'Numero de telefono del gerente';
comment on constraint telefonogerente_pkey on telefonogerente is 'La llave primaria de la tabla telefonogerente';
comment on constraint telefonogerente_fkey on telefonogerente is 'La llave foránea de la tabla telefonogerente';
comment on constraint tcurpgerenteD1 on telefonogerente is 'Restriccion check que nos asegura que la cadena sea de longitud 18';
comment on constraint tcurpgerenteD2 on telefonogerente is 'Restriccion check que nos asegura que la cadena sea de la forma de un curp';
comment on constraint telefonoD1 on telefonogerente is 'Restriccion check de que el numero de telefono sea una sucesion de numeros y sean exactamente 10';

CREATE TABLE correogerente(
	curpgerente CHAR(18),
	correo VARCHAR(50) 
);

--Restricciones correo
--Dominio
ALTER TABLE correogerente ALTER COLUMN curpgerente SET NOT NULL;
ALTER TABLE correogerente ADD CONSTRAINT ccurpgerenteD1 CHECK(CHAR_LENGTH(curpgerente)=18);
ALTER TABLE correogerente ADD CONSTRAINT ccurpgerenteD2 CHECK(curpgerente SIMILAR TO '[A-Z]{4}[0-9]{6}[A-Z]{6}[0-9]{2}');

ALTER TABLE correogerente ADD CONSTRAINT correogerenteD1 CHECK(correo LIKE '_%@_%._%');

--Entidad
ALTER TABLE correogerente ADD CONSTRAINT correogerente_pkey PRIMARY KEY (curpgerente,correo);

--Referencial
ALTER TABLE correogerente ADD CONSTRAINT correogerente_fkey FOREIGN KEY (curpgerente)
REFERENCES gerente (curpgerente) ON UPDATE CASCADE ON DELETE CASCADE;

comment on table correogerente is 'Tabla que contiene los correos de los gerentes'; 
comment on column correogerente.curpgerente is 'Curp del gerente';
comment on column correogerente.correo is 'Correo electronico del gerente';
comment on constraint correogerente_pkey on correogerente is 'La llave primaria de la tabla correogerente';
comment on constraint correogerente_fkey on correogerente is 'La llave foránea de la tabla correogerente';
comment on constraint ccurpgerenteD1 on correogerente is 'Restriccion check que nos asegura que la cadena sea de longitud 18';
comment on constraint ccurpgerenteD2 on correogerente is 'Restriccion check que nos asegura que la cadena sea de la forma de un curp';
comment on constraint correogerenteD1 on correogerente is 'Restriccion check de que el correo del gerente sea de la forma de un correo electrónico';

----------------------------------------------------------------------------------------------------------

CREATE TABLE venta(
	idventa CHAR(10),
	idsucursal CHAR(7),
	curpcliente CHAR(18),
	curpcajero CHAR(18),
	fechaventa date,
	ticket  CHAR(10),
	formapago  CHAR(10)
);

-- Restricciones venta

ALTER TABLE venta ALTER COLUMN idventa SET NOT NULL;
ALTER TABLE venta ADD CONSTRAINT idventa1 CHECK(idventa SIMILAR TO 'V-[0-9]{8}');
ALTER TABLE venta ALTER COLUMN idsucursal SET NOT NULL;
ALTER TABLE venta ADD CONSTRAINT idsucursalD1 CHECK (idsucursal SIMILAR TO 'S-[0-9]{5}');
ALTER TABLE venta ALTER COLUMN curpcliente SET NOT NULL;
ALTER TABLE venta ADD CONSTRAINT curpclienteD1 CHECK(CHAR_LENGTH(curpcliente)=18);
ALTER TABLE venta ADD CONSTRAINT curpclienteD2 CHECK(curpcliente SIMILAR TO '[A-Z]{4}[0-9]{6}[A-Z]{6}[0-9]{2}');
ALTER TABLE venta ALTER COLUMN curpcajero SET NOT NULL;
ALTER TABLE venta ADD CONSTRAINT curpcajeroD1 CHECK(CHAR_LENGTH(curpcajero)=18);
ALTER TABLE venta ADD CONSTRAINT curpcajeroD2 CHECK(curpcajero SIMILAR TO '[A-Z]{4}[0-9]{6}[A-Z]{6}[0-9]{2}');

ALTER TABLE venta ALTER COLUMN fechaventa SET NOT NULL;
ALTER TABLE venta ADD CONSTRAINT fechaventa1 CHECK(EXTRACT (years FROM age(CURRENT_DATE,fechaventa))>=23);
ALTER TABLE venta ALTER COLUMN ticket SET NOT NULL;
ALTER TABLE venta ADD CONSTRAINT ticket1 CHECK(CHAR_LENGTH(ticket)=10);
ALTER TABLE venta ADD CONSTRAINT formapago1 CHECK(formapago <>'');

--Entidad
ALTER TABLE venta ADD CONSTRAINT idventa2 UNIQUE(idventa);
ALTER TABLE venta ADD CONSTRAINT venta_pkey PRIMARY KEY (idventa);

--Referencial
ALTER TABLE venta ADD CONSTRAINT venta_fkey1 FOREIGN KEY (idsucursal)
REFERENCES sucursal (idsucursal) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE venta ADD CONSTRAINT venta_fkey2 FOREIGN KEY (curpcliente)
REFERENCES cliente (curpcliente) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE venta ADD CONSTRAINT venta_fkey3 FOREIGN KEY (curpcajero)
REFERENCES cajero (curpcajero) ON UPDATE CASCADE ON DELETE CASCADE;

comment on table venta is 'Tabla que contiene la información de las ventas';
comment on column venta.idventa is 'Identificador de cada venta';
comment on column venta.idsucursal  is 'Identificador de la sucursal';
comment on column venta.curpcliente is 'Curp del cliente';
comment on column venta.curpcajero is 'Curp del cajero';
comment on column venta.fechaventa is 'Fecha de realización de la venta';
comment on column venta.ticket is 'Codigo de ticket';  
comment on column venta.formapago is 'Forma de pago'; 
comment on constraint venta_pkey on venta is 'Identificador de la tabla encargado';
comment on constraint venta_fkey1 on venta is 'La primera llave foránea de la tabla encargado';
comment on constraint venta_fkey2 on venta is 'La segunda llave foránea de la tabla encargado';
comment on constraint venta_fkey3 on venta is 'La tercera llave foránea de la tabla encargado';
comment on constraint idventa1 on venta is 'Restriccion check que nos asegura que idventa sea de la forma que definimos los id';
comment on constraint idventa2 on venta is 'Restriccion unique para el atributo idventa';
comment on constraint idsucursalD1 on venta is 'Restriccion check que nos asegura que idsucursal sea de la forma que definimos los id';
comment on constraint curpclienteD1 on venta is 'Restriccion check que nos asegura que la cadena sea de longitud 18';
comment on constraint curpclienteD2 on venta is 'Restriccion check que nos asegura que la cadena sea de la forma de un curp';
comment on constraint curpcajeroD1 on venta is 'Restriccion check que nos asegura que la cadena sea de longitud 18';
comment on constraint curpcajeroD2 on venta is 'Restriccion check que nos asegura que la cadena sea de la forma de un curp';
comment on constraint fechaventa1 on venta is 'Restriccion check que nos asegura que la fecha no sea superior a la actual';
comment on constraint ticket1 on venta is 'Restriccion check que nos asegura que la longitud no sea mayor a 10';
comment on constraint formapago1 on venta is 'Restriccion check que nos asegura que formapago no sea la cadena vacía';

---------------------------------------------------------------------------------------------------------

CREATE TABLE electronica(
	idproductoe CHAR(10),
	nombre VARCHAR(50),
	marca VARCHAR(50),
	precio INT,
	cantidad INT,
	descripcion VARCHAR(50),
	categoria VARCHAR(50),
	consumowatts INT
);

--Restricciones de electronica

ALTER TABLE electronica ALTER COLUMN idproductoe SET NOT NULL;
ALTER TABLE electronica ADD CONSTRAINT idproductoe1 CHECK(idproductoe SIMILAR TO 'E-[0-9]{8}');
ALTER TABLE electronica ADD CONSTRAINT nombreE1 CHECK(nombre <> '');
ALTER TABLE electronica ADD CONSTRAINT marcaE1 CHECK(marca<>'');
ALTER TABLE electronica ADD CONSTRAiNT precioE1 CHECK(precio between 0 and 99999);
ALTER TABLE electronica ADD CONSTRAiNT cantidadE1 CHECK(cantidad between 1 and 99999);
ALTER TABLE electronica ADD CONSTRAINT descripcionE1 CHECK(descripcion <>'');
ALTER TABLE electronica ADD CONSTRAINT categoriaE1 CHECK(categoria <>'');
ALTER TABLE electronica ADD CONSTRAiNT consumowatts1 CHECK(consumowatts between 0 and 99999);

--Entidad

ALTER TABLE electronica ADD CONSTRAINT idproductoe2 UNIQUE(idproductoe);
ALTER TABLE electronica ADD CONSTRAINT electronica_pkey PRIMARY KEY (idproductoe);


comment on table electronica is 'Tabla que contiene la información de los productos electronicos';
comment on column electronica.idproductoe is 'Identificador de cada producto electronico';
comment on column electronica.nombre is 'Nombre del producto';
comment on column electronica.marca is 'Marca del producto';
comment on column electronica.precio is 'Precio del producto';
comment on column electronica.cantidad is 'Cantidad disponible del producto';
comment on column electronica.descripcion is 'Descripcion breve del producto';
comment on column electronica.categoria is 'Categoria del producto';
comment on column electronica.consumowatts is 'Consumo de watts del producto';
comment on constraint electronica_pkey on electronica is 'Identificador de la tabla electronica';
comment on constraint idproductoe1 on electronica is 'Restriccion check que nos asegura que idproductoe sea de la forma que definimos los id';
comment on constraint idproductoe2 on electronica is 'Restriccion unique para el atributo idproductoe';
comment on constraint nombreE1 on electronica is 'Restriccion check que nos asegura que nombre no sea la cadena vacía';
comment on constraint marcaE1 on electronica is 'Restriccion check que nos asegura que marca no sea la cadena vacía';
comment on constraint precioE1 on electronica is 'Restriccion check que nos asegura que precio está entre 0 y 99999';
comment on constraint cantidadE1 on electronica is 'Restriccion check que nos asegura que cantidad está entre 1 y 99999';
comment on constraint descripcionE1 on electronica is 'Restriccion check que nos asegura que descripcion no sea la cadena vacía';
comment on constraint categoriaE1 on electronica is 'Restriccion check que nos asegura que categoria no sea la cadena vacía';
comment on constraint consumowatts1 on electronica is 'Restriccion check que nos asegura que consumowatts está entre 1 y 99999';



----------------------------------------------------------------------------------------------------------

CREATE TABLE perecedero(
	idproductop CHAR(10),
	nombre VARCHAR(50),
	marca VARCHAR(50),
	precio INT,
	cantidad INT,
	descripcion VARCHAR(50),
	presentacion VARCHAR(50),
	fechapreparado date,
	fechacadcorta date,
	tiporefrigeracion VARCHAR(50)
);

--Restricciones de perecedero

ALTER TABLE perecedero ALTER COLUMN idproductop SET NOT NULL;
ALTER TABLE perecedero ADD CONSTRAINT idproductop1 CHECK(idproductop SIMILAR TO 'P-[0-9]{8}');
ALTER TABLE perecedero ADD CONSTRAINT nombreP1 CHECK(nombre <> '');
ALTER TABLE perecedero ADD CONSTRAINT marcaP1 CHECK(marca<>'');
ALTER TABLE perecedero ADD CONSTRAiNT precioP1 CHECK(precio between 0 and 99999);
ALTER TABLE perecedero ADD CONSTRAiNT cantidadP1 CHECK(cantidad between 1 and 99999);
ALTER TABLE perecedero ADD CONSTRAINT descripcionP1 CHECK(descripcion <>'');
ALTER TABLE perecedero ADD CONSTRAINT presentacionP1 CHECK(presentacion<>'');
ALTER TABLE perecedero ALTER COLUMN fechapreparado SET NOT NULL;
ALTER TABLE perecedero ALTER COLUMN fechacadcorta SET NOT NULL;
ALTER TABLE perecedero ADD CONSTRAINT tiporefrigeracionP1 CHECK(tiporefrigeracion<>'');


--Entidad

ALTER TABLE perecedero ADD CONSTRAINT idproductop2 UNIQUE(idproductop);
ALTER TABLE perecedero ADD CONSTRAINT perecedero_pkey PRIMARY KEY (idproductop);

comment on table perecedero is 'Tabla que contiene la información de los productos perecederos';
comment on column perecedero.idproductop is 'Identificador de cada producto perecedero';
comment on column perecedero.nombre is 'Nombre del producto';
comment on column perecedero.marca is 'Marca del producto';
comment on column perecedero.precio is 'Precio del producto';
comment on column perecedero.cantidad is 'Cantidad disponible del producto';
comment on column perecedero.descripcion is 'Descripcion breve del producto';
comment on column perecedero.presentacion is 'Presentacion del producto';
comment on column perecedero.fechapreparado is 'fecha de preparado del producto';
comment on column perecedero.fechacadcorta is 'fecha de caducidad del producto';
comment on column perecedero.tiporefrigeracion is 'Tipo de refrigeracion que necesita el producto';
comment on constraint perecedero_pkey on perecedero is 'Identificador de la tabla perecedero';
comment on constraint idproductop1 on perecedero is 'Restriccion check que nos asegura que idproductop sea de la forma que definimos los id';
comment on constraint idproductop2 on perecedero is 'Restriccion unique para el atributo idproductop';
comment on constraint nombreP1 on perecedero is 'Restriccion check que nos asegura que nombre no sea la cadena vacía';
comment on constraint marcaP1 on perecedero is 'Restriccion check que nos asegura que marca no sea la cadena vacía';
comment on constraint precioP1 on perecedero is 'Restriccion check que nos asegura que precio está entre 0 y 99999';
comment on constraint cantidadP1 on perecedero is 'Restriccion check que nos asegura que cantidad está entre 1 y 99999';
comment on constraint descripcionP1 on perecedero is 'Restriccion check que nos asegura que descripcion no sea la cadena vacía';
comment on constraint presentacionP1 on perecedero is 'Restriccion check que nos asegura que presentacion no sea la cadena vacía';
comment on constraint tiporefrigeracionP1 on perecedero is 'Restriccion check que nos asegura que tiporefrigeracion no sea la cadena vacía';




------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE noperecedero(
	idproductonp CHAR(11),
	nombre VARCHAR(50),
	marca VARCHAR(50),
	precio INT,
	cantidad INT,
	descripcion VARCHAR(50),
	presentacion VARCHAR(50),
	fechapreparado date,
	fechacadlarga date,
	condicionalmacenamiento VARCHAR(50)
);

--Restricciones de noperecedero

ALTER TABLE noperecedero ALTER COLUMN idproductonp SET NOT NULL;
ALTER TABLE noperecedero ADD CONSTRAINT idproductonp1 CHECK(idproductonp SIMILAR TO 'NP-[0-9]{8}');
ALTER TABLE noperecedero ADD CONSTRAINT nombreNP1 CHECK(nombre <> '');
ALTER TABLE noperecedero ADD CONSTRAINT marcaNP1 CHECK(marca<>'');
ALTER TABLE noperecedero ADD CONSTRAiNT precioNP1 CHECK(precio between 0 and 99999);
ALTER TABLE noperecedero ADD CONSTRAiNT cantidadNP1 CHECK(cantidad between 1 and 99999);
ALTER TABLE noperecedero ADD CONSTRAINT descripcionNP1 CHECK(descripcion <>'');
ALTER TABLE noperecedero ADD CONSTRAINT presentacionNP1 CHECK(presentacion<>'');
ALTER TABLE noperecedero ALTER COLUMN fechapreparado SET NOT NULL;
ALTER TABLE noperecedero ALTER COLUMN fechacadlarga SET NOT NULL;
ALTER TABLE noperecedero ADD CONSTRAINT condicionalmacenamientoNP1 CHECK(condicionalmacenamiento<>'');


--Entidad

ALTER TABLE noperecedero ADD CONSTRAINT idproductonp2 UNIQUE(idproductonp);
ALTER TABLE noperecedero ADD CONSTRAINT noperecedero_pkey PRIMARY KEY (idproductonp);

comment on table noperecedero is 'Tabla que contiene la información de los productos perecederos';
comment on column noperecedero.idproductonp is 'Identificador de cada producto perecedero';
comment on column noperecedero.nombre is 'Nombre del producto';
comment on column noperecedero.marca is 'Marca del producto';
comment on column noperecedero.precio is 'Precio del producto';
comment on column noperecedero.cantidad is 'Cantidad disponible del producto';
comment on column noperecedero.descripcion is 'Descripcion breve del producto';
comment on column noperecedero.presentacion is 'Presentacion del producto';
comment on column noperecedero.fechapreparado is 'fecha de preparado del producto';
comment on column noperecedero.fechacadlarga is 'fecha de caducidad del producto';
comment on column noperecedero.condicionalmacenamiento is 'Condiciones de almacenamiento necesarias';
comment on constraint noperecedero_pkey on noperecedero is 'Identificador de la tabla perecedero';
comment on constraint idproductonp1 on noperecedero is 'Restriccion check que nos asegura que idproductop sea de la forma que definimos los id';
comment on constraint idproductonp2 on noperecedero is 'Restriccion unique para el atributo idproductop';
comment on constraint nombreNP1 on noperecedero is 'Restriccion check que nos asegura que nombre no sea la cadena vacía';
comment on constraint marcaNP1 on noperecedero is 'Restriccion check que nos asegura que marca no sea la cadena vacía';
comment on constraint precioNP1 on noperecedero is 'Restriccion check que nos asegura que precio está entre 0 y 99999';
comment on constraint cantidadNP1 on noperecedero is 'Restriccion check que nos asegura que cantidad está entre 1 y 99999';
comment on constraint descripcionNP1 on noperecedero is 'Restriccion check que nos asegura que descripcion no sea la cadena vacía';
comment on constraint presentacionNP1 on noperecedero is 'Restriccion check que nos asegura que presentacion no sea la cadena vacía';
comment on constraint condicionalmacenamientoNP1 on noperecedero is 'Restriccion check que nos asegura que condicionalmacenamiento no sea la cadena vacía';



------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE poseerp(
	idsucursal CHAR(7),
    idproductop CHAR(10),
    cantidadestock INT 
);

-- Restricciones poseerp
ALTER TABLE poseerp ALTER COLUMN idsucursal SET NOT NULL;
ALTER TABLE poseerp ADD CONSTRAINT idsucursalD1 CHECK (idsucursal SIMILAR TO 'S-[0-9]{5}');
ALTER TABLE poseerp ALTER COLUMN idproductop SET NOT NULL;
ALTER TABLE poseerp ADD CONSTRAINT idproductop1 CHECK(idproductop SIMILAR TO 'P-[0-9]{8}');
ALTER TABLE poseerp ADD CONSTRAINT cantidadestock1 CHECK(cantidadestock BETWEEN 1 AND 99999);

-- Referencial
ALTER TABLE poseerp ADD CONSTRAINT poseerp_fkey1 FOREIGN KEY (idsucursal)
REFERENCES sucursal (idsucursal) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE poseerp ADD CONSTRAINT poseerp_fkey2 FOREIGN KEY (idproductop) 
REFERENCES perecedero (idproductop) ON UPDATE CASCADE ON DELETE CASCADE;

-- Comentarios

COMMENT ON TABLE poseerp IS 'Tabla que almacena la cantidad de stock de productos en diferentes sucursales';
COMMENT ON COLUMN poseerp.idsucursal IS 'Identificador de la sucursal donde se encuentra el producto';
COMMENT ON COLUMN poseerp.idproductop IS 'Identificador único del producto';
COMMENT ON COLUMN poseerp.cantidadestock IS 'Cantidad actual de stock del producto en la sucursal';
COMMENT ON CONSTRAINT idsucursalD1 ON poseerp IS 'Verifica que el identificador de la sucursal tenga el formato "S-" seguido de 5 digitos';
COMMENT ON CONSTRAINT idproductop1 ON poseerp IS 'Verifica que el identificador del producto no perecedero tenga el formato "P-" seguido de 8 digitos';
COMMENT ON CONSTRAINT cantidadestock1 ON poseerp IS 'Verifica que la cantidad de productos no perecederos disponibles esté entre 1 y 99999';
COMMENT ON CONSTRAINT poseerp_fkey1 ON poseerp IS 'idsucursal debe hacer referencia a una sucursal existente en la tabla sucursal';
COMMENT ON CONSTRAINT poseerp_fkey2 ON poseerp IS 'idproductop debe hacer referencia a un producto perecedero existente en la tabla perecedero';



-------------------------------------------------------------------------
CREATE TABLE poseernp(
	idsucursal CHAR(7),
    idproductonp CHAR(11),
    cantidadestock INT 
);

-- Restricciones poseernp
ALTER TABLE poseernp ALTER COLUMN idsucursal SET NOT NULL;
ALTER TABLE poseernp ADD CONSTRAINT idsucursalD1 CHECK (idsucursal SIMILAR TO 'S-[0-9]{5}');
ALTER TABLE poseernp ALTER COLUMN idproductonp SET NOT NULL;
ALTER TABLE poseernp ADD CONSTRAINT idproductonp1 CHECK(idproductonp SIMILAR TO 'NP-[0-9]{8}');
ALTER TABLE poseernp ADD CONSTRAINT cantidadestock1 CHECK(cantidadestock BETWEEN 1 AND 99999);

-- Referencial
ALTER TABLE poseernp ADD CONSTRAINT poseernp_fkey1 FOREIGN KEY (idsucursal)
REFERENCES sucursal (idsucursal) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE poseernp ADD CONSTRAINT poseernp_fkey2 FOREIGN KEY (idproductonp) 
REFERENCES noperecedero (idproductonp) ON UPDATE CASCADE ON DELETE CASCADE;
-- Comentarios
COMMENT ON TABLE poseernp IS 'Tabla que almacena la cantidad de productos no perecederos disponibles en cada sucursal';
COMMENT ON COLUMN poseernp.idsucursal IS 'Identificador de la sucursal a la que pertenece el registro';
COMMENT ON COLUMN poseernp.idproductonp IS 'Identificador del producto no perecedero registrado';
COMMENT ON COLUMN poseernp.cantidadestock IS 'Cantidad de productos no perecederos disponibles en la sucursal';
COMMENT ON CONSTRAINT idsucursalD1 ON poseernp IS 'Verifica que el identificador de la sucursal tenga el formato "S-" seguido de 5 digitos';
COMMENT ON CONSTRAINT idproductonp1 ON poseernp IS 'Verifica que el identificador del producto no perecedero tenga el formato "NP-" seguido de 8 digitos';
COMMENT ON CONSTRAINT cantidadestock1 ON poseernp IS 'Verifica que la cantidad de productos no perecederos disponibles esté entre 1 y 99999';
COMMENT ON CONSTRAINT poseernp_fkey1 ON poseernp IS 'Establece la relación referencial con la tabla sucursal y se actualiza en cascada en caso de actualización o eliminación';
COMMENT ON CONSTRAINT poseernp_fkey2 ON poseernp IS 'Establece la relación referencial con la tabla electronica y se actualiza en cascada en caso de actualización o eliminación';

---------------------------------------------------------------------------------------
CREATE TABLE poseere(
	idsucursal CHAR(7),
    idproductoe CHAR(10),
    cantidadestock INT 
);

-- Restricciones poseere
ALTER TABLE poseere ALTER COLUMN idsucursal SET NOT NULL;
ALTER TABLE poseere ADD CONSTRAINT idsucursalD1 CHECK (idsucursal SIMILAR TO 'S-[0-9]{5}');
ALTER TABLE poseere ALTER COLUMN idproductoe SET NOT NULL;
ALTER TABLE poseere ADD CONSTRAINT idproductoe1 CHECK(idproductoe SIMILAR TO 'E-[0-9]{8}');
ALTER TABLE poseere ADD CONSTRAINT cantidadestock1 CHECK(cantidadestock BETWEEN 1 AND 99999);

-- Referencial
ALTER TABLE poseere ADD CONSTRAINT poseere_fkey1 FOREIGN KEY (idsucursal)
REFERENCES sucursal (idsucursal) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE poseere ADD CONSTRAINT poseere_fkey2 FOREIGN KEY (idproductoe) 
REFERENCES electronica (idproductoe) ON UPDATE CASCADE ON DELETE CASCADE;


--Comentarios 
COMMENT ON TABLE poseere IS 'Tabla que almacena la cantidad de productos electrónicos disponibles en cada sucursal';

COMMENT ON COLUMN poseere.idsucursal IS 'Identificador de la sucursal a la que pertenece el registro';
COMMENT ON COLUMN poseere.idproductoe IS 'Identificador del producto electrónico registrado';
COMMENT ON COLUMN poseere.cantidadestock IS 'Cantidad de productos electrónicos disponibles en la sucursal';
COMMENT ON CONSTRAINT idsucursalD1 ON poseere IS 'Verifica que el identificador de la sucursal tenga el formato "S-" seguido de 5 digitos';
COMMENT ON CONSTRAINT idproductoe1 ON poseere IS 'Verifica que el identificador del producto electrónico tenga el formato "E-" seguido de 8 digitos';
COMMENT ON CONSTRAINT cantidadestock1 ON poseere IS 'Verifica que la cantidad de productos electrónicos disponibles esté entre 1 y 99999';
COMMENT ON CONSTRAINT poseere_fkey1 ON poseere IS 'Establece la relación referencial con la tabla sucursal y se actualiza en cascada en caso de actualización o eliminación';
COMMENT ON CONSTRAINT poseere_fkey2 ON poseere IS 'Establece la relación referencial con la tabla electronica y se actualiza en cascada en caso de actualización o eliminación';










---------------------------------------------------------------------------------------------------
CREATE TABLE venderp(
	idventa CHAR(10),
    idproductop CHAR(10),
    cantidadproducto INT 
    
);


--Restricciones venderp
ALTER TABLE venderp ALTER COLUMN idventa SET NOT NULL;
ALTER TABLE venderp ADD CONSTRAINT idventa1 CHECK(idventa SIMILAR TO 'V-[0-9]{8}');
ALTER TABLE venderp ALTER COLUMN idproductop SET NOT NULL;

ALTER TABLE venderp ADD CONSTRAINT idproductop1 CHECK(idproductop SIMILAR TO 'P-[0-9]{8}');
ALTER TABLE venderp ADD CONSTRAINT cantidadproducto CHECK(cantidadproducto between 1 and 99999);
-- Agregando comentarios a la tabla y las columnas
COMMENT ON TABLE venderp IS 'Tabla que almacena información sobre ventas de productos';
COMMENT ON COLUMN venderp.idventa IS 'ID de la venta ';
COMMENT ON COLUMN venderp.idproductop IS 'ID del producto vendido ';
COMMENT ON COLUMN venderp.cantidadproducto IS 'Cantidad de unidades del producto vendidas';
-- Comentarios para las restricciones de la tabla venderp
COMMENT ON CONSTRAINT idventa1 ON venderp IS 'Restricción para asegurar que el id de venta tenga el formato "V-" seguido de 8 digitos';
COMMENT ON CONSTRAINT idproductop1 ON venderp IS 'Restricción para asegurar que el id del producto tenga el formato "P-" seguido de 8 digitos';
COMMENT ON CONSTRAINT cantidadproducto ON venderp IS 'Restricción para asegurar que la cantidad del producto vendido esté entre 1 y 99999';

--Referencial
ALTER TABLE venderp ADD CONSTRAINT venderp_fkey1 FOREIGN KEY (idventa)
REFERENCES venta (idventa) ON UPDATE CASCADE ON DELETE CASCADE;
COMMENT ON CONSTRAINT venderp_fkey1 ON venderp IS 'Referencia a la tabla venta, se actualiza y elimina en cascada';

ALTER TABLE venderp ADD CONSTRAINT venderp_fkey2 FOREIGN KEY (idproductop) 
REFERENCES perecedero (idproductop) ON UPDATE CASCADE ON DELETE CASCADE;
COMMENT ON CONSTRAINT venderp_fkey2 ON venderp IS 'Referencia a la tabla perecedero, se actualiza y elimina en cascada';



---------------------------------------------------------------------------------------------------------------
CREATE TABLE vendernp(
	idventa CHAR(10),
    idproductonp CHAR(11),
    cantidadproducto INT 
    
);


--Restricciones vendernp
ALTER TABLE vendernp ALTER COLUMN idventa SET NOT NULL;
ALTER TABLE vendernp ADD CONSTRAINT idventa1 CHECK(idventa SIMILAR TO 'V-[0-9]{8}');
ALTER TABLE vendernp ALTER COLUMN idproductonp SET NOT NULL;
ALTER TABLE vendernp ADD CONSTRAINT idproductonp1 CHECK(idproductonp SIMILAR TO 'NP-[0-9]{8}');
ALTER TABLE vendernp ADD CONSTRAiNT cantidadproducto CHECK(cantidadproducto between 1 and 99999);
-- Agregando comentarios a la tabla y las columnas
COMMENT ON TABLE vendernp IS 'Tabla que almacena información sobre ventas de productos no perecederos';
COMMENT ON COLUMN vendernp.idventa IS 'ID de la venta';
COMMENT ON COLUMN vendernp.idproductonp IS 'ID del producto no perecedero vendido ';
COMMENT ON COLUMN vendernp.cantidadproducto IS 'Cantidad de unidades del producto vendidas';
COMMENT ON CONSTRAINT idventa1 ON vendernp IS 'Restricción para asegurar que el id de venta tenga el formato "V-" seguido de 8 digitos';
COMMENT ON CONSTRAINT idproductonp1 ON vendernp IS 'Restricción para asegurar que el id del producto no perecedero tenga el formato "NP-" seguido de 8 digitos';
COMMENT ON CONSTRAINT cantidadproducto ON vendernp IS 'Restricción para asegurar que la cantidad del producto vendido esté entre 1 y 99999';
--Referencial
ALTER TABLE vendernp ADD CONSTRAINT vendernp_fkey1 FOREIGN KEY (idventa)
REFERENCES venta (idventa) ON UPDATE CASCADE ON DELETE CASCADE;
COMMENT ON CONSTRAINT vendernp_fkey1 ON vendernp IS 'Referencia a la tabla venta, se actualiza y elimina en cascada';

ALTER TABLE vendernp ADD CONSTRAINT vendernp_fkey2 FOREIGN KEY (idproductonp) 
REFERENCES noperecedero (idproductonp) ON UPDATE CASCADE ON DELETE CASCADE;
COMMENT ON CONSTRAINT vendernp_fkey2 ON vendernp IS 'Referencia a la tabla noperecedero, se actualiza y elimina en cascada';

----------------------------------------------------------------------------------------------------------------------
CREATE TABLE vendere(
	idventa CHAR(10),
    idproductoe CHAR(10),
    cantidadproducto INT 
    
);


--Restricciones vendere
ALTER TABLE vendere ALTER COLUMN idventa SET NOT NULL;
ALTER TABLE vendere ADD CONSTRAINT idventa1 CHECK(idventa SIMILAR TO 'V-[0-9]{8}');
ALTER TABLE vendere ALTER COLUMN idproductoe SET NOT NULL;
ALTER TABLE vendere ADD CONSTRAINT idproductoe1 CHECK(idproductoe SIMILAR TO 'E-[0-9]{8}');
ALTER TABLE vendere ADD CONSTRAiNT cantidadproducto CHECK(cantidadproducto between 1 and 99999);

--Referencial
ALTER TABLE vendere ADD CONSTRAINT vendere_fkey1 FOREIGN KEY (idventa)
REFERENCES venta (idventa) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE vendere ADD CONSTRAINT vendere_fkey2 FOREIGN KEY (idproductoe) 
REFERENCES electronica (idproductoe) ON UPDATE CASCADE ON DELETE CASCADE;


--Comentarios
COMMENT ON TABLE vendere IS 'Tabla que almacena las ventas de productos de electrónica.';
COMMENT ON COLUMN vendere.idventa IS 'Identificador de la venta ';
COMMENT ON COLUMN vendere.idproductoe IS 'Identificador  del producto de electrónica';
COMMENT ON COLUMN vendere.cantidadproducto IS 'Cantidad de productos de electrónica vendidos en una venta.';
COMMENT ON CONSTRAINT idventa1 ON vendere IS 'Restricción que valida que el identificador de venta tenga el formato correcto "V-" seguido de 8 digitos.';
COMMENT ON CONSTRAINT idproductoe1 ON vendere IS 'Restricción que valida que el identificador de producto tenga el formato correcto "E-" seguido de 8 digitos.';
COMMENT ON CONSTRAINT cantidadproducto ON vendere IS 'Restricción que valida que la cantidad de productos vendidos esté entre 1 y 99999.';
COMMENT ON CONSTRAINT vendere_fkey1 ON vendere IS 'Restricción que establece una llave foránea hacia la tabla venta, en la columna idventa.';
COMMENT ON CONSTRAINT vendere_fkey2 ON vendere IS 'Restricción que establece una llave foránea hacia la tabla electronica, en la columna idproductoe.';