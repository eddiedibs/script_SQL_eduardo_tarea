-- EJECUTAR ANTES DE REALIZAR LAS TAREAS:

-- Creación de la base de datos
CREATE DATABASE tienda;

-- Conexión a la base de datos
USE tienda;

-- Creación de la tabla clientes
CREATE TABLE clientes (
  id INT PRIMARY KEY,
  nombre VARCHAR(50),
  apellido VARCHAR(50),
  direccion VARCHAR(100),
  correo_electronico VARCHAR(100)
);

-- Creación de la tabla pedidos
CREATE TABLE pedidos (
  id INT PRIMARY KEY,
  fecha DATE,
  id_cliente INT,
  FOREIGN KEY (id_cliente) REFERENCES clientes(id)
);

-- Creación de la tabla ventas
CREATE TABLE ventas (
  id INT PRIMARY KEY,
  id_pedido INT,
  cantidad INT,
  precio DECIMAL(10,2),
  FOREIGN KEY (id_pedido) REFERENCES pedidos(id)
);

-- TAREAS A REALIZAR:

-- Consulta 1: Obtener el nombre completo, dirección y correo electrónico de todos los clientes que han realizado pedidos en los últimos 30 días.
SELECT c.nombre, c.apellido, c.direccion, c.correo_electronico
FROM clientes c
JOIN pedidos p ON c.id = p.id_cliente
WHERE p.fecha > DATE_SUB(CURDATE(), INTERVAL 30 DAY);

-- Consulta 2: Mostrar los productos con mayor cantidad de ventas en el último mes, junto con el total vendido de cada uno.
SELECT p.nombre, SUM(v.cantidad * v.precio) AS total_vendido
FROM productos p
JOIN ventas v ON p.id = v.id_producto
WHERE v.fecha > DATE_SUB(CURDATE(), INTERVAL 1 MONTH)
GROUP BY p.nombre
ORDER BY total_vendido DESC;

-- Consulta 3: Listar los clientes que han realizado más pedidos en el último año, ordenados por mayor cantidad de pedidos.
SELECT c.nombre, COUNT(p.id) AS cantidad_pedidos
FROM clientes c
JOIN pedidos p ON c.id = p.id_cliente
WHERE p.fecha > DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
GROUP BY c.nombre
ORDER BY cantidad_pedidos DESC;

-- Actualización 1: Aumentar el precio de todos los productos de la categoría "Camisetas" en un 10%.

UPDATE productos SET precio = (precio * 1.10) WHERE categoria = 'Camisetas';

-- Eliminación 2: Eliminar los pedidos que no tengan ventas asociadas.
DELETE FROM pedidos WHERE id NOT IN (SELECT p.id FROM ventas v JOIN pedidos p ON v.id_pedido =
p.id);

-- Creación de vista "vista_clientes_pedidos" que muestre el nombre completo del cliente, la fecha del pedido y el total del pedido.
CREATE VIEW vista_clientes_pedidos AS
SELECT c.nombre, p.fecha, SUM(v.cantidad * v.precio) AS total_pedido
FROM clientes c
JOIN pedidos p ON c.id = p.id_cliente
JOIN ventas v ON p.id = v.id_pedido
GROUP BY c.nombre, p.fecha;
