(:ISMAEL CARRASCO CUBERO:)
(:En mi PC especificar "llegaya.xml" da error de archivo no encontrado, es por ello que en las consultas solo aparece doc("llegaya")
Desconozco el motivo:)



(: Ejercicio 1 :)
(: Obtener la marca, modelo y precio de los vehiculos comerciales que le cuesten a la empresa menos de 100.000 €, ordenados desde el más caro al más barato.
Estructura: 
<vehiculo>
   <marca>Marca</marca>
   <modelo>Modelo</modelo>
   <precio moneda="EUR">XXX</precio>
</vehiculo>
:)
(:Esto deja bonita la salida:)
declare option output:method 'xml';
declare option output:indent 'yes';

for $v in doc("llegaya")//vehiculo
(:Itero por cada nodo de vehiculo para asociarlo a una variable:)
where $v/precio <= 100000
(:Filtro el valor de los precios:)
return
(:selecciono que valores de de las tuplas deben mostrarse:)
  <vehiculo>
   {$v/marca}
   {$v/modelo}
   {$v/precio}
  </vehiculo>


(: Ejercicio 2 :)
(: Obtener el nif, zona de reparto, nombre, teléfono y salario (en ese orden) de los repartidores que han realizado más 5 repartos con un vehículos de la marca "Tesla" en el 2023. (No sabemos su código, sólo la marca del vehiculo).
Resultado: 
<repartidor nif="23234234B" zona="D">
   <nombre>Víctor</nombre>
   <telefono>607624122</telefono>
   <salario unidad="Euros">1100</salario>
</repartidor>
:)

(:Esto deja bonita la salida:)
declare option output:method 'xml';
declare option output:indent 'yes';

for $repartidores in doc("llegaya")//repartidor
(:Itero los nodos repartidor:)
for $vehiculo in doc("llegaya")//vehiculo
(:Itero los nodos vehiculo:)
for $reparto in doc("llegaya")//reparto
(:Itero los nodos reparto:)
(:De esa forma se crean todas las combinaciones posibles entre las tres variables:)

  (:De todos los resusltados generdaos, filtramos solo los que coinciden con lo que se pide:)
  where $vehiculo//marca="Tesla"
  and $vehiculo/@cod=$reparto/@vehiculo
  and $reparto>5 
  and matches($reparto/@fechareparto,"2023")
  and $repartidores/@nif=$reparto/@repartidor

(:seleccionamos que valores mostrar, tras pasar el filtro:)
return
<repartidores>
{  
  $repartidores/@nif,
  $repartidores/@zona,
  $repartidores/nombre,
  $repartidores/telefono,
  $repartidores/salario
}
</repartidores>

(: Ejercicio 3 :)
(: Obtener (usando let) el número total de vehículos comerciales que tiene llegaya, el coste total de adquisición y el precio del vehículo más caro.
Estructura:
<totales>
   <flota_vehiculos>X</flota_vehiculos>
   <coste_total moneda="EUR">XXX</coste_total>
   <mas_caro moneda="EUR">XXX</mas_caro>
</totales>
:)
(:Esto deja bonita la salida:)
declare option output:method 'xml';
declare option output:indent 'yes';

(:Creamos una coleccion de vehiculos:)
let $flota := doc("llegaya")//vehiculos

(:seleccionamos que valores mostrar de la coleccion:)
return
<totales>
(:usamos funciones para transformar el resultado de la coleccion que se esta mostrando:)
<flota_vehiculos> 
 {count($flota/vehiculo)}
</flota_vehiculos>
<coste_total moneda="EUR">
    {sum($flota/vehiculo/precio)}
</coste_total>
  <mas_caro moneda="EUR">
    {max($flota//precio)}
  </mas_caro>
</totales>

(: Ejercicio 4 :)
(: Obtener, usando let, la suma de los salarios de los repartidores que cobran menos de 1.000 €, que viven en la provincia de Sevilla (excepto los que viven en la capital) y además no tienen zona A. 
Estructura:
<total_salarios moneda="EUR">XXX</total_salarios>
:) 
(:Esto deja bonita la salida:)
declare option output:method 'xml';
declare option output:indent 'yes';

(:Coleccion de repartidores y salarios filtrados con un predicado:)
let $repartidores := doc("llegaya")//repartidores/repartidor
let $salarios := $repartidores[salario < 1000 and provincia = "Sevilla" and localidad != "Sevilla" and not(@zona = "A")]/salario

(:Seleccion de que valores mostrar:)
return
<total_salarios moneda="EUR">
  {sum($salarios)}
</total_salarios>

(: Ejercicio 5 :)
(: Obtener el nombre del cliente, los paquetes que incluye esa entrega, el coste de la entrega y el precio con un descuento del 50% para empleados. Ordenar por el nombre del cliente desde el nombre más corto hasta el más largo.
Estructura:
<entrega>
   <nombre>Nombre</nombre>
   <paquetes>XX</paquetes>
   <importe moneda="EUR">XX</importe>
   <importe_empleados moneda="EUR">XX</importe_empleados>
</entrega>
:)

(:Esto deja bonita la salida:)
declare option output:method 'xml';
declare option output:indent 'yes';

(:Iteracion de todas las entregas:)
for $entrega in doc("llegaya")//entregas/entrega

order by (:Uso de la longitud de la cadena nombre para ordenar los resultados de forma ascendente:) [string-length($entrega/nombre)] ascending

(:Seleccion de valores:)
return
<entrega>
    {$entrega/nombre}
    {$entrega/paquetes}
    {$entrega/importe}
  <importe_empleados moneda="EUR">
    (:uso de la funcion div para dividir el resultado:)
    {$entrega/importe div 2}
  </importe_empleados>
</entrega>