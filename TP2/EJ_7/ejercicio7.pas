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
CONST valoralto = 32767;
TYPE
	reg_maestro = record
		cod_prod : integer;
		nombre_comercial:String[10];
		precio_venta:integer;
		stock_actual:integer;
		stock_minimo:integer;
	
	end;
	
	reg_detalle = record
		cod_producto:integer;
		cant_vend:integer;
	end;
	
	archivo_maestro = file of reg_maestro;
	archivo_detalle = file of reg_detalle;
	

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

procedure importarDetalle(var d:archivo_detalle ; var t:text);
var
	r:reg_detalle;
begin
	rewrite(d);
	reset(t);
	Writeln('************COMIENZO DE CARGA DEL DETALLE*****************');
	Writeln('--------------------------------');
	while (not eof(t)) do begin
		readln(t,r.cod_producto , r.cant_vend);;
		writeln('Cod: ',r.cod_producto);
		writeln('Cant Vendida: ',r.cant_vend);
		write(d,r);
		Writeln('--------------------------------');
		end;
	close(d);
	close(t);
	Writeln('************FIN DE CARGA DEL DETALLE*****************');
end;

procedure listarEnPantallaDetalle (var d: archivo_detalle);
var
	r : reg_detalle;
begin
	reset(d);
	Writeln('--------------------------------');
	while (not eof(d)) do begin
		read(d , r);
		writeln('Cod: ',r.cod_producto);
		writeln('Cant Vendida: ',r.cant_vend);
		Writeln('--------------------------------');
	end;
	close(d);
end;

procedure leer(	var archivo: archivo_detalle; var dato: reg_detalle);
begin
    if (not(EOF(archivo))) then 
       read (archivo, dato)
    else 
		    dato.cod_producto := valoralto;
end;


procedure actualizarMaestro (var m:archivo_maestro ; var d:archivo_detalle);
var
	r_m : reg_maestro;
	r_d : reg_detalle;
	total_venta_unidades: integer;
	aux:integer;
begin
	
	reset(m);
	reset(d);
	
	read(m, r_m);
    leer(d, r_d);
    
	while (r_d.cod_producto <> valoralto) do begin
		
		aux:= r_d.cod_producto;
		total_venta_unidades:= 0;
		
		while (aux = r_d.cod_producto) do begin 
			total_venta_unidades:= total_venta_unidades + r_d.cant_vend;
			leer(d , r_d);
		end;
		while (aux <> r_m.cod_prod) do read(m , r_m);
		seek(m, filepos(m)-1);
		r_m.stock_actual :=  r_m.stock_actual - total_venta_unidades;
		write(m , r_m);
		
		if (not(EOF(m))) then read(m, r_m);
		
	end;
	close(m);
	close(d);
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
	text_productos , text_ventas : text;
	export_text_maestro:text;
	arch_maestro : archivo_maestro;
	arch_detalle : archivo_detalle;
	option : integer;
BEGIN
	assign(text_productos , 'productos.txt');
	assign(text_ventas, 'ventas.txt'); 
	assign(arch_maestro , 'maestro.dat');
	assign(arch_detalle , 'detalle.dat');
	
	assign(export_text_maestro, 'reporte.txt');
	
	mostrarMenu(option);
	
	while option <> 0 do begin 
		case (option) of
			1: importarMaestro(arch_maestro,text_productos);
			2: exportarMaestro(export_text_maestro , arch_maestro);
			3: importarDetalle(arch_detalle , text_ventas);
			4: listarEnPantallaDetalle(arch_detalle);
			5: actualizarMaestro(arch_maestro , arch_detalle);
		end;
		writeln('Enter para limpiar pantalla');
		readln();
		clrscr;
		mostrarMenu(option);
	end;
	
END.
