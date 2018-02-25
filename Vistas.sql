-- Vista de la tabla Cliente

DROP VIEW v_cliente;
DROP VIEW v_empleado;
DROP VIEW v_productor;
DROP VIEW v_pedidosucursal;
DROP VIEW v_productor;
DROP VIEW v_realizapedido;
DROP VIEW v_sucursal;
DROP VIEW v_vende;
DROP VIEW v_vino;


CREATE OR REPLACE VIEW v_cliente AS
    (SELECT * FROM panfleto951.cliente)
  UNION 
    (SELECT * FROM panfleto952.cliente)
  UNION 
    (SELECT * FROM panfleto953.cliente)
  UNION 
    (SELECT * FROM panfleto954.cliente);
    
-- Vista de la tabla empleado

CREATE OR REPLACE VIEW v_empleado AS
    (SELECT * FROM panfleto951.empleado)
  UNION 
    (SELECT * FROM panfleto952.empleado)
  UNION 
    (SELECT * FROM panfleto953.empleado)
  UNION 
    (SELECT * FROM panfleto954.empleado);
    
-- Vista de la tabla PedidoSucursal

CREATE OR REPLACE VIEW v_pedidoSucursal AS
    (SELECT * FROM panfleto951.pedidoSucursal)
  UNION 
    (SELECT * FROM panfleto952.pedidoSucursal)
  UNION 
    (SELECT * FROM panfleto953.pedidoSucursal)
  UNION 
    (SELECT * FROM panfleto954.pedidoSucursal);
    
-- Vista de la tabla RealizaPedido

CREATE OR REPLACE VIEW v_realizaPedido AS
    (SELECT * FROM panfleto951.realizaPedido)
  UNION 
    (SELECT * FROM panfleto952.realizaPedido)
  UNION 
    (SELECT * FROM panfleto953.realizaPedido)
  UNION 
    (SELECT * FROM panfleto954.realizaPedido);
    
-- Vista de la tabla Suscursal

CREATE OR REPLACE VIEW v_sucursal AS
    (SELECT * FROM panfleto951.sucursal)
  UNION 
    (SELECT * FROM panfleto952.sucursal)
  UNION 
    (SELECT * FROM panfleto953.sucursal)
  UNION 
    (SELECT * FROM panfleto954.sucursal);
    
-- Vista de la tabla Vende

CREATE OR REPLACE VIEW v_vende AS
    (SELECT * FROM panfleto951.vende)
  UNION 
    (SELECT * FROM panfleto952.vende)
  UNION 
    (SELECT * FROM panfleto953.vende)
  UNION 
    (SELECT * FROM panfleto954.vende);
    
-- Vista de la tabla Vino

CREATE OR REPLACE VIEW v_vino AS
    (SELECT * FROM panfleto951.vino)
  UNION 
    (SELECT * FROM panfleto952.vino)
  UNION 
    (SELECT * FROM panfleto953.vino)
  UNION 
    (SELECT * FROM panfleto954.vino);
    