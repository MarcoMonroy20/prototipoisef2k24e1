DROP DATABASE colchoneria2;
CREATE DATABASE colchoneria2;
USE colchoneria2;

CREATE TABLE sedes
(
  codigo_sede VARCHAR(5),
  nombre_sede VARCHAR(45),
  estatus_sede VARCHAR(1),
  estado TINYINT(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (codigo_sede)
) ENGINE = InnoDB DEFAULT CHARSET=latin1;

select* from sedes;


DELIMITER $$

CREATE   PROCEDURE `cambiarContraModulo` (IN `p_usuario` INT, IN `p_nueva_contrasenia` VARCHAR(100))   BEGIN
    -- Actualizar la contraseña del usuario
    UPDATE tbl_usuarios
    SET password_usuario = p_nueva_contrasenia
    WHERE pk_id_usuario = p_usuario;

    -- Confirmar que el cambio se realizó
    IF ROW_COUNT() > 0 THEN
        SELECT 'Contraseña actualizada con éxito' AS resultado;
    ELSE
        SELECT 'Usuario no encontrado' AS resultado;
    END IF;
END$$

-- Cambio de contraseña procedimiento ----------------------------------------------------------------------
CREATE   PROCEDURE `cambioContrasenia` (IN `p_usuario` VARCHAR(20))   BEGIN
    DECLARE usuario_existe INT;

    SELECT COUNT(*) INTO usuario_existe
    FROM tbl_usuarios
    WHERE username_usuario = p_usuario;

    -- Si el usuario existe, actualiza el tiempo de última conexión
    IF usuario_existe > 0 THEN        
        SELECT 'Usuario encontrado' AS resu;
    ELSE
        SELECT 'Usuario no encontrado' AS resu;
    END IF;
END$$

CREATE   PROCEDURE `cambiarContrasenia` (IN `usuario` VARCHAR(255), IN `nuevaContrasenia` VARCHAR(255), IN `respuestaSeguridad` VARCHAR(255))   BEGIN
    DECLARE respuestaGuardada VARCHAR(255);
    DECLARE usuarioExiste INT;

    -- Verificar si el usuario existe
    SELECT COUNT(*) INTO usuarioExiste 
    FROM tbl_usuarios 
    WHERE username_usuario = usuario;

    IF usuarioExiste = 0 THEN
        -- Si el usuario no existe, devolver mensaje de error
        SELECT 'Usuario no encontrado' AS resultado;
    ELSE
        -- Obtener la respuesta de seguridad desde la base de datos
        SELECT respuesta INTO respuestaGuardada 
        FROM tbl_usuarios 
        WHERE username_usuario = usuario;

        -- Verificar si la respuesta ingresada coincide con la guardada
        IF LOWER(respuestaGuardada) = LOWER(respuestaSeguridad) THEN
            -- Actualizar la contraseña
            UPDATE tbl_usuarios
            SET password_usuario = nuevaContrasenia
            WHERE username_usuario = usuario;
            
            -- Devolver el resultado exitoso
            SELECT 'Contraseña actualizada con éxito' AS resultado;
        ELSE
            -- Devolver resultado si la respuesta de seguridad es incorrecta
            SELECT 'Respuesta de seguridad incorrecta' AS resultado;
        END IF;
    END IF;
END$$

-- Se hizó cambio en el procedimiento para que valide si el usuario esta activo o inactivo / 08-02-2025 / Brandon Boch 
CREATE   PROCEDURE `procedimientoLogin` (IN `p_usuario` VARCHAR(20), IN `p_clave` VARCHAR(100))   BEGIN
    DECLARE usuario_existe INT;

    SELECT COUNT(*) INTO usuario_existe
    FROM tbl_usuarios
    WHERE username_usuario = p_usuario AND password_usuario = p_clave AND estado_usuario = 1;

    -- Si el usuario existe, actualiza el tiempo de última conexión
    IF usuario_existe > 0 THEN
        UPDATE tbl_usuarios
        SET ultima_conexion_usuario = NOW()
        WHERE username_usuario = p_usuario AND password_usuario = p_clave;
        
        SELECT 'Inicio de sesión exitoso' AS resultado;
    ELSE
        SELECT 'Inicio de sesión fallido' AS resultado;
    END IF;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ayuda`
--

CREATE TABLE `ayuda` (
  `Id_ayuda` int(11) NOT NULL,
  `Ruta` varchar(255) DEFAULT NULL,
  `indice` varchar(255) DEFAULT NULL,
  `estado` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------
--
-- Estructura de tabla para la tabla `tbl_aplicaciones`
--

DROP TABLE IF EXISTS `Tbl_aplicaciones`;
CREATE TABLE IF NOT EXISTS `Tbl_aplicaciones` (
	Pk_id_aplicacion INT NOT NULL,
    nombre_aplicacion VARCHAR(50) NOT NULL,
    descripcion_aplicacion VARCHAR(150) NOT NULL,
    estado_aplicacion TINYINT DEFAULT 0,
    primary key (`Pk_id_aplicacion`)
);


-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_asignaciones_perfils_usuario`
--

CREATE TABLE `tbl_asignaciones_perfils_usuario` (
  `PK_id_Perfil_Usuario` int(11) NOT NULL,
  `Fk_id_usuario` int(11) NOT NULL,
  `Fk_id_perfil` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;


-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_asignacion_modulo_aplicacion`
--

CREATE TABLE `tbl_asignacion_modulo_aplicacion` (
  `Fk_id_modulos` int(11) NOT NULL,
  `Fk_id_aplicacion` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- Estructura de tabla para la tabla `tbl_usuarios`
--

DROP TABLE IF EXISTS `Tbl_usuarios`;
CREATE TABLE IF NOT EXISTS `Tbl_usuarios` (
  Pk_id_usuario INT AUTO_INCREMENT NOT NULL,
  nombre_usuario VARCHAR(50) NOT NULL,
  apellido_usuario VARCHAR(50) NOT NULL,
  username_usuario VARCHAR(20) NOT NULL,
  password_usuario VARCHAR(100) NOT NULL,
  email_usuario VARCHAR(50) NOT NULL,
  ultima_conexion_usuario DATETIME NULL DEFAULT NULL,
  estado_usuario TINYINT DEFAULT 0 NOT NULL,
  pregunta varchar(50) not null,
  respuesta varchar(50) not null,
  PRIMARY KEY (`Pk_id_usuario`)
);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_bitacora`
--

DROP TABLE IF EXISTS Tbl_bitacora;
CREATE TABLE IF NOT EXISTS Tbl_bitacora (
  Pk_id_bitacora INT AUTO_INCREMENT NOT NULL,
  Fk_id_usuario INT NOT NULL,
  Fk_id_aplicacion INT NOT NULL,
  fecha_bitacora DATE NOT NULL,
  hora_bitacora TIME NOT NULL,
  host_bitacora VARCHAR(45) NOT NULL,
  ip_bitacora VARCHAR(100) NOT NULL,
  accion_bitacora VARCHAR(200) NOT NULL,
  PRIMARY KEY (`Pk_id_bitacora`),
  FOREIGN KEY (`Fk_id_usuario`) REFERENCES `Tbl_usuarios` (`Pk_id_usuario`),
  FOREIGN KEY (`Fk_id_aplicacion`) REFERENCES `Tbl_aplicaciones` (`Pk_id_aplicacion`)
)ENGINE = InnoDB DEFAULT CHARACTER SET = utf8;


-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_consultainteligente`
--

CREATE TABLE `tbl_consultainteligente` (
  `Pk_consultaID` int(11) NOT NULL,
  `nombre_consulta` varchar(50) NOT NULL,
  `tipo_consulta` int(1) NOT NULL,
  `consulta_SQLE` varchar(100) NOT NULL,
  `consulta_estatus` int(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_modulos`
--

CREATE TABLE `tbl_modulos` (
  `Pk_id_modulos` int(11) NOT NULL,
  `nombre_modulo` varchar(50) NOT NULL,
  `descripcion_modulo` varchar(150) NOT NULL,
  `estado_modulo` tinyint(4) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_perfiles`
--

CREATE TABLE `tbl_perfiles` (
  `Pk_id_perfil` int(11) NOT NULL,
  `nombre_perfil` varchar(50) NOT NULL,
  `descripcion_perfil` varchar(150) NOT NULL,
  `estado_perfil` tinyint(4) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_permisos_aplicaciones_usuario`
--

CREATE TABLE `tbl_permisos_aplicaciones_usuario` (
  `PK_id_Aplicacion_Usuario` int(11) NOT NULL,
  `Fk_id_usuario` int(11) NOT NULL,
  `Fk_id_aplicacion` int(11) NOT NULL,
  `guardar_permiso` tinyint(1) DEFAULT 0,
  `buscar_permiso` tinyint(1) DEFAULT 0,
  `modificar_permiso` tinyint(1) DEFAULT 0,
  `eliminar_permiso` tinyint(1) DEFAULT 0,
  `imprimir_permiso` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;


-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_permisos_aplicacion_perfil`
--

CREATE TABLE `tbl_permisos_aplicacion_perfil` (
  `PK_id_Aplicacion_Perfil` int(11) NOT NULL,
  `Fk_id_perfil` int(11) NOT NULL,
  `Fk_id_aplicacion` int(11) NOT NULL,
  `guardar_permiso` tinyint(1) DEFAULT 0,
  `modificar_permiso` tinyint(1) DEFAULT 0,
  `eliminar_permiso` tinyint(1) DEFAULT 0,
  `buscar_permiso` tinyint(1) DEFAULT 0,
  `imprimir_permiso` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

