-- TRIGGERS

-- 1. RESTRICCIONES DE CLAVE ÚNICA

-- TRIGGER QUE CONTROLA QUE NO SE INTRODUZCA UNA SUCURSAL QUE YA EXISTA EN EL SISTEMA.
-- NOS MOSTRARÁ UN MENSAJE DE ERROR PARA INFORMARNOS.

CREATE OR REPLACE TRIGGER TR_PK_SUCURSAL BEFORE INSERT OR UPDATE ON Sucursal FOR EACH ROW
DECLARE
	cont NUMBER(1);
BEGIN
  IF (INSERTING) THEN -- SI ESTAMOS INSERTANDO...
    -- COMPROBAMOS SI HAY SUCURSALES CON ESA CLAVE
    SELECT COUNT(codSucursal) INTO cont 
      FROM v_sucursal 
      WHERE codSucursal = :NEW.codSucursal;
    IF (cont>0) THEN -- SI EL NUMERO DE SUCURSAL DEVUELTO POR LA CONSULTA ES MAYOR QUE CERO
      RAISE_APPLICATION_ERROR(-20001,'YA EXISTE UNA SUCURSAL CON ESA CLAVE.');
    END IF;
  END IF;
  -- SI ACTUALIZAMOS NO PERMITIMOS CAMBIAR LA CLAVE
  IF (UPDATING('codSucursal')) THEN 
    RAISE_APPLICATION_ERROR(-20002, 'NO SE PUEDE CAMBIAR EL CÓDIGO A UNA SUCURSAL.');
  END IF;
END;
/

-- TRIGGER QUE CONTROLA QUE NO SE INTRODUZCA UN CLIENTE QUE YA EXISTA EN EL SISTEMA.
-- NOS MOSTRARÁ UN MENSAJE DE ERROR PARA INFORMARNOS

CREATE OR REPLACE TRIGGER TR_PK_CLIENTE BEFORE INSERT OR UPDATE ON Cliente FOR EACH ROW
DECLARE
	cont NUMBER(1);
BEGIN
  IF (INSERTING) THEN -- SI ESTAMOS INSERTANDO...
    -- COMPROBAMOS QUE NO EXISTE UN CLIENTE CON ESA CLAVE.
    SELECT COUNT(codCliente) INTO cont 
      FROM v_cliente 
      WHERE codCliente = :NEW.codCliente;
    IF (cont>0) THEN  -- SI EL NUMERO DE CLIENTE DEVUELTO POR LA CONSULTA ES MAYOR QUE CERO
      RAISE_APPLICATION_ERROR(-20003,'YA EXISTE UN CLIENTE CON ESA CLAVE.');
    END IF;
  END IF;
  -- SI ACTUALIZAMOS NO PERMITIMOS CAMBIAR LA CLAVE
  IF (UPDATING('codCliente')) THEN
    RAISE_APPLICATION_ERROR(-20004, 'NO SE PUEDE CAMBIAR EL CÓDIGO A UN CLIENTE');
  END IF;
END;
/

-- TRIGGER QUE CONTROLA QUE NO SE INTRODUZCA UN EMPLEADO QUE YA EXISTA EN EL SISTEMA.
-- NOS MOSTRARÁ UN MENSAJE DE ERROR PARA INFORMARNOS

CREATE OR REPLACE TRIGGER TR_PK_EMPLEADO BEFORE INSERT OR UPDATE ON Empleado FOR EACH ROW
DECLARE
	cont NUMBER(1);
BEGIN
  IF (INSERTING) THEN -- SI ESTAMOS INSERTANDO...
    -- COMPROBAMOS QUE NO EXISTE NINGÚN EMPLEADO CON ESA CLAVE
    SELECT COUNT(codEmpleado) INTO cont 
      FROM v_empleado 
      WHERE codEmpleado = :NEW.codEmpleado;
    IF (cont>0) THEN  -- Si el numero de empleado devuelto por la consulta es mayor que cero
      RAISE_APPLICATION_ERROR(-20005,'YA EXISTE UN EMPLEADO CON ESA CLAVE.');
    END IF;
  END IF;
  -- SI ACTUALIZAMOS NO PERMITIMOS CAMBIAR LA CLAVE.
  IF (UPDATING('codEmpleado')) THEN
    RAISE_APPLICATION_ERROR(-20006, 'NO SE PUEDE CAMBIAR EL CÓDIGO A UN EMPLEADO');
  END IF;
END;
/

-- TRIGGER QUE CONTROLA QUE NO SE INTRODUZCA UN VINO QUE YA EXISTA EN EL SISTEMA.
-- NOS MOSTRARÁ UN MENSAJE DE ERROR PARA INFORMARNOS

CREATE OR REPLACE TRIGGER TR_PK_VINO BEFORE INSERT ON Vino FOR EACH ROW
DECLARE
	cont NUMBER(1);
BEGIN
  IF (INSERTING) THEN -- SI ESTAMOS INSERTANDO...
    -- COMPROBAMOS QUE NO EXISTE NINGÚN VINO CON ESA CLAVE
    SELECT COUNT(codVino) INTO cont 
      FROM v_vino 
      WHERE codVino = :NEW.codVino;
    IF (cont>0) THEN  -- SI EL NUMERO DE VINO DEVUELTO POR LA CONSULTA ES MAYOR QUE CERO
      RAISE_APPLICATION_ERROR(-20007,'YA EXISTE UN VINO CON ESA CLAVE.');
    END IF;
  END IF;
  -- SI ACTUALIZAMOS NO PERMITIMOS CAMBIAR LA CLAVE
  IF (UPDATING('codVino')) THEN
    RAISE_APPLICATION_ERROR(-20008, 'NO SE PUEDE CAMBIAR EL CÓDIGO A UN VINO');
  END IF;
END;
/

-- Trigger que controla que no se introduzca un pedido de cliente que ya exista 
-- en el sistema. Nos mostrará un mensaje de error para informarnos

CREATE OR REPLACE TRIGGER TR_PK_REALIZAPEDIDO BEFORE INSERT OR UPDATE ON realizaPedido FOR EACH ROW
DECLARE
	cont NUMBER(1);
BEGIN
  IF (INSERTING) THEN -- SI ESTAMOS INSERTANDO...
    -- COMPROBAMOS QUE NO EXISTE OTRO PEDIDO DE UN CLIENTE CON ESA CLAVE
    SELECT COUNT(*) INTO cont FROM v_realizaPedido 
      WHERE codVino = :NEW.codVino
        AND codSucursal = :NEW.codSucursal 
        AND codCliente = :NEW.codCliente 
        AND fecha= :NEW.fecha;
    IF (cont>0) THEN -- SI EL VALOR DEVUELTO POR LA CONSULTA ES MAYOR QUE CERO
      RAISE_APPLICATION_ERROR(-20009,'YA EXISTE UN PEDIDO DE UN CLIENTE EN ESA FECHA.');
    END IF;
  END IF;
  -- SI ACTUALIZAMOS NO PERMITIMOS CAMBIAR LA CLAVE
  IF (UPDATING('codVino') OR UPDATING('codSucursal') OR UPDATING('codCliente'))THEN
    RAISE_APPLICATION_ERROR(-20010,'NO SE PUEDE CAMBIAR EL CÓDIGO A PEDIDO DE UN CLIENTE.');
  END IF;
