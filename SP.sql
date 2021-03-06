USE [CSLDB_HecoTours]
GO
/****** Object:  StoredProcedure [dbo].[abc_CatCamiones]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[abc_CatCamiones]
	@opcion				INT
	,@id_camion			NVARCHAR(100)
	,@descripcion		NVARCHAR(MAX)
	,@id_marca			INT
	,@id_submarca		INT
	,@id_tipocamion		INT
	,@numcamion			NVARCHAR(10)
	,@id_diseniocamion	NVARCHAR(100)
	,@caracteristicas	NVARCHAR(MAX)
	,@usuario			NVARCHAR(100)
AS
BEGIN	
	BEGIN TRY
	DECLARE @fecha	DATETIME
	SET @fecha = dbo.fnGetNewDate()

		IF @opcion = 1		
		BEGIN
			SET @id_camion = NEWID()
			INSERT INTO tbl_CatCamiones (
				id_camion,
				descripcion,
				id_marca,
				id_submarca,
				id_tipocamion,
				numcamion,
				id_disenioCamion,
				caracteristicas,
				usuins,
				fecins,
				usuupd,
				fecupd,
				activo) 
			VALUES (
				@id_camion,
				@descripcion,
				@id_marca,
				@id_submarca,
				@id_tipocamion,
				@numcamion,
				@id_diseniocamion,
				@caracteristicas,
				@usuario,
				@fecha,
				@usuario,
				@fecha,
				1)
		END
		IF @opcion = 2
		BEGIN 
			UPDATE tbl_CatCamiones SET 
				descripcion = @descripcion,
				id_marca = @id_marca,
				id_submarca = @id_submarca,
				id_tipocamion = @id_tipocamion,
				numcamion = @numcamion,
				id_disenioCamion = @id_diseniocamion,
				caracteristicas = @caracteristicas,
				usuupd = @usuario,
				fecupd = @fecha
			WHERE
				id_camion = @id_camion
		END
		IF @opcion = 3
		BEGIN
			UPDATE tbl_CatCamiones SET 
				activo = 0,
				usuupd = @usuario,
				fecupd = @fecha
			WHERE
				id_camion = @id_camion
		END
	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------
	END CATCH
END



























GO
/****** Object:  StoredProcedure [dbo].[abc_CatRutas]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[abc_CatRutas]
	 @opcion			INT	
	,@id_ruta			NVARCHAR(100)
	,@nombre			NVARCHAR(100)	
	,@usuario			NVARCHAR(100)
AS
BEGIN	
	BEGIN TRY
	DECLARE @fecha	DATETIME
	SET @fecha = dbo.fnGetNewDate()

		IF @opcion = 1		
		BEGIN
			SET @id_ruta = NEWID()
			INSERT INTO tbl_CatRutas(				
				id_ruta,
				nombre,				
				usuins,
				fecins,
				usuupd,
				fecupd,
				activo) 
			VALUES (				
				@id_ruta,
				@nombre,				
				@usuario,
				@fecha,
				@usuario,
				@fecha,
				1)
				SELECT @id_ruta
		END
		IF @opcion = 2
		BEGIN 
		/*
			UPDATE tbl_CatRutas SET 
				nombre = @nombre,
				usuupd = @usuario,
				fecupd = @fecha
			WHERE
				id_ruta = @id_ruta
	    */
		SELECT 1
		END
		IF @opcion = 3
		BEGIN
			IF(NOT EXISTS(SELECT id_ruta FROM tbl_CatViajes as cv  WHERE cv.activo = 1 AND cv.id_ruta	= @id_ruta))
			BEGIN		
				UPDATE tbl_CatRutas SET 
					activo = 0,
					usuupd = @usuario,
					fecupd = @fecha
				WHERE
					id_ruta	= @id_ruta	
				SELECT 1
			END
			ELSE
			BEGIN
				SELECT 2
			END
		END
	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------
	END CATCH
END







GO
/****** Object:  StoredProcedure [dbo].[abc_CatTerminales]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER PROCEDURE [dbo].[abc_CatTerminales]
	@opcion				INT
	,@id_terminal		NVARCHAR(100)
	,@nombre			NVARCHAR(70)
	,@direccion			NVARCHAR(150)
	,@telefonos			NVARCHAR(50)
	,@id_pais			INT
	,@id_estado			INT
	,@id_municipio		INT
	,@siglas			NVARCHAR(6)	
	,@usuario			NVARCHAR(100)
AS
BEGIN	
	BEGIN TRY
	DECLARE @fecha	DATETIME
	SET @fecha = dbo.fnGetNewDate()

		IF @opcion = 1		
		BEGIN
			SET @id_terminal = NEWID()
			INSERT INTO tbl_CatTerminales(
				id_terminal,
				nombre,
				direccion,
				telefonos,
				id_pais,
				id_estado,
				id_municipio,
				siglas,
				usuins,
				fecins,
				usuupd,
				fecupd,
				activo) 
			VALUES (
				@id_terminal,
				@nombre,
				@direccion,
				@telefonos,
				@id_pais,
				@id_estado,
				@id_municipio,
				@siglas,
				@usuario,
				@fecha,
				@usuario,
				@fecha,
				1)

			DECLARE @id_sucursal	NVARCHAR(100)
			DECLARE @int_cant_suc	INT
			SET @int_cant_suc = (SELECT count(id_sucursal) FROM tbl_CatSucursales) + 1
			SET @id_sucursal = CONCAT('SUC', (SELECT isnull(RIGHT(CONCAT('00', @int_cant_suc), 2), '00')))

			INSERT INTO tbl_CatSucursales(
				id_sucursal,
				id_empresa,
				id_tipoSucursal,
				Nombre_Sucursal,
				direccion,
				telefono,
				id_municipio,
				id_estado,
				id_pais,
				porcentaje_iva,
				margen_utilidad,
				codigopostal,
				monto_cancelacion,
				id_terminal,
				rg_puntosPlata,
				rg_puntosOro,
				tiempo_espera,
				tiempo_cobro,
				enUso,
				ip_Servidor,
				vertodo,
				porcentaje_puntos,
				numDiasPago,
				porcentaje_apartado,
				numPagosApartado,
				usuins,
				fecins,
				usuupd,
				fecupd,
				activo)
			VALUES(
				@id_sucursal,
				1,
				1,
				@nombre,
				@direccion,
				@telefonos,
				@id_municipio,
				@id_estado,
				@id_pais,
				0,
				0,
				0,
				(SELECT ISNULL(MAX(monto_cancelacion),0.0) FROM tbl_CatSucursales),
				@id_terminal,
			    0,
				0,
				0,
				0,
				1,
				'',
		        0,
				(SELECT ISNULL(MAX(porcentaje_puntos),0.0) FROM tbl_CatSucursales),
				0,
				0,
				0,
				@usuario,
				@fecha,
				@usuario,
				@fecha, 
				1)

		INSERT INTO tbl_configuracion
           (id_configuracion
           ,razonsocial
           ,activo
           ,rfc
           ,mensaje1
           ,mensaje2
           ,mensaje3
		   ,direccion
           ,nameprinter
           ,url_logo
           ,id_sucursal)
     VALUES
           (NEWID()
           ,(SELECT TOP 1 ISNULL(razonsocial,'') FROM tbl_configuracion WHERE id_sucursal = 'SUC01')
           ,1
           ,(SELECT TOP 1 ISNULL(rfc,'') FROM tbl_configuracion WHERE id_sucursal = 'SUC01')
           ,(SELECT TOP 1 ISNULL(mensaje1,'') FROM tbl_configuracion WHERE id_sucursal = 'SUC01')
           ,(SELECT TOP 1 ISNULL(mensaje2,'') FROM tbl_configuracion WHERE id_sucursal = 'SUC01')
           ,(SELECT TOP 1 ISNULL(mensaje3,'') FROM tbl_configuracion WHERE id_sucursal = 'SUC01')
		   ,(SELECT TOP 1 ISNULL(direccion,'') FROM tbl_configuracion WHERE id_sucursal = 'SUC01')
           ,(SELECT TOP 1 ISNULL(nameprinter,'') FROM tbl_configuracion WHERE id_sucursal = 'SUC01')
           ,(SELECT TOP 1 ISNULL(url_logo,'') FROM tbl_configuracion WHERE id_sucursal = 'SUC01')
           ,@id_sucursal)
		END
		IF @opcion = 2
		BEGIN 
			UPDATE tbl_CatTerminales SET 
				nombre = @nombre,
				direccion = @direccion,
				telefonos = @telefonos,
				id_pais = @id_pais,
				id_estado = @id_estado,
				id_municipio = @id_municipio, 
				siglas =	@siglas,				
				usuupd = @usuario,
				fecupd = @fecha
			WHERE
				id_terminal = @id_terminal

			UPDATE tbl_CatSucursales SET
				Nombre_Sucursal = @nombre,
				direccion = @direccion,
				telefono = @telefonos,
				id_pais = @id_pais,
				id_estado = @id_estado,
				id_municipio = @id_municipio,
				usuupd = @usuario,
				fecupd = @fecha
			WHERE
				id_terminal = @id_terminal
		END
		IF @opcion = 3
		BEGIN
			UPDATE tbl_CatTerminales SET 
				activo = 0,
				usuupd = @usuario,
				fecupd = @fecha
			WHERE
				id_terminal = @id_terminal

			UPDATE tbl_CatSucursales SET
				activo = 0,
				usuupd = @usuario,
				fecupd = @fecha
			WHERE
				id_terminal = @id_terminal
		END
	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------
	END CATCH
END







GO
/****** Object:  StoredProcedure [dbo].[abc_CatTerminalesXRuta]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[abc_CatTerminalesXRuta]
	@opcion					INT
	,@id_terminalxRuta		NVARCHAR(100)
	,@id_ruta				NVARCHAR(100)
	,@id_terminalSalida		NVARCHAR(100)
	,@id_temrinalDestino	NVARCHAR(100)
	,@tiempoMinutos			INT
	,@id_tipoTerminal		INT
	,@indice				INT
	,@usuario				NVARCHAR(100)
AS
BEGIN	
	BEGIN TRY
	DECLARE @fecha	DATETIME
	SET @fecha = dbo.fnGetNewDate()

		IF @opcion = 1		
		BEGIN
			SET @id_terminalxRuta = NEWID()
			INSERT INTO tbl_CatTerminalesXRuta(
				id_terminalXruta,
				id_ruta,
				id_terminalSalida,
				id_terminalDestino,
				tiempoMinutos,
				id_tipoTerminal,
				indice,
				usuins,
				fecins,
				usuupd,
				fecupd,
				activo) 
			VALUES (
				@id_terminalxRuta,
				@id_ruta,
				@id_terminalSalida,
				@id_temrinalDestino,
				@tiempoMinutos,
				@id_tipoTerminal,
				@indice,
				@usuario,
				@fecha,
				@usuario,
				@fecha,
				1)
				SELECT @id_terminalxRuta
		END
		IF @opcion = 2
		BEGIN 
			UPDATE tbl_CatTerminalesXRuta SET 
				id_ruta = @id_ruta,
				id_terminalSalida = @id_terminalSalida,
				id_terminalDestino = @id_temrinalDestino,
				tiempoMinutos = @tiempoMinutos,
				id_tipoTerminal = @id_tipoTerminal,
				indice = @indice,
				usuupd = @usuario,
				fecupd = @fecha
			WHERE
				id_terminalXruta = @id_terminalxRuta
		END
		IF @opcion = 3
		BEGIN
			UPDATE tbl_CatTerminalesXRuta SET 
				activo = 0,
				usuupd = @usuario,
				fecupd = @fecha
			WHERE
				id_terminalXruta = @id_terminalxRuta
		END
	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------
	END CATCH
END































GO
/****** Object:  StoredProcedure [dbo].[abc_CatViajes]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[abc_CatViajes]
	@opcion				INT
	,@id_identificador	NVARCHAR(100)
	,@id_ruta			NVARCHAR(100)
	,@id_camion			NVARCHAR(100)
	,@id_tipoViaje		INT
	,@fec_PeriodoIni	DATE
	,@fec_PeriodoFin	DATE
	,@lunes				BIT
	,@martes			BIT
	,@miercoles			BIT
	,@jueves			BIT
	,@viernes			BIT
	,@sabado			BIT
	,@domingo			BIT
	,@nombre			NVARCHAR(150)
	,@horario			NVARCHAR(8)
	,@usuario			NVARCHAR(100)
AS
BEGIN	
	BEGIN TRY
	DECLARE @fecha	DATETIME
	SET @fecha = dbo.fnGetNewDate()

		IF @opcion = 1		
		BEGIN
			SET @id_identificador = NEWID()
			INSERT INTO tbl_CatViajes(
				id_identificador,
				id_ruta,
				id_camion,
				id_tipoViaje,
				fec_PeriodoIni,
				fec_PeriodoFin,
				Lunes,
				Martes,
				Miercoles,
				Jueves,
				Viernes,
				Sabado,
				Domingo,
				nombre,
				horario,
				usuins,
				fecins,
				usuupd,
				fecupd,
				activo) 
			VALUES (
				@id_identificador,
				@id_ruta,
				@id_camion,
				@id_tipoViaje,
				@fec_PeriodoIni,
				@fec_PeriodoFin,
				@lunes,
				@martes,
				@miercoles,
				@jueves,
				@viernes,
				@sabado,
				@domingo,
				@nombre,
				@horario,
				@usuario,
				@fecha,
				@usuario,
				@fecha,
				1)

				IF @id_tipoViaje <> 3
				BEGIN

				EXECUTE CatFechasViaje_Insertar 
					@id_identificador, 
					@fec_PeriodoIni, 
					@fec_PeriodoFin,
					@lunes,
					@martes,
					@miercoles,
					@jueves,
					@viernes,
					@sabado,
					@domingo,
					@usuario,
					1
				END

				SELECT @id_identificador
		END
		IF @opcion = 2
		BEGIN 
			UPDATE tbl_CatViajes SET 
				id_ruta = @id_ruta,
				id_camion = @id_camion,
				id_tipoViaje = @id_tipoViaje,
				fec_PeriodoIni = @fec_PeriodoIni,
				fec_PeriodoFin = @fec_PeriodoFin,
				Lunes = @lunes,
				Martes = @martes,
				Miercoles = @miercoles,
				Jueves = @jueves,
				Viernes = @viernes,
				Sabado = @sabado,
				Domingo = @domingo,
				nombre = @nombre,
				horario = @horario,
				usuupd = @usuario,
				fecupd = @fecha
			WHERE
				id_identificador = @id_identificador
			UPDATE [dbo].[tbl_Boletos] SET [hora_salida] = @horario WHERE [id_viaje] = @id_identificador
		END
		IF @opcion = 3
		BEGIN
			UPDATE tbl_CatViajes SET 
				activo = 0,
				usuupd = @usuario,
				fecupd = @fecha
			WHERE
				id_identificador = @id_identificador

			UPDATE tbl_CatViajesXFecha SET 
			    activo = 0
			WHERE id_viaje = @id_identificador AND  tbl_CatViajesXFecha.fechaviaje >= CONVERT(DATE, @fecha)
		END
		IF @opcion = 4
		BEGIN 
			DECLARE @fec_PeriodoIni_Anterior_INS DATE = CONVERT(DATE,@fecha)
			DECLARE @fec_PeriodoFin_Anterior_INS DATE = CONVERT(DATE,@fecha)
			DECLARE @Lunes_Anterior_INS BIT = 0
			DECLARE @martes_Anterior_INS BIT = 0
			DECLARE @miercoles_Anterior_INS BIT = 0
			DECLARE @jueves_Anterior_INS BIT = 0
			DECLARE @viernes_Anterior_INS BIT = 0
			DECLARE @sabado_Anterior_INS BIT = 0
			DECLARE @domingo_Anterior_INS BIT = 0

			SELECT 
					@fec_PeriodoIni_Anterior_INS = fec_PeriodoIni,
					@fec_PeriodoFin_Anterior_INS = fec_PeriodoFin,
					@Lunes_Anterior_INS = Lunes,
					@martes_Anterior_INS = Martes,
					@miercoles_Anterior_INS = Miercoles,
					@jueves_Anterior_INS = Jueves,
					@viernes_Anterior_INS = Viernes,
					@sabado_Anterior_INS = Sabado,
					@domingo_Anterior_INS = Domingo
			FROM tbl_CatViajes 
			WHERE id_identificador = @id_identificador

			IF(CONVERT(DATE,@fec_PeriodoIni) < CONVERT(DATE,@fec_PeriodoIni_Anterior_INS)) -- Nuevo ini < Registrado ini
			BEGIN
				 SET @fec_PeriodoIni_Anterior_INS= @fec_PeriodoIni                        -- Registrado ini = Nuevo ini
			END
			IF(CONVERT(DATE,@fec_PeriodoFin) > CONVERT(DATE,@fec_PeriodoFin_Anterior_INS)) -- Nuevo fin > Registrado fin
			BEGIN
				 SET @fec_PeriodoFin_Anterior_INS= @fec_PeriodoFin                        -- Registrado fin = Nuevo fin
			END

			IF(@Lunes_Anterior_INS != 1)
			BEGIN
				 SET @Lunes_Anterior_INS = @lunes
			END
			
			IF(@martes_Anterior_INS != 1)
			BEGIN
				 SET @martes_Anterior_INS = @martes
			END
			
			IF(@miercoles_Anterior_INS != 1)
			BEGIN
				 SET @miercoles_Anterior_INS = @miercoles
			END
			
			IF(@jueves_Anterior_INS != 1)
			BEGIN
				 SET @jueves_Anterior_INS = @jueves
			END
			
			IF(@viernes_Anterior_INS != 1)
			BEGIN
				 SET @viernes_Anterior_INS = @viernes
			END

			IF(@sabado_Anterior_INS != 1)
			BEGIN
				 SET @sabado_Anterior_INS = @sabado
			END

			IF(@domingo_Anterior_INS != 1)
			BEGIN
				 SET @domingo_Anterior_INS = @domingo
			END

				EXECUTE CatFechasViaje_Insertar 
					@id_identificador, 
					@fec_PeriodoIni, 
					@fec_PeriodoFin,
					@lunes,
					@martes,
					@miercoles,
					@jueves,
					@viernes,
					@sabado,
					@domingo,
					@usuario,
					1

			UPDATE tbl_CatViajes SET 
				fec_PeriodoIni = @fec_PeriodoIni_Anterior_INS,
				fec_PeriodoFin = @fec_PeriodoFin_Anterior_INS,
				Lunes = @lunes_Anterior_INS,
				Martes = @martes_Anterior_INS,
				Miercoles = @miercoles_Anterior_INS,
				Jueves = @jueves_Anterior_INS,
				Viernes = @viernes_Anterior_INS,
				Sabado = @sabado_Anterior_INS,
				Domingo = @domingo_Anterior_INS,
				usuupd = @usuario,
				fecupd = @fecha
			WHERE
				id_identificador = @id_identificador

		END
		ELSE IF @opcion = 5
		BEGIN
		    IF(NOT EXISTS(SELECT id_boleto FROM tbl_Boletos WHERE id_viaje = @id_identificador AND CONVERT(DATE,fecha_salida) BETWEEN @fec_PeriodoIni	AND @fec_PeriodoFin))
			BEGIN
			DECLARE @fec_PeriodoIni_Anterior_UPD DATE = CONVERT(DATE,@fecha)
			DECLARE @fec_PeriodoFin_Anterior_UPD DATE = CONVERT(DATE,@fecha)
			DECLARE @Lunes_Anterior_UPD BIT = 0
			DECLARE @martes_Anterior_UPD BIT = 0
			DECLARE @miercoles_Anterior_UPD BIT = 0
			DECLARE @jueves_Anterior_UPD BIT = 0
			DECLARE @viernes_Anterior_UPD BIT = 0
			DECLARE @sabado_Anterior_UPD BIT = 0
			DECLARE @domingo_Anterior_UPD BIT = 0

			SELECT 
					@fec_PeriodoIni_Anterior_UPD = fec_PeriodoIni,
					@fec_PeriodoFin_Anterior_UPD = fec_PeriodoFin,
					@Lunes_Anterior_UPD = Lunes,
					@martes_Anterior_UPD = Martes,
					@miercoles_Anterior_UPD = Miercoles,
					@jueves_Anterior_UPD = Jueves,
					@viernes_Anterior_UPD = Viernes,
					@sabado_Anterior_UPD = Sabado,
					@domingo_Anterior_UPD = Domingo
			FROM tbl_CatViajes 
			WHERE id_identificador = @id_identificador

			IF(CONVERT(DATE,@fec_PeriodoIni) < CONVERT(DATE,@fec_PeriodoIni_Anterior_UPD)) -- Nuevo ini < Registrado ini
			BEGIN
				 SET @fec_PeriodoIni_Anterior_UPD = @fec_PeriodoFin                        -- Registrado ini = NNuevo fin
			END
			IF(CONVERT(DATE,@fec_PeriodoFin) > CONVERT(DATE,@fec_PeriodoFin_Anterior_UPD)) -- Nuevo fin > Registrado fin
			BEGIN
				 SET @fec_PeriodoFin_Anterior_UPD = @fec_PeriodoFin                        -- Registrado fin = Nuevo fin
			END

			IF(@Lunes_Anterior_INS != 1)
			BEGIN
				 SET @Lunes_Anterior_INS = @lunes
			END
			
			IF(@martes_Anterior_INS != 1)
			BEGIN
				 SET @martes_Anterior_INS = @martes
			END
			
			IF(@miercoles_Anterior_INS != 1)
			BEGIN
				 SET @miercoles_Anterior_INS = @miercoles
			END
			
			IF(@jueves_Anterior_INS != 1)
			BEGIN
				 SET @jueves_Anterior_INS = @jueves
			END
			
			IF(@viernes_Anterior_INS != 1)
			BEGIN
				 SET @viernes_Anterior_INS = @viernes
			END

			IF(@sabado_Anterior_INS != 1)
			BEGIN
				 SET @sabado_Anterior_INS = @sabado
			END

			IF(@domingo_Anterior_INS != 1)
			BEGIN
				 SET @domingo_Anterior_INS = @domingo
			END

				EXECUTE CatFechasViaje_Insertar 
					@id_identificador, 
					@fec_PeriodoIni, 
					@fec_PeriodoFin,
					@lunes,
					@martes,
					@miercoles,
					@jueves,
					@viernes,
					@sabado,
					@domingo,
					@usuario,
					2

			UPDATE tbl_CatViajes SET 
				fec_PeriodoIni = @fec_PeriodoIni_Anterior_UPD,
				fec_PeriodoFin = @fec_PeriodoFin_Anterior_UPD,
				Lunes = @lunes_Anterior_UPD,
				Martes = @martes_Anterior_UPD,
				Miercoles = @miercoles_Anterior_UPD,
				Jueves = @jueves_Anterior_UPD,
				Viernes = @viernes_Anterior_UPD,
				Sabado = @sabado_Anterior_UPD,
				Domingo = @domingo_Anterior_UPD,
				usuupd = @usuario,
				fecupd = @fecha
			WHERE
				id_identificador = @id_identificador
			
				SELECT 0
			END
			ELSE
			BEGIN
				SELECT 1
			END
		END 
	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------
	END CATCH
END






















GO
/****** Object:  StoredProcedure [dbo].[abc_CatViajesModificacionRuta]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





ALTER PROCEDURE [dbo].[abc_CatViajesModificacionRuta]
	 @id_viaje_viejo			      NVARCHAR(100)
	,@id_ruta_nuevo				      NVARCHAR(100)
	,@id_camion_nuevo			      NVARCHAR(100)
	,@id_tipoViaje_nuevo		      INT
	,@fec_PeriodoIni_nuevo		      DATE
	,@fec_PeriodoFin_nuevo		      DATE
	,@lunes_nuevo			 	      BIT
	,@martes_nuevo				      BIT
	,@miercoles_nuevo			      BIT
	,@jueves_nuevo				      BIT
	,@viernes_nuevo				      BIT
	,@sabado_nuevo				      BIT
	,@domingo_nuevo				      BIT
	,@nombre_nuevo					  NVARCHAR(150)
	,@horario_nuevo				      NVARCHAR(8)
	,@usuario_nuevo					  NVARCHAR(100)
	,@BoletosCambioRutaViajeNuevo	  BoletosCambioRutaViaje READONLY
	,@TarifasViajeNuevo				  TarifasViaje  READONLY    
AS
BEGIN	
	BEGIN TRY
	DECLARE @id_identificador NVARCHAR(100)
	SET @id_identificador = NEWID()

	DECLARE @fecha	DATETIME
	SET @fecha = dbo.fnGetNewDate()

			UPDATE tbl_CatViajes SET 
				activo = 0,
				usuupd = @usuario_nuevo,
				fecupd = @fecha
			WHERE
				id_identificador = @id_viaje_viejo

			
			INSERT INTO tbl_CatViajes(
				id_identificador,
				id_ruta,
				id_camion,
				id_tipoViaje,
				fec_PeriodoIni,
				fec_PeriodoFin,
				Lunes,
				Martes,
				Miercoles,
				Jueves,
				Viernes,
				Sabado,
				Domingo,
				nombre,
				horario,
				usuins,
				fecins,
				usuupd,
				fecupd,
				activo) 
			VALUES (
				@id_identificador,
				@id_ruta_nuevo,
				@id_camion_nuevo,
				@id_tipoViaje_nuevo,
				@fec_PeriodoIni_nuevo,
				@fec_PeriodoFin_nuevo,
				@lunes_nuevo,
				@martes_nuevo,
				@miercoles_nuevo,
				@jueves_nuevo,
				@viernes_nuevo,
				@sabado_nuevo,
				@domingo_nuevo,
				@nombre_nuevo,
				@horario_nuevo,
				@usuario_nuevo,
				@fecha,
				@usuario_nuevo,
				@fecha,
				1)

				UPDATE tbl_CatViajesXFecha SET 
					id_viaje = @id_identificador
				WHERE id_viaje = @id_viaje_viejo AND  tbl_CatViajesXFecha.fechaviaje >= CONVERT(DATE, @fecha)

				UPDATE tbl_Boletos 
				SET 
					tbl_Boletos.id_viaje = @id_identificador,
					tbl_Boletos.fecha_salida = BoletosCambioRutaViajeNuevo.FechaSalidaNuevo,
					tbl_Boletos.hora_salida = BoletosCambioRutaViajeNuevo.HoraSalidaNuevo,
					tbl_Boletos.asiento = BoletosCambioRutaViajeNuevo.AsientoNuevo,
					tbl_Boletos.id_disenioDatos = BoletosCambioRutaViajeNuevo.IDDisenioDatosNuevo,
					tbl_Boletos.id_status = BoletosCambioRutaViajeNuevo.IDStatusNuevo,
					tbl_Boletos.OrdenOrigenTerminal = BoletosCambioRutaViajeNuevo.OrdenOrigenTerminalNuevo,
					tbl_Boletos.OrdenDestinoTerminal = BoletosCambioRutaViajeNuevo.OrdenDestinoTerminalNuevo,
					tbl_Boletos.id_tarifa = TarifasViajeNuevo.IDTarifaNuevo
				FROM tbl_Boletos JOIN @BoletosCambioRutaViajeNuevo AS BoletosCambioRutaViajeNuevo
				ON tbl_Boletos.id_boleto = BoletosCambioRutaViajeNuevo.IDBoleto 
				AND tbl_Boletos.id_viaje = BoletosCambioRutaViajeNuevo.IDViajeViejo
				AND tbl_Boletos.fecha_salida = BoletosCambioRutaViajeNuevo.FechaSalidaViejo
				AND tbl_Boletos.hora_salida = BoletosCambioRutaViajeNuevo.HoraSalidaViejo
				AND tbl_Boletos.asiento = BoletosCambioRutaViajeNuevo.AsientoViejo
				AND tbl_Boletos.id_disenioDatos = BoletosCambioRutaViajeNuevo.IDDisenioDatosViejo
				AND tbl_Boletos.id_status = BoletosCambioRutaViajeNuevo.IDStatusViejo
				AND tbl_Boletos.OrdenOrigenTerminal = BoletosCambioRutaViajeNuevo.OrdenOrigenTerminalViejo
				AND tbl_Boletos.OrdenDestinoTerminal = BoletosCambioRutaViajeNuevo.OrdenDestinoTerminalViejo
				AND tbl_Boletos.id_tarifa = BoletosCambioRutaViajeNuevo.IDTarifaViejo
				JOIN @TarifasViajeNuevo AS TarifasViajeNuevo	
				ON BoletosCambioRutaViajeNuevo.IDTarifaViejo = TarifasViajeNuevo.IDTarifaViejo

				

			INSERT INTO tbl_CatViajeXTarifas
				  (id_tarifa,
				   id_viaje,
				   id_terminalXruta,
				   precioNormal1,
				   precioInfantil1,
				   precioTerceraEdad1,
				   precioEspecial1,
				   precioNormal2,
				   precioInfantil2,
				   precioTerceraEdad2,
				   precioEspecial2)
			SELECT 
					TarifasViajeNuevo.IDTarifaNuevo,
					@id_identificador,
					TarifasViajeNuevo.IDTerminalXRutaNuevo,
				    TarifasViajeNuevo.PrecioNormal1,
					TarifasViajeNuevo.PrecioInfantil1,
					TarifasViajeNuevo.PrecioTerceraEdad1,
					TarifasViajeNuevo.PrecioEspecial1,
					TarifasViajeNuevo.PrecioNormal2,
					TarifasViajeNuevo.PrecioInfantil2,
					TarifasViajeNuevo.PrecioTerceraEdad2,
					TarifasViajeNuevo.PrecioEspecial2
			FROM @TarifasViajeNuevo AS TarifasViajeNuevo	

	SELECT 1
	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------
	END CATCH
END

























GO
/****** Object:  StoredProcedure [dbo].[abc_CatViajesXFecha]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




ALTER PROCEDURE [dbo].[abc_CatViajesXFecha]
	@opcion				INT
	,@id_viaje			NVARCHAR(100)
	,@fecNew			DATE
	,@usuario			NVARCHAR(100)
AS
BEGIN	
	BEGIN TRY
	DECLARE @fecha	DATETIME
	SET @fecha = dbo.fnGetNewDate()

		IF @opcion = 1		
		BEGIN
			IF(NOT EXISTS(SELECT id_fechaviaje FROM tbl_CatViajesXFecha WHERE id_viaje =  @id_viaje AND CONVERT(DATE, fechaviaje) = CONVERT(DATE, @fecNew)))
			BEGIN
				INSERT INTO tbl_CatViajesXFecha
				(id_fechaviaje,
				id_viaje,
				fechaviaje,
				activo,
				usuins,
				usuupd,
				fecins,
				fecupd)
			VALUES 
			    (NEWID(),
				@id_viaje,
				@fecNew,
				1,
				@usuario,
				@usuario,
				@fecha,
				@fecha)		
			END
			ELSE
			BEGIN
				UPDATE tbl_CatViajesXFecha
				SET
					activo = 1
				WHERE id_viaje =  @id_viaje AND CONVERT(DATE, fechaviaje) = CONVERT(DATE, @fecNew) 
			END
		END
		ELSE IF @opcion = 2
		BEGIN
			IF(EXISTS(SELECT id_fechaviaje FROM tbl_CatViajesXFecha WHERE id_viaje =  @id_viaje AND CONVERT(DATE, fechaviaje) = CONVERT(DATE, @fecNew) AND activo = 1))
			BEGIN
				UPDATE tbl_CatViajesXFecha
				SET
					activo = 0
				WHERE id_viaje =  @id_viaje AND CONVERT(DATE, fechaviaje) = CONVERT(DATE, @fecNew) AND activo = 1
			END
		END
	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------
	END CATCH
END




























GO
/****** Object:  StoredProcedure [dbo].[abc_CatViajeXHorarios]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[abc_CatViajeXHorarios]
	@opcion				INT
	,@id_horario		NVARCHAR(100)
	,@id_viaje			NVARCHAR(100)
	,@horario			NVARCHAR(8)	
	,@usuario			NVARCHAR(100)
AS
BEGIN	
	BEGIN TRY
	DECLARE @fecha	DATETIME
	SET @fecha = dbo.fnGetNewDate()

		IF @opcion = 1		
		BEGIN
			SET @id_horario = NEWID()
			INSERT INTO tbl_CatViajeXHorarios(
				id_horario,
				id_viaje,
				horario,
				usuins,
				fecins,
				usuupd,
				fecupd,
				activo
				) 
			VALUES (
				@id_horario,
				@id_viaje,
				@horario,
				@usuario,
				@fecha,
				@usuario,
				@fecha,
				1
				)
		END
		IF @opcion = 2
		BEGIN 
			UPDATE tbl_CatViajeXHorarios SET 
				activo = 0
			WHERE
				id_horario = @id_horario
		END
		
	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------
	END CATCH
END



























GO
/****** Object:  StoredProcedure [dbo].[abc_CatViajeXTarifas]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[abc_CatViajeXTarifas]
	@opcion				    INT
	,@id_tarifa			    NVARCHAR(100)
	,@id_viaje			    NVARCHAR(100)
	,@id_temrinalXruta	    NVARCHAR(100)
	,@precioNormal1		    MONEY
	,@precioInfantil1	    MONEY
	,@precioTerceraEdad1	MONEY
	,@precioEspecial1	    MONEY
    ,@precioNormal2		    MONEY
	,@precioInfantil2	    MONEY
	,@precioTerceraEdad2	MONEY
	,@precioEspecial2	    MONEY
	,@usuario			    NVARCHAR(100)
AS
BEGIN	
	BEGIN TRY
	DECLARE @fecha	DATETIME
	SET @fecha = dbo.fnGetNewDate()

		IF @opcion = 1		
		BEGIN
			SET @id_tarifa = NEWID()
			INSERT INTO tbl_CatViajeXTarifas(
				id_tarifa,
				id_viaje,
				id_terminalXruta,
				precioNormal1,
				precioInfantil1,
				precioTerceraEdad1,
				precioEspecial1,
				precioNormal2,
				precioInfantil2,
				precioTerceraEdad2,
				precioEspecial2
				) 
			VALUES (
				@id_tarifa,
				@id_viaje,
				@id_temrinalXruta,
				@precioNormal1,
				@precioInfantil1,
				@precioTerceraEdad1,
				@precioEspecial1,
				@precioNormal2,
				@precioInfantil2,
				@precioTerceraEdad2,
				@precioEspecial2
				)
		END
		IF @opcion = 2
		BEGIN 
			UPDATE tbl_CatViajeXTarifas SET 
				precioNormal1 = @precioNormal1,
				precioInfantil1 = @precioInfantil1,
				precioTerceraEdad1 = @precioTerceraEdad1,
				precioEspecial1 = @precioEspecial1,
				precioNormal2 = @precioNormal2,
				precioInfantil2 = @precioInfantil2,
				precioTerceraEdad2 = @precioTerceraEdad2,
				precioEspecial2 = @precioEspecial2
			WHERE
				id_tarifa = @id_tarifa
		END
		
	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------
	END CATCH
END



























GO
/****** Object:  StoredProcedure [dbo].[abc_Configuracion]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




ALTER PROCEDURE [dbo].[abc_Configuracion]
	@opcion				INT,
	@id_configuracion	NVARCHAR(100),
	@razonsocial		NVARCHAR(200),
	@rfc				NVARCHAR(50),
	@direccion          NVARCHAR(500),
	@logourl			NVARCHAR(MAX),
	@mensaje1			NVARCHAR(MAX),
	@mensaje2			NVARCHAR(MAX),
	@mensaje3			NVARCHAR(MAX),
	@id_sucursal		NVARCHAR(100),
	@macAddress			NVARCHAR(20),
	@nameprinter		NVARCHAR(250),
	@id_caja			NVARCHAR(100),
	@descripcionCaja	NVARCHAR(1000)
AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON
		IF @opcion = 1
		BEGIN
			SET @id_configuracion = NEWID()
			INSERT INTO tbl_configuracion (
				id_configuracion,
				razonsocial,
				activo,
				rfc,
				direccion,
				mensaje1,
				mensaje2,
				mensaje3,
				nameprinter,
				url_logo,
				id_sucursal
				) 
			VALUES (
				@id_configuracion,
				@razonsocial,
				1,
				@rfc,
				@direccion,
				@mensaje1,
				@mensaje2,
				@mensaje3,
				@nameprinter,
				@logourl,
				@id_sucursal)

		UPDATE tbl_CatCajas 
		SET 
		    macAddress = @macAddress, 
			descripcion2 = @descripcionCaja,
			nameprinter = @NamePrinter,
			usuupd = '0',
			fecupd = dbo.fnGetNewDate()
		WHERE macAddress = @macAddress 

		END
		IF @opcion = 2
		BEGIN
			UPDATE tbl_configuracion SET
				razonsocial = @razonsocial,				
				rfc = @rfc,
				direccion = @direccion,
				mensaje1 = @mensaje1,
				mensaje2 = @mensaje2,
				mensaje3 = @mensaje3

			UPDATE tbl_configuracion SET
				nameprinter = '',
				url_logo = @logourl
			WHERE 
				id_configuracion = @id_configuracion

			UPDATE tbl_CatCajas 
			SET 
				macAddress = @macAddress, 
				descripcion2 = @descripcionCaja,
				nameprinter = @NamePrinter,
				usuupd = '0',
				fecupd = dbo.fnGetNewDate()
			WHERE macAddress = @macAddress 
		END
		SELECT @id_configuracion
	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END




















GO
/****** Object:  StoredProcedure [dbo].[abc_OrdenRuta]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[abc_OrdenRuta]
	 @opcion			INT
	,@id_ruta			NVARCHAR(100)
	,@id_terminal		NVARCHAR(MAX)
	,@orden				INT	
	,@usuario			NVARCHAR(100)
AS
BEGIN	
	BEGIN TRY
	DECLARE @fecha	DATETIME
	SET @fecha = dbo.fnGetNewDate()

		IF @opcion = 1		
		BEGIN			
			INSERT INTO tbl_OrdenRuta(
				id_ruta,
				id_terminal,
				orden,
				usuins,
				fecins,
				usuupd,
				fecupd,
				activo) 
			VALUES (
				@id_ruta,
				@id_terminal,
				@orden,
				@usuario,
				@fecha,
				@usuario,
				@fecha,
				1)
		END
		IF @opcion = 2
		BEGIN 
		    UPDATE tbl_OrdenRuta
			SET
			   activo = 0
			WHERE id_ruta = @id_ruta
		END		
	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------
	END CATCH
END































GO
/****** Object:  StoredProcedure [dbo].[abc_rutasindirectas_sp]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[abc_rutasindirectas_sp]
	@opcion				INT,
	@id_ruta			NVARCHAR(100),
	@id_usuario			NVARCHAR(100)
		
AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON	  
		DECLARE @totalsubrutas	INT
		DECLARE @i				INT
		DECLARE @j				INT
		DECLARE @id_terminalorigen	NVARCHAR(100)
		DECLARE @id_terminaldestino	NVARCHAR(100)
		DECLARE @tiempo		INT
		DECLARE @id_terminalxRuta	NVARCHAR(100)
		
		IF @opcion = 1
		BEGIN			
			SET @totalsubrutas = ISNULL((SELECT COUNT(ctr.id_terminalXruta) FROM tbl_CatTerminalesXRuta AS ctr WHERE ctr.id_ruta = @id_ruta AND ctr.activo = 1 AND ctr.id_tipoTerminal = 2), 0)
			SET @i = 0
			WHILE (@i < @totalsubrutas)
			BEGIN				
				SELECT @id_terminalorigen = ctr.id_terminalSalida FROM tbl_CatTerminalesXRuta AS ctr WHERE ctr.id_ruta = @id_ruta AND ctr.indice = (@i + 1) AND ctr.id_tipoTerminal = 2
				SET @j = @i
				WHILE (@j < @totalsubrutas)
				BEGIN
					SELECT @id_terminaldestino = ctr.id_terminalDestino FROM tbl_CatTerminalesXRuta AS ctr WHERE ctr.id_ruta = @id_ruta AND ctr.indice = (@j + 1) AND ctr.id_tipoTerminal = 2
					IF (SELECT COUNT(id_ruta) FROM tbl_CatTerminalesXRuta as ctr WHERE ctr.id_ruta = @id_ruta AND ctr.id_terminalSalida = @id_terminalorigen AND ctr.id_terminalDestino = @id_terminaldestino AND ctr.activo = 1) = 0
					BEGIN
						SELECT @tiempo = ISNULL(SUM(ctr.tiempoMinutos), 0) FROM tbl_CatTerminalesXRuta as ctr WHERE ctr.id_ruta = @id_ruta AND ctr.activo = 1 AND ctr.id_tipoTerminal = 2 AND ctr.indice >= (@i+1) AND ctr.indice <= (@j + 1)
						EXECUTE abc_CatTerminalesXRuta 1, '', @id_ruta, @id_terminalorigen, @id_terminaldestino, @tiempo, 3, @totalsubrutas, @id_usuario
					END	
					SET @j = @j + 1
				END
				SET @i = @i + 1
			END
		END


		IF @opcion = 2
		BEGIN
			SET @totalsubrutas = ISNULL((SELECT COUNT(ctr.id_terminalXruta) FROM tbl_CatTerminalesXRuta AS ctr WHERE ctr.id_ruta = @id_ruta AND ctr.activo = 1 AND ctr.id_tipoTerminal = 2), 0)

			UPDATE tbl_CatTerminalesXRuta 
			SET activo = 0
			WHERE id_ruta = @id_ruta AND id_tipoTerminal = 3
			SET @i = 0
			WHILE (@i < @totalsubrutas)
			BEGIN				
				SELECT @id_terminalorigen = ctr.id_terminalSalida FROM tbl_CatTerminalesXRuta AS ctr WHERE ctr.id_ruta = @id_ruta AND ctr.indice = (@i + 1) AND ctr.id_tipoTerminal = 2
				SET @j = @i
				WHILE (@j < @totalsubrutas)
				BEGIN
					SELECT @id_terminaldestino = ctr.id_terminalDestino FROM tbl_CatTerminalesXRuta AS ctr WHERE ctr.id_ruta = @id_ruta AND ctr.indice = (@j + 1) AND ctr.id_tipoTerminal = 2
					IF (SELECT COUNT(id_ruta) FROM tbl_CatTerminalesXRuta as ctr WHERE ctr.id_ruta = @id_ruta AND ctr.id_terminalSalida = @id_terminalorigen AND ctr.id_terminalDestino = @id_terminaldestino) = 0
					BEGIN
						SELECT @tiempo = ISNULL(SUM(ctr.tiempoMinutos), 0) FROM tbl_CatTerminalesXRuta as ctr WHERE ctr.id_ruta = @id_ruta AND ctr.activo = 1 AND ctr.id_tipoTerminal = 2 AND ctr.indice >= (@i+1) AND ctr.indice <= (@j + 1)
						EXECUTE abc_CatTerminalesXRuta 1, '', @id_ruta, @id_terminalorigen, @id_terminaldestino, @tiempo, 3, @totalsubrutas, @id_usuario
					END	
					ELSE
					BEGIN
						SELECT @id_terminalxRuta = id_terminalXruta FROM tbl_CatTerminalesXRuta as ctr WHERE ctr.id_ruta = @id_ruta AND ctr.id_terminalSalida = @id_terminalorigen AND ctr.id_terminalDestino = @id_terminaldestino
						SELECT @tiempo = ISNULL(SUM(ctr.tiempoMinutos), 0) FROM tbl_CatTerminalesXRuta as ctr WHERE ctr.id_ruta = @id_ruta AND ctr.activo = 1 AND  ctr.id_tipoTerminal = 2 AND ctr.indice >= (@i+1) AND ctr.indice <= (@j + 1)
						UPDATE tbl_CatTerminalesXRuta 
						SET activo = 1, tiempoMinutos = @tiempo
						WHERE id_terminalXruta = @id_terminalxRuta
					END
					SET @j = @j + 1
				END
				SET @i = @i + 1
			END
		END

	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END







GO
/****** Object:  StoredProcedure [dbo].[AperturaCaja_Insertar_sp]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




ALTER PROCEDURE [dbo].[AperturaCaja_Insertar_sp]
		 @id_caja		NVARCHAR(100)
		,@id_cajaCat    NVARCHAR(100)
		,@id_sucursal	NVARCHAR(100)
		,@M50C			INT	
        ,@M1P			INT
        ,@M2P			INT
        ,@M5P			INT
        ,@M10P			INT
		,@M20P			INT
        ,@M100P			INT
        ,@B20P			INT
        ,@B50P			INT
        ,@B100P			INT
        ,@B200P			INT
        ,@B500P			INT
        ,@B1000P		INT
        ,@Total			FLOAT
		,@Id_U			NVARCHAR(100)
		,@FechaIngreso	DATE
		,@HoraIngreso	NVARCHAR(10)
AS
BEGIN
	BEGIN TRANSACTION
	BEGIN TRY
		
		SET NOCOUNT ON
			DECLARE @fecha	DATETIME
	        SET @fecha = dbo.fnGetNewDate()
		
		SET @FechaIngreso = @fecha
		SET @HoraIngreso = CONVERT(NVARCHAR(10), @fecha, 108)

		UPDATE tbl_CajaXSucursal
		SET id_caja = @id_cajaCat
			,id_sucursal = @id_sucursal
			,id_cajero = @Id_U
			,id_statusCaja = 1
			--,fecha_inicio = @FechaIngreso
			--,hora_inicio = @HoraIngreso
			,caja_inicial = @Total
			,caja_final = 0
			--,activo = 1
			--,usuins = @Id_U
			--,fecins = @fecha
			--,usuupd = @Id_U
			--,fecupd =@fecha
			--,id_turno = 1
		WHERE id_cajaXsucursal = @id_caja

		UPDATE tbl_EfectivoXCaja
        SET id_sucursal = @id_sucursal
           ,id_tipoEfectivo = 1
           ,M50C = @M50C
           ,M1P = @M1P
           ,M2P = @M2P
           ,M5P = @M5P
           ,M10P = @M10P
           ,M20P = @M20P
           ,M100P = @M100P
           ,B20P = @B20P
           ,B50P = @B50P
           ,B100P = @B100P
           ,B200P = @B200P
           ,B500P = @B500P
           ,B1000P = @B1000P
           ,Total = @Total
           ,activo = 1
           ,usuins = @Id_U
           ,fecins = @fecha
           ,usuupd = @Id_U
           ,fecupd = @fecha
         WHERE id_cajaXsucursal = @id_caja

		--		INSERT INTO tbl_CajaXSucursal
		--			(id_cajaXSucursal
		--			,id_caja
		--			,id_sucursal
		--			,id_cajero
		--			,id_statusCaja
		--			,fecha_inicio
		--			,hora_inicio
		--			,caja_inicial
		--			,caja_final
		--			,activo
		--			,usuins
		--			,fecins
		--			,usuupd
		--			,fecupd
		--			,id_turno)
		--		VALUES
		--			(
		--			 @id_caja
		--			,@id_cajaCat
		--			,@id_sucursal
		--			,@Id_U
		--			,1
		--			,@FechaIngreso
		--			,@HoraIngreso
		--			,@Total
		--			,0
		--			,1
		--			,@Id_U
		--			,@fecha
		--			,@Id_U
		--			,@fecha
		--			,1)

		--INSERT INTO tbl_EfectivoXCaja
  --         (Id_cajaXSucursal
		--   ,id_sucursal
  --         ,id_tipoEfectivo
  --         ,M50C
  --         ,M1P
  --         ,M2P
  --         ,M5P
  --         ,M10P
  --         ,M20P
  --         ,M100P
  --         ,B20P
  --         ,B50P
  --         ,B100P
  --         ,B200P
  --         ,B500P
  --         ,B1000P
  --         ,Total
  --         ,activo
  --         ,usuins
  --         ,fecins
  --         ,usuupd
  --         ,fecupd)
  --   VALUES
  --         (@id_caja
		--   ,@id_sucursal
  --         ,1
  --         ,@M50C
  --         ,@M1P
  --         ,@M2P
  --         ,@M5P
  --         ,@M10P
		--   ,@M20P
		--   ,@M100P
		--   ,@B20P
		--   ,@B50P
		--   ,@B100P
		--   ,@B200P
  --         ,@B500P
		--   ,@B1000P
		--   ,@Total
  --         ,1
  --         ,@Id_U
  --         ,@fecha
  --         ,@Id_U
  --         ,@fecha)

	COMMIT TRANSACTION			
	END TRY
	BEGIN CATCH          
		-- Control de errores          
		ROLLBACK TRANSACTION
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
	END CATCH 
END




















GO
/****** Object:  StoredProcedure [dbo].[asistenciaPasajero]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[asistenciaPasajero]
	 @codigoBarra			NVARCHAR(20),
	 @id_u					NVARCHAR(100)
AS
BEGIN	
	BEGIN TRY
	DECLARE @fecha	DATETIME
	SET @fecha = dbo.fnGetNewDate()

		IF(EXISTS(SELECT id_boleto FROM tbl_Boletos WHERE CodigoBarra = @codigoBarra AND (id_status = 2)))
		BEGIN
			   SELECT 1 -- Para poder marcar asistencia debe de pagar el boleto
		END
		ELSE IF(EXISTS(SELECT id_boleto FROM tbl_Boletos WHERE CodigoBarra = @codigoBarra AND id_status = 3 AND asistencia = 1))
		BEGIN
			  SELECT 2 -- Asistencia ya marcada
		END
		ELSE IF(EXISTS(SELECT id_boleto FROM tbl_Boletos WHERE CodigoBarra = @codigoBarra AND id_status = 3 AND asistencia = 0))
		BEGIN
			  UPDATE tbl_Boletos
			  SET
					asistencia = 1,
					usuupd = @id_u,
					fecupd = @fecha 
			  WHERE CodigoBarra = @codigoBarra AND id_status = 3
			  SELECT 3 -- Asistencia Registrada Correctamente
		END
		ELSE
		BEGIN
			  SELECT 4 --Boleto No Encontrado
		END

	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------
	END CATCH
END







GO
/****** Object:  StoredProcedure [dbo].[Boleto_Pagar_sp]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER PROCEDURE [dbo].[Boleto_Pagar_sp]	
        @IDBOLETO                NVARCHAR(100)
	   ,@IDVENTA                 NVARCHAR(100)
	   ,@IDVENTADETALLE          NVARCHAR(100)
	   ,@TOTALPAGAR              MONEY
	   ,@PAGOEFECTIVO			 MONEY
	   ,@PAGOMONEDERO			 MONEY
	   ,@PAGOTARJETA			 MONEY
	   ,@PAGOTRANSFERENCIA		 MONEY
	   ,@IDFORMAPAGO             INT
	   ,@OBSERVACION             NVARCHAR(MAX)
	   ,@IDVENDEDOR              NVARCHAR(100)
	   ,@IDCAJA                  NVARCHAR(100)
	   ,@IDSUCURSAL              NVARCHAR(100)
	   ,@DATOSTARJETA		     DatosTarjeta READONLY
	   ,@DATOSTRANSFERENCIA	     DatosTransferencia READONLY
AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON
		
    BEGIN TRANSACTION

	DECLARE @porcentajeMonedero MONEY
	DECLARE @pagoBoleto MONEY
	DECLARE @newMonedero MONEY
	DECLARE @IDCliente NVARCHAR(100)
	DECLARE @IDVENTAPAGO NVARCHAR(100) = NEWID()
	DECLARE @FECHAACTUAL DATETIME = (dbo.fnGetNewDate())
	DECLARE @ACTIVO BIT = 1



		 UPDATE tbl_VentaDetalle
		   SET 
			   pago2 =  @TOTALPAGAR
			  ,usuupd = @IDVENDEDOR
			  ,fecupd = @FECHAACTUAL
		 WHERE id_ventadetalle = @IDVENTADETALLE


		 UPDATE tbl_Boletos
		   SET 
			   id_status = 3,
			   usuins = @IDVENDEDOR
		 FROM tbl_Boletos JOIN tbl_VentaDetalle
		 ON tbl_Boletos.id_boleto = tbl_VentaDetalle.id_boleto
		 WHERE tbl_Boletos.id_boleto = @IDBOLETO AND tbl_VentaDetalle.costo = tbl_VentaDetalle.pago1 + tbl_VentaDetalle.pago2 

	   	UPDATE tbl_Venta
		   SET 
			   pago = pago + @TOTALPAGAR
			  ,pendiente = pendiente - @TOTALPAGAR
			  ,usuupd = @IDVENDEDOR
			  ,fecupd = @FECHAACTUAL
			  ,cajupd = @IDCAJA
		 WHERE id_venta = @IDVENTA

		UPDATE tbl_Venta
		   SET 
			   Estatus = 1
		 WHERE id_venta = @IDVENTA AND total = pago


		SET @porcentajeMonedero = (SELECT porcentaje_puntos FROM tbl_CatSucursales JOIN tbl_CatUsuarioXSuc ON tbl_CatSucursales.id_sucursal = tbl_CatUsuarioXSuc.id_sucursal WHERE Id_U = @IDVENDEDOR )	
		SET @pagoBoleto = (SELECT pago1 + pago2 FROM tbl_VentaDetalle WHERE id_boleto = @IDBOLETO) 
		SET @newMonedero = (@pagoBoleto * @porcentajeMonedero)
		SET @IDCliente = (SELECT id_cliente FROM tbl_Venta JOIN tbl_VentaDetalle ON tbl_Venta.id_Venta = tbl_VentaDetalle.id_Venta JOIN tbl_Boletos ON tbl_VentaDetalle.id_boleto = tbl_Boletos.id_boleto WHERE tbl_Boletos.id_boleto = @IDBOLETO)	

		UPDATE tbl_CatCredenciales
			SET 
			  monedero = monedero + @newMonedero
		WHERE id_cliente = @IDCliente


		INSERT INTO tbl_VentaCajas
           (IDVentasCajas
           ,IDCajaXSucursal
           ,IDStatus
           ,IDGenerico
		   ,usuins
           ,fecins
           ,usuupd
           ,fecupd
           ,activo)
         VALUES
           (NEWID()
           ,@IDCAJA
           ,4
           ,@IDVENTADETALLE
		   ,@IDVENDEDOR
		   ,@FECHAACTUAL
		   ,@IDVENDEDOR
		   ,@FECHAACTUAL
		   ,@ACTIVO)

	INSERT INTO tbl_VentaPagos
           (id_ventaxpago
           ,id_sucursal
           ,id_venta
           ,id_formaPago
           ,monto
		   ,montoEfectivo
		   ,montoMonedero
		   ,montoTarjeta
		   ,montoTransferencia
           ,observaciones
           ,fecha
           ,id_cajaXSucursal
           ,id_cajero
           ,usuins
           ,fecins
           ,usuupd
           ,fecupd
           ,activo)
     VALUES
           (@IDVENTAPAGO
           ,@IDSUCURSAL
           ,@IDVENTA
           ,@IDFORMAPAGO
           ,@TOTALPAGAR
		   ,@PAGOEFECTIVO
		   ,@PAGOMONEDERO
		   ,@PAGOTARJETA
		   ,@PAGOTRANSFERENCIA
           ,@OBSERVACION
           ,@FECHAACTUAL
           ,@IDCAJA
           ,@IDVENDEDOR
           ,@IDVENDEDOR
           ,@FECHAACTUAL
           ,@IDVENDEDOR
           ,@FECHAACTUAL
           ,@ACTIVO)

	IF ISNULL(@PAGOTARJETA, 0) > 0
		BEGIN
		INSERT INTO [dbo].[tbl_PagoTarjeta] 
			([id_pagotarjeta], [id_sucursal], [id_venta], [id_ventaxpago], [autorizacion], [folio_IFE], [id_TipoDocumento],
			 [numTarjeta], [id_banco], [monto], [usuins], [fecins], [usuupd], [fecupd], [activo])
		SELECT

			NEWID(), @IDSUCURSAL, @IDVENTA, @IDVENTAPAGO, DatosTarjeta.autorizacion, DatosTarjeta.folioDNI, DatosTarjeta.tipoDocumento,
			DatosTarjeta.numTarjeta, DatosTarjeta.id_banco, DatosTarjeta.monto, @IDVENDEDOR, @FECHAACTUAL, @IDVENDEDOR, @FECHAACTUAL, @ACTIVO
			FROM @DATOSTARJETA AS DatosTarjeta
		END

	IF ISNULL(@PAGOTRANSFERENCIA, 0) > 0
		BEGIN
		INSERT INTO [dbo].[tbl_PagoTransferencia]
			([id_pagotransferencia], [id_sucursal], [id_venta], [id_ventaxpago], [autorizacion], 
			 [id_banco], [monto], [usuins], [fecins], [usuupd], [fecupd], [activo])
		SELECT

			NEWID(), @IDSUCURSAL, @IDVENTA, @IDVENTAPAGO, DatosTransferencia.autorizacion,
			DatosTransferencia.id_banco, DatosTransferencia.monto, @IDVENDEDOR, @FECHAACTUAL, @IDVENDEDOR, @FECHAACTUAL, @ACTIVO
			FROM @DATOSTRANSFERENCIA AS DatosTransferencia
		END 

	  IF @@ERROR <> 0 
      BEGIN
		SELECT 0
		ROLLBACK TRANSACTION
		RETURN
	  END
	 COMMIT TRANSACTION

	SELECT 1
	

	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END









GO
/****** Object:  StoredProcedure [dbo].[Boleto_PagarGrupal_sp]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER PROCEDURE [dbo].[Boleto_PagarGrupal_sp]	
	    @IDVENTA                 NVARCHAR(100)
	   ,@IDFORMAPAGO             INT
	   ,@OBSERVACION             NVARCHAR(MAX)
	   ,@IDVENDEDOR              NVARCHAR(100)
	   ,@IDCAJA                  NVARCHAR(100)
	   ,@IDSUCURSAL              NVARCHAR(100)
	   ,@PAGOEFECTIVO			 MONEY
	   ,@PAGOMONEDERO			 MONEY
	   ,@PAGOTARJETA			 MONEY
	   ,@PAGOTRANSFERENCIA		 MONEY
	   ,@DATOSTARJETA		     DatosTarjeta READONLY
	   ,@DATOSTRANSFERENCIA	     DatosTransferencia READONLY
AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON
		
    BEGIN TRANSACTION

	DECLARE @porcentajeMonedero MONEY
	DECLARE @pagoBoleto MONEY
	DECLARE @newMonedero MONEY
	DECLARE @IDCliente NVARCHAR(100)
	DECLARE @IDVENTAPAGO NVARCHAR(100) = NEWID()
	DECLARE @FECHAACTUAL DATETIME = (dbo.fnGetNewDate())
	DECLARE @ACTIVO BIT = 1

	DECLARE @IDBOLETO   NVARCHAR(100)
	DECLARE @IDVENTADETALLE  NVARCHAR(100)
	DECLARE @TOTALPAGAR      MONEY


	DECLARE BoletosInfo CURSOR FOR SELECT tb.id_boleto, vd.id_ventadetalle, CASE WHEN vd.costo  - (vd.pago1 + vd.pago2) <= 0  THEN 0 WHEN vd.costo  - (vd.pago1 + vd.pago2)  >  0  THEN vd.costo  - (vd.pago1 + vd.pago2)  END AS pendiente FROM tbl_Boletos AS tb JOIN tbl_VentaDetalle AS vd ON tb.id_boleto = vd.id_boleto JOIN tbl_Venta AS v ON v.id_venta = vd.id_venta WHERE vd.activo = 1 AND tb.activo = 1 AND tb.id_status = 2 AND vd.id_venta = @IDVENTA
	OPEN BoletosInfo
	FETCH NEXT FROM BoletosInfo INTO @IDBOLETO, @IDVENTADETALLE, @TOTALPAGAR
	WHILE @@fetch_status = 0
	BEGIN

		UPDATE tbl_VentaDetalle
		   SET 
			   pago2 =  @TOTALPAGAR
			  ,usuupd = @IDVENDEDOR
			  ,fecupd = @FECHAACTUAL
		 WHERE id_ventadetalle = @IDVENTADETALLE

		UPDATE tbl_Boletos
		   SET 
			   id_status = 3,
			   usuins = @IDVENDEDOR
		 FROM tbl_Boletos JOIN tbl_VentaDetalle
		 ON tbl_Boletos.id_boleto = tbl_VentaDetalle.id_boleto
		 WHERE tbl_Boletos.id_boleto = @IDBOLETO AND tbl_VentaDetalle.costo = tbl_VentaDetalle.pago1 + tbl_VentaDetalle.pago2 

	   	UPDATE tbl_Venta
		   SET 
			   pago = pago + @TOTALPAGAR
			  ,pendiente = pendiente - @TOTALPAGAR
			  ,usuupd = @IDVENDEDOR
			  ,fecupd = @FECHAACTUAL
			  ,cajupd = @IDCAJA
		 WHERE id_venta = @IDVENTA

		UPDATE tbl_Venta
		   SET 
			   Estatus = 1
		 WHERE id_venta = @IDVENTA AND total = pago
		
		SET @porcentajeMonedero = (SELECT porcentaje_puntos FROM tbl_CatSucursales JOIN tbl_CatUsuarioXSuc ON tbl_CatSucursales.id_sucursal = tbl_CatUsuarioXSuc.id_sucursal WHERE Id_U = @IDVENDEDOR )	
		SET @pagoBoleto = (SELECT pago1 + pago2 FROM tbl_VentaDetalle WHERE id_boleto = @IDBOLETO) 
		SET @newMonedero = (@pagoBoleto * @porcentajeMonedero)
		SET @IDCliente = (SELECT id_cliente FROM tbl_Venta JOIN tbl_VentaDetalle ON tbl_Venta.id_Venta = tbl_VentaDetalle.id_Venta JOIN tbl_Boletos ON tbl_VentaDetalle.id_boleto = tbl_Boletos.id_boleto WHERE tbl_Boletos.id_boleto = @IDBOLETO)	

		UPDATE tbl_CatCredenciales
			SET 
			  monedero = monedero + @newMonedero
		WHERE id_cliente = @IDCliente
		
		INSERT INTO tbl_VentaCajas
           (IDVentasCajas
           ,IDCajaXSucursal
           ,IDStatus
           ,IDGenerico
		   ,usuins
           ,fecins
           ,usuupd
           ,fecupd
           ,activo)
         VALUES
           (NEWID()
           ,@IDCAJA
           ,4
           ,@IDVENTADETALLE
		   ,@IDVENDEDOR
		   ,@FECHAACTUAL
		   ,@IDVENDEDOR
		   ,@FECHAACTUAL
		   ,1)
		FETCH NEXT FROM BoletosInfo INTO @IDBOLETO, @IDVENTADETALLE, @TOTALPAGAR
 	END
	CLOSE BoletosInfo
	DEALLOCATE BoletosInfo

		INSERT INTO tbl_VentaPagos
           (id_ventaxpago
           ,id_sucursal
           ,id_venta
           ,id_formaPago
           ,monto
		   ,montoEfectivo
		   ,montoMonedero
		   ,montoTarjeta
		   ,montoTransferencia
           ,observaciones
           ,fecha
           ,id_cajaXSucursal
           ,id_cajero
           ,usuins
           ,fecins
           ,usuupd
           ,fecupd
           ,activo)
     VALUES
           (@IDVENTAPAGO
           ,@IDSUCURSAL
           ,@IDVENTA
           ,@IDFORMAPAGO
           ,@TOTALPAGAR
		   ,@PAGOEFECTIVO
		   ,@PAGOMONEDERO
		   ,@PAGOTARJETA
		   ,@PAGOTRANSFERENCIA
           ,@OBSERVACION
           ,@FECHAACTUAL
           ,@IDCAJA
           ,@IDVENDEDOR
           ,@IDVENDEDOR
           ,@FECHAACTUAL
           ,@IDVENDEDOR
           ,@FECHAACTUAL
           ,1)

	IF ISNULL(@PAGOTARJETA, 0) > 0
		BEGIN
		INSERT INTO [dbo].[tbl_PagoTarjeta] 
			([id_pagotarjeta], [id_sucursal], [id_venta], [id_ventaxpago], [autorizacion], [folio_IFE], [id_TipoDocumento],
			 [numTarjeta], [id_banco], [monto], [usuins], [fecins], [usuupd], [fecupd], [activo])
		SELECT

			NEWID(), @IDSUCURSAL, @IDVENTA, @IDVENTAPAGO, DatosTarjeta.autorizacion, DatosTarjeta.folioDNI, DatosTarjeta.tipoDocumento,
			DatosTarjeta.numTarjeta, DatosTarjeta.id_banco, DatosTarjeta.monto, @IDVENDEDOR, @FECHAACTUAL, @IDVENDEDOR, @FECHAACTUAL, @ACTIVO
			FROM @DATOSTARJETA AS DatosTarjeta
		END

	IF ISNULL(@PAGOTRANSFERENCIA, 0) > 0
		BEGIN
		INSERT INTO [dbo].[tbl_PagoTransferencia]
			([id_pagotransferencia], [id_sucursal], [id_venta], [id_ventaxpago], [autorizacion], 
			 [id_banco], [monto], [usuins], [fecins], [usuupd], [fecupd], [activo])
		SELECT

			NEWID(), @IDSUCURSAL, @IDVENTA, @IDVENTAPAGO, DatosTransferencia.autorizacion,
			DatosTransferencia.id_banco, DatosTransferencia.monto, @IDVENDEDOR, @FECHAACTUAL, @IDVENDEDOR, @FECHAACTUAL, @ACTIVO
			FROM @DATOSTRANSFERENCIA AS DatosTransferencia
		END 

	  IF @@ERROR <> 0 
      BEGIN
		SELECT 0
		ROLLBACK TRANSACTION
		RETURN
	  END
	 COMMIT TRANSACTION

	SELECT 1
	

	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END









GO
/****** Object:  StoredProcedure [dbo].[Boleto_PagarGrupal2_sp]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER PROCEDURE [dbo].[Boleto_PagarGrupal2_sp]	
	    @IDVENTA                 NVARCHAR(100)
	   ,@IDFORMAPAGO             INT
	   ,@OBSERVACION             NVARCHAR(MAX)
	   ,@IDVENDEDOR              NVARCHAR(100)
	   ,@IDCAJA                  NVARCHAR(100)
	   ,@IDSUCURSAL              NVARCHAR(100)
	   ,@PAGOEFECTIVO			 MONEY
	   ,@PAGOMONEDERO			 MONEY
	   ,@PAGOTARJETA			 MONEY
	   ,@PAGOTRANSFERENCIA		 MONEY
	   ,@DATOSTARJETA		     DatosTarjeta READONLY
	   ,@DATOSTRANSFERENCIA	     DatosTransferencia READONLY
AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON
		
    BEGIN TRANSACTION

	DECLARE @porcentajeMonedero MONEY
	DECLARE @pagoBoleto MONEY
	DECLARE @newMonedero MONEY
	DECLARE @IDCliente NVARCHAR(100)
	DECLARE @IDVENTAPAGO NVARCHAR(100) = NEWID()
	DECLARE @FECHAACTUAL DATETIME = (dbo.fnGetNewDate())
	DECLARE @ACTIVO BIT = 1

	DECLARE @IDBOLETO   NVARCHAR(100)
	DECLARE @IDVENTADETALLE  NVARCHAR(100)
	DECLARE @TOTALPAGAR      MONEY

	ALTER TABLE #TablaBoletosTemp 
		(id_boleto NVARCHAR(100) COLLATE SQL_Latin1_General_CP1_CI_AS, 
		id_ventaDetallle NVARCHAR(100) COLLATE SQL_Latin1_General_CP1_CI_AS, 
		totalPagar MONEY, 
		PRIMARY KEY(id_boleto,id_ventaDetallle))

	INSERT INTO #TablaBoletosTemp
		(id_boleto
		,id_ventaDetallle
		,totalPagar)
	SELECT 
		 tb.id_boleto
		,vd.id_ventadetalle, 
		CASE 
			WHEN vd.costo  - (vd.pago1 + vd.pago2) <= 0  THEN 0 
			WHEN vd.costo  - (vd.pago1 + vd.pago2)  >  0  THEN vd.costo  - (vd.pago1 + vd.pago2)  
		END AS pendiente 
	FROM tbl_Boletos AS tb JOIN tbl_VentaDetalle AS vd 
	ON tb.id_boleto = vd.id_boleto 
	JOIN tbl_Venta AS v ON v.id_venta = vd.id_venta 
	WHERE vd.activo = 1 AND tb.activo = 1 AND tb.id_status = 2 AND vd.id_venta = @IDVENTA


	SET @porcentajeMonedero = (SELECT porcentaje_puntos FROM tbl_CatSucursales JOIN tbl_CatUsuarioXSuc ON tbl_CatSucursales.id_sucursal = tbl_CatUsuarioXSuc.id_sucursal WHERE Id_U = @IDVENDEDOR )	
	SET @pagoBoleto = (SELECT ISNULL(SUM(totalPagar),0.0) FROM #TablaBoletosTemp )
	SET @TOTALPAGAR =  @pagoBoleto
	SET @newMonedero = (@pagoBoleto * @porcentajeMonedero)
	SET @IDCliente = (SELECT id_cliente FROM tbl_Venta WHERE id_venta = @IDVENTA)	

	UPDATE tbl_VentaDetalle
	SET 
		tbl_VentaDetalle.pago2 =  TablaBoletosTemp.totalPagar
		,tbl_VentaDetalle.usuupd = @IDVENDEDOR
		,tbl_VentaDetalle.fecupd = @FECHAACTUAL
	FROM tbl_VentaDetalle JOIN #TablaBoletosTemp AS TablaBoletosTemp 
	ON tbl_VentaDetalle.id_boleto = TablaBoletosTemp.id_boleto

	UPDATE tbl_Boletos
	SET 
		id_status = 3,
		usuins = @IDVENDEDOR
	FROM tbl_Boletos JOIN #TablaBoletosTemp AS TablaBoletosTemp 
	ON tbl_Boletos.id_boleto = TablaBoletosTemp.id_boleto

	UPDATE tbl_Venta
	SET 
		pago = pago + @pagoBoleto
		,pendiente = pendiente - @pagoBoleto
		,usuupd = @IDVENDEDOR
		,fecupd = @FECHAACTUAL
		,cajupd = @IDCAJA
	WHERE id_venta = @IDVENTA

	UPDATE tbl_CatCredenciales
		SET 
			monedero = monedero + @newMonedero
	WHERE id_cliente = @IDCliente


	INSERT INTO tbl_VentaCajas
        (IDVentasCajas
        ,IDCajaXSucursal
        ,IDStatus
        ,IDGenerico
		,usuins
        ,fecins
        ,usuupd
        ,fecupd
        ,activo)
	SELECT
		NEWID()
		,@IDCAJA
        ,4
        ,id_ventaDetallle
		,@IDVENDEDOR
		,@FECHAACTUAL
		,@IDVENDEDOR
		,@FECHAACTUAL
		,1
	FROM #TablaBoletosTemp

	IF OBJECT_ID('tempdb.dbo.#TablaBoletosTemp') IS NOT NULL
	BEGIN
		DROP TABLE #TablaBoletosTemp
	END

	INSERT INTO tbl_VentaPagos
        (id_ventaxpago
        ,id_sucursal
        ,id_venta
        ,id_formaPago
        ,monto
		,montoEfectivo
		,montoMonedero
		,montoTarjeta
		,montoTransferencia
        ,observaciones
        ,fecha
        ,id_cajaXSucursal
        ,id_cajero
        ,usuins
        ,fecins
        ,usuupd
        ,fecupd
        ,activo)
    VALUES
        (@IDVENTAPAGO
        ,@IDSUCURSAL
        ,@IDVENTA
        ,@IDFORMAPAGO
        ,@TOTALPAGAR
		,@PAGOEFECTIVO
		,@PAGOMONEDERO
		,@PAGOTARJETA
		,@PAGOTRANSFERENCIA
        ,@OBSERVACION
        ,@FECHAACTUAL
        ,@IDCAJA
        ,@IDVENDEDOR
        ,@IDVENDEDOR
        ,@FECHAACTUAL
        ,@IDVENDEDOR
        ,@FECHAACTUAL
        ,1)

	IF ISNULL(@PAGOTARJETA, 0) > 0
		BEGIN
		INSERT INTO [dbo].[tbl_PagoTarjeta] 
			([id_pagotarjeta], [id_sucursal], [id_venta], [id_ventaxpago], [autorizacion], [folio_IFE], [id_TipoDocumento],
			 [numTarjeta], [id_banco], [monto], [usuins], [fecins], [usuupd], [fecupd], [activo])
		SELECT

			NEWID(), @IDSUCURSAL, @IDVENTA, @IDVENTAPAGO, DatosTarjeta.autorizacion, DatosTarjeta.folioDNI, DatosTarjeta.tipoDocumento,
			DatosTarjeta.numTarjeta, DatosTarjeta.id_banco, DatosTarjeta.monto, @IDVENDEDOR, @FECHAACTUAL, @IDVENDEDOR, @FECHAACTUAL, @ACTIVO
			FROM @DATOSTARJETA AS DatosTarjeta
		END

	IF ISNULL(@PAGOTRANSFERENCIA, 0) > 0
		BEGIN
		INSERT INTO [dbo].[tbl_PagoTransferencia]
			([id_pagotransferencia], [id_sucursal], [id_venta], [id_ventaxpago], [autorizacion], 
			 [id_banco], [monto], [usuins], [fecins], [usuupd], [fecupd], [activo])
		SELECT

			NEWID(), @IDSUCURSAL, @IDVENTA, @IDVENTAPAGO, DatosTransferencia.autorizacion,
			DatosTransferencia.id_banco, DatosTransferencia.monto, @IDVENDEDOR, @FECHAACTUAL, @IDVENDEDOR, @FECHAACTUAL, @ACTIVO
			FROM @DATOSTRANSFERENCIA AS DatosTransferencia
		END 

	  IF @@ERROR <> 0 
      BEGIN
		SELECT 0
		ROLLBACK TRANSACTION
		RETURN
	  END
	 COMMIT TRANSACTION

	SELECT 1
	

	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END









GO
/****** Object:  StoredProcedure [dbo].[Boletos_LiberarSistema_sp1]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




ALTER PROCEDURE [dbo].[Boletos_LiberarSistema_sp1]		
AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON

		DECLARE @FECHASISTEMA DATETIME 
		SET @FECHASISTEMA = dbo.fnGetNewDate()
		-- Liberacion Boletos atrapados 

		UPDATE tbl_Boletos 
		SET 
		    activo = 0,
			usuupd = 0,
			fecupd = @FECHASISTEMA 
	    WHERE CONVERT(DATETIME,DATEADD(SECOND, 900,fecins)) < @FECHASISTEMA AND id_status = 1 AND activo = 1
	
	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END



































GO
/****** Object:  StoredProcedure [dbo].[Boletos_LiberarSistema_sp2]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER PROCEDURE [dbo].[Boletos_LiberarSistema_sp2]		
AS
BEGIN
	BEGIN TRY

		SET NOCOUNT ON

		DECLARE @FECHASISTEMA DATETIME 
		SET @FECHASISTEMA = dbo.fnGetNewDate()
		

		DECLARE @IDVIAJE_ NVARCHAR(100)
		DECLARE @FECHA_ DATE
		DECLARE @HORA_ NVARCHAR(8)
		DECLARE @FECHASALIDA_ DATE
		DECLARE @HORASALIDA_ NVARCHAR(8)
		DECLARE @ORDENORIGEN_ INT 
		DECLARE @ORDENDESTINO_ INT 
		

	    DECLARE tl CURSOR LOCAL FOR SELECT vtbl_FechasViaje.id_viaje, vtbl_FechasViaje.fechaOrigen, vtbl_FechasViaje.horaOrigen, vtbl_FechasViaje.fechaOrigenV, vtbl_FechasViaje.horaOrigenV, vtbl_FechasViaje.ordenOrigen, vtbl_FechasViaje.ordenDestino FROM vtbl_FechasViaje WHERE fechaOrigen = CONVERT(DATE,@FECHASISTEMA) AND activo = 1
		OPEN tl
		FETCH tl INTO @IDVIAJE_, @FECHA_, @HORA_,@FECHASALIDA_,@HORASALIDA_,@ORDENORIGEN_,@ORDENDESTINO_
		WHILE(@@fetch_status=0)
		BEGIN
		-- Liberacion Boletos Aparatados Sin Anticipo
		IF((@FECHASISTEMA > CONVERT(DATETIME,DATEADD(HOUR,-2,CONVERT(DATETIME, CAST(CONVERT(DATE,@FECHASALIDA_) AS NVARCHAR(10)) + ' ' + @HORASALIDA_ ,121))))  AND (@FECHASISTEMA < CONVERT(DATETIME,DATEADD(HOUR,2,CONVERT(DATETIME, CAST(CONVERT(DATE,@FECHASALIDA_) AS NVARCHAR(10)) + ' ' + @HORASALIDA_,121)))))
		BEGIN 
		     
			 IF(EXISTS(SELECT * FROM tbl_Boletos JOIN tbl_VentaDetalle ON tbl_Boletos.id_boleto = tbl_VentaDetalle.id_boleto WHERE tbl_Boletos.fecha_salidaV = CONVERT(DATE,@FECHASISTEMA) AND tbl_Boletos.hora_salidaV = @HORASALIDA_ AND tbl_Boletos.OrdenOrigenTerminal = @ORDENORIGEN_ AND tbl_Boletos.OrdenDestinoTerminal = @ORDENDESTINO_ AND tbl_Boletos.id_status = 2 AND (tbl_VentaDetalle.pago1 + tbl_VentaDetalle.pago2)  = 0.0))
			 BEGIN
		   		UPDATE tbl_Boletos 
				SET 
				    activo = 0,
					usuupd = 0,
					fecupd = @FECHASISTEMA
				FROM tbl_Boletos JOIN tbl_VentaDetalle
				ON tbl_Boletos.id_boleto = tbl_VentaDetalle.id_boleto
				WHERE
				tbl_Boletos.fecha_salidaV = CONVERT(DATE,@FECHASISTEMA) AND tbl_Boletos.hora_salidaV = @HORASALIDA_ AND tbl_Boletos.OrdenOrigenTerminal = @ORDENORIGEN_ AND tbl_Boletos.OrdenDestinoTerminal = @ORDENDESTINO_ AND tbl_Boletos.id_status = 2 AND (tbl_VentaDetalle.pago1 + tbl_VentaDetalle.pago2)  = 0.0
			END
		END

		-- Liberacion Boletos Aparatados Con Anticipo
		IF((@FECHASISTEMA > CONVERT(DATETIME, CAST(CONVERT(DATE,@FECHASALIDA_) AS NVARCHAR(10)) + ' ' + @HORASALIDA_ ,121))  AND (@FECHASISTEMA < CONVERT(DATETIME,DATEADD(HOUR,2,CONVERT(DATETIME, CAST(CONVERT(DATE,@FECHASALIDA_) AS NVARCHAR(10)) + ' ' + @HORASALIDA_,121)))))
		BEGIN 
		     
			 IF(EXISTS(SELECT * FROM tbl_Boletos JOIN tbl_VentaDetalle ON tbl_Boletos.id_boleto = tbl_VentaDetalle.id_boleto WHERE tbl_Boletos.fecha_salidaV = CONVERT(DATE,@FECHASISTEMA) AND tbl_Boletos.hora_salidaV = @HORASALIDA_ AND tbl_Boletos.OrdenOrigenTerminal = @ORDENORIGEN_ AND tbl_Boletos.OrdenDestinoTerminal = @ORDENDESTINO_ AND tbl_Boletos.id_status = 2 AND (tbl_VentaDetalle.pago1 + tbl_VentaDetalle.pago2)  > 0.0))
			 BEGIN
		   		UPDATE tbl_Boletos 
				SET 
				    activo = 0,
					usuupd = 0,
					fecupd = @FECHASISTEMA
				FROM tbl_Boletos JOIN tbl_VentaDetalle
				ON tbl_Boletos.id_boleto = tbl_VentaDetalle.id_boleto
				WHERE
				tbl_Boletos.fecha_salidaV = CONVERT(DATE,@FECHASISTEMA) AND tbl_Boletos.hora_salidaV = @HORASALIDA_ AND tbl_Boletos.OrdenOrigenTerminal = @ORDENORIGEN_ AND tbl_Boletos.OrdenDestinoTerminal = @ORDENDESTINO_ AND tbl_Boletos.id_status = 2 AND (tbl_VentaDetalle.pago1 + tbl_VentaDetalle.pago2)  > 0.0
			  END
		END

		FETCH tl INTO  @IDVIAJE_, @FECHA_, @HORA_,@FECHASALIDA_,@HORASALIDA_,@ORDENORIGEN_,@ORDENDESTINO_
		END
		CLOSE tl
		DEALLOCATE tl

		
	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END


































GO
/****** Object:  StoredProcedure [dbo].[CajaMac_Asignar_sp]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[CajaMac_Asignar_sp]	
        @IDCAJACAT                NVARCHAR(100)
	   ,@MAC                      NVARCHAR(20)
	   ,@Descripcion              NVARCHAR(1000)
	   ,@NamePrinter			  NVARCHAR(250)
AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON

		UPDATE tbl_CatCajas 
		SET 
		    macAddress = @Mac, 
			descripcion2 = @Descripcion,
			nameprinter = @NamePrinter,
			usuupd = '0',
			fecupd = dbo.fnGetNewDate()
		WHERE id_caja = @IDCAJACAT
	   
	   SELECT 0
	

	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END








GO
/****** Object:  StoredProcedure [dbo].[CambioCamion_Modificar_sp]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[CambioCamion_Modificar_sp]	
				@BoletosCambioRutaViaje BoletosCambioRutaViaje READONLY
AS
BEGIN
	BEGIN TRY

		SET NOCOUNT ON
		
		UPDATE tbl_Boletos 
		SET 
			tbl_Boletos.id_viaje = boletosCambioRutaViaje.IDViajeNuevo,
			tbl_Boletos.fecha_salida = boletosCambioRutaViaje.FechaSalidaNuevo,
			tbl_Boletos.hora_salida = boletosCambioRutaViaje.HoraSalidaNuevo,
			tbl_Boletos.asiento = boletosCambioRutaViaje.AsientoNuevo,
			tbl_Boletos.id_disenioDatos = boletosCambioRutaViaje.IDDisenioDatosNuevo,
			tbl_Boletos.id_status = boletosCambioRutaViaje.IDStatusNuevo,
			tbl_Boletos.OrdenOrigenTerminal = boletosCambioRutaViaje.OrdenOrigenTerminalNuevo,
		    tbl_Boletos.OrdenDestinoTerminal = boletosCambioRutaViaje.OrdenDestinoTerminalNuevo,
			tbl_Boletos.id_tarifa = boletosCambioRutaViaje.IDTarifaNuevo
		FROM tbl_Boletos JOIN @BoletosCambioRutaViaje AS boletosCambioRutaViaje
		ON tbl_Boletos.id_boleto = boletosCambioRutaViaje.IDBoleto 
		AND tbl_Boletos.id_viaje = boletosCambioRutaViaje.IDViajeViejo
		AND tbl_Boletos.fecha_salida = boletosCambioRutaViaje.FechaSalidaViejo
		AND tbl_Boletos.hora_salida = boletosCambioRutaViaje.HoraSalidaViejo
		AND tbl_Boletos.asiento = boletosCambioRutaViaje.AsientoViejo
		AND tbl_Boletos.id_disenioDatos = boletosCambioRutaViaje.IDDisenioDatosViejo
		AND tbl_Boletos.id_status = boletosCambioRutaViaje.IDStatusViejo
		AND tbl_Boletos.OrdenOrigenTerminal = boletosCambioRutaViaje.OrdenOrigenTerminalViejo
		AND tbl_Boletos.OrdenDestinoTerminal = boletosCambioRutaViaje.OrdenDestinoTerminalViejo
		AND tbl_Boletos.id_tarifa = boletosCambioRutaViaje.IDTarifaViejo
	
	
	   SELECT 0

	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END































GO
/****** Object:  StoredProcedure [dbo].[Cancelacion_Boletos_sp]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[Cancelacion_Boletos_sp]
	 @tipoCancelacion			INT
	,@id_boleto					NVARCHAR(100)	
	,@id_ventadetalle			NVARCHAR(100)
	,@id_status					INT
	,@id_caja					NVARCHAR(100)
	,@usuario					NVARCHAR(100)
	,@id_motivoCancelacion		INT
	,@id_tipoCancelacion		INT
	,@descripcionCancelacion	NVARCHAR(1000)
AS
BEGIN	
	BEGIN TRY
	 BEGIN TRANSACTION
	DECLARE @fecha	DATETIME
	DECLARE @porcentajeMonedero MONEY
	DECLARE @pagoBoleto MONEY
	DECLARE @newMonedero MONEY
	DECLARE @IDCliente NVARCHAR(100)

	SET @fecha = dbo.fnGetNewDate()

		BEGIN
		   	SET @porcentajeMonedero = (SELECT porcentaje_puntos FROM tbl_CatSucursales JOIN tbl_CatUsuarioXSuc ON tbl_CatSucursales.id_sucursal = tbl_CatUsuarioXSuc.id_sucursal WHERE Id_U = @usuario)	
			IF(EXISTS( SELECT id_ventadetalle FROM tbl_VentaDetalle JOIN tbl_Boletos ON tbl_VentaDetalle.id_boleto = tbl_Boletos.id_boleto WHERE tbl_Boletos.id_boleto = @id_boleto AND (tbl_Boletos.id_status = 2 OR tbl_Boletos.id_status = 3)))
			BEGIN
			     SET @pagoBoleto = (SELECT pago1 + pago2 FROM tbl_VentaDetalle JOIN tbl_Boletos ON tbl_VentaDetalle.id_boleto = tbl_Boletos.id_boleto WHERE tbl_Boletos.id_boleto = @id_boleto AND (tbl_Boletos.id_status = 2 OR tbl_Boletos.id_status = 3)) 
			END
			ELSE 
			BEGIN
			   SET @pagoBoleto = (0)
			END
			SET @newMonedero = (@pagoBoleto * @porcentajeMonedero)
			SET @IDCliente = (SELECT id_cliente FROM tbl_Venta JOIN tbl_VentaDetalle ON tbl_Venta.id_Venta = tbl_VentaDetalle.id_Venta JOIN tbl_Boletos ON tbl_VentaDetalle.id_boleto = tbl_Boletos.id_boleto WHERE tbl_Boletos.id_boleto = @id_boleto)	

			-- Cancelar el boleto y regresar su status a disponible
			UPDATE	
				tbl_Boletos
			SET
				activo = 0,
				id_status = @id_status,
				usuupd = @usuario,
				fecupd = @fecha
			WHERE 
				id_boleto = @id_boleto
			-- Cancelar el registro en Venta detalle
			UPDATE 
				tbl_VentaDetalle
			SET
				activo = 0,
				usuupd = @usuario,
				fecupd = @fecha
			WHERE
				id_ventadetalle = @id_ventadetalle

			-- Cancelar algun posible descuento
			UPDATE 
				tbl_VentaDetalleDescuento
			SET
				activo = 0,
				usuupd = @usuario,
				fecupd = @fecha
			WHERE 
				id_ventadetalle = @id_ventadetalle


			-- Obtener datos para ingresar en venta detalle
				DECLARE @id_venta NVARCHAR(100)
				DECLARE @id_sucursal	NVARCHAR(100)

				SELECT 
					@id_venta = id_venta,
					@id_sucursal = id_sucursal
				FROM
					tbl_VentaDetalle
				WHERE
					id_ventadetalle = @id_ventadetalle

			-- Si es tipo 1, agregar el nuevo dato			
			IF(@tipoCancelacion = 1)
			BEGIN
			-- Comparar si ya se ha pagado algo del boleto

			--Obtener Monto por cancelacion de boleto
				DECLARE @monto		MONEY
				DECLARE @iva		MONEY
				DECLARE @porc_iva	MONEY
				
				SELECT 
					@monto = cs.monto_cancelacion,
					@porc_iva = cs.porcentaje_iva
				FROM
					tbl_CatSucursales as cs
				WHERE	
					id_sucursal = @id_sucursal

			-- Calcular el IVA 
				--SET @iva = (@monto * @porc_iva) / (100 + @porc_iva)
				
			 --Insertar dato en Venta detalle

				DECLARE @cobroCancelaciones		MONEY = 0.0 
				DECLARE @retornoCancelaciones	MONEY = 0.0

				IF(@pagoBoleto > 0)
				BEGIN
					UPDATE 
						tbl_VentaDetalle
					SET
						cancelacion = (SELECT ISNULL(MAX(monto_cancelacion),0) FROM tbl_CatSucursales)
					WHERE
						id_ventadetalle = @id_ventadetalle

					INSERT INTO tbl_VentaDetalle (
							id_ventadetalle,
							id_sucursal,
							id_venta,
							id_boleto,
							cantidad_venta,
							costo,
							precio,
							porcentaje_desc,
							porcentaje_iva,
							descuento,
							iva, 
							usuins,
							fecins,
							usuupd,
							fecupd,
							activo,
							observaciones)
						VALUES(
							newid(),
							@id_sucursal,
							@id_venta,
							'',
							1,
							@monto,
							@monto,
							0,
							@porc_iva,
							0,
							0,
							@usuario,
							@fecha,
							@usuario,
							@fecha,
							1,
							'Cancelación de boleto')

					SET @cobroCancelaciones = @monto
					SET @retornoCancelaciones = @pagoBoleto - @monto
				END
				
				UPDATE [dbo].[tbl_Venta]
				SET
					cobroCancelacion =  ISNULL(cobroCancelacion,0) + @cobroCancelaciones,
					retornoCancelacion = ISNULL(retornoCancelacion,0) + @retornoCancelaciones
				WHERE id_venta = @id_venta
			END
			
			-- Actualizar montos en tbl_Venta
			DECLARE @sum_costo		MONEY
			DECLARE @sum_precio		MONEY
			DECLARE @sum_iva		MONEY			
			DECLARE @sum_descuento	MONEY
			DECLARE @sum_pagos		MONEY
			SELECT 
				@sum_costo = isnull(SUM(costo), 0),
				@sum_precio = isnull(SUM(precio), 0),
				@sum_iva = isnull(SUM(iva), 0),
				@sum_descuento = isnull(SUM(descuento),0),
				@sum_pagos = isnull(SUM(pago1),0) + isnull(SUM(pago2),0)
			FROM 
				tbl_VentaDetalle as vd
			WHERE
				id_venta = @id_venta
				AND vd.activo = 1 AND vd.id_boleto != '' 

            DECLARE @costoBoleto  MONEY

			SELECT 
				@costoBoleto = isnull(costo, 0)
			FROM 
				tbl_VentaDetalle 
			WHERE
				[id_ventadetalle] = @id_ventadetalle

			UPDATE 
				tbl_Venta
			SET
				importe = @sum_precio,
				iva = @sum_iva,
				descuento = @sum_descuento,
				total = (@sum_costo + @sum_iva - @sum_descuento),
				pendiente = (@sum_costo + @sum_iva - @sum_descuento) - @sum_pagos
			WHERE
				id_venta = @id_venta

			-- Actualizar VentaPagos
			
			UPDATE 
				tbl_VentaPagos
			SET	
				monto = (@sum_costo + @sum_iva - @sum_descuento)
			WHERE 
				id_venta = @id_venta
				

			UPDATE tbl_CatCredenciales
			SET 
			  monedero = monedero - @newMonedero
			WHERE id_cliente = @IDCliente

		 INSERT INTO tbl_VentaCajas
			   (IDVentasCajas
			   ,IDCajaXSucursal
			   ,IDStatus
			   ,IDGenerico
			   ,usuins
			   ,fecins
			   ,usuupd
			   ,fecupd
			   ,activo)
			VALUES
			   (NEWID()
			   ,@id_caja
			   ,6
			   ,@id_ventadetalle
			   ,@USUARIO
			   ,@fecha
			   ,@USUARIO
			   ,@fecha
			   ,1)
	
		INSERT INTO tbl_CancelacionesTransferenciasBoletos
			   (id_boleto
			   ,id_motivoCancelacionTransferencia
			   ,id_tipo
			   ,id_caja
			   ,motivo
			   ,usuins
			   ,fecins
			   ,usuupd
			   ,fecupd
			   ,activo)
		 VALUES
			   (@id_boleto
			   ,@id_motivoCancelacion
			   ,@id_tipoCancelacion
			   ,@id_caja
			   ,@descripcionCancelacion
    		   ,@USUARIO
			   ,@fecha
			   ,@USUARIO
			   ,@fecha
			   ,1)

	 IF @@ERROR <> 0 
      BEGIN
	    SELECT -1
		ROLLBACK TRANSACTION
		RETURN
	  END
	 COMMIT TRANSACTION


		END
	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------
	END CATCH
END



















GO
/****** Object:  StoredProcedure [dbo].[CancelacionGrupal_Boletos_sp]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[CancelacionGrupal_Boletos_sp]
	 @tipoCancelacion			INT
	,@id_venta					NVARCHAR(100)
	,@id_status					INT
	,@id_caja					NVARCHAR(100)
	,@usuario					NVARCHAR(100)
	,@id_motivoCancelacion		INT
	,@id_tipoCancelacion		INT
	,@descripcionCancelacion	NVARCHAR(1000)
AS
BEGIN	
	BEGIN TRY
	 BEGIN TRANSACTION
	DECLARE @fecha	DATETIME
	DECLARE @porcentajeMonedero MONEY
	DECLARE @pagoBoleto MONEY
	DECLARE @newMonedero MONEY
	DECLARE @IDCliente NVARCHAR(100)
    DECLARE @id_boleto NVARCHAR(100)	
	DECLARE @id_ventadetalle NVARCHAR(100)

	SET @fecha = dbo.fnGetNewDate()
	DECLARE BoletosInfo CURSOR FOR SELECT tb.id_boleto, vd.id_ventadetalle FROM tbl_Boletos AS tb JOIN tbl_VentaDetalle AS vd ON tb.id_boleto = vd.id_boleto JOIN tbl_Venta AS v ON v.id_venta = vd.id_venta WHERE vd.activo = 1 AND tb.activo = 1 AND vd.id_venta = @id_venta
	OPEN BoletosInfo
	FETCH NEXT FROM BoletosInfo INTO @id_boleto, @id_ventadetalle
	WHILE @@fetch_status = 0
	BEGIN
	
		   	SET @porcentajeMonedero = (SELECT porcentaje_puntos FROM tbl_CatSucursales JOIN tbl_CatUsuarioXSuc ON tbl_CatSucursales.id_sucursal = tbl_CatUsuarioXSuc.id_sucursal WHERE Id_U = @usuario)	
			IF(EXISTS( SELECT id_ventadetalle FROM tbl_VentaDetalle JOIN tbl_Boletos ON tbl_VentaDetalle.id_boleto = tbl_Boletos.id_boleto WHERE tbl_Boletos.id_boleto = @id_boleto AND (tbl_Boletos.id_status = 2 OR tbl_Boletos.id_status = 3)))
			BEGIN
			     SET @pagoBoleto = (SELECT pago1 + pago2 FROM tbl_VentaDetalle JOIN tbl_Boletos ON tbl_VentaDetalle.id_boleto = tbl_Boletos.id_boleto WHERE tbl_Boletos.id_boleto = @id_boleto AND (tbl_Boletos.id_status = 2 OR tbl_Boletos.id_status = 3)) 
			END
			ELSE 
			BEGIN
			   SET @pagoBoleto = (0)
			END
			SET @newMonedero = (@pagoBoleto * @porcentajeMonedero)
			SET @IDCliente = (SELECT id_cliente FROM tbl_Venta JOIN tbl_VentaDetalle ON tbl_Venta.id_Venta = tbl_VentaDetalle.id_Venta JOIN tbl_Boletos ON tbl_VentaDetalle.id_boleto = tbl_Boletos.id_boleto WHERE tbl_Boletos.id_boleto = @id_boleto)	

			-- Cancelar el boleto y regresar su status a disponible
			UPDATE	
				tbl_Boletos
			SET
				activo = 0,
				id_status = @id_status,
				usuupd = @usuario,
				fecupd = @fecha
			WHERE 
				id_boleto = @id_boleto
			-- Cancelar el registro en Venta detalle
			UPDATE 
				tbl_VentaDetalle
			SET
				activo = 0,
				usuupd = @usuario,
				fecupd = @fecha
			WHERE
				id_ventadetalle = @id_ventadetalle

			-- Cancelar algun posible descuento
			UPDATE 
				tbl_VentaDetalleDescuento
			SET
				activo = 0,
				usuupd = @usuario,
				fecupd = @fecha
			WHERE 
				id_ventadetalle = @id_ventadetalle


			-- Obtener datos para ingresar en venta detalle
		    --DECLARE @id_venta NVARCHAR(100)
				DECLARE @id_sucursal	NVARCHAR(100)

				SELECT 
					--@id_venta = id_venta,
					@id_sucursal = id_sucursal
				FROM
					tbl_VentaDetalle
				WHERE
					id_ventadetalle = @id_ventadetalle

			-- Si es tipo 1, agregar el nuevo dato			
			IF(@tipoCancelacion = 1)
			BEGIN
			-- Comparar si ya se ha pagado algo del boleto

			--Obtener Monto por cancelacion de boleto
				DECLARE @monto		MONEY
				DECLARE @iva		MONEY
				DECLARE @porc_iva	MONEY
				
				SELECT 
					@monto = cs.monto_cancelacion,
					@porc_iva = cs.porcentaje_iva
				FROM
					tbl_CatSucursales as cs
				WHERE	
					id_sucursal = @id_sucursal

			-- Calcular el IVA 
				--SET @iva = (@monto * @porc_iva) / (100 + @porc_iva)
				
			 --Insertar dato en Venta detalle

			 	DECLARE @cobroCancelaciones		MONEY = 0.0 
				DECLARE @retornoCancelaciones	MONEY = 0.0

				IF(@pagoBoleto > 0)
				BEGIN
					UPDATE 
						tbl_VentaDetalle
					SET
						cancelacion = (SELECT ISNULL(MAX(monto_cancelacion),0) FROM tbl_CatSucursales)
					WHERE
						id_ventadetalle = @id_ventadetalle

					INSERT INTO tbl_VentaDetalle (
							id_ventadetalle,
							id_sucursal,
							id_venta,
							id_boleto,
							cantidad_venta,
							costo,
							precio,
							porcentaje_desc,
							porcentaje_iva,
							descuento,
							iva, 
							usuins,
							fecins,
							usuupd,
							fecupd,
							activo,
							observaciones)
						VALUES(
							newid(),
							@id_sucursal,
							@id_venta,
							'',
							1,
							@monto,
							@monto,
							0,
							@porc_iva,
							0,
							0,
							@usuario,
							@fecha,
							@usuario,
							@fecha,
							1,
							'Cancelación de boleto')

					SET @cobroCancelaciones = @monto
					SET @retornoCancelaciones = @pagoBoleto - @monto
				END
				
				UPDATE [dbo].[tbl_Venta]
				SET
					cobroCancelacion =  ISNULL(cobroCancelacion,0) + @cobroCancelaciones,
					retornoCancelacion = ISNULL(retornoCancelacion,0) + @retornoCancelaciones
				WHERE id_venta = @id_venta

			END
			
			-- Actualizar montos en tbl_Venta
			DECLARE @sum_costo		MONEY
			DECLARE @sum_precio		MONEY
			DECLARE @sum_iva		MONEY			
			DECLARE @sum_descuento	MONEY
			DECLARE @sum_pagos		MONEY
			SELECT 
				@sum_costo = isnull(SUM(costo), 0),
				@sum_precio = isnull(SUM(precio), 0),
				@sum_iva = isnull(SUM(iva), 0),
				@sum_descuento = isnull(SUM(descuento),0),
				@sum_pagos = isnull(SUM(pago1),0) + isnull(SUM(pago2),0)
			FROM 
				tbl_VentaDetalle as vd
			WHERE
				id_venta = @id_venta
				AND vd.activo = 1 AND vd.id_boleto != '' 

			DECLARE @costoBoleto  MONEY

			SELECT 
				@costoBoleto = isnull(costo, 0)
			FROM 
				tbl_VentaDetalle 
			WHERE
				[id_ventadetalle] = @id_ventadetalle


			UPDATE 
				tbl_Venta
			SET
				importe = @sum_precio,
				iva = @sum_iva,
				descuento = @sum_descuento,
				total = (@sum_costo + @sum_iva - @sum_descuento),
				pendiente = (@sum_costo + @sum_iva - @sum_descuento) - @sum_pagos
			WHERE
				id_venta = @id_venta

			-- Actualizar VentaPagos
			
			UPDATE 
				tbl_VentaPagos
			SET	
				monto = (@sum_costo + @sum_iva - @sum_descuento)
			WHERE 
				id_venta = @id_venta
				

			UPDATE tbl_CatCredenciales
			SET 
			  monedero = monedero - @newMonedero
			WHERE id_cliente = @IDCliente

			INSERT INTO tbl_VentaCajas
			   (IDVentasCajas
			   ,IDCajaXSucursal
			   ,IDStatus
			   ,IDGenerico
			   ,usuins
			   ,fecins
			   ,usuupd
			   ,fecupd
			   ,activo)
			VALUES
			   (NEWID()
			   ,@id_caja
			   ,6
			   ,@id_ventadetalle
			   ,@USUARIO
			   ,@fecha
			   ,@USUARIO
			   ,@fecha
			   ,1)
	
			INSERT INTO tbl_CancelacionesTransferenciasBoletos
			   (id_boleto
			   ,id_motivoCancelacionTransferencia
			   ,id_tipo
			   ,id_caja
			   ,motivo
			   ,usuins
			   ,fecins
			   ,usuupd
			   ,fecupd
			   ,activo)
		 VALUES
			   (@id_boleto
			   ,@id_motivoCancelacion
			   ,@id_tipoCancelacion
			   ,@id_caja
			   ,@descripcionCancelacion
    		   ,@USUARIO
			   ,@fecha
			   ,@USUARIO
			   ,@fecha
			   ,1)
		FETCH NEXT FROM BoletosInfo INTO @id_boleto, @id_ventadetalle
 	 END
	 CLOSE BoletosInfo
	 DEALLOCATE BoletosInfo

	 		UPDATE 
				tbl_Venta
			SET
				activo = 0
			WHERE
				id_venta = @id_venta

	 IF @@ERROR <> 0 
      BEGIN
	    SELECT -1
		ROLLBACK TRANSACTION
		RETURN
	  END
	 COMMIT TRANSACTION


	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------
	END CATCH
END



















GO
/****** Object:  StoredProcedure [dbo].[CancelacionGrupal2_Boletos_sp]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[CancelacionGrupal2_Boletos_sp]
	 @tipoCancelacion			INT
	,@id_venta					NVARCHAR(100)
	,@id_status					INT
	,@id_caja					NVARCHAR(100)
	,@usuario					NVARCHAR(100)
	,@id_motivoCancelacion		INT
	,@id_tipoCancelacion		INT
	,@descripcionCancelacion	NVARCHAR(1000)
AS
BEGIN	
	BEGIN TRY
	 BEGIN TRANSACTION
	DECLARE @fecha	DATETIME
	DECLARE @porcentajeMonedero MONEY
	DECLARE @pagoBoleto MONEY
	DECLARE @newMonedero MONEY
	DECLARE @IDCliente NVARCHAR(100)
    DECLARE @id_boleto NVARCHAR(100)	
	DECLARE @id_ventadetalle NVARCHAR(100)

	SET @fecha = dbo.fnGetNewDate()


	ALTER TABLE #TablaBoletosTemp 
	(id_boleto NVARCHAR(100) COLLATE SQL_Latin1_General_CP1_CI_AS, 
	id_ventaDetallle NVARCHAR(100) COLLATE SQL_Latin1_General_CP1_CI_AS, 
	totalPagar MONEY, 
	PRIMARY KEY(id_boleto,id_ventaDetallle))


	INSERT INTO #TablaBoletosTemp
		(id_boleto
		,id_ventaDetallle
		,totalPagar)
	SELECT tb.id_boleto
		  ,vd.id_ventadetalle
		  ,ISNULL((pago1 + pago2),0.0) 
	FROM tbl_Boletos AS tb JOIN tbl_VentaDetalle AS vd 
	ON tb.id_boleto = vd.id_boleto 
	JOIN tbl_Venta AS v 
	ON v.id_venta = vd.id_venta 
	WHERE vd.activo = 1 
	AND tb.activo = 1 
	AND vd.id_venta = @id_venta
	AND(tb.id_status = 2 OR tb.id_status = 3)

   	SET @porcentajeMonedero = (SELECT porcentaje_puntos FROM tbl_CatSucursales JOIN tbl_CatUsuarioXSuc ON tbl_CatSucursales.id_sucursal = tbl_CatUsuarioXSuc.id_sucursal WHERE Id_U = @usuario)	
	SET @pagoBoleto = (SELECT SUM(totalPagar) FROM #TablaBoletosTemp) 
	SET @newMonedero = (@pagoBoleto * @porcentajeMonedero)
	SET @IDCliente = (SELECT id_cliente FROM tbl_Venta JOIN tbl_VentaDetalle ON tbl_Venta.id_Venta = tbl_VentaDetalle.id_Venta JOIN tbl_Boletos ON tbl_VentaDetalle.id_boleto = tbl_Boletos.id_boleto WHERE tbl_Boletos.id_boleto = @id_boleto)	

	-- Cancelar los boletos y regresar su status a disponible
	UPDATE	
		tbl_Boletos
	SET
		activo = 0,
		id_status = @id_status,
		usuupd = @usuario,
		fecupd = @fecha
	FROM tbl_Boletos JOIN #TablaBoletosTemp AS TablaBoletosTemp
	ON tbl_Boletos.id_boleto = TablaBoletosTemp.id_boleto

	-- Cancelar los registros en Venta detalle
	UPDATE 
		tbl_VentaDetalle
	SET
		activo = 0,
		usuupd = @usuario,
		fecupd = @fecha
	FROM tbl_VentaDetalle JOIN #TablaBoletosTemp AS TablaBoletosTemp
	ON tbl_VentaDetalle.id_ventadetalle = TablaBoletosTemp.id_ventaDetallle

	-- Cancelar posibles descuento
	UPDATE 
		tbl_VentaDetalleDescuento
	SET
		activo = 0,
		usuupd = @usuario,
		fecupd = @fecha
	FROM tbl_VentaDetalle JOIN #TablaBoletosTemp AS TablaBoletosTemp
	ON tbl_VentaDetalle.id_ventadetalle = TablaBoletosTemp.id_ventaDetallle


	-- Obtener datos para ingresar en venta detalle
	DECLARE @id_sucursal	NVARCHAR(100)
	SELECT TOP 1
		@id_sucursal = id_sucursal
	FROM
		tbl_VentaDetalle
	WHERE
		id_venta = @id_venta

	-- Si es tipo 1, agregar el nuevo dato			
	IF(@tipoCancelacion = 1)
	BEGIN
	-- Comparar si ya se ha pagado algo del boleto
	--Obtener Monto por cancelacion de boleto
		DECLARE @monto		MONEY
		DECLARE @iva		MONEY
		DECLARE @porc_iva	MONEY
				
		SELECT 
			@monto = cs.monto_cancelacion,
			@porc_iva = cs.porcentaje_iva
		FROM
			tbl_CatSucursales as cs
		WHERE	
			id_sucursal = @id_sucursal

		-- Calcular el IVA 
		--SET @iva = (@monto * @porc_iva) / (100 + @porc_iva)
		--Insertar dato en Venta detalle

		DECLARE @cobroCancelaciones		MONEY = 0.0 
		DECLARE @retornoCancelaciones	MONEY = 0.0

		IF(@pagoBoleto > 0)
		BEGIN
			UPDATE 
				tbl_VentaDetalle
			SET
				cancelacion = (SELECT ISNULL(MAX(monto_cancelacion),0) FROM tbl_CatSucursales)
			FROM tbl_VentaDetalle JOIN #TablaBoletosTemp AS TablaBoletosTemp
			ON tbl_VentaDetalle.id_ventadetalle = TablaBoletosTemp.id_ventaDetallle
			WHERE TablaBoletosTemp.totalPagar > 0

			INSERT INTO tbl_VentaDetalle (
					id_ventadetalle,
					id_sucursal,
					id_venta,
					id_boleto,
					cantidad_venta,
					costo,
					precio,
					porcentaje_desc,
					porcentaje_iva,
					descuento,
					iva, 
					usuins,
					fecins,
					usuupd,
					fecupd,
					activo,
					observaciones)
			SELECT 
					NEWID(),
					@id_sucursal,
					@id_venta,
					'',
					1,
					@monto,
					@monto,
					0,
					@porc_iva,
					0,
					0,
					@usuario,
					@fecha,
					@usuario,
					@fecha,
					1,
					'Cancelación de boleto' 
			FROM #TablaBoletosTemp AS TablaBoletosTemp
			WHERE TablaBoletosTemp.totalPagar > 0

			
			SET @cobroCancelaciones = (@monto * ISNULL((SELECT COUNT(id_boleto) FROM #TablaBoletosTemp AS TablaBoletosTemp WHERE TablaBoletosTemp.totalPagar > 0),0))
			SET @retornoCancelaciones = @pagoBoleto - @monto
		END
				
		UPDATE [dbo].[tbl_Venta]
		SET
			cobroCancelacion =  ISNULL(cobroCancelacion,0) + @cobroCancelaciones,
			retornoCancelacion = ISNULL(retornoCancelacion,0) + @retornoCancelaciones
		WHERE id_venta = @id_venta
	END
	-- Actualizar montos en tbl_Venta
	DECLARE @sum_costo		MONEY
	DECLARE @sum_precio		MONEY
	DECLARE @sum_iva		MONEY			
	DECLARE @sum_descuento	MONEY
	DECLARE @sum_pagos		MONEY
	SELECT 
		@sum_costo = isnull(SUM(costo), 0),
		@sum_precio = isnull(SUM(precio), 0),
		@sum_iva = isnull(SUM(iva), 0),
		@sum_descuento = isnull(SUM(descuento),0),
		@sum_pagos = isnull(SUM(pago1),0) + isnull(SUM(pago2),0)
	FROM 
		tbl_VentaDetalle as vd
	WHERE
		id_venta = @id_venta
		AND vd.activo = 1 AND vd.id_boleto != '' 

	DECLARE @costoBoleto  MONEY
	SELECT 
		@costoBoleto = isnull(costo, 0)
	FROM 
		tbl_VentaDetalle 
	WHERE
		[id_ventadetalle] = @id_ventadetalle


	UPDATE 
		tbl_Venta
	SET
		importe = @sum_precio,
		iva = @sum_iva,
		descuento = @sum_descuento,
		total = (@sum_costo + @sum_iva - @sum_descuento),
		pendiente = (@sum_costo + @sum_iva - @sum_descuento) - @sum_pagos
	WHERE
		id_venta = @id_venta

	-- Actualizar VentaPagos			
	UPDATE 
		tbl_VentaPagos
	SET	
		monto = (@sum_costo + @sum_iva - @sum_descuento)
	WHERE 
		id_venta = @id_venta
				
	UPDATE tbl_CatCredenciales
	SET 
		monedero = monedero - @newMonedero
	WHERE id_cliente = @IDCliente

	INSERT INTO tbl_VentaCajas
		(IDVentasCajas
		,IDCajaXSucursal
		,IDStatus
		,IDGenerico
		,usuins
		,fecins
		,usuupd
		,fecupd
		,activo)
	SELECT
		NEWID()
		,@id_caja
		,6
		,id_ventaDetallle
		,@USUARIO
		,@fecha
		,@USUARIO
		,@fecha
		,1
	FROM #TablaBoletosTemp AS TablaBoletosTemp 
	
	INSERT INTO tbl_CancelacionesTransferenciasBoletos
			(id_boleto
			,id_motivoCancelacionTransferencia
			,id_tipo
			,id_caja
			,motivo
			,usuins
			,fecins
			,usuupd
			,fecupd
			,activo)
		SELECT
			id_boleto
			,@id_motivoCancelacion
			,@id_tipoCancelacion
			,@id_caja
			,@descripcionCancelacion
    		,@USUARIO
			,@fecha
			,@USUARIO
			,@fecha
			,1
		FROM #TablaBoletosTemp AS TablaBoletosTemp 

	 	UPDATE 
			tbl_Venta
		SET
			activo = 0
		WHERE
			id_venta = @id_venta

	 IF @@ERROR <> 0 
      BEGIN
	    SELECT -1
		ROLLBACK TRANSACTION
		RETURN
	  END
	 COMMIT TRANSACTION


	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------
	END CATCH
END



















GO
/****** Object:  StoredProcedure [dbo].[CatBancos_Combo_sp]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CatBancos_Combo_sp]		
AS
BEGIN
	BEGIN TRY
		SET NOCOUNT OFF
		-- ------------------------ --
		-- Declaración de variables --
		-- ------------------------ --
		DECLARE
			@MensajeError	VARCHAR(1000)
			SELECT 
				[id_banco],
				[razonsocial] 
			FROM 
				[dbo].[tbl_CatBancos]
			WHERE 
				[activo] = 1
		UNION
			SELECT 0 as id_banco, ' -- Seleccionar -- ' as razonsocial
		ORDER BY [razonsocial]
	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		SELECT @MensajeError	= ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------
	END CATCH
END



GO
/****** Object:  StoredProcedure [dbo].[CatBoletos_Modificar_sp]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CatBoletos_Modificar_sp]
			@id_boleto			NVARCHAR(100),
			@id_caja			NVARCHAR(100),
			@Nombre				NVARCHAR(300),
			@fechaNacimiento	DATE,
			@numeroTelefonico	NVARCHAR(50),
			@usuario			NVARCHAR(100)
AS
BEGIN
	BEGIN TRANSACTION
	BEGIN TRY
		SET NOCOUNT ON
		DECLARE @NombreAnterior NVARCHAR(300) = '',
				@IDUsuarioAnt	NVARCHAR(100) = 'System',
				@FechaAnt		DATETIME = [dbo].[fnGetNewDate]()
		DECLARE @FechaSys		DATETIME = @FechaAnt

		SELECT  @NombreAnterior = ISNULL([NombrePersona], ''),  
				@IDUsuarioAnt = ISNULL([usuupd], 'System'),
				@FechaAnt = ISNULL([fecupd], @FechaSys)

		FROM	[dbo].[tbl_Boletos]
		WHERE	[id_boleto] = @id_boleto
		
        UPDATE tbl_Boletos
		SET 
		      NombrePersona = @Nombre,
			  fechaNacimiento = @fechaNacimiento,
			  numeroTelefono = @numeroTelefonico,
			  fecupd = @FechaSys,
			  usuupd = @usuario
		WHERE id_boleto = @id_boleto
			
		INSERT INTO [dbo].[tbl_LogNombreBoletos]
           ([id_logBoleto]
		   ,[id_caja]
           ,[id_boleto]
           ,[nombreAnterior]
           ,[fecins]
           ,[usuins]
           ,[nuevoNombre]
           ,[fecupd]
           ,[usuupd])
		VALUES
           (NEWID()
		   ,@id_caja
           ,@id_boleto
           ,@nombreAnterior
           ,@FechaAnt
           ,@IDUsuarioAnt
           ,@Nombre
           ,@FechaSys
           ,@usuario)
	COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		ROLLBACK TRANSACTION
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END

































GO
/****** Object:  StoredProcedure [dbo].[CatBoletosApartadosLiberar_Modificar_sp]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




ALTER PROCEDURE [dbo].[CatBoletosApartadosLiberar_Modificar_sp]
                     @DatosBoletos  Boletos READONLY,
   					 @Id_U         NVARCHAR(100)     
AS
BEGIN
	BEGIN TRY

		SET NOCOUNT ON
		
       	DECLARE @fecha	DATETIME
    	SET @fecha = dbo.fnGetNewDate()
		
		UPDATE tbl_Boletos
	     SET 
		    activo = 0,
			usuupd = @Id_U,
			fecupd = @fecha
		FROM tbl_Boletos JOIN @DatosBoletos as boletos
		ON tbl_Boletos.id_boleto = boletos.IDBoleto
		WHERE tbl_Boletos.id_viaje = boletos.IDViaje 
		AND tbl_Boletos.asiento = boletos.Asiento 
		AND tbl_Boletos.id_disenioDatos = boletos.IDCamionDiseño 
		AND tbl_Boletos.fecha_salida = boletos.FechaSalida 
		AND tbl_Boletos.hora_salida = boletos.HoraSalida 
		AND tbl_Boletos.id_boleto = boletos.IDBoleto 
		AND tbl_Boletos.id_status = 1
		AND tbl_Boletos.activo = 1 
		
	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------
	END CATCH
END



































GO
/****** Object:  StoredProcedure [dbo].[CatBoletosApartar_Insertar_sp]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





ALTER PROCEDURE [dbo].[CatBoletosApartar_Insertar_sp]
			    @IDViaje	         NVARCHAR(100) 	
			   ,@Asiento             INT
			   ,@IDDiseñoDatos       NVARCHAR(100)
			   ,@FechaSalida         DATE
			   ,@HoraSalida          NVARCHAR(100)
			   ,@OrdenOrigen         INT
			   ,@OrdenDestino        INT  
			   ,@Id_u                NVARCHAR(100)
			   ,@macaddress			 NVARCHAR(20)
AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON

	DECLARE @IDBOLETO NVARCHAR(100)
	SET @IDBOLETO = NEWID() 
    DECLARE @AUX INT;
	IF((SELECT COUNT(*) FROM tbl_Boletos WHERE id_viaje = @IDViaje AND fecha_salida = @FechaSalida AND hora_salida = @HoraSalida AND asiento = @ASIENTO  AND activo = 1) = 0)
	BEGIN
       SET @AUX = 0
	END
	ELSE
	BEGIN
		SET @AUX = 0
		DECLARE @IDSTATUS_ INT
		DECLARE @ORDENORIGEN_ INT
		DECLARE @ORDENDESTINO_ INT
	    DECLARE tl CURSOR LOCAL FOR SELECT id_status, OrdenOrigenTerminal, OrdenDestinoTerminal FROM tbl_Boletos WHERE id_viaje = @IDViaje AND fecha_salida = @FechaSalida AND hora_salida = @HoraSalida AND asiento = @ASIENTO AND activo = 1
		OPEN tl
		FETCH tl INTO @IDSTATUS_, @ORDENORIGEN_, @ORDENDESTINO_
		WHILE(@@fetch_status=0)
		BEGIN

	   IF( NOT (((@OrdenOrigen < @ORDENORIGEN_) AND (@OrdenDestino <= @ORDENORIGEN_ )) OR  ((@OrdenOrigen >= @ORDENDESTINO_) AND (@OrdenDestino > @ORDENDESTINO_))))
		BEGIN
			IF(@AUX = 0)
			  SET @AUX = 1
		END
		FETCH tl INTO @IDSTATUS_, @ORDENORIGEN_, @ORDENDESTINO_
		END
		CLOSE tl
		DEALLOCATE tl
	END

		IF(@AUX = 0)
		BEGIN
--		BEGIN TRANSACTION

		DECLARE @FECHA DATETIME 
		SET @FECHA = dbo.fnGetNewDate()
		
		DECLARE  @FOLIOBOLETOS   NVARCHAR(20)
		SET @FOLIOBOLETOS = ( SELECT ISNULL(MAX(right(CodigoBarra,6)),'000000') 
							FROM tbl_Boletos 
							WHERE YEAR(fecins) = YEAR(@FECHA) 
							AND MONTH(fecins) = MONTH(@FECHA)
							AND DAY(fecins) = DAY(@FECHA))
		SET @FOLIOBOLETOS = @FOLIOBOLETOS + 1
		SET @FOLIOBOLETOS = CONVERT(CHAR(4),YEAR(@FECHA)) + RIGHT('0' + RTRIM(MONTH(@FECHA)), 2) + RIGHT('0' + RTRIM(DAY(@FECHA)), 2) +RIGHT('000000'+ @FOLIOBOLETOS, 6) 

		DECLARE @cobro BIT = (SELECT cobro FROM tbl_CatCajas WHERE macAddress = @macaddress)


		INSERT INTO tbl_Boletos
			(id_boleto
			,CodigoBarra
			,id_viaje
			,asiento
			,id_disenioDatos
			,id_status
			,fecha_salida
			,hora_salida
			,OrdenOrigenTerminal
			,OrdenDestinoTerminal
			,usuins
			,fecins
			,usuupd
			,fecupd
			,activo
			,activoCobro
			,asistencia)
		VALUES
			(@IDBOLETO
			,@FOLIOBOLETOS
			,@IDViaje
			,@Asiento
			,@IDDiseñoDatos
			,1
			,@FechaSalida
			,@HoraSalida
			,@OrdenOrigen
			,@OrdenDestino
			,@Id_u
			,@FECHA
			,@Id_u
			,@FECHA
			,1
			,@cobro
			,0)

		IF(@cobro = 1)
			SET @cobro = 0
		ELSE IF(@cobro = 0) 
		    SET @cobro = 1

		EXEC CatMacCobro_Modificar @macaddress, @cobro

--			IF @@ERROR <> 0 
--			BEGIN
--				SELECT 1
--				ROLLBACK TRANSACTION
--				RETURN
--			END
--			COMMIT TRANSACTION

			SELECT @IDBOLETO
		END
		ELSE IF(@AUX = 1)
		BEGIN 
			SELECT 1
		END

	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END







































GO
/****** Object:  StoredProcedure [dbo].[CatCaja_Combo_sp]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[CatCaja_Combo_sp]
AS
BEGIN
	BEGIN TRY

		SET NOCOUNT ON

			SELECT 
				id_caja as id_cajaCat, 
				descripcion as cajaCat,
				fecins
			FROM tbl_CatCajas WHERE activo = 1 AND macAddress = ''
			UNION
			SELECT 
				'0' AS 'id_cajaCat', 
				'-- Seleccionar --' AS 'cajaCat' , 
				CONVERT(DATETIME, '01/01/2000') AS 'fecins' 
			ORDER BY fecins

	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------
	END CATCH
END
































GO
/****** Object:  StoredProcedure [dbo].[CatCajaOcupadas_Combo_sp]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER PROCEDURE [dbo].[CatCajaOcupadas_Combo_sp]
AS
BEGIN
	BEGIN TRY

		SET NOCOUNT ON

			SELECT 
				id_caja as id_cajaCat, 
				descripcion as cajaCat,
				descripcion + '( ' + descripcion2 + ' )'  as cajaCatCompleto,
				fecins
			FROM tbl_CatCajas WHERE activo = 1 AND macAddress != ''
			UNION
			SELECT 
				'0' AS 'id_cajaCat', 
				'-- Seleccionar --' AS 'cajaCat',
				'-- Seleccionar --' AS 'cajaCatCompleto',
				 CONVERT(DATETIME, '01/01/2000') AS 'fecins' 
		     ORDER BY fecins

	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------
	END CATCH
END

































GO
/****** Object:  StoredProcedure [dbo].[CatCamiones_Combo_sp]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[CatCamiones_Combo_sp]
		@Activo			INT --Activo = 1		
AS
BEGIN
	BEGIN TRY

		SET NOCOUNT ON

		DECLARE @MensajeError	VARCHAR(1000)

			SELECT 
			cc.id_camion,
			cc.descripcion,			
			cm.marca,			
			cs.submarca,
			ct.tipoCamion,
			cc.numcamion,
			cc.caracteristicas,
			cd.nombre,			
			cc.id_marca,
			cc.id_submarca,
			cc.id_tipocamion,
			cc.id_disenioCamion
		FROM
			tbl_CatCamiones as cc
			JOIN tbl_CatDisenio as cd ON cc.id_disenioCamion = cd.id_disenioCamion
			JOIN tbl_CatMarcas as cm ON cc.id_marca = cm.id_marca
			JOIN tbl_CatSubMarcas as cs ON cc.id_submarca = cs.id_submarca
			JOIN tbl_CatTipoCamion as ct ON cc.id_tipocamion = ct.id_tipoCamion
		WHERE
			cc.activo = 1

		UNION
			SELECT 
				'' AS 'id_camion', 
				'-- Seleccionar --' AS 'descripcion',
				'' as marca,
				'' as submarca,
				'' as tipoCamion,
				'' as numcamion,
				'' as caracteristicas,
				'' as nombre,
				0  as id_marca,
				0  as id_submarca,
				0  as id_tipocamion,
				'' as id_disenioCamion

	ORDER BY cc.descripcion
	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		SELECT @MensajeError	= ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END


























GO
/****** Object:  StoredProcedure [dbo].[CatChofer_Consulta_sp]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[CatChofer_Consulta_sp]		

AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON
		
				SELECT id_chofer as IDChofer
				      ,nombre + ' ' + apellidopaterno + ' ' + apellidomaterno as NombreCompleto
					  ,nombre as Nombre
					  ,apellidopaterno as ApellidoPaterno
					  ,apellidomaterno as ApellidoMaterno
					  ,curp as Curp
					  ,CAST(fecNacimiento AS date)  as FechaNacimiento
					  ,observaciones as Observaciones
				  FROM tbl_CatChoferes
				  WHERE activo = 1
				  ORDER BY nombre + ' ' + apellidopaterno + ' ' + apellidomaterno

	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END

































GO
/****** Object:  StoredProcedure [dbo].[CatChofer_Eliminar_sp]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[CatChofer_Eliminar_sp]		
           @IDChofer     NVARCHAR(100)
AS
BEGIN
	BEGIN TRY

		SET NOCOUNT ON

		UPDATE tbl_CatChoferes SET  activo = 0 WHERE tbl_CatChoferes.id_chofer = @IDChofer
		SELECT 0
	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END

































GO
/****** Object:  StoredProcedure [dbo].[CatChofer_Insertar_sp]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER PROCEDURE [dbo].[CatChofer_Insertar_sp]	
            @nombre				NVARCHAR(30)
		   ,@apePat				NVARCHAR(30)
		   ,@apeMat				NVARCHAR(30)	
		   ,@curp				NVARCHAR(18)
		   ,@fechaNacimiento	DATETIME
		   ,@observaciones      NVARCHAR(MAX)
		   ,@Id_U               NVARCHAR(100)               
AS
BEGIN
	BEGIN TRY

		SET NOCOUNT ON
		
	    DECLARE @fecha	DATETIME
	    SET @fecha = dbo.fnGetNewDate()

		INSERT INTO tbl_CatChoferes
				   (id_chofer
				   ,nombre
				   ,apellidopaterno
				   ,apellidomaterno
				   ,curp
				   ,fecNacimiento
				   ,observaciones
				   ,usuins
				   ,fecins
				   ,usuupd
				   ,fecupd
				   ,activo)
			 VALUES
				   (NEWID()
				   ,@nombre
				   ,@apePat
				   ,@apeMat
				   ,@curp
				   ,@fechaNacimiento
				   ,@observaciones
				   ,@Id_U
				   ,@fecha
				   ,@Id_U
				   ,@fecha
				   ,1)


	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END


































GO
/****** Object:  StoredProcedure [dbo].[CatChofer_Modificar_sp]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER PROCEDURE [dbo].[CatChofer_Modificar_sp]	
            @IDChofer           NVARCHAR(100)
           ,@nombre				NVARCHAR(30)
		   ,@apePat				NVARCHAR(30)
		   ,@apeMat				NVARCHAR(30)	
		   ,@curp				NVARCHAR(18)
		   ,@fechaNacimiento	DATETIME
		   ,@observaciones      NVARCHAR(MAX)
		   ,@Id_U               NVARCHAR(100)               
AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON

		DECLARE @fecha	DATETIME
	    SET @fecha = dbo.fnGetNewDate()

		
		UPDATE tbl_CatChoferes
		   SET 
			   nombre = @nombre
			  ,apellidopaterno = @apePat
			  ,apellidomaterno = @apeMat
			  ,curp = @curp
			  ,fecNacimiento = @fechaNacimiento
			  ,observaciones = @observaciones
			  ,usuupd = @Id_U
			  ,fecupd = @fecha
		 WHERE id_chofer = @IDChofer


	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END


































GO
/****** Object:  StoredProcedure [dbo].[CatChoferes_Combo_sp]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[CatChoferes_Combo_sp]
AS
BEGIN
	BEGIN TRY

		SET NOCOUNT ON

			SELECT 
					id_chofer,  
					tbl_CatChoferes.nombre + ' ' + tbl_CatChoferes.apellidopaterno + ' ' + tbl_CatChoferes.apellidomaterno AS Descripcion 
			FROM tbl_CatChoferes WHERE activo = 1
			UNION
			SELECT 
					'' AS 'id_chofer', 
					'-- Seleccionar --' AS 'Descripcion' 
			ORDER BY Descripcion

	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------
	END CATCH
END































GO
/****** Object:  StoredProcedure [dbo].[CatCliente_Consulta_sp]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[CatCliente_Consulta_sp]		

AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON

		SELECT 
			   tbl_CatClientes.id_cliente as IDCliente
			  ,nombre as Nombre
			  ,apePat as ApePat
			  ,apeMat as ApeMat
			  , nombre + ' ' + apePat + ' ' + apeMat as NombreCompleto 
			  ,CorreoElectronico
			  ,tbl_CatMunicipios.id_municipio as IDMunicipio
			  ,tbl_CatMunicipios.descripcion as Municipio
			  ,tbl_CatEstados.id_estado as IDEstado
			  ,tbl_CatEstados.descripcion as Estado
			  ,tbl_CatPaises.id_pais as IDPais
			  ,tbl_CatPaises.descripcion as Pais
			  ,colonia as Colonia
			  ,CAST(fechaNacimiento AS date) AS FechaNacimiento
			  ,tbl_CatOcupacion.id_ocupacion as IDOcupacion
			  ,tbl_CatOcupacion.ocupacion as Ocupacion
			  ,tbl_CatEstadoCivil.id_estadoCivil as IDEstadoCivil
			  ,tbl_CatEstadoCivil.estadoCivil as EstadoCivil
			  ,tbl_CatGenero.id_genero as IDGenero
			  ,tbl_CatGenero.genero as Genero
			  ,curp as Curp
			  ,tbl_CatCredenciales.id_codigoEab as IDCodigoEab
			  ,tbl_CatCredenciales.id_tipocredencial
			  ,tbl_CatCredenciales.puntos
			  ,tbl_CatCredenciales.monedero as Monedero
			  ,tbl_CatCredenciales.id_codigoEab
		  FROM tbl_CatClientes JOIN tbl_CatMunicipios
		  ON tbl_CatClientes.id_municipio = tbl_CatMunicipios.id_municipio AND tbl_CatClientes.id_estado = tbl_CatMunicipios.id_estado AND tbl_CatClientes.id_pais = tbl_CatMunicipios.id_pais
		  JOIN tbl_CatEstados
		  ON tbl_CatClientes.id_estado = tbl_CatEstados.id_estado
		  JOIN tbl_CatPaises
		  ON tbl_CatClientes.id_pais = tbl_CatPaises.id_pais
		  JOIN tbl_CatOcupacion
		  ON tbl_CatClientes.id_ocupacion = tbl_CatOcupacion.id_ocupacion
		  JOIN tbl_CatEstadoCivil 
		  ON tbl_CatClientes.id_estadoCivil = tbl_CatEstadoCivil.id_estadoCivil
		  JOIN tbl_CatCredenciales
		  ON tbl_CatClientes.id_cliente = tbl_CatCredenciales.id_cliente
		  JOIN tbl_CatGenero
		  ON tbl_CatGenero.id_genero = tbl_CatClientes.id_genero
		  WHERE tbl_CatClientes.activo = 1
		  ORDER BY nombre + ' ' + apePat + ' ' + apeMat


	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END

































GO
/****** Object:  StoredProcedure [dbo].[CatCliente_Eliminar_sp]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[CatCliente_Eliminar_sp]		
           @IDCliente     NVARCHAR(100)
AS
BEGIN
	BEGIN TRY

		SET NOCOUNT ON

		
		UPDATE tbl_CatClientes 
			SET  activo = 0 
		WHERE tbl_CatClientes.id_cliente = @IDCliente


	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END
































GO
/****** Object:  StoredProcedure [dbo].[CatCliente_Insertar_sp]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER PROCEDURE [dbo].[CatCliente_Insertar_sp]		
		    @nombre				NVARCHAR(30)
		   ,@apePat				NVARCHAR(30)
		   ,@apeMat				NVARCHAR(30)
		   ,@correo				NVARCHAR(150)
		   ,@id_municipio		INT
		   ,@id_estado			INT
		   ,@id_pais			INT
		   ,@colonia			NVARCHAR(70)
		   ,@fechaNacimiento	DATETIME
		   ,@id_ocupacion		INT
		   ,@id_estadoCivil     INT
		   ,@id_genero			INT
		   ,@curp				NVARCHAR(18)
		   ,@id_codigoEab       NVARCHAR(15)
		   ,@Id_U				NVARCHAR(100)
AS
BEGIN
	BEGIN TRY

		SET NOCOUNT ON

		-- ------------------------ --
		-- Declaración de variables --
		-- ------------------------ --
        DECLARE  @IDCLIENTE NVARCHAR (100) = NEWID()
		DECLARE @fecha	DATETIME
	    SET @fecha = dbo.fnGetNewDate()

		INSERT INTO tbl_CatClientes
				   (id_cliente
				   ,nombre
				   ,apePat
				   ,apeMat
				   ,CorreoElectronico
				   ,id_municipio
				   ,id_estado
				   ,id_pais
				   ,colonia
				   ,fechaNacimiento
				   ,id_ocupacion
				   ,id_estadoCivil
				   ,id_genero
				   ,curp
				   ,activo
				   ,usuins
				   ,fecins
				   ,usuupd
				   ,fecupd
				   ,fechaInicio
				   ,Solicitado
				   ,Entregado)
			 VALUES
				   (@IDCLIENTE
				   ,@nombre
				   ,@apePat
				   ,@apeMat
				   ,@correo
				   ,@id_municipio
				   ,@id_estado
				   ,@id_pais
				   ,@colonia
				   ,@fechaNacimiento
				   ,@id_ocupacion
				   ,@id_estadoCivil
				   ,@id_genero
				   ,@curp
				   ,1
				   ,@Id_U
				   ,@fecha
				   ,@Id_U
				   ,@fecha
				   ,@fecha
				   ,1
				   ,0)

		INSERT INTO tbl_CatCredenciales
				   (id_credencial
				   ,id_tipocredencial
				   ,puntos
				   ,monedero
				   ,id_codigoEab
				   ,id_cliente)
			 VALUES
				   (NEWID()
				   ,2
				   ,0
				   ,0
				   ,@id_codigoEab
				   ,@IDCLIENTE)

	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END


































GO
/****** Object:  StoredProcedure [dbo].[CatCliente_Modificar_sp]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER PROCEDURE [dbo].[CatCliente_Modificar_sp]	
            @id_cliente         NVARCHAR(100)	
		   ,@nombre				NVARCHAR(30)
		   ,@apePat				NVARCHAR(30)
		   ,@apeMat				NVARCHAR(30)
		   ,@correo				NVARCHAR(150)
		   ,@id_municipio		INT
		   ,@id_estado			INT
		   ,@id_pais			INT
		   ,@colonia			NVARCHAR(70)
		   ,@fechaNacimiento	DATETIME
		   ,@id_ocupacion		INT
		   ,@id_estadoCivil     INT
		   ,@id_genero			INT
		   ,@curp				NVARCHAR(18)
		   ,@id_codigoEab       NVARCHAR(15)
		   ,@Id_U				NVARCHAR(100)
AS
BEGIN
	BEGIN TRY

		SET NOCOUNT ON

		-- ------------------------ --
		-- Declaración de variables --
		-- ------------------------ --
		DECLARE @fecha	DATETIME
    	SET @fecha = dbo.fnGetNewDate()

		UPDATE tbl_CatClientes
		   SET 
			   nombre = @nombre
			  ,apePat = @apePat
			  ,apeMat = @apeMat
			  ,CorreoElectronico = @correo
			  ,id_municipio = @id_municipio
			  ,id_estado = @id_estado
			  ,id_pais = @id_pais
			  ,colonia = @colonia
			  ,fechaNacimiento = @fechaNacimiento
			  ,id_ocupacion = @id_ocupacion
			  ,id_estadoCivil = @id_estadoCivil
			  ,id_genero = @id_genero
			  ,curp = @curp
			  ,usuupd = @Id_U
			  ,fecupd = @fecha
		 WHERE id_cliente = @id_cliente


		UPDATE tbl_CatCredenciales
		   SET id_codigoEab = @id_codigoEab
	    WHERE id_cliente = @id_cliente

	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END









GO
/****** Object:  StoredProcedure [dbo].[CatClienteBusqueda_Consulta_sp]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[CatClienteBusqueda_Consulta_sp]
             @TipoBusq       INT
            ,@Busqueda         NVARCHAR(300)
AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON
		-- ------------------------ --
		-- Declaración de variables --
		-- ------------------------ --
		IF(@TipoBusq = 1)
		BEGIN
		SELECT 
			   tbl_CatClientes.id_cliente as IDCliente
			  ,nombre as Nombre
			  ,apePat as ApePat
			  ,apeMat as ApeMat
			  , nombre + ' ' + apePat + ' ' + apeMat as NombreCompleto 
			  ,CorreoElectronico
			  ,tbl_CatMunicipios.id_municipio as IDMunicipio
			  ,tbl_CatMunicipios.descripcion as Municipio
			  ,tbl_CatEstados.id_estado as IDEstado
			  ,tbl_CatEstados.descripcion as Estado
			  ,tbl_CatPaises.id_pais as IDPais
			  ,tbl_CatPaises.descripcion as Pais
			  ,colonia as Colonia
			  ,CAST(fechaNacimiento AS date) AS FechaNacimiento
			  ,tbl_CatOcupacion.id_ocupacion as IDOcupacion
			  ,tbl_CatOcupacion.ocupacion as Ocupacion
			  ,tbl_CatEstadoCivil.id_estadoCivil as IDEstadoCivil
			  ,tbl_CatEstadoCivil.estadoCivil as EstadoCivil
			  ,tbl_CatGenero.id_genero as IDGenero
			  ,tbl_CatGenero.genero as Genero
			  ,curp as Curp
			  ,tbl_CatCredenciales.id_codigoEab as IDCodigoEab
			  ,tbl_CatCredenciales.id_tipocredencial
			  ,tbl_CatCredenciales.puntos
			  ,tbl_CatCredenciales.monedero as Monedero
			  ,tbl_CatCredenciales.id_codigoEab
		  FROM tbl_CatClientes JOIN tbl_CatMunicipios
		  ON tbl_CatClientes.id_municipio = tbl_CatMunicipios.id_municipio AND tbl_CatClientes.id_estado = tbl_CatMunicipios.id_estado AND tbl_CatClientes.id_pais = tbl_CatMunicipios.id_pais
		  JOIN tbl_CatEstados
		  ON tbl_CatClientes.id_estado = tbl_CatEstados.id_estado
		  JOIN tbl_CatPaises
		  ON tbl_CatClientes.id_pais = tbl_CatPaises.id_pais
		  JOIN tbl_CatOcupacion
		  ON tbl_CatClientes.id_ocupacion = tbl_CatOcupacion.id_ocupacion
		  JOIN tbl_CatEstadoCivil 
		  ON tbl_CatClientes.id_estadoCivil = tbl_CatEstadoCivil.id_estadoCivil
		  JOIN tbl_CatCredenciales
		  ON tbl_CatClientes.id_cliente = tbl_CatCredenciales.id_cliente
		  JOIN tbl_CatGenero
		  ON tbl_CatGenero.id_genero = tbl_CatClientes.id_genero
		  WHERE tbl_CatClientes.activo = 1 AND  tbl_CatClientes.activo = 1 AND  nombre +' '+ apePat +' '+ apeMat  LIKE '%'  + @Busqueda + '%'
		  ORDER BY nombre + ' ' + apePat + ' ' + apeMat
		END
		ELSE IF(@TipoBusq = 2)
		BEGIN
		  SELECT 
			   tbl_CatClientes.id_cliente as IDCliente
			  ,nombre as Nombre
			  ,apePat as ApePat
			  ,apeMat as ApeMat
			  , nombre + ' ' + apePat + ' ' + apeMat as NombreCompleto 
			  ,CorreoElectronico
			  ,tbl_CatMunicipios.id_municipio as IDMunicipio
			  ,tbl_CatMunicipios.descripcion as Municipio
			  ,tbl_CatEstados.id_estado as IDEstado
			  ,tbl_CatEstados.descripcion as Estado
			  ,tbl_CatPaises.id_pais as IDPais
			  ,tbl_CatPaises.descripcion as Pais
			  ,colonia as Colonia
			  ,CAST(fechaNacimiento AS date) AS FechaNacimiento
			  ,tbl_CatOcupacion.id_ocupacion as IDOcupacion
			  ,tbl_CatOcupacion.ocupacion as Ocupacion
			  ,tbl_CatEstadoCivil.id_estadoCivil as IDEstadoCivil
			  ,tbl_CatEstadoCivil.estadoCivil as EstadoCivil
			  ,tbl_CatGenero.id_genero as IDGenero
			  ,tbl_CatGenero.genero as Genero
			  ,curp as Curp
			  ,tbl_CatCredenciales.id_codigoEab as IDCodigoEab
			  ,tbl_CatCredenciales.id_tipocredencial
			  ,tbl_CatCredenciales.puntos
			  ,tbl_CatCredenciales.monedero as Monedero
			  ,tbl_CatCredenciales.id_codigoEab
		  FROM tbl_CatClientes JOIN tbl_CatMunicipios
		  ON tbl_CatClientes.id_municipio = tbl_CatMunicipios.id_municipio AND tbl_CatClientes.id_estado = tbl_CatMunicipios.id_estado AND tbl_CatClientes.id_pais = tbl_CatMunicipios.id_pais
		  JOIN tbl_CatEstados
		  ON tbl_CatClientes.id_estado = tbl_CatEstados.id_estado
		  JOIN tbl_CatPaises
		  ON tbl_CatClientes.id_pais = tbl_CatPaises.id_pais
		  JOIN tbl_CatOcupacion
		  ON tbl_CatClientes.id_ocupacion = tbl_CatOcupacion.id_ocupacion
		  JOIN tbl_CatEstadoCivil 
		  ON tbl_CatClientes.id_estadoCivil = tbl_CatEstadoCivil.id_estadoCivil
		  JOIN tbl_CatCredenciales
		  ON tbl_CatClientes.id_cliente = tbl_CatCredenciales.id_cliente
		  JOIN tbl_CatGenero
		  ON tbl_CatGenero.id_genero = tbl_CatClientes.id_genero
		  WHERE tbl_CatClientes.activo = 1 AND  id_codigoEab  LIKE '%'  + @Busqueda + '%'
		  ORDER BY nombre + ' ' + apePat + ' ' + apeMat
		END
	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END











GO
/****** Object:  StoredProcedure [dbo].[CatDatosViajes_Eliminar_sp]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[CatDatosViajes_Eliminar_sp]
            @id_datosViaje        NVARCHAR(100)
		   ,@id_viaje             NVARCHAR(100)
		   ,@fecha_viaje          DATE
		   ,@hora_viaje			  NVARCHAR(8)
		   ,@ID_U				  NVARCHAR(100)		
           
AS
BEGIN
	BEGIN TRY

		SET NOCOUNT ON

	    DECLARE @fechaSistema	DATETIME
	    SET @fechaSistema = dbo.fnGetNewDate()


		UPDATE dbo.tbl_DatosViaje
		   SET 
			   usuupd = @ID_U
			  ,fecupd = @fechaSistema
			  ,activo = 0
		 WHERE id_datosViaje = @id_datosViaje AND id_viaje = @id_viaje AND fecha_salida = @fecha_viaje AND hora_salida = @hora_viaje



	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END

































GO
/****** Object:  StoredProcedure [dbo].[CatDatosViajes_Insertar_sp]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO










ALTER PROCEDURE [dbo].[CatDatosViajes_Insertar_sp]	
            @IDVIAJE									NVARCHAR(100)
		   ,@FECHA										DATE
		   ,@HORA										NVARCHAR(8)
		   ,@folio_prestacionServicios1					NVARCHAR(20)
		   ,@id_chofer1_prestacionServicios1			NVARCHAR(100)
		   ,@id_chofer2_prestacionServicios1			NVARCHAR(100)
		   ,@autobus_prestacionServicios1				NVARCHAR(50)
		   ,@fecha_salida_prestacionServicios1			DATE
		   ,@hora_salida_prestacionServicios1			NVARCHAR(8)
		   ,@solicitado_por_prestacionServicios1		NVARCHAR(300)
		   ,@grupo_prestacionServicios1					INT
		   ,@servicio_prestacionServicios1				NVARCHAR(200)
		   ,@presentarse_en_prestacionServicios1		NVARCHAR(300)
           ,@instrucciones_prestacionServicios1			NVARCHAR(MAX)
           ,@observaciones_prestacionServicios1			NVARCHAR(MAX)
		   ,@folio_prestacionServicios2					NVARCHAR(20)
		   ,@solicitado_por_prestacionServicios2		NVARCHAR(300)
		   ,@poliza_prestacionServicios2				NVARCHAR(50)
		   ,@poliza_fecha1_prestacionServicios2			DATE
		   ,@poliza_fecha2_prestacionServicios2			DATE
		   ,@credencial_elector_prestacionServicios2	NVARCHAR(50)
		   ,@domicilio_prestacionServicios2				NVARCHAR(100)
		   ,@origen_prestacionServicios2				NVARCHAR(100)
		   ,@destino_prestacionServicios2				NVARCHAR(100)
		   ,@monto_servicio_prestacionServicios2        MONEY
		   ,@monto_servicio_texto_prestacionServicios2  NVARCHAR(100)
		   ,@lugar_salida_prestacionServicios2          NVARCHAR(100)
		   ,@fecha_salida_prestacionServicios2          DATE
		   ,@hora_salida_prestacionServicios2           NVARCHAR(8)
		   ,@numero_personas_prestacionServicios2       INT
		   ,@id_chofer1_prestacionServicios2            NVARCHAR(100)
		   ,@id_chofer2_prestacionServicios2            NVARCHAR(100)
		   ,@numero_placa_prestacionServicios2          NVARCHAR(20)
		   ,@ruta_contratada_prestacionServicios2       NVARCHAR(200)
		   ,@dias_viaje_prestacionServicios2            INT
		   ,@dia_hora_salida_prestacionServicios2       NVARCHAR(200)
		   ,@folio_listapasajeros                       NVARCHAR(20)
		   ,@oficina_listapasajeros                     NVARCHAR(100)
		   ,@dia_listapasajeros                         INT
		   ,@mes_listapasajeros                         INT
		   ,@año_listapasajeros                         INT
		   ,@carro_listapasajeros                       NVARCHAR(100)
		   ,@oficinista_listapasajeros                  NVARCHAR(100)
		   ,@hora_salida_listapasajeros                 NVARCHAR(8)
		   ,@Id_U										NVARCHAR(100)
		   ,@BanTipo									INT            
AS
BEGIN
	BEGIN TRY

		SET NOCOUNT ON

	    DECLARE @fechaSistema	DATETIME
	    SET @fechaSistema = dbo.fnGetNewDate()

	
			IF( NOT EXISTS(SELECT id_datosViaje  FROM [dbo].[vtbl_DatosViaje_Estadisticos] WHERE id_viaje = @IDVIAJE AND fecha_salida = @FECHA AND hora_salida = @HORA AND activo = 1))
			BEGIN
				DECLARE @id_datosViaje NVARCHAR(100)
				SET @id_datosViaje = NEWID()
				DECLARE @id_prestacionServicios1 NVARCHAR(100)
				SET @id_prestacionServicios1 = NEWID()
				DECLARE @id_prestacionServicios2 NVARCHAR(100)
				SET @id_prestacionServicios2 = NEWID()
				DECLARE @id_listapasajeros NVARCHAR(100)
				SET @id_listapasajeros = NEWID()

				DECLARE  @FOLIOVIAJE   NVARCHAR(20)
				SET @FOLIOVIAJE = ( SELECT ISNULL(MAX(RIGHT(folio,6)),'000000') 
									FROM tbl_DatosViaje 
									WHERE YEAR(fecins)= YEAR(GETDATE()) 
									AND MONTH(fecins) = MONTH(GETDATE())
									AND DAY(fecins) = DAY(GETDATE()))
				SET @FOLIOVIAJE = @FOLIOVIAJE + 1
				SET @FOLIOVIAJE = CONVERT(CHAR(4),YEAR(GETDATE())) + RIGHT('0' + RTRIM(MONTH(GETDATE())), 2) + RIGHT('0' + RTRIM(DAY(GETDATE())), 2) +  RIGHT('000000' + @FOLIOVIAJE, 6) 

				INSERT INTO tbl_DatosViaje
					   (id_datosViaje
					   ,id_viaje
					   ,fecha_salida
					   ,hora_salida
					   ,id_prestacionServicios1
					   ,id_prestacionServicios2
					   ,id_listapasajeros
					   ,folio
					   ,usuins
					   ,fecins
					   ,usuupd
					   ,fecupd
					   ,activo)
				 VALUES
					   (@id_datosViaje
					   ,@IDVIAJE
					   ,@FECHA
					   ,@HORA
					   ,@id_prestacionServicios1
					   ,@id_prestacionServicios2
					   ,@id_listapasajeros
					   ,@FOLIOVIAJE
					   ,@Id_U
					   ,@fechaSistema
					   ,@Id_U
					   ,@fechaSistema
					   ,1)

				INSERT INTO tbl_DatosViajeContratoServicio1
						   (id_prestacionServicios1
						   ,folio
						   ,id_chofer1
						   ,id_chofer2
						   ,autobus
						   ,fecha_salida
						   ,hora_salida
						   ,solicitado_por
						   ,grupo
						   ,servicio
						   ,presentarse_en
						   ,instrucciones
						   ,observaciones)
					 VALUES
						   (@id_prestacionServicios1
						   ,@FOLIOVIAJE
						   ,@id_chofer1_prestacionServicios1
						   ,@id_chofer2_prestacionServicios1
						   ,@autobus_prestacionServicios1
						   ,@fecha_salida_prestacionServicios1
						   ,@hora_salida_prestacionServicios1
						   ,@solicitado_por_prestacionServicios1
						   ,@grupo_prestacionServicios1
						   ,@servicio_prestacionServicios1
						   ,@presentarse_en_prestacionServicios1
						   ,@instrucciones_prestacionServicios1
						   ,@observaciones_prestacionServicios1)

					INSERT INTO tbl_DatosViajeContratoServicio2
						   (id_prestacionServicios2
						   ,folio
						   ,solicitado_por
						   ,poliza
						   ,poliza_fecha1
						   ,poliza_fecha2
						   ,credencial_elector
						   ,domicilio
						   ,origen
						   ,destino
						   ,monto_servicio
						   ,monto_servicio_texto
						   ,lugar_salida
						   ,fecha_salida
						   ,hora_salida
						   ,numero_personas
						   ,id_chofer1
						   ,id_chofer2
						   ,numero_placa
						   ,ruta_contratada
						   ,dias_viaje
						   ,dia_hora_salida)
					 VALUES
						   (@id_prestacionServicios2
						   ,@FOLIOVIAJE
				   		   ,@solicitado_por_prestacionServicios2		
                		   ,@poliza_prestacionServicios2				
		                   ,@poliza_fecha1_prestacionServicios2			
						   ,@poliza_fecha2_prestacionServicios2			
						   ,@credencial_elector_prestacionServicios2	
						   ,@domicilio_prestacionServicios2				
						   ,@origen_prestacionServicios2				
						   ,@destino_prestacionServicios2				
						   ,@monto_servicio_prestacionServicios2        
						   ,@monto_servicio_texto_prestacionServicios2  
						   ,@lugar_salida_prestacionServicios2          
						   ,@fecha_salida_prestacionServicios2          
						   ,@hora_salida_prestacionServicios2           
						   ,@numero_personas_prestacionServicios2       
						   ,@id_chofer1_prestacionServicios2            
						   ,@id_chofer2_prestacionServicios2            
						   ,@numero_placa_prestacionServicios2          
						   ,@ruta_contratada_prestacionServicios2       
						   ,@dias_viaje_prestacionServicios2            
						   ,@dia_hora_salida_prestacionServicios2)      

				INSERT INTO tbl_DatosViajeListaPasajeros
						   (id_listapasajeros
						   ,folio
						   ,oficina
						   ,dia
						   ,mes
						   ,año
						   ,carro
						   ,oficinista
						   ,hora_salida)
					 VALUES
						   (@id_listapasajeros
						   ,@FOLIOVIAJE
						   ,@oficina_listapasajeros
						   ,@dia_listapasajeros
						   ,@mes_listapasajeros
						   ,@año_listapasajeros
						   ,@carro_listapasajeros
						   ,@oficinista_listapasajeros
						   ,@hora_salida_listapasajeros)
				SELECT 1
			END		
	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END







































GO
/****** Object:  StoredProcedure [dbo].[CatDatosViajes_Modificar_sp]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO











ALTER PROCEDURE [dbo].[CatDatosViajes_Modificar_sp]
            @id_datosViaje	                            NVARCHAR(100)
		   ,@id_prestacionServicios1                    NVARCHAR(100)
		   ,@id_prestacionServicios2                    NVARCHAR(100)
		   ,@id_listapasajeros                          NVARCHAR(100)
           ,@IDVIAJE									NVARCHAR(100)
		   ,@FECHA										DATE
		   ,@HORA										NVARCHAR(8)
		   ,@folio_prestacionServicios1					NVARCHAR(20)
		   ,@id_chofer1_prestacionServicios1			NVARCHAR(100)
		   ,@id_chofer2_prestacionServicios1			NVARCHAR(100)
		   ,@autobus_prestacionServicios1				NVARCHAR(50)
		   ,@fecha_salida_prestacionServicios1			DATE
		   ,@hora_salida_prestacionServicios1			NVARCHAR(8)
		   ,@solicitado_por_prestacionServicios1		NVARCHAR(300)
		   ,@grupo_prestacionServicios1					INT
		   ,@servicio_prestacionServicios1				NVARCHAR(200)
		   ,@presentarse_en_prestacionServicios1		NVARCHAR(300)
           ,@instrucciones_prestacionServicios1			NVARCHAR(MAX)
           ,@observaciones_prestacionServicios1			NVARCHAR(MAX)
		   ,@folio_prestacionServicios2					NVARCHAR(20)
		   ,@solicitado_por_prestacionServicios2		NVARCHAR(300)
		   ,@poliza_prestacionServicios2				NVARCHAR(50)
		   ,@poliza_fecha1_prestacionServicios2			DATE
		   ,@poliza_fecha2_prestacionServicios2			DATE
		   ,@credencial_elector_prestacionServicios2	NVARCHAR(50)
		   ,@domicilio_prestacionServicios2				NVARCHAR(100)
		   ,@origen_prestacionServicios2				NVARCHAR(100)
		   ,@destino_prestacionServicios2				NVARCHAR(100)
		   ,@monto_servicio_prestacionServicios2        MONEY
		   ,@monto_servicio_texto_prestacionServicios2  NVARCHAR(100)
		   ,@lugar_salida_prestacionServicios2          NVARCHAR(100)
		   ,@fecha_salida_prestacionServicios2          DATE
		   ,@hora_salida_prestacionServicios2           NVARCHAR(8)
		   ,@numero_personas_prestacionServicios2       INT
		   ,@id_chofer1_prestacionServicios2            NVARCHAR(100)
		   ,@id_chofer2_prestacionServicios2            NVARCHAR(100)
		   ,@numero_placa_prestacionServicios2          NVARCHAR(20)
		   ,@ruta_contratada_prestacionServicios2       NVARCHAR(200)
		   ,@dias_viaje_prestacionServicios2            INT
		   ,@dia_hora_salida_prestacionServicios2       NVARCHAR(200)
		   ,@folio_listapasajeros                       NVARCHAR(20)
		   ,@oficina_listapasajeros                     NVARCHAR(100)
		   ,@dia_listapasajeros                         INT
		   ,@mes_listapasajeros                         INT
		   ,@año_listapasajeros                         INT
		   ,@carro_listapasajeros                       NVARCHAR(100)
		   ,@oficinista_listapasajeros                  NVARCHAR(100)
		   ,@hora_salida_listapasajeros                 NVARCHAR(8)
		   ,@Id_U										NVARCHAR(100)
		   ,@BanTipo									INT            
AS
BEGIN
	BEGIN TRY

		SET NOCOUNT ON

	    DECLARE @fechaSistema	DATETIME
	    SET @fechaSistema = dbo.fnGetNewDate()


		UPDATE tbl_DatosViaje
		   SET 
			   folio = @folio_prestacionServicios1
			  ,usuupd = @Id_U	
			  ,fecupd = @fechaSistema
		 WHERE id_datosViaje = @id_datosViaje

		 UPDATE dbo.tbl_DatosViajeContratoServicio1
		   SET 
			   folio = @folio_prestacionServicios1
			  ,id_chofer1 = @id_chofer1_prestacionServicios1
			  ,id_chofer2 = @id_chofer2_prestacionServicios1
			  ,autobus = @autobus_prestacionServicios1
			  ,fecha_salida = @fecha_salida_prestacionServicios1
			  ,hora_salida = @hora_salida_prestacionServicios1
			  ,solicitado_por = @solicitado_por_prestacionServicios1
			  ,grupo = @grupo_prestacionServicios1	
			  ,servicio = @servicio_prestacionServicios1
			  ,presentarse_en = @presentarse_en_prestacionServicios1
			  ,instrucciones = @instrucciones_prestacionServicios1	
			  ,observaciones = @observaciones_prestacionServicios1	
		 WHERE id_prestacionServicios1 = @id_prestacionServicios1


		 UPDATE tbl_DatosViajeContratoServicio2
		   SET 
			   folio = @folio_prestacionServicios2
			  ,solicitado_por = @solicitado_por_prestacionServicios2
			  ,poliza = @poliza_prestacionServicios2
			  ,poliza_fecha1 = @poliza_fecha1_prestacionServicios2
			  ,poliza_fecha2 = @poliza_fecha2_prestacionServicios2
			  ,credencial_elector = @credencial_elector_prestacionServicios2
			  ,domicilio = @domicilio_prestacionServicios2
			  ,origen = @origen_prestacionServicios2
			  ,destino = @destino_prestacionServicios2
			  ,monto_servicio = @monto_servicio_prestacionServicios2
			  ,monto_servicio_texto = @monto_servicio_texto_prestacionServicios2
			  ,lugar_salida = @lugar_salida_prestacionServicios2 
			  ,fecha_salida = @fecha_salida_prestacionServicios2
			  ,hora_salida = @hora_salida_prestacionServicios2
			  ,numero_personas = @numero_personas_prestacionServicios2
			  ,id_chofer1 = @id_chofer1_prestacionServicios2
			  ,id_chofer2 = @id_chofer2_prestacionServicios2
			  ,numero_placa = @numero_placa_prestacionServicios2
			  ,ruta_contratada = @ruta_contratada_prestacionServicios2
			  ,dias_viaje = @dias_viaje_prestacionServicios2
			  ,dia_hora_salida = @dia_hora_salida_prestacionServicios2
		 WHERE id_prestacionServicios2 = @id_prestacionServicios2  

		 UPDATE dbo.tbl_DatosViajeListaPasajeros
		   SET 
			  folio = @folio_listapasajeros
			  ,oficina = @oficina_listapasajeros
			  ,dia = @dia_listapasajeros
			  ,mes = @mes_listapasajeros
			  ,año = @año_listapasajeros
			  ,carro = @carro_listapasajeros
			  ,oficinista = @oficinista_listapasajeros
			  ,hora_salida = @hora_salida_listapasajeros
		 WHERE id_listapasajeros = @id_listapasajeros
		SELECT 1
		
	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END








































GO
/****** Object:  StoredProcedure [dbo].[CatDisenioCamion_Consulta_sp]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[CatDisenioCamion_Consulta_sp]
AS
BEGIN
	BEGIN TRY

		SET NOCOUNT ON

			SELECT id_disenioCamion
				  ,nombre
				  ,descripcion
				  ,numasientos
				  ,numtvs
				  ,numwcsnt
				  ,numbares
				  ,numpisos
				  ,numpuerta
			  FROM tbl_CatDisenio
			  WHERE activo = 1
			  ORDER BY nombre 
			
	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END































GO
/****** Object:  StoredProcedure [dbo].[CatDisenioCamion_Eliminar_sp]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[CatDisenioCamion_Eliminar_sp]
                @IDDisenioCamion NVARCHAR(100)
			   
AS
BEGIN
	BEGIN TRY

		SET NOCOUNT ON


		UPDATE tbl_CatDisenio
		   SET 
               activo = 0
		 WHERE id_disenioCamion = @IDDisenioCamion

		 UPDATE tbl_CatDisenioDatos
		   SET 
			   activo = 0
		 WHERE id_disenioCamion = @IDDisenioCamion
			
	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END































GO
/****** Object:  StoredProcedure [dbo].[CatDisenioCamion_Insertar_sp]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER PROCEDURE [dbo].[CatDisenioCamion_Insertar_sp]
                @Nombre        NVARCHAR(50)
			   ,@Descripcion   NVARCHAR(MAX)
			   ,@NumAsientos   INT
			   ,@NumTV         INT
			   ,@NumWC         INT
			   ,@NumBares      INT
			   ,@NumPisos      INT
			   ,@NumPuerta     INT
               ,@DisenioCamion DisenioCamion READONLY
			   ,@ID_U          NVARCHAR(100)
AS
BEGIN
	BEGIN TRY

		SET NOCOUNT ON

		DECLARE @IDDisenioCamion NVARCHAR(100)
		SET @IDDisenioCamion = NEWID()

		DECLARE @fecha	DATETIME
    	SET @fecha = dbo.fnGetNewDate()


		INSERT INTO tbl_CatDisenio
				   (id_disenioCamion
				   ,nombre
				   ,descripcion
				   ,numasientos
				   ,numtvs
				   ,numwcsnt
				   ,numbares
				   ,numpisos
				   ,numpuerta
				   ,usuins
				   ,fecins
				   ,usuupd
				   ,fecupd
				   ,activo)
			 VALUES
				   (@IDDisenioCamion
				   ,@Nombre
				   ,@Descripcion
				   ,@NumAsientos
				   ,@NumTV
				   ,@NumWC
				   ,@NumBares
				   ,@NumPisos
				   ,@NumPuerta
				   ,@ID_U
				   ,@fecha
				   ,@ID_U
				   ,@fecha
				   ,1)


		INSERT INTO tbl_CatDisenioDatos
				   (id_disenioDatos
				   ,id_disenioCamion
				   ,indice
				   ,id_tipoObjeto
				   ,descripcion
				   ,numpiso
				   ,usuins
				   ,fecins
				   ,usuupd
				   ,fecupd
				   ,activo)

			SELECT
				   NEWID()
				   ,@IDDisenioCamion
				   ,indice
				   ,idTipoObj
				   ,descripcion
				   ,numPiso
				   ,@ID_U
				   ,@fecha
				   ,@ID_U
				   ,@fecha
				   ,1
			FROM @DisenioCamion
			
	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END

































GO
/****** Object:  StoredProcedure [dbo].[CatDisenioCamion_Modificar_sp]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER PROCEDURE [dbo].[CatDisenioCamion_Modificar_sp]
                @IDDisenioCamion NVARCHAR(100)
               ,@Nombre         NVARCHAR(50)
			   ,@Descripcion    NVARCHAR(MAX)
			   ,@NumAsientos    INT
			   ,@NumTV          INT
			   ,@NumWC          INT
			   ,@NumBares       INT
			   ,@NumPisos       INT
			   ,@NumPuerta      INT
			   ,@DisenioCamion DisenioCamion READONLY
			   ,@ID_U           NVARCHAR(100)
AS
BEGIN
	BEGIN TRY

		SET NOCOUNT ON


		DECLARE @fecha	DATETIME
    	SET @fecha = dbo.fnGetNewDate()


		UPDATE tbl_CatDisenio
		   SET 
			   nombre = @Nombre
			  ,descripcion = @Descripcion
			  ,numasientos = @NumAsientos
			  ,numtvs = @NumTV
			  ,numwcsnt = @NumWC
			  ,numbares = @NumBares
			  ,numpisos = @NumPisos
			  ,numpuerta = @NumPuerta
			  ,usuupd = @ID_U
			  ,fecupd = @fecha
		 WHERE id_disenioCamion = @IDDisenioCamion

		DELETE FROM tbl_CatDisenioDatos WHERE id_disenioCamion = @IDDisenioCamion


		 		INSERT INTO tbl_CatDisenioDatos
				   (id_disenioDatos
				   ,id_disenioCamion
				   ,indice
				   ,id_tipoObjeto
				   ,descripcion
				   ,numpiso
				   ,usuins
				   ,fecins
				   ,usuupd
				   ,fecupd
				   ,activo)

			SELECT
				   NEWID()
				   ,@IDDisenioCamion
				   ,indice
				   ,idTipoObj
				   ,descripcion
				   ,numPiso
				   ,@ID_U
				   ,@fecha
				   ,@ID_U
				   ,@fecha
				   ,1
			FROM @DisenioCamion
			
	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END

































GO
/****** Object:  StoredProcedure [dbo].[CatDisenioCamionDatos_Consulta_sp]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[CatDisenioCamionDatos_Consulta_sp]
                 @IDViaje      NVARCHAR(100)
				,@Fecha        DATE
				,@Hora         NVARCHAR(8)
				,@OrdenOrigen  INT 
				,@OrdenDestino INT
AS
BEGIN
	BEGIN TRY

		SET NOCOUNT ON

		SELECT 
		     tbl_CatDisenioDatos.indice
			,tbl_CatTipoObjeto.id_tipoObjeto as idTipoObj
			,tbl_CatTipoObjeto.tipoObjeto as tipoObj
			,tbl_CatDisenioDatos.descripcion
			,numpiso
			,CONVERT(NVARCHAR(20),ISNULL(Datos.id_status,'')) AS idStatus  
			,CONVERT(NVARCHAR(20),ISNULL(Datos.pago, '')) AS pago   
			,CONVERT(NVARCHAR(20),ISNULL(Datos.costo,'') ) AS costo  
			,CONVERT(NVARCHAR(300),ISNULL(Datos.NombrePersona,'')) AS nombre
			,Datos.asistencia  
		FROM tbl_CatDisenioDatos JOIN tbl_CatTipoObjeto
		ON tbl_CatDisenioDatos.id_tipoObjeto = tbl_CatTipoObjeto.id_tipoObjeto
		JOIN tbl_CatCamiones
		ON tbl_CatCamiones.id_disenioCamion = tbl_CatDisenioDatos.id_disenioCamion
		JOIN tbl_CatViajes
		ON tbl_CatViajes.id_camion = tbl_CatCamiones.id_camion
		JOIN tbl_CatViajesXFecha
		ON tbl_CatViajes.id_identificador = tbl_CatViajesXFecha.id_viaje
		LEFT JOIN vtbl_BoletosVenta AS Datos
		ON Datos.id_viaje = tbl_CatViajes.id_identificador AND Datos.fecha_salida = tbl_CatViajesXFecha.fechaviaje AND Datos.hora_salida = tbl_CatViajes.horario AND Datos.asiento = tbl_CatDisenioDatos.indice AND Datos.idTipoObj = tbl_CatTipoObjeto.id_tipoObjeto AND NOT (((@OrdenOrigen < OrdenOrigenTerminal) AND (@OrdenDestino <= OrdenOrigenTerminal )) OR  ((@OrdenOrigen >= OrdenDestinoTerminal) AND (@OrdenDestino > OrdenDestinoTerminal)))
		WHERE  tbl_CatViajesXFecha.id_viaje = @IDViaje AND CONVERT(DATE,tbl_CatViajesXFecha.fechaviaje) = @Fecha AND tbl_CatViajes.horario = @Hora AND tbl_CatDisenioDatos.activo = 1 
		ORDER BY idTipoObj, indice

		
			
	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END

































GO
/****** Object:  StoredProcedure [dbo].[CatDisenioCamionDatosDiseñador_Consulta_sp]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[CatDisenioCamionDatosDiseñador_Consulta_sp]
                 @IDDiseñoCamion  NVARCHAR(100)
AS
BEGIN
	BEGIN TRY

		SET NOCOUNT ON

		SELECT 
		     indice
			,tbl_CatTipoObjeto.id_tipoObjeto as idTipoObj
			,tbl_CatTipoObjeto.tipoObjeto as tipoObj
			,tbl_CatDisenioDatos.descripcion
			,numpiso
			,0 as idStatus
		FROM tbl_CatDisenioDatos JOIN tbl_CatTipoObjeto
		ON tbl_CatDisenioDatos.id_tipoObjeto = tbl_CatTipoObjeto.id_tipoObjeto
		WHERE tbl_CatDisenioDatos.id_disenioCamion = @IDDiseñoCamion AND tbl_CatDisenioDatos.activo = 1
		ORDER BY idTipoObj, indice

		
			
	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END































GO
/****** Object:  StoredProcedure [dbo].[CatEstadoCivil_Combo_sp]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[CatEstadoCivil_Combo_sp]
AS
BEGIN
	BEGIN TRY

		SET NOCOUNT ON

		-- ------------------------ --
		-- Declaración de variables --
		-- ------------------------ --

			SELECT 
				id_estadoCivil, 
				estadoCivil
			FROM tbl_CatEstadoCivil WHERE activo = 1
			UNION
			SELECT '0' AS 'id_estadoCivil', '-- Seleccionar --' AS 'estadoCivil' ORDER BY estadoCivil

	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------
	END CATCH
END







GO
/****** Object:  StoredProcedure [dbo].[CatEstados_Combo_sp]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[CatEstados_Combo_sp]
		@Activo		INT, --Activo = 1
		@id_pais	INT
AS
BEGIN
	BEGIN TRY

		SET NOCOUNT ON
		DECLARE
				@MensajeError	VARCHAR(1000)


			SELECT 
					id_estado AS 'Id', 
					descripcion AS 'Descripcion'
			FROM tbl_CatEstados WHERE activo = @Activo AND id_pais = @id_pais
			UNION
			SELECT 
					'0' AS 'Id',
					 '-- Seleccionar --' AS 'Descripcion' 
			ORDER BY descripcion

	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		SELECT @MensajeError	= ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END

























GO
/****** Object:  StoredProcedure [dbo].[CatFechasViaje_Insertar]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[CatFechasViaje_Insertar]
	@id_viaje NVARCHAR(100),
	@fecini DATE, 
	@fecfin DATE,
	@lunes BIT,    
	@martes BIT,
	@miercoles BIT,
	@jueves BIT,
	@viernes BIT,
	@sabado BIT,
	@domingo BIT,
	@usuario NVARCHAR(100),
	@Opcion INT -- 1 Insertar, 2 Eliminar

AS
BEGIN
	SET NOCOUNT ON;
	declare @fecNew DATE
	declare @NumDayTotal INT
	declare @Contador INT
	declare @NumDaySemana INT
	declare @fectoday DATE

	/*valores iniciales*/
	SET @fectoday = dbo.fnGetNewDate()
	SET @Contador = 1
	SET @NumDayTotal = DATEDIFF(day, @fecini, @fecfin) /* validar que fecini debe ser menor o igual a fecfin*/
	SET @NumDayTotal = @NumDayTotal + 1
	IF(@NumDayTotal = 0) 
	BEGIN
		SET @NumDayTotal =1
	END

	SET @fecNew = @fecIni
	/*Para hacer modificaciones o recofiguracion, cada que se ejecute este procedimiento se borraran todas las fechas
	previamente programadas*/
	--DELETE  tbl_CatViajesXFecha WHERE id_viaje = @id_viaje

	/*inicia contador de numero de dias de la fecha de inicio a la fecha de fin del periodo*/
	WHILE (@Contador <= @NumDayTotal)
	BEGIN	
	/* obtener el dia de la semana del viaje*/
	SET  @NumDaySemana = DatePart(WeekDay, @fecNew)
	
	/* revisar si al publicar el numero de semana no cambia en versiones para INGLES*/
	IF(@lunes = 'True' AND @NumDaySemana = 2)
	BEGIN
		EXECUTE abc_CatViajesXFecha @Opcion, @id_viaje, @fecNew, @usuario
	END
	ELSE IF(@martes = 'True' and @NumDaySemana = 3)
	BEGIN
		EXECUTE abc_CatViajesXFecha @Opcion, @id_viaje, @fecNew, @usuario
	END
	ELSE IF(@miercoles= 'True' and @NumDaySemana = 4)
	BEGIN
		EXECUTE abc_CatViajesXFecha @Opcion, @id_viaje, @fecNew, @usuario
	END
	ELSE IF(@jueves= 'True' and @NumDaySemana = 5)
	BEGIN
		EXECUTE abc_CatViajesXFecha @Opcion, @id_viaje, @fecNew, @usuario
	END ELSE IF(@viernes= 'True' and @NumDaySemana = 6)
	BEGIN
		EXECUTE abc_CatViajesXFecha @Opcion, @id_viaje, @fecNew, @usuario
	END
	ELSE IF(@sabado= 'True' and @NumDaySemana = 7)
	BEGIN
		EXECUTE abc_CatViajesXFecha @Opcion, @id_viaje, @fecNew, @usuario
	END
	ELSE IF(@domingo= 'True' and @NumDaySemana = 1)
	BEGIN
		EXECUTE abc_CatViajesXFecha @Opcion, @id_viaje, @fecNew, @usuario
	END
	
	SET @fecNew = DATEADD(day, @Contador, @fecIni);
	SET @Contador = @Contador + 1	
	END

END







GO
/****** Object:  StoredProcedure [dbo].[CatGenero_Combo_sp]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[CatGenero_Combo_sp]
AS
BEGIN
	BEGIN TRY

		SET NOCOUNT ON

			SELECT 
					id_genero,  
					genero 
			FROM tbl_CatGenero WHERE Activo = 1
			UNION
			SELECT 
					'0' AS 'id_genero',
					 '-- Seleccionar --' AS 'genero' 
			ORDER BY genero

	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------
	END CATCH
END








GO
/****** Object:  StoredProcedure [dbo].[CatMacCobro_Modificar]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





ALTER PROCEDURE [dbo].[CatMacCobro_Modificar]
			@macaddress    NVARCHAR(20),
			@cobro		   BIT

AS
BEGIN
	BEGIN TRANSACTION
	BEGIN TRY
		SET NOCOUNT ON

			UPDATE tbl_CatCajas
			SET	
				 cobro = @cobro
			WHERE macAddress = @macaddress
					
	COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		ROLLBACK TRANSACTION
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END


































GO
/****** Object:  StoredProcedure [dbo].[CatMaletas_Agregar_sp]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





ALTER PROCEDURE [dbo].[CatMaletas_Agregar_sp]	
            @IDBoleto		    NVARCHAR(100)
		   ,@FolioMaleta        NVARCHAR(25)
		   ,@Descripcion        NVARCHAR(500)
		   ,@Precio             MONEY
		   ,@numeroMaletas      INT
           ,@Usuario            NVARCHAR(100)
		   ,@IDCaja             NVARCHAR(100)
AS
BEGIN
	BEGIN TRY

		SET NOCOUNT ON


	DECLARE @Fecha DATETIME = dbo.fnGetNewDate()
	DECLARE @IDMaleta NVARCHAR(100) = (NEWID())

	INSERT INTO tbl_CatMaletas
           (id_maleta
           ,id_boleto
           ,folioMaleta
           ,descripcion
           ,precio
		   ,numeroMaletas
           ,id_status
           ,usuins
           ,fecins
           ,usuupd
           ,fecupd
           ,activo)
     VALUES
           (@IDMaleta
           ,@IDBoleto
           ,@FolioMaleta
           ,@Descripcion
           ,@Precio
		   ,@numeroMaletas
           ,1
           ,@Usuario
           ,@Fecha
           ,@Usuario
           ,@Fecha
           ,1)


		INSERT INTO tbl_VentaCajas
			   (IDVentasCajas
			   ,IDCajaXSucursal
			   ,IDStatus
			   ,IDGenerico
			   ,usuins
			   ,fecins
			   ,usuupd
			   ,fecupd
			   ,activo)
		 VALUES
			   (NEWID()
			   ,@IDCAJA
			   ,9
			   ,@IDMaleta
			   ,@Usuario
			   ,@Fecha
			   ,@Usuario
			   ,@Fecha
			   ,1)

	SELECT @IDMaleta

	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END












GO
/****** Object:  StoredProcedure [dbo].[CatMaletas_Consulta_sp]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[CatMaletas_Consulta_sp]	
		    @IDBoleto        NVARCHAR(100)
AS
BEGIN
	BEGIN TRY
	
		SET NOCOUNT ON

		SELECT 
			 id_maleta
			,id_boleto
			,folioMaleta
			,descripcion
			,numeroMaletas
			,precio
			,id_status
		FROM tbl_CatMaletas
		WHERE id_boleto = @IDBoleto AND activo = 1
		ORDER BY fecins DESC



	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END

































GO
/****** Object:  StoredProcedure [dbo].[CatMaletas_Eliminar_sp]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER PROCEDURE [dbo].[CatMaletas_Eliminar_sp]	
		    @idMaleta        NVARCHAR(100),
			@Usuario         NVARCHAR(100),
			@IDCaja             NVARCHAR(100)
AS
BEGIN
	BEGIN TRY

		SET NOCOUNT ON


		DECLARE @Fecha DATETIME = dbo.fnGetNewDate()
		   UPDATE tbl_CatMaletas
			  SET
				 activo = 0,
				 usuupd = @Usuario,
				 fecupd = dbo.fnGetNewDate()
		   WHERE id_maleta = @idMaleta


		INSERT INTO tbl_VentaCajas
			   (IDVentasCajas
			   ,IDCajaXSucursal
			   ,IDStatus
			   ,IDGenerico
			   ,usuins
			   ,fecins
			   ,usuupd
			   ,fecupd
			   ,activo)
		 VALUES
			   (NEWID()
			   ,@IDCAJA
			   ,10
			   ,@idMaleta
			   ,@Usuario
			   ,@Fecha
			   ,@Usuario
			   ,@Fecha
			   ,1)
		   SELECT 1

	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END


































GO
/****** Object:  StoredProcedure [dbo].[CatMarca_Eliminar]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER PROCEDURE [dbo].[CatMarca_Eliminar]
			@id_marca	INT
AS
BEGIN
	BEGIN TRANSACTION
	BEGIN TRY

		SET NOCOUNT ON

			UPDATE tbl_CatMarcas SET activo = 0  WHERE id_marca = @id_marca

	COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		ROLLBACK TRANSACTION
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END



































GO
/****** Object:  StoredProcedure [dbo].[CatMarca_Insertar]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





ALTER PROCEDURE [dbo].[CatMarca_Insertar]
		@marca			NVARCHAR(500),
		@usuario		NVARCHAR(100)
AS
BEGIN	
	BEGIN TRANSACTION
	BEGIN TRY	
		SET NOCOUNT ON

		DECLARE @fecha	DATETIME,
				@IDMarca INT = 0
	    SET @fecha = dbo.fnGetNewDate()

		IF NOT EXISTS(SELECT * FROM tbl_CatMarcas WHERE marca = @marca)
		BEGIN
		SET @IDMarca = (SELECT MAX([id_marca]) FROM [dbo].[tbl_CatMarcas] )
		SET @IDMarca = ISNULL(@IDMarca, 0) + 1
			INSERT INTO tbl_CatMarcas 
				([id_marca],
				marca, 
				 usuins, 
				 fecins, 
				 usuupd, 
				 fecupd, 
				 activo)
			VALUES
				(@IDMarca,
				 @marca, 
				 @usuario, 
				 @fecha, 
				 @usuario, 
				 @fecha, 
				 1)
			COMMIT TRANSACTION			
		END
		ELSE
		BEGIN
			SELECT 2 -- Ya existe la marca
		END 		
	END TRY
	BEGIN CATCH          
		-- Control de errores          
		ROLLBACK TRANSACTION
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
	END CATCH 
END


































GO
/****** Object:  StoredProcedure [dbo].[CatMarca_Modificar]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




ALTER PROCEDURE [dbo].[CatMarca_Modificar]
			@id_marca			INT,
			@marca			NVARCHAR(500),
			@usuario		NVARCHAR(100)

AS
BEGIN
	BEGIN TRANSACTION
	BEGIN TRY
		SET NOCOUNT ON


		DECLARE @fecha	DATETIME
    	SET @fecha = dbo.fnGetNewDate()

		IF ((SELECT COUNT(id_marca) FROM tbl_CatMarcas WHERE marca = @marca AND NOT id_marca = @id_marca)= 0)
		BEGIN
			UPDATE tbl_CatMarcas SET
			     marca = @marca,
			     usuupd = @usuario,
			     fecupd = @fecha
			WHERE id_marca = @id_marca
		END
		ELSE
		BEGIN
			SELECT 2 -- Existe un Usuario con el mismo nombre apellido paterno y materno
		END
		
			
	COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		ROLLBACK TRANSACTION
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END

































GO
/****** Object:  StoredProcedure [dbo].[CatMarcas_Combo]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[CatMarcas_Combo]
AS
BEGIN
	BEGIN TRY

		SET NOCOUNT ON

			SELECT 
					id_marca,
					tbl_CatMarcas.marca 
			FROM tbl_CatMarcas WHERE activo = 1
			UNION
			SELECT 
					'0' AS 'id_marca', 
					'-- Seleccionar --' AS 'marca' 
			ORDER BY marca

	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------
	END CATCH
END

































GO
/****** Object:  StoredProcedure [dbo].[CatMotivoCancelaciones_Combo_sp]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER PROCEDURE [dbo].[CatMotivoCancelaciones_Combo_sp]
		@id_tipo      INT
AS
BEGIN
	BEGIN TRY

		SET NOCOUNT ON

		  SELECT 
			   id_motivoCancelacionTransferencia		  
			  ,descripcion
		  FROM tbl_CatMotivoCancelacionesTransferencias
		  WHERE activo = 1 AND id_tipo = @id_tipo
		  UNION
		  SELECT 
				'0' AS 'id_motivoCancelacionTransferencia', 
				'-- Seleccionar --' AS 'descripcion' 
		ORDER BY descripcion

	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------
	END CATCH
END


































GO
/****** Object:  StoredProcedure [dbo].[CatMunicipios_Combo_sp]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[CatMunicipios_Combo_sp]
		@Activo		INT, --Activo = 1
		@id_estado	INT,
		@id_pais	INT
AS
BEGIN
	BEGIN TRY

		SET NOCOUNT ON

		DECLARE
				@MensajeError	VARCHAR(1000)


			SELECT 
					id_municipio AS 'Id', 
					descripcion AS 'Descripcion'
			FROM tbl_CatMunicipios WHERE activo = @Activo AND id_pais = @id_pais AND id_estado = @id_estado
			UNION
			SELECT 
					'0' AS 'Id', 
					'-- Seleccionar --' AS 'Descripcion' 
			ORDER BY descripcion

	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		SELECT @MensajeError	= ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END

























GO
/****** Object:  StoredProcedure [dbo].[CatOcupaciones_Combo_sp]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[CatOcupaciones_Combo_sp]		    
AS
BEGIN	
	
	SELECT  
	      id_ocupacion , ocupacion
	FROM 
		tbl_CatOcupacion 
	WHERE		
		activo = 1 
    
	UNION
	SELECT 
		'0' AS id_ocupacion , 
		'-- Seleccionar --' AS ocupacion 
	ORDER BY ocupacion

END






























GO
/****** Object:  StoredProcedure [dbo].[CatPaises_Combo_sp]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[CatPaises_Combo_sp]
		@Activo INT --Activo = 1
AS
BEGIN
	BEGIN TRY

		SET NOCOUNT ON

		DECLARE @MensajeError	VARCHAR(1000)


			SELECT 
					id_pais AS 'Id', 
					descripcion AS 'Descripcion'
			FROM tbl_CatPaises WHERE activo = @Activo 
			UNION
			SELECT 
					'0' AS 'Id', 
					'-- Seleccionar --' AS 'Descripcion' 
			ORDER BY descripcion

	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		SELECT @MensajeError	= ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END

























GO
/****** Object:  StoredProcedure [dbo].[CatRutas_Combo_sp]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[CatRutas_Combo_sp]
		@Activo INT --Activo = 1
AS
BEGIN
	BEGIN TRY

		SET NOCOUNT ON

		DECLARE @MensajeError	VARCHAR(1000)


		SELECT 
			cr.id_ruta,
			cr.nombre			
		FROM
			tbl_CatRutas as cr			
		WHERE						
			cr.activo = 1
		UNION
			SELECT 
				'' AS 'id_ruta', 
				'-- Seleccione --' AS 'nombre'				
		ORDER BY id_ruta



	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		SELECT @MensajeError	= ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END


























GO
/****** Object:  StoredProcedure [dbo].[CatSubMarca_Eliminar]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[CatSubMarca_Eliminar]
			@id_submarca	INT
AS
BEGIN
	BEGIN TRANSACTION
	BEGIN TRY

		SET NOCOUNT ON

			UPDATE tbl_CatSubMarcas SET activo = 0  WHERE id_submarca = @id_submarca

	COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		ROLLBACK TRANSACTION
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END


































GO
/****** Object:  StoredProcedure [dbo].[CatSubMarca_Insertar]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





ALTER PROCEDURE [dbo].[CatSubMarca_Insertar]
		@submarca			NVARCHAR(500),
		@id_marca		INT,
		@usuario		NVARCHAR(100)
AS
BEGIN	
	BEGIN TRANSACTION
	BEGIN TRY	
		SET NOCOUNT ON

		DECLARE @fecha	DATETIME,
				@IDSubmarca INT = 0
    	SET @fecha = dbo.fnGetNewDate()

		IF NOT EXISTS(SELECT id_submarca FROM tbl_CatSubMarcas WHERE submarca = @submarca)
		BEGIN
			SET @IDSubmarca = (SELECT MAX([id_submarca]) FROM [dbo].[tbl_CatSubMarcas])
			SET @IDSubmarca = ISNULL(@IDSubmarca, 0) + 1
			INSERT INTO tbl_CatSubMarcas 
						([id_submarca],
						id_marca, 
						submarca, 
						usuins, 
						fecins, 
						usuupd, 
						fecupd, 
						activo)
			VALUES
						(@IDSubmarca,
						@id_marca, 
						@submarca, 
						@usuario, 
						@fecha, 
						@usuario,
						@fecha, 
						1)
			COMMIT TRANSACTION			
		END
		ELSE
		BEGIN
			SELECT 2 -- Ya existe la marca
		END 		
	END TRY
	BEGIN CATCH                
		ROLLBACK TRANSACTION
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
	END CATCH 
END


































GO
/****** Object:  StoredProcedure [dbo].[CatSubMarca_Modificar]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




ALTER PROCEDURE [dbo].[CatSubMarca_Modificar]
			@id_submarca	INT,
			@submarca	    NVARCHAR(500),
			@id_marca		INT,
			@usuario		NVARCHAR(100)

AS
BEGIN
	BEGIN TRANSACTION
	BEGIN TRY

		SET NOCOUNT ON

		DECLARE @fecha	DATETIME
	    SET @fecha = dbo.fnGetNewDate()

		IF ((SELECT COUNT(id_submarca) FROM tbl_CatSubMarcas WHERE submarca = @submarca AND NOT id_submarca = @id_submarca) = 0)
		BEGIN
			UPDATE tbl_CatSubMarcas SET
			     submarca = @submarca,
			     id_marca = @id_marca,
			     usuupd = @usuario,
			     fecupd = @fecha
			WHERE id_submarca = @id_submarca
		END
		ELSE
		BEGIN
			SELECT 2 -- Existe un Usuario con el mismo nombre apellido paterno y materno
		END
		
			
	COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		ROLLBACK TRANSACTION
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END

































GO
/****** Object:  StoredProcedure [dbo].[CatSucursales_Combo_sp]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[CatSucursales_Combo_sp]
AS
BEGIN
	BEGIN TRY

		SET NOCOUNT ON


			SELECT 
				id_sucursal, 
				Nombre_Sucursal
			FROM tbl_CatSucursales WHERE activo = 1
			UNION
			SELECT 
				'0' AS 'id_sucursal', 
				'-- Seleccionar --' AS 'Nombre_Sucursal ' 
			ORDER BY Nombre_Sucursal

	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------
	END CATCH
END
































GO
/****** Object:  StoredProcedure [dbo].[CatTerminales_Combo_sp]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[CatTerminales_Combo_sp]
		@Activo			INT, --Activo = 1
		@id_terminal	NVARCHAR(100)
AS
BEGIN
	BEGIN TRY

		SET NOCOUNT ON

		DECLARE @MensajeError	VARCHAR(1000)

			SELECT 
				ct.id_terminal,
				ct.nombre
			FROM 
				tbl_CatTerminales as ct
			WHERE 
				ct.activo = @Activo AND 
				ct.id_terminal NOT IN (@id_terminal)
			UNION
			SELECT 
				'' AS 'id_terminal', 
				'-- Seleccionar --' AS 'nombre' 
			ORDER BY nombre

	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		SELECT @MensajeError	= ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END

























GO
/****** Object:  StoredProcedure [dbo].[CatTipoCamion_Eliminar]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[CatTipoCamion_Eliminar]
			@id_tipocamion	INT
AS
BEGIN
	BEGIN TRANSACTION
	BEGIN TRY

		SET NOCOUNT ON

			UPDATE tbl_CatTipoCamion SET activo = 0  WHERE id_tipocamion = @id_tipocamion

	COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		ROLLBACK TRANSACTION
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END


































GO
/****** Object:  StoredProcedure [dbo].[CatTipoCamion_Insertar]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




ALTER PROCEDURE [dbo].[CatTipoCamion_Insertar]
		@tipocamion			NVARCHAR(250),
		@maximoDescuento    MONEY,
		@usuario		    NVARCHAR(100)
AS
BEGIN	
	BEGIN TRANSACTION
	BEGIN TRY	
		SET NOCOUNT ON
		
	   DECLARE @fecha	DATETIME
	   SET @fecha = dbo.fnGetNewDate()

		IF NOT EXISTS(SELECT id_tipoCamion FROM tbl_CatTipoCamion WHERE tipoCamion = @tipocamion)
		BEGIN
			INSERT INTO tbl_CatTipoCamion
				(tipoCamion, 
				 maximoDescuentoLinea,
				 usuins, 
				 fecins, 
				 usuupd, 
				 fecupd, 
				 activo)
			VALUES
				(@tipocamion, 
				@maximoDescuento, 
				@usuario, 
				@fecha, 
				@usuario, 
				@fecha, 
				1)
			COMMIT TRANSACTION			
		END
		ELSE
		BEGIN
			SELECT 2 -- Ya existe la marca
		END 		
	END TRY
	BEGIN CATCH          
		-- Control de errores          
		ROLLBACK TRANSACTION
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
	END CATCH 
END



































GO
/****** Object:  StoredProcedure [dbo].[CatTipoCamion_Modificar]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




ALTER PROCEDURE [dbo].[CatTipoCamion_Modificar]
			@id_tipocamion			INT,
			@tipocamion			NVARCHAR(250),
			@maximoDescuento    MONEY,
			@usuario		NVARCHAR(100)

AS
BEGIN
	BEGIN TRANSACTION
	BEGIN TRY

		SET NOCOUNT ON

	   DECLARE @fecha	DATETIME
	   SET @fecha = dbo.fnGetNewDate()

		IF ((SELECT COUNT(id_tipoCamion) FROM tbl_CatTipoCamion WHERE tipoCamion = @tipocamion AND NOT id_tipoCamion = @id_tipocamion)= 0)
		BEGIN
			UPDATE tbl_CatTipoCamion SET
			     tipoCamion = @tipocamion,
				 maximoDescuentoLinea = @maximoDescuento,
			     usuupd = @usuario,
			     fecupd = @fecha
			WHERE id_tipoCamion = @id_tipoCamion
		END
		ELSE
		BEGIN
			SELECT 2 -- Existe un Usuario con el mismo nombre apellido paterno y materno
		END
		
			
	COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		ROLLBACK TRANSACTION
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END



































GO
/****** Object:  StoredProcedure [dbo].[CatTipoUsuario_Combo_sp]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[CatTipoUsuario_Combo_sp]
AS
BEGIN
	BEGIN TRY

		SET NOCOUNT ON

			SELECT 
					Id_Tu,  
					tbl_CatTipoUsuario.Tu_Desccripcion 
			FROM tbl_CatTipoUsuario WHERE Tu_Activo = 1
			UNION
			SELECT 
					'0' AS 'Id_Tu', 
					'-- Seleccionar --' AS 'Tu_Desccripcion ' 
			ORDER BY Tu_Desccripcion

	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------
	END CATCH
END































GO
/****** Object:  StoredProcedure [dbo].[CatTurno_Combo_sp]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[CatTurno_Combo_sp]
AS
BEGIN
	BEGIN TRY

		SET NOCOUNT ON

			SELECT 
					Id_Turno,  
					Turno
			FROM tbl_CatTurno WHERE activo = 1
			UNION
			SELECT 
					'0' AS 'Id_Turno', 
					'-- Seleccionar --' AS 'Turno ' 
			ORDER BY Turno

	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------
	END CATCH
END































GO
/****** Object:  StoredProcedure [dbo].[CatUsuario_Consulta_sp]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[CatUsuario_Consulta_sp]
AS
BEGIN
	BEGIN TRY

		SET NOCOUNT ON

			SELECT 
					CU.U_Nombre + ' ' + CU.U_Apellidop + ' ' + CU.U_Apellidom AS NombreCompleto,
					CU.U_Nombre,
					CU.U_Apellidop,
					CU.U_Apellidom,
					CU.U_DirCalle,
					CU.U_DirColonia,
					CU.U_DirNumero,
					CU.U_FechaNac,
					CAST(CU.U_FechaNac AS date) AS U_FechaNac_Short,
					CUC.Cu_User,
					CTU.Tu_Desccripcion as Tu_Descripcion,
					CS.Nombre_Sucursal,
					CUC.Cu_Pass,
					CU.Id_Tu,
					CU.Id_U,
					CU.id_sucursal,
					CU.Id_Turno,
					CTUR.Turno								
			FROM tbl_CatUsuario AS CU JOIN tbl_CatUsuarioCuenta AS CUC
			ON CU.Id_U = CUC.Id_U  JOIN tbl_CatTipoUsuario AS CTU 
			ON CTU.Id_Tu = CU.Id_Tu JOIN tbl_CatSucursales AS CS 
			ON CS.id_sucursal = CU.id_sucursal JOIN tbl_CatTurno as CTUR
			ON CU.Id_Turno = CTUR.Id_Turno
			WHERE CU.U_Activo = 1 
			ORDER BY CU.U_Nombre + ' ' + CU.U_Apellidop + ' ' + CU.U_Apellidom
			
	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END
































GO
/****** Object:  StoredProcedure [dbo].[CatUsuario_Eliminar_sp]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[CatUsuario_Eliminar_sp]
			@Id_U			NVARCHAR(100)
AS
BEGIN
	BEGIN TRANSACTION
	BEGIN TRY

		SET NOCOUNT ON

			UPDATE tbl_CatUsuario SET U_Activo = 0  WHERE Id_U = @Id_U
			
	COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		ROLLBACK TRANSACTION
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END
































GO
/****** Object:  StoredProcedure [dbo].[CatUsuario_Insertar_sp]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





ALTER PROCEDURE [dbo].[CatUsuario_Insertar_sp]
		@Id_U			NVARCHAR(100),
		@Id_Tu			INT,
		@id_sucursal	NVARCHAR(100),
		@U_Nombre		NVARCHAR(100),
		@U_Apellidop	NVARCHAR(50),
		@U_Apellidom	NVARCHAR(50),
		@U_FechaNac		DATETIME,
		@U_DirCalle		NVARCHAR(90),
		@U_DirColonia	NVARCHAR(50),
		@U_DirNumero	NVARCHAR(15),
		@Cu_User		NVARCHAR(15),
		@Cu_Pass		NVARCHAR(32),
		@Turno          INT
AS
BEGIN	
	BEGIN TRANSACTION
	BEGIN TRY	
		SET NOCOUNT ON

		DECLARE @fecha	DATETIME
	    SET @fecha = dbo.fnGetNewDate()

		DECLARE @NEWId_U	INT
		
		IF NOT EXISTS(SELECT Id_U FROM tbl_CatUsuario WHERE U_Nombre = @U_Nombre AND U_Apellidop = @U_Apellidop AND U_Apellidom = @U_Apellidom)
		BEGIN
			IF NOT EXISTS(SELECT Id_U FROM tbl_CatUsuarioCuenta WHERE Cu_User = @Cu_User )
			BEGIN			
				SELECT @NEWId_U =  ISNULL(MAX(Id_U),0) FROM tbl_CatUsuario									
				SET @NEWId_U = @NEWId_U + 1
				SET IDENTITY_INSERT tbl_CatUsuario ON
				INSERT INTO tbl_CatUsuario
					   (Id_U
					   ,Id_Tu
					   ,id_sucursal
					   ,U_Nombre
					   ,U_Apellidop
					   ,U_Apellidom
					   ,U_FechaNac
					   ,U_DirCalle
					   ,U_DirColonia
					   ,U_DirNumero
					   ,U_Activo
					   ,U_usuins
					   ,U_fecins
					   ,U_usuupd
					   ,U_fecupd
					   ,Id_Turno
					   )
				 VALUES
					   (@NEWId_U
					   ,@Id_Tu
					   ,@id_sucursal
					   ,@U_Nombre
					   ,@U_Apellidop
					   ,@U_Apellidom
					   ,@U_FechaNac
					   ,@U_DirCalle
					   ,@U_DirColonia
					   ,@U_DirNumero
					   ,1
					   ,@Id_U
					   ,@fecha
					   ,@Id_U
					   ,@fecha
					   ,@Turno
					   )
				SET IDENTITY_INSERT tbl_CatUsuario OFF
				INSERT INTO tbl_CatUsuarioCuenta
					   (Id_U
					   ,Cu_User
					   ,Cu_Pass
					   ,Cu_ConInt
					   ,Cu_Estatus
					   ,Cu_FBloq
					   ,Cu_FCaducidad
					   ,Cu_usuins
					   ,Cu_fecins
					   ,Cu_usuupd
					   ,Cu_fecupd)
				 VALUES
					   (@NEWId_U
					   ,@Cu_User
					   ,HASHBYTES('SHA1', @Cu_Pass)
					   ,1
					   ,1
					   ,CAST(@fecha AS SMALLDATETIME) ----DATEADD(YEAR ,200, GETDATE())
					   ,CAST(@fecha AS SMALLDATETIME) --DATEADD(YEAR ,200, GETDATE())
					   ,@Id_U
					   ,@fecha
					   ,@Id_U
					   ,@fecha)
				
				INSERT INTO tbl_CatUsuarioXSuc
					   (Id_U
					   ,id_sucursal
					   ,UXSuc_usuins
					   ,UXSuc_fecins
					   ,UXSuc_usuupd
					   ,UXSuc_fecupd)
				VALUES
					   (@NEWId_U
					   ,@id_sucursal
					   ,@Id_U
					   ,@fecha
					   ,@Id_U
					   ,@fecha)
					   
					   COMMIT TRANSACTION			
			END
			ELSE
			BEGIN
				SELECT 3 -- Existe ese usuario
			END
		END
		ELSE
		BEGIN
			SELECT 2 -- Existe una Usuario con el mismo nombre y apellidos
		END  		
	END TRY
	BEGIN CATCH          
		-- Control de errores          
		ROLLBACK TRANSACTION
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
	END CATCH 
END

































GO
/****** Object:  StoredProcedure [dbo].[CatUsuario_Modificar_sp]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER PROCEDURE [dbo].[CatUsuario_Modificar_sp]		
			@Id_U			NVARCHAR(100),
			@Id_Tu			INT,
			@id_sucursal	NVARCHAR(100),
			@U_Nombre		NVARCHAR(100),
			@U_Apellidop	NVARCHAR(50),
			@U_Apellidom	NVARCHAR(50),
			@U_FechaNac		DATETIME,
			@U_DirCalle		NVARCHAR(90),
			@U_DirColonia	NVARCHAR(50),
			@U_DirNumero	NVARCHAR(15),
			@Cu_User		NVARCHAR(15),
			@Cu_Pass		NVARCHAR(32),
			@Id_UModifico	NVARCHAR(100),
			@IdTurno  		INT,
			@BanPass        INT

AS
BEGIN
	BEGIN TRANSACTION
	BEGIN TRY

		SET NOCOUNT ON

		-- ------------------------ --
		-- Declaración de variables --
		-- ------------------------ --
		DECLARE @Id_UXSuc INT
	    DECLARE @fecha	DATETIME
	    SET @fecha = dbo.fnGetNewDate()

		IF ((SELECT COUNT(Id_U) FROM tbl_CatUsuario WHERE U_Nombre = @U_Nombre AND U_Apellidop = @U_Apellidop AND U_Apellidom = @U_Apellidom AND Id_U != @Id_U)=0)
		BEGIN
			IF ((SELECT COUNT(Id_U) FROM tbl_CatUsuarioCuenta WHERE Cu_User = @Cu_User AND Id_U != @Id_U)=0)
			BEGIN
				UPDATE tbl_CatUsuario SET
				     Id_Tu = @Id_Tu,
					 U_Nombre = @U_Nombre,
					 U_Apellidop = @U_Apellidop,
					 U_Apellidom = @U_Apellidom,
					 U_DirCalle = @U_DirCalle,
					 U_DirColonia = @U_DirColonia,
					 U_DirNumero = @U_DirNumero,
					 U_FechaNac	= @U_FechaNac,
					 U_usuupd = @Id_UModifico,
					 U_fecupd = @fecha,
					 Id_Turno = @IdTurno,
					 id_sucursal = @id_sucursal
				WHERE Id_U	= @Id_U

				SET @Id_UXSuc = (SELECT Id_UXSuc FROM tbl_CatUsuarioXSuc WHERE Id_U = @Id_U) 

					UPDATE tbl_CatUsuarioXSuc SET 
						   id_sucursal = @id_sucursal,
						   UXSuc_usuupd = @Id_UModifico,
						   UXSuc_fecupd =  @fecha 
					WHERE Id_UXSuc = @Id_UXSuc
				
				IF(@BanPass=1)
				BEGIN
				UPDATE tbl_CatUsuarioCuenta SET
					 Cu_User = @Cu_User,
					 Cu_Pass = HASHBYTES('SHA1', @Cu_Pass),
					 Cu_usuupd = @Id_UModifico,
					 Cu_fecupd = @fecha
				WHERE Id_U	= @Id_U
				END
				ELSE if (@BanPass=0)
				BEGIN
				UPDATE tbl_CatUsuarioCuenta SET
					 Cu_User = @Cu_User,
					 Cu_usuupd = @Id_UModifico,
					 Cu_fecupd = @fecha
				WHERE Id_U	= @Id_U
				END


			END
			ELSE
			BEGIN
				SELECT 3 -- Existe ese usuario
			END	    
		END
		ELSE
		BEGIN
			SELECT 2 -- Existe un Usuario con el mismo nombre apellido paterno y materno
		END
		
			
	COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		ROLLBACK TRANSACTION
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END































GO
/****** Object:  StoredProcedure [dbo].[CatUsuario_ModificarContraseña_sp]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER PROCEDURE [dbo].[CatUsuario_ModificarContraseña_sp]		
			@Cu_User		NVARCHAR(15),
			@Cu_Pass		NVARCHAR(32)

AS
BEGIN
	BEGIN TRANSACTION
	BEGIN TRY

		SET NOCOUNT ON

		DECLARE @fecha	DATETIME
	    SET @fecha = dbo.fnGetNewDate()

				UPDATE tbl_CatUsuarioCuenta SET
					 Cu_Pass = HASHBYTES('SHA1', @Cu_Pass),
					 Cu_fecupd = @fecha
				WHERE Cu_User = @Cu_User
		
	COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		ROLLBACK TRANSACTION
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END































GO
/****** Object:  StoredProcedure [dbo].[CatUsuarioAdministrador_Consultar_sp]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[CatUsuarioAdministrador_Consultar_sp]
		@Cu_User		NVARCHAR(15),
		@Cu_Pass		NVARCHAR(32)
		
AS
BEGIN	
	BEGIN TRANSACTION
	BEGIN TRY	
		SET NOCOUNT ON


	    IF(EXISTS(SELECT tbl_CatUsuarioCuenta.Id_U FROM tbl_CatUsuarioCuenta JOIN tbl_CatUsuario ON tbl_CatUsuarioCuenta.Id_U = tbl_CatUsuario.Id_U WHERE Cu_User = @Cu_User AND Cu_Pass = HASHBYTES('SHA1', @Cu_Pass) AND (tbl_CatUsuario.Id_Tu = 1 OR tbl_CatUsuario.Id_Tu = 3))) 
		BEGIN
            SELECT 1
		END
		ELSE 
		BEGIN
		   SELECT 0
		END


	END TRY
	BEGIN CATCH          
		-- Control de errores          
		ROLLBACK TRANSACTION
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
	END CATCH 
END






























GO
/****** Object:  StoredProcedure [dbo].[CatViajeFecha_Eliminar_sp]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[CatViajeFecha_Eliminar_sp]		
            @IDViajes     NVARCHAR(100)
		   ,@FechaSalida  DATE
		   ,@Usuario      NVARCHAR(100)
AS
BEGIN
	BEGIN TRY

		SET NOCOUNT ON

		
		UPDATE tbl_CatViajesXFecha 
		SET  
		    activo = 0,
			fecupd = dbo.fnGetNewDate(),
			usuupd = @Usuario 
		WHERE tbl_CatViajesXFecha.id_viaje = @IDViajes AND tbl_CatViajesXFecha.fechaviaje = @FechaSalida 
		
		SELECT 1 


	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END

































GO
/****** Object:  StoredProcedure [dbo].[CatViajes_Combo_sp]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[CatViajes_Combo_sp]
		@Activo			INT --Activo = 1		
AS
BEGIN
	BEGIN TRY

		SET NOCOUNT ON

		DECLARE @MensajeError	VARCHAR(1000)

			SELECT 
				cv.id_identificador,
				cv.nombre

			FROM 
				tbl_CatViajes as cv
			WHERE 
				cv.activo = @Activo 
			UNION
			SELECT 
				'' AS 'id_identificador', 
				'-- Seleccionar --' AS 'nombre' 
			ORDER BY nombre

	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		SELECT @MensajeError	= ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END

























GO
/****** Object:  StoredProcedure [dbo].[CierreCaja_Modificar_sp]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[CierreCaja_Modificar_sp]
		@id_caja		NVARCHAR(100)
		,@id_sucursal	NVARCHAR(100)
		,@M50C			INT	
        ,@M1P			INT
        ,@M2P			INT
        ,@M5P			INT
        ,@M10P			INT
		,@M20P			INT
        ,@M100P			INT
        ,@B20P			INT
        ,@B50P			INT
        ,@B100P			INT
        ,@B200P			INT
        ,@B500P			INT
        ,@B1000P		INT
        ,@Total			FLOAT
		,@Id_U			NVARCHAR(100)
		,@FechaCierre	DATE
		,@HoraCierre	NVARCHAR(10)
AS
BEGIN
	BEGIN TRANSACTION
	BEGIN TRY
		
		SET NOCOUNT ON

	DECLARE @FECHA DATETIME = (dbo.fnGetNewDate())
   	SET @FechaCierre = @FECHA
	SET @HoraCierre = CONVERT(NVARCHAR(10), @FECHA, 108)

	 INSERT INTO tbl_EfectivoXCaja
           (Id_cajaXSucursal
		   ,id_sucursal
           ,id_tipoEfectivo
           ,M50C
           ,M1P
           ,M2P
           ,M5P
           ,M10P
           ,M20P
           ,M100P
           ,B20P
           ,B50P
           ,B100P
           ,B200P
           ,B500P
           ,B1000P
           ,Total
           ,activo
           ,usuins
           ,fecins
           ,usuupd
           ,fecupd)
     VALUES
           (@id_caja
		   ,@id_sucursal
           ,2
           ,@M50C
           ,@M1P
           ,@M2P
           ,@M5P
           ,@M10P
		   ,@M20P
		   ,@M100P
		   ,@B20P
		   ,@B50P
		   ,@B100P
		   ,@B200P
           ,@B500P
		   ,@B1000P
		   ,@Total
           ,1
           ,@Id_U
           ,@FECHA
           ,@Id_U
           ,@FECHA)

	 UPDATE tbl_CajaXSucursal 
	 SET 
		 fecha_cierre = @FechaCierre, 
		 hora_cierre = @HoraCierre, 
		 caja_final = @Total, 
		 id_statusCaja = 2,
		 usuupd = @Id_U,
		 fecupd = @FECHA
	WHERE id_cajaXSucursal = @id_caja
		

	COMMIT TRANSACTION			
	END TRY
	BEGIN CATCH          
		-- Control de errores          
		ROLLBACK TRANSACTION
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
	END CATCH 
END


















GO
/****** Object:  StoredProcedure [dbo].[CodigoCliente_Verficar_sp]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[CodigoCliente_Verficar_sp]		
                @idCodigEab      NVARCHAR(100)

AS
BEGIN
	BEGIN TRY

		SET NOCOUNT ON

		IF((SELECT COUNT(id_codigoEab)  FROM tbl_CatCredenciales WHERE id_codigoEab = @idCodigEab) > 0)
		        SELECT 1
		ELSE
		        SELECT 0 
				 
	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END

































GO
/****** Object:  StoredProcedure [dbo].[Consultar_Boletos_sp]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






ALTER PROCEDURE [dbo].[Consultar_Boletos_sp] 
	 @fecha				DATETIME
	,@nombre			NVARCHAR(150)
	,@folio				NVARCHAR(15)
	,@folioVenta		NVARCHAR(15)
	,@bandfecha			BIT
	,@bandnombre		BIT
	,@bandfolio			BIT
	,@bandfolioVenta	BIT
AS
BEGIN		
	SET NOCOUNT ON
	
	DECLARE					
		@Query		NVARCHAR(MAX)
	SET LANGUAGE 'español';

	SET @Query = '	SELECT TOP 10
						tb.id_boleto,
						vd.id_ventadetalle,
						tb.CodigoBarra,
						tbl_CatViajes.nombre AS nombreViaje,
						tb.costo as boletocosto,	
						tb.fecha_salidaV,
						tb.hora_salidaV,
						tb.NombrePersona,
						tb.numeroTelefono,
						tb.asiento,
						vd.cantidad_venta,
						vd.costo as vdcosto,
						vd.descuento,
						vd.iva,
						vd.precio,
						vd.id_venta,
					   (vd.pago1 + vd.pago2) as pago,
						CASE 
						   WHEN vd.costo  - (vd.pago1 + vd.pago2) <= 0  THEN 0
						   WHEN vd.costo  - (vd.pago1 + vd.pago2)  >  0  THEN vd.costo  - (vd.pago1 + vd.pago2)    
						   END
						   as pendiente,
						v.id_cliente,
					   CASE 
						   WHEN tb.id_boletoTransferencia = '''' THEN  0 
						   WHEN tb.id_boletoTransferencia != ''''  THEN  1     
					   END 
					   as Transf,
			           TerminalSalida.nombre AS origen,
			           TerminalDestino.nombre AS destino,
					   ucins.Cu_User AS usuins,
					   ucupd.Cu_User AS usuupd,
					   [dbo].[BloqueoCancelacionPorMonedero](v.id_venta) bloqueoCancelacionMonedero,
					   [dbo].[BloqueoCancelacionPorFormaDePago](v.id_venta) bloqueoCancelacionPorFormaDePago,
					   v.folio AS folioVenta,
					   tb.fechaNacimiento
					FROM
						tbl_Boletos AS tb 
						JOIN tbl_VentaDetalle AS vd ON tb.id_boleto = vd.id_boleto
						JOIN tbl_Venta AS v ON v.id_venta = vd.id_venta
						JOIN tbl_CatViajes  ON tb.id_viaje = tbl_CatViajes.id_identificador
						JOIN dbo.tbl_CatTerminalesXRuta ON dbo.tbl_CatViajes.id_ruta = dbo.tbl_CatTerminalesXRuta.id_ruta 
						JOIN dbo.tbl_CatRutas ON dbo.tbl_CatViajes.id_ruta = dbo.tbl_CatRutas.id_ruta 
						JOIN dbo.tbl_CatTerminales AS TerminalSalida ON dbo.tbl_CatTerminalesXRuta.id_terminalSalida = TerminalSalida.id_terminal 
						JOIN dbo.tbl_CatTerminales AS TerminalDestino ON dbo.tbl_CatTerminalesXRuta.id_terminalDestino = TerminalDestino.id_terminal 
						JOIN dbo.tbl_OrdenRuta AS OrdenRutaOrigen ON dbo.tbl_CatTerminalesXRuta.id_terminalSalida = OrdenRutaOrigen.id_terminal AND dbo.tbl_CatTerminalesXRuta.id_ruta = OrdenRutaOrigen.id_ruta AND tb.OrdenOrigenTerminal =  OrdenRutaOrigen.orden 
					    JOIN dbo.tbl_OrdenRuta AS OrdenRutaDestino ON dbo.tbl_CatTerminalesXRuta.id_ruta = OrdenRutaDestino.id_ruta AND dbo.tbl_CatTerminalesXRuta.id_terminalDestino = OrdenRutaDestino.id_terminal AND tb.OrdenDestinoTerminal = OrdenRutaDestino.orden
					    JOIN tbl_CatUsuarioCuenta AS ucins ON ucins.Id_U = vd.usuins
						JOIN tbl_CatUsuarioCuenta AS ucupd ON ucupd.Id_U = vd.usuupd
					WHERE
						vd.activo = 1
						AND tb.activo = 1
						ANd tb.id_status = 3							
				'
				
	IF @bandfolioVenta = 1
		SET @Query = @Query + ' AND v.folio LIKE ''%'+ CONVERT(NVARCHAR(15), @folioVenta) + '%'''															
	IF @bandfecha = 1	
		SET @Query = @Query + ' AND CONVERT(DATE, tb.fecha_salida) = CONVERT(DATE,@fecha)'
	IF @bandnombre = 1	
		SET @Query = @Query + ' AND tb.NombrePersona LIKE ''%'+ CONVERT(NVARCHAR(150), @nombre) + '%'''
	IF @bandfolio = 1
		SET @Query = @Query + ' AND tb.CodigoBarra LIKE ''%'+ CONVERT(NVARCHAR(15), @folio) + '%'''

	IF @bandfecha = 0 AND @bandfolio = 0 AND @bandnombre = 0
		SET @Query = @Query + ' AND 1 < 0 '


    SET @Query = @Query + ' ORDER BY tb.fecins '

	DECLARE @PARAMETROS NVARCHAR(MAX)
	SET @PARAMETROS = N'@fecha DATETIME';		
	EXEC SP_EXECUTESQL @Query, @PARAMETROS, @fecha

END



































GO
/****** Object:  StoredProcedure [dbo].[Consultar_BoletosApartados_sp]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





ALTER PROCEDURE [dbo].[Consultar_BoletosApartados_sp] 
	 @fecha				DATETIME
	,@nombre			NVARCHAR(150)
	,@folio				NVARCHAR(15)
	,@folioVenta		NVARCHAR(15)
	,@bandfecha			BIT
	,@bandnombre		BIT
	,@bandfolio			BIT
	,@bandfolioVenta	BIT
AS
BEGIN		
	SET NOCOUNT ON
	DECLARE					
		@Query						NVARCHAR(MAX)
			
	SET LANGUAGE 'español';
	

	SET @Query = '	SELECT TOP 10
						tb.id_boleto,
						vd.id_ventadetalle,
						tb.CodigoBarra,
						tbl_CatViajes.nombre AS nombreViaje,
						tb.costo as boletocosto,	
						tb.fecha_salidaV,
						tb.hora_salidaV,
						tb.NombrePersona,
						tb.numeroTelefono,
						tb.asiento,
						vd.cantidad_venta,
						vd.costo as vdcosto,
						vd.descuento,
						vd.iva,
						vd.precio,
						vd.id_venta,
					   (vd.pago1 + vd.pago2) as pago,
						CASE 
						   WHEN vd.costo  - (vd.pago1 + vd.pago2) <= 0  THEN 0
						   WHEN vd.costo  - (vd.pago1 + vd.pago2)  >  0  THEN vd.costo  - (vd.pago1 + vd.pago2)    
						   END
						   as pendiente,
						v.id_cliente,
					   CASE 
						   WHEN tb.id_boletoTransferencia = '''' THEN  0 
						   WHEN tb.id_boletoTransferencia != ''''  THEN  1     
					   END 
					   as Transf,
			           TerminalSalida.nombre AS origen,
			           TerminalDestino.nombre AS destino,
					   ucins.Cu_User AS usuins,
					   ucupd.Cu_User AS usuupd,
					   [dbo].[BloqueoCancelacionPorMonedero](v.id_venta) bloqueoCancelacionMonedero,
					   [dbo].[BloqueoCancelacionPorFormaDePago](v.id_venta) bloqueoCancelacionPorFormaDePago,
					   v.folio AS folioVenta,
					   tb.fechaNacimiento
					FROM
						tbl_Boletos AS tb 
						JOIN tbl_VentaDetalle AS vd ON tb.id_boleto = vd.id_boleto
						JOIN tbl_Venta AS v ON v.id_venta = vd.id_venta
						JOIN tbl_CatViajes  ON tb.id_viaje = tbl_CatViajes.id_identificador
						JOIN dbo.tbl_CatTerminalesXRuta ON dbo.tbl_CatViajes.id_ruta = dbo.tbl_CatTerminalesXRuta.id_ruta 
						JOIN dbo.tbl_CatRutas ON dbo.tbl_CatViajes.id_ruta = dbo.tbl_CatRutas.id_ruta 
						JOIN dbo.tbl_CatTerminales AS TerminalSalida ON dbo.tbl_CatTerminalesXRuta.id_terminalSalida = TerminalSalida.id_terminal 
						JOIN dbo.tbl_CatTerminales AS TerminalDestino ON dbo.tbl_CatTerminalesXRuta.id_terminalDestino = TerminalDestino.id_terminal 
						JOIN dbo.tbl_OrdenRuta AS OrdenRutaOrigen ON dbo.tbl_CatTerminalesXRuta.id_terminalSalida = OrdenRutaOrigen.id_terminal AND dbo.tbl_CatTerminalesXRuta.id_ruta = OrdenRutaOrigen.id_ruta AND tb.OrdenOrigenTerminal =  OrdenRutaOrigen.orden 
					    JOIN dbo.tbl_OrdenRuta AS OrdenRutaDestino ON dbo.tbl_CatTerminalesXRuta.id_ruta = OrdenRutaDestino.id_ruta AND dbo.tbl_CatTerminalesXRuta.id_terminalDestino = OrdenRutaDestino.id_terminal AND tb.OrdenDestinoTerminal = OrdenRutaDestino.orden
					    JOIN tbl_CatUsuarioCuenta AS ucins ON ucins.Id_U = vd.usuins
						JOIN tbl_CatUsuarioCuenta AS ucupd ON ucupd.Id_U = vd.usuupd
					WHERE
						vd.activo = 1
						AND tb.activo = 1	
						AND tb.id_status = 2					
				'	
	IF @bandfolioVenta = 1
		SET @Query = @Query + ' AND v.folio LIKE ''%'+ CONVERT(NVARCHAR(15), @folioVenta) + '%'''														
	IF @bandfecha = 1	
		SET @Query = @Query + ' AND CONVERT(DATE, tb.fecha_salida) = CONVERT(DATE,@fecha)'
	IF @bandnombre = 1	
		SET @Query = @Query + ' AND tb.NombrePersona LIKE ''%'+ CONVERT(NVARCHAR(150), @nombre) + '%'''
	IF @bandfolio = 1
		SET @Query = @Query + ' AND tb.CodigoBarra LIKE ''%'+ CONVERT(NVARCHAR(15), @folio) + '%'''

	IF @bandfecha = 0 AND @bandfolio = 0 AND @bandnombre = 0
		SET @Query = @Query + ' AND 1 < 0 '

    SET @Query = @Query + ' ORDER BY tb.fecins '

	DECLARE @PARAMETROS NVARCHAR(MAX)
	SET @PARAMETROS = N'@fecha DATETIME';		
	EXEC SP_EXECUTESQL @Query, @PARAMETROS, @fecha

END
































GO
/****** Object:  StoredProcedure [dbo].[Consultar_BoletosCambio_sp]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER PROCEDURE [dbo].[Consultar_BoletosCambio_sp] 
	 @fecha				DATETIME
	,@nombre			NVARCHAR(150)
	,@folio				NVARCHAR(15)
	,@bandfecha			BIT
	,@bandnombre		BIT
	,@bandfolio			BIT
AS
BEGIN		
	SET NOCOUNT ON
	DECLARE					
		@Query						NVARCHAR(MAX)

	DECLARE @FechaSistema DATETIME
	SET @FechaSistema = [dbo].[fnGetNewDate]()
		
	SET LANGUAGE 'español';
	
	SET @Query = '	SELECT TOP 10
						tb.id_boleto,
						vd.id_ventadetalle,
						tb.CodigoBarra,
						tbl_CatViajes.nombre AS nombreViaje,
						tb.costo as boletocosto,	
						tb.fecha_salidaV,
						tb.hora_salidaV,
						tb.NombrePersona,
						tb.numeroTelefono,
						tb.asiento,
						vd.cantidad_venta,
						vd.costo as vdcosto,
						vd.descuento,
						vd.iva,
						vd.precio,
						vd.id_venta,
					   (vd.pago1 + vd.pago2) as pago,
						CASE 
						   WHEN vd.costo  - (vd.pago1 + vd.pago2) <= 0  THEN 0
						   WHEN vd.costo  - (vd.pago1 + vd.pago2)  >  0  THEN vd.costo  - (vd.pago1 + vd.pago2)    
						   END
						   as pendiente,
						v.id_cliente,
					   CASE 
						   WHEN tb.id_boletoTransferencia = '''' THEN  0 
						   WHEN tb.id_boletoTransferencia != ''''  THEN  1     
					   END 
					   as Transf,
			           TerminalSalida.nombre AS origen,
			           TerminalDestino.nombre AS destino,
					   ucins.Cu_User AS usuins,
					   ucupd.Cu_User AS usuupd,
					   [dbo].[BloqueoCancelacionPorMonedero](v.id_venta) bloqueoCancelacionMonedero,
					   [dbo].[BloqueoTransferencia24Horas](@FechaSistema, CONVERT(DATETIME,CONVERT(NVARCHAR(10),fecha_salidaV,103) + '' '' +hora_salidaV)) bloqueoTransferencia24Horas
					FROM
						tbl_Boletos AS tb 
						JOIN tbl_VentaDetalle AS vd ON tb.id_boleto = vd.id_boleto
						JOIN tbl_Venta AS v ON v.id_venta = vd.id_venta
						JOIN tbl_CatViajes  ON tb.id_viaje = tbl_CatViajes.id_identificador
						JOIN dbo.tbl_CatTerminalesXRuta ON dbo.tbl_CatViajes.id_ruta = dbo.tbl_CatTerminalesXRuta.id_ruta 
						JOIN dbo.tbl_CatRutas ON dbo.tbl_CatViajes.id_ruta = dbo.tbl_CatRutas.id_ruta 
						JOIN dbo.tbl_CatTerminales AS TerminalSalida ON dbo.tbl_CatTerminalesXRuta.id_terminalSalida = TerminalSalida.id_terminal 
						JOIN dbo.tbl_CatTerminales AS TerminalDestino ON dbo.tbl_CatTerminalesXRuta.id_terminalDestino = TerminalDestino.id_terminal 
						JOIN dbo.tbl_OrdenRuta AS OrdenRutaOrigen ON dbo.tbl_CatTerminalesXRuta.id_terminalSalida = OrdenRutaOrigen.id_terminal AND dbo.tbl_CatTerminalesXRuta.id_ruta = OrdenRutaOrigen.id_ruta AND tb.OrdenOrigenTerminal =  OrdenRutaOrigen.orden 
					    JOIN dbo.tbl_OrdenRuta AS OrdenRutaDestino ON dbo.tbl_CatTerminalesXRuta.id_ruta = OrdenRutaDestino.id_ruta AND dbo.tbl_CatTerminalesXRuta.id_terminalDestino = OrdenRutaDestino.id_terminal AND tb.OrdenDestinoTerminal = OrdenRutaDestino.orden
					    JOIN tbl_CatUsuarioCuenta AS ucins ON ucins.Id_U = vd.usuins
						JOIN tbl_CatUsuarioCuenta AS ucupd ON ucupd.Id_U = vd.usuupd
					WHERE
						vd.activo = 1
						AND tb.activo = 1	
						AND tb.id_status = 3 						
				'	
														
	IF @bandfecha = 1	
		SET @Query = @Query + ' AND CONVERT(DATE, tb.fecha_salida) = CONVERT(DATE,@fecha)'
	IF @bandnombre = 1	
		SET @Query = @Query + ' AND tb.NombrePersona LIKE ''%'+ CONVERT(NVARCHAR(150), @nombre) + '%'''
	IF @bandfolio = 1
		SET @Query = @Query + ' AND tb.CodigoBarra LIKE ''%'+ CONVERT(NVARCHAR(15), @folio) + '%'''

	IF @bandfecha = 0 AND @bandfolio = 0 AND @bandnombre = 0
		SET @Query = @Query + ' AND 1 < 0 '
	DECLARE @PARAMETROS NVARCHAR(MAX)
	SET @PARAMETROS = N'@fecha DATETIME, @FechaSistema DATETIME';		
	EXEC SP_EXECUTESQL @Query, @PARAMETROS, @fecha, @FechaSistema

END






























GO
/****** Object:  StoredProcedure [dbo].[Consultar_Ventas_sp]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





ALTER PROCEDURE [dbo].[Consultar_Ventas_sp] 
	 @fecha				DATETIME
	,@nombre			NVARCHAR(150)
	,@folio				NVARCHAR(15)
	,@bandfecha			BIT
	,@bandnombre		BIT
	,@bandfolio			BIT
AS
BEGIN		
	SET NOCOUNT ON
	DECLARE					
		@Query						NVARCHAR(MAX)
			
	SET LANGUAGE 'español';
	

	SET @Query = '	SELECT TOP 10
	                            tv.id_venta,
								tv.folio,
								CONVERT(DATE,tv.fec_venta) AS fec_venta,
								tv.nombre,
								tv.numeroTelefono,
								tv.fechaNacimiento,
								tv.total,
								tv.pendiente,
								IIF(tv.pendiente > 0, ''Pendiente'',''Pagado'') AS status,
								ucins.Cu_User AS usuins,
								ucupd.Cu_User AS usuupd,
								[dbo].[BloqueoCancelacionPorMonedero](tv.id_venta) bloqueoCancelacionMonedero,
								[dbo].[BloqueoCancelacionPorFormaDePago](tv.id_venta) bloqueoCancelacionPorFormaDePago,
								IIF(tv.pendiente > 0, 0 ,1) AS IDStatusCobro,
								IIF(tv.pago > 0, 1 ,0) AS IDStatusPago,
								tv.cobroCancelacion,
								tv.retornoCancelacion,
								[dbo].[NumeroBoletosXVenta](tv.id_venta) AS numeroBoletos
					FROM [dbo].[tbl_Venta] AS tv JOIN tbl_CatUsuarioCuenta AS ucins ON ucins.Id_U = tv.usuins
					JOIN tbl_CatUsuarioCuenta AS ucupd ON ucupd.Id_U = tv.usuupd
					WHERE tv.ventaGrupal = 1 	 			
				'	
														
	IF @bandfecha = 1	
		SET @Query = @Query + ' AND CONVERT(DATE, tv.fec_venta) = CONVERT(DATE,@fecha)'
	IF @bandnombre = 1	
		SET @Query = @Query + ' AND tv.nombre LIKE ''%'+ CONVERT(NVARCHAR(150), @nombre) + '%'''
	IF @bandfolio = 1
		SET @Query = @Query + ' AND tv.folio LIKE ''%'+ CONVERT(NVARCHAR(15), @folio) + '%'''

	IF @bandfecha = 0 AND @bandfolio = 0 AND @bandnombre = 0
		SET @Query = @Query + ' AND 1 < 0 '

    SET @Query = @Query + ' ORDER BY tv.fecins '

	DECLARE @PARAMETROS NVARCHAR(MAX)
	SET @PARAMETROS = N'@fecha DATETIME';		
	EXEC SP_EXECUTESQL @Query, @PARAMETROS, @fecha

END
































GO
/****** Object:  StoredProcedure [dbo].[Consultar_ViajesRpt_sp]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER PROCEDURE [dbo].[Consultar_ViajesRpt_sp]
		@fecha        DATE
AS
BEGIN	
	BEGIN TRY

		SELECT
		   tbl_DatosViaje.id_datosViaje
		  ,tbl_DatosViaje.id_viaje
		  ,tbl_DatosViaje.fecha_salida
		  ,tbl_DatosViaje.hora_salida
		  ,tbl_DatosViaje.id_prestacionServicios1
		  ,tbl_DatosViaje.id_prestacionServicios2
		  ,tbl_DatosViaje.id_listapasajeros
		  ,vtbl_FechasViaje.nombreViaje
		  ,vtbl_FechasViaje.camion
		  ,vtbl_FechasViaje.terminalOrigen + ' - ' + vtbl_FechasViaje.terminalDestino AS ruta
	  FROM tbl_DatosViaje JOIN vtbl_FechasViaje
	  ON tbl_DatosViaje.id_viaje = vtbl_FechasViaje.id_viaje AND vtbl_FechasViaje.fechaOrigen = tbl_DatosViaje.fecha_salida AND vtbl_FechasViaje.horaOrigen = tbl_DatosViaje.hora_salida AND vtbl_FechasViaje.id_tipoTerminal = 1
	  WHERE tbl_DatosViaje.fecha_salida = @fecha AND tbl_DatosViaje.activo = 1

	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------
	END CATCH
END







































GO
/****** Object:  StoredProcedure [dbo].[Consultar_ViajesRptEstadisticos_sp]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




ALTER PROCEDURE [dbo].[Consultar_ViajesRptEstadisticos_sp]
		@fecha        DATE
AS
BEGIN	
	BEGIN TRY

	   SELECT
		   vtbl_DatosViaje_Estadisticos.id_datosViaje
		  ,vtbl_DatosViaje_Estadisticos.id_viaje
		  ,vtbl_DatosViaje_Estadisticos.fecha_salida
		  ,vtbl_DatosViaje_Estadisticos.hora_salida
		  ,vtbl_DatosViaje_Estadisticos.id_prestacionServicios1
		  ,vtbl_DatosViaje_Estadisticos.id_prestacionServicios2
		  ,vtbl_DatosViaje_Estadisticos.id_listapasajeros
		  ,vtbl_FechasViaje.nombreViaje
		  ,vtbl_FechasViaje.camion
		  ,vtbl_FechasViaje.terminalOrigen + ' - ' + vtbl_FechasViaje.terminalDestino AS ruta
	  FROM vtbl_DatosViaje_Estadisticos JOIN vtbl_FechasViaje
	  ON vtbl_DatosViaje_Estadisticos.id_viaje = vtbl_FechasViaje.id_viaje AND vtbl_FechasViaje.fechaOrigen = vtbl_DatosViaje_Estadisticos.fecha_salida AND vtbl_FechasViaje.horaOrigen = vtbl_DatosViaje_Estadisticos.hora_salida AND vtbl_FechasViaje.id_tipoTerminal = 1
	  WHERE vtbl_DatosViaje_Estadisticos.fecha_salida = @fecha AND vtbl_DatosViaje_Estadisticos.activo = 1


	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------
	END CATCH
END








































GO
/****** Object:  StoredProcedure [dbo].[Correo_Verficar_sp]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[Correo_Verficar_sp]		
                @CorreoElectronico      NVARCHAR(150)
AS
BEGIN
	BEGIN TRY

		SET NOCOUNT ON

		IF((SELECT COUNT(CorreoElectronico)  FROM tbl_CatClientes WHERE CorreoElectronico = @CorreoElectronico) > 0)
		        SELECT 1
		ELSE
		        SELECT 0 
				 
	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END
































GO
/****** Object:  StoredProcedure [dbo].[getDatosComboDoctos_sp]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[getDatosComboDoctos_sp]	
AS
BEGIN TRY
	SET NOCOUNT ON
	DECLARE @MensajeError	VARCHAR(1000)
	
		SELECT	'' AS 'id', 
				'-- Seleccione --' AS 'descripcion'
		UNION
			SELECT 
			[id_documento] AS 'id',
			[nombre] AS 'descripcion'
		FROM [dbo].[tbl_CatTipoIdentificacion]
		WHERE [activo] = 1

	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		SELECT @MensajeError	= ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------
	END CATCH

RETURN 0












GO
/****** Object:  StoredProcedure [dbo].[Login_sp]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[Login_sp]
		@Cu_User     NVARCHAR(15),
		@Cu_Pass     NVARCHAR(32),
		@sucursal    NVARCHAR(100),
		@macAddress  NVARCHAR(20)
AS
BEGIN
	BEGIN TRY

	DECLARE @Id_U					NVARCHAR(100)
			,@Id_Tu					INT
			,@CTU_TipoUsuario       NVARCHAR(100)
			,@Cu_Estatus			BIT
			,@Cu_FBloq				DATETIME
			,@Cu_FCaducidad			DATETIME
			,@CuentaCaducada		BIT = 0
			,@U_Nombre				NVARCHAR(100)
			,@U_Apellidop			NVARCHAR(50)
			,@U_Apellidom			NVARCHAR(50)
			,@CU_Contraseña			NVARCHAR(100)
			,@id_sucursal			NVARCHAR(100)
			,@id_caja				NVARCHAR(100) = ''
			,@id_cajaNew            NVARCHAR(100) = ''
			,@RecuperarDatosCaja	BIT = 0
			,@impresora				NVARCHAR(MAX)
		
		SET NOCOUNT ON

		DECLARE @fecha	DATETIME
	    SET @fecha = dbo.fnGetNewDate()
		
		DECLARE
				@MensajeError	VARCHAR(1000),
				@IDTurno			INT	

		SELECT @impresora = nameprinter FROM tbl_CatCajas WHERE macAddress = @macAddress

		SELECT @Id_U = tbl_CatUsuarioCuenta.Id_U FROM tbl_CatUsuarioCuenta JOIN tbl_CatUsuario ON tbl_CatUsuarioCuenta.Id_U = tbl_CatUsuario.Id_U WHERE tbl_CatUsuario.U_activo = 1 AND Cu_User = @Cu_User AND Cu_Pass = HASHBYTES('SHA1', @Cu_Pass) 
		IF @Id_U IS NOT NULL
		BEGIN
			IF EXISTS(SELECT Id_U FROM tbl_CatUsuarioXSuc WHERE Id_U = @Id_U AND id_sucursal = @sucursal)
			BEGIN
				IF((SELECT Id_Tu FROM tbl_CatUsuario WHERE Id_U = @Id_U ) = 1  OR (SELECT Id_Tu FROM tbl_CatUsuario WHERE Id_U = @Id_U ) = 2 OR (SELECT Id_Tu FROM tbl_CatUsuario WHERE Id_U = @Id_U ) = 3 OR (SELECT Id_Tu FROM tbl_CatUsuario WHERE Id_U = @Id_U ) = 4)
				BEGIN
				    IF EXISTS(SELECT id_caja FROM tbl_CatCajas WHERE macAddress = @macAddress)
			        BEGIN
				            SET @id_caja = (SELECT id_caja FROM tbl_CatCajas WHERE macAddress = @macAddress)
					  		SET @IDTurno = (SELECT Id_Turno FROM tbl_CatUsuario WHERE Id_U = @Id_U)
					IF(EXISTS(SELECT id_caja FROM tbl_CajaXSucursal WHERE id_sucursal = @sucursal AND id_caja = @id_caja AND id_statusCaja = 1 AND CONVERT(DATE,fecha_inicio,105) < CONVERT(DATE,@fecha,105)))
					BEGIN
					--SET @id_cajaNew = (SELECT id_cajaXSucursal FROM tbl_CajaXSucursal WHERE id_sucursal = @sucursal AND id_caja = @id_caja AND id_statusCaja = 1 AND CONVERT(DATE,fecha_inicio,105) < CONVERT(DATE,@fecha,105))

					INSERT INTO tbl_EfectivoXCaja
								(Id_cajaXSucursal
								,id_sucursal
								,id_tipoEfectivo
								,M50C
								,M1P
								,M2P
								,M5P
								,M10P
								,M20P
								,M100P
								,B20P
								,B50P
								,B100P
								,B200P
								,B500P
								,B1000P
								,Total
								,activo
								,usuins
								,fecins
								,usuupd
								,fecupd)
							SELECT
								tbl_CajaXSucursal.id_cajaXSucursal
								,@sucursal
								,2
								,0
								,0
								,0
								,0
								,0
								,0
								,0
								,0
								,0
								,0
								,0
								,0
								,0
								,0.0
								,1
								,0
								,@fecha
								,0
								,@fecha
							FROM tbl_CajaXSucursal 
							WHERE id_sucursal = @sucursal AND id_caja = @id_caja AND id_statusCaja = 1 AND CONVERT(DATE,fecha_inicio,105) < CONVERT(DATE,@fecha,105)


					       	 UPDATE tbl_CajaXSucursal 
							 SET 
								 fecha_cierre = CONVERT(DATETIME,@fecha,105), 
								 hora_cierre = CONVERT(NVARCHAR(20),@fecha,108), 
								 caja_final = 0.0, 
								 id_statusCaja = 2,
								 usuupd = 0,
								 fecupd = @fecha
							WHERE id_cajaXSucursal IN (SELECT id_cajaXSucursal FROM tbl_CajaXSucursal WHERE id_sucursal = @sucursal AND id_caja = @id_caja AND id_statusCaja = 1 AND CONVERT(DATE,fecha_inicio,105) < CONVERT(DATE,@fecha,105)) --= @id_cajaNew

					        
 
					END

					IF(EXISTS(SELECT id_cajaXSucursal FROM tbl_CajaXSucursal WHERE id_sucursal = @sucursal AND id_caja = @id_caja AND id_statusCaja = 1 AND CONVERT(DATE,fecha_inicio,105) = CONVERT(DATE,@fecha,105)))
					BEGIN
					    SET @id_cajaNew = (SELECT id_cajaXSucursal FROM tbl_CajaXSucursal WHERE id_sucursal = @sucursal AND id_caja = @id_caja AND id_statusCaja = 1 AND CONVERT(DATE,fecha_inicio,105) = CONVERT(DATE,@fecha,105))
					    INSERT INTO tbl_LogLiginUser
							   (id_loginUser
							   ,id_usuario
							   ,feclogin
							   ,id_caja)
						 VALUES
							   (NEWID()
							   ,@Id_U
							   ,@fecha
							   ,@id_cajaNew)
						SET @RecuperarDatosCaja = 1
					END
					ELSE 
						BEGIN
						    SET @id_cajaNew = (NEWID())
							INSERT INTO tbl_LogLiginUser
								   (id_loginUser
								   ,id_usuario
								   ,feclogin
								   ,id_caja)
							 VALUES
								   (NEWID()
								   ,@Id_U
								   ,@fecha
								   ,@id_cajaNew)

							INSERT INTO tbl_CajaXSucursal
									(id_cajaXSucursal
									,id_caja
									,id_sucursal
									,id_cajero
									,id_statusCaja
									,fecha_inicio
									,hora_inicio
									,caja_inicial
									,caja_final
									,activo
									,usuins
									,fecins
									,usuupd
									,fecupd
									,id_turno)
							VALUES
									(@id_cajaNew
									,@id_caja
									,@sucursal
									,@Id_U
									,1
									,@fecha
									,CONVERT(NVARCHAR(8), @fecha, 108)
									,0
									,0
									,1
									,@Id_U
									,@fecha
									,@Id_U
									,@fecha
									,1)

							INSERT INTO tbl_EfectivoXCaja
								   (Id_cajaXSucursal
								   ,id_sucursal
								   ,id_tipoEfectivo
								   ,M50C
								   ,M1P
								   ,M2P
								   ,M5P
								   ,M10P
								   ,M20P
								   ,M100P
								   ,B20P
								   ,B50P
								   ,B100P
								   ,B200P
								   ,B500P
								   ,B1000P
								   ,Total
								   ,activo
								   ,usuins
								   ,fecins
								   ,usuupd
								   ,fecupd)
							VALUES
								   (@id_cajaNew
								   ,@sucursal
								   ,1
								   ,0
								   ,0
								   ,0
								   ,0
								   ,0
								   ,0
								   ,0
								   ,0
								   ,0
								   ,0
								   ,0
								   ,0
								   ,0
								   ,0
								   ,1
								   ,@Id_U
								   ,@fecha
								   ,@Id_U
								   ,@fecha)

						END

					END
				  ELSE 
				    BEGIN
					  SELECT 8
					END					
				END 

					SELECT	@Id_U		 = CUC.Id_U, 
						@Id_Tu			 = CTU.Id_Tu,
						@CTU_TipoUsuario = CTU.Tu_Desccripcion,
						@Cu_Estatus		 = CUC.Cu_Estatus,
						@Cu_FBloq		 = CUC.Cu_FBloq,
						@Cu_FCaducidad	 = CUC.Cu_FCaducidad,
						@U_Nombre		 = CU.U_Nombre,
						@U_Apellidop	 = CU.U_Apellidop,
						@U_Apellidom	 = CU.U_Apellidom,
						@Cu_Pass		 = CUC.Cu_Pass,
						@Cu_User		 = CUC.Cu_User,
						@id_sucursal	 = CU.id_sucursal,
						@IDTurno		 = CU.Id_Turno
				FROM tbl_CatUsuarioCuenta CUC
				INNER JOIN tbl_CatUsuario CU
					ON CUC.Id_U = CU.Id_U
				INNER JOIN tbl_CatTipoUsuario CTU
					ON CU.Id_Tu = CTU.Id_Tu
				WHERE Cu_User = @Cu_User AND Cu_Pass = HASHBYTES('SHA1', @Cu_Pass)

					IF @Cu_Estatus = 0 --Revisa si la cuenta esta bloqueada
					BEGIN
						IF @fecha > @Cu_FBloq
						BEGIN
							UPDATE tbl_CatUsuarioCuenta SET Cu_Estatus = 0, Cu_ConInt = 0 
								WHERE Id_U = @Id_U
							SET @Cu_Estatus = 0;
						END
						ELSE
						BEGIN
							IF @fecha > @Cu_FCaducidad
								SET @CuentaCaducada = 1
						END
					END
					ELSE
					BEGIN
						SELECT 1 AS id, @Id_U AS Id_U, @U_Nombre AS U_Nombre, @U_Apellidop AS U_Apellidop,
							@U_Apellidom AS U_Apellidom, @Id_Tu AS Id_Tu, @Cu_Estatus AS Cu_Estatus, 
							@CuentaCaducada AS CuentaCaducada, @id_sucursal AS id_sucursal, @RecuperarDatosCaja AS Crearid_caja, @id_cajaNew AS id_caja, @id_caja as idCajaCat, @IDTurno as id_turno, @impresora as impresora, @CTU_TipoUsuario as CTU_TipoUsuario, @Cu_User as Cu_User ,@Cu_Pass as Cu_Pass

						UPDATE tbl_CatUsuarioCuenta SET Cu_ConInt = 0 WHERE Id_U = @Id_U
						IF(SELECT Cu_ConInt FROM tbl_CatUsuarioCuenta WHERE Id_U = @Id_U) = 2
						BEGIN
							UPDATE tbl_CatUsuarioCuenta SET Cu_Estatus = 0 WHERE Id_U = @Id_U
						END
					END			
					IF @Cu_Estatus = 0 OR @CuentaCaducada = 1
					BEGIN
						SELECT 2 -- bloqueado o caducado
					END
			END
			ELSE
			BEGIN
				SELECT 4 -- NO existe el usuario en esta sucursal
			END
		END
		ELSE
		BEGIN
			SELECT @Id_U = tbl_CatUsuarioCuenta.Id_U FROM tbl_CatUsuarioCuenta JOIN tbl_CatUsuario ON tbl_CatUsuarioCuenta.Id_U = tbl_CatUsuario.Id_U WHERE tbl_CatUsuario.U_activo = 1 AND Cu_User = @Cu_User
			IF @Id_U IS NOT NULL
			BEGIN
				IF EXISTS(SELECT * FROM tbl_CatUsuarioXSuc WHERE Id_U = @Id_U AND id_sucursal = @sucursal)
				BEGIN
					UPDATE tbl_CatUsuarioCuenta SET Cu_ConInt = Cu_ConInt + 1 WHERE Id_U = @Id_U
					IF(SELECT Cu_ConInt FROM tbl_CatUsuarioCuenta WHERE Id_U = @Id_U) = 20
					BEGIN
						UPDATE tbl_CatUsuarioCuenta SET Cu_Estatus = 0 WHERE Id_U = @Id_U
						SELECT 6 -- Su cuenta fue bloqueda
					END
					ELSE
						SELECT 5 -- Contraseña incorrecta		
				END
				ELSE
						SELECT 4 -- NO existe el usuario en esta sucursal
			END
			ELSE
				SELECT 3 -- No existe la cuenta
		END
		
	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		SELECT @MensajeError	= ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END






























GO
/****** Object:  StoredProcedure [dbo].[Obtener_BoletosRutasViajesxIDRuta]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[Obtener_BoletosRutasViajesxIDRuta]
		@id_ruta	       NVARCHAR(100),
		@id_viaje		   NVARCHAR(100),
		@fecha_salida      DATE,
		@hora_salida       NVARCHAR(8)
AS
BEGIN	
	BEGIN TRY


	SELECT 
	        ISNULL(tbl_Boletos.id_boleto,'') AS id_boleto,
			tbl_CatViajes.id_identificador AS id_viaje,
			tbl_CatViajesXFecha.fechaviaje AS fecha_salida,
			tbl_CatViajes.horario AS hora,
		    tbl_CatDisenioDatos.indice AS asiento,
			tbl_CatDisenioDatos.id_disenioCamion AS id_disenioDatos,  
			ISNULL(tbl_Boletos.id_status,0) AS id_status,
			ISNULL(tbl_Boletos.NombrePersona,'') AS cliente_nombre,
			ISNULL(tOrigen.terminalOrigen,'') AS terminalOrigen,
			ISNULL(tDestino.terminalDestino,'') AS terminalDestino,
			ISNULL(tOrigen.id_terminalXruta,'') AS id_terminalXruta,
			ISNULL(tDestino.id_ruta,'') AS id_ruta,
			ISNULL(tOrigen.id_terminalOrigen,'') AS id_terminalSalida,
			ISNULL(tDestino.id_terminalDestino,'') AS id_terminalDestino,
			ISNULL(tbl_CatViajeXTarifas.id_tarifa, '') AS id_tarfifa
		FROM 
		tbl_CatDisenioDatos JOIN tbl_CatTipoObjeto
		ON tbl_CatDisenioDatos.id_tipoObjeto = tbl_CatTipoObjeto.id_tipoObjeto AND tbl_CatTipoObjeto.id_tipoObjeto = 1
		JOIN tbl_CatCamiones
		ON tbl_CatCamiones.id_disenioCamion = tbl_CatDisenioDatos.id_disenioCamion
		JOIN tbl_CatViajes
		ON tbl_CatViajes.id_camion = tbl_CatCamiones.id_camion AND tbl_CatViajes.id_identificador = @id_viaje AND tbl_CatViajes.id_ruta = @id_ruta
		JOIN tbl_CatViajesXFecha
		ON tbl_CatViajes.id_identificador = tbl_CatViajesXFecha.id_viaje AND tbl_CatViajesXFecha.fechaviaje = @fecha_salida	
		LEFT JOIN tbl_Boletos 
		ON tbl_CatViajes.id_identificador = tbl_Boletos.id_viaje AND tbl_Boletos.asiento = tbl_CatDisenioDatos.indice AND tbl_Boletos.fecha_salida = tbl_CatViajesXFecha.fechaviaje AND tbl_Boletos.activo = 1 AND (tbl_Boletos.id_status = 2 OR tbl_Boletos.id_status = 3) AND tbl_Boletos.id_viaje = @id_viaje AND tbl_Boletos.fecha_salida = @fecha_salida AND tbl_Boletos.hora_salida = @hora_salida 
		LEFT JOIN vtbl_FechasViaje AS tOrigen
		ON tbl_Boletos.id_viaje = tOrigen.id_viaje AND tbl_Boletos.fecha_salida = tOrigen.fechaOrigen AND tbl_Boletos.hora_salida = tOrigen.horaOrigen AND tbl_Boletos.OrdenOrigenTerminal =  tOrigen.ordenOrigen AND tbl_Boletos.OrdenDestinoTerminal = tOrigen.ordenDestino
        LEFT JOIN vtbl_FechasViaje AS tDestino
		ON tbl_Boletos.id_viaje = tDestino.id_viaje AND tbl_Boletos.fecha_salida = tDestino.fechaOrigen AND tbl_Boletos.hora_salida = tDestino.horaOrigen AND tbl_Boletos.OrdenOrigenTerminal =  tDestino.ordenOrigen AND tbl_Boletos.OrdenDestinoTerminal = tDestino.ordenDestino		
		LEFT JOIN tbl_CatViajeXTarifas
		ON tbl_CatViajeXTarifas.id_viaje = tbl_CatViajes.id_identificador AND tbl_CatViajeXTarifas.id_terminalXruta = tOrigen.id_terminalXruta AND tbl_CatViajeXTarifas.id_terminalXruta = tDestino.id_terminalXruta -- Si no funciona revisar
		ORDER BY tbl_CatDisenioDatos.indice

	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------
	END CATCH
END






































GO
/****** Object:  StoredProcedure [dbo].[Obtener_BoletosRutasViajesxIDRutaXFechas]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[Obtener_BoletosRutasViajesxIDRutaXFechas]
		@id_ruta	       NVARCHAR(100),
		@id_viaje		   NVARCHAR(100),
		@fecha_inicio      DATE,
		@fecha_fin         DATE,
		@hora_salida       NVARCHAR(8)
AS
BEGIN	
	BEGIN TRY


	SELECT 
	        ISNULL(tbl_Boletos.id_boleto,'') AS id_boleto,
			tbl_CatViajes.id_identificador AS id_viaje,
			tbl_CatViajesXFecha.fechaviaje AS fecha_salida,
			tbl_CatViajes.horario AS hora,
		    tbl_CatDisenioDatos.indice AS asiento,
			tbl_CatDisenioDatos.id_disenioCamion AS id_disenioDatos,  --Cambio
			ISNULL(tbl_Boletos.id_status,0) AS id_status,
			ISNULL(tbl_Boletos.NombrePersona,'') AS cliente_nombre,
			ISNULL(tOrigen.terminalOrigen,'') AS terminalOrigen,
			ISNULL(tDestino.terminalDestino,'') AS terminalDestino,
			ISNULL(tOrigen.id_terminalXruta,'') AS id_terminalXruta,
			ISNULL(tDestino.id_ruta,'') AS id_ruta,
			ISNULL(tOrigen.id_terminalOrigen,'') AS id_terminalSalida,
			ISNULL(tDestino.id_terminalDestino,'') AS id_terminalDestino,
			ISNULL(tbl_CatViajeXTarifas.id_tarifa, '') AS id_tarfifa
		FROM 
		tbl_CatDisenioDatos JOIN tbl_CatTipoObjeto
		ON tbl_CatDisenioDatos.id_tipoObjeto = tbl_CatTipoObjeto.id_tipoObjeto AND tbl_CatTipoObjeto.id_tipoObjeto = 1
		JOIN tbl_CatCamiones
		ON tbl_CatCamiones.id_disenioCamion = tbl_CatDisenioDatos.id_disenioCamion
		JOIN tbl_CatViajes
		ON tbl_CatViajes.id_camion = tbl_CatCamiones.id_camion AND tbl_CatViajes.id_identificador = @id_viaje AND tbl_CatViajes.id_ruta = @id_ruta
		JOIN tbl_CatViajesXFecha
		ON tbl_CatViajes.id_identificador = tbl_CatViajesXFecha.id_viaje AND (tbl_CatViajesXFecha.fechaviaje BETWEEN @fecha_inicio AND @fecha_fin)	
		JOIN tbl_Boletos 
		ON tbl_CatViajes.id_identificador = tbl_Boletos.id_viaje AND tbl_Boletos.asiento = tbl_CatDisenioDatos.indice AND tbl_Boletos.fecha_salida = tbl_CatViajesXFecha.fechaviaje AND tbl_Boletos.activo = 1 AND (tbl_Boletos.id_status = 2 OR tbl_Boletos.id_status = 3) AND tbl_Boletos.id_viaje = @id_viaje AND (tbl_Boletos.fecha_salida  BETWEEN @fecha_inicio AND @fecha_fin) AND tbl_Boletos.hora_salida = @hora_salida 
		LEFT JOIN vtbl_FechasViaje AS tOrigen
		ON tbl_Boletos.id_viaje = tOrigen.id_viaje AND tbl_Boletos.fecha_salida = tOrigen.fechaOrigen AND tbl_Boletos.hora_salida = tOrigen.horaOrigen AND tbl_Boletos.OrdenOrigenTerminal =  tOrigen.ordenOrigen AND tbl_Boletos.OrdenDestinoTerminal = tOrigen.ordenDestino
        LEFT JOIN vtbl_FechasViaje AS tDestino
		ON tbl_Boletos.id_viaje = tDestino.id_viaje AND tbl_Boletos.fecha_salida = tDestino.fechaOrigen AND tbl_Boletos.hora_salida = tDestino.horaOrigen AND tbl_Boletos.OrdenOrigenTerminal =  tDestino.ordenOrigen AND tbl_Boletos.OrdenDestinoTerminal = tDestino.ordenDestino		
		LEFT JOIN tbl_CatViajeXTarifas
		ON tbl_CatViajeXTarifas.id_viaje = tbl_CatViajes.id_identificador AND tbl_CatViajeXTarifas.id_terminalXruta = tOrigen.id_terminalXruta AND tbl_CatViajeXTarifas.id_terminalXruta = tDestino.id_terminalXruta -- Si no funciona revisar
		ORDER BY tbl_CatDisenioDatos.indice

	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------
	END CATCH
END






































GO
/****** Object:  StoredProcedure [dbo].[Obtener_Camiones_Activos]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[Obtener_Camiones_Activos]
	
AS
BEGIN
	
	BEGIN TRY

		SELECT 
			cc.id_camion,
			cc.descripcion,			
			cm.marca,			
			cs.submarca,
			ct.tipoCamion,
			cc.numcamion,
			cc.caracteristicas,
			cd.nombre,			
			cc.id_marca,
			cc.id_submarca,
			cc.id_tipocamion,
			cc.id_disenioCamion

		FROM
			tbl_CatCamiones as cc
			JOIN tbl_CatDisenio as cd ON cc.id_disenioCamion = cd.id_disenioCamion
			JOIN tbl_CatMarcas as cm ON cc.id_marca = cm.id_marca
			JOIN tbl_CatSubMarcas as cs ON cc.id_submarca = cs.id_submarca
			JOIN tbl_CatTipoCamion as ct ON cc.id_tipocamion = ct.id_tipoCamion
		WHERE
			cc.activo = 1
			ORDER BY cc.descripcion
	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------
	END CATCH
END



























GO
/****** Object:  StoredProcedure [dbo].[Obtener_DatosCaja]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Obtener_DatosCaja]
	@txt_Id_Caja nvarchar(100)    
AS
BEGIN
	IF ISNULL(@txt_Id_Caja,'') != ''
	BEGIN
	DECLARE @fechainicio DATETIME
	DECLARE @horainicio  NVARCHAR(8)

	SELECT @fechainicio = fecha_inicio, @horainicio=hora_inicio FROM tbl_CajaXSucursal WHERE
	id_cajaXSucursal = @txt_Id_Caja

	DECLARE @Apertura AS MONEY
	SET @Apertura = ( SELECT ISNULL(SUM(exc.Total),0)  FROM tbl_EfectivoXCaja exc 
		WHERE exc.id_tipoEfectivo = 1 AND exc.id_cajaXSucursal = @txt_Id_Caja )

	DECLARE @ventaBoletos AS MONEY
	SET @ventaBoletos =(
		SELECT ISNULL(SUM(vd.pago1 + vd.pago2),0)
		FROM 
		    tbl_VentaDetalle AS vd INNER JOIN tbl_VentaCajas AS tvc ON tvc.IDGenerico = vd.id_ventadetalle		
		WHERE 
		tvc.IDCajaXSucursal = @txt_Id_Caja AND tvc.IDStatus = 1 AND tvc.Activo = 1
	) 

	DECLARE @reservacionesBoletos AS MONEY
	SET @reservacionesBoletos =(
		SELECT ISNULL(SUM(0.0 + 0.0),0)
		FROM 
		    tbl_VentaDetalle AS vd INNER JOIN tbl_VentaCajas AS tvc ON tvc.IDGenerico = vd.id_ventadetalle		
		WHERE 
		tvc.IDCajaXSucursal = @txt_Id_Caja AND tvc.IDStatus = 2 AND tvc.Activo = 1
	) 

	DECLARE @anticipo1Boletos AS MONEY
	SET @anticipo1Boletos =(
		SELECT ISNULL(SUM(vd.pago1 + 0.0),0)
		FROM 
		    tbl_VentaDetalle AS vd INNER JOIN tbl_VentaCajas AS tvc ON tvc.IDGenerico = vd.id_ventadetalle		
		WHERE 
		tvc.IDCajaXSucursal = @txt_Id_Caja AND tvc.IDStatus = 3 AND tvc.Activo = 1
	)

	DECLARE @anticipo2Boletos AS MONEY
	SET @anticipo2Boletos =(
		SELECT ISNULL(SUM(0.0 + vd.pago2),0)
		FROM 
		    tbl_VentaDetalle AS vd INNER JOIN tbl_VentaCajas AS tvc ON tvc.IDGenerico = vd.id_ventadetalle		
		WHERE 
		tvc.IDCajaXSucursal = @txt_Id_Caja AND tvc.IDStatus = 4 AND tvc.Activo = 1
	)

	DECLARE @transferenciasBoletos AS MONEY
	SET @transferenciasBoletos =(
		SELECT ISNULL(SUM(vd.pago1 + vd.pago2),0)
		FROM 
		    tbl_VentaDetalle AS vd INNER JOIN tbl_VentaCajas AS tvc ON tvc.IDGenerico = vd.id_ventadetalle		
		WHERE 
		tvc.IDCajaXSucursal = @txt_Id_Caja AND tvc.IDStatus = 5 AND tvc.Activo = 1
	)

    DECLARE @cancelacionesBoletos AS MONEY
	SET @cancelacionesBoletos =(
		SELECT ISNULL(SUM(vd.pago1 + vd.pago2),0)
		FROM 
		    tbl_VentaDetalle AS vd INNER JOIN tbl_VentaCajas AS tvc ON tvc.IDGenerico = vd.id_ventadetalle		
		WHERE 
		tvc.IDCajaXSucursal = @txt_Id_Caja AND tvc.IDStatus = 6 AND tvc.Activo = 1
	)

    DECLARE @cancelacionesCobroBoletos AS MONEY
	SET @cancelacionesCobroBoletos =(
		SELECT ISNULL(SUM(vd.cancelacion),0)
		FROM 
		    tbl_VentaDetalle AS vd INNER JOIN tbl_VentaCajas AS tvc ON tvc.IDGenerico = vd.id_ventadetalle		
		WHERE 
		tvc.IDCajaXSucursal = @txt_Id_Caja AND tvc.IDStatus = 6 AND tvc.Activo = 1
	)

    DECLARE @TotalVtaMaletas AS MONEY
	SET @TotalVtaMaletas =(
		SELECT ISNULL(SUM(tcm.precio),0)
		FROM 
		    tbl_CatMaletas AS tcm INNER JOIN tbl_VentaCajas AS tvc ON tvc.IDGenerico = tcm.id_maleta		
		WHERE 
		tvc.IDCajaXSucursal = @txt_Id_Caja AND tvc.IDStatus = 9 AND tvc.Activo = 1 AND tcm.activo = 1
	)

    DECLARE @TotalVta AS MONEY
	SET @TotalVta = ( @ventaBoletos + @reservacionesBoletos + @anticipo1Boletos + @anticipo2Boletos + @transferenciasBoletos - @cancelacionesBoletos + @cancelacionesCobroBoletos +  @TotalVtaMaletas)

	    
    DECLARE @TotalEfectivo AS MONEY
	SET @TotalEfectivo = (SELECT ISNULL(SUM(v.montoEfectivo),0) FROM tbl_VentaPagos v 
		where v.id_cajaXSucursal = @txt_Id_Caja AND v.activo = 'true')

	SET @TotalEfectivo = @TotalEfectivo - @cancelacionesBoletos + @cancelacionesCobroBoletos + @TotalVtaMaletas

    DECLARE @TotalMonedero AS MONEY
	SET @TotalMonedero = ( SELECT ISNULL(SUM(v.montoMonedero),0) FROM tbl_VentaPagos v 
		WHERE v.id_cajaXSucursal = @txt_Id_Caja AND v.activo = 'true')

	DECLARE @TotalTarjeta AS MONEY
	SET @TotalTarjeta = ( SELECT ISNULL(SUM(v.montoTarjeta),0) FROM tbl_VentaPagos v 
		WHERE v.id_cajaXSucursal = @txt_Id_Caja AND v.activo = 'true')

	DECLARE @TotalTransferencia AS MONEY
	SET @TotalTransferencia = ( SELECT ISNULL(SUM(v.montoTransferencia),0) FROM tbl_VentaPagos v 
		WHERE v.id_cajaXSucursal = @txt_Id_Caja AND v.activo = 'true')

	DECLARE @RetirosP AS MONEY
	SET @RetirosP = (SELECT  ISNULL(SUM(tbl_Retiros.Monto),0)  FROM tbl_Retiros WHERE tbl_Retiros.id_cajaXSucursal = @txt_Id_Caja AND tbl_Retiros.Tipo = 2 AND tbl_Retiros.Activo = 'true')

	DECLARE @RetirosC AS MONEY
	SET @RetirosC = (SELECT ISNULL(SUM(tbl_Retiros.Monto),0)  FROM tbl_Retiros WHERE tbl_Retiros.id_cajaXSucursal = @txt_Id_Caja AND tbl_Retiros.Tipo = 1 AND tbl_Retiros.Activo = 'true')


	DECLARE @Depositos AS MONEY
	SET @Depositos = (SELECT isnull(sum(tbl_Depositos.Monto),0) FROM tbl_Depositos WHERE tbl_Depositos.id_cajaXSucursal = @txt_Id_Caja and tbl_Depositos.Activo = 'true')


	DECLARE @Cajero NVARCHAR(100)
	SET @Cajero = (SELECT tbl_CatUsuario.U_Nombre + ' ' + tbl_CatUsuario.U_Apellidop + ' ' +tbl_CatUsuario.U_Apellidom FROM tbl_CajaXSucursal JOIN tbl_CatUsuario ON tbl_CajaXSucursal.id_cajero = tbl_CatUsuario.Id_U WHERE id_cajaXSucursal = @txt_Id_Caja) 

	SELECT
		@Apertura AS Apertura,
		@TotalVta AS TotalVta , 
		@TotalEfectivo AS TotalEfectivo,
		@TotalMonedero AS TotalMonedero,
		@TotalTarjeta AS TotalTarjeta,
		@TotalTransferencia AS TotalTransferencia,
		@fechainicio AS fechainicio , 
		@horainicio AS horainicio, 
		@RetirosP AS RetirosP, 
		@RetirosC AS RetirosC, 
		@Depositos AS Depositos,
		@TotalVtaMaletas AS TotalVtaMaletas,
		@Cajero AS Cajero,
		@ventaBoletos AS TotalBoletos

	END
	ELSE
	BEGIN 
		SET @Apertura = 0
		SET @TotalVta = 0
		SET @TotalEfectivo = 0
		SET @TotalMonedero = 0
		SET @TotalTarjeta = 0
		SET @TotalTransferencia = 0
		SET @fechainicio = dbo.fnGetNewDate()
		SET @horainicio = '00:00:00'
		SET @RetirosC = 0
		SET @RetirosP = 0
		SET @Depositos  = 0
		SET @TotalVtaMaletas = 0
		SET @Cajero = ''
		SET @ventaBoletos = 0
	SELECT
		@Apertura AS Apertura,
		@TotalVta AS TotalVta , 
		@TotalEfectivo AS TotalEfectivo,
		@TotalMonedero AS TotalMonedero,
		@TotalTarjeta AS TotalTarjeta,
		@TotalTransferencia AS TotalTransferencia,
		@fechainicio AS fechainicio , 
		@horainicio AS horainicio, 
		@RetirosP AS RetirosP, 
		@RetirosC AS RetirosC, 
		@Depositos AS Depositos,
		@TotalVtaMaletas AS TotalVtaMaletas,
		@Cajero AS Cajero,
		@ventaBoletos AS TotalBoletos
	END
END




















GO
/****** Object:  StoredProcedure [dbo].[Obtener_DatosCaja_Estadisticos]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Obtener_DatosCaja_Estadisticos]
	@txt_Id_Caja nvarchar(100)    
AS
BEGIN
	IF ISNULL(@txt_Id_Caja,'') != ''
	BEGIN
	DECLARE @fechainicio DATETIME
	DECLARE @horainicio  NVARCHAR(8)

	IF(EXISTS(SELECT id_caja FROM [dbo].[vtbl_CajaXSucursal_Estadisticos] WHERE id_cajaXSucursal = @txt_Id_Caja))
	BEGIN
		SELECT @fechainicio = fecha_inicio, @horainicio=hora_inicio FROM [dbo].[vtbl_CajaXSucursal_Estadisticos] WHERE
		id_cajaXSucursal = @txt_Id_Caja
	END

	DECLARE @Apertura AS MONEY
	SET @Apertura = ( SELECT SUM(Apertura.Total) FROM (
		SELECT ISNULL(SUM(exc.Total),0) AS Total FROM [dbo].[vtbl_EfectivoXCaja_Estadisticos] exc 
		WHERE exc.id_tipoEfectivo = 1 AND exc.id_cajaXSucursal = @txt_Id_Caja) AS Apertura
		)

	DECLARE @ventaBoletos AS MONEY
	SET @ventaBoletos =(SELECT SUM(VentaBoletos.Total) FROM (
	    SELECT ISNULL(SUM(vd.pago1 + vd.pago2),0) AS Total
		FROM 
		    [dbo].[vtbl_VentaDetalle_Estadisticos] AS vd INNER JOIN [dbo].[vtbl_VentaCajas_Estadisticos] AS tvc ON tvc.IDGenerico = vd.id_ventadetalle		
		WHERE 
		tvc.IDCajaXSucursal = @txt_Id_Caja AND tvc.IDStatus = 1 AND tvc.Activo = 1) AS VentaBoletos
	) 

	DECLARE @reservacionesBoletos AS MONEY
	SET @reservacionesBoletos =(SELECT SUM(Reservaciones.Total) FROM (
		SELECT ISNULL(SUM(0.0 + 0.0),0) AS Total
		FROM 
		    [dbo].[vtbl_VentaDetalle_Estadisticos] AS vd INNER JOIN [dbo].[vtbl_VentaCajas_Estadisticos] AS tvc ON tvc.IDGenerico = vd.id_ventadetalle		
		WHERE 
		tvc.IDCajaXSucursal = @txt_Id_Caja AND tvc.IDStatus = 2 AND tvc.Activo = 1) AS Reservaciones
	) 
	 

	DECLARE @anticipo1Boletos AS MONEY
	SET @anticipo1Boletos =(SELECT SUM(Anticipo1.Total) FROM (
		SELECT ISNULL(SUM(vd.pago1 + 0.0),0) AS Total
		FROM 
		    [dbo].[vtbl_VentaDetalle_Estadisticos] AS vd INNER JOIN [dbo].[vtbl_VentaCajas_Estadisticos] AS tvc ON tvc.IDGenerico = vd.id_ventadetalle		
		WHERE 
		tvc.IDCajaXSucursal = @txt_Id_Caja AND tvc.IDStatus = 3 AND tvc.Activo = 1) AS Anticipo1
	)

	DECLARE @anticipo2Boletos AS MONEY
	SET @anticipo2Boletos =(SELECT SUM(Anticipo2.Total) FROM (
		SELECT ISNULL(SUM(0.0 + vd.pago2),0) AS Total
		FROM 
		    [dbo].[vtbl_VentaDetalle_Estadisticos] AS vd INNER JOIN [dbo].[vtbl_VentaCajas_Estadisticos] AS tvc ON tvc.IDGenerico = vd.id_ventadetalle		
		WHERE 
		tvc.IDCajaXSucursal = @txt_Id_Caja AND tvc.IDStatus = 4 AND tvc.Activo = 1) AS Anticipo2
	)

	DECLARE @transferenciasBoletos AS MONEY
	SET @transferenciasBoletos =(SELECT SUM(Transferencia.Total) FROM (
		SELECT ISNULL(SUM(vd.pago1 + vd.pago2),0) AS Total
		FROM 
		    [dbo].[vtbl_VentaDetalle_Estadisticos] AS vd INNER JOIN [dbo].[vtbl_VentaCajas_Estadisticos] AS tvc ON tvc.IDGenerico = vd.id_ventadetalle		
		WHERE 
		tvc.IDCajaXSucursal = @txt_Id_Caja AND tvc.IDStatus = 5 AND tvc.Activo = 1) AS Transferencia
	)

    DECLARE @cancelacionesBoletos AS MONEY
	SET @cancelacionesBoletos =(SELECT SUM(Cancelaciones.Total) FROM (
		SELECT ISNULL(SUM(vd.pago1 + vd.pago2),0) AS Total
		FROM 
		    [dbo].[vtbl_VentaDetalle_Estadisticos] AS vd INNER JOIN [dbo].[vtbl_VentaCajas_Estadisticos] AS tvc ON tvc.IDGenerico = vd.id_ventadetalle		
		WHERE 
		tvc.IDCajaXSucursal = @txt_Id_Caja AND tvc.IDStatus = 6 AND tvc.Activo = 1) AS Cancelaciones
	)

    DECLARE @cancelacionesCobroBoletos AS MONEY
	SET @cancelacionesCobroBoletos =(SELECT SUM(CancelacionesCobro.Total) FROM (
		SELECT ISNULL(SUM(vd.cancelacion),0) AS Total
		FROM 
		    [dbo].[vtbl_VentaDetalle_Estadisticos] AS vd INNER JOIN [dbo].[vtbl_VentaCajas_Estadisticos] AS tvc ON tvc.IDGenerico = vd.id_ventadetalle		
		WHERE 
		tvc.IDCajaXSucursal = @txt_Id_Caja AND tvc.IDStatus = 6 AND tvc.Activo = 1) AS CancelacionesCobro
	)

    DECLARE @TotalVtaMaletas AS MONEY
	SET @TotalVtaMaletas =( SELECT SUM(VentaMaleta.Total) FROM (
		SELECT ISNULL(SUM(tcm.precio),0) AS Total
		FROM 
		    [dbo].[vtbl_CatMaletas_Estadisticos] AS tcm INNER JOIN [dbo].[vtbl_VentaCajas_Estadisticos] AS tvc ON tvc.IDGenerico = tcm.id_maleta		
		WHERE 
		tvc.IDCajaXSucursal = @txt_Id_Caja AND tvc.IDStatus = 9 AND tvc.Activo = 1 AND tcm.activo = 1) AS VentaMaleta
	)

    DECLARE @TotalVta AS MONEY
	SET @TotalVta = ( @ventaBoletos + @reservacionesBoletos + @anticipo1Boletos + @anticipo2Boletos + @transferenciasBoletos - @cancelacionesBoletos + @cancelacionesCobroBoletos +  @TotalVtaMaletas)

	    
    DECLARE @TotalEfectivo AS MONEY
	SET @TotalEfectivo = (SELECT SUM(TotalEfectivo.Total) FROM (
		SELECT ISNULL(SUM(v.montoEfectivo),0) AS Total FROM [dbo].[vtbl_VentaPagos_Estadisticos] v 
		WHERE v.id_cajaXSucursal = @txt_Id_Caja AND v.activo = 'true') AS TotalEfectivo		
		)

	SET @TotalEfectivo = @TotalEfectivo - @cancelacionesBoletos + @cancelacionesCobroBoletos + @TotalVtaMaletas

    DECLARE @TotalMonedero AS MONEY
	SET @TotalMonedero = ( SELECT SUM(TotalMonedero .Total) FROM (
		SELECT ISNULL(SUM(v.montoMonedero),0) AS Total FROM [dbo].[vtbl_VentaPagos_Estadisticos] v 
		WHERE v.id_cajaXSucursal = @txt_Id_Caja AND v.activo = 'true') AS TotalMonedero 
		)

	
    DECLARE @TotalTarjeta AS MONEY
	SET @TotalTarjeta = ( SELECT SUM(TotalTarjeta.Total) FROM (
		SELECT ISNULL(SUM(v.montoTarjeta),0) AS Total FROM [dbo].[vtbl_VentaPagos_Estadisticos] v 
		WHERE v.id_cajaXSucursal = @txt_Id_Caja AND v.activo = 'true') AS TotalTarjeta
		)

	DECLARE @TotalTransferencia AS MONEY
	SET @TotalTransferencia = ( SELECT SUM(TotalTransferencia.Total) FROM (
		SELECT ISNULL(SUM(v.montoTransferencia),0) AS Total FROM [dbo].[vtbl_VentaPagos_Estadisticos] v 
		WHERE v.id_cajaXSucursal = @txt_Id_Caja AND v.activo = 'true') AS TotalTransferencia
		)

	DECLARE @RetirosP AS MONEY
	SET @RetirosP = (SELECT SUM(Retiros.Total) FROM (
	SELECT  ISNULL(SUM([dbo].[vtbl_Retiros_Estadisticos].Monto),0) AS Total  FROM [dbo].[vtbl_Retiros_Estadisticos] WHERE [dbo].[vtbl_Retiros_Estadisticos].id_cajaXSucursal = @txt_Id_Caja AND [dbo].[vtbl_Retiros_Estadisticos].Tipo = 2 AND [dbo].[vtbl_Retiros_Estadisticos].Activo = 'true') AS Retiros)


	DECLARE @RetirosC AS MONEY
	SET @RetirosC = (SELECT SUM(Retiros.Total) FROM (
	SELECT ISNULL(SUM([dbo].[vtbl_Retiros_Estadisticos].Monto),0) AS Total  FROM [dbo].[vtbl_Retiros_Estadisticos] WHERE [dbo].[vtbl_Retiros_Estadisticos].id_cajaXSucursal = @txt_Id_Caja AND [dbo].[vtbl_Retiros_Estadisticos].Tipo = 1 AND [dbo].[vtbl_Retiros_Estadisticos].Activo = 'true') AS Retiros)


	DECLARE @Depositos AS MONEY
	SET @Depositos = (SELECT SUM(Depositos.Total) FROM (
	SELECT ISNULL(SUM([dbo].[vtbl_Depositos_Estadisticos].Monto),0) AS Total  FROM [dbo].[vtbl_Depositos_Estadisticos] WHERE [dbo].[vtbl_Depositos_Estadisticos].id_cajaXSucursal = @txt_Id_Caja and [dbo].[vtbl_Depositos_Estadisticos].Activo = 'true') AS Depositos)



	DECLARE @Cajero NVARCHAR(100)
	SET @Cajero = (SELECT tbl_CatUsuario.U_Nombre + ' ' + tbl_CatUsuario.U_Apellidop + ' ' +tbl_CatUsuario.U_Apellidom FROM tbl_CajaXSucursal JOIN tbl_CatUsuario ON tbl_CajaXSucursal.id_cajero = tbl_CatUsuario.Id_U WHERE id_cajaXSucursal = @txt_Id_Caja) 

	SELECT
		@Apertura AS Apertura,
		@TotalVta AS TotalVta , 
		@TotalEfectivo AS TotalEfectivo,
		@TotalMonedero AS TotalMonedero,
		@TotalTarjeta AS TotalTarjeta,
		@TotalTransferencia AS TotalTransferencia,
		@fechainicio AS fechainicio , 
		@horainicio AS horainicio, 
		@RetirosP AS RetirosP, 
		@RetirosC AS RetirosC, 
		@Depositos AS Depositos,
		@TotalVtaMaletas AS TotalVtaMaletas,
		@Cajero AS Cajero,
		@ventaBoletos AS TotalBoletos

	END
	ELSE
	BEGIN 
		SET @Apertura = 0
		SET @TotalVta = 0
		SET @TotalEfectivo = 0
		SET @TotalMonedero = 0
		SET @TotalTarjeta = 0
		SET @TotalTransferencia = 0
		SET @fechainicio = dbo.fnGetNewDate()
		SET @horainicio = '00:00:00'
		SET @RetirosC = 0
		SET @RetirosP = 0
		SET @Depositos  = 0
		SET @TotalVtaMaletas = 0
		SET @Cajero = ''
		SET @ventaBoletos = 0
	SELECT
		@Apertura AS Apertura,
		@TotalVta AS TotalVta , 
		@TotalEfectivo AS TotalEfectivo,
		@TotalMonedero AS TotalMonedero,
		@TotalTarjeta AS TotalTarjeta,
		@TotalTransferencia AS TotalTransferencia,
		@fechainicio AS fechainicio , 
		@horainicio AS horainicio, 
		@RetirosP AS RetirosP, 
		@RetirosC AS RetirosC, 
		@Depositos AS Depositos,
		@TotalVtaMaletas AS TotalVtaMaletas,
		@Cajero AS Cajero,
		@ventaBoletos AS TotalBoletos
	END
END























GO
/****** Object:  StoredProcedure [dbo].[Obtener_DatosCaja2]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Obtener_DatosCaja2]
	@txt_Id_Caja nvarchar(100),
	@txt_FechaInicio date,
	@txt_FechaFin date    
AS
BEGIN
	IF ISNULL(@txt_Id_Caja,'') != ''
	BEGIN
	DECLARE @fechainicio DATETIME
	DECLARE @horainicio DATETIME 

	SELECT @fechainicio = dbo.fnGetNewDate()
	SELECT @horainicio = @fechainicio

	DECLARE @Apertura AS MONEY
	SET @Apertura = ( SELECT ISNULL(SUM(exc.Total),0)  FROM tbl_EfectivoXCaja AS exc JOIN tbl_CajaXSucursal AS cs ON exc.id_cajaXSucursal = cs.id_cajaXSucursal
	WHERE exc.id_tipoEfectivo = 1 AND cs.id_caja = @txt_Id_Caja  AND CONVERT(DATE,cs.fecha_inicio) BETWEEN @txt_FechaInicio AND @txt_FechaFin)



	DECLARE @ventaBoletos AS MONEY
	SET @ventaBoletos =(
		SELECT ISNULL(SUM(vd.pago1 + vd.pago2),0)
		FROM 
		    tbl_VentaDetalle AS vd INNER JOIN tbl_VentaCajas AS tvc ON tvc.IDGenerico = vd.id_ventadetalle JOIN tbl_CajaXSucursal AS cs ON tvc.IDCajaXSucursal = cs.id_cajaXSucursal	
		WHERE 
		tvc.IDStatus = 1 AND tvc.Activo = 1 AND cs.id_caja = @txt_Id_Caja  AND CONVERT(DATE,cs.fecha_inicio) BETWEEN @txt_FechaInicio AND @txt_FechaFin
	) 

	DECLARE @reservacionesBoletos AS MONEY
	SET @reservacionesBoletos =(
		SELECT ISNULL(SUM(0.0 + 0.0),0)
		FROM 
		    tbl_VentaDetalle AS vd INNER JOIN tbl_VentaCajas AS tvc ON tvc.IDGenerico = vd.id_ventadetalle	JOIN tbl_CajaXSucursal AS cs ON tvc.IDCajaXSucursal = cs.id_cajaXSucursal	
		WHERE 
		tvc.IDStatus = 2 AND tvc.Activo = 1 AND cs.id_caja = @txt_Id_Caja AND CONVERT(DATE,cs.fecha_inicio) BETWEEN @txt_FechaInicio AND @txt_FechaFin
	) 

	DECLARE @anticipo1Boletos AS MONEY
	SET @anticipo1Boletos =(
		SELECT ISNULL(SUM(vd.pago1 + 0.0),0)
		FROM 
		    tbl_VentaDetalle AS vd INNER JOIN tbl_VentaCajas AS tvc ON tvc.IDGenerico = vd.id_ventadetalle	JOIN tbl_CajaXSucursal AS cs ON tvc.IDCajaXSucursal = cs.id_cajaXSucursal	
		WHERE 
		tvc.IDStatus = 3 AND tvc.Activo = 1 AND cs.id_caja = @txt_Id_Caja AND CONVERT(DATE,cs.fecha_inicio) BETWEEN @txt_FechaInicio AND @txt_FechaFin
	)

	DECLARE @anticipo2Boletos AS MONEY
	SET @anticipo2Boletos =(
		SELECT ISNULL(SUM(0.0 + vd.pago2),0)
		FROM 
		    tbl_VentaDetalle AS vd INNER JOIN tbl_VentaCajas AS tvc ON tvc.IDGenerico = vd.id_ventadetalle	JOIN tbl_CajaXSucursal AS cs ON tvc.IDCajaXSucursal = cs.id_cajaXSucursal	
		WHERE 
		tvc.IDStatus = 4 AND tvc.Activo = 1 AND cs.id_caja = @txt_Id_Caja AND CONVERT(DATE,cs.fecha_inicio) BETWEEN @txt_FechaInicio AND @txt_FechaFin
	)

	DECLARE @transferenciasBoletos AS MONEY
	SET @transferenciasBoletos =(
		SELECT ISNULL(SUM(vd.pago1 + vd.pago2),0)
		FROM 
		    tbl_VentaDetalle AS vd INNER JOIN tbl_VentaCajas AS tvc ON tvc.IDGenerico = vd.id_ventadetalle	JOIN tbl_CajaXSucursal AS cs ON tvc.IDCajaXSucursal = cs.id_cajaXSucursal	
		WHERE 
		tvc.IDStatus = 5 AND tvc.Activo = 1 AND cs.id_caja = @txt_Id_Caja AND CONVERT(DATE,cs.fecha_inicio) BETWEEN @txt_FechaInicio AND @txt_FechaFin
	)

    DECLARE @cancelacionesBoletos AS MONEY
	SET @cancelacionesBoletos =(
		SELECT ISNULL(SUM(vd.pago1 + vd.pago2),0)
		FROM 
		    tbl_VentaDetalle as vd INNER JOIN tbl_VentaCajas AS tvc ON tvc.IDGenerico = vd.id_ventadetalle	JOIN tbl_CajaXSucursal AS cs ON tvc.IDCajaXSucursal = cs.id_cajaXSucursal	
		WHERE 
		tvc.IDStatus = 6 AND tvc.Activo = 1 AND cs.id_caja = @txt_Id_Caja AND CONVERT(DATE,cs.fecha_inicio) BETWEEN @txt_FechaInicio AND @txt_FechaFin
	)

    DECLARE @cancelacionesCobroBoletos AS MONEY
	SET @cancelacionesCobroBoletos =(
		SELECT ISNULL(SUM(vd.cancelacion),0)
		FROM 
		    tbl_VentaDetalle AS vd INNER JOIN tbl_VentaCajas AS tvc ON tvc.IDGenerico = vd.id_ventadetalle JOIN tbl_CajaXSucursal AS cs ON tvc.IDCajaXSucursal = cs.id_cajaXSucursal		
		WHERE 
		tvc.IDStatus = 6 AND tvc.Activo = 1 AND cs.id_caja = @txt_Id_Caja AND CONVERT(DATE,cs.fecha_inicio) BETWEEN @txt_FechaInicio AND @txt_FechaFin
	)

    DECLARE @TotalVtaMaletas AS MONEY
	SET @TotalVtaMaletas =(
		SELECT ISNULL(SUM(tcm.precio),0)
		FROM 
		    tbl_CatMaletas AS tcm INNER JOIN tbl_VentaCajas AS tvc ON tvc.IDGenerico = tcm.id_maleta JOIN tbl_CajaXSucursal AS cs ON tvc.IDCajaXSucursal = cs.id_cajaXSucursal	
		WHERE 
		tvc.IDStatus = 9 AND tvc.Activo = 1 AND cs.id_caja = @txt_Id_Caja AND CONVERT(DATE,cs.fecha_inicio) BETWEEN @txt_FechaInicio AND @txt_FechaFin AND tcm.activo = 1
	)

    DECLARE @TotalVta AS MONEY
	SET @TotalVta = ( @ventaBoletos + @reservacionesBoletos + @anticipo1Boletos + @anticipo2Boletos + @transferenciasBoletos - @cancelacionesBoletos + @cancelacionesCobroBoletos +  @TotalVtaMaletas)

	    
    DECLARE @TotalEfectivo AS MONEY
	SET @TotalEfectivo = (SELECT ISNULL(SUM(v.montoEfectivo),0) FROM tbl_VentaPagos AS v JOIN tbl_CajaXSucursal AS cs ON v.id_cajaXSucursal = cs.id_cajaXSucursal
		WHERE v.activo = 'true' AND cs.id_caja = @txt_Id_Caja AND CONVERT(DATE,cs.fecha_inicio) BETWEEN @txt_FechaInicio AND @txt_FechaFin)

	SET @TotalEfectivo = @TotalEfectivo - @cancelacionesBoletos + @cancelacionesCobroBoletos + @TotalVtaMaletas

    DECLARE @TotalMonedero AS MONEY
	set @TotalMonedero = ( SELECT ISNULL(SUM(v.montoMonedero),0) FROM tbl_VentaPagos AS v  JOIN tbl_CajaXSucursal as cs ON v.id_cajaXSucursal = cs.id_cajaXSucursal 
		WHERE v.activo = 'true' AND cs.id_caja = @txt_Id_Caja AND CONVERT(DATE,cs.fecha_inicio) BETWEEN @txt_FechaInicio AND @txt_FechaFin)

	DECLARE @TotalTarjeta AS MONEY
	SET @TotalTarjeta = (SELECT ISNULL(SUM(v.montoTarjeta),0) FROM tbl_VentaPagos AS v JOIN tbl_CajaXSucursal AS cs ON v.id_cajaXSucursal = cs.id_cajaXSucursal
		WHERE v.activo = 'true' and cs.id_caja = @txt_Id_Caja AND CONVERT(DATE,cs.fecha_inicio) BETWEEN @txt_FechaInicio AND @txt_FechaFin)

	DECLARE @TotalTransferencia AS MONEY
	set @TotalTransferencia = ( SELECT ISNULL(SUM(v.montoTransferencia),0) FROM tbl_VentaPagos AS v  JOIN tbl_CajaXSucursal as cs ON v.id_cajaXSucursal = cs.id_cajaXSucursal 
		WHERE v.activo = 'true' AND cs.id_caja = @txt_Id_Caja AND CONVERT(DATE,cs.fecha_inicio) BETWEEN @txt_FechaInicio AND @txt_FechaFin)

	DECLARE @RetirosP AS MONEY
	SET @RetirosP = (SELECT  ISNULL(SUM(tbl_Retiros.Monto),0)  FROM tbl_Retiros JOIN tbl_CajaXSucursal AS cs ON tbl_Retiros.id_cajaXSucursal = cs.id_cajaXSucursal WHERE cs.id_caja = @txt_Id_Caja AND CONVERT(DATE,cs.fecha_inicio) BETWEEN @txt_FechaInicio AND @txt_FechaFin AND tbl_Retiros.Tipo = 2 AND tbl_Retiros.Activo='true')

	DECLARE @RetirosC AS MONEY
	SET @RetirosC = (SELECT ISNULL(SUM(tbl_Retiros.Monto),0)  FROM tbl_Retiros JOIN tbl_CajaXSucursal AS cs ON tbl_Retiros.id_cajaXSucursal = cs.id_cajaXSucursal  WHERE cs.id_caja = @txt_Id_Caja AND CONVERT(DATE,cs.fecha_inicio) BETWEEN @txt_FechaInicio AND @txt_FechaFin AND tbl_Retiros.Tipo = 1 AND tbl_Retiros.Activo='true')


	DECLARE @Depositos AS MONEY
	SET @Depositos = (SELECT ISNULL(SUM(tbl_Depositos.Monto),0) FROM tbl_Depositos JOIN tbl_CajaXSucursal AS cs ON tbl_Depositos.id_cajaXSucursal = cs.id_cajaXSucursal  WHERE  cs.id_caja = @txt_Id_Caja AND CONVERT(DATE,cs.fecha_inicio) BETWEEN @txt_FechaInicio AND @txt_FechaFin AND tbl_Depositos.Activo = 'true')

	DECLARE @Caja AS NVARCHAR(100)
	SET @Caja = (SELECT descripcion + '( ' + descripcion2 + ' )' FROM tbl_CatCajas WHERE id_caja = @txt_Id_Caja )
	SELECT
		@Apertura AS Apertura,
		@TotalVta AS TotalVta , 
		@TotalEfectivo AS TotalEfectivo,
		@TotalMonedero AS TotalMonedero,
		@TotalTarjeta AS TotalTarjeta,
		@TotalTransferencia AS TotalTransferencia,
		@fechainicio AS fechainicio , 
		@horainicio AS horainicio, 
		@RetirosP AS RetirosP, 
		@RetirosC AS RetirosC, 
		@Depositos AS Depositos,
		@TotalVtaMaletas AS TotalVtaMaletas,
		@Caja AS Cajero,
		@ventaBoletos AS TotalBoletos
	END
	ELSE
	BEGIN 
		SET @Apertura = 0
		SET @TotalVta = 0
		SET @TotalEfectivo = 0
		SET @TotalMonedero = 0
		SET @TotalTarjeta = 0
		SET @TotalTransferencia = 0
		SET @fechainicio = dbo.fnGetNewDate()
		SET @horainicio = '00:00:00' -- SET @fechainicio = dbo.fnGetNewDate()
		SET @RetirosC = 0
		SET @RetirosP = 0
		SET @Depositos  = 0
		SET @TotalVtaMaletas = 0
		SET @Caja = ''
		SET @ventaBoletos = 0
	SELECT
		@Apertura AS Apertura,
		@TotalVta AS TotalVta , 
		@TotalEfectivo AS TotalEfectivo,
		@TotalMonedero AS TotalMonedero,
		@TotalTarjeta AS TotalTarjeta,
		@TotalTransferencia AS TotalTransferencia,
		@fechainicio AS fechainicio , 
		@horainicio AS horainicio, 
		@RetirosP AS RetirosP, 
		@RetirosC AS RetirosC, 
		@Depositos AS Depositos,
		@TotalVtaMaletas AS TotalVtaMaletas,	
		@Caja AS Cajero,
		@ventaBoletos AS TotalBoletos
	END
END
















GO
/****** Object:  StoredProcedure [dbo].[Obtener_DatosCaja2_Estadisticos]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Obtener_DatosCaja2_Estadisticos]
	@txt_Id_Caja nvarchar(100),
	@txt_FechaInicio date,
	@txt_FechaFin date    
AS
BEGIN
	IF ISNULL(@txt_Id_Caja,'') != ''
	BEGIN
	DECLARE @fechainicio DATETIME
	DECLARE @horainicio DATETIME 

	SELECT @fechainicio = dbo.fnGetNewDate()
	SELECT @horainicio = @fechainicio

	DECLARE @Apertura AS MONEY
	SET @Apertura = (SELECT SUM(Apertura.Total) FROM (
	SELECT ISNULL(SUM(exc.Total),0) AS Total  FROM [dbo].[vtbl_EfectivoXCaja_Estadisticos] AS exc JOIN [dbo].[vtbl_CajaXSucursal_Estadisticos] AS cs ON exc.id_cajaXSucursal = cs.id_cajaXSucursal
	WHERE exc.id_tipoEfectivo = 1 AND cs.id_caja = @txt_Id_Caja  AND CONVERT(DATE, fecha_inicio) BETWEEN @txt_FechaInicio AND @txt_FechaFin) AS Apertura
	)

	DECLARE @ventaBoletos AS MONEY
	SET @ventaBoletos =( SELECT SUM(VentaBoletos.Total) FROM (
		SELECT ISNULL(SUM(vd.pago1 + vd.pago2),0) AS Total
		FROM 
		    [dbo].[vtbl_VentaDetalle_Estadisticos] AS vd INNER JOIN [dbo].[vtbl_VentaCajas_Estadisticos] AS tvc ON tvc.IDGenerico = vd.id_ventadetalle JOIN [dbo].[vtbl_CajaXSucursal_Estadisticos] AS cs ON tvc.IDCajaXSucursal = cs.id_cajaXSucursal	
		WHERE 
		tvc.IDStatus = 1 AND tvc.Activo = 1 AND cs.id_caja = @txt_Id_Caja  AND CONVERT(DATE, fecha_inicio) BETWEEN @txt_FechaInicio AND @txt_FechaFin) AS VentaBoletos
	) 

	DECLARE @reservacionesBoletos AS MONEY
	SET @reservacionesBoletos =( SELECT SUM(ReservacionesBoletos.Total) FROM (
		SELECT ISNULL(SUM(0.0 + 0.0),0) AS Total
		FROM 
		    [dbo].[vtbl_VentaDetalle_Estadisticos] AS vd INNER JOIN [dbo].[vtbl_VentaCajas_Estadisticos] AS tvc ON tvc.IDGenerico = vd.id_ventadetalle JOIN [dbo].[vtbl_CajaXSucursal_Estadisticos] AS cs ON tvc.IDCajaXSucursal = cs.id_cajaXSucursal	
		WHERE 
		tvc.IDStatus = 2 AND tvc.Activo = 1 AND cs.id_caja = @txt_Id_Caja  AND CONVERT(DATE, fecha_inicio) BETWEEN @txt_FechaInicio AND @txt_FechaFin) AS ReservacionesBoletos
	) 

	DECLARE @anticipo1Boletos AS MONEY
	SET @anticipo1Boletos =( SELECT SUM(Anticipo1Boletos.Total) FROM (
		SELECT ISNULL(SUM(vd.pago1 + 0.0),0) AS Total
		FROM 
		    [dbo].[vtbl_VentaDetalle_Estadisticos] AS vd INNER JOIN [dbo].[vtbl_VentaCajas_Estadisticos] AS tvc ON tvc.IDGenerico = vd.id_ventadetalle JOIN [dbo].[vtbl_CajaXSucursal_Estadisticos] AS cs ON tvc.IDCajaXSucursal = cs.id_cajaXSucursal	
		WHERE 
		tvc.IDStatus = 3 AND tvc.Activo = 1 AND cs.id_caja = @txt_Id_Caja  AND CONVERT(DATE, fecha_inicio) BETWEEN @txt_FechaInicio AND @txt_FechaFin) AS Anticipo1Boletos)


	DECLARE @anticipo2Boletos AS MONEY
	SET @anticipo2Boletos =( SELECT SUM(Anticipo2Boletos.Total) FROM (
		SELECT ISNULL(SUM(0.0 + vd.pago2),0) AS Total
		FROM 
		    [dbo].[vtbl_VentaDetalle_Estadisticos] AS vd INNER JOIN [dbo].[vtbl_VentaCajas_Estadisticos] AS tvc ON tvc.IDGenerico = vd.id_ventadetalle JOIN [dbo].[vtbl_CajaXSucursal_Estadisticos] AS cs ON tvc.IDCajaXSucursal = cs.id_cajaXSucursal	
		WHERE 
		tvc.IDStatus = 4 AND tvc.Activo = 1 AND cs.id_caja = @txt_Id_Caja  AND CONVERT(DATE, fecha_inicio) BETWEEN @txt_FechaInicio AND @txt_FechaFin) AS Anticipo2Boletos)


	DECLARE @transferenciasBoletos AS MONEY
	SET @transferenciasBoletos =( SELECT SUM(TransferenciaBoletos.Total) FROM (
		SELECT ISNULL(SUM(vd.pago1 + vd.pago2),0) AS Total
		FROM 
		    [dbo].[vtbl_VentaDetalle_Estadisticos] AS vd INNER JOIN [dbo].[vtbl_VentaCajas_Estadisticos] AS tvc ON tvc.IDGenerico = vd.id_ventadetalle JOIN [dbo].[vtbl_CajaXSucursal_Estadisticos] AS cs ON tvc.IDCajaXSucursal = cs.id_cajaXSucursal	
		WHERE 
		tvc.IDStatus = 5 AND tvc.Activo = 1 AND cs.id_caja = @txt_Id_Caja  AND CONVERT(DATE, fecha_inicio) BETWEEN @txt_FechaInicio AND @txt_FechaFin) AS TransferenciaBoletos)


    DECLARE @cancelacionesBoletos AS MONEY
	SET @cancelacionesBoletos =( SELECT SUM(Cancelaciones.Total) FROM (
		SELECT ISNULL(SUM(vd.pago1 + vd.pago2),0) AS Total
		FROM 
		    [dbo].[vtbl_VentaDetalle_Estadisticos] as vd INNER JOIN [dbo].[vtbl_VentaCajas_Estadisticos] AS tvc ON tvc.IDGenerico = vd.id_ventadetalle JOIN [dbo].[vtbl_CajaXSucursal_Estadisticos] AS cs ON tvc.IDCajaXSucursal = cs.id_cajaXSucursal	
		WHERE 
		tvc.IDStatus = 6 AND tvc.Activo = 1 AND cs.id_caja = @txt_Id_Caja  AND CONVERT(DATE, fecha_inicio) BETWEEN @txt_FechaInicio AND @txt_FechaFin) AS Cancelaciones)


    DECLARE @cancelacionesCobroBoletos AS MONEY
	SET @cancelacionesCobroBoletos =( SELECT SUM(CancelacionesCobro.Total) FROM (
		SELECT ISNULL(SUM(vd.cancelacion),0) AS Total
		FROM 
		    [dbo].[vtbl_VentaDetalle_Estadisticos] AS vd INNER JOIN [dbo].[vtbl_VentaCajas_Estadisticos] AS tvc ON tvc.IDGenerico = vd.id_ventadetalle JOIN [dbo].[vtbl_CajaXSucursal_Estadisticos] AS cs ON tvc.IDCajaXSucursal = cs.id_cajaXSucursal		
		WHERE 
		tvc.IDStatus = 6 AND tvc.Activo = 1 AND cs.id_caja = @txt_Id_Caja  AND CONVERT(DATE, fecha_inicio) BETWEEN @txt_FechaInicio AND @txt_FechaFin) AS CancelacionesCobro)


    DECLARE @TotalVtaMaletas AS MONEY
	SET @TotalVtaMaletas =( SELECT SUM(VentaMaleta.Total) FROM (
		SELECT ISNULL(SUM(tcm.precio),0) AS Total
		FROM 
		    [dbo].[vtbl_CatMaletas_Estadisticos] AS tcm INNER JOIN [dbo].[vtbl_VentaCajas_Estadisticos] AS tvc ON tvc.IDGenerico = tcm.id_maleta JOIN [dbo].[vtbl_CajaXSucursal_Estadisticos] AS cs ON tvc.IDCajaXSucursal = cs.id_cajaXSucursal	
		WHERE 
		tvc.IDStatus = 9 AND tvc.Activo = 1 AND cs.id_caja = @txt_Id_Caja  AND CONVERT(DATE, fecha_inicio) BETWEEN @txt_FechaInicio AND @txt_FechaFin AND tcm.activo = 1) AS VentaMaleta)


    DECLARE @TotalVta AS MONEY
	SET @TotalVta = ( @ventaBoletos + @reservacionesBoletos + @anticipo1Boletos + @anticipo2Boletos + @transferenciasBoletos - @cancelacionesBoletos + @cancelacionesCobroBoletos +  @TotalVtaMaletas)

	    
    DECLARE @TotalEfectivo AS MONEY
	SET @TotalEfectivo = (SELECT SUM(Efectivo.Total) FROM (
		SELECT ISNULL(SUM(v.montoEfectivo),0) AS Total FROM [dbo].[vtbl_VentaPagos_Estadisticos] AS v JOIN [dbo].[vtbl_CajaXSucursal_Estadisticos] AS cs ON v.id_cajaXSucursal = cs.id_cajaXSucursal
		WHERE v.activo = 'true' AND cs.id_caja = @txt_Id_Caja  AND CONVERT(DATE, fecha_inicio) BETWEEN @txt_FechaInicio AND @txt_FechaFin) AS Efectivo)


	SET @TotalEfectivo = @TotalEfectivo - @cancelacionesBoletos + @cancelacionesCobroBoletos + @TotalVtaMaletas

    DECLARE @TotalMonedero AS MONEY
	set @TotalMonedero = ( SELECT SUM(Monedero.Total) FROM (
	    SELECT ISNULL(SUM(v.montoMonedero),0) AS Total FROM [dbo].[vtbl_VentaPagos_Estadisticos] AS v JOIN [dbo].[vtbl_CajaXSucursal_Estadisticos] as cs ON v.id_cajaXSucursal = cs.id_cajaXSucursal 
		WHERE v.activo = 'true' AND cs.id_caja = @txt_Id_Caja  AND CONVERT(DATE, fecha_inicio) BETWEEN @txt_FechaInicio AND @txt_FechaFin) AS Monedero)


	DECLARE @TotalTarjeta AS MONEY
	SET @TotalTarjeta = ( SELECT SUM(Tarjeta.Total) FROM (
	    SELECT ISNULL(SUM(v.montoTarjeta),0) AS Total FROM [dbo].[vtbl_VentaPagos_Estadisticos] AS v JOIN [dbo].[vtbl_CajaXSucursal_Estadisticos] as cs ON v.id_cajaXSucursal = cs.id_cajaXSucursal 
		WHERE v.activo = 'true' AND cs.id_caja = @txt_Id_Caja  AND CONVERT(DATE, fecha_inicio) BETWEEN @txt_FechaInicio AND @txt_FechaFin) AS Tarjeta)


	DECLARE @TotalTransferencia AS MONEY
	SET @TotalTransferencia = ( SELECT SUM(Transferencia.Total) FROM (
	    SELECT ISNULL(SUM(v.montoTransferencia),0) AS Total FROM [dbo].[vtbl_VentaPagos_Estadisticos] AS v JOIN [dbo].[vtbl_CajaXSucursal_Estadisticos] as cs ON v.id_cajaXSucursal = cs.id_cajaXSucursal 
		WHERE v.activo = 'true' AND cs.id_caja = @txt_Id_Caja  AND CONVERT(DATE, fecha_inicio) BETWEEN @txt_FechaInicio AND @txt_FechaFin) AS Transferencia)


	DECLARE @RetirosP AS MONEY
	SET @RetirosP = ( SELECT SUM(Retiros.Total) FROM (
	SELECT  ISNULL(SUM([dbo].[vtbl_Retiros_Estadisticos].Monto),0) AS Total  FROM [dbo].[vtbl_Retiros_Estadisticos] JOIN [dbo].[vtbl_CajaXSucursal_Estadisticos] AS cs ON [dbo].[vtbl_Retiros_Estadisticos].id_cajaXSucursal = cs.id_cajaXSucursal WHERE cs.id_caja = @txt_Id_Caja  AND CONVERT(DATE, fecha_inicio) BETWEEN @txt_FechaInicio AND @txt_FechaFin AND [dbo].[vtbl_Retiros_Estadisticos].Tipo = 2 AND [dbo].[vtbl_Retiros_Estadisticos].Activo='true') AS Retiros)


	DECLARE @RetirosC AS MONEY
	SET @RetirosC = ( SELECT SUM(Retiros2.Total) FROM (
	SELECT ISNULL(SUM([dbo].[vtbl_Retiros_Estadisticos].Monto),0) AS Total  FROM [dbo].[vtbl_Retiros_Estadisticos] JOIN [dbo].[vtbl_CajaXSucursal_Estadisticos] AS cs ON [dbo].[vtbl_Retiros_Estadisticos].id_cajaXSucursal = cs.id_cajaXSucursal  WHERE cs.id_caja = @txt_Id_Caja  AND CONVERT(DATE, fecha_inicio) BETWEEN @txt_FechaInicio AND @txt_FechaFin AND [dbo].[vtbl_Retiros_Estadisticos].Tipo = 1 AND [dbo].[vtbl_Retiros_Estadisticos].Activo='true') AS Retiros2)


	DECLARE @Depositos AS MONEY
	SET @Depositos = ( SELECT SUM(Depositos.Total) FROM (
	SELECT ISNULL(SUM([dbo].[vtbl_Depositos_Estadisticos].Monto),0)  AS Total FROM [dbo].[vtbl_Depositos_Estadisticos] JOIN tbl_CajaXSucursal AS cs ON [dbo].[vtbl_Depositos_Estadisticos].id_cajaXSucursal = cs.id_cajaXSucursal  WHERE  cs.id_caja = @txt_Id_Caja  AND CONVERT(DATE, fecha_inicio) BETWEEN @txt_FechaInicio AND @txt_FechaFin AND [dbo].[vtbl_Depositos_Estadisticos].Activo = 'true') AS Depositos)


	DECLARE @Caja AS NVARCHAR(100)
	SET @Caja = (SELECT descripcion + '( ' + descripcion2 + ' )' FROM tbl_CatCajas WHERE id_caja = @txt_Id_Caja )
	SELECT
		@Apertura AS Apertura,
		@TotalVta AS TotalVta , 
		@TotalEfectivo AS TotalEfectivo,
		@TotalMonedero AS TotalMonedero,
		@TotalTarjeta AS TotalTarjeta,
		@TotalTransferencia AS TotalTransferencia,
		@fechainicio AS fechainicio , 
		@horainicio AS horainicio, 
		@RetirosP AS RetirosP, 
		@RetirosC AS RetirosC, 
		@Depositos AS Depositos,
		@TotalVtaMaletas AS TotalVtaMaletas,
		@Caja AS Cajero,
		@ventaBoletos AS TotalBoletos
	END
	ELSE
	BEGIN 
		SET @Apertura = 0
		SET @TotalVta = 0
		SET @TotalEfectivo = 0
		SET @TotalMonedero = 0
		SET @TotalTarjeta = 0
		SET @TotalTransferencia = 0
		SET @fechainicio = dbo.fnGetNewDate()
		SET @horainicio = '00:00:00' -- SET @fechainicio = dbo.fnGetNewDate()
		SET @RetirosC = 0
		SET @RetirosP = 0
		SET @Depositos  = 0
		SET @TotalVtaMaletas = 0
		SET @Caja = ''
		SET @ventaBoletos = 0
	SELECT
		@Apertura AS Apertura,
		@TotalVta AS TotalVta , 
		@TotalEfectivo AS TotalEfectivo,
		@TotalMonedero AS TotalMonedero,
		@TotalTarjeta AS TotalTarjeta,
		@TotalTransferencia AS TotalTransferencia,
		@fechainicio AS fechainicio , 
		@horainicio AS horainicio, 
		@RetirosP AS RetirosP, 
		@RetirosC AS RetirosC, 
		@Depositos AS Depositos,
		@TotalVtaMaletas AS TotalVtaMaletas,	
		@Caja AS Cajero,
		@ventaBoletos AS TotalBoletos
	END
END





















GO
/****** Object:  StoredProcedure [dbo].[Obtener_DatosCajaSai]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Obtener_DatosCajaSai]
	@txt_Id_Caja nvarchar(100)    
AS
BEGIN
	IF ISNULL(@txt_Id_Caja,'') != ''
	BEGIN
	DECLARE @fechainicio DATETIME
	DECLARE @horainicio  NVARCHAR(8)

	SELECT @fechainicio = fecha_inicio, @horainicio=hora_inicio FROM tbl_CajaXSucursal WHERE
	id_cajaXSucursal = @txt_Id_Caja

	DECLARE @Apertura AS MONEY
	SET @Apertura = ( SELECT ISNULL(SUM(exc.Total),0)  FROM tbl_EfectivoXCaja exc 
		WHERE exc.id_tipoEfectivo = 1 AND exc.id_cajaXSucursal = @txt_Id_Caja )

	DECLARE @ventaBoletos AS MONEY
	SET @ventaBoletos =(
		SELECT ISNULL(SUM(vd.pago1 + vd.pago2),0)
		FROM 
		    tbl_VentaDetalle AS vd INNER JOIN tbl_VentaCajas AS tvc ON tvc.IDGenerico = vd.id_ventadetalle
			INNER JOIN tbl_Boletos AS tb ON tb.id_boleto = vd.id_boleto 	
		WHERE 
		tvc.IDCajaXSucursal = @txt_Id_Caja AND tvc.IDStatus = 1 AND tvc.Activo = 1 AND tb.activoCobro = 1
	) 

	DECLARE @reservacionesBoletos AS MONEY
	SET @reservacionesBoletos =(
		SELECT ISNULL(SUM(0.0 + 0.0),0)
		FROM 
		    tbl_VentaDetalle AS vd INNER JOIN tbl_VentaCajas AS tvc ON tvc.IDGenerico = vd.id_ventadetalle
			INNER JOIN tbl_Boletos AS tb ON tb.id_boleto = vd.id_boleto 			
		WHERE 
		tvc.IDCajaXSucursal = @txt_Id_Caja AND tvc.IDStatus = 2 AND tvc.Activo = 1 AND tb.activoCobro = 1
	) 

	DECLARE @anticipo1Boletos AS MONEY
	SET @anticipo1Boletos =(
		SELECT ISNULL(SUM(vd.pago1 + 0.0),0)
		FROM 
		    tbl_VentaDetalle AS vd INNER JOIN tbl_VentaCajas AS tvc ON tvc.IDGenerico = vd.id_ventadetalle
			INNER JOIN tbl_Boletos AS tb ON tb.id_boleto = vd.id_boleto 		
		WHERE 
		tvc.IDCajaXSucursal = @txt_Id_Caja AND tvc.IDStatus = 3 AND tvc.Activo = 1 AND tb.activoCobro = 1
	)

	DECLARE @anticipo2Boletos AS MONEY
	SET @anticipo2Boletos =(
		SELECT ISNULL(SUM(0.0 + vd.pago2),0)
		FROM 
		    tbl_VentaDetalle AS vd INNER JOIN tbl_VentaCajas AS tvc ON tvc.IDGenerico = vd.id_ventadetalle
			INNER JOIN tbl_Boletos AS tb ON tb.id_boleto = vd.id_boleto 		
		WHERE 
		tvc.IDCajaXSucursal = @txt_Id_Caja AND tvc.IDStatus = 4 AND tvc.Activo = 1 AND tb.activoCobro = 1
	)

	DECLARE @transferenciasBoletos AS MONEY
	SET @transferenciasBoletos =(
		SELECT ISNULL(SUM(vd.pago1 + vd.pago2),0)
		FROM 
		    tbl_VentaDetalle AS vd INNER JOIN tbl_VentaCajas AS tvc ON tvc.IDGenerico = vd.id_ventadetalle
			INNER JOIN tbl_Boletos AS tb ON tb.id_boleto = vd.id_boleto 		
		WHERE 
		tvc.IDCajaXSucursal = @txt_Id_Caja AND tvc.IDStatus = 5 AND tvc.Activo = 1 AND tb.activoCobro = 1
	)

    DECLARE @cancelacionesBoletos AS MONEY
	SET @cancelacionesBoletos =(
		SELECT ISNULL(SUM(vd.pago1 + vd.pago2),0)
		FROM 
		    tbl_VentaDetalle AS vd INNER JOIN tbl_VentaCajas AS tvc ON tvc.IDGenerico = vd.id_ventadetalle	
			INNER JOIN tbl_Boletos AS tb ON tb.id_boleto = vd.id_boleto	
		WHERE 
		tvc.IDCajaXSucursal = @txt_Id_Caja AND tvc.IDStatus = 6 AND tvc.Activo = 1 AND tb.activoCobro = 1
	)

    DECLARE @cancelacionesCobroBoletos AS MONEY
	SET @cancelacionesCobroBoletos =(
		SELECT ISNULL(SUM(vd.cancelacion),0)
		FROM 
		    tbl_VentaDetalle AS vd INNER JOIN tbl_VentaCajas AS tvc ON tvc.IDGenerico = vd.id_ventadetalle
			INNER JOIN tbl_Boletos AS tb ON tb.id_boleto = vd.id_boleto			
		WHERE 
		tvc.IDCajaXSucursal = @txt_Id_Caja AND tvc.IDStatus = 6 AND tvc.Activo = 1 AND tb.activoCobro = 1
	)

    DECLARE @TotalVtaMaletas AS MONEY
	SET @TotalVtaMaletas =(
		SELECT ISNULL(SUM(tcm.precio),0)
		FROM 
		    tbl_CatMaletas AS tcm INNER JOIN tbl_VentaCajas AS tvc ON tvc.IDGenerico = tcm.id_maleta		
		WHERE 
		tvc.IDCajaXSucursal = @txt_Id_Caja AND tvc.IDStatus = 9 AND tvc.Activo = 1 AND tcm.activo = 1
	)

    DECLARE @TotalVta AS MONEY
	SET @TotalVta = ( @ventaBoletos + @reservacionesBoletos + @anticipo1Boletos + @anticipo2Boletos + @transferenciasBoletos - @cancelacionesBoletos + @cancelacionesCobroBoletos +  @TotalVtaMaletas)

	    
    DECLARE @TotalEfectivo AS MONEY
	SET @TotalEfectivo = (@TotalVta)

	SET @TotalEfectivo = @TotalEfectivo - @cancelacionesBoletos + @cancelacionesCobroBoletos + @TotalVtaMaletas

    DECLARE @TotalMonedero AS MONEY
	SET @TotalMonedero = (0.0)

	DECLARE @RetirosP AS MONEY
	SET @RetirosP = (SELECT  ISNULL(SUM(tbl_Retiros.Monto),0)  FROM tbl_Retiros WHERE tbl_Retiros.id_cajaXSucursal = @txt_Id_Caja AND tbl_Retiros.Tipo = 2 AND tbl_Retiros.Activo = 'true')

	DECLARE @RetirosC AS MONEY
	SET @RetirosC = (SELECT ISNULL(SUM(tbl_Retiros.Monto),0)  FROM tbl_Retiros WHERE tbl_Retiros.id_cajaXSucursal = @txt_Id_Caja AND tbl_Retiros.Tipo = 1 AND tbl_Retiros.Activo = 'true')


	DECLARE @Depositos AS MONEY
	SET @Depositos = (SELECT isnull(sum(tbl_Depositos.Monto),0) FROM tbl_Depositos WHERE tbl_Depositos.id_cajaXSucursal = @txt_Id_Caja and tbl_Depositos.Activo = 'true')


	DECLARE @Cajero NVARCHAR(100)
	SET @Cajero = (SELECT tbl_CatUsuario.U_Nombre + ' ' + tbl_CatUsuario.U_Apellidop + ' ' +tbl_CatUsuario.U_Apellidom FROM tbl_CajaXSucursal JOIN tbl_CatUsuario ON tbl_CajaXSucursal.id_cajero = tbl_CatUsuario.Id_U WHERE id_cajaXSucursal = @txt_Id_Caja) 

	SELECT
		@Apertura AS Apertura,
		@TotalVta AS TotalVta , 
		@TotalEfectivo AS TotalEfectivo,
		@TotalMonedero AS TotalMonedero,
		@fechainicio AS fechainicio , 
		@horainicio AS horainicio, 
		@RetirosP AS RetirosP, 
		@RetirosC AS RetirosC, 
		@Depositos AS Depositos,
		@TotalVtaMaletas AS TotalVtaMaletas,
		@Cajero AS Cajero,
		@ventaBoletos AS TotalBoletos

	END
	ELSE
	BEGIN 
		SET @Apertura = 0
		SET @TotalVta = 0
		SET @TotalEfectivo = 0
		SET @TotalMonedero = 0
		SET @fechainicio = dbo.fnGetNewDate()
		SET @horainicio = '00:00:00'
		SET @RetirosC = 0
		SET @RetirosP = 0
		SET @Depositos  = 0
		SET @TotalVtaMaletas = 0
		SET @Cajero = ''
		SET @ventaBoletos = 0
	SELECT
		@Apertura AS Apertura,
		@TotalVta AS TotalVta , 
		@TotalEfectivo AS TotalEfectivo,
		@TotalMonedero AS TotalMonedero,
		@fechainicio AS fechainicio , 
		@horainicio AS horainicio, 
		@RetirosP AS RetirosP, 
		@RetirosC AS RetirosC, 
		@Depositos AS Depositos,
		@TotalVtaMaletas AS TotalVtaMaletas,
		@Cajero AS Cajero,
		@ventaBoletos AS TotalBoletos
	END
END





GO
/****** Object:  StoredProcedure [dbo].[Obtener_DatosCajaSai_Estadisticos]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Obtener_DatosCajaSai_Estadisticos]
	@txt_Id_Caja nvarchar(100)    
AS
BEGIN
	IF ISNULL(@txt_Id_Caja,'') != ''
	BEGIN
	DECLARE @fechainicio DATETIME
	DECLARE @horainicio  NVARCHAR(8)

	IF(EXISTS(SELECT id_caja FROM [dbo].[vtbl_CajaXSucursal_Estadisticos] WHERE id_cajaXSucursal = @txt_Id_Caja))
	BEGIN
		SELECT @fechainicio = fecha_inicio, @horainicio=hora_inicio FROM tbl_CajaXSucursal WHERE
		id_cajaXSucursal = @txt_Id_Caja
	END


	DECLARE @Apertura AS MONEY
	SET @Apertura = (SELECT SUM(Apertura.Total) FROM (
		SELECT ISNULL(SUM(exc.Total),0) AS Total  FROM [dbo].[vtbl_EfectivoXCaja_Estadisticos] exc 
		WHERE exc.id_tipoEfectivo = 1 AND exc.id_cajaXSucursal = @txt_Id_Caja ) AS Apertura
	)

	DECLARE @ventaBoletos AS MONEY
	SET @ventaBoletos =(SELECT SUM(VentaBoletos.Total) FROM (
		SELECT ISNULL(SUM(vd.pago1 + vd.pago2),0) AS Total 
		FROM 
		    [dbo].[vtbl_VentaDetalle_Estadisticos] AS vd INNER JOIN [dbo].[vtbl_VentaCajas_Estadisticos] AS tvc ON tvc.IDGenerico = vd.id_ventadetalle
			INNER JOIN [dbo].[vtbl_Boletos_Estadisticos] AS tb ON tb.id_boleto = vd.id_boleto 	
		WHERE 
		tvc.IDCajaXSucursal = @txt_Id_Caja AND tvc.IDStatus = 1 AND tvc.Activo = 1 AND tb.activoCobro = 1) AS VentaBoletos
	)

	DECLARE @reservacionesBoletos AS MONEY
	SET @reservacionesBoletos =(SELECT SUM(Reservaciones.Total) FROM (
		SELECT ISNULL(SUM(0.0 + 0.0),0) AS Total
		FROM 
		    [dbo].[vtbl_VentaDetalle_Estadisticos] AS vd INNER JOIN [dbo].[vtbl_VentaCajas_Estadisticos] AS tvc ON tvc.IDGenerico = vd.id_ventadetalle
			INNER JOIN [dbo].[vtbl_Boletos_Estadisticos] AS tb ON tb.id_boleto = vd.id_boleto 			
		WHERE 
		tvc.IDCajaXSucursal = @txt_Id_Caja AND tvc.IDStatus = 2 AND tvc.Activo = 1 AND tb.activoCobro = 1) AS Reservaciones
	) 

	DECLARE @anticipo1Boletos AS MONEY
	SET @anticipo1Boletos =(SELECT SUM(Anticipo1.Total) FROM (
		SELECT ISNULL(SUM(vd.pago1 + 0.0),0) AS Total
		FROM 
		    [dbo].[vtbl_VentaDetalle_Estadisticos] AS vd INNER JOIN [dbo].[vtbl_VentaCajas_Estadisticos] AS tvc ON tvc.IDGenerico = vd.id_ventadetalle
			INNER JOIN [dbo].[vtbl_Boletos_Estadisticos] AS tb ON tb.id_boleto = vd.id_boleto 		
		WHERE 
		tvc.IDCajaXSucursal = @txt_Id_Caja AND tvc.IDStatus = 3 AND tvc.Activo = 1 AND tb.activoCobro = 1) AS Anticipo1
	)

	DECLARE @anticipo2Boletos AS MONEY
	SET @anticipo2Boletos =(SELECT SUM(Anticipo2.Total) FROM (
		SELECT ISNULL(SUM(0.0 + vd.pago2),0) AS Total
		FROM 
		    [dbo].[vtbl_VentaDetalle_Estadisticos] AS vd INNER JOIN [dbo].[vtbl_VentaCajas_Estadisticos] AS tvc ON tvc.IDGenerico = vd.id_ventadetalle
			INNER JOIN [dbo].[vtbl_Boletos_Estadisticos] AS tb ON tb.id_boleto = vd.id_boleto 		
		WHERE 
		tvc.IDCajaXSucursal = @txt_Id_Caja AND tvc.IDStatus = 4 AND tvc.Activo = 1 AND tb.activoCobro = 1) AS Anticipo2
	)

	DECLARE @transferenciasBoletos AS MONEY
	SET @transferenciasBoletos =(SELECT SUM(transferencia.Total) FROM (
		SELECT ISNULL(SUM(vd.pago1 + vd.pago2),0) AS Total
		FROM 
		    [dbo].[vtbl_VentaDetalle_Estadisticos] AS vd INNER JOIN [dbo].[vtbl_VentaCajas_Estadisticos] AS tvc ON tvc.IDGenerico = vd.id_ventadetalle
			INNER JOIN [dbo].[vtbl_Boletos_Estadisticos] AS tb ON tb.id_boleto = vd.id_boleto 		
		WHERE 
		tvc.IDCajaXSucursal = @txt_Id_Caja AND tvc.IDStatus = 5 AND tvc.Activo = 1 AND tb.activoCobro = 1) AS transferencia
	)

    DECLARE @cancelacionesBoletos AS MONEY
	SET @cancelacionesBoletos =(SELECT SUM(cancelaciones.Total) FROM (
		SELECT ISNULL(SUM(vd.pago1 + vd.pago2),0) AS Total
		FROM 
		    [dbo].[vtbl_VentaDetalle_Estadisticos] AS vd INNER JOIN [dbo].[vtbl_VentaCajas_Estadisticos] AS tvc ON tvc.IDGenerico = vd.id_ventadetalle	
			INNER JOIN [dbo].[vtbl_Boletos_Estadisticos] AS tb ON tb.id_boleto = vd.id_boleto	
		WHERE 
		tvc.IDCajaXSucursal = @txt_Id_Caja AND tvc.IDStatus = 6 AND tvc.Activo = 1 AND tb.activoCobro = 1) AS cancelaciones
	)

    DECLARE @cancelacionesCobroBoletos AS MONEY
	SET @cancelacionesCobroBoletos =(SELECT SUM(cancelacionesCobro.Total) FROM (
		SELECT ISNULL(SUM(vd.cancelacion),0) AS Total
		FROM 
		    [dbo].[vtbl_VentaDetalle_Estadisticos] AS vd INNER JOIN [dbo].[vtbl_VentaCajas_Estadisticos] AS tvc ON tvc.IDGenerico = vd.id_ventadetalle
			INNER JOIN [dbo].[vtbl_Boletos_Estadisticos] AS tb ON tb.id_boleto = vd.id_boleto			
		WHERE 
		tvc.IDCajaXSucursal = @txt_Id_Caja AND tvc.IDStatus = 6 AND tvc.Activo = 1 AND tb.activoCobro = 1) AS cancelacionesCobro
	)

    DECLARE @TotalVtaMaletas AS MONEY
	SET @TotalVtaMaletas =(SELECT SUM(VentasMaletas.Total) FROM (
		SELECT ISNULL(SUM(tcm.precio),0) AS Total
		FROM 
		    [dbo].[vtbl_CatMaletas_Estadisticos] AS tcm INNER JOIN [dbo].[vtbl_VentaCajas_Estadisticos] AS tvc ON tvc.IDGenerico = tcm.id_maleta		
		WHERE 
		tvc.IDCajaXSucursal = @txt_Id_Caja AND tvc.IDStatus = 9 AND tvc.Activo = 1 AND tcm.activo = 1) AS VentasMaletas
	)

    DECLARE @TotalVta AS MONEY
	SET @TotalVta = ( @ventaBoletos + @reservacionesBoletos + @anticipo1Boletos + @anticipo2Boletos + @transferenciasBoletos - @cancelacionesBoletos + @cancelacionesCobroBoletos +  @TotalVtaMaletas)

	    
    DECLARE @TotalEfectivo AS MONEY
	SET @TotalEfectivo = (@TotalVta)

	SET @TotalEfectivo = @TotalEfectivo - @cancelacionesBoletos + @cancelacionesCobroBoletos + @TotalVtaMaletas

    DECLARE @TotalMonedero AS MONEY
	SET @TotalMonedero = (0.0)

	DECLARE @RetirosP AS MONEY
	SET @RetirosP = (SELECT SUM(Retiros.Total) FROM (
	SELECT  ISNULL(SUM([dbo].[vtbl_Retiros_Estadisticos].Monto),0) AS Total  FROM [dbo].[vtbl_Retiros_Estadisticos] WHERE [dbo].[vtbl_Retiros_Estadisticos].id_cajaXSucursal = @txt_Id_Caja AND [dbo].[vtbl_Retiros_Estadisticos].Tipo = 2 AND [dbo].[vtbl_Retiros_Estadisticos].Activo = 'true') AS Retiros)

	DECLARE @RetirosC AS MONEY
	SET @RetirosC = (SELECT SUM(Retiros.Total) FROM (
	SELECT ISNULL(SUM([dbo].[vtbl_Retiros_Estadisticos].Monto),0) AS Total  FROM [dbo].[vtbl_Retiros_Estadisticos] WHERE [dbo].[vtbl_Retiros_Estadisticos].id_cajaXSucursal = @txt_Id_Caja AND [dbo].[vtbl_Retiros_Estadisticos].Tipo = 1 AND [dbo].[vtbl_Retiros_Estadisticos].Activo = 'true') AS Retiros)


	DECLARE @Depositos AS MONEY
	SET @Depositos = (SELECT SUM(Depositos.Total) FROM (
	SELECT ISNULL(SUM([dbo].[vtbl_Depositos_Estadisticos].Monto),0) AS Total FROM [dbo].[vtbl_Depositos_Estadisticos] WHERE [dbo].[vtbl_Depositos_Estadisticos].id_cajaXSucursal = @txt_Id_Caja and [dbo].[vtbl_Depositos_Estadisticos].Activo = 'true') AS Depositos)


	DECLARE @Cajero NVARCHAR(100)
	SET @Cajero = (SELECT tbl_CatUsuario.U_Nombre + ' ' + tbl_CatUsuario.U_Apellidop + ' ' +tbl_CatUsuario.U_Apellidom FROM [dbo].[vtbl_CajaXSucursal_Estadisticos] JOIN tbl_CatUsuario ON [dbo].[vtbl_CajaXSucursal_Estadisticos].id_cajero = tbl_CatUsuario.Id_U WHERE id_cajaXSucursal = @txt_Id_Caja) 

	SELECT
		@Apertura AS Apertura,
		@TotalVta AS TotalVta , 
		@TotalEfectivo AS TotalEfectivo,
		@TotalMonedero AS TotalMonedero,
		@fechainicio AS fechainicio , 
		@horainicio AS horainicio, 
		@RetirosP AS RetirosP, 
		@RetirosC AS RetirosC, 
		@Depositos AS Depositos,
		@TotalVtaMaletas AS TotalVtaMaletas,
		@Cajero AS Cajero,
		@ventaBoletos AS TotalBoletos

	END
	ELSE
	BEGIN 
		SET @Apertura = 0
		SET @TotalVta = 0
		SET @TotalEfectivo = 0
		SET @TotalMonedero = 0
		SET @fechainicio = dbo.fnGetNewDate()
		SET @horainicio = '00:00:00'
		SET @RetirosC = 0
		SET @RetirosP = 0
		SET @Depositos  = 0
		SET @TotalVtaMaletas = 0
		SET @Cajero = ''
		SET @ventaBoletos = 0
	SELECT
		@Apertura AS Apertura,
		@TotalVta AS TotalVta , 
		@TotalEfectivo AS TotalEfectivo,
		@TotalMonedero AS TotalMonedero,
		@fechainicio AS fechainicio , 
		@horainicio AS horainicio, 
		@RetirosP AS RetirosP, 
		@RetirosC AS RetirosC, 
		@Depositos AS Depositos,
		@TotalVtaMaletas AS TotalVtaMaletas,
		@Cajero AS Cajero,
		@ventaBoletos AS TotalBoletos
	END
END







GO
/****** Object:  StoredProcedure [dbo].[Obtener_Disenios]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[Obtener_Disenios]
	@opcion		INT 
AS
BEGIN
	
	BEGIN TRY

	IF @opcion = 1
	BEGIN
		(SELECT 
			cd.id_disenioCamion,
			cd.nombre
		FROM
			tbl_CatDisenio AS cd
		WHERE activo = 1		
		UNION
		SELECT 
			'' AS id_disenioCamion,
			'-- Seleccione --' AS nombre)
		ORDER BY nombre

	END
	IF @opcion = 2
	BEGIN 
		SELECT 
			cd.id_disenioCamion,
			cd.nombre
		FROM
			tbl_CatDisenio AS cd
		WHERE activo = 1	
		ORDER BY nombre
	END
	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------
	END CATCH
END



























GO
/****** Object:  StoredProcedure [dbo].[Obtener_HorariosxViaje]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Obtener_HorariosxViaje]
		@id_viaje	NVARCHAR(100)
AS
BEGIN
	BEGIN TRY

		SET NOCOUNT ON

		DECLARE
			@MensajeError	VARCHAR(1000)

			SELECT
				id_horario,
				id_viaje,
				horario	
			FROM 
				tbl_CatViajeXHorarios AS cvh
			WHERE
				id_viaje = @id_viaje
				AND activo = 1

	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		SELECT @MensajeError	= ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END

























GO
/****** Object:  StoredProcedure [dbo].[Obtener_Maletas]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[Obtener_Maletas]
	@IDBoleto		NVARCHAR(100),
	@IDMaleta		NVARCHAR(100)
AS
BEGIN
	
	BEGIN TRY

		SELECT id_boleto
			  ,id_maleta
			  ,folioMaleta
			  ,descripcion
			  ,precio
			  ,numeroMaletas
			  ,folio
			  ,nombreCliente
			  ,asiento
			  ,fecha_salida
			  ,hora_salida
			  ,cajero
		  FROM dbo.vtbl_MaletasImpresion
		  WHERE id_boleto = @IDboleto AND id_maleta = @IDMaleta

	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------
	END CATCH
END































GO
/****** Object:  StoredProcedure [dbo].[Obtener_Marcas]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[Obtener_Marcas]
	@opcion		INT 
AS
BEGIN
	
	BEGIN TRY

	IF @opcion = 1
	BEGIN
		(SELECT 
			cm.id_marca,
			cm.marca
		FROM
			tbl_CatMarcas AS cm
		WHERE
			cm.activo = 1
		UNION
		SELECT 
			0 as id_marca,
			'-- Seleccione --' AS marca)
		ORDER BY id_marca

	END
	IF @opcion = 2
	BEGIN 
		SELECT 
			cm.id_marca,
			cm.marca
		FROM
			tbl_CatMarcas AS cm
		WHERE
			cm.activo = 1
		ORDER BY cm.id_marca
	END
	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------
	END CATCH
END




























GO
/****** Object:  StoredProcedure [dbo].[Obtener_NEWID]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER PROCEDURE [dbo].[Obtener_NEWID]		
AS
BEGIN
	BEGIN TRY

		SET NOCOUNT ON
		
		SELECT NEWID()

	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END


































GO
/****** Object:  StoredProcedure [dbo].[Obtener_PorcentajeMonedero]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[Obtener_PorcentajeMonedero]
AS
BEGIN
	BEGIN TRY

		SET NOCOUNT ON

     SELECT 
			'Todas' AS IDSucursal, 
			MAX(tbl_CatSucursales.porcentaje_puntos) AS Porcentaje_Monedero, 
			MAX(tbl_CatSucursales.monto_cancelacion) AS Cancelacion 
	FROM tbl_CatSucursales  
			
	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END
































GO
/****** Object:  StoredProcedure [dbo].[Obtener_Reporte_Clientes_Mas_Gasto]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER PROCEDURE [dbo].[Obtener_Reporte_Clientes_Mas_Gasto]	
	@yr INT
   ,@IDSucursal    NVARCHAR(100)
AS
BEGIN
SET NOCOUNT ON;
	BEGIN TRY	 	
		SELECT TOP 5 
			c.nombre + ' ' + c.apePat + ' ' + c.apeMat AS cliente, sc.total
		FROM 
			tbl_CatClientes as c
		JOIN (
			SELECT 
				v.id_cliente, SUM(v.total) AS total
			FROM
				tbl_Venta as v
			WHERE
				{fn YEAR(v.fec_venta)} = @yr
			GROUP BY 
				v.id_cliente
	
			) AS sc
		ON (c.id_cliente = sc.id_cliente)
		ORDER BY sc.total DESC
	END TRY
	BEGIN CATCH
	-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		ROLLBACK TRANSACTION
		-- -----------------------------------------------------------------------------------------
	END CATCH	   
END

























GO
/****** Object:  StoredProcedure [dbo].[Obtener_Reporte_Clientes_Mas_Gasto_Estadisticos]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





ALTER PROCEDURE [dbo].[Obtener_Reporte_Clientes_Mas_Gasto_Estadisticos]	
	@yr INT
   ,@IDSucursal    NVARCHAR(100)
AS
BEGIN
SET NOCOUNT ON;
	BEGIN TRY	 	
		SELECT TOP 5 
			c.nombre + ' ' + c.apePat + ' ' + c.apeMat AS cliente, sc.total
		FROM 
			tbl_CatClientes as c
		JOIN (
		SELECT SUM(Ventas.total) AS total , Ventas.id_cliente FROM(
			SELECT 
				v.id_cliente, SUM(v.total) AS total
			FROM
				[dbo].[vtbl_Venta_Estadisticos] as v
			WHERE
				{fn YEAR(v.fec_venta)} = @yr
			GROUP BY 
				v.id_cliente) AS Ventas	
			GROUP BY Ventas.id_cliente
			) AS sc
		ON (c.id_cliente = sc.id_cliente)
		ORDER BY sc.total DESC
	END TRY
	BEGIN CATCH
	-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		ROLLBACK TRANSACTION
		-- -----------------------------------------------------------------------------------------
	END CATCH	   
END



























GO
/****** Object:  StoredProcedure [dbo].[Obtener_Reporte_Clientes_Mas_Llego]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[Obtener_Reporte_Clientes_Mas_Llego]	
	@yr INT
   ,@IDSucursal    NVARCHAR(100)
AS
BEGIN
SET NOCOUNT ON;
	BEGIN TRY	 	
		SELECT TOP 5 
			c.nombre + ' ' + c.apePat + ' ' + c.apeMat AS cliente, sc.veces
		FROM 
			tbl_CatClientes AS c
		JOIN (
			SELECT 
				v.id_cliente, COUNT(v.id_cliente) AS veces
			FROM
				tbl_Venta AS v
			WHERE
				{fn YEAR(v.fec_venta)} = @yr
			GROUP BY 
				v.id_cliente		
			) AS sc
		ON (c.id_cliente = sc.id_cliente)
		ORDER BY sc.veces DESC
	END TRY
	BEGIN CATCH
	-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		ROLLBACK TRANSACTION
		-- -----------------------------------------------------------------------------------------
	END CATCH	   
END

























GO
/****** Object:  StoredProcedure [dbo].[Obtener_Reporte_Clientes_Mas_Llego_Estadisticos]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





ALTER PROCEDURE [dbo].[Obtener_Reporte_Clientes_Mas_Llego_Estadisticos]	
	@yr INT
   ,@IDSucursal    NVARCHAR(100)
AS
BEGIN
SET NOCOUNT ON;
	BEGIN TRY	 	
		SELECT TOP 5 
			c.nombre + ' ' + c.apePat + ' ' + c.apeMat AS cliente, sc.veces
		FROM 
			tbl_CatClientes AS c
		JOIN (
		SELECT SUM(Ventas.veces) AS veces, Ventas.id_cliente FROM(
			SELECT 
				v.id_cliente, COUNT(v.id_cliente) AS veces
			FROM
				[dbo].[vtbl_Venta_Estadisticos] AS v
			WHERE
				{fn YEAR(v.fec_venta)} = @yr
			GROUP BY 
				v.id_cliente) AS Ventas
			GROUP BY Ventas.id_cliente	 		
			) AS sc
		ON (c.id_cliente = sc.id_cliente)
		ORDER BY sc.veces DESC
	END TRY
	BEGIN CATCH
	-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		ROLLBACK TRANSACTION
		-- -----------------------------------------------------------------------------------------
	END CATCH	   
END




























GO
/****** Object:  StoredProcedure [dbo].[Obtener_RutasIntermedias_Activas]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[Obtener_RutasIntermedias_Activas]
		@id_ruta	NVARCHAR(100)
AS
BEGIN	
	BEGIN TRY

		SELECT 
			cr.id_terminalXruta,
			cr.id_ruta,
			cr.id_terminalSalida,
			cr.id_terminalDestino,
			cr.id_tipoTerminal,
			co.nombre AS terminalOrigen,
			cd.nombre AS terminalDestino,
			cr.tiempoMinutos,
			cr.indice			
		FROM
			tbl_CatTerminalesXRuta AS cr
			JOIN tbl_CatTerminales AS co ON cr.id_terminalSalida = co.id_terminal
			JOIN tbl_CatTerminales AS cd ON cr.id_terminalDestino = cd.id_terminal			
		WHERE
			cr.id_tipoTerminal = 2
			AND cr.id_ruta = @id_ruta
			AND cr.activo = 1
		ORDER BY
			cr.indice
			
	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------
	END CATCH
END





























GO
/****** Object:  StoredProcedure [dbo].[Obtener_RutasPrincipales_Activas]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[Obtener_RutasPrincipales_Activas]
	
AS
BEGIN
	
	BEGIN TRY

		SELECT
			cr.id_ruta, 
			ctr.id_terminalXruta,			
			ctr.id_terminalSalida,
			ctr.id_terminalDestino,
			ctr.id_tipoTerminal,			
			co.nombre as terminalOrigen,
			cd.nombre as terminalDestino,
			ctr.tiempoMinutos,
			'' as tiempo,
			ctr.indice		
		FROM
			tbl_CatRutas as cr JOIN
			tbl_CatTerminalesXRuta as ctr ON ctr.id_ruta = cr.id_ruta
			JOIN tbl_CatTerminales as co ON ctr.id_terminalSalida = co.id_terminal
			JOIN tbl_CatTerminales as cd ON ctr.id_terminalDestino = cd.id_terminal			
		WHERE
			ctr.id_tipoTerminal = 1
			ANd cr.activo = 1
			
	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------
	END CATCH
END





























GO
/****** Object:  StoredProcedure [dbo].[Obtener_RutasViajesxIDRuta]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[Obtener_RutasViajesxIDRuta]
		@id_ruta	       NVARCHAR(100),
		@id_viaje		   NVARCHAR(100),
		@fecha_salida      DATE
AS
BEGIN	
	BEGIN TRY

		SELECT 
			cr.id_terminalXruta,
			cr.id_ruta,
			cr.id_terminalSalida,
			cr.id_terminalDestino,
			cr.id_tipoTerminal,
			co.nombre AS terminalOrigen,
			cd.nombre AS terminalDestino,
			cr.tiempoMinutos,
			[dbo].[ObtnerAsientosXRutasViaje](cv.id_identificador,cr.id_ruta,cvxf.fechaviaje,oro.orden, ord.orden) AS asientosOcupados,
			oro.orden 	AS ordenOrigen,
			ord.orden AS ordenDestino
		FROM
			tbl_CatRutas AS catr 
			JOIN tbl_CatTerminalesXRuta as cr ON cr.id_ruta = catr.id_ruta
			JOIN tbl_CatTerminales AS co ON cr.id_terminalSalida = co.id_terminal
			JOIN tbl_CatTerminales AS cd ON cr.id_terminalDestino = cd.id_terminal
			JOIN tbl_OrdenRuta AS oro ON oro.id_ruta = catr.id_ruta AND oro.id_terminal = co.id_terminal AND oro.activo = 1
			JOIN tbl_OrdenRuta AS ord ON ord.id_ruta = catr.id_ruta AND ord.id_terminal = cd.id_terminal AND ord.activo = 1
			JOIN tbl_CatViajes AS cv ON cv.id_ruta = catr.id_ruta
			JOIN tbl_CatViajesXFecha AS cvxf  ON cvxf.id_viaje = cv.id_identificador AND cvxf.activo = 1
		WHERE			
			cr.id_ruta = @id_ruta
			AND cv.id_identificador = @id_viaje
			AND cvxf.fechaviaje = @fecha_salida
			AND cr.activo = 1
		ORDER BY 
			cr.indice
	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------
	END CATCH
END
































GO
/****** Object:  StoredProcedure [dbo].[Obtener_RutasViajesxIDRutaCompleto]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[Obtener_RutasViajesxIDRutaCompleto]
		@id_ruta	       NVARCHAR(100),
		@id_viaje		   NVARCHAR(100),
		@fecha_salida	   DATE
AS
BEGIN	
	BEGIN TRY

		SELECT TOP 1
			cr.id_terminalXruta,
			cr.id_ruta,
			cr.id_terminalSalida,
			cr.id_terminalDestino,
			cr.id_tipoTerminal,
			co.nombre AS terminalOrigen,
			cd.nombre AS terminalDestino,
			cr.tiempoMinutos,
			[dbo].[ObtnerAsientosXRutasViajeCompleto](cv.id_identificador,cr.id_ruta,@fecha_salida,oro.orden, ord.orden) AS asientosOcupados,
			oro.orden 	AS ordenOrigen,
			ord.orden AS ordenDestino
		FROM
			tbl_CatRutas AS catr 
			JOIN tbl_CatTerminalesXRuta as cr ON cr.id_ruta = catr.id_ruta
			JOIN tbl_CatTerminales AS co ON cr.id_terminalSalida = co.id_terminal
			JOIN tbl_CatTerminales AS cd ON cr.id_terminalDestino = cd.id_terminal
			JOIN tbl_OrdenRuta AS oro ON oro.id_ruta = catr.id_ruta AND oro.id_terminal = co.id_terminal AND oro.activo = 1
			JOIN tbl_OrdenRuta AS ord ON ord.id_ruta = catr.id_ruta AND ord.id_terminal = cd.id_terminal AND ord.activo = 1
			JOIN tbl_CatViajes AS cv ON cv.id_ruta = catr.id_ruta
			JOIN tbl_CatViajesXFecha AS cvxf  ON cvxf.id_viaje = cv.id_identificador AND cvxf.activo = 1
		WHERE			
			cr.id_ruta = @id_ruta
			AND cv.id_identificador = @id_viaje
			AND cr.activo = 1
		ORDER BY 
			cr.indice
	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------
	END CATCH
END
































GO
/****** Object:  StoredProcedure [dbo].[Obtener_RutasxIDRuta]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[Obtener_RutasxIDRuta]
		@id_ruta	NVARCHAR(100)
AS
BEGIN	
	BEGIN TRY

		SELECT 
			cr.id_terminalXruta,
			cr.id_ruta,
			cr.id_terminalSalida,
			cr.id_terminalDestino,
			cr.id_tipoTerminal,
			co.nombre AS terminalOrigen,
			cd.nombre AS terminalDestino,
			cr.tiempoMinutos			
		FROM
			tbl_CatRutas AS catr 
			JOIN tbl_CatTerminalesXRuta as cr ON cr.id_ruta = catr.id_ruta
			JOIN tbl_CatTerminales AS co ON cr.id_terminalSalida = co.id_terminal
			JOIN tbl_CatTerminales AS cd ON cr.id_terminalDestino = cd.id_terminal
			
		WHERE			
			cr.id_ruta = @id_ruta
			AND cr.activo = 1
			AND cr.id_tipoTerminal NOT IN (3)
		ORDER BY 
			cr.indice
	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------
	END CATCH
END





























GO
/****** Object:  StoredProcedure [dbo].[Obtener_RutasxIDRutaTodas]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER PROCEDURE [dbo].[Obtener_RutasxIDRutaTodas]
		@id_ruta	NVARCHAR(100)
AS
BEGIN	
	BEGIN TRY

		SELECT 
			cr.id_terminalXruta,
			cr.id_ruta,
			cr.id_terminalSalida,
			cr.id_terminalDestino,
			cr.id_tipoTerminal,
			co.nombre AS terminalOrigen,
			cd.nombre AS terminalDestino,
			cr.tiempoMinutos,
			oro.orden 	AS ordenOrigen,
			ord.orden AS ordenDestino			
		FROM
			tbl_CatRutas AS catr 
			JOIN tbl_CatTerminalesXRuta as cr ON cr.id_ruta = catr.id_ruta
			JOIN tbl_CatTerminales AS co ON cr.id_terminalSalida = co.id_terminal
			JOIN tbl_CatTerminales AS cd ON cr.id_terminalDestino = cd.id_terminal
			JOIN tbl_OrdenRuta AS oro ON oro.id_ruta = catr.id_ruta AND oro.id_terminal = co.id_terminal AND oro.activo = 1
			JOIN tbl_OrdenRuta AS ord ON ord.id_ruta = catr.id_ruta AND ord.id_terminal = cd.id_terminal AND ord.activo = 1
		WHERE			
			cr.id_ruta = @id_ruta
			AND cr.activo = 1
		ORDER BY 
			cr.indice
	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------
	END CATCH
END






























GO
/****** Object:  StoredProcedure [dbo].[Obtener_Submarcas]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[Obtener_Submarcas]
	@opcion		INT,
	@id_marca	INT
AS
BEGIN
	
	BEGIN TRY

	IF @opcion = 1
	BEGIN
		(SELECT 
			cs.id_submarca,
			cs.submarca
		FROM
			tbl_CatSubMarcas AS cs
		WHERE
			cs.activo = 1
			AND cs.id_marca = @id_marca
		UNION
		SELECT 
			0 as id_submarca,
			'-- Seleccione --' AS submarca)
		ORDER BY id_submarca
	END
	IF @opcion = 2
	BEGIN 
		SELECT 
			cs.id_submarca,
			cs.submarca
		FROM
			tbl_CatSubMarcas AS cs
		WHERE
			cs.activo = 1
			AND cs.id_marca = @id_marca
		ORDER BY cs.id_submarca
	END
	IF @opcion = 3
	BEGIN 
		SELECT 
			cs.id_submarca,
			cs.submarca,
			cs.id_marca,
			cm.marca
		FROM
			tbl_CatSubMarcas AS cs
		INNER JOIN
			tbl_CatMarcas AS cm
		ON
			cs.activo = 1 AND cs.id_marca = cm.id_marca
		ORDER BY cs.id_submarca
	END
	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------
	END CATCH
END





























GO
/****** Object:  StoredProcedure [dbo].[Obtener_tarifas]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[Obtener_tarifas]
		--@opcion				INT		
AS
BEGIN
	BEGIN TRY

		SET NOCOUNT ON

		DECLARE @MensajeError	VARCHAR(1000)			

			SELECT 
				cvt.id_tarifa,
				cv.id_identificador,
				ctrp.id_terminalXruta,
				cv.nombre,	
				cc.descripcion,			
				cto.nombre as terminalOrigen,
				ctd.nombre as terminalDestino,
				isnull(cvt.precioEspecial1, 0) as precioEspecial1,
				isnull(cvt.precioInfantil1, 0) as precioInfantil1,
				isnull(cvt.precioNormal1, 0) as precioNormal1,
				isnull(cvt.precioTerceraEdad1, 0) as precioTerceraEdad1,
				isnull(cvt.precioEspecial2, 0) as precioEspecial2,
				isnull(cvt.precioInfantil2, 0) as precioInfantil2,
				isnull(cvt.precioNormal2, 0) as precioNormal2,
				isnull(cvt.precioTerceraEdad2, 0) as precioTerceraEdad2
			FROM 
				tbl_CatViajes as cv
				JOIN tbl_CatCamiones as cc ON cv.id_camion = cc.id_camion
				JOIN tbl_CatRutas as cr ON cr.id_ruta = cv.id_ruta
				JOIN tbl_CatTerminalesXRuta as ctrp ON cr.id_ruta = ctrp.id_ruta
				JOIN tbl_CatTerminales as cto ON ctrp.id_terminalSalida = cto.id_terminal
				JOIN tbl_CatTerminales as ctd ON ctrp.id_terminalDestino = ctd.id_terminal
				LEFT JOIN tbl_CatViajeXTarifas as cvt ON cv.id_identificador = cvt.id_viaje AND cvt.id_terminalXruta = ctrp.id_terminalXruta

			WHERE 
				cv.activo = 1
				AND cr.activo = 1
				AND ctrp.activo = 1		
				AND ctrp.id_tipoTerminal = 1
				AND cv.id_tipoViaje != 3
				
			ORDER BY cv.nombre						

	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		SELECT @MensajeError	= ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END



























GO
/****** Object:  StoredProcedure [dbo].[Obtener_Terminales_Activas]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[Obtener_Terminales_Activas]
	
AS
BEGIN
	
	BEGIN TRY

		SELECT 
			ct.id_terminal,
			ct.nombre,
			cp.descripcion AS pais,
			ce.descripcion AS estado,
			cm.descripcion AS municipio,
			ct.direccion,
			ct.telefonos,
			ct.id_pais,
			ct.id_estado,
			ct.id_municipio
			
		FROM
			tbl_CatTerminales AS ct			
			JOIN tbl_CatMunicipios AS cm ON ct.id_municipio = cm.id_municipio
			JOIN tbl_CatEstados AS ce ON ce.id_estado = cm.id_estado AND ct.id_estado = ce.id_estado
			JOIN tbl_CatPaises AS cp ON cp.id_pais = cm.id_pais AND ct.id_pais = cp.id_pais			
		WHERE
			ct.activo = 1
	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------
	END CATCH
END



























GO
/****** Object:  StoredProcedure [dbo].[Obtener_TerminalesxRutaxViaje]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




ALTER PROCEDURE [dbo].[Obtener_TerminalesxRutaxViaje]
		@opcion				INT,
		@id_viaje			NVARCHAR(100)
AS
BEGIN
	BEGIN TRY

		SET NOCOUNT ON

		DECLARE
				@MensajeError	VARCHAR(1000)

			SELECT 
				cvt.id_tarifa,
				cv.id_identificador,
				ctr.id_terminalXruta,
				cv.nombre,
				cto.nombre AS terminalOrigen,
				ctd.nombre AS terminalDestino,
				cto.id_terminal AS id_terminalOrigen,
				ctd.id_terminal AS id_terminalDestino,
				ISNULL(cvt.precioEspecial1, 0) AS precioEspecial1,
				ISNULL(cvt.precioInfantil1, 0) AS precioInfantil1,
				ISNULL(cvt.precioNormal1, 0) AS precioNormal1,
				ISNULL(cvt.precioTerceraEdad1, 0) AS precioTerceraEdad1,
				ISNULL(cvt.precioEspecial2, 0) AS precioEspecial2,
				ISNULL(cvt.precioInfantil2, 0) AS precioInfantil2,
				ISNULL(cvt.precioNormal2, 0) AS precioNormal2,
				ISNULL(cvt.precioTerceraEdad2, 0) AS precioTerceraEdad2,
				indice,
				id_tipoTerminal,
				ISNULL(cvt.id_viaje, '') AS id_viaje
			FROM 
				tbl_CatViajes AS cv
				JOIN tbl_CatRutas AS cr ON cv.id_ruta = cr.id_ruta
				JOIN tbl_CatTerminalesXRuta AS ctr ON ctr.id_ruta = cr.id_ruta
				JOIN tbl_CatTerminales AS cto ON ctr.id_terminalSalida = cto.id_terminal
				JOIN tbl_CatTerminales AS ctd ON ctr.id_terminalDestino = ctd.id_terminal
				LEFT JOIN tbl_CatViajeXTarifas AS cvt ON cv.id_identificador = cvt.id_viaje AND cvt.id_terminalXruta = ctr.id_terminalXruta
			WHERE 
				cv.activo = 1
				AND cr.activo = 1
				AND ctr.activo = 1
				AND cv.id_identificador = @id_viaje 

			UNION

			SELECT 
				cvt.id_tarifa,
				cv.id_identificador,
				ctr.id_terminalXruta,
				cv.nombre,				
				cto.nombre AS terminalOrigen,
				ctd.nombre AS terminalDestino,
				cto.id_terminal AS id_terminalOrigen,
				ctd.id_terminal AS id_terminalDestino,
				ISNULL(cvt.precioEspecial1, 0) AS precioEspecial1,
				ISNULL(cvt.precioInfantil1, 0) AS precioInfantil1,
				ISNULL(cvt.precioNormal1, 0) AS precioNormal1,
				ISNULL(cvt.precioTerceraEdad1, 0) AS precioTerceraEdad1,
				ISNULL(cvt.precioEspecial2, 0) AS precioEspecial2,
				ISNULL(cvt.precioInfantil2, 0) AS precioInfantil2,
				ISNULL(cvt.precioNormal2, 0) AS precioNormal2,
				ISNULL(cvt.precioTerceraEdad2, 0) AS precioTerceraEdad2,
				indice,
				id_tipoTerminal,
				ISNULL(cvt.id_viaje, '') AS id_viaje
			FROM 
				tbl_CatViajes AS cv
				JOIN tbl_CatTerminalesXRuta AS ctr ON cv.id_ruta = ctr.id_terminalXruta				
				JOIN tbl_CatTerminales AS cto ON ctr.id_terminalSalida = cto.id_terminal
				JOIN tbl_CatTerminales AS ctd ON ctr.id_terminalDestino = ctd.id_terminal
				LEFT JOIN tbl_CatViajeXTarifas AS cvt ON cv.id_identificador = cvt.id_viaje AND cvt.id_terminalXruta = ctr.id_terminalXruta
			WHERE 
				cv.activo = 1
				AND ctr.activo = 1				
				AND cv.id_identificador = @id_viaje
			ORDER BY 				
				indice, ctr.id_tipoTerminal
				

	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		SELECT @MensajeError	= ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END





















GO
/****** Object:  StoredProcedure [dbo].[Obtener_TipoCamion]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[Obtener_TipoCamion]
	@opcion		INT 
AS
BEGIN
	
	BEGIN TRY

	IF @opcion = 1
	BEGIN
		(SELECT 
			ctc.id_tipoCamion,
			ctc.tipoCamion
		FROM
			tbl_CatTipoCamion AS ctc
		WHERE
			ctc.activo = 1
		UNION
		SELECT 
			0 as id_tipoCamion,
			'-- Seleccione --' AS tipoCamion)
		ORDER BY id_tipoCamion

	END
	IF @opcion = 2
	BEGIN 
		SELECT 
			ctc.id_tipoCamion,
			ctc.tipoCamion,
			ctc.maximoDescuentoLinea
		FROM
			tbl_CatTipoCamion AS ctc
		WHERE
			ctc.activo = 1
		ORDER BY id_tipoCamion
	END
	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------
	END CATCH
END































GO
/****** Object:  StoredProcedure [dbo].[Obtener_Viajes_Activos]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER PROCEDURE [dbo].[Obtener_Viajes_Activos]
	
AS
BEGIN
	
	BEGIN TRY

		SELECT 
			cv.id_identificador,
			cv.id_ruta,
			cv.id_camion,
			cv.id_tipoViaje,
			cv.fec_PeriodoIni,
			cv.fec_PeriodoFin,
			FORMAT ( cv.fec_PeriodoIni, 'dd/MM/yyyy') + ' - ' + FORMAT ( cv.fec_PeriodoFin, 'dd/MM/yyyy') AS periodo,
			[dbo].[StatusViajes](cv.id_identificador) AS status_viaje,
			cv.Lunes,
			cv.Martes,
			cv.Miercoles,
			cv.Jueves,
			cv.Viernes,
			cv.Sabado,
			cv.Domingo,
			cv.nombre,
			cc.descripcion,
			cd.nombre as terminalDestino,
			co.nombre as terminalOrigen,
			cv.horario
		FROM
			tbl_CatViajes as cv
			JOIN tbl_CatCamiones as cc ON cv.id_camion = cc.id_camion
			JOIN tbl_CatRutas as cr ON cv.id_ruta = cr.id_ruta
			JOIN tbl_CatTerminalesXRuta as ctr ON cr.id_ruta = ctr.id_ruta
			JOIN tbl_CatTerminales as cd ON cd.id_terminal = ctr.id_terminalDestino
			JOIN tbl_CatTerminales as co ON co.id_terminal = ctr.id_terminalSalida

		WHERE
			cv.activo = 1
			AND ctr.id_tipoTerminal = 1	
		ORDER BY cv.nombre
				
	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------
	END CATCH
END























GO
/****** Object:  StoredProcedure [dbo].[Obtener_ViajesXFechas_Activos]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[Obtener_ViajesXFechas_Activos]
			@id_viaje        NVARCHAR(100), 
			@fecha_inicio    DATE,
			@fecha_fin		 DATE
AS
BEGIN
	
	BEGIN TRY

		SELECT 
			cv.id_identificador,
			cv.nombre,
			cvxf.fechaviaje,
			cv.horario,
			cvxf.activo
		FROM
			tbl_CatViajes AS cv JOIN tbl_CatViajesXFecha AS cvxf
			ON cv.id_identificador = cvxf.id_viaje
		WHERE
			cv.activo = 1
			AND cv.id_identificador = @id_viaje
			AND cvxf.fechaviaje BETWEEN @fecha_inicio AND @fecha_fin
		ORDER BY cvxf.fechaviaje
				
	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------
	END CATCH
END

























GO
/****** Object:  StoredProcedure [dbo].[obtenerAnticipo1xIDCaja]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[obtenerAnticipo1xIDCaja]
	@id_cajaXSucursal	NVARCHAR(100),
	@fecha			DATE

AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON

		SELECT 
			tb.CodigoBarra,
			tb.NombrePersona,
			tb.asiento,
			ctO.nombre AS terminalOrigen,
			ctD.nombre AS  terminalDestino,
			tb.costo,
			vd.pago1,
			0.0 as pago2,--vd.pago2,
			cuc.Cu_User AS vendedor
		FROM 
			tbl_Boletos AS tb
		    INNER JOIN tbl_VentaDetalle AS vd ON vd.id_boleto = tb.id_boleto
			INNER JOIN tbl_CatViajes AS cv ON tb.id_viaje = cv.id_identificador
			INNER JOIN tbl_OrdenRuta AS orO ON cv.id_ruta = orO.id_ruta
			INNER JOIN tbl_CatTerminales AS ctO ON ctO.id_terminal = orO.id_terminal AND orO.orden = tb.OrdenOrigenTerminal
			INNER JOIN tbl_OrdenRuta AS orD ON cv.id_ruta = orD.id_ruta
			INNER JOIN tbl_CatTerminales AS ctD ON ctD.id_terminal = orD.id_terminal AND orD.orden = tb.OrdenDestinoTerminal
			INNER JOIN tbl_VentaCajas AS tvc ON tvc.IDGenerico = vd.id_ventadetalle
			INNER JOIN tbl_CatUsuarioCuenta AS cuc ON tvc.usuins = cuc.Id_U	
		WHERE 
			tvc.IDCajaXSucursal = @id_cajaXSucursal AND tvc.IDStatus = 3 AND tvc.Activo = 1
		ORDER BY tb.fecins
			

			

	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END



















GO
/****** Object:  StoredProcedure [dbo].[obtenerAnticipo1xIDCaja_Estadisticos]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER PROCEDURE [dbo].[obtenerAnticipo1xIDCaja_Estadisticos]
	@id_cajaXSucursal	NVARCHAR(100),
	@fecha			DATE

AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON

		SELECT 
			tb.CodigoBarra,
			tb.NombrePersona,
			tb.asiento,
			ctO.nombre AS terminalOrigen,
			ctD.nombre AS  terminalDestino,
			tb.costo,
			vd.pago1,
			0.0 as pago2,--vd.pago2,
			cuc.Cu_User AS vendedor,
			tb.fecins
		FROM 
			[dbo].[vtbl_Boletos_Estadisticos] AS tb
		    INNER JOIN [dbo].[vtbl_VentaDetalle_Estadisticos] AS vd ON vd.id_boleto = tb.id_boleto
			INNER JOIN tbl_CatViajes AS cv ON tb.id_viaje = cv.id_identificador
			INNER JOIN tbl_OrdenRuta AS orO ON cv.id_ruta = orO.id_ruta
			INNER JOIN tbl_CatTerminales AS ctO ON ctO.id_terminal = orO.id_terminal AND orO.orden = tb.OrdenOrigenTerminal
			INNER JOIN tbl_OrdenRuta AS orD ON cv.id_ruta = orD.id_ruta
			INNER JOIN tbl_CatTerminales AS ctD ON ctD.id_terminal = orD.id_terminal AND orD.orden = tb.OrdenDestinoTerminal
			INNER JOIN [dbo].[vtbl_VentaCajas_Estadisticos] AS tvc ON tvc.IDGenerico = vd.id_ventadetalle
			INNER JOIN tbl_CatUsuarioCuenta AS cuc ON tvc.usuins = cuc.Id_U	
		WHERE 
			tvc.IDCajaXSucursal = @id_cajaXSucursal AND tvc.IDStatus = 3 AND tvc.Activo = 1
		ORDER BY tb.fecins

	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END




















GO
/****** Object:  StoredProcedure [dbo].[obtenerAnticipo1xIDCaja2]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[obtenerAnticipo1xIDCaja2]
	@id_cajaXSucursal	NVARCHAR(100),
	@fechaInicio			DATE,
	@fechaFin			    DATE

AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON
		
		SELECT 
			tb.CodigoBarra,
			tb.NombrePersona,
			tb.asiento,
			ctO.nombre AS terminalOrigen,
			ctD.nombre AS  terminalDestino,
			tb.costo,
			vd.pago1,
			0.0 as pago2,--vd.pago2,
			cuc.Cu_User AS vendedor
		FROM 
			tbl_Boletos AS tb
		    INNER JOIN tbl_VentaDetalle AS vd ON vd.id_boleto = tb.id_boleto
			INNER JOIN tbl_CatViajes AS cv ON tb.id_viaje = cv.id_identificador
			INNER JOIN tbl_OrdenRuta AS orO ON cv.id_ruta = orO.id_ruta
			INNER JOIN tbl_CatTerminales AS ctO ON ctO.id_terminal = orO.id_terminal AND orO.orden = tb.OrdenOrigenTerminal
			INNER JOIN tbl_OrdenRuta AS orD ON cv.id_ruta = orD.id_ruta
			INNER JOIN tbl_CatTerminales AS ctD ON ctD.id_terminal = orD.id_terminal AND orD.orden = tb.OrdenDestinoTerminal
			INNER JOIN tbl_VentaCajas AS tvc ON tvc.IDGenerico = vd.id_ventadetalle
			INNER JOIN tbl_CatUsuarioCuenta AS cuc ON tvc.usuins = cuc.Id_U
			INNER JOIN tbl_CajaXSucursal as cs ON tvc.IDCajaXSucursal = cs.id_cajaXSucursal				
		WHERE 
			cs.id_caja = @id_cajaxSucursal	 			
			AND CONVERT(DATE,cs.fecha_inicio) BETWEEN @fechaInicio AND @fechaFin
			AND tvc.IDStatus = 3 AND tvc.Activo = 1
		ORDER BY tb.fecins
			

			

	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END



















GO
/****** Object:  StoredProcedure [dbo].[obtenerAnticipo1xIDCaja2_Estadisticos]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER PROCEDURE [dbo].[obtenerAnticipo1xIDCaja2_Estadisticos]
	@id_cajaXSucursal	NVARCHAR(100),
	@fechaInicio			DATE,
	@fechaFin			    DATE

AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON
		
		SELECT 
			tb.CodigoBarra,
			tb.NombrePersona,
			tb.asiento,
			ctO.nombre AS terminalOrigen,
			ctD.nombre AS  terminalDestino,
			tb.costo,
			vd.pago1,
			0.0 as pago2,--vd.pago2,
			cuc.Cu_User AS vendedor,
			tb.fecins
		FROM 
			[dbo].[vtbl_Boletos_Estadisticos] AS tb
		    INNER JOIN [dbo].[vtbl_VentaDetalle_Estadisticos] AS vd ON vd.id_boleto = tb.id_boleto
			INNER JOIN tbl_CatViajes AS cv ON tb.id_viaje = cv.id_identificador
			INNER JOIN tbl_OrdenRuta AS orO ON cv.id_ruta = orO.id_ruta
			INNER JOIN tbl_CatTerminales AS ctO ON ctO.id_terminal = orO.id_terminal AND orO.orden = tb.OrdenOrigenTerminal
			INNER JOIN tbl_OrdenRuta AS orD ON cv.id_ruta = orD.id_ruta
			INNER JOIN tbl_CatTerminales AS ctD ON ctD.id_terminal = orD.id_terminal AND orD.orden = tb.OrdenDestinoTerminal
			INNER JOIN [dbo].[vtbl_VentaCajas_Estadisticos] AS tvc ON tvc.IDGenerico = vd.id_ventadetalle
			INNER JOIN tbl_CatUsuarioCuenta AS cuc ON tvc.usuins = cuc.Id_U
			INNER JOIN [dbo].[vtbl_CajaXSucursal_Estadisticos] as cs ON tvc.IDCajaXSucursal = cs.id_cajaXSucursal		
		WHERE 
			cs.id_caja = @id_cajaxSucursal	 			
			AND CONVERT(DATE,cs.fecha_inicio) BETWEEN @fechaInicio AND @fechaFin
			AND tvc.IDStatus = 3 AND tvc.Activo = 1
		ORDER BY tb.fecins
			

		
	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END




















GO
/****** Object:  StoredProcedure [dbo].[obtenerAnticipo2xIDCaja]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[obtenerAnticipo2xIDCaja]
	@id_cajaXSucursal	NVARCHAR(100),
	@fecha			DATE

AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON

		SELECT 
			tb.CodigoBarra,
			tb.NombrePersona,
			tb.asiento,
			ctO.nombre AS terminalOrigen,
			ctD.nombre AS  terminalDestino,
			tb.costo,
			0.0 as pago1, --vd.pago1,
			vd.pago2,
			cuc.Cu_User AS vendedor
		FROM 
			tbl_Boletos AS tb
		    INNER JOIN tbl_VentaDetalle AS vd ON vd.id_boleto = tb.id_boleto
			INNER JOIN tbl_CatViajes AS cv ON tb.id_viaje = cv.id_identificador
			INNER JOIN tbl_OrdenRuta AS orO ON cv.id_ruta = orO.id_ruta
			INNER JOIN tbl_CatTerminales AS ctO ON ctO.id_terminal = orO.id_terminal AND orO.orden = tb.OrdenOrigenTerminal
			INNER JOIN tbl_OrdenRuta AS orD ON cv.id_ruta = orD.id_ruta
			INNER JOIN tbl_CatTerminales AS ctD ON ctD.id_terminal = orD.id_terminal AND orD.orden = tb.OrdenDestinoTerminal
			INNER JOIN tbl_VentaCajas AS tvc ON tvc.IDGenerico = vd.id_ventadetalle
			INNER JOIN tbl_CatUsuarioCuenta AS cuc ON tvc.usuins = cuc.Id_U	
		WHERE 
			tvc.IDCajaXSucursal = @id_cajaXSucursal AND tvc.IDStatus = 4 AND tvc.Activo = 1
		ORDER BY tb.fecins	

			

	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END



















GO
/****** Object:  StoredProcedure [dbo].[obtenerAnticipo2xIDCaja_Estadisticos]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER PROCEDURE [dbo].[obtenerAnticipo2xIDCaja_Estadisticos]
	@id_cajaXSucursal	NVARCHAR(100),
	@fecha			DATE

AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON

		SELECT 
			tb.CodigoBarra,
			tb.NombrePersona,
			tb.asiento,
			ctO.nombre AS terminalOrigen,
			ctD.nombre AS  terminalDestino,
			tb.costo,
			0.0 as pago1, --vd.pago1,
			vd.pago2,
			cuc.Cu_User AS vendedor,
			tb.fecins	
		FROM 
			[dbo].[vtbl_Boletos_Estadisticos] AS tb
		    INNER JOIN [dbo].[vtbl_VentaDetalle_Estadisticos] AS vd ON vd.id_boleto = tb.id_boleto
			INNER JOIN tbl_CatViajes AS cv ON tb.id_viaje = cv.id_identificador
			INNER JOIN tbl_OrdenRuta AS orO ON cv.id_ruta = orO.id_ruta
			INNER JOIN tbl_CatTerminales AS ctO ON ctO.id_terminal = orO.id_terminal AND orO.orden = tb.OrdenOrigenTerminal
			INNER JOIN tbl_OrdenRuta AS orD ON cv.id_ruta = orD.id_ruta
			INNER JOIN tbl_CatTerminales AS ctD ON ctD.id_terminal = orD.id_terminal AND orD.orden = tb.OrdenDestinoTerminal
			INNER JOIN [dbo].[vtbl_VentaCajas_Estadisticos] AS tvc ON tvc.IDGenerico = vd.id_ventadetalle
			INNER JOIN tbl_CatUsuarioCuenta AS cuc ON tvc.usuins = cuc.Id_U	
		WHERE 
			tvc.IDCajaXSucursal = @id_cajaXSucursal AND tvc.IDStatus = 4 AND tvc.Activo = 1
		ORDER BY tb.fecins	
			

	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END




















GO
/****** Object:  StoredProcedure [dbo].[obtenerAnticipo2xIDCaja2]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[obtenerAnticipo2xIDCaja2]
	@id_cajaXSucursal	NVARCHAR(100),
	@fechaInicio			DATE,
	@fechaFin			    DATE

AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON

		SELECT 
			tb.CodigoBarra,
			tb.NombrePersona,
			tb.asiento,
			ctO.nombre AS terminalOrigen,
			ctD.nombre AS  terminalDestino,
			tb.costo,
			0.0 as pago1, --vd.pago1,
			vd.pago2,
			cuc.Cu_User AS vendedor
		FROM 
			tbl_Boletos AS tb
		    INNER JOIN tbl_VentaDetalle AS vd ON vd.id_boleto = tb.id_boleto
			INNER JOIN tbl_CatViajes AS cv ON tb.id_viaje = cv.id_identificador
			INNER JOIN tbl_OrdenRuta AS orO ON cv.id_ruta = orO.id_ruta
			INNER JOIN tbl_CatTerminales AS ctO ON ctO.id_terminal = orO.id_terminal AND orO.orden = tb.OrdenOrigenTerminal
			INNER JOIN tbl_OrdenRuta AS orD ON cv.id_ruta = orD.id_ruta
			INNER JOIN tbl_CatTerminales AS ctD ON ctD.id_terminal = orD.id_terminal AND orD.orden = tb.OrdenDestinoTerminal
			INNER JOIN tbl_VentaCajas AS tvc ON tvc.IDGenerico = vd.id_ventadetalle
			INNER JOIN tbl_CatUsuarioCuenta AS cuc ON tvc.usuins = cuc.Id_U
			INNER JOIN tbl_CajaXSucursal as cs ON tvc.IDCajaXSucursal = cs.id_cajaXSucursal	
		WHERE 
		 cs.id_caja = @id_cajaxSucursal	 			
		 AND CONVERT(DATE,cs.fecha_inicio) BETWEEN @fechaInicio AND @fechaFin
		 AND tvc.IDStatus = 4 AND tvc.Activo = 1
		ORDER BY tb.fecins	

			
	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END



















GO
/****** Object:  StoredProcedure [dbo].[obtenerAnticipo2xIDCaja2_Estadisticos]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER PROCEDURE [dbo].[obtenerAnticipo2xIDCaja2_Estadisticos]
	@id_cajaXSucursal	NVARCHAR(100),
	@fechaInicio			DATE,
	@fechaFin			    DATE

AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON

		SELECT 
			tb.CodigoBarra,
			tb.NombrePersona,
			tb.asiento,
			ctO.nombre AS terminalOrigen,
			ctD.nombre AS  terminalDestino,
			tb.costo,
			0.0 as pago1, --vd.pago1,
			vd.pago2,
			cuc.Cu_User AS vendedor,
			tb.fecins
		FROM 
			[dbo].[vtbl_Boletos_Estadisticos] AS tb
		    INNER JOIN [dbo].[vtbl_VentaDetalle_Estadisticos] AS vd ON vd.id_boleto = tb.id_boleto
			INNER JOIN tbl_CatViajes AS cv ON tb.id_viaje = cv.id_identificador
			INNER JOIN tbl_OrdenRuta AS orO ON cv.id_ruta = orO.id_ruta
			INNER JOIN tbl_CatTerminales AS ctO ON ctO.id_terminal = orO.id_terminal AND orO.orden = tb.OrdenOrigenTerminal
			INNER JOIN tbl_OrdenRuta AS orD ON cv.id_ruta = orD.id_ruta
			INNER JOIN tbl_CatTerminales AS ctD ON ctD.id_terminal = orD.id_terminal AND orD.orden = tb.OrdenDestinoTerminal
			INNER JOIN [dbo].[vtbl_VentaCajas_Estadisticos] AS tvc ON tvc.IDGenerico = vd.id_ventadetalle
			INNER JOIN tbl_CatUsuarioCuenta AS cuc ON tvc.usuins = cuc.Id_U
			INNER JOIN [dbo].[vtbl_CajaXSucursal_Estadisticos] as cs ON tvc.IDCajaXSucursal = cs.id_cajaXSucursal	
		WHERE 
		 cs.id_caja = @id_cajaxSucursal	 			
		 AND CONVERT(DATE,cs.fecha_inicio) BETWEEN @fechaInicio AND @fechaFin
		 AND tvc.IDStatus = 4 AND tvc.Activo = 1
		ORDER BY tb.fecins	

			
	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END




















GO
/****** Object:  StoredProcedure [dbo].[obtenerBoletosViaje]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





ALTER PROCEDURE [dbo].[obtenerBoletosViaje]
	@IDVIAJE	NVARCHAR(100),
	@FECHA      DATE,
	@HORA       NVARCHAR(8),
	@IDSUCURSAL NVARCHAR(100)

AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON

        SELECT 
			ISNULL(CodigoBarra,'')  AS folio,
			ISNULL(NombrePersona,'') AS cliente_nombre,
			ISNULL(indice,0) AS asiento,
			ISNULL(tOrigen.terminalOrigen,'') AS origen,
			ISNULL(tDestino.terminalDestino,'') AS destino,
			ISNULL(tbl_Boletos.costo,0.0) AS precio,
		    ISNULL(tbl_CatTipoPromocion.descripcion,'') AS tipoVenta,
			ISNULL(tbl_Boletos.fechaNacimiento,GETDATE()) AS fechaNacimiento
		FROM tbl_CatDisenioDatos JOIN tbl_CatCamiones
		ON tbl_CatCamiones.id_disenioCamion = tbl_CatDisenioDatos.id_disenioCamion  AND tbl_CatDisenioDatos.id_tipoObjeto = 1 AND tbl_CatDisenioDatos.activo = 1
		JOIN tbl_CatViajes
		ON tbl_CatViajes.id_camion = tbl_CatCamiones.id_camion
		JOIN tbl_CatViajesXFecha
		ON tbl_CatViajes.id_identificador = tbl_CatViajesXFecha.id_viaje
        LEFT JOIN tbl_Boletos 
	    ON tbl_Boletos.id_viaje = tbl_CatViajes.id_identificador AND tbl_Boletos.fecha_salida = tbl_CatViajesXFecha.fechaviaje AND tbl_Boletos.hora_salida = tbl_CatViajes.horario AND tbl_Boletos.asiento = tbl_CatDisenioDatos.indice AND tbl_Boletos.activo = 1 AND tbl_Boletos.id_status = 3 
		LEFT JOIN tbl_VentaDetalle
		ON tbl_Boletos.id_boleto = tbl_VentaDetalle.id_boleto	
		LEFT JOIN tbl_VentaDetalleDescuento 
		ON 	tbl_VentaDetalle.id_ventadetalle = tbl_VentaDetalleDescuento.id_ventadetalle
		LEFT JOIN vtbl_FechasViaje AS tOrigen
		ON tbl_Boletos.id_viaje = tOrigen.id_viaje AND tbl_Boletos.fecha_salida = tOrigen.fechaOrigen AND tbl_Boletos.hora_salida = tOrigen.horaOrigen AND tbl_Boletos.OrdenOrigenTerminal =  tOrigen.ordenOrigen AND tbl_Boletos.OrdenDestinoTerminal = tOrigen.ordenDestino
        LEFT JOIN vtbl_FechasViaje AS tDestino
		ON tbl_Boletos.id_viaje = tDestino.id_viaje AND tbl_Boletos.fecha_salida = tDestino.fechaOrigen AND tbl_Boletos.hora_salida = tDestino.horaOrigen AND tbl_Boletos.OrdenOrigenTerminal =  tDestino.ordenOrigen AND tbl_Boletos.OrdenDestinoTerminal = tDestino.ordenDestino
		LEFT JOIN tbl_CatTipoPromocion
		ON tbl_CatTipoPromocion.id_tipoPromocion = tbl_VentaDetalleDescuento.id_tipoPromocion
		WHERE tbl_CatViajes.id_identificador = @IDVIAJE AND tbl_CatViajesXFecha.fechaviaje = @FECHA AND tbl_CatViajes.horario = @HORA 
		ORDER BY indice, tbl_Boletos.fecins

	END TRY
	BEGIN CATCH 
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END






















GO
/****** Object:  StoredProcedure [dbo].[ObtenerBoletosViaje_Asistencia]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





ALTER PROCEDURE [dbo].[ObtenerBoletosViaje_Asistencia]
	@IDVIAJE	NVARCHAR(100),
	@FECHA      DATE,
	@HORA       NVARCHAR(8)

AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON

		DECLARE @origen		NVARCHAR(300)
		DECLARE @destino	NVARCHAR(300)

		SELECT 
				@origen = terminalOrigen.nombre,
				@destino = terminalDestino.nombre
		FROM [dbo].[tbl_CatViajes] JOIN [dbo].[tbl_CatRutas]
		ON [dbo].[tbl_CatViajes].[id_ruta] = [dbo].[tbl_CatRutas].[id_ruta] AND [dbo].[tbl_CatRutas].[activo] = 1
		JOIN [dbo].[tbl_CatTerminalesXRuta]
		ON [dbo].[tbl_CatTerminalesXRuta].[id_ruta] = [dbo].[tbl_CatRutas].[id_ruta] AND [dbo].[tbl_CatTerminalesXRuta].[id_tipoTerminal] = 1 AND [dbo].[tbl_CatTerminalesXRuta].[indice] = 0 AND [dbo].[tbl_CatTerminalesXRuta].[activo] = 1
        JOIN [dbo].[tbl_CatTerminales] AS terminalOrigen
		ON terminalOrigen.[id_terminal] = [dbo].[tbl_CatTerminalesXRuta].[id_terminalSalida]
		JOIN [dbo].[tbl_CatTerminales] AS terminalDestino
		ON terminalDestino.[id_terminal] = [dbo].[tbl_CatTerminalesXRuta].[id_terminalDestino]
		WHERE [dbo].[tbl_CatViajes].[id_identificador] = @IDVIAJE



        SELECT 
			ISNULL(tbl_Boletos.id_boleto,'') AS id_boleto,
			ISNULL(CodigoBarra,'')  AS folio,
			ISNULL(@origen,'') AS origen,
			ISNULL(@destino,'') AS destino,
			ISNULL(NombrePersona,'') AS cliente_nombre,
			ISNULL(indice,0) AS asiento,
			ISNULL(numeroTelefono,'') AS numeroTelefono,
			ISNULL(asistencia,0) AS asistencia
		FROM tbl_CatDisenioDatos JOIN tbl_CatCamiones
		ON tbl_CatCamiones.id_disenioCamion = tbl_CatDisenioDatos.id_disenioCamion  AND tbl_CatDisenioDatos.id_tipoObjeto = 1 AND tbl_CatDisenioDatos.activo = 1
		JOIN tbl_CatViajes
		ON tbl_CatViajes.id_camion = tbl_CatCamiones.id_camion
		JOIN tbl_CatViajesXFecha
		ON tbl_CatViajes.id_identificador = tbl_CatViajesXFecha.id_viaje
        LEFT JOIN tbl_Boletos 
	    ON tbl_Boletos.id_viaje = tbl_CatViajes.id_identificador AND tbl_Boletos.fecha_salida = tbl_CatViajesXFecha.fechaviaje AND tbl_Boletos.hora_salida = tbl_CatViajes.horario AND tbl_Boletos.asiento = tbl_CatDisenioDatos.indice AND tbl_Boletos.activo = 1 AND tbl_Boletos.id_status = 3 
		LEFT JOIN tbl_VentaDetalle
		ON tbl_Boletos.id_boleto = tbl_VentaDetalle.id_boleto	
		LEFT JOIN tbl_VentaDetalleDescuento 
		ON 	tbl_VentaDetalle.id_ventadetalle = tbl_VentaDetalleDescuento.id_ventadetalle
		LEFT JOIN vtbl_FechasViaje AS tOrigen
		ON tbl_Boletos.id_viaje = tOrigen.id_viaje AND tbl_Boletos.fecha_salida = tOrigen.fechaOrigen AND tbl_Boletos.hora_salida = tOrigen.horaOrigen AND tbl_Boletos.OrdenOrigenTerminal =  tOrigen.ordenOrigen AND tbl_Boletos.OrdenDestinoTerminal = tOrigen.ordenDestino
        LEFT JOIN vtbl_FechasViaje AS tDestino
		ON tbl_Boletos.id_viaje = tDestino.id_viaje AND tbl_Boletos.fecha_salida = tDestino.fechaOrigen AND tbl_Boletos.hora_salida = tDestino.horaOrigen AND tbl_Boletos.OrdenOrigenTerminal =  tDestino.ordenOrigen AND tbl_Boletos.OrdenDestinoTerminal = tDestino.ordenDestino
		LEFT JOIN tbl_CatTipoPromocion
		ON tbl_CatTipoPromocion.id_tipoPromocion = tbl_VentaDetalleDescuento.id_tipoPromocion
		WHERE tbl_CatViajes.id_identificador = @IDVIAJE AND tbl_CatViajesXFecha.fechaviaje = @FECHA AND tbl_CatViajes.horario = @HORA 
		ORDER BY indice, tbl_Boletos.fecins

	END TRY
	BEGIN CATCH 
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END






















GO
/****** Object:  StoredProcedure [dbo].[obtenerBoletosViaje_Estadisticos]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







ALTER PROCEDURE [dbo].[obtenerBoletosViaje_Estadisticos]
	@IDVIAJE	NVARCHAR(100),
	@FECHA      DATE,
	@HORA       NVARCHAR(8),
	@IDSUCURSAL NVARCHAR(100)

AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON

        SELECT 
			ISNULL(Boletos.CodigoBarra,ISNULL(BoletosEstadisticos.CodigoBarra,''))  AS folio,
			ISNULL(Boletos.NombrePersona,ISNULL(BoletosEstadisticos.NombrePersona,'')) AS cliente_nombre,
			ISNULL(indice,0) AS asiento,
			ISNULL(tOrigen.terminalOrigen,'') AS origen,
			ISNULL(tDestino.terminalDestino,'') AS destino,
			ISNULL(Boletos.costo,ISNULL(BoletosEstadisticos.costo,0.0)) AS precio,
		    ISNULL(tbl_CatTipoPromocion.descripcion,'') AS tipoVenta,
			ISNULL(Boletos.fecins,ISNULL(BoletosEstadisticos.fecins,GETDATE())) AS fecins,
			ISNULL(Boletos.fechaNacimiento,ISNULL(BoletosEstadisticos.fechaNacimiento,GETDATE())) AS fechaNacimiento
		FROM tbl_CatDisenioDatos JOIN tbl_CatCamiones
		ON tbl_CatCamiones.id_disenioCamion = tbl_CatDisenioDatos.id_disenioCamion  AND tbl_CatDisenioDatos.id_tipoObjeto = 1 AND tbl_CatDisenioDatos.activo = 1
		JOIN tbl_CatViajes
		ON tbl_CatViajes.id_camion = tbl_CatCamiones.id_camion
		JOIN tbl_CatViajesXFecha
		ON tbl_CatViajes.id_identificador = tbl_CatViajesXFecha.id_viaje
        LEFT JOIN tbl_Boletos AS Boletos
	    ON Boletos.id_viaje = tbl_CatViajes.id_identificador AND Boletos.fecha_salida = tbl_CatViajesXFecha.fechaviaje AND Boletos.hora_salida = tbl_CatViajes.horario AND Boletos.asiento = tbl_CatDisenioDatos.indice AND Boletos.activo = 1 AND Boletos.id_status = 3 
		LEFT JOIN tbl_Boletos AS BoletosEstadisticos
	    ON BoletosEstadisticos.id_viaje = tbl_CatViajes.id_identificador AND BoletosEstadisticos.fecha_salida = tbl_CatViajesXFecha.fechaviaje AND BoletosEstadisticos.hora_salida = tbl_CatViajes.horario AND BoletosEstadisticos.asiento = tbl_CatDisenioDatos.indice AND BoletosEstadisticos.activo = 1 AND BoletosEstadisticos.id_status = 3 
		LEFT JOIN tbl_VentaDetalle
		ON Boletos.id_boleto = tbl_VentaDetalle.id_boleto AND BoletosEstadisticos.id_boleto = tbl_VentaDetalle.id_boleto	
		LEFT JOIN tbl_VentaDetalleDescuento 
		ON 	tbl_VentaDetalle.id_ventadetalle = tbl_VentaDetalleDescuento.id_ventadetalle
		LEFT JOIN vtbl_FechasViaje AS tOrigen
		ON Boletos.id_viaje = tOrigen.id_viaje AND Boletos.fecha_salida = tOrigen.fechaOrigen AND Boletos.hora_salida = tOrigen.horaOrigen AND Boletos.OrdenOrigenTerminal =  tOrigen.ordenOrigen AND Boletos.OrdenDestinoTerminal = tOrigen.ordenDestino AND BoletosEstadisticos.id_viaje = tOrigen.id_viaje AND BoletosEstadisticos.fecha_salida = tOrigen.fechaOrigen AND BoletosEstadisticos.hora_salida = tOrigen.horaOrigen AND BoletosEstadisticos.OrdenOrigenTerminal =  tOrigen.ordenOrigen AND BoletosEstadisticos.OrdenDestinoTerminal = tOrigen.ordenDestino
        LEFT JOIN vtbl_FechasViaje AS tDestino
		ON Boletos.id_viaje = tDestino.id_viaje AND Boletos.fecha_salida = tDestino.fechaOrigen AND Boletos.hora_salida = tDestino.horaOrigen AND Boletos.OrdenOrigenTerminal =  tDestino.ordenOrigen AND Boletos.OrdenDestinoTerminal = tDestino.ordenDestino AND BoletosEstadisticos.id_viaje = tDestino.id_viaje AND BoletosEstadisticos.fecha_salida = tDestino.fechaOrigen AND BoletosEstadisticos.hora_salida = tDestino.horaOrigen AND BoletosEstadisticos.OrdenOrigenTerminal =  tDestino.ordenOrigen AND BoletosEstadisticos.OrdenDestinoTerminal = tDestino.ordenDestino
		LEFT JOIN tbl_CatTipoPromocion
		ON tbl_CatTipoPromocion.id_tipoPromocion = tbl_VentaDetalleDescuento.id_tipoPromocion
		WHERE tbl_CatViajes.id_identificador = @IDVIAJE AND tbl_CatViajesXFecha.fechaviaje = @FECHA AND tbl_CatViajes.horario = @HORA 	
		ORDER BY asiento, fecins

	END TRY
	BEGIN CATCH 
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END
























GO
/****** Object:  StoredProcedure [dbo].[obtenerBoletosViaje_Estadisticos2]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







ALTER PROCEDURE [dbo].[obtenerBoletosViaje_Estadisticos2]
	@IDVIAJE	NVARCHAR(100),
	@FECHA      DATE,
	@HORA       NVARCHAR(8),
	@IDSUCURSAL NVARCHAR(100)

AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON
		
		DECLARE @origen		NVARCHAR(300)
		DECLARE @destino	NVARCHAR(300)
		
		SELECT 
				@origen = terminalOrigen.nombre,
				@destino = terminalDestino.nombre
		FROM [dbo].[tbl_CatViajes] JOIN [dbo].[tbl_CatRutas]
		ON [dbo].[tbl_CatViajes].[id_ruta] = [dbo].[tbl_CatRutas].[id_ruta] AND [dbo].[tbl_CatRutas].[activo] = 1
		JOIN [dbo].[tbl_CatTerminalesXRuta]
		ON [dbo].[tbl_CatTerminalesXRuta].[id_ruta] = [dbo].[tbl_CatRutas].[id_ruta] AND [dbo].[tbl_CatTerminalesXRuta].[id_tipoTerminal] = 1 AND [dbo].[tbl_CatTerminalesXRuta].[indice] = 0 AND [dbo].[tbl_CatTerminalesXRuta].[activo] = 1
        JOIN [dbo].[tbl_CatTerminales] AS terminalOrigen
		ON terminalOrigen.[id_terminal] = [dbo].[tbl_CatTerminalesXRuta].[id_terminalSalida]
		JOIN [dbo].[tbl_CatTerminales] AS terminalDestino
		ON terminalDestino.[id_terminal] = [dbo].[tbl_CatTerminalesXRuta].[id_terminalDestino]
		WHERE [dbo].[tbl_CatViajes].[id_identificador] = @IDVIAJE




        SELECT 
			ISNULL(Boletos.CodigoBarra,ISNULL(BoletosEstadisticos.CodigoBarra,''))  AS folio,
			ISNULL(Boletos.NombrePersona,ISNULL(BoletosEstadisticos.NombrePersona,'')) AS cliente_nombre,
			ISNULL(indice,0) AS asiento,
			ISNULL(@origen,'') AS origen,
			ISNULL(@destino,'') AS destino,
			ISNULL(Boletos.costo,ISNULL(BoletosEstadisticos.costo,0.0)) AS precio,
		    ISNULL(tbl_CatTipoPromocion.descripcion,'') AS tipoVenta,
			ISNULL(Boletos.fecins,ISNULL(BoletosEstadisticos.fecins,GETDATE())) AS fecins,
			ISNULL(Boletos.fechaNacimiento,ISNULL(BoletosEstadisticos.fechaNacimiento,GETDATE())) AS fechaNacimiento
		FROM tbl_CatDisenioDatos JOIN tbl_CatCamiones
		ON tbl_CatCamiones.id_disenioCamion = tbl_CatDisenioDatos.id_disenioCamion  AND tbl_CatDisenioDatos.id_tipoObjeto = 1 AND tbl_CatDisenioDatos.activo = 1
		JOIN tbl_CatViajes
		ON tbl_CatViajes.id_camion = tbl_CatCamiones.id_camion
		JOIN tbl_CatViajesXFecha
		ON tbl_CatViajes.id_identificador = tbl_CatViajesXFecha.id_viaje
        LEFT JOIN tbl_Boletos AS Boletos
	    ON Boletos.id_viaje = tbl_CatViajes.id_identificador AND Boletos.fecha_salida = tbl_CatViajesXFecha.fechaviaje AND Boletos.hora_salida = tbl_CatViajes.horario AND Boletos.asiento = tbl_CatDisenioDatos.indice AND Boletos.activo = 1 AND Boletos.id_status = 3 
		LEFT JOIN tbl_Boletos AS BoletosEstadisticos
	    ON BoletosEstadisticos.id_viaje = tbl_CatViajes.id_identificador AND BoletosEstadisticos.fecha_salida = tbl_CatViajesXFecha.fechaviaje AND BoletosEstadisticos.hora_salida = tbl_CatViajes.horario AND BoletosEstadisticos.asiento = tbl_CatDisenioDatos.indice AND BoletosEstadisticos.activo = 1 AND BoletosEstadisticos.id_status = 3 
		LEFT JOIN tbl_VentaDetalle
		ON Boletos.id_boleto = tbl_VentaDetalle.id_boleto AND BoletosEstadisticos.id_boleto = tbl_VentaDetalle.id_boleto	
		LEFT JOIN tbl_VentaDetalleDescuento 
		ON 	tbl_VentaDetalle.id_ventadetalle = tbl_VentaDetalleDescuento.id_ventadetalle
		LEFT JOIN vtbl_FechasViaje AS tOrigen
		ON Boletos.id_viaje = tOrigen.id_viaje AND Boletos.fecha_salida = tOrigen.fechaOrigen AND Boletos.hora_salida = tOrigen.horaOrigen AND Boletos.OrdenOrigenTerminal =  tOrigen.ordenOrigen AND Boletos.OrdenDestinoTerminal = tOrigen.ordenDestino AND BoletosEstadisticos.id_viaje = tOrigen.id_viaje AND BoletosEstadisticos.fecha_salida = tOrigen.fechaOrigen AND BoletosEstadisticos.hora_salida = tOrigen.horaOrigen AND BoletosEstadisticos.OrdenOrigenTerminal =  tOrigen.ordenOrigen AND BoletosEstadisticos.OrdenDestinoTerminal = tOrigen.ordenDestino
        LEFT JOIN vtbl_FechasViaje AS tDestino
		ON Boletos.id_viaje = tDestino.id_viaje AND Boletos.fecha_salida = tDestino.fechaOrigen AND Boletos.hora_salida = tDestino.horaOrigen AND Boletos.OrdenOrigenTerminal =  tDestino.ordenOrigen AND Boletos.OrdenDestinoTerminal = tDestino.ordenDestino AND BoletosEstadisticos.id_viaje = tDestino.id_viaje AND BoletosEstadisticos.fecha_salida = tDestino.fechaOrigen AND BoletosEstadisticos.hora_salida = tDestino.horaOrigen AND BoletosEstadisticos.OrdenOrigenTerminal =  tDestino.ordenOrigen AND BoletosEstadisticos.OrdenDestinoTerminal = tDestino.ordenDestino
		LEFT JOIN tbl_CatTipoPromocion
		ON tbl_CatTipoPromocion.id_tipoPromocion = tbl_VentaDetalleDescuento.id_tipoPromocion
		WHERE tbl_CatViajes.id_identificador = @IDVIAJE AND tbl_CatViajesXFecha.fechaviaje = @FECHA AND tbl_CatViajes.horario = @HORA 	
		ORDER BY asiento, fecins

	END TRY
	BEGIN CATCH 
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END
























GO
/****** Object:  StoredProcedure [dbo].[obtenerBoletosViaje2]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





ALTER PROCEDURE [dbo].[obtenerBoletosViaje2]
	@IDVIAJE	NVARCHAR(100),
	@FECHA      DATE,
	@HORA       NVARCHAR(8),
	@IDSUCURSAL NVARCHAR(100)

AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON

		DECLARE @origen		NVARCHAR(300)
		DECLARE @destino	NVARCHAR(300)

		SELECT 
				@origen = terminalOrigen.nombre,
				@destino = terminalDestino.nombre
		FROM [dbo].[tbl_CatViajes] JOIN [dbo].[tbl_CatRutas]
		ON [dbo].[tbl_CatViajes].[id_ruta] = [dbo].[tbl_CatRutas].[id_ruta] AND [dbo].[tbl_CatRutas].[activo] = 1
		JOIN [dbo].[tbl_CatTerminalesXRuta]
		ON [dbo].[tbl_CatTerminalesXRuta].[id_ruta] = [dbo].[tbl_CatRutas].[id_ruta] AND [dbo].[tbl_CatTerminalesXRuta].[id_tipoTerminal] = 1 AND [dbo].[tbl_CatTerminalesXRuta].[indice] = 0 AND [dbo].[tbl_CatTerminalesXRuta].[activo] = 1
        JOIN [dbo].[tbl_CatTerminales] AS terminalOrigen
		ON terminalOrigen.[id_terminal] = [dbo].[tbl_CatTerminalesXRuta].[id_terminalSalida]
		JOIN [dbo].[tbl_CatTerminales] AS terminalDestino
		ON terminalDestino.[id_terminal] = [dbo].[tbl_CatTerminalesXRuta].[id_terminalDestino]
		WHERE [dbo].[tbl_CatViajes].[id_identificador] = @IDVIAJE



        SELECT 
			ISNULL(CodigoBarra,'')  AS folio,
			ISNULL(NombrePersona,'') AS cliente_nombre,
			ISNULL(indice,0) AS asiento,
			ISNULL(@origen,'') AS origen,
			ISNULL(@destino,'') AS destino,
			ISNULL(tbl_Boletos.costo,0.0) AS precio,
		    ISNULL(tbl_CatTipoPromocion.descripcion,'') AS tipoVenta,
			ISNULL(tbl_Boletos.fechaNacimiento,GETDATE()) AS fechaNacimiento
		FROM tbl_CatDisenioDatos JOIN tbl_CatCamiones
		ON tbl_CatCamiones.id_disenioCamion = tbl_CatDisenioDatos.id_disenioCamion  AND tbl_CatDisenioDatos.id_tipoObjeto = 1 AND tbl_CatDisenioDatos.activo = 1
		JOIN tbl_CatViajes
		ON tbl_CatViajes.id_camion = tbl_CatCamiones.id_camion
		JOIN tbl_CatViajesXFecha
		ON tbl_CatViajes.id_identificador = tbl_CatViajesXFecha.id_viaje
        LEFT JOIN tbl_Boletos 
	    ON tbl_Boletos.id_viaje = tbl_CatViajes.id_identificador AND tbl_Boletos.fecha_salida = tbl_CatViajesXFecha.fechaviaje AND tbl_Boletos.hora_salida = tbl_CatViajes.horario AND tbl_Boletos.asiento = tbl_CatDisenioDatos.indice AND tbl_Boletos.activo = 1 AND tbl_Boletos.id_status = 3 
		LEFT JOIN tbl_VentaDetalle
		ON tbl_Boletos.id_boleto = tbl_VentaDetalle.id_boleto	
		LEFT JOIN tbl_VentaDetalleDescuento 
		ON 	tbl_VentaDetalle.id_ventadetalle = tbl_VentaDetalleDescuento.id_ventadetalle
		LEFT JOIN vtbl_FechasViaje AS tOrigen
		ON tbl_Boletos.id_viaje = tOrigen.id_viaje AND tbl_Boletos.fecha_salida = tOrigen.fechaOrigen AND tbl_Boletos.hora_salida = tOrigen.horaOrigen AND tbl_Boletos.OrdenOrigenTerminal =  tOrigen.ordenOrigen AND tbl_Boletos.OrdenDestinoTerminal = tOrigen.ordenDestino
        LEFT JOIN vtbl_FechasViaje AS tDestino
		ON tbl_Boletos.id_viaje = tDestino.id_viaje AND tbl_Boletos.fecha_salida = tDestino.fechaOrigen AND tbl_Boletos.hora_salida = tDestino.horaOrigen AND tbl_Boletos.OrdenOrigenTerminal =  tDestino.ordenOrigen AND tbl_Boletos.OrdenDestinoTerminal = tDestino.ordenDestino
		LEFT JOIN tbl_CatTipoPromocion
		ON tbl_CatTipoPromocion.id_tipoPromocion = tbl_VentaDetalleDescuento.id_tipoPromocion
		WHERE tbl_CatViajes.id_identificador = @IDVIAJE AND tbl_CatViajesXFecha.fechaviaje = @FECHA AND tbl_CatViajes.horario = @HORA 
		ORDER BY indice, tbl_Boletos.fecins

	END TRY
	BEGIN CATCH 
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END






















GO
/****** Object:  StoredProcedure [dbo].[obtenerCajasxFecha]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[obtenerCajasxFecha]
	@fecha			DATE

AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON

		SELECT 
			'' AS id_caja
			,'' AS descripcion
			,'' AS id_cajaXSucursal
			,'-- Seleccione --' AS U_Nombre
			,'' AS U_Apellidop
			,'' AS hora_inicio

		UNION 

		SELECT 
			tbc.id_caja,			
			tbc.descripcion,
			tbcs.id_cajaXSucursal,
			cu.U_Nombre,
			cu.U_Apellidop,
			tbcs.hora_inicio
		FROM 
			tbl_CatCajas AS tbc
			JOIN tbl_CajaXSucursal AS tbcs ON tbc.id_caja = tbcs.id_caja
			JOIN tbl_CatUsuario AS cu ON tbcs.id_cajero = cu.Id_U
		WHERE 
			tbc.activo = 1
			AND CONVERT(DATE, tbcs.fecha_inicio) = CONVERT(DATE, @fecha)

	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END



















GO
/****** Object:  StoredProcedure [dbo].[obtenerCajasxFecha_Estadisticos]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER PROCEDURE [dbo].[obtenerCajasxFecha_Estadisticos]
	@fecha			DATE

AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON

		SELECT 
			'' AS id_caja
			,'' AS descripcion
			,'' AS id_cajaXSucursal
			,'-- Seleccione --' AS U_Nombre
			,'' AS U_Apellidop
			,'' AS hora_inicio

		UNION 

		SELECT 
			tbc.id_caja,			
			tbc.descripcion,
			tbcs.id_cajaXSucursal,
			cu.U_Nombre,
			cu.U_Apellidop,
			tbcs.hora_inicio
		FROM 
			tbl_CatCajas AS tbc
			JOIN [dbo].[vtbl_CajaXSucursal_Estadisticos] AS tbcs ON tbc.id_caja = tbcs.id_caja
			JOIN tbl_CatUsuario AS cu ON tbcs.id_cajero = cu.Id_U
		WHERE 
			tbc.activo = 1
			AND CONVERT(DATE, tbcs.fecha_inicio) = CONVERT(DATE, @fecha)

	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END




















GO
/****** Object:  StoredProcedure [dbo].[obtenerCancelacionesxIDCaja]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




ALTER PROCEDURE [dbo].[obtenerCancelacionesxIDCaja]
	@id_cajaXSucursal	NVARCHAR(100),
	@fecha			DATE

AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON

		SELECT 
			tb.CodigoBarra,
			tb.NombrePersona,
			tb.asiento,
			ctO.nombre AS terminalOrigen,
			ctD.nombre AS  terminalDestino,
			tb.costo,
			vd.pago1,
			vd.pago2,
			vd.cancelacion,
			cuc.Cu_User AS vendedor
		FROM 
			tbl_Boletos AS tb
		    INNER JOIN tbl_VentaDetalle AS vd ON vd.id_boleto = tb.id_boleto
			INNER JOIN tbl_CatViajes AS cv ON tb.id_viaje = cv.id_identificador
			INNER JOIN tbl_OrdenRuta AS orO ON cv.id_ruta = orO.id_ruta
			INNER JOIN tbl_CatTerminales AS ctO ON ctO.id_terminal = orO.id_terminal AND orO.orden = tb.OrdenOrigenTerminal
			INNER JOIN tbl_OrdenRuta AS orD ON cv.id_ruta = orD.id_ruta
			INNER JOIN tbl_CatTerminales AS ctD ON ctD.id_terminal = orD.id_terminal AND orD.orden = tb.OrdenDestinoTerminal
			INNER JOIN tbl_VentaCajas AS tvc ON tvc.IDGenerico = vd.id_ventadetalle
			INNER JOIN tbl_CatUsuarioCuenta AS cuc ON tvc.usuins = cuc.Id_U	
		WHERE 
			tvc.IDCajaXSucursal = @id_cajaXSucursal AND tvc.IDStatus = 6 AND tvc.Activo = 1
		ORDER BY tb.fecins	

			

	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END





















GO
/****** Object:  StoredProcedure [dbo].[obtenerCancelacionesxIDCaja_Estadisticos]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






ALTER PROCEDURE [dbo].[obtenerCancelacionesxIDCaja_Estadisticos]
	@id_cajaXSucursal	NVARCHAR(100),
	@fecha			DATE

AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON

		SELECT 
			tb.CodigoBarra,
			tb.NombrePersona,
			tb.asiento,
			ctO.nombre AS terminalOrigen,
			ctD.nombre AS  terminalDestino,
			tb.costo,
			vd.pago1,
			vd.pago2,
			vd.cancelacion,
			cuc.Cu_User AS vendedor,
			tb.fecins
		FROM 
			[dbo].[vtbl_Boletos_Estadisticos] AS tb
		    INNER JOIN [dbo].[vtbl_VentaDetalle_Estadisticos] AS vd ON vd.id_boleto = tb.id_boleto
			INNER JOIN tbl_CatViajes AS cv ON tb.id_viaje = cv.id_identificador
			INNER JOIN tbl_OrdenRuta AS orO ON cv.id_ruta = orO.id_ruta
			INNER JOIN tbl_CatTerminales AS ctO ON ctO.id_terminal = orO.id_terminal AND orO.orden = tb.OrdenOrigenTerminal
			INNER JOIN tbl_OrdenRuta AS orD ON cv.id_ruta = orD.id_ruta
			INNER JOIN tbl_CatTerminales AS ctD ON ctD.id_terminal = orD.id_terminal AND orD.orden = tb.OrdenDestinoTerminal
			INNER JOIN [dbo].[vtbl_VentaCajas_Estadisticos] AS tvc ON tvc.IDGenerico = vd.id_ventadetalle
			INNER JOIN tbl_CatUsuarioCuenta AS cuc ON tvc.usuins = cuc.Id_U	
		WHERE 
			tvc.IDCajaXSucursal = @id_cajaXSucursal AND tvc.IDStatus = 6 AND tvc.Activo = 1
		ORDER BY tb.fecins	

			

	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END























GO
/****** Object:  StoredProcedure [dbo].[obtenerCancelacionesxIDCaja2]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




ALTER PROCEDURE [dbo].[obtenerCancelacionesxIDCaja2]
	@id_cajaXSucursal	NVARCHAR(100),
	@fechaInicio			DATE,
	@fechaFin			    DATE

AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON

		SELECT 
			tb.CodigoBarra,
			tb.NombrePersona,
			tb.asiento,
			ctO.nombre AS terminalOrigen,
			ctD.nombre AS  terminalDestino,
			tb.costo,
			vd.pago1,
			vd.pago2,
			vd.cancelacion,
			cuc.Cu_User AS vendedor
		FROM 
			tbl_Boletos AS tb
		    INNER JOIN tbl_VentaDetalle AS vd ON vd.id_boleto = tb.id_boleto
			INNER JOIN tbl_CatViajes AS cv ON tb.id_viaje = cv.id_identificador
			INNER JOIN tbl_OrdenRuta AS orO ON cv.id_ruta = orO.id_ruta
			INNER JOIN tbl_CatTerminales AS ctO ON ctO.id_terminal = orO.id_terminal AND orO.orden = tb.OrdenOrigenTerminal
			INNER JOIN tbl_OrdenRuta AS orD ON cv.id_ruta = orD.id_ruta
			INNER JOIN tbl_CatTerminales AS ctD ON ctD.id_terminal = orD.id_terminal AND orD.orden = tb.OrdenDestinoTerminal
			INNER JOIN tbl_VentaCajas AS tvc ON tvc.IDGenerico = vd.id_ventadetalle
			INNER JOIN tbl_CatUsuarioCuenta AS cuc ON tvc.usuins = cuc.Id_U	
			INNER JOIN tbl_CajaXSucursal as cs ON tvc.IDCajaXSucursal = cs.id_cajaXSucursal			
		WHERE 
		cs.id_caja = @id_cajaxSucursal	 			
		AND CONVERT(DATE,cs.fecha_inicio) BETWEEN @fechaInicio AND @fechaFin
		AND tvc.IDStatus = 6 AND tvc.Activo = 1
		ORDER BY tb.fecins	

			

	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END





















GO
/****** Object:  StoredProcedure [dbo].[obtenerCancelacionesxIDCaja2_Estadisticos]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





ALTER PROCEDURE [dbo].[obtenerCancelacionesxIDCaja2_Estadisticos]
	@id_cajaXSucursal	NVARCHAR(100),
	@fechaInicio			DATE,
	@fechaFin			    DATE

AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON

		SELECT 
			tb.CodigoBarra,
			tb.NombrePersona,
			tb.asiento,
			ctO.nombre AS terminalOrigen,
			ctD.nombre AS  terminalDestino,
			tb.costo,
			vd.pago1,
			vd.pago2,
			vd.cancelacion,
			cuc.Cu_User AS vendedor,
			tb.fecins	
		FROM 
			[dbo].[vtbl_Boletos_Estadisticos] AS tb
		    INNER JOIN [dbo].[vtbl_VentaDetalle_Estadisticos] AS vd ON vd.id_boleto = tb.id_boleto
			INNER JOIN tbl_CatViajes AS cv ON tb.id_viaje = cv.id_identificador
			INNER JOIN tbl_OrdenRuta AS orO ON cv.id_ruta = orO.id_ruta
			INNER JOIN tbl_CatTerminales AS ctO ON ctO.id_terminal = orO.id_terminal AND orO.orden = tb.OrdenOrigenTerminal
			INNER JOIN tbl_OrdenRuta AS orD ON cv.id_ruta = orD.id_ruta
			INNER JOIN tbl_CatTerminales AS ctD ON ctD.id_terminal = orD.id_terminal AND orD.orden = tb.OrdenDestinoTerminal
			INNER JOIN [dbo].[vtbl_VentaCajas_Estadisticos] AS tvc ON tvc.IDGenerico = vd.id_ventadetalle
			INNER JOIN tbl_CatUsuarioCuenta AS cuc ON tvc.usuins = cuc.Id_U	
			INNER JOIN [dbo].[vtbl_CajaXSucursal_Estadisticos] as cs ON tvc.IDCajaXSucursal = cs.id_cajaXSucursal		
		WHERE 
		cs.id_caja = @id_cajaxSucursal	 			
		AND CONVERT(DATE,cs.fecha_inicio) BETWEEN @fechaInicio AND @fechaFin
		AND tvc.IDStatus = 6 AND tvc.Activo = 1
		ORDER BY tb.fecins	

			

	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END






















GO
/****** Object:  StoredProcedure [dbo].[obtenerConfiguracionInicial]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




ALTER PROCEDURE [dbo].[obtenerConfiguracionInicial]
              @IDSucursal			NVARCHAR(100)
AS
BEGIN

	SELECT
		tbl_CatSucursales.id_sucursal, 
		tbl_CatSucursales.id_empresa, 
		tbl_CatSucursales.id_tipoSucursal, 
		tbl_CatSucursales.Nombre_Sucursal, 
		tbl_configuracion.direccion, 
		tbl_CatSucursales.telefono, 
		tbl_CatSucursales.id_municipio,
		tbl_CatSucursales.id_estado,
		tbl_CatSucursales.id_pais, 
		tbl_CatSucursales.margen_utilidad, 
		tbl_CatSucursales.codigopostal, 
		tbl_CatSucursales.rg_puntosPlata, 
		tbl_CatSucursales.rg_puntosOro, 
		tbl_CatSucursales.tiempo_espera, 
		tbl_CatSucursales.tiempo_cobro,
		tbl_CatSucursales.ip_Servidor,
		tbl_CatSucursales.porcentaje_puntos AS porcentajeMonedero,
		tbl_configuracion.id_configuracion,
		tbl_configuracion.razonsocial,
		tbl_configuracion.rfc,
		tbl_configuracion.direccion,
		tbl_configuracion.mensaje1,
		tbl_configuracion.mensaje2,
		tbl_configuracion.mensaje3,
		tbl_configuracion.nameprinter,
		tbl_configuracion.url_logo,
		'' AS direccion,
		'' AS municipio,
		'' AS estado,
		tbl_CatSucursales.monto_cancelacion
	FROM 
		tbl_CatSucursales LEFT JOIN tbl_configuracion
		ON tbl_CatSucursales.id_sucursal = tbl_configuracion.id_sucursal
	WHERE  
		tbl_CatSucursales.id_sucursal = @IDSucursal
END




















GO
/****** Object:  StoredProcedure [dbo].[obtenerDatosBaseViajeXID]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER PROCEDURE [dbo].[obtenerDatosBaseViajeXID]
		@id_viaje		   NVARCHAR(100),
		@fecha_viaje	   DATE,
		@hora			   NVARCHAR(8)
AS
BEGIN	
	BEGIN TRY

		DECLARE  @FOLIOVIAJE   NVARCHAR(20)
		SET @FOLIOVIAJE = ( SELECT ISNULL(MAX(RIGHT(folio,6)),'000000') 
							FROM tbl_DatosViaje 
							WHERE YEAR(fecins)= YEAR(GETDATE()) 
							AND MONTH(fecins) = MONTH(GETDATE())
							AND DAY(fecins) = DAY(GETDATE()))
		SET @FOLIOVIAJE = @FOLIOVIAJE + 1
		SET @FOLIOVIAJE = CONVERT(CHAR(4),YEAR(GETDATE())) + RIGHT('0' + RTRIM(MONTH(GETDATE())), 2) + RIGHT('0' + RTRIM(DAY(GETDATE())), 2) +  RIGHT('000000' + @FOLIOVIAJE, 6) 


		SET LANGUAGE Español;
		SELECT 
				@FOLIOVIAJE AS folio_prestacionServicios1,
				camion AS autobus_prestacionServicios1,
				fechaOrigen AS fecha_salida_prestacionServicios1,
				horaOrigen AS hora_salida_prestacionServicios1,
				terminalOrigen + ' - ' + terminalDestino AS servicio_prestacionServicios1,
				@FOLIOVIAJE AS folio_prestacionServicios2,
				terminalOrigen AS origen_prestacionServicios2,
				terminalDestino AS destino_prestacionServicios2,
				terminalOrigen AS lugar_salida_prestacionServicios2,
				fechaOrigen AS fecha_salida_prestacionServicios2,
				horaOrigen AS hora_salida_prestacionServicios2,
				terminalOrigen + ' - ' + terminalDestino AS ruta_contratada_prestacionServicios2,
				[dbo].[ObtnerAsientosXViajesReportes](id_viaje, fechaOrigen, horaOrigen) AS numero_personas_prestacionServicios2,
				0 AS dias_viaje_prestacionServicios2,
				CONVERT(NVARCHAR(50),DATENAME(WEEKDAY, fechaOrigen)) + ', ' + CONVERT(NVARCHAR(20), DAY(fechaOrigen)) + ' de '+  CONVERT(NVARCHAR(50),DATENAME(MONTH, fechaOrigen)) +' de ' + CONVERT(NVARCHAR(20), YEAR(fechaOrigen)) + ' ' + horaOrigen + ' hrs' AS dia_hora_salida_prestacionServicios2,
				@FOLIOVIAJE AS folio_listapasajeros,
				DAY(fechaOrigen) AS dia_listapasajeros,
				MONTH(fechaOrigen) AS mes_listapasajeros,
				YEAR(fechaOrigen) AS año_listapasajeros,
				camion AS carro_listapasajeros,
				horaOrigen AS hora_salida_listapasajeros
		FROM vtbl_FechasViaje
		WHERE id_viaje = @id_viaje
		AND fechaOrigen = @fecha_viaje
		AND horaOrigen = @hora
	    AND id_tipoTerminal = 1
		SET LANGUAGE us_english;

	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------
	END CATCH
END







































GO
/****** Object:  StoredProcedure [dbo].[obtenerDatosBoleto]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[obtenerDatosBoleto]
	@id_boleto	NVARCHAR(100)
AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON

	SELECT vtbl_BoletosImpresion.id_boleto
		  ,vtbl_BoletosImpresion.folio
		  ,vtbl_BoletosImpresion.nombreCliente
		  ,vtbl_BoletosImpresion.asiento
		  ,vtbl_BoletosImpresion.fecha_salida
		  ,vtbl_BoletosImpresion.hora_salida
		  ,vtbl_BoletosImpresion.precioBoleto
		  ,vtbl_BoletosImpresion.iva
		  ,vtbl_BoletosImpresion.formaPago
		  ,vtbl_BoletosImpresion.tipoBoleto
		  ,vtbl_BoletosImpresion.terminalOrigen
		  ,vtbl_BoletosImpresion.origen
		  ,vtbl_BoletosImpresion.terminalDestino
		  ,vtbl_BoletosImpresion.destino
		  ,vtbl_BoletosImpresion.marca
		  ,vtbl_BoletosImpresion.servicio
		  ,vtbl_BoletosImpresion.numcamion
		  ,vtbl_BoletosImpresion.descuento
		  ,vtbl_BoletosImpresion.total
		  ,vtbl_BoletosImpresion.pago
		  ,vtbl_BoletosImpresion.pendiente
		  ,vtbl_BoletosImpresion.fechaventa
		  ,vtbl_BoletosImpresion.horaventa
		  ,vtbl_BoletosImpresion.porciva
		  ,vtbl_BoletosImpresion.id_status
		  ,vtbl_BoletosImpresion.cajero
	  FROM vtbl_BoletosImpresion
	  WHERE 
		vtbl_BoletosImpresion.id_boleto = @id_boleto

	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END



















GO
/****** Object:  StoredProcedure [dbo].[obtenerDatosBoletoDetalles]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




ALTER PROCEDURE [dbo].[obtenerDatosBoletoDetalles]
	@folio	 NVARCHAR(100)
AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON

		SELECT 
		    id_boleto,
			folio,
			nombreCliente,
			asiento,
			fecha_salida,
			hora_salida,			
			precioBoleto,
			terminalOrigen,
			terminalDestino,
			marca,
			numcamion,
			descuento,
			total,
			estadoBoleto,
			pago1,
			pago2,
			VentaUsuario,
		    VentaFechaHora,
			ApartadoUsuario,
		    ApartadoFechaHora,
			AnticipoPaso1Usuario,
		    AnticipoPaso1FechaHora,
			AnticipoPaso2Usuario,
		    AnticipoPaso2FechaHora,
			TransferenciaUsuario,
		    TransferenciaFechaHora,
			CancelacionUsuario,
		    CancelacionFechaHora,
			motivoCancelacion,
			PagoEfectivo, 
			PagoMonedero,
			PagoTarjeta,
			PagoTransferencia
		FROM 
			vtbl_BoletosDetalles 
		WHERE 
			vtbl_BoletosDetalles.folio = @folio

	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END





















GO
/****** Object:  StoredProcedure [dbo].[obtenerDatosBoletoDetalles_Estadisticos]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





ALTER PROCEDURE [dbo].[obtenerDatosBoletoDetalles_Estadisticos]
	@folio	 NVARCHAR(100)
AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON

		SELECT 
		    id_boleto,
			folio,
			nombreCliente,
			asiento,
			fecha_salida,
			hora_salida,			
			precioBoleto,
			terminalOrigen,
			terminalDestino,
			marca,
			numcamion,
			descuento,
			total,
			estadoBoleto,
			pago1,
			pago2,
			VentaUsuario,
		    VentaFechaHora,
			ApartadoUsuario,
		    ApartadoFechaHora,
			AnticipoPaso1Usuario,
		    AnticipoPaso1FechaHora,
			AnticipoPaso2Usuario,
		    AnticipoPaso2FechaHora,
			TransferenciaUsuario,
		    TransferenciaFechaHora,
			CancelacionUsuario,
		    CancelacionFechaHora,
			motivoCancelacion,
			PagoEfectivo, 
			PagoMonedero,
			PagoTarjeta, 
			PagoTransferencia
		FROM 
			vtbl_BoletosDetalles 
		WHERE 
			vtbl_BoletosDetalles.folio = @folio

		UNION

		SELECT 
		    id_boleto,
			folio,
			nombreCliente,
			asiento,
			fecha_salida,
			hora_salida,			
			precioBoleto,
			terminalOrigen,
			terminalDestino,
			marca,
			numcamion,
			descuento,
			total,
			estadoBoleto,
			pago1,
			pago2,
			VentaUsuario,
		    VentaFechaHora,
			ApartadoUsuario,
		    ApartadoFechaHora,
			AnticipoPaso1Usuario,
		    AnticipoPaso1FechaHora,
			AnticipoPaso2Usuario,
		    AnticipoPaso2FechaHora,
			TransferenciaUsuario,
		    TransferenciaFechaHora,
			CancelacionUsuario,
		    CancelacionFechaHora,
			motivoCancelacion,
			PagoEfectivo, 
			PagoMonedero,
			PagoTarjeta, 
			PagoTransferencia
		FROM 
			vtbl_BoletosDetalles_Estadisticos 
		WHERE 
			vtbl_BoletosDetalles_Estadisticos.folio = @folio

		

	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END






















GO
/****** Object:  StoredProcedure [dbo].[obtenerDatosGenerales]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[obtenerDatosGenerales]
	 @id_sucursal		NVARCHAR(100)
	,@mac               NVARCHAR(20)
AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON
		  
		DECLARE	@razonsocial		NVARCHAR(80)
		DECLARE @mensaje1			NVARCHAR(MAX)
		DECLARE @mensaje2			NVARCHAR(MAX)
		DECLARE @mensaje3			NVARCHAR(MAX)
		DECLARE @rfc				NVARCHAR(50)
		DECLARE @direccion			NVARCHAR(500)
		DECLARE @url_logo			NVARCHAR(MAX)
		DECLARE @id_configuracion	NVARCHAR(100)
		DECLARE @caja				NVARCHAR(50)
		DECLARE @descripcion		NVARCHAR(100)
		DECLARE @namePrinter		NVARCHAR(250)
		DECLARE @macAddress			NVARCHAR(20)
		DECLARE @idCaja				NVARCHAR(100)

		SELECT 
			@id_configuracion	= tc.id_configuracion,
			@razonsocial	= tc.razonsocial,
			@rfc			= tc.rfc,
			@direccion      = tc.direccion,
			@mensaje1		= tc.mensaje1,
			@mensaje2		= tc.mensaje2,
			@mensaje3		= tc.mensaje3,
			@url_logo		= tc.url_logo
		FROM 
			tbl_configuracion as tc
		WHERE 
			tc.activo = 1
			AND tc.id_sucursal = @id_sucursal

		SELECT 
			   @caja = descripcion 
			  ,@descripcion = descripcion2 
			  ,@nameprinter = nameprinter
			  ,@macAddress = macAddress
			  ,@idCaja = id_caja
		FROM tbl_CatCajas
		WHERE macAddress = @mac

		SELECT 
			@id_configuracion AS id_configuracion,
			@razonsocial AS razonsocial,
			@rfc AS rfc,
			@direccion AS direccion,
			@mensaje1 AS mensaje1,
			@mensaje2 AS mensaje2,
			@mensaje3 AS mensaje3,
			@url_logo AS url_logo,
			@caja AS caja,
			@descripcion AS descripcion,
			@namePrinter AS namePrinter,
			@macAddress AS macAddress,
			@idCaja AS idCaja

	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END

















GO
/****** Object:  StoredProcedure [dbo].[obtenerDatosReportesDatos]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER PROCEDURE [dbo].[obtenerDatosReportesDatos]
         @IDSUCURSAL   NVARCHAR(100)
AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON
	
		SELECT 
				razonSocial AS razonSocial, 
				rfc AS rfc, 
				url_logo AS path, 
				direccion AS direccion	
	    FROM tbl_configuracion WHERE id_sucursal = @IDSUCURSAL
        		  
	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END




















GO
/****** Object:  StoredProcedure [dbo].[obtenerDatosVendedoresXFecha]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER PROCEDURE [dbo].[obtenerDatosVendedoresXFecha]
         @FECHAINICIO    DATE,
		 @FECHAFIN      DATE
AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON

			SELECT 
				tu.U_Nombre + ' ' + tu.U_Apellidop + ' ' + tu.U_Apellidom AS Vendedor,
				ISNULL(VentasDirectas.VentaDirecta,0.0) AS VentaDirecta,
				ISNULL(NumeroVentasDirectas.NumeroVentaDirecta,0) AS NumeroVentaDirecta,
				ISNULL(Reservaciones.Reservaciones,0.0) AS Reservaciones, 
				ISNULL(NumeroReservaciones.NumeroReservaciones,0) AS NumeroReservaciones,
				ISNULL(AnticipoPaso1.AnticipoPaso1,0.0) AS AnticipoPaso1,
				ISNULL(NumeroAnticipoPaso1.NumeroAnticipoPaso1,0) AS NumeroAnticipoPaso1,
				ISNULL(AnticipoPaso2.AnticipoPaso2,0.0) AS AnticipoPaso2,
				ISNULL(NumeroAnticipoPaso2.NumeroAnticipoPaso2,0) AS NumeroAnticipoPaso2,
				ISNULL(Transferencia.Transferencia,0.0) AS Transferencia,
				ISNULL(NumeroTransferencia.NumeroTransferencia,0) AS NumeroTransferencia,
				ISNULL(Cancelaciones.Cancelaciones,0.0) AS Cancelaciones,
				ISNULL(NumeroCancelaciones.NumeroCancelaciones,0) AS NumeroCancelaciones,
				ISNULL(CancelacionesCobroExtra.CancelacionesCobroExtra,0.0) AS CancelacionesCobroExtra,
				ISNULL(Retiros.Retiros,0.0) AS Retiros,
				ISNULL(Depositos.Depositos,0.0) AS Depositos,
				ISNULL(Monedero.Monedero,0.0) AS Monedero
			FROM tbl_CatUsuario AS tu  
				 LEFT JOIN (
						 SELECT 
						   tvc.usuins,
						   isnull(sum(tvVentas.pago1 + tvVentas.pago2),0) AS VentaDirecta
						 FROM tbl_VentaDetalle AS tvVentas JOIN tbl_VentaCajas AS tvc 
						 ON tvVentas.id_ventadetalle = tvc.IDGenerico
						 WHERE tvc.IDStatus = 1 AND tvc.Activo = 1 AND CONVERT(DATE,tvc.fecins) BETWEEN @FECHAINICIO AND @FECHAFIN
						 GROUP BY tvc.usuins   
					   ) AS VentasDirectas
			ON tu.Id_U = VentasDirectas.usuins
				 LEFT JOIN (
						 SELECT 
						   tvc.usuins,
						   COUNT(*) AS NumeroVentaDirecta
						 FROM tbl_VentaDetalle AS tvVentas JOIN tbl_VentaCajas AS tvc 
						 ON tvVentas.id_ventadetalle = tvc.IDGenerico
						 WHERE tvc.IDStatus = 1 AND tvc.Activo = 1 AND CONVERT(DATE,tvc.fecins) BETWEEN @FECHAINICIO AND @FECHAFIN
						 GROUP BY tvc.usuins   
					   ) AS NumeroVentasDirectas
			ON tu.Id_U = NumeroVentasDirectas.usuins
				 LEFT JOIN (
						 SELECT 
						   tvc.usuins,
						   isnull(sum(0.0 + 0.0),0) AS Reservaciones
						 FROM tbl_VentaDetalle AS tvVentas JOIN tbl_VentaCajas AS tvc 
						 ON tvVentas.id_ventadetalle = tvc.IDGenerico
						 WHERE tvc.IDStatus = 2 AND tvc.Activo = 1 AND CONVERT(DATE,tvc.fecins) BETWEEN @FECHAINICIO AND @FECHAFIN
						 GROUP BY tvc.usuins   
					   ) AS Reservaciones
			ON tu.Id_U = Reservaciones.usuins
				 LEFT JOIN (
						 SELECT 
						   tvc.usuins,
						   COUNT(*) AS NumeroReservaciones
						 FROM tbl_VentaDetalle AS tvVentas JOIN tbl_VentaCajas AS tvc 
						 ON tvVentas.id_ventadetalle = tvc.IDGenerico
						 WHERE tvc.IDStatus = 2 AND tvc.Activo = 1 AND CONVERT(DATE,tvc.fecins) BETWEEN @FECHAINICIO AND @FECHAFIN
						 GROUP BY tvc.usuins   
					   ) AS NumeroReservaciones
			ON tu.Id_U = NumeroReservaciones.usuins
				 LEFT JOIN (
						 SELECT 
						   tvc.usuins,
						   isnull(sum(tvVentas.pago1 + 0.0),0) AS AnticipoPaso1
						 FROM tbl_VentaDetalle AS tvVentas JOIN tbl_VentaCajas AS tvc 
						 ON tvVentas.id_ventadetalle = tvc.IDGenerico
						 WHERE tvc.IDStatus = 3 AND tvc.Activo = 1 AND CONVERT(DATE,tvc.fecins) BETWEEN @FECHAINICIO AND @FECHAFIN
						 GROUP BY tvc.usuins   
					   ) AS AnticipoPaso1
			ON tu.Id_U = AnticipoPaso1.usuins
				 LEFT JOIN (
						 SELECT 
						   tvc.usuins,
						   COUNT(*) AS NumeroAnticipoPaso1
						 FROM tbl_VentaDetalle AS tvVentas JOIN tbl_VentaCajas AS tvc 
						 ON tvVentas.id_ventadetalle = tvc.IDGenerico
						 WHERE tvc.IDStatus = 3 AND tvc.Activo = 1 AND CONVERT(DATE,tvc.fecins) BETWEEN @FECHAINICIO AND @FECHAFIN
						 GROUP BY tvc.usuins   
					   ) AS NumeroAnticipoPaso1
			ON tu.Id_U = NumeroAnticipoPaso1.usuins
				 LEFT JOIN (
						 SELECT 
						   tvc.usuins,
						   isnull(sum(0.0 + tvVentas.pago2),0) AS AnticipoPaso2
						 FROM tbl_VentaDetalle AS tvVentas JOIN tbl_VentaCajas AS tvc 
						 ON tvVentas.id_ventadetalle = tvc.IDGenerico
						 WHERE tvc.IDStatus = 4 AND tvc.Activo = 1 AND CONVERT(DATE,tvc.fecins) BETWEEN @FECHAINICIO AND @FECHAFIN
						 GROUP BY tvc.usuins   
					   ) AS AnticipoPaso2
			ON tu.Id_U = AnticipoPaso2.usuins
				 LEFT JOIN (
						 SELECT 
						   tvc.usuins,
						   COUNT(*) AS NumeroAnticipoPaso2
						 FROM tbl_VentaDetalle AS tvVentas JOIN tbl_VentaCajas AS tvc 
						 ON tvVentas.id_ventadetalle = tvc.IDGenerico
						 WHERE tvc.IDStatus = 4 AND tvc.Activo = 1 AND CONVERT(DATE,tvc.fecins) BETWEEN @FECHAINICIO AND @FECHAFIN
						 GROUP BY tvc.usuins   
					   ) AS NumeroAnticipoPaso2
			ON tu.Id_U = NumeroAnticipoPaso2.usuins
				 LEFT JOIN (
						 SELECT 
						   tvc.usuins,
						   isnull(sum(tvVentas.pago1 + tvVentas.pago2),0) AS Transferencia
						 FROM tbl_VentaDetalle AS tvVentas JOIN tbl_VentaCajas AS tvc 
						 ON tvVentas.id_ventadetalle = tvc.IDGenerico
						 WHERE tvc.IDStatus = 5 AND tvc.Activo = 1 AND CONVERT(DATE,tvc.fecins) BETWEEN @FECHAINICIO AND @FECHAFIN
						 GROUP BY tvc.usuins   
					   ) AS Transferencia
			ON tu.Id_U = Transferencia.usuins
				 LEFT JOIN (
						 SELECT 
						   tvc.usuins,
						   COUNT(*) AS NumeroTransferencia
						 FROM tbl_VentaDetalle AS tvVentas JOIN tbl_VentaCajas AS tvc 
						 ON tvVentas.id_ventadetalle = tvc.IDGenerico
						 WHERE tvc.IDStatus = 5 AND tvc.Activo = 1 AND CONVERT(DATE,tvc.fecins) BETWEEN @FECHAINICIO AND @FECHAFIN
						 GROUP BY tvc.usuins   
					   ) AS NumeroTransferencia
			ON tu.Id_U = NumeroTransferencia.usuins
				 LEFT JOIN (
						 SELECT 
						   tvc.usuins,
						   isnull(sum(tvVentas.pago1 + tvVentas.pago2),0) AS Cancelaciones
						 FROM tbl_VentaDetalle AS tvVentas JOIN tbl_VentaCajas AS tvc 
						 ON tvVentas.id_ventadetalle = tvc.IDGenerico
						 WHERE tvc.IDStatus = 6 AND tvc.Activo = 1 AND CONVERT(DATE,tvc.fecins) BETWEEN @FECHAINICIO AND @FECHAFIN
						 GROUP BY tvc.usuins   
					   ) AS Cancelaciones
			ON tu.Id_U = Cancelaciones.usuins
				 LEFT JOIN (
						 SELECT 
						   tvc.usuins,
						   COUNT(*) AS NumeroCancelaciones
						 FROM tbl_VentaDetalle AS tvVentas JOIN tbl_VentaCajas AS tvc 
						 ON tvVentas.id_ventadetalle = tvc.IDGenerico
						 WHERE tvc.IDStatus = 6 AND tvc.Activo = 1 AND CONVERT(DATE,tvc.fecins) BETWEEN @FECHAINICIO AND @FECHAFIN
						 GROUP BY tvc.usuins   
					   ) AS NumeroCancelaciones
			ON tu.Id_U = NumeroCancelaciones.usuins
				 LEFT JOIN (
						 SELECT 
						   tvc.usuins,
						   isnull(sum(tvVentas.cancelacion),0) AS CancelacionesCobroExtra
						 FROM tbl_VentaDetalle AS tvVentas JOIN tbl_VentaCajas AS tvc 
						 ON tvVentas.id_ventadetalle = tvc.IDGenerico
						 WHERE tvc.IDStatus = 6 AND tvc.Activo = 1 AND CONVERT(DATE,tvc.fecins) BETWEEN @FECHAINICIO AND @FECHAFIN
						 GROUP BY tvc.usuins   
					   ) AS CancelacionesCobroExtra
			ON tu.Id_U = CancelacionesCobroExtra.usuins
				 LEFT JOIN (
						 SELECT 
						   tbl_Retiros.UsuIns,
						   isnull(sum(tbl_Retiros.Monto),0) AS Retiros
						 FROM tbl_Retiros 
						 WHERE (tbl_Retiros.Tipo = 1  OR tbl_Retiros.Tipo = 2) AND tbl_Retiros.Activo = 1 AND CONVERT(DATE,tbl_Retiros.FecIns) BETWEEN @FECHAINICIO AND @FECHAFIN
						 GROUP BY tbl_Retiros.UsuIns   
					   ) AS Retiros
			ON tu.Id_U = Retiros.UsuIns
				 LEFT JOIN (
						 SELECT 
						   tbl_Depositos.UsuIns,
						   isnull(sum(tbl_Depositos.Monto),0) AS Depositos
						 FROM tbl_Depositos 
						 WHERE tbl_Depositos.Activo = 1 AND CONVERT(DATE,tbl_Depositos.FecIns) BETWEEN @FECHAINICIO AND @FECHAFIN
						 GROUP BY tbl_Depositos.UsuIns   
					   ) AS Depositos
			ON tu.Id_U = Depositos.UsuIns
				 LEFT JOIN (
	 				  SELECT 
						id_cajero,
						SUM(montoMonedero) AS Monedero	
					  FROM tbl_VentaPagos  
					  WHERE CONVERT(DATE,fecins) BETWEEN @FECHAINICIO AND @FECHAFIN
					  GROUP BY id_cajero
					  ) AS Monedero
			ON tu.Id_U = Monedero.id_cajero
			WHERE tu.U_Activo = 1
			ORDER BY VentasDirectas.VentaDirecta DESC

	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END






















GO
/****** Object:  StoredProcedure [dbo].[obtenerDatosVendedoresXFecha_Estadisticos]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





ALTER PROCEDURE [dbo].[obtenerDatosVendedoresXFecha_Estadisticos]
         @FECHAINICIO    DATE,
		 @FECHAFIN      DATE
AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON

		    SELECT 
			    Vendedor,
				SUM(VentaDirecta) AS VentaDirecta,
				SUM(NumeroVentaDirecta) AS NumeroVentaDirecta,
				SUM(Reservaciones) AS Reservaciones, 
				SUM(NumeroReservaciones) AS NumeroReservaciones,
				SUM(AnticipoPaso1) AS AnticipoPaso1,
				SUM(NumeroAnticipoPaso1) AS NumeroAnticipoPaso1,
				SUM(AnticipoPaso2) AS AnticipoPaso2,
				SUM(NumeroAnticipoPaso2) AS NumeroAnticipoPaso2,
				SUM(Transferencia) AS Transferencia,
				SUM(NumeroTransferencia) AS NumeroTransferencia,
				SUM(Cancelaciones) AS Cancelaciones,
				SUM(NumeroCancelaciones) AS NumeroCancelaciones,
				SUM(CancelacionesCobroExtra) AS CancelacionesCobroExtra,
				SUM(Retiros) AS Retiros,
				SUM(Depositos) AS Depositos,
				SUM(Monedero) AS Monedero
			FROM (

			SELECT 
				tu.U_Nombre + ' ' + tu.U_Apellidop + ' ' + tu.U_Apellidom AS Vendedor,
				ISNULL(VentasDirectas.VentaDirecta,0.0) AS VentaDirecta,
				ISNULL(NumeroVentasDirectas.NumeroVentaDirecta,0) AS NumeroVentaDirecta,
				ISNULL(Reservaciones.Reservaciones,0.0) AS Reservaciones, 
				ISNULL(NumeroReservaciones.NumeroReservaciones,0) AS NumeroReservaciones,
				ISNULL(AnticipoPaso1.AnticipoPaso1,0.0) AS AnticipoPaso1,
				ISNULL(NumeroAnticipoPaso1.NumeroAnticipoPaso1,0) AS NumeroAnticipoPaso1,
				ISNULL(AnticipoPaso2.AnticipoPaso2,0.0) AS AnticipoPaso2,
				ISNULL(NumeroAnticipoPaso2.NumeroAnticipoPaso2,0) AS NumeroAnticipoPaso2,
				ISNULL(Transferencia.Transferencia,0.0) AS Transferencia,
				ISNULL(NumeroTransferencia.NumeroTransferencia,0) AS NumeroTransferencia,
				ISNULL(Cancelaciones.Cancelaciones,0.0) AS Cancelaciones,
				ISNULL(NumeroCancelaciones.NumeroCancelaciones,0) AS NumeroCancelaciones,
				ISNULL(CancelacionesCobroExtra.CancelacionesCobroExtra,0.0) AS CancelacionesCobroExtra,
				ISNULL(Retiros.Retiros,0.0) AS Retiros,
				ISNULL(Depositos.Depositos,0.0) AS Depositos,
				ISNULL(Monedero.Monedero,0.0) AS Monedero
			FROM tbl_CatUsuario AS tu  
				 LEFT JOIN (
						 SELECT 
						   tvc.usuins,
						   isnull(sum(tvVentas.pago1 + tvVentas.pago2),0) AS VentaDirecta
						 FROM [dbo].[vtbl_VentaDetalle_Estadisticos] AS tvVentas JOIN [dbo].[vtbl_VentaCajas_Estadisticos] AS tvc 
						 ON tvVentas.id_ventadetalle = tvc.IDGenerico
						 WHERE tvc.IDStatus = 1 AND tvc.Activo = 1 AND CONVERT(DATE,tvc.fecins) BETWEEN @FECHAINICIO AND @FECHAFIN
						 GROUP BY tvc.usuins   
					   ) AS VentasDirectas
			ON tu.Id_U = VentasDirectas.usuins
				 LEFT JOIN (
						 SELECT 
						   tvc.usuins,
						   COUNT(tvc.IDGenerico) AS NumeroVentaDirecta
						 FROM [dbo].[vtbl_VentaDetalle_Estadisticos] AS tvVentas JOIN [dbo].[vtbl_VentaCajas_Estadisticos] AS tvc 
						 ON tvVentas.id_ventadetalle = tvc.IDGenerico
						 WHERE tvc.IDStatus = 1 AND tvc.Activo = 1 AND CONVERT(DATE,tvc.fecins) BETWEEN @FECHAINICIO AND @FECHAFIN
						 GROUP BY tvc.usuins   
					   ) AS NumeroVentasDirectas
			ON tu.Id_U = NumeroVentasDirectas.usuins
				 LEFT JOIN (
						 SELECT 
						   tvc.usuins,
						   isnull(sum(0.0 + 0.0),0) AS Reservaciones
						 FROM [dbo].[vtbl_VentaDetalle_Estadisticos] AS tvVentas JOIN [dbo].[vtbl_VentaCajas_Estadisticos] AS tvc 
						 ON tvVentas.id_ventadetalle = tvc.IDGenerico
						 WHERE tvc.IDStatus = 2 AND tvc.Activo = 1 AND CONVERT(DATE,tvc.fecins) BETWEEN @FECHAINICIO AND @FECHAFIN
						 GROUP BY tvc.usuins   
					   ) AS Reservaciones
			ON tu.Id_U = Reservaciones.usuins
				 LEFT JOIN (
						 SELECT 
						   tvc.usuins,
						   COUNT(tvc.IDGenerico) AS NumeroReservaciones
						 FROM [dbo].[vtbl_VentaDetalle_Estadisticos] AS tvVentas JOIN [dbo].[vtbl_VentaCajas_Estadisticos] AS tvc 
						 ON tvVentas.id_ventadetalle = tvc.IDGenerico
						 WHERE tvc.IDStatus = 2 AND tvc.Activo = 1 AND CONVERT(DATE,tvc.fecins) BETWEEN @FECHAINICIO AND @FECHAFIN
						 GROUP BY tvc.usuins   
					   ) AS NumeroReservaciones
			ON tu.Id_U = NumeroReservaciones.usuins
				 LEFT JOIN (
						 SELECT 
						   tvc.usuins,
						   isnull(sum(tvVentas.pago1 + 0.0),0) AS AnticipoPaso1
						 FROM [dbo].[vtbl_VentaDetalle_Estadisticos] AS tvVentas JOIN [dbo].[vtbl_VentaCajas_Estadisticos] AS tvc 
						 ON tvVentas.id_ventadetalle = tvc.IDGenerico
						 WHERE tvc.IDStatus = 3 AND tvc.Activo = 1 AND CONVERT(DATE,tvc.fecins) BETWEEN @FECHAINICIO AND @FECHAFIN
						 GROUP BY tvc.usuins   
					   ) AS AnticipoPaso1
			ON tu.Id_U = AnticipoPaso1.usuins
				 LEFT JOIN (
						 SELECT 
						   tvc.usuins,
						   COUNT(tvc.IDGenerico) AS NumeroAnticipoPaso1
						 FROM [dbo].[vtbl_VentaDetalle_Estadisticos] AS tvVentas JOIN [dbo].[vtbl_VentaCajas_Estadisticos] AS tvc 
						 ON tvVentas.id_ventadetalle = tvc.IDGenerico
						 WHERE tvc.IDStatus = 3 AND tvc.Activo = 1 AND CONVERT(DATE,tvc.fecins) BETWEEN @FECHAINICIO AND @FECHAFIN
						 GROUP BY tvc.usuins   
					   ) AS NumeroAnticipoPaso1
			ON tu.Id_U = NumeroAnticipoPaso1.usuins
				 LEFT JOIN (
						 SELECT 
						   tvc.usuins,
						   isnull(sum(0.0 + tvVentas.pago2),0) AS AnticipoPaso2
						 FROM [dbo].[vtbl_VentaDetalle_Estadisticos] AS tvVentas JOIN [dbo].[vtbl_VentaCajas_Estadisticos] AS tvc 
						 ON tvVentas.id_ventadetalle = tvc.IDGenerico
						 WHERE tvc.IDStatus = 4 AND tvc.Activo = 1 AND CONVERT(DATE,tvc.fecins) BETWEEN @FECHAINICIO AND @FECHAFIN
						 GROUP BY tvc.usuins   
					   ) AS AnticipoPaso2
			ON tu.Id_U = AnticipoPaso2.usuins
				 LEFT JOIN (
						 SELECT 
						   tvc.usuins,
						   COUNT(tvc.IDGenerico) AS NumeroAnticipoPaso2
						 FROM [dbo].[vtbl_VentaDetalle_Estadisticos] AS tvVentas JOIN [dbo].[vtbl_VentaCajas_Estadisticos] AS tvc 
						 ON tvVentas.id_ventadetalle = tvc.IDGenerico
						 WHERE tvc.IDStatus = 4 AND tvc.Activo = 1 AND CONVERT(DATE,tvc.fecins) BETWEEN @FECHAINICIO AND @FECHAFIN
						 GROUP BY tvc.usuins   
					   ) AS NumeroAnticipoPaso2
			ON tu.Id_U = NumeroAnticipoPaso2.usuins
				 LEFT JOIN (
						 SELECT 
						   tvc.usuins,
						   isnull(sum(tvVentas.pago1 + tvVentas.pago2),0) AS Transferencia
						 FROM [dbo].[vtbl_VentaDetalle_Estadisticos] AS tvVentas JOIN [dbo].[vtbl_VentaCajas_Estadisticos] AS tvc 
						 ON tvVentas.id_ventadetalle = tvc.IDGenerico
						 WHERE tvc.IDStatus = 5 AND tvc.Activo = 1 AND CONVERT(DATE,tvc.fecins) BETWEEN @FECHAINICIO AND @FECHAFIN
						 GROUP BY tvc.usuins   
					   ) AS Transferencia
			ON tu.Id_U = Transferencia.usuins
				 LEFT JOIN (
						 SELECT 
						   tvc.usuins,
						   COUNT(tvc.IDGenerico) AS NumeroTransferencia
						 FROM [dbo].[vtbl_VentaDetalle_Estadisticos] AS tvVentas JOIN [dbo].[vtbl_VentaCajas_Estadisticos] AS tvc 
						 ON tvVentas.id_ventadetalle = tvc.IDGenerico
						 WHERE tvc.IDStatus = 5 AND tvc.Activo = 1 AND CONVERT(DATE,tvc.fecins) BETWEEN @FECHAINICIO AND @FECHAFIN
						 GROUP BY tvc.usuins   
					   ) AS NumeroTransferencia
			ON tu.Id_U = NumeroTransferencia.usuins
				 LEFT JOIN (
						 SELECT 
						   tvc.usuins,
						   isnull(sum(tvVentas.pago1 + tvVentas.pago2),0) AS Cancelaciones
						 FROM [dbo].[vtbl_VentaDetalle_Estadisticos] AS tvVentas JOIN [dbo].[vtbl_VentaCajas_Estadisticos] AS tvc 
						 ON tvVentas.id_ventadetalle = tvc.IDGenerico
						 WHERE tvc.IDStatus = 6 AND tvc.Activo = 1 AND CONVERT(DATE,tvc.fecins) BETWEEN @FECHAINICIO AND @FECHAFIN
						 GROUP BY tvc.usuins   
					   ) AS Cancelaciones
			ON tu.Id_U = Cancelaciones.usuins
				 LEFT JOIN (
						 SELECT 
						   tvc.usuins,
						   COUNT(tvc.IDGenerico) AS NumeroCancelaciones
						 FROM [dbo].[vtbl_VentaDetalle_Estadisticos] AS tvVentas JOIN [dbo].[vtbl_VentaCajas_Estadisticos] AS tvc 
						 ON tvVentas.id_ventadetalle = tvc.IDGenerico
						 WHERE tvc.IDStatus = 6 AND tvc.Activo = 1 AND CONVERT(DATE,tvc.fecins) BETWEEN @FECHAINICIO AND @FECHAFIN
						 GROUP BY tvc.usuins   
					   ) AS NumeroCancelaciones
			ON tu.Id_U = NumeroCancelaciones.usuins
				 LEFT JOIN (
						 SELECT 
						   tvc.usuins,
						   isnull(sum(tvVentas.cancelacion),0) AS CancelacionesCobroExtra
						 FROM [dbo].[vtbl_VentaDetalle_Estadisticos] AS tvVentas JOIN [dbo].[vtbl_VentaCajas_Estadisticos] AS tvc 
						 ON tvVentas.id_ventadetalle = tvc.IDGenerico
						 WHERE tvc.IDStatus = 6 AND tvc.Activo = 1 AND CONVERT(DATE,tvc.fecins) BETWEEN @FECHAINICIO AND @FECHAFIN
						 GROUP BY tvc.usuins   
					   ) AS CancelacionesCobroExtra
			ON tu.Id_U = CancelacionesCobroExtra.usuins
				 LEFT JOIN (
						 SELECT 
						   [dbo].[vtbl_Retiros_Estadisticos].UsuIns,
						   isnull(sum([dbo].[vtbl_Retiros_Estadisticos].Monto),0) AS Retiros
						 FROM [dbo].[vtbl_Retiros_Estadisticos] 
						 WHERE ([dbo].[vtbl_Retiros_Estadisticos].Tipo = 1  OR [dbo].[vtbl_Retiros_Estadisticos].Tipo = 2) AND [dbo].[vtbl_Retiros_Estadisticos].Activo = 1 AND CONVERT(DATE,[dbo].[vtbl_Retiros_Estadisticos].FecIns) BETWEEN @FECHAINICIO AND @FECHAFIN
						 GROUP BY [dbo].[vtbl_Retiros_Estadisticos].UsuIns   
					   ) AS Retiros
			ON tu.Id_U = Retiros.UsuIns
				 LEFT JOIN (
						 SELECT 
						   [dbo].[vtbl_Depositos_Estadisticos].UsuIns,
						   isnull(sum([dbo].[vtbl_Depositos_Estadisticos].Monto),0) AS Depositos
						 FROM [dbo].[vtbl_Depositos_Estadisticos] 
						 WHERE [dbo].[vtbl_Depositos_Estadisticos].Activo = 1 AND CONVERT(DATE,[dbo].[vtbl_Depositos_Estadisticos].FecIns) BETWEEN @FECHAINICIO AND @FECHAFIN
						 GROUP BY [dbo].[vtbl_Depositos_Estadisticos].UsuIns   
					   ) AS Depositos
			ON tu.Id_U = Depositos.UsuIns
				 LEFT JOIN (
	 				  SELECT 
						id_cajero,
						SUM(montoMonedero) AS Monedero	
					  FROM [dbo].[vtbl_VentaPagos_Estadisticos]  
					  WHERE CONVERT(DATE,fecins) BETWEEN @FECHAINICIO AND @FECHAFIN
					  GROUP BY id_cajero
					  ) AS Monedero
			ON tu.Id_U = Monedero.id_cajero
			WHERE tu.U_Activo = 1
			) AS Ventas
			GROUP BY Ventas.Vendedor
			ORDER BY SUM(Ventas.VentaDirecta) DESC 

	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END
























GO
/****** Object:  StoredProcedure [dbo].[obtenerDatosViaje_EstadisticosXID]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






ALTER PROCEDURE [dbo].[obtenerDatosViaje_EstadisticosXID]
		@id_viaje		   NVARCHAR(100),
		@fecha_viaje	   DATE,
		@hora			   NVARCHAR(8),
		@id_DatosViaje     NVARCHAR(100)
AS
BEGIN	
	BEGIN TRY

	SELECT 
		   vtbl_DatosViajeContratoServicio1_Estadisticos.folio AS folio_prestacionServicios1
		  ,vtbl_DatosViajeContratoServicio1_Estadisticos.id_chofer1 AS id_chofer1_prestacionServicios1
		  ,chofer1Prestacion1.nombre + ' ' + chofer1Prestacion1.apellidopaterno + ' ' + chofer1Prestacion1.apellidomaterno AS chofer1_prestacionServicios1
		  ,vtbl_DatosViajeContratoServicio1_Estadisticos.id_chofer2 AS id_chofer2_prestacionServicios1
		  ,chofer2Prestacion1.nombre + ' ' + chofer2Prestacion1.apellidopaterno + ' ' + chofer2Prestacion1.apellidomaterno AS chofer2_prestacionServicios1
		  ,vtbl_DatosViajeContratoServicio1_Estadisticos.autobus AS autobus_prestacionServicios1
		  ,vtbl_DatosViajeContratoServicio1_Estadisticos.fecha_salida AS fecha_salida_prestacionServicios1
		  ,vtbl_DatosViajeContratoServicio1_Estadisticos.hora_salida AS hora_salida_prestacionServicios1
		  ,vtbl_DatosViajeContratoServicio1_Estadisticos.solicitado_por AS solicitado_por_prestacionServicios1
		  ,vtbl_DatosViajeContratoServicio1_Estadisticos.grupo AS grupo_prestacionServicios1
		  ,vtbl_DatosViajeContratoServicio1_Estadisticos.servicio AS servicio_prestacionServicios1
		  ,vtbl_DatosViajeContratoServicio1_Estadisticos.presentarse_en AS presentarse_en_prestacionServicios1
		  ,vtbl_DatosViajeContratoServicio1_Estadisticos.instrucciones AS instrucciones_prestacionServicios1
		  ,vtbl_DatosViajeContratoServicio1_Estadisticos.observaciones AS observaciones_prestacionServicios1
		  ,vtbl_DatosViajeContratoServicio2_Estadisticos.folio AS folio_prestacionServicios2
		  ,vtbl_DatosViajeContratoServicio2_Estadisticos.solicitado_por AS solicitado_por_prestacionServicios2
		  ,vtbl_DatosViajeContratoServicio2_Estadisticos.poliza AS poliza_prestacionServicios2
		  ,vtbl_DatosViajeContratoServicio2_Estadisticos.poliza_fecha1 AS poliza_fecha1_prestacionServicios2
		  ,vtbl_DatosViajeContratoServicio2_Estadisticos.poliza_fecha2 AS poliza_fecha2_prestacionServicios2
		  ,vtbl_DatosViajeContratoServicio2_Estadisticos.credencial_elector AS credencial_elector_prestacionServicios2
		  ,vtbl_DatosViajeContratoServicio2_Estadisticos.domicilio AS domicilio_prestacionServicios2
		  ,vtbl_DatosViajeContratoServicio2_Estadisticos.origen AS origen_prestacionServicios2
		  ,vtbl_DatosViajeContratoServicio2_Estadisticos.destino AS destino_prestacionServicios2
		  ,vtbl_DatosViajeContratoServicio2_Estadisticos.monto_servicio AS monto_servicio_prestacionServicios2
		  ,vtbl_DatosViajeContratoServicio2_Estadisticos.monto_servicio_texto AS monto_servicio_texto_prestacionServicios2
		  ,vtbl_DatosViajeContratoServicio2_Estadisticos.lugar_salida AS lugar_salida_prestacionServicios2
		  ,vtbl_DatosViajeContratoServicio2_Estadisticos.fecha_salida AS fecha_salida_prestacionServicios2
		  ,vtbl_DatosViajeContratoServicio2_Estadisticos.hora_salida AS hora_salida_prestacionServicios2
		  ,vtbl_DatosViajeContratoServicio2_Estadisticos.numero_personas AS numero_personas_prestacionServicios2
		  ,vtbl_DatosViajeContratoServicio2_Estadisticos.id_chofer1 AS id_chofer1_prestacionServicios2
		  ,chofer1Prestacion2.nombre + ' ' + chofer1Prestacion2.apellidopaterno + ' ' + chofer1Prestacion2.apellidomaterno AS chofer1_prestacionServicios2
		  ,vtbl_DatosViajeContratoServicio2_Estadisticos.id_chofer2 AS id_chofer2_prestacionServicios2
		  ,chofer2Prestacion2.nombre + ' ' + chofer2Prestacion2.apellidopaterno + ' ' + chofer2Prestacion2.apellidomaterno AS chofer2_prestacionServicios2
		  ,vtbl_DatosViajeContratoServicio2_Estadisticos.numero_placa AS numero_placa_prestacionServicios2
		  ,vtbl_DatosViajeContratoServicio2_Estadisticos.ruta_contratada AS ruta_contratada_prestacionServicios2
		  ,vtbl_DatosViajeContratoServicio2_Estadisticos.dias_viaje AS dias_viaje_prestacionServicios2
		  ,vtbl_DatosViajeContratoServicio2_Estadisticos.dia_hora_salida AS dia_hora_salida_prestacionServicios2
		  ,tbl_DatosViajeListaPasajeros.folio AS folio_listapasajeros
		  ,tbl_DatosViajeListaPasajeros.oficina AS oficina_listapasajeros
		  ,tbl_DatosViajeListaPasajeros.dia AS dia_listapasajeros
		  ,tbl_DatosViajeListaPasajeros.mes AS mes_listapasajeros
		  ,tbl_DatosViajeListaPasajeros.año AS año_listapasajeros
		  ,tbl_DatosViajeListaPasajeros.carro AS carro_listapasajeros
		  ,tbl_DatosViajeListaPasajeros.oficinista AS oficinista_listapasajeros
		  ,tbl_DatosViajeListaPasajeros.hora_salida AS hora_salida_listapasajeros
		  ,vtbl_DatosViajeContratoServicio1_Estadisticos.id_prestacionServicios1
		  ,vtbl_DatosViajeContratoServicio2_Estadisticos.id_prestacionServicios2
		  ,tbl_DatosViajeListaPasajeros.id_listapasajeros
	FROM vtbl_DatosViaje_Estadisticos JOIN vtbl_DatosViajeContratoServicio1_Estadisticos
	ON vtbl_DatosViaje_Estadisticos.id_prestacionServicios1 = vtbl_DatosViajeContratoServicio1_Estadisticos.id_prestacionServicios1
	JOIN vtbl_DatosViajeContratoServicio2_Estadisticos
	ON vtbl_DatosViaje_Estadisticos.id_prestacionServicios2 = vtbl_DatosViajeContratoServicio2_Estadisticos.id_prestacionServicios2
	JOIN tbl_DatosViajeListaPasajeros
	ON vtbl_DatosViaje_Estadisticos.id_listapasajeros = tbl_DatosViajeListaPasajeros.id_listapasajeros
	JOIN tbl_CatChoferes AS chofer1Prestacion1
	ON vtbl_DatosViajeContratoServicio1_Estadisticos.id_chofer1  = chofer1Prestacion1.id_chofer
	JOIN tbl_CatChoferes AS chofer2Prestacion1
	ON vtbl_DatosViajeContratoServicio1_Estadisticos.id_chofer2  = chofer2Prestacion1.id_chofer
	JOIN tbl_CatChoferes AS chofer1Prestacion2
	ON vtbl_DatosViajeContratoServicio2_Estadisticos.id_chofer1  = chofer1Prestacion2.id_chofer
	JOIN tbl_CatChoferes AS chofer2Prestacion2
	ON vtbl_DatosViajeContratoServicio2_Estadisticos.id_chofer2  = chofer2Prestacion2.id_chofer
	WHERE vtbl_DatosViaje_Estadisticos.id_viaje = @id_viaje AND vtbl_DatosViaje_Estadisticos.fecha_salida = @fecha_viaje AND vtbl_DatosViaje_Estadisticos.hora_salida = @hora AND vtbl_DatosViaje_Estadisticos.id_datosViaje = @id_DatosViaje
	
	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------
	END CATCH
END










































GO
/****** Object:  StoredProcedure [dbo].[obtenerDatosViajeXID]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





ALTER PROCEDURE [dbo].[obtenerDatosViajeXID]
		@id_viaje		   NVARCHAR(100),
		@fecha_viaje	   DATE,
		@hora			   NVARCHAR(8),
		@id_DatosViaje     NVARCHAR(100)
AS
BEGIN	
	BEGIN TRY

	SELECT 
	       
		   tbl_DatosViajeContratoServicio1.folio AS folio_prestacionServicios1
		  ,tbl_DatosViajeContratoServicio1.id_chofer1 AS id_chofer1_prestacionServicios1
		  ,chofer1Prestacion1.nombre + ' ' + chofer1Prestacion1.apellidopaterno + ' ' + chofer1Prestacion1.apellidomaterno AS chofer1_prestacionServicios1
		  ,tbl_DatosViajeContratoServicio1.id_chofer2 AS id_chofer2_prestacionServicios1
		  ,chofer2Prestacion1.nombre + ' ' + chofer2Prestacion1.apellidopaterno + ' ' + chofer2Prestacion1.apellidomaterno AS chofer2_prestacionServicios1
		  ,tbl_DatosViajeContratoServicio1.autobus AS autobus_prestacionServicios1
		  ,tbl_DatosViajeContratoServicio1.fecha_salida AS fecha_salida_prestacionServicios1
		  ,tbl_DatosViajeContratoServicio1.hora_salida AS hora_salida_prestacionServicios1
		  ,tbl_DatosViajeContratoServicio1.solicitado_por AS solicitado_por_prestacionServicios1
		  ,tbl_DatosViajeContratoServicio1.grupo AS grupo_prestacionServicios1
		  ,tbl_DatosViajeContratoServicio1.servicio AS servicio_prestacionServicios1
		  ,tbl_DatosViajeContratoServicio1.presentarse_en AS presentarse_en_prestacionServicios1
		  ,tbl_DatosViajeContratoServicio1.instrucciones AS instrucciones_prestacionServicios1
		  ,tbl_DatosViajeContratoServicio1.observaciones AS observaciones_prestacionServicios1
		  ,tbl_DatosViajeContratoServicio2.folio AS folio_prestacionServicios2
		  ,tbl_DatosViajeContratoServicio2.solicitado_por AS solicitado_por_prestacionServicios2
		  ,tbl_DatosViajeContratoServicio2.poliza AS poliza_prestacionServicios2
		  ,tbl_DatosViajeContratoServicio2.poliza_fecha1 AS poliza_fecha1_prestacionServicios2
		  ,tbl_DatosViajeContratoServicio2.poliza_fecha2 AS poliza_fecha2_prestacionServicios2
		  ,tbl_DatosViajeContratoServicio2.credencial_elector AS credencial_elector_prestacionServicios2
		  ,tbl_DatosViajeContratoServicio2.domicilio AS domicilio_prestacionServicios2
		  ,tbl_DatosViajeContratoServicio2.origen AS origen_prestacionServicios2
		  ,tbl_DatosViajeContratoServicio2.destino AS destino_prestacionServicios2
		  ,tbl_DatosViajeContratoServicio2.monto_servicio AS monto_servicio_prestacionServicios2
		  ,tbl_DatosViajeContratoServicio2.monto_servicio_texto AS monto_servicio_texto_prestacionServicios2
		  ,tbl_DatosViajeContratoServicio2.lugar_salida AS lugar_salida_prestacionServicios2
		  ,tbl_DatosViajeContratoServicio2.fecha_salida AS fecha_salida_prestacionServicios2
		  ,tbl_DatosViajeContratoServicio2.hora_salida AS hora_salida_prestacionServicios2
		  ,tbl_DatosViajeContratoServicio2.numero_personas AS numero_personas_prestacionServicios2
		  ,tbl_DatosViajeContratoServicio2.id_chofer1 AS id_chofer1_prestacionServicios2
		  ,chofer1Prestacion2.nombre + ' ' + chofer1Prestacion2.apellidopaterno + ' ' + chofer1Prestacion2.apellidomaterno AS chofer1_prestacionServicios2
		  ,tbl_DatosViajeContratoServicio2.id_chofer2 AS id_chofer2_prestacionServicios2
		  ,chofer2Prestacion2.nombre + ' ' + chofer2Prestacion2.apellidopaterno + ' ' + chofer2Prestacion2.apellidomaterno AS chofer2_prestacionServicios2
		  ,tbl_DatosViajeContratoServicio2.numero_placa AS numero_placa_prestacionServicios2
		  ,tbl_DatosViajeContratoServicio2.ruta_contratada AS ruta_contratada_prestacionServicios2
		  ,tbl_DatosViajeContratoServicio2.dias_viaje AS dias_viaje_prestacionServicios2
		  ,tbl_DatosViajeContratoServicio2.dia_hora_salida AS dia_hora_salida_prestacionServicios2
		  ,tbl_DatosViajeListaPasajeros.folio AS folio_listapasajeros
		  ,tbl_DatosViajeListaPasajeros.oficina AS oficina_listapasajeros
		  ,tbl_DatosViajeListaPasajeros.dia AS dia_listapasajeros
		  ,tbl_DatosViajeListaPasajeros.mes AS mes_listapasajeros
		  ,tbl_DatosViajeListaPasajeros.año AS año_listapasajeros
		  ,tbl_DatosViajeListaPasajeros.carro AS carro_listapasajeros
		  ,tbl_DatosViajeListaPasajeros.oficinista AS oficinista_listapasajeros
		  ,tbl_DatosViajeListaPasajeros.hora_salida AS hora_salida_listapasajeros
		  ,tbl_DatosViajeContratoServicio1.id_prestacionServicios1
		  ,tbl_DatosViajeContratoServicio2.id_prestacionServicios2
		  ,tbl_DatosViajeListaPasajeros.id_listapasajeros
	FROM tbl_DatosViaje JOIN tbl_DatosViajeContratoServicio1
	ON tbl_DatosViaje.id_prestacionServicios1 = tbl_DatosViajeContratoServicio1.id_prestacionServicios1
	JOIN tbl_DatosViajeContratoServicio2
	ON tbl_DatosViaje.id_prestacionServicios2 = tbl_DatosViajeContratoServicio2.id_prestacionServicios2
	JOIN tbl_DatosViajeListaPasajeros
	ON tbl_DatosViaje.id_listapasajeros = tbl_DatosViajeListaPasajeros.id_listapasajeros
	JOIN tbl_CatChoferes AS chofer1Prestacion1
	ON tbl_DatosViajeContratoServicio1.id_chofer1  = chofer1Prestacion1.id_chofer
	JOIN tbl_CatChoferes AS chofer2Prestacion1
	ON tbl_DatosViajeContratoServicio1.id_chofer2  = chofer2Prestacion1.id_chofer
	JOIN tbl_CatChoferes AS chofer1Prestacion2
	ON tbl_DatosViajeContratoServicio2.id_chofer1  = chofer1Prestacion2.id_chofer
	JOIN tbl_CatChoferes AS chofer2Prestacion2
	ON tbl_DatosViajeContratoServicio2.id_chofer2  = chofer2Prestacion2.id_chofer
	WHERE tbl_DatosViaje.id_viaje = @id_viaje AND tbl_DatosViaje.fecha_salida = @fecha_viaje AND tbl_DatosViaje.hora_salida = @hora AND tbl_DatosViaje.id_datosViaje = @id_DatosViaje
	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------
	END CATCH
END









































GO
/****** Object:  StoredProcedure [dbo].[obtenerDepRetxIDCajaSucursal]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







ALTER PROCEDURE [dbo].[obtenerDepRetxIDCajaSucursal]
	 @opcion				INT,
	 @id_cajaxSucursal		NVARCHAR(100),
	 @fecha					DATE	
AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON

		IF(@opcion = 1)
		BEGIN
			SELECT 
				tr.Id_Retiro as id_movimiento,
				tr.Motivo as motivo,
				tr.Monto as monto,
				cuc.Cu_User as vendedor,
				vc.IDStatus
			FROM 
				tbl_Retiros as tr
	            INNER JOIN tbl_VentaCajas as vc ON vc.IDGenerico = tr.Id_Retiro
				INNER JOIN tbl_CatUsuarioCuenta as cuc ON  vc.usuins = cuc.Id_U

			WHERE 
	 			vc.IDCajaXSucursal = @id_cajaxSucursal		
				AND tr.Activo = 1 
				AND vc.IDStatus = 8
				AND vc.Activo = 1
			ORDER BY tr.FecIns
			

		END

		IF(@opcion = 2)
		BEGIN
			SELECT 
				td.Id_Deposito as id_movimiento,
				td.Motivo as motivo,
				td.Monto as monto,
				cuc.Cu_User as vendedor
			FROM 
				tbl_Depositos as td	
				INNER JOIN tbl_VentaCajas as vc ON vc.IDGenerico = td.Id_Deposito
				INNER JOIN tbl_CatUsuarioCuenta as cuc ON vc.usuins = cuc.Id_U

			WHERE 
				td.id_cajaXSucursal = @id_cajaxSucursal		
				AND td.Activo = 1
				AND vc.IDStatus = 7
				AND vc.Activo = 1
			ORDER BY td.FecIns
		END


	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END
























GO
/****** Object:  StoredProcedure [dbo].[obtenerDepRetxIDCajaSucursal_Estadisticos]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







ALTER PROCEDURE [dbo].[obtenerDepRetxIDCajaSucursal_Estadisticos]
	 @opcion				INT,
	 @id_cajaxSucursal		NVARCHAR(100),
	 @fecha					DATE	
AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON

		IF(@opcion = 1)
		BEGIN
			SELECT 
				tr.Id_Retiro as id_movimiento,
				tr.Motivo as motivo,
				tr.Monto as monto,
				cuc.Cu_User as vendedor,
				vc.IDStatus,
				tr.FecIns
			FROM 
				[dbo].[vtbl_Retiros_Estadisticos] as tr
	            INNER JOIN [dbo].[vtbl_VentaCajas_Estadisticos] as vc ON vc.IDGenerico = tr.Id_Retiro
				INNER JOIN tbl_CatUsuarioCuenta as cuc ON  vc.usuins = cuc.Id_U

			WHERE 
	 		vc.IDCajaXSucursal = @id_cajaxSucursal		
			AND tr.Activo = 1 
			AND vc.IDStatus = 8
			AND vc.Activo = 1
			ORDER BY tr.FecIns
		END

		IF(@opcion = 2)
		BEGIN
			SELECT 
				td.Id_Deposito as id_movimiento,
				td.Motivo as motivo,
				td.Monto as monto,
				cuc.Cu_User as vendedor,
				td.FecIns
			FROM 
				[dbo].[vtbl_Depositos_Estadisticos] as td	
				INNER JOIN [dbo].[vtbl_VentaCajas_Estadisticos] as vc ON vc.IDGenerico = td.Id_Deposito
				INNER JOIN tbl_CatUsuarioCuenta as cuc ON vc.usuins = cuc.Id_U

			WHERE 
				td.id_cajaXSucursal = @id_cajaxSucursal		
				AND td.Activo = 1
				AND vc.IDStatus = 7
				AND vc.Activo = 1
			ORDER BY td.FecIns
		END


	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END
























GO
/****** Object:  StoredProcedure [dbo].[obtenerDepRetxIDCajaSucursal2]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[obtenerDepRetxIDCajaSucursal2]
	 @opcion				INT,
	 @id_cajaxSucursal		NVARCHAR(100),
	 @fechaInicio			DATE,
	 @fechaFin			    DATE	
AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON
		IF(@opcion = 1)
		BEGIN
			SELECT 
				tr.Id_Retiro as id_movimiento,
				tr.Motivo as motivo,
				tr.Monto as monto,
				cuc.Cu_User as vendedor,
				vc.IDStatus
			FROM 
				tbl_Retiros as tr
	            INNER JOIN tbl_VentaCajas as vc ON vc.IDGenerico = tr.Id_Retiro
				INNER JOIN tbl_CatUsuarioCuenta as cuc ON  vc.usuins = cuc.Id_U
				INNER JOIN tbl_CajaXSucursal as cs ON vc.IDCajaXSucursal = cs.id_cajaXSucursal
			WHERE
			cs.id_caja = @id_cajaxSucursal	 			
			AND CONVERT(DATE,cs.fecha_inicio) BETWEEN @fechaInicio AND @fechaFin
			AND tr.Activo = 1 
			AND vc.IDStatus = 8
			AND vc.Activo = 1
		END

		IF(@opcion = 2)
		BEGIN
			SELECT 
				td.Id_Deposito as id_movimiento,
				td.Motivo as motivo,
				td.Monto as monto,
				cuc.Cu_User as vendedor
			FROM 
				tbl_Depositos as td	
				INNER JOIN tbl_VentaCajas as vc ON vc.IDGenerico = td.Id_Deposito
				INNER JOIN tbl_CatUsuarioCuenta as cuc ON vc.usuins = cuc.Id_U
				INNER JOIN tbl_CajaXSucursal as cs ON vc.IDCajaXSucursal = cs.id_cajaXSucursal
			WHERE 
			cs.id_caja = @id_cajaxSucursal	 			
			AND CONVERT(DATE,cs.fecha_inicio) BETWEEN @fechaInicio AND @fechaFin				
			AND td.Activo = 1 
			AND vc.IDStatus = 7
			AND vc.Activo = 1		
			END


	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END


















GO
/****** Object:  StoredProcedure [dbo].[obtenerDepRetxIDCajaSucursal2_Estadisticos]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[obtenerDepRetxIDCajaSucursal2_Estadisticos]
	 @opcion				INT,
	 @id_cajaxSucursal		NVARCHAR(100),
	 @fechaInicio			DATE,
	 @fechaFin			    DATE	
AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON
		IF(@opcion = 1)
		BEGIN
			SELECT 
				tr.Id_Retiro as id_movimiento,
				tr.Motivo as motivo,
				tr.Monto as monto,
				cuc.Cu_User as vendedor,
				vc.IDStatus,
				tr.FecIns
			FROM 
				[dbo].[vtbl_Retiros_Estadisticos] as tr
	            INNER JOIN [dbo].[vtbl_VentaCajas_Estadisticos] as vc ON vc.IDGenerico = tr.Id_Retiro
				INNER JOIN tbl_CatUsuarioCuenta as cuc ON  vc.usuins = cuc.Id_U
				INNER JOIN [dbo].[vtbl_CajaXSucursal_Estadisticos] as cs ON vc.IDCajaXSucursal = cs.id_cajaXSucursal
			WHERE
			cs.id_caja = @id_cajaxSucursal	 			
			AND CONVERT(DATE,cs.fecha_inicio) BETWEEN @fechaInicio AND @fechaFin
			AND tr.Activo = 1 
			AND vc.IDStatus = 8
			AND vc.Activo = 1
			ORDER BY tr.FecIns
		END

		IF(@opcion = 2)
		BEGIN
			SELECT 
				td.Id_Deposito as id_movimiento,
				td.Motivo as motivo,
				td.Monto as monto,
				cuc.Cu_User as vendedor,
				td.FecIns
			FROM 
				[dbo].[vtbl_Depositos_Estadisticos] as td	
				INNER JOIN [dbo].[vtbl_VentaCajas_Estadisticos] as vc ON vc.IDGenerico = td.Id_Deposito
				INNER JOIN tbl_CatUsuarioCuenta as cuc ON vc.usuins = cuc.Id_U
				INNER JOIN [dbo].[vtbl_CajaXSucursal_Estadisticos] as cs ON vc.IDCajaXSucursal = cs.id_cajaXSucursal
			WHERE 
			cs.id_caja = @id_cajaxSucursal	 			
			AND CONVERT(DATE,cs.fecha_inicio) BETWEEN @fechaInicio AND @fechaFin				
			AND td.Activo = 1 
			AND vc.IDStatus = 7
			AND vc.Activo = 1				
			ORDER BY td.FecIns	
		END

	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END



















GO
/****** Object:  StoredProcedure [dbo].[obtenerMaletasViaje]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER PROCEDURE [dbo].[obtenerMaletasViaje]
	@IDVIAJE	NVARCHAR(100),
	@FECHA      DATE,
	@HORA       NVARCHAR(8),
	@IDSUCURSAL NVARCHAR(100)

AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON

		SELECT  
		   id_maleta
		  ,tbl_Boletos.NombrePersona
		  ,tbl_CatMaletas.id_boleto
		  ,folioMaleta
		  ,descripcion
		  ,precio
		  ,numeroMaletas
		FROM tbl_CatMaletas INNER JOIN tbl_Boletos
		ON tbl_CatMaletas.id_boleto = tbl_Boletos.id_boleto
		WHERE tbl_CatMaletas.Activo = 1 AND tbl_Boletos.Activo = 1 -- AND tbl_Boletos.id_viaje = @IDVIAJE AND tbl_Boletos.fecha_salida = @FECHA AND tbl_Boletos.hora_salida = @HORA


	END TRY
	BEGIN CATCH 
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END




















GO
/****** Object:  StoredProcedure [dbo].[obtenerMaletasViaje_Estadisticos]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





ALTER PROCEDURE [dbo].[obtenerMaletasViaje_Estadisticos]
	@IDVIAJE	NVARCHAR(100),
	@FECHA      DATE,
	@HORA       NVARCHAR(8),
	@IDSUCURSAL NVARCHAR(100)

AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON

		SELECT  
		   id_maleta
		  ,[dbo].[vtbl_Boletos_Estadisticos].NombrePersona
		  ,[dbo].[vtbl_CatMaletas_Estadisticos].id_boleto
		  ,folioMaleta
		  ,descripcion
		  ,precio
		  ,numeroMaletas
		FROM [dbo].[vtbl_CatMaletas_Estadisticos] INNER JOIN [dbo].[vtbl_Boletos_Estadisticos]
		ON [dbo].[vtbl_CatMaletas_Estadisticos].id_boleto = [dbo].[vtbl_Boletos_Estadisticos].id_boleto
		WHERE [dbo].[vtbl_CatMaletas_Estadisticos].Activo = 1 AND [dbo].[vtbl_Boletos_Estadisticos].Activo = 1 -- AND tbl_Boletos.id_viaje = @IDVIAJE AND tbl_Boletos.fecha_salida = @FECHA AND tbl_Boletos.hora_salida = @HORA


	END TRY
	BEGIN CATCH 
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END






















GO
/****** Object:  StoredProcedure [dbo].[obtenerMaletasxIDCaja]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER PROCEDURE [dbo].[obtenerMaletasxIDCaja]
	@id_cajaXSucursal	NVARCHAR(100),
	@fecha			DATE

AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON

		SELECT 
		   id_maleta
		  ,tcm.id_boleto
		  ,tb.NombrePersona
		  ,folioMaleta
		  ,descripcion
		  ,precio
		  ,numeroMaletas
		  ,cuc.Cu_User as vendedor
		FROM 
		    tbl_CatMaletas as tcm
			INNER JOIN tbl_VentaCajas as tvc ON tvc.IDGenerico = tcm.id_maleta
			INNER JOIN tbl_CatUsuarioCuenta as cuc ON tvc.usuins = cuc.Id_U
			INNER JOIN tbl_Boletos as tb ON tcm.id_boleto = tb.id_boleto
			
		WHERE 
		tvc.IDCajaXSucursal = @id_cajaXSucursal AND tvc.IDStatus = 9 AND tvc.Activo = 1 AND tcm.activo = 1
		ORDER BY tcm.fecins	

			

	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END




















GO
/****** Object:  StoredProcedure [dbo].[obtenerMaletasxIDCaja_Estadisticos]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




ALTER PROCEDURE [dbo].[obtenerMaletasxIDCaja_Estadisticos]
	@id_cajaXSucursal	NVARCHAR(100),
	@fecha			DATE

AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON

		SELECT 
		   id_maleta
		  ,tcm.id_boleto
		  ,tb.NombrePersona
		  ,folioMaleta
		  ,descripcion
		  ,precio
		  ,numeroMaletas
		  ,cuc.Cu_User as vendedor
		  ,tcm.fecins	
		FROM 
		    [dbo].[vtbl_CatMaletas_Estadisticos] as tcm
			INNER JOIN [dbo].[vtbl_VentaCajas_Estadisticos] as tvc ON tvc.IDGenerico = tcm.id_maleta
			INNER JOIN tbl_CatUsuarioCuenta as cuc ON tvc.usuins = cuc.Id_U
			INNER JOIN [dbo].[vtbl_Boletos_Estadisticos] as tb ON tcm.id_boleto = tb.id_boleto
			
		WHERE 
		tvc.IDCajaXSucursal = @id_cajaXSucursal AND tvc.IDStatus = 9 AND tvc.Activo = 1 AND tcm.activo = 1
		ORDER BY tcm.fecins	

			

	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END





















GO
/****** Object:  StoredProcedure [dbo].[obtenerMaletasxIDCaja2]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER PROCEDURE [dbo].[obtenerMaletasxIDCaja2]
	@id_cajaXSucursal	NVARCHAR(100),
	@fechaInicio			DATE,
	@fechaFin			    DATE

AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON

		SELECT 
		   id_maleta
		  ,tcm.id_boleto
		  ,tb.NombrePersona
		  ,folioMaleta
		  ,descripcion
		  ,precio
		  ,numeroMaletas
		  ,cuc.Cu_User as vendedor
		FROM 
		    tbl_CatMaletas as tcm
			INNER JOIN tbl_VentaCajas as tvc ON tvc.IDGenerico = tcm.id_maleta
			INNER JOIN tbl_CatUsuarioCuenta as cuc ON tvc.usuins = cuc.Id_U
			INNER JOIN tbl_Boletos as tb ON tcm.id_boleto = tb.id_boleto
		    INNER JOIN tbl_CajaXSucursal as cs ON tvc.IDCajaXSucursal = cs.id_cajaXSucursal
		WHERE 
			cs.id_caja = @id_cajaxSucursal	 			
			AND CONVERT(DATE,cs.fecha_inicio) BETWEEN @fechaInicio AND @fechaFin
			AND tvc.IDStatus = 9 AND tvc.Activo = 1 AND tcm.activo = 1
		ORDER BY tcm.fecins	

			
	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END




















GO
/****** Object:  StoredProcedure [dbo].[obtenerMaletasxIDCaja2_Estadisticos]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




ALTER PROCEDURE [dbo].[obtenerMaletasxIDCaja2_Estadisticos]
	@id_cajaXSucursal	NVARCHAR(100),
	@fechaInicio			DATE,
	@fechaFin			    DATE

AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON

		SELECT 
		   id_maleta
		  ,tcm.id_boleto
		  ,tb.NombrePersona
		  ,folioMaleta
		  ,descripcion
		  ,precio
		  ,numeroMaletas
		  ,cuc.Cu_User as vendedor
		  ,tcm.fecins
		FROM 
		    [dbo].[vtbl_CatMaletas_Estadisticos] as tcm
			INNER JOIN [dbo].[vtbl_VentaCajas_Estadisticos] as tvc ON tvc.IDGenerico = tcm.id_maleta
			INNER JOIN tbl_CatUsuarioCuenta as cuc ON tvc.usuins = cuc.Id_U
			INNER JOIN [dbo].[vtbl_Boletos_Estadisticos] as tb ON tcm.id_boleto = tb.id_boleto
		    INNER JOIN [dbo].[vtbl_CajaXSucursal_Estadisticos] as cs ON tvc.IDCajaXSucursal = cs.id_cajaXSucursal
		WHERE 
			cs.id_caja = @id_cajaxSucursal	 			
			AND CONVERT(DATE,cs.fecha_inicio) BETWEEN @fechaInicio AND @fechaFin
			AND tvc.IDStatus = 9 AND tvc.Activo = 1 AND tcm.activo = 1
		ORDER BY tcm.fecins	

			
	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END





















GO
/****** Object:  StoredProcedure [dbo].[obtenerMaximoDescuentoLinea]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[obtenerMaximoDescuentoLinea]


AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON

		  SELECT 
			   id_tipoCamion 
			  ,tipoCamion
			  ,maximoDescuentoLinea
		  FROM tbl_CatTipoCamion

	END TRY
	BEGIN CATCH 
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END





















GO
/****** Object:  StoredProcedure [dbo].[obtenerReservacionesxIDCaja]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER PROCEDURE [dbo].[obtenerReservacionesxIDCaja]
	@id_cajaXSucursal	NVARCHAR(100),
	@fecha			DATE

AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON

		SELECT 
			tb.CodigoBarra,
			tb.NombrePersona,
			tb.asiento,
			ctO.nombre AS terminalOrigen,
			ctD.nombre AS  terminalDestino,
			tb.costo,
			0.0 as pago1,--vd.pago1,
			0.0 as pago2,--vd.pago2,
			cuc.Cu_User AS vendedor
		FROM 
			tbl_Boletos AS tb
		    INNER JOIN tbl_VentaDetalle AS vd ON vd.id_boleto = tb.id_boleto
			INNER JOIN tbl_CatViajes AS cv ON tb.id_viaje = cv.id_identificador
			INNER JOIN tbl_OrdenRuta AS orO ON cv.id_ruta = orO.id_ruta
			INNER JOIN tbl_CatTerminales AS ctO ON ctO.id_terminal = orO.id_terminal AND orO.orden = tb.OrdenOrigenTerminal
			INNER JOIN tbl_OrdenRuta AS orD ON cv.id_ruta = orD.id_ruta
			INNER JOIN tbl_CatTerminales AS ctD ON ctD.id_terminal = orD.id_terminal AND orD.orden = tb.OrdenDestinoTerminal
			INNER JOIN tbl_VentaCajas AS tvc ON tvc.IDGenerico = vd.id_ventadetalle
			INNER JOIN tbl_CatUsuarioCuenta AS cuc ON tvc.usuins = cuc.Id_U		
		WHERE 
			tvc.IDCajaXSucursal = @id_cajaXSucursal AND tvc.IDStatus = 2 AND tvc.activo = 1	
		ORDER BY tb.fecins

			

	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END




















GO
/****** Object:  StoredProcedure [dbo].[obtenerReservacionesxIDCaja_Estadisticos]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




ALTER PROCEDURE [dbo].[obtenerReservacionesxIDCaja_Estadisticos]
	@id_cajaXSucursal	NVARCHAR(100),
	@fecha			DATE

AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON

		SELECT 
			tb.CodigoBarra,
			tb.NombrePersona,
			tb.asiento,
			ctO.nombre AS terminalOrigen,
			ctD.nombre AS  terminalDestino,
			tb.costo,
			0.0 as pago1,--vd.pago1,
			0.0 as pago2,--vd.pago2,
			cuc.Cu_User AS vendedor,
			tb.fecins AS fecins
		FROM 
			[dbo].[vtbl_Boletos_Estadisticos] AS tb
		    INNER JOIN [dbo].[vtbl_VentaDetalle_Estadisticos] AS vd ON vd.id_boleto = tb.id_boleto
			INNER JOIN tbl_CatViajes AS cv ON tb.id_viaje = cv.id_identificador
			INNER JOIN tbl_OrdenRuta AS orO ON cv.id_ruta = orO.id_ruta
			INNER JOIN tbl_CatTerminales AS ctO ON ctO.id_terminal = orO.id_terminal AND orO.orden = tb.OrdenOrigenTerminal
			INNER JOIN tbl_OrdenRuta AS orD ON cv.id_ruta = orD.id_ruta
			INNER JOIN tbl_CatTerminales AS ctD ON ctD.id_terminal = orD.id_terminal AND orD.orden = tb.OrdenDestinoTerminal
			INNER JOIN [dbo].[vtbl_VentaCajas_Estadisticos] AS tvc ON tvc.IDGenerico = vd.id_ventadetalle
			INNER JOIN tbl_CatUsuarioCuenta AS cuc ON tvc.usuins = cuc.Id_U		
		WHERE 
			tvc.IDCajaXSucursal = @id_cajaXSucursal AND tvc.IDStatus = 2 AND tvc.activo = 1			
		ORDER BY tb.fecins

			

	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END





















GO
/****** Object:  StoredProcedure [dbo].[obtenerReservacionesxIDCaja2]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[obtenerReservacionesxIDCaja2]
	@id_cajaXSucursal	NVARCHAR(100),
	@fechaInicio			DATE,
	@fechaFin			    DATE

AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON

		SELECT 
			tb.CodigoBarra,
			tb.NombrePersona,
			tb.asiento,
			ctO.nombre AS terminalOrigen,
			ctD.nombre AS  terminalDestino,
			tb.costo,
			0.0 as pago1,--vd.pago1,
			0.0 as pago2,--vd.pago2,
			cuc.Cu_User AS vendedor
		FROM 
			tbl_Boletos AS tb
		    INNER JOIN tbl_VentaDetalle AS vd ON vd.id_boleto = tb.id_boleto
			INNER JOIN tbl_CatViajes AS cv ON tb.id_viaje = cv.id_identificador
			INNER JOIN tbl_OrdenRuta AS orO ON cv.id_ruta = orO.id_ruta
			INNER JOIN tbl_CatTerminales AS ctO ON ctO.id_terminal = orO.id_terminal AND orO.orden = tb.OrdenOrigenTerminal
			INNER JOIN tbl_OrdenRuta AS orD ON cv.id_ruta = orD.id_ruta
			INNER JOIN tbl_CatTerminales AS ctD ON ctD.id_terminal = orD.id_terminal AND orD.orden = tb.OrdenDestinoTerminal
			INNER JOIN tbl_VentaCajas AS tvc ON tvc.IDGenerico = vd.id_ventadetalle
			INNER JOIN tbl_CatUsuarioCuenta AS cuc ON tvc.usuins = cuc.Id_U
			INNER JOIN tbl_CajaXSucursal as cs ON tvc.IDCajaXSucursal = cs.id_cajaXSucursal	
		WHERE 
		 cs.id_caja = @id_cajaxSucursal	 			
		 AND CONVERT(DATE,cs.fecha_inicio) BETWEEN @fechaInicio AND @fechaFin
		 AND tvc.IDStatus = 2 AND tvc.activo = 1	
	    ORDER BY tb.fecins
			
	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END



















GO
/****** Object:  StoredProcedure [dbo].[obtenerReservacionesxIDCaja2_Estadisticos]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER PROCEDURE [dbo].[obtenerReservacionesxIDCaja2_Estadisticos]
	@id_cajaXSucursal	NVARCHAR(100),
	@fechaInicio			DATE,
	@fechaFin			    DATE

AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON

		SELECT 
			tb.CodigoBarra,
			tb.NombrePersona,
			tb.asiento,
			ctO.nombre AS terminalOrigen,
			ctD.nombre AS  terminalDestino,
			tb.costo,
			0.0 as pago1,--vd.pago1,
			0.0 as pago2,--vd.pago2,
			cuc.Cu_User AS vendedor,
			tb.fecins
		FROM 
			[dbo].[vtbl_Boletos_Estadisticos] AS tb
		    INNER JOIN [dbo].[vtbl_VentaDetalle_Estadisticos] AS vd ON vd.id_boleto = tb.id_boleto
			INNER JOIN tbl_CatViajes AS cv ON tb.id_viaje = cv.id_identificador
			INNER JOIN tbl_OrdenRuta AS orO ON cv.id_ruta = orO.id_ruta
			INNER JOIN tbl_CatTerminales AS ctO ON ctO.id_terminal = orO.id_terminal AND orO.orden = tb.OrdenOrigenTerminal
			INNER JOIN tbl_OrdenRuta AS orD ON cv.id_ruta = orD.id_ruta
			INNER JOIN tbl_CatTerminales AS ctD ON ctD.id_terminal = orD.id_terminal AND orD.orden = tb.OrdenDestinoTerminal
			INNER JOIN [dbo].[vtbl_VentaCajas_Estadisticos] AS tvc ON tvc.IDGenerico = vd.id_ventadetalle
			INNER JOIN tbl_CatUsuarioCuenta AS cuc ON tvc.usuins = cuc.Id_U
			INNER JOIN [dbo].[vtbl_CajaXSucursal_Estadisticos] as cs ON tvc.IDCajaXSucursal = cs.id_cajaXSucursal		
		WHERE 
		 cs.id_caja = @id_cajaxSucursal	 			
		 AND CONVERT(DATE,cs.fecha_inicio) BETWEEN @fechaInicio AND @fechaFin
		 AND tvc.IDStatus = 2 AND tvc.activo = 1	
		ORDER BY tb.fecins
			
	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END




















GO
/****** Object:  StoredProcedure [dbo].[obtenerSucursalUsuario]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[obtenerSucursalUsuario]
		@Cu_User NVARCHAR(15)
AS
BEGIN
	BEGIN TRY		
		SET NOCOUNT ON

		DECLARE @Id_U NVARCHAR(100)
		
	    IF((SELECT COUNT(*) FROM tbl_CatUsuarioCuenta WHERE Cu_User = @Cu_User) > 0) 
		BEGIN
            SELECT tbl_CatUsuarioXSuc.id_sucursal FROM tbl_CatUsuarioCuenta JOIN tbl_CatUsuarioXSuc ON tbl_CatUsuarioCuenta.Id_U = tbl_CatUsuarioXSuc.Id_U WHERE Cu_User = @Cu_User 
		END
		ELSE 
		BEGIN
		   SELECT ' '
		END

	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------
	END CATCH
END

















GO
/****** Object:  StoredProcedure [dbo].[obtenerTotalesCajasFecha]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[obtenerTotalesCajasFecha]
	@fecha			DATE
	

AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON

		SELECT 
			tbc.id_caja,			
			U_Nombre + ' ' + U_Apellidop + ' ' + hora_inicio as caja,
			[dbo].[CajaTotal](tbcs.id_cajaXSucursal) as total
		FROM 
			tbl_CatCajas as tbc
			JOIN tbl_CajaXSucursal as tbcs ON tbc.id_caja = tbcs.id_caja
			JOIN tbl_CatUsuario as cu ON tbcs.id_cajero = cu.Id_U
		WHERE 
			tbc.activo = 1
			AND CONVERT(DATE, tbcs.fecha_inicio) = CONVERT(DATE, @fecha)

	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END



















GO
/****** Object:  StoredProcedure [dbo].[obtenerTotalesCajasFecha_Estadisticos]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




ALTER PROCEDURE [dbo].[obtenerTotalesCajasFecha_Estadisticos]
	@fecha			DATE
	

AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON

		SELECT 
			tbc.id_caja,			
			U_Nombre + ' ' + U_Apellidop + ' ' + hora_inicio as caja,
			[dbo].[CajaTotal](tbcs.id_cajaXSucursal) as total
		FROM 
			tbl_CatCajas as tbc
			JOIN [dbo].[vtbl_CajaXSucursal_Estadisticos] as tbcs ON tbc.id_caja = tbcs.id_caja
			JOIN tbl_CatUsuario as cu ON tbcs.id_cajero = cu.Id_U
		WHERE 
			tbc.activo = 1
			AND CONVERT(DATE, tbcs.fecha_inicio) = CONVERT(DATE, @fecha)

	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END





















GO
/****** Object:  StoredProcedure [dbo].[obtenerTransferenciaxIDCaja]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[obtenerTransferenciaxIDCaja]
	@id_cajaXSucursal	NVARCHAR(100),
	@fecha				DATE

AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON

		SELECT 
			tb.CodigoBarra,
			tbt.CodigoBarra as CodigoBarraTransferencia,
			tb.NombrePersona,
			tb.asiento,
			ctO.nombre AS terminalOrigen,
			ctD.nombre AS  terminalDestino,
			tb.costo,
			vd.costo,
			vd.pago1,
			vd.pago2,
			cuc.Cu_User AS vendedor
		FROM 
			tbl_Boletos AS tb
		    INNER JOIN tbl_VentaDetalle AS vd ON vd.id_boleto = tb.id_boleto
			INNER JOIN tbl_CatViajes AS cv ON tb.id_viaje = cv.id_identificador
			INNER JOIN tbl_OrdenRuta AS orO ON cv.id_ruta = orO.id_ruta
			INNER JOIN tbl_CatTerminales AS ctO ON ctO.id_terminal = orO.id_terminal AND orO.orden = tb.OrdenOrigenTerminal
			INNER JOIN tbl_OrdenRuta AS orD ON cv.id_ruta = orD.id_ruta
			INNER JOIN tbl_CatTerminales AS ctD ON ctD.id_terminal = orD.id_terminal AND orD.orden = tb.OrdenDestinoTerminal
			INNER JOIN tbl_VentaCajas AS tvc ON tvc.IDGenerico = vd.id_ventadetalle
			INNER JOIN tbl_CatUsuarioCuenta AS cuc ON tvc.usuins = cuc.Id_U	
			INNER JOIN tbl_Boletos AS tbt ON tbt.id_boleto = tb.id_boletoTransferencia
		WHERE 
			tvc.IDCajaXSucursal = @id_cajaXSucursal AND tvc.IDStatus = 5 AND tvc.activo = 1
		ORDER BY tb.fecins	

			

	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END



















GO
/****** Object:  StoredProcedure [dbo].[obtenerTransferenciaxIDCaja_Estadisticos]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




ALTER PROCEDURE [dbo].[obtenerTransferenciaxIDCaja_Estadisticos]
	@id_cajaXSucursal	NVARCHAR(100),
	@fecha				DATE

AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON

		SELECT 
			tb.CodigoBarra,
			tbt.CodigoBarra as CodigoBarraTransferencia,
			tb.NombrePersona,
			tb.asiento,
			ctO.nombre AS terminalOrigen,
			ctD.nombre AS  terminalDestino,
			tb.costo,
			vd.costo,
			vd.pago1,
			vd.pago2,
			cuc.Cu_User AS vendedor,
			tb.fecins	
		FROM 
			[dbo].[vtbl_Boletos_Estadisticos] AS tb
		    INNER JOIN [dbo].[vtbl_VentaDetalle_Estadisticos] AS vd ON vd.id_boleto = tb.id_boleto
			INNER JOIN tbl_CatViajes AS cv ON tb.id_viaje = cv.id_identificador
			INNER JOIN tbl_OrdenRuta AS orO ON cv.id_ruta = orO.id_ruta
			INNER JOIN tbl_CatTerminales AS ctO ON ctO.id_terminal = orO.id_terminal AND orO.orden = tb.OrdenOrigenTerminal
			INNER JOIN tbl_OrdenRuta AS orD ON cv.id_ruta = orD.id_ruta
			INNER JOIN tbl_CatTerminales AS ctD ON ctD.id_terminal = orD.id_terminal AND orD.orden = tb.OrdenDestinoTerminal
			INNER JOIN [dbo].[vtbl_VentaCajas_Estadisticos] AS tvc ON tvc.IDGenerico = vd.id_ventadetalle
			INNER JOIN tbl_CatUsuarioCuenta AS cuc ON tvc.usuins = cuc.Id_U	
			INNER JOIN [dbo].[vtbl_Boletos_Estadisticos] AS tbt ON tbt.id_boleto = tb.id_boletoTransferencia
		WHERE 
			tvc.IDCajaXSucursal = @id_cajaXSucursal AND tvc.IDStatus = 5 AND tvc.activo = 1
		ORDER BY tb.fecins	

			

	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END





















GO
/****** Object:  StoredProcedure [dbo].[obtenerTransferenciaxIDCaja2]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[obtenerTransferenciaxIDCaja2]
	@id_cajaXSucursal	    NVARCHAR(100),
	@fechaInicio			DATE,
	@fechaFin			    DATE

AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON

	     SELECT 
			tb.CodigoBarra,
			tbt.CodigoBarra as CodigoBarraTransferencia,
			tb.NombrePersona,
			tb.asiento,
			ctO.nombre AS terminalOrigen,
			ctD.nombre AS  terminalDestino,
			tb.costo,
			vd.costo,
			vd.pago1,
			vd.pago2,
			cuc.Cu_User AS vendedor
		FROM 
			tbl_Boletos AS tb
		    INNER JOIN tbl_VentaDetalle AS vd ON vd.id_boleto = tb.id_boleto
			INNER JOIN tbl_CatViajes AS cv ON tb.id_viaje = cv.id_identificador
			INNER JOIN tbl_OrdenRuta AS orO ON cv.id_ruta = orO.id_ruta
			INNER JOIN tbl_CatTerminales AS ctO ON ctO.id_terminal = orO.id_terminal AND orO.orden = tb.OrdenOrigenTerminal
			INNER JOIN tbl_OrdenRuta AS orD ON cv.id_ruta = orD.id_ruta
			INNER JOIN tbl_CatTerminales AS ctD ON ctD.id_terminal = orD.id_terminal AND orD.orden = tb.OrdenDestinoTerminal
			INNER JOIN tbl_VentaCajas AS tvc ON tvc.IDGenerico = vd.id_ventadetalle
			INNER JOIN tbl_CatUsuarioCuenta AS cuc ON tvc.usuins = cuc.Id_U	
			INNER JOIN tbl_Boletos AS tbt ON tbt.id_boleto = tb.id_boletoTransferencia
			INNER JOIN tbl_CajaXSucursal as cs ON tvc.IDCajaXSucursal = cs.id_cajaXSucursal	
		WHERE 
		cs.id_caja = @id_cajaxSucursal	 			
		AND CONVERT(DATE,cs.fecha_inicio) BETWEEN @fechaInicio AND @fechaFin
		AND tvc.IDStatus = 5 AND tvc.activo = 1
		ORDER BY tb.fecins	

			
	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END



















GO
/****** Object:  StoredProcedure [dbo].[obtenerTransferenciaxIDCaja2_Estadisticos]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




ALTER PROCEDURE [dbo].[obtenerTransferenciaxIDCaja2_Estadisticos]
	@id_cajaXSucursal	    NVARCHAR(100),
	@fechaInicio			DATE,
	@fechaFin			    DATE

AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON

	     SELECT 
			tb.CodigoBarra,
			tbt.CodigoBarra as CodigoBarraTransferencia,
			tb.NombrePersona,
			tb.asiento,
			ctO.nombre AS terminalOrigen,
			ctD.nombre AS  terminalDestino,
			tb.costo,
			vd.costo,
			vd.pago1,
			vd.pago2,
			cuc.Cu_User AS vendedor,
			tb.fecins
		FROM 
			[dbo].[vtbl_Boletos_Estadisticos] AS tb
		    INNER JOIN [dbo].[vtbl_VentaDetalle_Estadisticos] AS vd ON vd.id_boleto = tb.id_boleto
			INNER JOIN tbl_CatViajes AS cv ON tb.id_viaje = cv.id_identificador
			INNER JOIN tbl_OrdenRuta AS orO ON cv.id_ruta = orO.id_ruta
			INNER JOIN tbl_CatTerminales AS ctO ON ctO.id_terminal = orO.id_terminal AND orO.orden = tb.OrdenOrigenTerminal
			INNER JOIN tbl_OrdenRuta AS orD ON cv.id_ruta = orD.id_ruta
			INNER JOIN tbl_CatTerminales AS ctD ON ctD.id_terminal = orD.id_terminal AND orD.orden = tb.OrdenDestinoTerminal
			INNER JOIN [dbo].[vtbl_VentaCajas_Estadisticos] AS tvc ON tvc.IDGenerico = vd.id_ventadetalle
			INNER JOIN tbl_CatUsuarioCuenta AS cuc ON tvc.usuins = cuc.Id_U	
			INNER JOIN [dbo].[vtbl_Boletos_Estadisticos] AS tbt ON tbt.id_boleto = tb.id_boletoTransferencia
			INNER JOIN [dbo].[vtbl_CajaXSucursal_Estadisticos] as cs ON tvc.IDCajaXSucursal = cs.id_cajaXSucursal	
		WHERE 
		cs.id_caja = @id_cajaxSucursal	 			
		AND CONVERT(DATE,cs.fecha_inicio) BETWEEN @fechaInicio AND @fechaFin
		AND tvc.IDStatus = 5 AND tvc.activo = 1	
		ORDER BY tb.fecins	

			
	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END





















GO
/****** Object:  StoredProcedure [dbo].[obtenerVentasxIDCaja]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[obtenerVentasxIDCaja]
	@id_cajaXSucursal	NVARCHAR(100),
	@fecha				DATE

AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON

		SELECT 
			tb.CodigoBarra,
			tb.NombrePersona,
			tb.asiento,
			ctO.nombre AS terminalOrigen,
			ctD.nombre AS  terminalDestino,
			tb.costo,
			vd.pago1,
			vd.pago2,
			cuc.Cu_User AS vendedor
		FROM 
			tbl_Boletos AS tb
		    INNER JOIN tbl_VentaDetalle AS vd ON vd.id_boleto = tb.id_boleto
			INNER JOIN tbl_CatViajes AS cv ON tb.id_viaje = cv.id_identificador
			INNER JOIN tbl_OrdenRuta AS orO ON cv.id_ruta = orO.id_ruta
			INNER JOIN tbl_CatTerminales AS ctO ON ctO.id_terminal = orO.id_terminal AND orO.orden = tb.OrdenOrigenTerminal
			INNER JOIN tbl_OrdenRuta AS orD ON cv.id_ruta = orD.id_ruta
			INNER JOIN tbl_CatTerminales AS ctD ON ctD.id_terminal = orD.id_terminal AND orD.orden = tb.OrdenDestinoTerminal
			INNER JOIN tbl_VentaCajas AS tvc ON tvc.IDGenerico = vd.id_ventadetalle
			INNER JOIN tbl_CatUsuarioCuenta AS cuc ON tvc.usuins = cuc.Id_U
		WHERE 
			tvc.IDCajaXSucursal = @id_cajaXSucursal AND tvc.IDStatus = 1 AND tvc.activo = 1
		ORDER BY tb.fecins	

		
	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END























GO
/****** Object:  StoredProcedure [dbo].[obtenerVentasxIDCaja_Estadisticos]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[obtenerVentasxIDCaja_Estadisticos]
	@id_cajaXSucursal	NVARCHAR(100),
	@fecha				DATE

AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON

		SELECT 
			tb.CodigoBarra,
			tb.NombrePersona,
			tb.asiento,
			ctO.nombre AS terminalOrigen,
			ctD.nombre AS  terminalDestino,
			tb.costo,
			vd.pago1,
			vd.pago2,
			cuc.Cu_User AS vendedor,
			tb.fecins 			
		FROM 
			[dbo].[vtbl_Boletos_Estadisticos] AS tb
		    INNER JOIN [dbo].[vtbl_VentaDetalle_Estadisticos] AS vd ON vd.id_boleto = tb.id_boleto
			INNER JOIN tbl_CatViajes AS cv ON tb.id_viaje = cv.id_identificador
			INNER JOIN tbl_OrdenRuta AS orO ON cv.id_ruta = orO.id_ruta
			INNER JOIN tbl_CatTerminales AS ctO ON ctO.id_terminal = orO.id_terminal AND orO.orden = tb.OrdenOrigenTerminal
			INNER JOIN tbl_OrdenRuta AS orD ON cv.id_ruta = orD.id_ruta
			INNER JOIN tbl_CatTerminales AS ctD ON ctD.id_terminal = orD.id_terminal AND orD.orden = tb.OrdenDestinoTerminal
			INNER JOIN [dbo].[vtbl_VentaCajas_Estadisticos] AS tvc ON tvc.IDGenerico = vd.id_ventadetalle
			INNER JOIN tbl_CatUsuarioCuenta AS cuc ON tvc.usuins = cuc.Id_U
		WHERE 
			tvc.IDCajaXSucursal = @id_cajaXSucursal AND tvc.IDStatus = 1 AND tvc.activo = 1
		ORDER BY tb.fecins	
	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END
























GO
/****** Object:  StoredProcedure [dbo].[obtenerVentasxIDCaja2]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[obtenerVentasxIDCaja2]
	 @id_cajaXSucursal	    NVARCHAR(100),
	 @fechaInicio			DATE,
	 @fechaFin			    DATE

AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON

		SELECT 
			tb.CodigoBarra,
			tb.NombrePersona,
			tb.asiento,
			ctO.nombre AS terminalOrigen,
			ctD.nombre AS  terminalDestino,
			tb.costo,
			vd.pago1,
			vd.pago2,
			cuc.Cu_User AS vendedor
		FROM 
			tbl_Boletos AS tb
		    INNER JOIN tbl_VentaDetalle AS vd ON vd.id_boleto = tb.id_boleto
			INNER JOIN tbl_CatViajes AS cv ON tb.id_viaje = cv.id_identificador
			INNER JOIN tbl_OrdenRuta AS orO ON cv.id_ruta = orO.id_ruta
			INNER JOIN tbl_CatTerminales AS ctO ON ctO.id_terminal = orO.id_terminal AND orO.orden = tb.OrdenOrigenTerminal
			INNER JOIN tbl_OrdenRuta AS orD ON cv.id_ruta = orD.id_ruta
			INNER JOIN tbl_CatTerminales AS ctD ON ctD.id_terminal = orD.id_terminal AND orD.orden = tb.OrdenDestinoTerminal
			INNER JOIN tbl_VentaCajas AS tvc ON tvc.IDGenerico = vd.id_ventadetalle
			INNER JOIN tbl_CatUsuarioCuenta AS cuc ON tvc.usuins = cuc.Id_U
			INNER JOIN tbl_CajaXSucursal as cs ON tvc.IDCajaXSucursal = cs.id_cajaXSucursal
		WHERE 
			 cs.id_caja = @id_cajaxSucursal	 			
			 AND CONVERT(DATE,cs.fecha_inicio) BETWEEN @fechaInicio AND @fechaFin
			 AND tvc.IDStatus = 1 AND tvc.activo = 1
		ORDER BY tb.fecins	

			

	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END



















GO
/****** Object:  StoredProcedure [dbo].[obtenerVentasxIDCaja2_Estadisticos]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER PROCEDURE [dbo].[obtenerVentasxIDCaja2_Estadisticos]
	 @id_cajaXSucursal	    NVARCHAR(100),
	 @fechaInicio			DATE,
	 @fechaFin			    DATE

AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON

		SELECT 
			tb.CodigoBarra,
			tb.NombrePersona,
			tb.asiento,
			ctO.nombre AS terminalOrigen,
			ctD.nombre AS  terminalDestino,
			tb.costo,
			vd.pago1,
			vd.pago2,
			cuc.Cu_User AS vendedor,
			tb.fecins
		FROM 
			[dbo].[vtbl_Boletos_Estadisticos] AS tb
		    INNER JOIN [dbo].[vtbl_VentaDetalle_Estadisticos] AS vd ON vd.id_boleto = tb.id_boleto
			INNER JOIN tbl_CatViajes AS cv ON tb.id_viaje = cv.id_identificador
			INNER JOIN tbl_OrdenRuta AS orO ON cv.id_ruta = orO.id_ruta
			INNER JOIN tbl_CatTerminales AS ctO ON ctO.id_terminal = orO.id_terminal AND orO.orden = tb.OrdenOrigenTerminal
			INNER JOIN tbl_OrdenRuta AS orD ON cv.id_ruta = orD.id_ruta
			INNER JOIN tbl_CatTerminales AS ctD ON ctD.id_terminal = orD.id_terminal AND orD.orden = tb.OrdenDestinoTerminal
			INNER JOIN [dbo].[vtbl_VentaCajas_Estadisticos] AS tvc ON tvc.IDGenerico = vd.id_ventadetalle
			INNER JOIN tbl_CatUsuarioCuenta AS cuc ON tvc.usuins = cuc.Id_U
			INNER JOIN [dbo].[vtbl_CajaXSucursal_Estadisticos] as cs ON tvc.IDCajaXSucursal = cs.id_cajaXSucursal
		WHERE 
			 cs.id_caja = @id_cajaxSucursal	 			
			 AND CONVERT(DATE,cs.fecha_inicio) BETWEEN @fechaInicio AND @fechaFin
			 AND tvc.IDStatus = 1 AND tvc.activo = 1
		ORDER BY tb.fecins	

			

	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END




















GO
/****** Object:  StoredProcedure [dbo].[orden_rutas_sp]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[orden_rutas_sp]
	 @opcion			INT	
	,@id_ruta			NVARCHAR(100)
	,@usuario			NVARCHAR(100)
AS
BEGIN	
	BEGIN TRY
		DECLARE @fecha		DATETIME
		DECLARE @nsubrutas	INT
		DECLARE @indice		INT
		DECLARE @id_terminal	NVARCHAR(100)

		SET @fecha = dbo.[fnGetNewDate]()		
		SET @nsubrutas = (SELECT COUNT(id_ruta) FROM tbl_CatTerminalesXRuta WHERE id_ruta = @id_ruta AND id_tipoTerminal = 2 AND activo = 1)
		SET @indice = 1

		--Eliminar el orden previo que pueda existir
		DELETE FROM tbl_OrdenRuta WHERE id_ruta = @id_ruta
		
		--Recorrer ruta por subruta
		IF @nsubrutas = 0
		BEGIN
			SELECT @id_terminal = id_terminalSalida FROM tbl_CatTerminalesXRuta WHERE id_ruta = @id_ruta and id_tipoTerminal = 1 AND activo = 1
			EXEC abc_OrdenRuta 1, @id_ruta, @id_terminal, 1, @usuario
			SELECT @id_terminal = id_terminalDestino FROM tbl_CatTerminalesXRuta WHERE id_ruta = @id_ruta and id_tipoTerminal = 1 AND activo = 1
			EXEC abc_OrdenRuta 1, @id_ruta, @id_terminal, 2, @usuario
		END
		ELSE
		BEGIN			
			WHILE(@indice <= @nsubrutas)
			BEGIN
				SELECT @id_terminal = id_terminalSalida FROM tbl_CatTerminalesXRuta WHERE id_ruta = @id_ruta AND indice = @indice AND id_tipoTerminal = 2 AND activo = 1
				EXEC abc_OrdenRuta 1, @id_ruta, @id_terminal, @indice, @usuario

				IF @indice = @nsubrutas
				BEGIN
					SELECT @id_terminal = id_terminalDestino FROM tbl_CatTerminalesXRuta WHERE id_ruta = @id_ruta AND indice = @indice AND id_tipoTerminal = 2
					SET @indice = @indice + 1
					EXEC abc_OrdenRuta 1, @id_ruta, @id_terminal, @indice, @usuario
				END

				SET @indice = @indice + 1
			END
		END
	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------
	END CATCH
END
















GO
/****** Object:  StoredProcedure [dbo].[PorcentajeMonedeor_Actualizar_sp]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER PROCEDURE [dbo].[PorcentajeMonedeor_Actualizar_sp]
           @PORCENTAJEMONEDERO   MONEY,
		   @MONTOCANCELACION     MONEY,
		   @USUARIO              NVARCHAR(100) 
AS
BEGIN
	BEGIN TRY

		SET NOCOUNT ON


	 UPDATE tbl_CatSucursales
	 SET 
	    porcentaje_puntos = @PORCENTAJEMONEDERO,
		monto_cancelacion = @MONTOCANCELACION,
		usuupd = @USUARIO

	 SELECT 1
 
			
	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END

































GO
/****** Object:  StoredProcedure [dbo].[RespaldoMensualBoletos]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[RespaldoMensualBoletos] --- EXEC  RespaldoMensualBoletos CONVERT(DATE, '01/01/2016', 103), CONVERT(DATE, '31/01/2016', 103) ---- Format  dd/mm/yyyy 
		@FECINS_INICIO   DATE,
		@FECINS_FIN		 DATE
AS
BEGIN	
	BEGIN TRANSACTION
	BEGIN TRY	
		SET NOCOUNT ON
		
		--- tbl_VentaCajas
		INSERT INTO tbl_VentaCajas_Estadisticos 
		SELECT * FROM tbl_VentaCajas WHERE CONVERT(DATE,fecins) BETWEEN @FECINS_INICIO AND @FECINS_FIN
		DELETE FROM tbl_VentaCajas WHERE CONVERT(DATE,fecins) BETWEEN @FECINS_INICIO AND @FECINS_FIN 

		--- tbl_Boletos
		INSERT INTO tbl_Boletos_Estadisticos 
		SELECT * FROM tbl_Boletos WHERE CONVERT(DATE,fecins) BETWEEN @FECINS_INICIO AND @FECINS_FIN
		DELETE FROM tbl_Boletos WHERE CONVERT(DATE,fecins) BETWEEN @FECINS_INICIO AND @FECINS_FIN

		--- tbl_CatMaletas
		INSERT INTO tbl_CatMaletas_Estadisticos 
		SELECT * FROM tbl_CatMaletas WHERE CONVERT(DATE,fecins) BETWEEN @FECINS_INICIO AND @FECINS_FIN
		DELETE FROM tbl_CatMaletas WHERE CONVERT(DATE,fecins) BETWEEN @FECINS_INICIO AND @FECINS_FIN

		--- tbl_VentaDetalle
		INSERT INTO tbl_VentaDetalle_Estadisticos 
		SELECT * FROM tbl_VentaDetalle WHERE CONVERT(DATE,fecins) BETWEEN @FECINS_INICIO AND @FECINS_FIN
		DELETE FROM tbl_VentaDetalle WHERE CONVERT(DATE,fecins) BETWEEN @FECINS_INICIO AND @FECINS_FIN

		--- tbl_VentaDetalleDescuento
		INSERT INTO tbl_VentaDetalleDescuento_Estadisticos 
		SELECT * FROM tbl_VentaDetalleDescuento WHERE CONVERT(DATE,fecins) BETWEEN @FECINS_INICIO AND @FECINS_FIN
		DELETE FROM tbl_VentaDetalleDescuento WHERE CONVERT(DATE,fecins) BETWEEN @FECINS_INICIO AND @FECINS_FIN

		--- tbl_VentaPagos
		INSERT INTO tbl_VentaPagos_Estadisticos 
		SELECT * FROM tbl_VentaPagos WHERE CONVERT(DATE,fecins) BETWEEN @FECINS_INICIO AND @FECINS_FIN
		DELETE FROM tbl_VentaPagos WHERE CONVERT(DATE,fecins) BETWEEN @FECINS_INICIO AND @FECINS_FIN

		--- tbl_Venta
		INSERT INTO tbl_Venta_Estadisticos 
		SELECT * FROM tbl_Venta WHERE CONVERT(DATE,fecins) BETWEEN @FECINS_INICIO AND @FECINS_FIN
		DELETE FROM tbl_Venta WHERE CONVERT(DATE,fecins) BETWEEN @FECINS_INICIO AND @FECINS_FIN

		--- tbl_EfectivoXCaja
		INSERT INTO tbl_EfectivoXCaja_Estadisticos 
		SELECT * FROM tbl_EfectivoXCaja WHERE CONVERT(DATE,fecins) BETWEEN @FECINS_INICIO AND @FECINS_FIN
		DELETE FROM tbl_EfectivoXCaja WHERE CONVERT(DATE,fecins) BETWEEN @FECINS_INICIO AND @FECINS_FIN

		--- tbl_Retiros
		INSERT INTO tbl_Retiros_Estadisticos 
		SELECT * FROM tbl_Retiros WHERE CONVERT(DATE,fecins) BETWEEN @FECINS_INICIO AND @FECINS_FIN
		DELETE FROM tbl_Retiros WHERE CONVERT(DATE,fecins) BETWEEN @FECINS_INICIO AND @FECINS_FIN

		--- tbl_CajaXSucursal
		INSERT INTO tbl_CajaXSucursal_Estadisticos 
		SELECT * FROM tbl_CajaXSucursal WHERE CONVERT(DATE,fecins) BETWEEN @FECINS_INICIO AND @FECINS_FIN
		DELETE FROM tbl_CajaXSucursal WHERE CONVERT(DATE,fecins) BETWEEN @FECINS_INICIO AND @FECINS_FIN

		--- tbl_Depositos
		INSERT INTO tbl_Depositos_Estadisticos 
		SELECT * FROM tbl_Depositos WHERE CONVERT(DATE,fecins) BETWEEN @FECINS_INICIO AND @FECINS_FIN
		DELETE FROM tbl_Depositos WHERE CONVERT(DATE,fecins) BETWEEN @FECINS_INICIO AND @FECINS_FIN
	
		--- tbl_DatosViajeContratoServicio1
		INSERT INTO tbl_DatosViajeContratoServicio1_Estadisticos
		SELECT 
			   tbl_DatosViajeContratoServicio1.id_prestacionServicios1
			  ,tbl_DatosViajeContratoServicio1.folio
			  ,tbl_DatosViajeContratoServicio1.id_chofer1
			  ,tbl_DatosViajeContratoServicio1.id_chofer2
			  ,tbl_DatosViajeContratoServicio1.autobus
			  ,tbl_DatosViajeContratoServicio1.fecha_salida
			  ,tbl_DatosViajeContratoServicio1.hora_salida
			  ,tbl_DatosViajeContratoServicio1.solicitado_por
			  ,tbl_DatosViajeContratoServicio1.grupo
			  ,tbl_DatosViajeContratoServicio1.servicio
			  ,tbl_DatosViajeContratoServicio1.presentarse_en
			  ,tbl_DatosViajeContratoServicio1.instrucciones
			  ,tbl_DatosViajeContratoServicio1.observaciones
	   FROM tbl_DatosViajeContratoServicio1 JOIN tbl_DatosViaje ON tbl_DatosViajeContratoServicio1.id_prestacionServicios1 = tbl_DatosViaje.id_prestacionServicios1  WHERE CONVERT(DATE,tbl_DatosViaje.fecins) BETWEEN @FECINS_INICIO AND @FECINS_FIN
	   DELETE tbl_DatosViajeContratoServicio1 FROM tbl_DatosViajeContratoServicio1 JOIN tbl_DatosViaje ON tbl_DatosViajeContratoServicio1.id_prestacionServicios1 = tbl_DatosViaje.id_prestacionServicios1 WHERE CONVERT(DATE,tbl_DatosViaje.fecins) BETWEEN @FECINS_INICIO AND @FECINS_FIN
	   
	   
	   --- tbl_DatosViajeContratoServicio2
		INSERT INTO tbl_DatosViajeContratoServicio2_Estadisticos
		SELECT 
			   tbl_DatosViajeContratoServicio2.id_prestacionServicios2
			  ,tbl_DatosViajeContratoServicio2.folio
			  ,tbl_DatosViajeContratoServicio2.solicitado_por
			  ,tbl_DatosViajeContratoServicio2.poliza
			  ,tbl_DatosViajeContratoServicio2.poliza_fecha1
			  ,tbl_DatosViajeContratoServicio2.poliza_fecha2
			  ,tbl_DatosViajeContratoServicio2.credencial_elector
			  ,tbl_DatosViajeContratoServicio2.domicilio
			  ,tbl_DatosViajeContratoServicio2.origen
			  ,tbl_DatosViajeContratoServicio2.destino
			  ,tbl_DatosViajeContratoServicio2.monto_servicio
			  ,tbl_DatosViajeContratoServicio2.monto_servicio_texto
			  ,tbl_DatosViajeContratoServicio2.lugar_salida
			  ,tbl_DatosViajeContratoServicio2.fecha_salida
			  ,tbl_DatosViajeContratoServicio2.hora_salida
			  ,tbl_DatosViajeContratoServicio2.numero_personas
			  ,tbl_DatosViajeContratoServicio2.id_chofer1
			  ,tbl_DatosViajeContratoServicio2.id_chofer2
			  ,tbl_DatosViajeContratoServicio2.numero_placa
			  ,tbl_DatosViajeContratoServicio2.ruta_contratada
			  ,tbl_DatosViajeContratoServicio2.dias_viaje
			  ,tbl_DatosViajeContratoServicio2.dia_hora_salida
	   FROM tbl_DatosViajeContratoServicio2 JOIN tbl_DatosViaje ON tbl_DatosViajeContratoServicio2.id_prestacionServicios2 = tbl_DatosViaje.id_prestacionServicios2  WHERE CONVERT(DATE,tbl_DatosViaje.fecins) BETWEEN @FECINS_INICIO AND @FECINS_FIN
	   DELETE tbl_DatosViajeContratoServicio2 FROM tbl_DatosViajeContratoServicio2 JOIN tbl_DatosViaje ON tbl_DatosViajeContratoServicio2.id_prestacionServicios2 = tbl_DatosViaje.id_prestacionServicios2  WHERE CONVERT(DATE,tbl_DatosViaje.fecins) BETWEEN @FECINS_INICIO AND @FECINS_FIN
 
	   --- tbl_DatosViajeListaPasajeros
		INSERT INTO tbl_DatosViajeListaPasajeros_Estadisticos
		SELECT 
			   tbl_DatosViajeListaPasajeros.id_listapasajeros
			  ,tbl_DatosViajeListaPasajeros.folio
			  ,tbl_DatosViajeListaPasajeros.oficina
			  ,tbl_DatosViajeListaPasajeros.dia
			  ,tbl_DatosViajeListaPasajeros.mes
			  ,tbl_DatosViajeListaPasajeros.año
			  ,tbl_DatosViajeListaPasajeros.carro
			  ,tbl_DatosViajeListaPasajeros.oficinista
			  ,tbl_DatosViajeListaPasajeros.hora_salida
	   FROM tbl_DatosViajeListaPasajeros JOIN tbl_DatosViaje ON tbl_DatosViajeListaPasajeros.id_listapasajeros = tbl_DatosViaje.id_listapasajeros  WHERE CONVERT(DATE,tbl_DatosViaje.fecins) BETWEEN @FECINS_INICIO AND @FECINS_FIN
	   DELETE tbl_DatosViajeListaPasajeros FROM tbl_DatosViajeListaPasajeros JOIN tbl_DatosViaje ON tbl_DatosViajeListaPasajeros.id_listapasajeros = tbl_DatosViaje.id_listapasajeros  WHERE CONVERT(DATE,tbl_DatosViaje.fecins) BETWEEN @FECINS_INICIO AND @FECINS_FIN

	   --- tbl_DatosViaje
		INSERT INTO tbl_DatosViaje_Estadisticos 
		SELECT * FROM tbl_DatosViaje WHERE CONVERT(DATE,fecins) BETWEEN @FECINS_INICIO AND @FECINS_FIN
		DELETE FROM tbl_DatosViaje WHERE CONVERT(DATE,fecins) BETWEEN @FECINS_INICIO AND @FECINS_FIN
		
		COMMIT TRANSACTION			
		
	END TRY
	BEGIN CATCH          
		-- Control de errores          
		ROLLBACK TRANSACTION
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
	END CATCH 
END



































GO
/****** Object:  StoredProcedure [dbo].[Salidas_Consulta_sp]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[Salidas_Consulta_sp]		
             @IDTerminalOrigen     NVARCHAR(100)
			,@IDTerminalDestino    NVARCHAR(100)
			,@FechaBusqueda        DATE

AS
BEGIN
	BEGIN TRY

		SET NOCOUNT ON
		
		SELECT 
			   camion
			  ,terminalOrigen
			  ,fechaOrigenV
			  ,horaOrigenV
			  ,terminalDestino
			  ,fechaDestinoV
			  ,horaDestinoV
			  ,numAsiento
			  ,id_tarifa
			  ,precioNormal1
			  ,precioInfantil1
			  ,precioTerceraEdad1
			  ,precioEspecial1
			  ,precioNormal2
			  ,precioInfantil2
			  ,precioTerceraEdad2
			  ,precioEspecial2
			  ,nombreViaje
			  ,numCamion
			  ,tiempoMinutos
			  ,numPiso
			  ,id_tipoViaje
			  ,id_tipoTerminal
			  ,tipoTerminal
			  ,fechaOrigen
			  ,horaOrigen
			  ,id_viaje
			  ,id_ruta
			  ,ruta
			  ,id_camion
			  ,id_disenioCamion
			  ,id_terminalOrigen
			  ,id_terminalDestino
			  ,id_terminalXruta
			  ,ordenOrigen
			  ,ordenDestino
			  ,activo
			  ,numAsientos
			  ,recorridoViaje
			  ,id_tipoCamion
		FROM vtbl_FechasViaje 
		WHERE id_terminalOrigen = @IDTerminalOrigen 
		AND id_terminalDestino = @IDTerminalDestino 
		AND fechaOrigen = @FechaBusqueda
		AND vtbl_FechasViaje.Activo = 1
		ORDER BY camion


	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END

































GO
/****** Object:  StoredProcedure [dbo].[sp_abcDepositos]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[sp_abcDepositos]
	@Accion				INT,
	@txt_Id_Deposito	NVARCHAR(100),
	@txt_Id_Caja		NVARCHAR(100),
	@txt_Id_Cajero  	NVARCHAR(100),
	@dec_Monto			MONEY,
	@txt_Motivo			NVARCHAR(100),
	@Id_Sucursal        NVARCHAR(100)
AS
BEGIN

	DECLARE @txt_Mensaje	VARCHAR(100)
	DECLARE @bit_UserError	BIT

	DECLARE @Id			NVARCHAR(100)
	DECLARE @FecSys		DATETIME
	
	SET @FecSys = dbo.[fnGetNewDate]()
	
	SET @bit_UserError = 0
	BEGIN TRANSACTION
	
		IF @Accion = 1
		BEGIN
			SET @Id = NEWID()
			
			INSERT INTO tbl_Depositos
				  (Id_Deposito
				   ,id_sucursal
				   ,id_cajaXSucursal
				   ,Id_Cajero
				   ,Monto
				   ,Motivo
				   ,UsuIns
				   ,FecIns
				   ,UsuMod
				   ,FecMod
				   ,Activo)
			VALUES
				   (@Id,
					@Id_Sucursal,
					@txt_Id_Caja,
					@txt_Id_Cajero,
					@dec_Monto,
					@txt_Motivo,
					@txt_Id_Cajero,
					@FecSys,
					@txt_Id_Cajero,
					@FecSys,
					1)

			 INSERT INTO tbl_VentaCajas
			   (IDVentasCajas
			   ,IDCajaXSucursal
			   ,IDStatus
			   ,IDGenerico
			   ,usuins
			   ,fecins
			   ,usuupd
			   ,fecupd
			   ,activo)
			 VALUES
			   (NEWID()
			   ,@txt_Id_Caja
			   ,7
			   ,@Id
			   ,@txt_Id_Cajero
			   ,@FecSys
			   ,@txt_Id_Cajero
			   ,@FecSys
			   ,1)
		END
		
		If @Accion = 3
		BEGIN
			UPDATE tbl_Depositos
			SET
				Activo	= 0,
				UsuMod	= @txt_Id_Cajero,
				FecMod	= @FecSys
			WHERE
				Id_Deposito = @txt_Id_Deposito
		END
		
		IF @@ERROR <> 0 OR @bit_UserError = 1
		BEGIN
			ROLLBACK TRANSACTION
			RETURN
		END
	COMMIT TRANSACTION

END


















GO
/****** Object:  StoredProcedure [dbo].[sp_abcRetiros]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[sp_abcRetiros]
	@Accion				INT,
	@txt_Id_Retiro		NVARCHAR(100),
	@txt_Id_Caja		NVARCHAR(100),
	@txt_Id_Cajero  	NVARCHAR(100),
	@int_Tipo			INT,
	@dec_Monto			MONEY,
	@txt_Motivo			NVARCHAR(100),
	@Id_Sucursal        NVARCHAR(100)
AS
BEGIN

	DECLARE @txt_Mensaje	VARCHAR(100)
	DECLARE @bit_UserError	BIT

	DECLARE @Id			NVARCHAR(100)
	DECLARE @FecSys		DATETIME
	
	SET @FecSys = dbo.[fnGetNewDate]()

	SET @bit_UserError = 0
	BEGIN TRANSACTION
	
		IF @Accion = 1
		BEGIN
			SET @Id = NEWID()
			
			INSERT INTO tbl_Retiros
				   (Id_Retiro
				   ,id_sucursal
				   ,id_cajaXSucursal
				   ,Id_Cajero
				   ,Tipo
				   ,Monto
				   ,Motivo
				   ,UsuIns
				   ,FecIns
				   ,UsuMod
				   ,FecMod
				   ,Activo)
			VALUES
				   (@Id,
					@Id_Sucursal,
					@txt_Id_Caja,
					@txt_Id_Cajero,
					@int_Tipo,
					@dec_Monto,
					@txt_Motivo,
					@txt_Id_Cajero,
					@FecSys,
					@txt_Id_Cajero,
					@FecSys,
					1)

				INSERT INTO tbl_VentaCajas
				   (IDVentasCajas
				   ,IDCajaXSucursal
				   ,IDStatus
				   ,IDGenerico
				   ,usuins
				   ,fecins
				   ,usuupd
				   ,fecupd
				   ,activo)
				 VALUES
				   (NEWID()
				   ,@txt_Id_Caja
				   ,8
				   ,@Id
				   ,@txt_Id_Cajero
				   ,@FecSys
				   ,@txt_Id_Cajero
				   ,@FecSys
				   ,1)
		END
		
		If @Accion = 3
		BEGIN
			UPDATE tbl_Retiros
			SET
				Activo	= 0,
				UsuMod	= @txt_Id_Cajero,
				FecMod	= @FecSys
			WHERE
				Id_Retiro = @txt_Id_Retiro
		END
		
		IF @@ERROR <> 0 OR @bit_UserError = 1
		BEGIN
			ROLLBACK TRANSACTION
			RETURN
		END
	COMMIT TRANSACTION
END


















GO
/****** Object:  StoredProcedure [dbo].[ValidarFolioTransaccionTransferencia]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[ValidarFolioTransaccionTransferencia]
	-- Add the parameters for the stored procedure here
	@FolioAutorizacion NVARCHAR(30)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @BandExiste BIT = 0
    -- Insert statements for procedure here
	IF EXISTS (SELECT [id_pagotransferencia] FROM [dbo].[tbl_PagoTransferencia] WHERE [autorizacion] = @FolioAutorizacion)
	BEGIN
		SET @BandExiste = 1
	END
	ELSE
	BEGIN
		SET @BandExiste = 0
	END

	SELECT @BandExiste
END
GO
/****** Object:  StoredProcedure [dbo].[VentaBoletos_Insertar]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





ALTER PROCEDURE [dbo].[VentaBoletos_Insertar]	
        @IDSUCURSAL					NVARCHAR(100)
	   ,@IDTIPOVENTA				INT
	   ,@IDCLIENTE					NVARCHAR(100)
	   ,@MONEDERO					FLOAT
	   ,@IDCAJA						NVARCHAR(100)
	   ,@IDVENDEDOR					NVARCHAR(100)
	   ,@SUBTOTAL					MONEY
	   ,@DESCUENTO					MONEY
	   ,@IVA						MONEY
	   ,@TOTAL						MONEY
	   ,@PAGO						MONEY
	   ,@PAGOEFECTIVO				MONEY
	   ,@PAGOMONEDERO				MONEY
	   ,@PAGOTARJETA				MONEY
	   ,@PAGOTRANSFERENCIA			MONEY
	   ,@CAMBIO						MONEY
	   ,@ESTATUS					INT
	   ,@PENDIENTE					MONEY
	   ,@IDFORMAPAGO				INT 
	   ,@OBSERVACION				NVARCHAR(100)
	   ,@DATOSBOLETOS				Boletos READONLY
	   ,@DATOSBOLETOSTRANSFERIDOS   BoletosTransferidos READONLY
	   ,@DATOSTARJETA				DatosTarjeta READONLY
	   ,@DATOSTRANSFERENCIA			DatosTransferencia READONLY
	   ,@MACADDRESS					NVARCHAR(20)
	   ,@VENTAGRUPAL				BIT
	   ,@NOMBRE						NVARCHAR(150)
	   ,@NUMEROTELEFONO				NVARCHAR(50)
	   ,@FECHANACIMIENTO			DATE


AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON

	BEGIN TRANSACTION
	
		DECLARE  @FECHAACTUAL DATETIME = (dbo.[fnGetNewDate]())
		DECLARE  @HORAACTUAL   NVARCHAR(8) = CONVERT(CHAR(8), @FECHAACTUAL, 108)
		DECLARE  @ACTIVO   BIT = (1)
		DECLARE  @IDVENTA NVARCHAR(100) = (NEWID())
		DECLARE @IDVENTAPAGO NVARCHAR(100) = (NEWID())
	

		DECLARE  @FOLIOVENTA   NVARCHAR(20)
		SET @FOLIOVENTA = ( SELECT ISNULL(MAX(RIGHT(folio,6)),'000000') 
							FROM tbl_Venta 
							WHERE YEAR(fec_venta)= YEAR(@FECHAACTUAL)
							AND MONTH(fecins) = MONTH(@FECHAACTUAL) 
							AND DAY(fecins) = DAY(@FECHAACTUAL))
		SET @FOLIOVENTA = @FOLIOVENTA + 1
		SET @FOLIOVENTA = CONVERT(CHAR(4),YEAR(@FECHAACTUAL))+ RIGHT('0' + RTRIM(MONTH(@FECHAACTUAL)), 2)+ RIGHT('0' + RTRIM(DAY(@FECHAACTUAL)), 2) + RIGHT('000000'+@FOLIOVENTA,6) 

      INSERT INTO dbo.tbl_Venta
           (id_venta
           ,id_sucursal
           ,folio
           ,fec_venta
           ,hor_venta
           ,id_tipoVenta
           ,id_cliente
           ,id_cajaXSucursal
           ,id_vendedor
           ,id_cajero
           ,importe
           ,descuento
           ,iva
           ,total
           ,pago
           ,cambio
           ,Estatus
           ,pendiente
		   ,nombre
		   ,numeroTelefono
		   ,fechaNacimiento
		   ,ventaGrupal
		   ,cobroCancelacion
		   ,retornoCancelacion
           ,usuins
           ,usuupd
           ,fecins
           ,fecupd
           ,cajupd
           ,activo)
     VALUES
           (@IDVENTA
           ,@IDSUCURSAL
           ,@FOLIOVENTA
           ,@FECHAACTUAL
           ,@HORAACTUAL
           ,@IDTIPOVENTA
           ,@IDCLIENTE
           ,@IDCAJA
           ,@IDVENDEDOR
           ,@IDVENDEDOR
           ,@TOTAL
           ,@DESCUENTO
           ,@IVA
           ,@TOTAL
           ,@PAGO
           ,@CAMBIO
           ,@ESTATUS
           ,@PENDIENTE
           ,@NOMBRE
		   ,@NUMEROTELEFONO
		   ,@FECHANACIMIENTO
		   ,@VENTAGRUPAL
		   ,0
		   ,0
		   ,@IDVENDEDOR
           ,@IDVENDEDOR
           ,@FECHAACTUAL
           ,@FECHAACTUAL
           ,@IDCAJA
           ,@ACTIVO)

	  DECLARE @ABC BIT = 0
      INSERT INTO dbo.tbl_VentaDetalle
           (id_ventadetalle
           ,id_sucursal
           ,id_venta
           ,id_boleto
           ,cantidad_venta
           ,cantidad_devolucion
           ,costo
           ,precio
           ,porcentaje_desc
           ,porcentaje_iva
           ,descuento
		   ,pago1
		   ,pago2
		   ,iva
		   ,cancelacion
           ,usuins
           ,usuupd
           ,fecins
           ,fecupd
           ,activo)
     SELECT 
            NEWID()
           ,@IDSUCURSAL
           ,@IDVENTA
		   ,IDBoleto
		   ,1
		   ,0
		   ,Precio - Descuento + PagoExtra
		   ,Precio - Descuento + PagoExtra
		   ,0
		   ,0
		   ,Descuento
		   ,Anticipo
		   ,0
		   ,0
		   ,0
		   ,@IDVENDEDOR
		   ,@IDVENDEDOR
		   ,@FECHAACTUAL
		   ,@FECHAACTUAL
		   ,@ACTIVO
     FROM @DATOSBOLETOS	  
  
      INSERT INTO dbo.tbl_VentaDetalleDescuento
           (id_descuentoxdetalle
           ,id_sucursal
           ,id_ventadetalle
           ,id_descuento
           ,id_tipoPromocion
           ,descuento
           ,porcenta_desc
           ,usuins
           ,fecins
           ,usuupd
           ,fecupd
           ,activo)
	SELECT 
	         NEWID()
			,@IDSUCURSAL
			,tbl_VentaDetalle.id_ventadetalle
			,TipoDescuento
			,TipoDescuento
			,tbl_VentaDetalle.descuento
			,0
		    ,@IDVENDEDOR		    
		    ,@FECHAACTUAL
			,@IDVENDEDOR
		    ,@FECHAACTUAL
		    ,@ACTIVO
	FROM @DATOSBOLETOS AS Datos_Boletos JOIN tbl_VentaDetalle
	ON Datos_Boletos.IDBoleto = tbl_VentaDetalle.id_boleto	  
 
      INSERT INTO dbo.tbl_VentaPagos
           (id_ventaxpago
           ,id_sucursal
           ,id_venta
           ,id_formaPago
           ,monto
		   ,montoEfectivo
		   ,montoMonedero
		   ,montoTarjeta
		   ,montoTransferencia
           ,observaciones
           ,fecha
           ,id_cajaXSucursal
           ,id_cajero
           ,usuins
           ,fecins
           ,usuupd
           ,fecupd
           ,activo)
     VALUES
           (@IDVENTAPAGO
           ,@IDSUCURSAL
           ,@IDVENTA
           ,@IDFORMAPAGO
           ,@PAGO
		   ,@PAGOEFECTIVO - @CAMBIO
		   ,@PAGOMONEDERO
		   ,@PAGOTARJETA
		   ,@PAGOTRANSFERENCIA
           ,@OBSERVACION
           ,@FECHAACTUAL
           ,@IDCAJA
           ,@IDVENDEDOR
           ,@IDVENDEDOR
           ,@FECHAACTUAL
           ,@IDVENDEDOR
           ,@FECHAACTUAL
           ,@ACTIVO)   
		   
		   
		 IF ISNULL(@PAGOTARJETA, 0) > 0
		BEGIN
		INSERT INTO [dbo].[tbl_PagoTarjeta] 
			([id_pagotarjeta], [id_sucursal], [id_venta], [id_ventaxpago], [autorizacion], [folio_IFE], [id_TipoDocumento],
			 [numTarjeta], [id_banco], [monto], [usuins], [fecins], [usuupd], [fecupd], [activo])
		SELECT
			NEWID(), @IDSUCURSAL, @IDVENTA, @IDVENTAPAGO, DatosTarjeta.autorizacion, DatosTarjeta.folioDNI, DatosTarjeta.tipoDocumento,
			DatosTarjeta.numTarjeta, DatosTarjeta.id_banco, DatosTarjeta.monto, @IDVENDEDOR, @FECHAACTUAL, @IDVENDEDOR, @FECHAACTUAL, @ACTIVO
			FROM @DATOSTARJETA AS DatosTarjeta
		END
	   IF ISNULL(@PAGOTRANSFERENCIA, 0) > 0
		BEGIN
		INSERT INTO [dbo].[tbl_PagoTransferencia]
			([id_pagotransferencia], [id_sucursal], [id_venta], [id_ventaxpago], [autorizacion], 
			 [id_banco], [monto], [usuins], [fecins], [usuupd], [fecupd], [activo])
		SELECT
			NEWID(), @IDSUCURSAL, @IDVENTA, @IDVENTAPAGO, DatosTransferencia.autorizacion,
			DatosTransferencia.id_banco, DatosTransferencia.monto, @IDVENDEDOR, @FECHAACTUAL, @IDVENDEDOR, @FECHAACTUAL, @ACTIVO
			FROM @DATOSTRANSFERENCIA AS DatosTransferencia
		END    	

	  UPDATE tbl_Boletos
	     SET 
		     id_status = Datosboletos.IdStatus
			,id_tarifa = Datosboletos.IDTarifa
			,id_tipoTarifa = Datosboletos.IDTipoTarifa
			,costo = Datosboletos.Precio - Datosboletos.Descuento + Datosboletos.PagoExtra
			,id_venta = @IDVENTA
			,NombrePersona = Datosboletos.Nombre
			,fechaNacimiento = Datosboletos.fechaNacimiento
			,numeroTelefono = Datosboletos.NumeroTelefono				
		    ,id_boletoTransferencia =  Datosboletos.IDBoletoTransferencia
			,usuupd = @IDVENDEDOR
			,fecupd = @FECHAACTUAL
			,fecha_salidaV = Datosboletos.FechaSalidaV
			,hora_salidaV = Datosboletos.HoraSalidaV
		FROM tbl_Boletos JOIN @DatosBoletos AS Datosboletos
		ON tbl_Boletos.id_boleto = Datosboletos.IDBoleto
		WHERE Datosboletos.IDBoletoTransferencia = ''
  
      UPDATE tbl_Boletos
	     SET 
		     id_status = Datosboletos.IdStatus
			,id_tarifa = Datosboletos.IDTarifa
			,id_tipoTarifa = Datosboletos.IDTipoTarifa
			,costo = Datosboletos.Precio + Datosboletos.PagoExtra
			,id_venta = @IDVENTA
			,NombrePersona = Datosboletos.Nombre
			,fechaNacimiento = Datosboletos.fechaNacimiento		
			,numeroTelefono = Datosboletos.NumeroTelefono		
		    ,id_boletoTransferencia =  Datosboletos.IDBoletoTransferencia
			,usuupd = @IDVENDEDOR
			,fecupd = @FECHAACTUAL
			,fecha_salidaV = Datosboletos.FechaSalidaV
			,hora_salidaV = Datosboletos.HoraSalidaV
		FROM tbl_Boletos JOIN @DatosBoletos AS Datosboletos
		ON tbl_Boletos.id_boleto = Datosboletos.IDBoleto
		WHERE Datosboletos.IDBoletoTransferencia != ''
  
      UPDATE tbl_Boletos
	     SET 
   		     id_status = 4
			,activo = 0
			,usuupd = @IDVENDEDOR
			,fecupd = @FECHAACTUAL
		FROM tbl_Boletos JOIN @DatosBoletos AS Datosboletos
		ON tbl_Boletos.id_boleto = Datosboletos.IDBoletoTransferencia
		WHERE id_status = 3 AND activo = 1
	
	  IF((@PAGOMONEDERO > 0) AND (@IDCLIENTE != ''))
		BEGIN
	  		UPDATE tbl_CatCredenciales
			SET 
			   monedero = monedero - @PAGOMONEDERO 
			WHERE id_cliente = @IDCLIENTE
		END 

	  IF((@MONEDERO > 0) AND (@IDCLIENTE != ''))
		BEGIN
			UPDATE tbl_CatCredenciales
				SET 
					monedero = monedero + @MONEDERO 
			WHERE id_cliente = @IDCLIENTE
		END
  
      INSERT INTO tbl_VentaCajas
           (IDVentasCajas
           ,IDCajaXSucursal
           ,IDStatus
           ,IDGenerico
		   ,usuins
           ,fecins
           ,usuupd
           ,fecupd
           ,activo)
     SELECT
            NEWID()
           ,@IDCAJA
           ,1
           ,tbl_VentaDetalle.id_ventadetalle
		   ,@IDVENDEDOR
		   ,@FECHAACTUAL
		   ,@IDVENDEDOR
		   ,@FECHAACTUAL
		   ,1
	FROM @DATOSBOLETOS AS Datos_Boletos JOIN tbl_VentaDetalle
	ON Datos_Boletos.IDBoleto = tbl_VentaDetalle.id_boleto
	WHERE Datos_Boletos.IDBoletoTransferencia = '' AND tbl_VentaDetalle.pago1 = tbl_VentaDetalle.costo
	
	  INSERT INTO tbl_VentaCajas
           (IDVentasCajas
           ,IDCajaXSucursal
           ,IDStatus
           ,IDGenerico
		   ,usuins
           ,fecins
           ,usuupd
           ,fecupd
           ,activo)
     SELECT
            NEWID()
           ,@IDCAJA
           ,2
           ,tbl_VentaDetalle.id_ventadetalle
		   ,@IDVENDEDOR
		   ,@FECHAACTUAL
		   ,@IDVENDEDOR
		   ,@FECHAACTUAL
		   ,1
	FROM @DATOSBOLETOS AS Datos_Boletos JOIN tbl_VentaDetalle
	ON Datos_Boletos.IDBoleto = tbl_VentaDetalle.id_boleto
	WHERE Datos_Boletos.IDBoletoTransferencia = '' AND (tbl_VentaDetalle.pago1 + tbl_VentaDetalle.pago2) = 0

	  INSERT INTO tbl_VentaCajas
           (IDVentasCajas
           ,IDCajaXSucursal
           ,IDStatus
           ,IDGenerico
		   ,usuins
           ,fecins
           ,usuupd
           ,fecupd
           ,activo)
     SELECT
            NEWID()
           ,@IDCAJA
           ,3
           ,tbl_VentaDetalle.id_ventadetalle
		   ,@IDVENDEDOR
		   ,@FECHAACTUAL
		   ,@IDVENDEDOR
		   ,@FECHAACTUAL
		   ,1
	FROM @DATOSBOLETOS AS Datos_Boletos JOIN tbl_VentaDetalle
	ON Datos_Boletos.IDBoleto = tbl_VentaDetalle.id_boleto
	WHERE Datos_Boletos.IDBoletoTransferencia = '' AND (tbl_VentaDetalle.pago1 + tbl_VentaDetalle.pago2) > 0 AND (tbl_VentaDetalle.pago1 + tbl_VentaDetalle.pago2) != tbl_VentaDetalle.costo
	
	  INSERT INTO tbl_VentaCajas
           (IDVentasCajas
           ,IDCajaXSucursal
           ,IDStatus
           ,IDGenerico
		   ,usuins
           ,fecins
           ,usuupd
           ,fecupd
           ,activo)
     SELECT
            NEWID()
           ,@IDCAJA
           ,5
           ,tbl_VentaDetalle.id_ventadetalle
		   ,@IDVENDEDOR
		   ,@FECHAACTUAL
		   ,@IDVENDEDOR
		   ,@FECHAACTUAL
		   ,1
	FROM @DATOSBOLETOS AS Datos_Boletos JOIN tbl_VentaDetalle
	ON Datos_Boletos.IDBoleto = tbl_VentaDetalle.id_boleto
	WHERE Datos_Boletos.IDBoletoTransferencia != '' 

	INSERT INTO tbl_CancelacionesTransferenciasBoletos
			(id_boleto
			,id_motivoCancelacionTransferencia
			,id_tipo
			,id_caja
			,motivo
			,usuins
			,fecins
			,usuupd
			,fecupd
			,activo)
	SELECT 
	         Transferidos.IDBoletoTransferido
			,Transferidos.IDMotivoCancelacionTransferencia
			,Transferidos.id_tipo
			,@IDCAJA
			,Transferidos.descripcion
		    ,@IDVENDEDOR		    
		    ,@FECHAACTUAL
			,@IDVENDEDOR
		    ,@FECHAACTUAL
		    ,@ACTIVO
	FROM @DATOSBOLETOSTRANSFERIDOS AS Transferidos
	
	  IF @@ERROR <> 0 
      BEGIN
		SELECT 0
		ROLLBACK TRANSACTION
		RETURN
	  END
	 COMMIT TRANSACTION
	 
	SELECT 1
	SELECT vtbl_BoletosImpresion.id_boleto
		  ,vtbl_BoletosImpresion.folio
		  ,vtbl_BoletosImpresion.nombreCliente
		  ,vtbl_BoletosImpresion.asiento
		  ,vtbl_BoletosImpresion.fecha_salida
		  ,vtbl_BoletosImpresion.hora_salida
		  ,vtbl_BoletosImpresion.precioBoleto
		  ,vtbl_BoletosImpresion.iva
		  ,vtbl_BoletosImpresion.formaPago
		  ,vtbl_BoletosImpresion.tipoBoleto
		  ,vtbl_BoletosImpresion.terminalOrigen
		  ,vtbl_BoletosImpresion.origen
		  ,vtbl_BoletosImpresion.terminalDestino
		  ,vtbl_BoletosImpresion.destino
		  ,vtbl_BoletosImpresion.marca
		  ,vtbl_BoletosImpresion.servicio
		  ,vtbl_BoletosImpresion.numcamion
		  ,vtbl_BoletosImpresion.descuento
		  ,vtbl_BoletosImpresion.total
		  ,vtbl_BoletosImpresion.pago
		  ,vtbl_BoletosImpresion.pendiente
		  ,vtbl_BoletosImpresion.fechaventa
		  ,vtbl_BoletosImpresion.horaventa
		  ,vtbl_BoletosImpresion.porciva
		  ,vtbl_BoletosImpresion.id_status
		  ,vtbl_BoletosImpresion.cajero
		  ,@FOLIOVENTA AS folioVenta
	  FROM vtbl_BoletosImpresion JOIN @DATOSBOLETOS AS Datos_Boletos 
	  ON Datos_Boletos.IDBoleto = vtbl_BoletosImpresion.id_boleto 
 
	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		DECLARE @MensajeError NVARCHAR(MAX)= OBJECT_NAME(@@PROCID)+ '<br>' + ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END




































GO
/****** Object:  StoredProcedure [dbo].[VistaCamionesT1-2_Combo_sp]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







ALTER PROCEDURE [dbo].[VistaCamionesT1-2_Combo_sp]		
             @FECHABUSQUEDA     DATE
AS
BEGIN
	BEGIN TRY

		SET NOCOUNT ON

		DECLARE @MensajeError	VARCHAR(1000)

	    SELECT 
		     vtbl_FechasViaje.id_viaje AS IDViajeViejo,
			 vtbl_FechasViaje.id_viaje AS IDViajeNuevo,
			 vtbl_FechasViaje.nombreViaje AS NombreViaje, 
			 vtbl_FechasViaje.fechaOrigen AS FechaSalida, 
			 vtbl_FechasViaje.horaOrigen AS HoraSalida,
			 vtbl_FechasViaje.fechaOrigenV AS FechaV,
			 vtbl_FechasViaje.horaOrigenV AS HoraV,
			 (SELECT tbl_CatDisenio.numasientos FROM tbl_CatViajes JOIN tbl_CatCamiones ON tbl_CatViajes.id_camion = tbl_CatCamiones.id_camion JOIN tbl_CatDisenio ON tbl_CatCamiones.id_disenioCamion = tbl_CatDisenio.id_disenioCamion WHERE tbl_CatViajes.id_identificador = vtbl_FechasViaje.id_viaje) AS Asientos,
		     (SELECT COUNT(*) FROM tbl_Boletos WHERE id_viaje = vtbl_FechasViaje.id_viaje AND fecha_salida = vtbl_FechasViaje.fechaOrigen AND hora_salida = vtbl_FechasViaje.horaOrigen AND (id_status = 2 OR id_status = 3)  AND activo = 1) AS AsientosOcupados,
			 vtbl_FechasViaje.id_ruta AS IDRuta,
			 vtbl_FechasViaje.ruta AS Ruta,
			 vtbl_FechasViaje.id_disenioCamion AS IDDisenioCamion,
			 vtbl_FechasViaje.camion AS Camion,
			 vtbl_FechasViaje.id_tipocamion AS IDTipoCamion,
			 vtbl_FechasViaje.id_tarifa AS IDTarifa		 
	    FROM vtbl_FechasViaje 
		WHERE fechaOrigen = @FECHABUSQUEDA AND id_tipoTerminal = 1 AND activo = 1

	  UNION

	  SELECT 
	       '' AS IDViajeViejo,
		   '' AS IDViajeNuevo,
		   '-- Seleccionar --' AS NombreViaje,
		   CONVERT(DATE, dbo.[fnGetNewDate]()) AS FechaSalida,
		   '00:00:00' AS HoraSalida,
		   CONVERT(DATE, dbo.[fnGetNewDate]()) AS  FechaV,
		   '00:00:00' AS HoraV,
		   0 AS Asientos,
		   0 AS AsientosOcupados,
		   '' AS IDRuta,
		   '' AS Ruta,
		   '' AS IDDisenioCamion,
		   '-- Seleccionar --' AS Camion,
		   '' AS IDTipoCamion,
		   '' AS IDTarifa
	 ORDER BY NombreViaje

	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		SELECT @MensajeError	= ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END































GO
/****** Object:  StoredProcedure [dbo].[VistaCamionesT1-2_Combo_sp_Asistencia]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER PROCEDURE [dbo].[VistaCamionesT1-2_Combo_sp_Asistencia]	
              @FECHABUSQUEDA     DATE
AS
BEGIN
	BEGIN TRY

		SET NOCOUNT ON

		DECLARE @MensajeError	VARCHAR(1000)
		SET @FECHABUSQUEDA = [dbo].[fnGetNewDate]()

	    SELECT 
			 vtbl_FechasViaje.id_viaje,
			 vtbl_FechasViaje.nombreViaje, 
			 vtbl_FechasViaje.fechaOrigen,
			 vtbl_FechasViaje.horaOrigen
	    FROM vtbl_FechasViaje 
		WHERE fechaOrigen = @FECHABUSQUEDA AND id_tipoTerminal = 1 AND activo = 1 
		UNION
		SELECT
			'' AS id_viaje,
			'-- Seleccionar --' AS nombreViaje,
			CONVERT(DATE, dbo.[fnGetNewDate]()) AS fechaOrigen,
		   '00:00:00' AS horaOrigen
	 ORDER BY nombreViaje

	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		SELECT @MensajeError	= ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END

































GO
/****** Object:  StoredProcedure [dbo].[VistaCamionesT1-2_Combo_sp_Rpt]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[VistaCamionesT1-2_Combo_sp_Rpt]	
              @FECHABUSQUEDA DATE	
AS
BEGIN
	BEGIN TRY

		SET NOCOUNT ON

		DECLARE @MensajeError	VARCHAR(1000)


	    SELECT 
			 vtbl_FechasViaje.id_viaje AS IDViajeNuevo,
			 vtbl_FechasViaje.nombreViaje AS NombreViaje, 
			 vtbl_FechasViaje.fechaOrigen,
			 vtbl_FechasViaje.horaOrigen
	    FROM vtbl_FechasViaje 
		WHERE fechaOrigen = @FECHABUSQUEDA AND id_tipoTerminal = 1 AND activo = 1 AND NOT EXISTS(
		SELECT 
				tbl_DatosViaje.id_viaje
				,tbl_DatosViaje.fecha_salida
				,tbl_DatosViaje.hora_salida
		FROM tbl_DatosViaje
		WHERE tbl_DatosViaje.activo = 1  AND tbl_DatosViaje.id_viaje = vtbl_FechasViaje.id_viaje AND vtbl_FechasViaje.fechaOrigen = tbl_DatosViaje.fecha_salida AND vtbl_FechasViaje.horaOrigen = tbl_DatosViaje.hora_salida AND vtbl_FechasViaje.id_tipoTerminal = 1
		)

	  UNION

	  SELECT 
		   '' AS IDViajeNuevo,
		   '-- Seleccionar --' AS NombreViaje,
		   CONVERT(DATE, dbo.[fnGetNewDate]()) AS  fechaOrigen,
		   '00:00:00' AS horaOrigen
	 ORDER BY NombreViaje

	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		SELECT @MensajeError	= ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END
































GO
/****** Object:  StoredProcedure [dbo].[VistaCamionesT1-2_Combo_sp_Rpt_Mod]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER PROCEDURE [dbo].[VistaCamionesT1-2_Combo_sp_Rpt_Mod]	
              @FECHABUSQUEDA     DATE,
			  @IDVIAJE       	 NVARCHAR(100)
AS
BEGIN
	BEGIN TRY

		SET NOCOUNT ON

		DECLARE @MensajeError	VARCHAR(1000)


	    SELECT 
			 vtbl_FechasViaje.id_viaje AS IDViajeNuevo,
			 vtbl_FechasViaje.nombreViaje AS NombreViaje, 
			 vtbl_FechasViaje.fechaOrigen,
			 vtbl_FechasViaje.horaOrigen
	    FROM vtbl_FechasViaje 
		WHERE fechaOrigen = @FECHABUSQUEDA AND id_tipoTerminal = 1 AND activo = 1 AND NOT EXISTS(
		SELECT 
				tbl_DatosViaje.id_viaje
				,tbl_DatosViaje.fecha_salida
				,tbl_DatosViaje.hora_salida
		FROM tbl_DatosViaje
		WHERE tbl_DatosViaje.activo = 1  AND tbl_DatosViaje.id_viaje = vtbl_FechasViaje.id_viaje AND vtbl_FechasViaje.fechaOrigen = tbl_DatosViaje.fecha_salida AND vtbl_FechasViaje.horaOrigen = tbl_DatosViaje.hora_salida AND vtbl_FechasViaje.id_tipoTerminal = 1 AND tbl_DatosViaje.id_viaje NOT IN(@IDVIAJE)
		)

	  UNION

	  SELECT 
		   '' AS IDViajeNuevo,
		   '-- Seleccionar --' AS NombreViaje,
		   CONVERT(DATE, dbo.[fnGetNewDate]()) AS  fechaOrigen,
		   '00:00:00' AS horaOrigen
	 ORDER BY NombreViaje

	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		SELECT @MensajeError	= ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END

































GO
/****** Object:  StoredProcedure [dbo].[VistaCorridasT1-2_Combo_sp]    Script Date: 06/07/2017 1:20:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[VistaCorridasT1-2_Combo_sp]		
              @IDVIAJE     NVARCHAR(100)
			 ,@FECHAV      DATETIME
			 ,@HORAV       NVARCHAR(8)
AS
BEGIN
	BEGIN TRY

		SET NOCOUNT ON

		DECLARE @MensajeError	VARCHAR(1000)

	    SELECT 
		     CONCAT(vtbl_FechasViaje.id_viaje,vtbl_FechasViaje.ordenOrigen , ',' , vtbl_FechasViaje.ordenDestino) AS IDCorrida,
			 vtbl_FechasViaje.ordenOrigen AS OrdenOrigen,
			 vtbl_FechasViaje.ordenDestino AS OrdenDestino,
			 vtbl_FechasViaje.ruta AS Corrida
	    FROM vtbl_FechasViaje 
		WHERE vtbl_FechasViaje.id_viaje = @IDVIAJE 
		AND vtbl_FechasViaje.fechaOrigen = @FECHAV 
		AND vtbl_FechasViaje.horaOrigen = @HORAV
		AND activo = 1

	   UNION 
	     
		SELECT 
		   '' AS IDCorrida,
		   0  AS OrdenOrigen,
		   0  AS OrdenDestino,
		   '--Seleccionar--' AS Corrida

	END TRY
	BEGIN CATCH
		-- -----------------------------------------------------------------------------------------
		-- Control de errores
		-- -----------------------------------------------------------------------------------------
		SELECT @MensajeError	= ERROR_MESSAGE()
		RAISERROR(@MensajeError, 16, 1)
		-- -----------------------------------------------------------------------------------------

	END CATCH
END


























GO
