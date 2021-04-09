{- El encargado de ventas de un negocio de productos de limpieza desea administrar el stock
de los productos que vende.

De cada producto un archivo maestro
*********************************
código de producto
nombre comercial
precio de venta
stock actual
stock mínimo
*********************************
Diariamente segenera un archivo detalle donde se registran todas las ventas de productos realizadas.
De cada venta se registra:
*********************************
código de producto
cantidad de unidades vendidas
*********************************

programa con opciones para:
a. Crear el archivo maestro a partir de un archivo de texto llamado “productos.txt”.

b. Listar el contenido del archivo maestro en un archivo de texto llamado “reporte.txt”,
listando de a un producto por línea.

c. Crear un archivo detalle de ventas a partir de en un archivo de texto llamado
“ventas.txt”.

d. Listar en pantalla el contenido del archivo detalle de ventas.

e. Actualizar el archivo maestro con el archivo detalle, sabiendo que:
	● Ambos archivos están ordenados por código de producto.
	● Cada registro del maestro puede ser actualizado por 0, 1 ó más registros del
	archivo detalle.
	● El archivo detalle sólo contiene registros que están en el archivo maestro.
	
f. Listar en un archivo de texto llamado “stock_minimo.txt” aquellos productos cuyo
stock actual esté por debajo del stock mínimo permitido.
}
program ejercicio7;
uses crt;
TYPE
	reg_maestro = record
		cod_prod : integer;
		nombre_comercial:String[10];
		precio_venta:real;
		stock_actual:integer;
		stock_minimo:integer;
	
	end;
	
	reg_detalle = record
		cod_producto:integer;
		cant_vend:integer;
	end;
	
	archivo_maestro = file of reg_maestro;
	archivo_detalle = file of reg_detalle;
	
	


{procedure importarDetalle( var d:archivoDetalle ; var t:text);
var
	r:alumnoD;
begin
	rewrite(d);
	reset(t);
	while ( not eof(t) ) do begin
		readln(t,r.codAlumno,r.materia,r.conFinal);
		write(d,r);
		end;
	close(d);
	close(t);
	end;

procedure exportarMaestro( var a:archivoMaestro; var t:text);
var 
	r:alumnoM;
begin
	rewrite(t);
	reset(a);
	while (not eof(a)) do begin
		read(a,r);
		writeln(t,r.codAlumno,' ',r.apellido,r.nombre);
		writeln(t,r.cantMateriaSinFinal,'',r.cantMateriaFinal);
	end;
	close(t);
	close(a);
end;}

procedure importarMaestro(var m:archivo_maestro ; var t:text);
var
	r:reg_maestro;
begin
	rewrite(m);
	reset(t);
	Writeln('************COMIENZO DE CARGA DEL MAESTRO*****************');
	while (not eof(t)) do begin
		readln(t,r.cod_prod);
		readln(t, r.nombre_comercial);
		readln(t , r.precio_venta , r.stock_actual , r.stock_minimo);
		writeln('Cod: ',r.cod_prod);
		writeln('Nombre: ',r.nombre_comercial);
		writeln('Precio Venta: ',r.precio_venta);
		writeln('Stock Actual: ',r.stock_actual);
		writeln('Stock Minimo: ',r.stock_minimo);
		write(m,r);
		Writeln('--------------------------------');
		end;
	close(m);
	close(t);
	Writeln('************FIN DE CARGA DEL MAESTRO*****************');
end;

procedure exportarMaestro(var t:text ; var arch_m : archivo_maestro);
var
	reg_m:reg_maestro;
begin
	rewrite(t);
	reset(arch_m);
	while (not eof(arch_m)) do begin
		read(arch_m,reg_m);
		writeln(t , reg_m.cod_prod ,' ',reg_m.nombre_comercial ,' ', reg_m.precio_venta ,' ', reg_m.stock_actual ,' ', reg_m.stock_minimo);
	end;
	close(t);
	close(arch_m);
end;


procedure mostrarMenu (var option:integer);

begin
	writeln('1) Crear el archivo maestro a partir de un archivo de texto llamado productos.txt.');
	writeln('2) Listar el contenido del archivo maestro en un archivo de texto llamado reporte.txt, listando de a un producto por linea.');
	writeln('3) Crear un archivo detalle de ventas a partir de en un archivo de texto llamado ventas.txt.');
	writeln('4) Listar en pantalla el contenido del archivo detalle de ventas.');
	writeln('5) Actualizar el archivo maestro con el archivo detalle');
	writeln('6) Listar en un archivo de texto llamado stock_minimo.txt aquellos productos cuyo stock actual este por debajo del stock minimo permitido.');
	writeln('0) Salir');
	writeln('.............');
	writeln('Ingrese la opcion');
	readln(option);
end;

VAR
	text_maestro : text;
	export_text_maestro:text;
	arch_maestro : archivo_maestro;
	option : integer;
BEGIN
	assign(text_maestro , 'productos.txt');
	assign(arch_maestro , 'maestro.dat');
	assign(export_text_maestro, 'reporte.txt');
	mostrarMenu(option);
	
	while option <> 0 do begin 
		case (option) of
			1: importarMaestro(arch_maestro,text_maestro);
			2: exportarMaestro(export_text_maestro , arch_maestro);
		end;
		writeln('Enter para limpiar pantalla');
		readln();
		clrscr;
		mostrarMenu(option);
	end;
	
END.