END;
/

-- TRIGGER QUE CONTROLA QUE NO SE INTRODUZCA UN PEDIDO DE UNA SUCURSAL A OTRA QUE YA EXISTA 
-- EN EL SISTEMA. NOS MOSTRARÁ UN MENSAJE DE ERROR PARA INFORMARNOS

CREATE OR REPLACE TRIGGER TR_PK_PEDIDO_SURCURSAL BEFORE INSERT ON PedidoSucursal FOR EACH ROW
DECLARE
	cont NUMBER(1);
BEGIN
  IF (INSERTING) THEN -- SI ESTAMOS INSERTANDO...
    -- COMPROBAMOS QUE NO EXISTE UN PEDIDO ENTRE SUCURSALES CON LA MISMA CLAVE
    SELECT COUNT(*) INTO cont FROM v_pedidoSucursal 
      WHERE Vino = :NEW.Vino
        AND codSucPide = :NEW.codSucPide 
        AND codSucPedido = :NEW.codSucPedido 
        AND fecha= :NEW.fecha;
    IF (cont>0) THEN -- SI EL VALOR DEVUELTO POR LA CONSULTA ES MAYOR QUE CERO
      RAISE_APPLICATION_ERROR(-20011,'YA EXISTE UN PEDIDO A UNA SUCURUSAL CON ESA CLAVE.');
    END IF;
  END IF;
  -- SI ACTUALIZAMOS NO PERMITIMOS CAMBIAR LA CLAVE.
  IF (UPDATING('codSucPide') OR UPDATING('codSucPedido') OR UPDATING('fecha'))THEN
    RAISE_APPLICATION_ERROR(-20012,'NO SE PUEDE CAMBIAR EL CÓDIGO A UN PEDIDO DE UNA SUCURSAL.');
  END IF;
END;
/

-- TRIGGER QUE CONTROLA QUE UNA SUCURSAL VENDA DOS VECES EL MISMO VINO O QUE
-- UN VINO NO SEA VENDIDO DOS VECES POR UNA SUCURSAL. EL SISTEMA NOS MOSTRARÁ UN
-- MENSAJE DE ERROR PARA INFORMARNOS

CREATE OR REPLACE TRIGGER TR_PK_VENDE BEFORE INSERT ON Vende FOR EACH ROW
DECLARE
	cont NUMBER(1);
BEGIN
  IF INSERTING THEN -- SI ESTAMOS INSERTANDO...
    -- COMPROBAMOS QUE NO SE ROMPA RESTRICCION COMENTADA ANTERIORMENTE
    SELECT COUNT(*) INTO cont FROM v_vende 
      WHERE codVino = :NEW.codVino
        AND codSucursal = :NEW.codSucursal;
    IF (cont>0) THEN  -- SI EL VALOR DEVUELTO POR LA CONSULTA ES MAYOR QUE CERO
      RAISE_APPLICATION_ERROR(-20013,'YA EXISTE UN VINO CON ESE CODIGO PARA ESA SUCURSAL.');
    END IF;
  END IF;
  -- SI ACTUALIZAMOS NO PERMITIMOS CAMBIAR LA CLAVE.
  IF (UPDATING('codVino') OR UPDATING('codSucursal'))THEN
    RAISE_APPLICATION_ERROR(-20014,'NO SE PUEDE CAMBIAR EL CÓDIGO DE UN VINO DE UNA SUCURSAL.');
  END IF;
END;
/

-- 2. RESTRICCIONES NO NULAS QUE SE CONSIDEREN OPORTUNAS.

-- REALIZADAS EN LA DEFINICION DE TABLA.

-- 3. EL DIRECTOR DE UNA SUCURSAL ES EMPLEADO DE LA COMPAÑIA (NO TIENE QUE SER 
-- EMPLEADO DE LA SUCURSAL).

CREATE OR REPLACE TRIGGER TR_DIRECTOR_EMPLEADO BEFORE INSERT OR UPDATE ON Sucursal FOR EACH ROW
DECLARE
	xCont NUMBER(1);
BEGIN
    IF (UPDATING('director') OR INSERTING) THEN  -- SI ACTUALIZAMOS DIRECTOR O INSERTAMOS
      IF (:NEW.director IS NOT NULL) THEN -- SI ES NULO LO PASAMOS POR ALTO
        -- COMPROBAMOS SI EL EMPLEADO EXISTE EN LA COMPAÑIA.
        SELECT COUNT(*) INTO xCont FROM v_empleado
          WHERE codEmpleado = :NEW.director;
        IF (xCont = 0) THEN -- SI EL VALOR DEVUELTO POR LA CONSULTA ES MAYOR QUE CERO
          RAISE_APPLICATION_ERROR(-20015,'ESE CODIGO DE EMPLEADO NO EXISTE EN LA COMPAÑÍA.');
        END IF;
      END IF;
    END IF;
END;
/
commit;

-- 4. UN EMPLEADO, AL MISMO TIEMPO, SOLAMENTE PUEDE SER DIRECTOR DE UNA SUCURSAL.

CREATE OR REPLACE TRIGGER TR_DIREC_EMPL_UNIQUE BEFORE INSERT OR UPDATE ON Sucursal FOR EACH ROW
DECLARE
	cont NUMBER(1);
BEGIN
  -- COMPROBAMOS QUE EL EMPLEADO NO SEA DIRECTOR DE ALGUNA COMPAÑÍA.
	SELECT COUNT(*) INTO cont FROM v_empleado 
		WHERE codEmpleado = :NEW.director;
	IF (cont>1) THEN -- SI EL VALOR DEVUELTO POR LA CONSULTA ES MAYOR QUE CERO
		RAISE_APPLICATION_ERROR(-20016,'ESE CODIGO DE EMPLEADO YA ES DIRECTOR EN UNA SUCURSAL.');
	END IF;
END;
/

-- 5. UN EMPLEADO, AL MISMO TIEMPO, SOLAMENTE PUEDE TRABAJAR EN UNA SUCURSAL.

-- ESTÁ HECHO POR DEFINICIÓN EN LA TABLA

-- 6. EL SALARIO DE UN EMPLEADO NUNCA PUEDE DISMINUIR.

