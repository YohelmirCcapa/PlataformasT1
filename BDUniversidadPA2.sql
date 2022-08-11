-- Procedimientos almacenados TAlumno
-- Yohelmir Ccapa Espinoza
-- 10 de agosto 2022







-- ProcedimientoAlmacenado para TAlumno
use BDUniversidad
go

--Procedimiento de Listar ALummno
if OBJECT_ID ('spListarAlumno') is not null
   drop proc spListarAlumno
go
create proc spListarAlumno
as
begin
    select CodAlumno, Apellidos, Nombres,LugarNac,FechaNac, CodEscuela from TAlumno
end
go

execute spListarAlumno
go


--Procedimiento para agregar alumno (transaccional)
if OBJECT_ID('spAgregarAlumno') is not null
	drop proc spAgregarAlumno
go
create proc spAgregarAlumno
@CodAlumno char(5), @Apellidos varchar(50), @Nombres varchar(50), @LugarNac varchar(50), @FechaNac varchar(50), @CodEscuela char(3)
as
begin
	-- CodAlumno no puede ser duplicado
	if not exists(select CodAlumno from TAlumno where CodAlumno=@CodAlumno)
		-- Escuela no puede ser duplicado
		if not exists(select Apellidos from TAlumno where Apellidos=@Apellidos)
			begin
				insert into TAlumno values(@CodAlumno,@Apellidos,@Nombres,@LugarNac,@FechaNac,@CodEscuela)
				select CodError = 0, Mensaje= 'Se inserto correctamente alumno'
			end
		else select CodError= 1, Mensaje = 'Error: Apellidos duplicada'
	else select CodError = 1, Mensaje = 'Error: CodAlumno duplicado'
end
go



exec spAgregarAlumno 'A01','Salva','Pool','Cusco','2022','E01'

exec spAgregarAlumno 'A02','Palomino','Andre','Cusco','12/07/2022','E02'

exec spAgregarAlumno 'A03','Perez','Juan','Cusco','09/07/2022','E03'

exec spAgregarAlumno 'A04','Coaquira','Ernesto','Cusco','12/03/2022','E04'

exec spAgregarAlumno 'A05','Coraima','Ernesto','Cusco','12/03/2022','E04'


execute spListarAlumno
go

--  Actividad: Eliminar, Actualizar, Buscar, Listar

--------------------------------------
---Procedimiento eleminado
if OBJECT_ID('spEliminarAlumno') is not null
	drop proc spEliminarAlumno
go
create proc spEliminarAlumno
@CodAlumno char(5)
as begin
	--1. CodAlumno debe existir
	if exists (select CodAlumno from TAlumno where CodAlumno = @CodAlumno)
		--2. No exista escuelas en la los alumnos  que quiero eliminar
		if not exists(select CodEscuela from TEscuela where CodEscuela = @CodAlumno)
		begin 
			delete from TAlumno WHERE CodAlumno =  @CodAlumno
			select CodError = 0, Mensaje = 'Alumno elimanado correctamente'
		end

		else select CodError = 1, Mensaje = 'Error: No se puede eliminar por que existe escuela'
	else select CodError = 1, Mensaje = 'Error: CodAlumno no existe'
end
go

exec spEliminarAlumno 'A01'
go

 exec spEliminarAlumno 'A02'
 go
--exec spEliminarAlumno 'A03'
--exec spEliminarAlumno 'A04'
--exec spEliminarAlumno 'A05'


exec spListarAlumno
go




SELECT * FROM TEscuela
SELECT * FROM TAlumno



-- Procedimientos Actualizar Alumno


if OBJECT_ID('spActualizarAlumno') is not null
	drop proc spActualizarAlumno
go
create proc spActualizarAlumno
@CodAlumno char(5), @Apellidos varchar(50), @Nombres varchar(50), @LugarNac varchar(50), @FechaNac datetime, @CodEscuela char(3)
as
begin
	if exists(select CodAlumno from TAlumno where CodAlumno = @CodAlumno)
		-- 2.- No exista escuela en los alumnos que quiero actualizar
		if not exists(select Apellidos, Nombres, LugarNac, FechaNac, CodEscuela from TAlumno where Apellidos = @Apellidos and Nombres = @Nombres and LugarNac = @LugarNac and FechaNac = @FechaNac and CodEscuela = @CodEscuela)
			begin
				update TAlumno set Apellidos = @Apellidos,Nombres = @Nombres, LugarNac=@LugarNac,FechaNac =@FechaNac, CodEscuela=@CodEscuela where CodAlumno = @CodAlumno
				select CodError = 0, Mensaje = 'Alumno actualizada correctamente'
			end
		else select CodError=1, Mensaje = 'Error: El alumno es duplicada'
	else select CodError = 1, Mensaje = 'Error: Codigo de Alumno no existe'

end


exec spActualizarAlumno  'A03','Issac','Pool','Cusco','2022','E02'
go
--exec spActualizarAlumno  'A02','Issac','Pool','Cusco','2022','E01'
--go


--exec spActualizarAlumno  'A06','Pool','Pool','Cusco','2022','E01'
--go

select * from TAlumno

-- Procedimiento almacenado para Buscar Escuela con sensitivas y exactas
if OBJECT_ID('spBuscarAlumno') is not null
	drop proc spBuscarAlumno
go
create proc spBuscarAlumno
	@Texto varchar(50),
	@Criterio varchar(50)
as
begin
	-- Busqueda exacta para el codigo de escuela
	if(@Criterio = 'CodAlumno')
		select CodAlumno, Apellidos, Nombres, LugarNac, FechaNac, CodEscuela from TAlumno where CodAlumno = @Texto
	--Busqueda sensitiva para el nombre de la escueka
	else if (@Criterio = 'Materno')
		select Apellidos, CodAlumno from TAlumno where Apellidos like @Texto + '%'
	else if (@Criterio = 'Paterno')
		select Nombres, CodAlumno from TAlumno where Nombres like @Texto + '%'
	else if (@Criterio = 'Sitio')
		select LugarNac, CodAlumno from TAlumno where LugarNac like @Texto + '%'
else if (@Criterio = 'Cumplea�os')
		select FechaNac, CodAlumno from TAlumno where FechaNac like @Texto + '%'
else if (@Criterio = 'id')
		select CodEscuela, CodAlumno from TAlumno where CodEscuela like @Texto + '%'

	end
go

exec spListarAlumno
go

exec spBuscarAlumno 'A04','CodAlumno'
go 

exec spBuscarAlumno 'C', 'Materno'
go 



-- Presentad para el d�a miercoles 10 de agosto a traves de aula virtual