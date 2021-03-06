USE [master]
GO
/****** Object:  Database [MultiProcessDb]    Script Date: 01-08-2018 13:58:44 ******/
CREATE DATABASE [MultiProcessDb]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'MultiProcessDb', FILENAME = N'C:\Program Files (x86)\Microsoft SQL Server\MSSQL12.SQLEXPRESS\MSSQL\DATA\MultiProcessDb.mdf' , SIZE = 3264KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'MultiProcessDb_log', FILENAME = N'C:\Program Files (x86)\Microsoft SQL Server\MSSQL12.SQLEXPRESS\MSSQL\DATA\MultiProcessDb_log.ldf' , SIZE = 832KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [MultiProcessDb] SET COMPATIBILITY_LEVEL = 120
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [MultiProcessDb].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [MultiProcessDb] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [MultiProcessDb] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [MultiProcessDb] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [MultiProcessDb] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [MultiProcessDb] SET ARITHABORT OFF 
GO
ALTER DATABASE [MultiProcessDb] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [MultiProcessDb] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [MultiProcessDb] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [MultiProcessDb] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [MultiProcessDb] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [MultiProcessDb] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [MultiProcessDb] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [MultiProcessDb] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [MultiProcessDb] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [MultiProcessDb] SET  ENABLE_BROKER 
GO
ALTER DATABASE [MultiProcessDb] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [MultiProcessDb] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [MultiProcessDb] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [MultiProcessDb] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [MultiProcessDb] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [MultiProcessDb] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [MultiProcessDb] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [MultiProcessDb] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [MultiProcessDb] SET  MULTI_USER 
GO
ALTER DATABASE [MultiProcessDb] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [MultiProcessDb] SET DB_CHAINING OFF 
GO
ALTER DATABASE [MultiProcessDb] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [MultiProcessDb] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [MultiProcessDb] SET DELAYED_DURABILITY = DISABLED 
GO
USE [MultiProcessDb]
GO
/****** Object:  Table [dbo].[MultiProcessStatus]    Script Date: 01-08-2018 13:58:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MultiProcessStatus](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [nvarchar](200) NULL,
	[Module] [nvarchar](200) NULL,
	[TotalRecords] [int] NULL,
	[FailedRecords] [int] NULL,
	[SuccessRecords] [int] NULL,
	[Percentage] [decimal](18, 2) NULL,
	[IsCompleted] [bit] NULL,
	[CreatedDate] [date] NULL
) ON [PRIMARY]

GO
/****** Object:  StoredProcedure [dbo].[GetMultiprocessStatus]    Script Date: 01-08-2018 13:58:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetMultiprocessStatus]
(
@UserId NVARCHAR(200),
@Module NVARCHAR(200)
)
AS
BEGIN
	SELECT TOP 1 * FROM MultiProcessStatus WHERE UserId = @UserId AND Module = @Module ORDER BY Id DESC
END

GO
/****** Object:  StoredProcedure [dbo].[InsertMultiprocessStatus]    Script Date: 01-08-2018 13:58:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[InsertMultiprocessStatus]
(
@UserId NVARCHAR(200),
@Module  NVARCHAR(200),
@TotalRecords INT,
@ReturnId INT OUTPUT
)
AS
BEGIN
	SET @ReturnId = 0
	INSERT INTO MultiProcessStatus (UserId,Module,TotalRecords,FailedRecords,SuccessRecords,Percentage,IsCompleted,CreatedDate)
	VALUES (@UserId,@Module,@TotalRecords,0,0,0,0,GETDATE())

	SET @ReturnId = @@IDENTITY
END

GO
/****** Object:  StoredProcedure [dbo].[UpdateMultiprocessStatus]    Script Date: 01-08-2018 13:58:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[UpdateMultiprocessStatus] 
(
@Id INT,
@Percentage DECIMAL(18,2),
@IsCompleted BIT,
@FailedRecords INT,
@SuccessRecords INT
)
AS
BEGIN
	IF(@Percentage > 99)
	BEGIN
		SET @IsCompleted = 1
	END
	UPDATE MultiProcessStatus SET Percentage = @Percentage,IsCompleted = @IsCompleted,
	FailedRecords = @FailedRecords,SuccessRecords = @SuccessRecords 
	WHERE Id = @Id 
END

GO
USE [master]
GO
ALTER DATABASE [MultiProcessDb] SET  READ_WRITE 
GO