CREATE OR REPLACE TRIGGER TR_SALARIO_EMP BEFORE UPDATE ON Empleado FOR EACH ROW
DECLARE
BEGIN
  IF UPDATING('salario') THEN -- SI LO QUE SE ACTUALIZA ES EL SALARIO
    IF (:OLD.Salario > :NEW.Salario ) THEN -- SI EL SALARIO ANTIGUO ES MAYOR QUE EL NUEVO
      RAISE_APPLICATION_ERROR(-20017,'EL SALARIO DEL EMPLEADO NO PUEDE DISMINUIR. 
        SU SALARIO ACTUAL ES DE '|| :OLD.Salario || ' €.');
    END IF;
  END IF;
END;
/

-- 7. LA SUCURSAL DONDE TRABAJA UN EMPLEADO DEBE EXISTIR.

CREATE OR REPLACE TRIGGER TR_SUCURSAL_EMP BEFORE INSERT OR UPDATE ON Empleado FOR EACH ROW
DECLARE
  cont NUMBER(1);
BEGIN
  IF (UPDATING ('codSucursal') OR INSERTING) THEN
    -- COMPROBAMOS QUE EXISTE LA SUCURSAL.
    SELECT COUNT(codSucursal) INTO cont FROM v_sucursal
      WHERE codSucursal = :NEW.codSucursal;
        IF (cont=0) THEN -- SI LA SUCURSAL EXISTE.
          RAISE_APPLICATION_ERROR(-20018,'LA SUCURSAL PARA ESE EMPLEADO DEBE DE EXISTIR.');
        END IF;
  END IF;
END;
/

-- 8. LOS CLIENTES SOLAMENTE PUEDEN SER DE TIPO 'A' (SUPERMERCADOS E 
-- HIPERMERCADOS), 'B' (TIENDAS DE ALIMENTACIсN Y PARTICULARES O 'C' (RESTAURANTES).

CREATE OR REPLACE TRIGGER TR_TIPO_CLI BEFORE INSERT OR UPDATE ON Cliente FOR EACH ROW
DECLARE

BEGIN
  IF (UPDATING ('tipoCliente') OR INSERTING) THEN
    IF (:NEW.tipoCliente NOT IN('A','B','C')) THEN -- SI EL TIPO ES DIFERENTE A LOS PERMITIDOS.
      RAISE_APPLICATION_ERROR(-20019,'EL TIPO DE CLIENTE SOLAMENTE PUEDE SER: 
      A = (SUPERMERCADOS E HIPERMERCADOS), B = (TIENDAS DE ALIMENTACIÓN Y 
      PARTICULARES O C = (RESTAURANTES).');
    END IF;
  END IF;
END;
/

-- 9. UN CLIENTE PUEDE SOLICITAR A LA COMPAÑÍA SUMINISTROS DE CUALQUIER VINO, 
-- PERO SIEMPRE TENDRÁ QUE HACERLO A TRAVÉS DE SUCURSALES DE LA DELEGACIÓN A 
-- LA QUE PERTENECE SU COMUNIDAD AUTÓNOMA.

CREATE OR REPLACE TRIGGER TR_SUCURSAL_PED_CLI BEFORE INSERT OR UPDATE ON realizaPedido FOR EACH ROW
DECLARE
	cont NUMBER(8);
  valido NUMBER (1); -- INDICARÁ SI LA SUCURSAL A LA QUE SE PIDE ES CORRECTA.
  xCodSucursal Sucursal.codSucursal%TYPE; -- DONDE ALMACENAREMOS LA POSIBLE SUCURSAL.
  xCCAA cliente.CCAA%TYPE;  -- COMUNIDAD AUTONOMA DEL CLIENTE.
  xDelegacion Sucursal.delegacion%TYPE; -- GUARDAMOS LA DELEGACIÓN QUE PERTENECE AL CLIENTE.
  CURSOR Cu_Sucursales IS -- CURSOR PARA LAS POSIBLES SUCURSALES A LAS QUE PUEDE PEDIR.
    SELECT codSucursal 
      FROM v_sucursal 
      WHERE delegacion = xDelegacion;
    
BEGIN

  valido := 0;
  SELECT CCAA INTO xCCAA 
    FROM v_cliente 
    WHERE codCliente = :NEW.codCliente;

  PR_GET_DELEGACION(xDelegacion, xCCAA); -- LLAMAMOS AL PROCEDIMIENTO QUE
                                -- NOS DEVUELVE LA DELEGACION DEL CLIENTE.
  
  -- EJECUTAMOS EL CURSOR CON LA DELEGACIÓN CORRECTA.
    
  OPEN Cu_Sucursales; -- ABRIMOS EL CURSOR CON LA DELEGACION CORRECTA
  FETCH Cu_Sucursales INTO xCodSucursal; -- LEEMOS EL PRIMER VALOR
  WHILE Cu_Sucursales%FOUND -- MIENTRAS LA ÚLTIMA FILA HAYA SIDO LEÍDA CON ÉXITO
  LOOP
    IF (xCodSucursal = :NEW.codSucursal) THEN -- SI LA SUCURSAL INSERTADA 
      valido := 1;        -- COINCIDE CON UNA POSIBLE DEL CLIENTE
      
    END IF;
    FETCH Cu_Sucursales INTO xCodSucursal; -- LEEMOS LA SIGUIENTE SUCURSAL
  END LOOP;
  CLOSE Cu_Sucursales; -- CERRAMOS EL CURSOR.
  IF (valido = 0) THEN  -- SI LA SUCURSAL NO ES NINGUNA DE LAS POSIBLES.
    RAISE_APPLICATION_ERROR(-20020, 'EL CLIENTE DEBE PEDIR A UNA SUCURSAL QUE LE CORRESPONDA.');
  END IF;
END;
/

-- 10. PARA CADA CLIENTE, LA FECHA DE UN SUMINISTRO TENDRÁ QUE SE SIEMPRE IGUAL
-- O POSTERIOR A LA FECHA DE SU ÚLTIMO SUMINISTRO.

CREATE OR REPLACE TRIGGER TR_PED_CLI_FEC_SUMI BEFORE INSERT OR UPDATE ON realizaPedido FOR EACH ROW
DECLARE
  xFechaMax realizapedido.fecha%TYPE;
BEGIN
  IF (INSERTING) THEN -- SI ESTAMOS INSERTANDO
    -- COMPROBAMOS LA ÚLTIMA FECHA DEL PEDIDO DEL CLIENTE A ESA SUCURSAL SOBRE
    -- ESE VINO
    SELECT MAX(fecha) INTO xFechaMax 
      FROM v_realizaPedido
      WHERE codCliente = :NEW.codCliente 
        AND codSucursal = :NEW.CodSucursaL 
        AND codVino = :NEW.CodVino;
    IF (xFechaMax > :NEW.fecha) THEN -- SI LA FECHA A INTRODUCIR ES MENOR QUE 
                              --LA ÚLTIMA QUE HABÍA INSERTADA PARA ESE CLIENTE
      RAISE_APPLICATION_ERROR(-20021, 'LA FECHA DEL NUEVO PEDIDO NO PUEDE SER 
        INFERIOR A: ' || xFechaMax);
    END IF;
  END IF;
  -- SI ESTAMOS ACTUALIZANDO 
  IF (UPDATING('Cantidad'))THEN  -- SI ESTAMOS ACTUALIZANDO LA FECHA
    IF (:OLD.fecha > :NEW.fecha) THEN -- COMPROBAMOS QUE LA NUEVA FECHA NO 
                                -- SEA MÁS ANTIGUA QUE LA QUE HABÍA
      RAISE_APPLICATION_ERROR(-20022, 'LA NUEVA FECHA DEL PEDIDO NO PUEDE SER 
        INFERIOR A LA QUE TENÍA ANTERIORMENTE ' || xFechaMax);
    END IF;
  END IF;
END;
/

--  11. NO SE PUEDE SUMINISTRAR UN VINO QUE NO EXISTE.

CREATE OR REPLACE TRIGGER PR_INS_VIN_REALSUC BEFORE INSERT OR UPDATE ON realizaPedido FOR EACH ROW
DECLARE
  xCont NUMBER(8);
BEGIN
  -- SI ESTAMOS INSERTANDO O ACTUALIZANDO EL CAMPO DEL CÓDIGO DEL VINO
  IF INSERTING OR UPDATING('codVino') THEN
    -- COMPROBAMOS SI ESE VINO EXISTE.
    SELECT COUNT (*) INTO xCont 
      FROM v_vino 
      WHERE codVino = :NEW.codVino;
    IF(xCont = 0) THEN  -- SI NO EXISTE MOSTRAMOS EL ERROR.
      RAISE_APPLICATION_ERROR(-20023, 'NO SE PUEDE SUMINISTRAR UN VINO QUE NO EXISTE.');
    END IF;
  END IF;
END;
/

-- 12. UN VINO SOLAMENTE PUEDE PRODUCIRLO UN PRODUCTOR.

CREATE OR REPLACE TRIGGER TR_VINO_PROD BEFORE INSERT ON vino FOR EACH ROW
DECLARE
  xCont NUMBER(8);
BEGIN
  IF (INSERTING) THEN -- MIRAMOS SI HAY ALGÚN PRODUCTOR QUE YA PRODUZCA ESA MARCA
    SELECT COUNT (*) INTO xCont 
      FROM v_vino 
      WHERE marca = :NEW.marca 
        AND codProductor <> :NEW.codProductor;
    IF (xCont > 0) THEN -- SI ENCONTRAMOS ALGUNO...
      RAISE_APPLICATION_ERROR(-20024, 'ESA MARCA YA PERTENECE A OTRO PRODUCTOR.');
    END IF;
  END IF;
END;
/

-- 13. UN VINO NO PUEDE EXISTIR SI NO EXISTE UN PRODUCTOR QUE LO PRODUZCA.

CREATE OR REPLACE TRIGGER TR_INS_PROD_VINO BEFORE INSERT OR UPDATE ON vino FOR EACH ROW
DECLARE
  xCont NUMBER(8);  -- CONTADOR
BEGIN
  IF (INSERTING OR UPDATING('codProductor')) THEN -- SI INSERTAMOS O ACTUALIZAMOS
    -- COMPROBAMOS SI EXISTE EL CÓDIGO DEL PRODUCTOR
    SELECT COUNT (*) INTO xCont 
      FROM productor 
      WHERE codProductor = :NEW.codProductor;
    IF (xCont = 0) THEN -- SI NO EXISTE EL CÓDIGO DEL PRODUCTOR.
      RAISE_APPLICATION_ERROR(-20025, 'EL VINO TIENE QUE TENER UN PRODUCTOR.');
    END IF;
  END IF;
END;
/

-- 14. EL STOCK DE UN VINO NUNCA PUEDE SER NEGATIVO NI MAYOR QUE LA CANTIDAD PRODUCIDA.

CREATE OR REPLACE TRIGGER TR_VINO_STOCK BEFORE INSERT OR UPDATE ON vino FOR EACH ROW
DECLARE

BEGIN
  IF (UPDATING('stock') OR INSERTING) THEN  -- SI INSERTAMOS O ACTUALIZAMOS EL STOCK
     IF (:NEW.stock < 0 OR :NEW.stock > :NEW.cantidad) THEN -- COMPROBAMOS EL NUEVO VALOR DEL STOCK.
      RAISE_APPLICATION_ERROR(-20026, 'EL STOCK NO PUEDE SER SUPERIOR A LA 
          CANTIDAD DE VINO PRODUCIDO NI INFERIOR A CERO');
     END IF;
  END IF;
END;
/

-- 15. LOS DATOS REFERENTES A UN VINO SOLAMENTE PODRÁN ELIMINARSE DE LA BASE DE 
-- DATOS SI LA CANTIDAD TOTAL SUMINISTRADA DE ESE VINO ES 0 (O SI ESE VINO NO HA
-- SIDO SUMINISTRADO NUNCA).

CREATE OR REPLACE TRIGGER TR_VINO_DELETE BEFORE DELETE ON vino FOR EACH ROW
DECLARE
  xContRealPedi NUMBER(8); -- CONTADOR DE LOS VINOS EN REALIZAPEDIDO
  xContPediSuc NUMBER(8); -- CONTADOR DE LOS VINOS EN PEDIDOSUCURSAL
BEGIN
  -- COMPROBAMOS QUE NO EXISTE NINGÚN VINO DE LOS QUE SE VAN A BORRAR EN LAS
  -- TABLAS DE LOS PEDIDOS DE LAS SUCURSALES NI EN LA DE PEDIDOS DE CLIENTES.
  SELECT COUNT (*) INTO xContRealPedi 
    FROM v_realizaPedido 
    WHERE codVino = :OLD.codVino;
  SELECT COUNT (*) INTO xContPediSuc 
    FROM v_pedidoSucursal 
    WHERE vino = :OLD.codVino;
  IF (xContRealPedi > 0 OR xContPediSuc > 0) THEN -- SE HA SUMINISTRADO EL VINO
    RAISE_APPLICATION_ERROR(-20027, 'NO SE PUEDE BORRAR UN VINO QUE HA SIDO SUMINISTRADO');
  END IF;
END;
/

-- 16. LOS DATOS REFERENTES A UN PRODUCTOR SOLAMENTE PODRÁN ELIMINARSE DE LA 
-- BASE DE DATOS SI PARA CADA VINO QUE SE PRODUCE, LA CANTIDAD TOTAL SUMINISTRADA
-- ES 0 O NO EXISTE NINGÚN SUMINISTRO.

CREATE OR REPLACE TRIGGER TR_DEL_PROV BEFORE DELETE ON productor FOR EACH ROW
DECLARE
  xContRealPedi NUMBER(8); -- CONTADOR DE LOS VINOS EN REALIZAPEDIDO
  xContPediSuc NUMBER(8); -- CONTADOR DE LOS VINOS EN PEDIDOSUCURSAL
  CURSOR CU_VINOS_PROD IS -- CURSOR PARA RECORRER TODOS LOS VINOS DE UN PRODUCTOR
    SELECT codVino 
      FROM v_vino 
      WHERE codProductor = :OLD.codProductor; 
  xCodVino vino.codVino%TYPE; -- DONDE ALMACENAREMOS EL CÓDIGO DE CADA VINO
BEGIN
  OPEN CU_VINOS_PROD; -- ABRIMOS EL CURSOR
  FETCH CU_VINOS_PROD INTO xCodVino; -- LEEMOS EL PRIMER VINO SI LO HUBIESE
  WHILE CU_VINOS_PROD%FOUND LOOP -- SI SE HA LEIDO CORRECTAMENTE
    -- COMPROBAMOS QUE EL VINO NO HA SIDO PEDIDO POR NINGUNA SUCURSAL NI POR
    -- NINGÚN CLIENTE.
    SELECT COUNT (*) INTO xContRealPedi 
      FROM v_realizaPedido 
      WHERE codVino = xCodVino;
    SELECT COUNT (*) INTO xContPediSuc 
      FROM v_pedidoSucursal 
        WHERE vino = xCodVino;
    IF (xContRealPedi > 0 OR xContPediSuc > 0) THEN -- SE HA SUMINISTRADO EL VINO EN CUALQUIERA DE LAS DOS TABLAS
      RAISE_APPLICATION_ERROR(-20028, 'NO SE PUEDE BORRAR UN VINO QUE HA SIDO SUMINISTRADO');
    END IF;
    FETCH CU_VINOS_PROD INTO xCodVino;  -- LEEMOS EL SIGUIENTE REGISTRO DEL CURSOR
  END LOOP;
  CLOSE CU_VINOS_PROD; -- CERRAMOS EL CURSOR.
END;
/

-- 17. UNA SUCURSAL NO PUEDE REALIZAR PEDIDOS A SUCURSALES DE SU MISMA DELEGACIÓN.

CREATE OR REPLACE TRIGGER TR_PED_SUC_A_SUC BEFORE INSERT OR UPDATE ON PedidoSucursal FOR EACH ROW
DECLARE
  xDelegacion1 Sucursal.delegacion%TYPE;
  xDelegacion2 Sucursal.delegacion%TYPE;
BEGIN
    -- COMPROBAMOS LA DELEGACIÓN DE LAS DOS SUCURSALES.
    SELECT delegacion INTO xDelegacion1 
      FROM v_Sucursal 
      WHERE codSucursal = :NEW.codSucPide;
    SELECT delegacion INTO xDelegacion2 
      FROM v_Sucursal 
      WHERE codSucursal = :NEW.codSucPedido;
    IF (xDelegacion1 = xDelegacion2) THEN -- COMPROBAMOS QUE NO SEAN LAS MISMAS
      RAISE_APPLICATION_ERROR(-20029, 'LA DELEGACIÓN DE LA SUCURSAL A LA QUE SE 
          REALIZA EL PEDIDO NO PUEDE SER LA MISMA');
    END IF;
END;
/

-- 18. LA CANTIDAD TOTAL DE CADA VINO QUE LAS SUCURSALES PIDEN A OTRAS SUCURSALES,
-- NO PUEDE EXCEDER LA CANTIDAD TOTAL QUE DE ESE VINO SOLICITAN LOS CLIENTES.

CREATE OR REPLACE TRIGGER TR_PED_SUC_CANT_INS BEFORE INSERT OR UPDATE ON pedidoSucursal FOR EACH ROW
DECLARE
  xCantidad pedidoSucursal.cantidad%TYPE;
  xCont NUMBER(8);
BEGIN
  -- SI ESTAMOS INSERTANDO UN NUEVO PEDIDO...
  IF (INSERTING) THEN     
    -- COMPROBAMOS SI EXISTE PEDIDO DE ESE VINO A ESA SUCURSAL.
    SELECT COUNT (*) INTO xCont FROM v_realizaPedido WHERE codVino = :NEW.vino 
        AND codsucursal = :NEW.codSucPide;
    IF (xCont = 0) THEN
      RAISE_APPLICATION_ERROR(-20042,'NO HAY PEDIDOS DE CLIENTES CON A ESTA 
          SUCURSAL SOBRE ESTE VINO');
    ELSE  -- SI EXISTE, PRIMERO CALCULAMOS EL TOTAL QUE SE HA PEDIDO PARA ESA SUCURSAL ESE VINO
      SELECT SUM(cantidad) INTO xCantidad 
        FROM v_realizaPedido 
        WHERE codVino = :NEW.vino 
          AND codsucursal = :NEW.codSucPide 
        GROUP BY codVino, codSucursal;
      IF (:NEW.Cantidad > xCantidad OR :NEW.Cantidad <= 0) THEN -- SI LA NUEVA 
      -- CANTIDAD ES MAYOR A LA QUE NOS DA LA SUMA O ES IGUAL A 0...
        RAISE_APPLICATION_ERROR(-20043, 'LA CANTIDAD PEDIDA A LA SUCURSAL NO 
          PUEDE SER MAYOR AL TOTAL QUE SE HA PEDIDO DE ESE VINO O CERO');
      END IF;
    END IF;
  END IF;
  IF UPDATING('Cantidad') THEN -- SI ACTUALIZAMOS EL REGISTRO...
  -- CALCULAMOS EL TOTAL QUE SE HA PEDIDO PARA ESA SUCURSAL, ESE VINO
    SELECT SUM(cantidad) INTO xCantidad 
      FROM v_realizaPedido 
      WHERE codVino = :NEW.vino 
        AND codsucursal = :NEW.codSucPide 
      GROUP BY codVino, codSucursal;
      IF (:OLD.cantidad < :NEW.cantidad ) THEN
        IF (xCantidad < :NEW.cantidad OR :NEW.cantidad<0) THEN -- SI LA CANTIDAD 
        -- SUMINISTRADA ES MENOR A LA QUE SE VA A PEDIR...
        RAISE_APPLICATION_ERROR(-20032, 'LA CANTIDAD DE VINO NO PUEDE SER SUPERIOR 
          A LA QUE HAN SOLICITADO LOS CLIENTES O NEGATIVA.');
      END IF; 
    END IF;
  END IF;
END;
/

-- 19. LA SUCURSAL A LA QUE OTRA SE DIRIGE PARA HACER PEDIDOS DE VINO QUE ELLA 
-- NO DISTRIBUYE, TIENE QUE SUMINISTRAR DIRECTAMENTE EL VINO QUE SE SOLICITA; 
-- ES DECIR, SI POR EJEMPLO UNA SUCURSAL DE ANDALUCÍA REQUIERE VINO DE RIOJA, 
-- TIENE QUE SOLICITARLO, NECESARIAMENTE, A UNA SUCURSAL DE LA DELEGACION DE MADRID

CREATE OR REPLACE TRIGGER TR_PIDE_OTRA_SUCURSAL BEFORE INSERT OR UPDATE ON pedidoSucursal FOR EACH ROW
DECLARE
  xDelegVino sucursal.delegacion%TYPE;
  xDelegPedi sucursal.delegacion%TYPE;
  xCCAAvino vino.CCAA%TYPE;
  xCont NUMBER(1);
  
BEGIN
  
  -- COMPROBAMOS QUE LA SUCURSAL QUE PIDE EXISTE
  SELECT COUNT(*) INTO xCont FROM v_sucursal WHERE codSucursal = :NEW.codSucPide;
  IF (xCont = 0) THEN
    RAISE_APPLICATION_ERROR(-20033, 'LA SUCURSAL QUE REALIZA EL PEDIDO NO EXISTE');
  END IF;
  
  -- COMPROBAMOS QUE LA SUCURSAL QUE PIDE EXISTE
  SELECT COUNT(*) INTO xCont FROM v_sucursal WHERE codSucursal = :NEW.codSucPedido;
  IF (xCont = 0) THEN
    RAISE_APPLICATION_ERROR(-20034, 'LA SUCURSAL A LA QUE SE LE REALIZA EL PEDIDO NO EXISTE');
  END IF;
  
  -- COMPROBAMOS QUE EXISTE EL VINO
  
  SELECT COUNT(*) INTO xCont FROM v_vino WHERE codVino = :NEW.Vino;
  IF (xCont = 0) THEN
    RAISE_APPLICATION_ERROR(-20035, 'EL VINO SOLICITADO NO EXISTE');
  END IF;  
  
  -- SELECCIONAMOS LA DELEGACIÓN DE LA SUCURSAL A LA QUE SE LE PIDE
  
  SELECT delegacion INTO xDelegPedi FROM v_sucursal WHERE codSucursal = :NEW.codSucPedido;
  
  -- OBTENEMOS LA DELEGACIÓN A LA QUE PERTENECE EL VINO
  
  SELECT CCAA INTO xCCAAvino FROM v_vino WHERE codVino = :NEW.Vino;
  
  PR_GET_DELEGACION(xDelegVino, xCCAAvino);
  
  IF (xDelegVino <> xDelegPedi) THEN
    RAISE_APPLICATION_ERROR(-20036, 'LA SUCURSAL A LA QUE SE LE PIDE EL VINO NO ES CORRECTA. ');
  END IF;
END;
/ 

-- 20. LA FECHA DEL PEDIDO DE UNA SUCURSAL S1 A OTRA S2 DE UN DETERMINADO VINO,
-- TIENE QUE SER POSTERIOR A LA FECHA DEL ÚLTIMO PEDIDO QUE S1 HAYA CURSADO
-- A S2 DE ESE MISMO VINO.

CREATE OR REPLACE TRIGGER TR_FECHA_SUCURSALES BEFORE INSERT OR UPDATE ON pedidoSucursal FOR EACH ROW
DECLARE
  xFecha pedidoSucursal.fecha%TYPE;
  xCont NUMBER(8);
BEGIN
  IF (INSERTING) THEN -- SI ESTAMOS INSERTANDO...
    -- COMPROBAMOS QUE HAY PEDIDOS CON ESA FECHA, A ESA SUCURSAL, DE ESE VINO
    SELECT COUNT(*) INTO xCont 
      FROM v_pedidoSucursal 
      WHERE codSucpedido = :NEW.codSucPedido 
        AND codSucPide = :NEW.codSucPide 
        AND vino = :NEW.vino;
        
    IF (xCont <> 0) THEN -- SI LOS HAY...
      SELECT MAX(fecha) INTO xFecha -- OBTENEMOS LA ÚLTIMA FECHA PARA ESE PEDIDO
      FROM v_pedidoSucursal 
      WHERE codSucpedido = :NEW.codSucPedido 
        AND codSucPide = :NEW.codSucPide 
        AND vino = :NEW.vino 
      GROUP BY vino;
      
      IF (xFecha > :NEW.fecha) THEN -- SI ES ANTERIOR A LA FECHA MOSTRAMOS ERROR
       RAISE_APPLICATION_ERROR(-20037,'LA FECHA DEL PEDIDO A ESTA SUCURSAL, 
          PARA ESTE VINO, DEBE SE POSTERIOR AL ' || xFecha);
      END IF;
    END IF;
    
  END IF;
  -- SI ESTAMOS ACTUALIZANDO COMPROBAMOS QUE LA FECHA NUEVA NO SEA ANTERIOR LA 
  -- QUE HABÍA.
  IF (UPDATING('fecha')) THEN
    IF (:OLD.fecha > :NEW.fecha) THEN
      RAISE_APPLICATION_ERROR(-20038,'LA FECHA DEL PEDIDO A ESTA SUCURSAL, PARA 
          ESTE VINO, DEBE SE POSTERIOR AL ' || :OLD.fecha);
    END IF;
  END IF;
END;
/

-- 21. LA FECHA DE PEDIDO DE UN VINO DE UNA SUCURSAL S1 A OTRA S2, TIENE QUE SE 
-- POSTERIOR A LA ÚLTIMA FECHA DE SOLICITUD DE SUMINISTRO DE ESE MISMO VINO 
-- RECIBIDA EN S1 POR UN CLIENTE. POR EJEMPLO, SI UN CLIENTE DE ANDALUCÍA 
-- SOLICITA SUMINISTRO DE VINO DE RIOJA A LA SUCURSAL S1 EN LA FECHA , Y ESA 
-- SOLICITUDES LA ÚLTIMA QUE S1 HA RECIBIDO DE VINO DE RIOJA, EL PEDIDO DE S1 A 
-- LA SUCURSAL DE LA DELEGACIÓN DE MADRID CORRESPONDIENTE TIENE QUE SER DE FECHA 
-- POSTERIOR A F.

CREATE OR REPLACE TRIGGER TR_FECHA_SUCUR_CLI BEFORE INSERT OR UPDATE ON pedidoSucursal FOR EACH ROW
DECLARE
  xFecha pedidoSucursal.fecha%TYPE;
  xCont NUMBER(8);
BEGIN
  IF (INSERTING) THEN -- SI ESTAMOS INSERTANDO...
    SELECT MAX(fecha) INTO xFecha -- SELECCIONAMOS LA ULTIMA FECHA PARA EL PEDIDO
      FROM v_realizaPedido 
      WHERE codSucursal = :NEW.codSucPide 
        AND codVino = :NEW.Vino;
    IF (xFecha > :NEW.fecha) THEN -- SI ES ANTERIOR MOSTRAMOS ERROR
      RAISE_APPLICATION_ERROR(-20039, 'LA FECHA DEL PEDIDO A LA SUCURSAL DEBE 
          SER POSTERIOR AL ' || xFecha);
    END IF;
  END IF;
  -- SI ACTUALIZAMOS LA FECHA COMPROBAMOS QUE SEA POSTERIOR.
  IF (UPDATING('fecha')) THEN
    IF (:OLD.fecha > :NEW.fecha) THEN
      RAISE_APPLICATION_ERROR(-20040,'LA FECHA DEL PEDIDO A ESTA SUCURSAL, PARA 
          ESTE VINO, DEBE SE POSTERIOR AL ' || :OLD.fecha);
    END IF;
  END IF;
END;
/

-- TRIGGER PARA CONTROLAR LAS CLAVES EXTERNAS

-- TRIGGER QUE NO PERMITA BORRAR UN EMPLEADO SI ES DIRECTOR DE UNA SUCURSAL.

CREATE OR REPLACE TRIGGER TR_FK_EMP_SUC BEFORE DELETE ON EMPLEADO FOR EACH ROW
DECLARE
  xCont NUMBER(8);
BEGIN
  -- COMPROBAMOS QUE EL EMPLEADO NO ES DIRECTOR DE UNA SUCURSAL.
  SELECT COUNT(*) INTO xCont 
    FROM v_sucursal 
    WHERE director = :OLD.codEmpleado;
  IF (xCont <> 0) THEN -- SI ES DIRECTOR NO PERMITIMOS BORRAR
    RAISE_APPLICATION_ERROR(-20041,'NO SE PUEDE BORRAR UN EMPLEADO QUE ES 
        DIRECTOR DE UNA SUCURSAL.');
  END IF;
END;
/

-- TRIGGER QUE NO PERMITA BORRAR UN CLIENTE SI ESTÁ EN UN PEDIDO 

CREATE OR REPLACE TRIGGER TR_FK_CLI_PED BEFORE DELETE ON cliente FOR EACH ROW
DECLARE
  xCont NUMBER(8);
BEGIN
  -- COMPROBAMOS SI EL CLIENTE ESTÁ EN LA TABLA DE PEDIDOS.
  SELECT COUNT(*) INTO xCont 
    FROM v_realizaPedido 
    WHERE codCliente = :OLD.codCliente;
  IF (xCont <> 0) THEN -- SI ESTÁ ENTONCES NO SE PUEDE BORRAR.
    RAISE_APPLICATION_ERROR(-20042, 'NO SE PUEDE BORRAR UN CLIENTE DEL QUE 
        EXISTE UN PEDIDO.');
  END IF;
END;
/

-- TRIGGER QUE IMPIDE INSERTAR O MODIFICAR EL CODIGO DEL CLIENTE EN REALIZAPEDIDO
-- A UN CÓDIGO DE CLIENTE QUE NO EXISTA.

CREATE OR REPLACE TRIGGER TR_FK_PED_CLI BEFORE INSERT OR UPDATE ON realizaPedido FOR EACH ROW
DECLARE
  xCont NUMBER(8);
BEGIN
-- COMPROBAMOS QUE EXISTE EL CÓDIGO DEL CLIENTE.
  SELECT COUNT(*) INTO xCont 
    FROM v_cliente 
    WHERE codCliente = :NEW.codCliente;
  IF (xCont = 0) THEN -- SI NO EXISTE, ENTONCES NO PODEMOS MODIFICAR EL CLIENTE.
    RAISE_APPLICATION_ERROR(-20043, 'NO SE PUEDE INTRODUCIR/MODIFICAR UN CLIENTE QUE NO 
      EXISTA EN EL SISTEMA.');
  END IF;
END;
/

-- TRIGGER QUE IMPIDE QUE SE CREE O MODIFIQUE EL CODIGO DE UN VINO A UNO QUE NO 
-- EXISTA

CREATE OR REPLACE TRIGGER TR_FK_PED_VIN BEFORE INSERT OR UPDATE ON realizaPedido FOR EACH ROW
DECLARE
  xCont NUMBER(8);
BEGIN
  -- COMPROBAMOS SI EXISTE UN VINO CON ESE CÓDIGO
  SELECT COUNT(*) INTO xCont 
    FROM v_vino 
    WHERE codVino = :NEW.codVino;
  IF (xCont = 0) THEN -- SI NO EXISTE NO PERMITIMOS MODIFICAR O INTRODUCIR UN VINO QUE NO EXISTA
    RAISE_APPLICATION_ERROR(-20044, 'NO SE PUEDE INTRODUCIR/MODIFICAR UN VINO QUE NO 
      EXISTA EN EL PEDIDO.');
  END IF;
END;
/

-- TRIGGER QUE IMPIDE QUE SE BORRE UN VINO SI EXISTE UN PEDIDO EN EL QUE APAREZCA

CREATE OR REPLACE TRIGGER TR_FK_VIN_PED BEFORE DELETE ON vino FOR EACH ROW
DECLARE
  xCont NUMBER(8);
BEGIN
  -- COMPROBAMOS QUE NO EXISTE EL VINO EN UN PEDIDO
  SELECT COUNT(*) INTO xCont 
    FROM v_realizaPedido 
    WHERE codVino = :OLD.codVino;
  IF (xCont <> 0) THEN -- SI EXISTE, ENTONCES NO SE PUEDE BORRAR.
    RAISE_APPLICATION_ERROR(-20045, 'NO SE PUEDE BORRAR UN VINO DEL QUE EXISTE UN PEDIDO.');
  END IF;
END;
/

-- TRIGGER QUE IMPIDA BORRAR UNA SUCURSAL DE LA CUAL EXISTE UN PEDIDO

CREATE OR REPLACE TRIGGER TR_FK_SUC_PED BEFORE DELETE ON sucursal FOR EACH ROW
DECLARE
  xCont NUMBER(8);
BEGIN
  -- COMPROBAMOS SI LA SUCURSAL EXISTE EN LA TABLA DE PEDIDOS DE CLIENTE
  SELECT COUNT(*) INTO xCont 
    FROM v_realizaPedido 
    WHERE codSucursal = :OLD.codSucursal;
  IF (xCont <> 0) THEN -- SI EXISTE MOSTRAMOS EL ERROR.
    RAISE_APPLICATION_ERROR(-20046, 'NO SE PUEDE BORRAR UNA SUCURSAL DE LA QUE EXISTE UN PEDIDO.');
  END IF;
END;
/

-- TRIGGER QUE IMPIDE QUE SE CREE O MODIFIQUE EL CODIGO DE UNA SUCURSAL A UNO 
-- QUE NO EXISTA

CREATE OR REPLACE TRIGGER TR_FK_PED_SUC BEFORE INSERT OR UPDATE ON realizaPedido FOR EACH ROW
DECLARE
  xCont NUMBER(8);
BEGIN
  -- COMPROBAMOS QUE EL CODIGO DE LA SUCURSAL EXISTE EN EL SISTEMA.
  SELECT COUNT(*) INTO xCont 
    FROM v_sucursal 
    WHERE codSucursal = :NEW.codSucursal;
  IF (xCont = 0) THEN -- SI NO EXISTE BLOQUEAMOS EL CAMBIO
    RAISE_APPLICATION_ERROR(-20047, 'NO SE PUEDE INTRODUCIR/MODIFICAR UNA SUCURSAL QUE NO 
      EXISTA EN EL SISTEMA.');
  END IF;
END;
/

-- TRIGGER QUE IMPIDA BORRAR UNA SUCURSAL QUE HA PEDIDO A OTRA SUCURSAL

CREATE OR REPLACE TRIGGER TR_FK_SUCPIDE_PED BEFORE DELETE ON sucursal FOR EACH ROW
DECLARE
  xCont NUMBER(8);
BEGIN
  -- COMPROBAMOS QUE EL CODIGO DE LA SUCURSAL EN LA TABLA DE PEDIDO DE SUCURSALES
  SELECT COUNT(*) INTO xCont 
    FROM v_pedidoSucursal 
    WHERE codSucPide = :OLD.codSucursal;
  IF (xCont <> 0) THEN -- SI EXISTE BLOQUEAMOS EL BORRADO EN LA TABLA SUCURSAL
    RAISE_APPLICATION_ERROR(-20048, 'NO SE PUEDE BORRAR UNA SUCURSAL DE LA QUE 
        EXISTE UN PEDIDO A OTRA SUCURSAL.');
  END IF;
END;
/

-- TRIGGER QUE IMPIDA MODIDIFICAR LA SUCURSAL QUE PIDE Y QUE NO EXISTA EN EL SISTEMA

CREATE OR REPLACE TRIGGER TR_FK_SUC_SUCPIDE BEFORE INSERT OR UPDATE ON pedidoSucursal FOR EACH ROW
DECLARE
  xCont NUMBER(8);
BEGIN
  -- COMPROBAMOS QUE EXISTE LA SUCURSAL QUE SE VA A MODIFICAR O INSERTAR
  SELECT COUNT(*) INTO xCont 
    FROM v_sucursal 
    WHERE codSucursal = :NEW.codSucPide;
  IF (xCont = 0) THEN -- SI LA SUCURSAL NO EXISTE...
    RAISE_APPLICATION_ERROR(-20049, 'NO SE PUEDE INTRODUCIR/MODIFICAR UNA SUCURSAL QUE NO 
      EXISTA EN EL SISTEMA.');
  END IF;
END;
/

-- TRIGGER QUE IMPIDA BORRAR UNA SUCURSAL A LA QUE SE LE HA PEDIDO

CREATE OR REPLACE TRIGGER TR_FK_SUCPEDIDO_PED BEFORE DELETE ON sucursal FOR EACH ROW
DECLARE
  xCont NUMBER(8);
BEGIN
  -- COMPROBAMOS SI LA SUCURSAL QUE SE VA A BORRAR SE LE HA PEDIDO POR PARTE DE OTRA SUCURSAL
  SELECT COUNT(*) INTO xCont 
    FROM v_pedidoSucursal 
    WHERE codSucPedido = :OLD.codSucursal;
  IF (xCont <> 0) THEN -- SI EXISTE
    RAISE_APPLICATION_ERROR(-20050, 'NO SE PUEDE BORRAR UNA SUCURSAL A LA QUE SE 
        LE HA PEDIDO DESDE OTRA SUCURSAL.');
  END IF;
END;
/

-- TRIGGER QUE IMPIDA MODIDIFICAR LA SUCURSAL QUE PIDE Y QUE NO EXISTA EN EL SISTEMA

CREATE OR REPLACE TRIGGER TR_FK_SUC_SUCPEDIDO BEFORE INSERT OR UPDATE ON pedidoSucursal FOR EACH ROW
DECLARE
  xCont NUMBER(8);
BEGIN
  -- COMPROBAMOS QUE LA NUEVA SUCURSAL ESTÁ EN EL SISTEMA
  SELECT COUNT(*) INTO xCont 
    FROM v_sucursal 
    WHERE codSucursal = :NEW.codSucPedido;
  IF (xCont = 0) THEN -- SI NO EXISTE.
    RAISE_APPLICATION_ERROR(-20051, 'NO SE PUEDE INTRODUCIR/MODIFICAR UNA SUCURSAL QUE NO 
      EXISTA EN EL SISTEMA.');
  END IF;
END;
/

-- TRIGGER ADICIONALES

-- TRIGGER QUE RESTABLECE LA CANTIDAD DEL PEDIDO A UN VINO CUANDO SE BORRA EL SUMINISTRO

CREATE OR REPLACE TRIGGER TR_DEL_SUMINISTRO BEFORE DELETE ON realizaPedido FOR EACH ROW
DECLARE
  xCCAA vino.CCAA%TYPE;
  xDelegacion sucursal.delegacion%TYPE;
BEGIN
  -- RESTABLECEMOS LA CANTIDAD DE PEDIDO A SU VINO
  
  -- SELECCIONAMOS LA DELEGACIÓN A LA QUE PERTENECE EL VINO
  SELECT CCAA INTO xCCAA FROM v_vino WHERE codVino = :OLD.CodVino;
  PR_GET_DELEGACION(xDelegacion, xCCAA);
  
  CASE 
    WHEN (xDelegacion = 'Madrid') THEN
        -- DISMINUIMOS EL STOCK DISPONIBLE DE ESE VINO.
        UPDATE panfleto951.vino SET stock = stock + :OLD.Cantidad WHERE codVino = :OLD.CodVino;
    WHEN (xDelegacion = 'Barcelona') THEN
        -- DISMINUIMOS EL STOCK DISPONIBLE DE ESE VINO.
        UPDATE panfleto952.vino SET stock = stock + :OLD.Cantidad WHERE codVino = :OLD.CodVino;
    WHEN (xDelegacion = 'La Coruña') THEN
        -- DISMINUIMOS EL STOCK DISPONIBLE DE ESE VINO.
        UPDATE panfleto953.vino SET stock = stock + :OLD.Cantidad WHERE codVino = :OLD.CodVino;
    WHEN (xDelegacion = 'Sevilla') THEN
        -- DISMINUIMOS EL STOCK DISPONIBLE DE ESE VINO.
        UPDATE panfleto954.vino SET stock = stock + :OLD.Cantidad WHERE codVino = :OLD.CodVino;
  END CASE;  
END;
/

COMMIT;
/