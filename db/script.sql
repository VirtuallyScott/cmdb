USE [master]
GO
/****** Object:  Database [cmdb_db]    Script Date: 10/27/2015 4:19:17 PM ******/
CREATE DATABASE [cmdb_db]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'cmdb_db', FILENAME = N'/var/opt/mssql/data/cmdb_db.mdf' , SIZE = 65344KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'cmdb_db_log', FILENAME = N'/var/opt/mssql/data/cmdb_db_log.ldf' , SIZE = 1024KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [cmdb_db] SET COMPATIBILITY_LEVEL = 120
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [cmdb_db].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [cmdb_db] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [cmdb_db] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [cmdb_db] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [cmdb_db] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [cmdb_db] SET ARITHABORT OFF 
GO
ALTER DATABASE [cmdb_db] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [cmdb_db] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [cmdb_db] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [cmdb_db] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [cmdb_db] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [cmdb_db] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [cmdb_db] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [cmdb_db] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [cmdb_db] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [cmdb_db] SET  DISABLE_BROKER 
GO
ALTER DATABASE [cmdb_db] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [cmdb_db] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [cmdb_db] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [cmdb_db] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [cmdb_db] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [cmdb_db] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [cmdb_db] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [cmdb_db] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [cmdb_db] SET  MULTI_USER 
GO
ALTER DATABASE [cmdb_db] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [cmdb_db] SET DB_CHAINING OFF 
GO
ALTER DATABASE [cmdb_db] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [cmdb_db] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [cmdb_db] SET DELAYED_DURABILITY = DISABLED 
GO
USE [cmdb_db]
GO
/****** Object:  Table [dbo].[active_directory_groups]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[active_directory_groups](
	[ADGroupID] [int] IDENTITY(1,1) NOT NULL,
	[ADGroupUUID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_active_directory_groups_ADGroupUUID]  DEFAULT (newid()),
	[StartDate] [datetime] NOT NULL CONSTRAINT [DF_active_directory_groups_StartDate]  DEFAULT (getutcdate()),
	[EndDate] [datetime] NULL,
	[distinguishedName] [varchar](500) NULL,
	[SamAccountName] [varchar](150) NULL,
	[cn] [varchar](150) NULL,
	[displayName] [varchar](150) NULL,
	[mail] [varchar](150) NULL,
	[mailNickname] [varchar](150) NULL,
	[memberOf] [varchar](2500) NULL,
 CONSTRAINT [PK_active_directory_groups] PRIMARY KEY CLUSTERED 
(
	[ADGroupUUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[active_directory_members]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[active_directory_members](
	[ADMemberID] [int] IDENTITY(1,1) NOT NULL,
	[ADMemberUUID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_active_directory_members_ADMemberUUID]  DEFAULT (newid()),
	[StartDate] [datetime] NOT NULL CONSTRAINT [DF_active_directory_members_StartDate]  DEFAULT (getutcdate()),
	[EndDate] [datetime] NULL,
	[ADGroupUUID] [uniqueidentifier] NOT NULL,
	[PersonUUID] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_active_directory_members] PRIMARY KEY CLUSTERED 
(
	[ADMemberUUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[active_directory_memberships]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[active_directory_memberships](
	[memberofID] [int] IDENTITY(1,1) NOT NULL,
	[memberofUUID] [uniqueidentifier] NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NULL,
	[ParentADUUID] [uniqueidentifier] NOT NULL,
	[ChildADUUID] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_active_directory_memberships] PRIMARY KEY CLUSTERED 
(
	[memberofUUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[alpha]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[alpha](
	[alphaID] [int] IDENTITY(1,1) NOT NULL,
	[alphaUUID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_alpha_alphaUUID]  DEFAULT (newid()),
	[alpha] [char](1) NOT NULL,
 CONSTRAINT [PK_alpha] PRIMARY KEY CLUSTERED 
(
	[alphaUUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[api_consumers]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[api_consumers](
	[APIConsumerID] [int] IDENTITY(1,1) NOT NULL,
	[APIConsumerUUID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_api_consumers_APIConsumerUUID]  DEFAULT (newid()),
	[StartDate] [datetime] NOT NULL CONSTRAINT [DF_api_consumers_StartDate]  DEFAULT (getutcdate()),
	[EndDate] [datetime] NULL,
	[PublicKey] [uniqueidentifier] NOT NULL CONSTRAINT [DF_api_consumers_PublicKey]  DEFAULT (newid()),
	[PersonUUID] [uniqueidentifier] NOT NULL,
	[Notes] [varchar](50) NULL,
	[LastUpdate] [datetime] NULL,
 CONSTRAINT [PK_api_consumers] PRIMARY KEY CLUSTERED 
(
	[APIConsumerUUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[application_compliance]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[application_compliance](
	[applicationComplianceID] [int] IDENTITY(1,1) NOT NULL,
	[applicationComplianceUUID] [uniqueidentifier] NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NULL,
	[ApplicationUUID] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_application_compliance] PRIMARY KEY CLUSTERED 
(
	[applicationComplianceUUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[application_files]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[application_files](
	[applicationFileID] [int] IDENTITY(1,1) NOT NULL,
	[applicationFileUUID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_application_files_applicationFileUUID]  DEFAULT (newid()),
	[StartDate] [datetime] NOT NULL CONSTRAINT [DF_application_files_StartDate]  DEFAULT (getutcdate()),
	[EndDate] [datetime] NULL,
	[PersonUUID] [uniqueidentifier] NULL,
	[ApplicationUUID] [uniqueidentifier] NULL,
	[FileUUID] [uniqueidentifier] NULL,
 CONSTRAINT [PK_application_files] PRIMARY KEY CLUSTERED 
(
	[applicationFileUUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[application_notes]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[application_notes](
	[ApplicationNoteID] [int] IDENTITY(1,1) NOT NULL,
	[ApplicationNoteUUID] [uniqueidentifier] NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NULL,
	[ApplicationUUID] [uniqueidentifier] NOT NULL,
	[PersonUUID] [uniqueidentifier] NOT NULL,
	[ApplicationNote] [nvarchar](max) NOT NULL,
	[LastUpdatePersonUUID] [uniqueidentifier] NULL,
 CONSTRAINT [PK_application_notes] PRIMARY KEY CLUSTERED 
(
	[ApplicationNoteUUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[application_owners]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[application_owners](
	[ApplicationOwnerID] [int] IDENTITY(1,1) NOT NULL,
	[ApplicationOwnerUUID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_application_owners_ApplicationOwnerUUID]  DEFAULT (newid()),
	[StartDate] [datetime] NOT NULL CONSTRAINT [DF_application_owners_StartDate]  DEFAULT (getutcdate()),
	[EndDate] [datetime] NULL,
	[ApplicationUUID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_application_owners_ApplicationUUID]  DEFAULT (newid()),
	[PersonUUID] [uniqueidentifier] NULL,
	[OwnerType] [bit] NOT NULL CONSTRAINT [DF_application_owners_OwnerType]  DEFAULT ((0)),
	[ADGroupUUID] [uniqueidentifier] NULL,
 CONSTRAINT [PK_application_owners] PRIMARY KEY CLUSTERED 
(
	[ApplicationOwnerUUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[application_servers]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[application_servers](
	[ApplicationServerID] [int] IDENTITY(1,1) NOT NULL,
	[ApplicationServerUUID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_application_servers_ApplicationServerUUID]  DEFAULT (newid()),
	[StartDate] [datetime] NOT NULL CONSTRAINT [DF_application_servers_StartDate]  DEFAULT (getutcdate()),
	[EndDate] [datetime] NULL,
	[ApplicationUUID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_application_servers_ApplicationUUID]  DEFAULT (newid()),
	[ServerUUID] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_application_servers] PRIMARY KEY CLUSTERED 
(
	[ApplicationServerUUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[application_sme_types]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[application_sme_types](
	[ApplicationSMETypeID] [int] IDENTITY(1,1) NOT NULL,
	[ApplicationSMETypeUUID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_application_sme_types_ApplicationSMETypeUUID]  DEFAULT (newid()),
	[StartDate] [datetime] NOT NULL CONSTRAINT [DF_application_sme_types_StartDate]  DEFAULT (getutcdate()),
	[EndDate] [datetime] NULL,
	[SMEType] [varchar](50) NOT NULL,
 CONSTRAINT [PK_application_sme_types] PRIMARY KEY CLUSTERED 
(
	[ApplicationSMETypeUUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[application_smes]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[application_smes](
	[ApplicationSMEID] [int] IDENTITY(1,1) NOT NULL,
	[ApplicationSMEUUID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_application_SMEs_ApplicationSMEUUID]  DEFAULT (newid()),
	[StartDate] [datetime] NOT NULL CONSTRAINT [DF_application_SMEs_StartDate]  DEFAULT (getutcdate()),
	[EndDate] [datetime] NULL,
	[ApplicationUUID] [uniqueidentifier] NOT NULL,
	[PersonUUID] [uniqueidentifier] NOT NULL,
	[ApplicationSMETypeUUID] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_application_SMEs] PRIMARY KEY CLUSTERED 
(
	[ApplicationSMEUUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[application_technologies]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[application_technologies](
	[applicationTechnologyID] [int] IDENTITY(1,1) NOT NULL,
	[applicationTechnologyUUID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_application_technologies_applicationTechnologyUUID]  DEFAULT (newid()),
	[StartDate] [datetime] NOT NULL CONSTRAINT [DF_application_technologies_StartDate]  DEFAULT (getutcdate()),
	[EndDate] [datetime] NULL,
	[ApplicationUUID] [uniqueidentifier] NOT NULL,
	[TechnologyUUID] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_application_technologies] PRIMARY KEY CLUSTERED 
(
	[applicationTechnologyUUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[application_types]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[application_types](
	[ApplicationTypeID] [int] IDENTITY(1,1) NOT NULL,
	[ApplicationTypeUUID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_application_types_ApplicationUUID]  DEFAULT (newid()),
	[StartDate] [datetime] NOT NULL CONSTRAINT [DF_application_types_StartDate]  DEFAULT (getutcdate()),
	[EndDate] [datetime] NULL,
	[CompanyUUID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_application_types_CompanyUUID]  DEFAULT (newid()),
	[ApplicationType] [varchar](150) NOT NULL,
 CONSTRAINT [PK_application_types] PRIMARY KEY CLUSTERED 
(
	[ApplicationTypeUUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[application_urls]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[application_urls](
	[ApplicationURLID] [int] IDENTITY(1,1) NOT NULL,
	[ApplicationURLUUID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_application_urls_ApplicationURLUUID]  DEFAULT (newid()),
	[StartDate] [datetime] NOT NULL CONSTRAINT [DF_application_urls_StartDate]  DEFAULT (getutcdate()),
	[EndDate] [datetime] NULL,
	[ApplicationUUID] [uniqueidentifier] NOT NULL,
	[Link] [varchar](250) NOT NULL,
	[Note] [varchar](250) NULL,
 CONSTRAINT [PK_application_urls] PRIMARY KEY CLUSTERED 
(
	[ApplicationURLUUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[applications]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[applications](
	[ApplicationID] [int] IDENTITY(1,1) NOT NULL,
	[ApplicationUUID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_applications_ApplicationUUID]  DEFAULT (newid()),
	[StartDate] [datetime] NOT NULL CONSTRAINT [DF_applications_StartDate]  DEFAULT (getutcdate()),
	[EndDate] [datetime] NULL,
	[ApplicationTypeUUID] [uniqueidentifier] NULL,
	[CompanyUUID] [uniqueidentifier] NULL,
	[ChangePriorityUUID] [uniqueidentifier] NULL,
	[ApplicationName] [varchar](150) NOT NULL,
	[ApplicationDescription] [varchar](150) NULL,
	[PCI] [bit] NOT NULL CONSTRAINT [DF_applications_PCI]  DEFAULT ((0)),
	[DR] [bit] NOT NULL,
	[ProductionSiteUUID] [uniqueidentifier] NULL,
	[DRSiteUUID] [uniqueidentifier] NULL,
	[CorporateCritical] [bit] NULL CONSTRAINT [DF_applications_CorporateCritical]  DEFAULT ((0)),
	[Utility] [bit] NOT NULL CONSTRAINT [DF_applications_Utility]  DEFAULT ((0)),
	[WikiURL] [varchar](150) NULL,
	[GITURL] [varchar](150) NULL,
	[SOX] [bit] NOT NULL CONSTRAINT [DF_applications_SOX]  DEFAULT ((0)),
 CONSTRAINT [PK_applications] PRIMARY KEY CLUSTERED 
(
	[ApplicationUUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[approve_application_owner_change]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[approve_application_owner_change](
	[ApprovalApplicationOwnerID] [int] IDENTITY(1,1) NOT NULL,
	[ApprovalApplicationOwnerUUID] [uniqueidentifier] NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NULL,
	[ApplicationUUID] [uniqueidentifier] NOT NULL,
	[NewOwnerPersonUUID] [uniqueidentifier] NOT NULL,
	[OldOwnerPersonUUID] [uniqueidentifier] NOT NULL,
	[OwnerType] [bit] NULL,
	[ApprovalDate] [datetime] NULL,
	[IPAddress] [varchar](15) NULL,
 CONSTRAINT [PK_approve_application_owner_change] PRIMARY KEY CLUSTERED 
(
	[ApprovalApplicationOwnerUUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[bk]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[bk](
	[BKID] [int] IDENTITY(1,1) NOT NULL,
	[BKUUID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_bk_BKUUID]  DEFAULT (newid()),
	[StartDate] [datetime] NOT NULL CONSTRAINT [DF_bk_StartDate]  DEFAULT (getutcdate()),
	[EndDate] [datetime] NULL,
	[PersonUUID] [uniqueidentifier] NOT NULL,
	[DateMask] [varchar](50) NOT NULL CONSTRAINT [DF_bk_DateMask]  DEFAULT ('mm/dd/yyyy'),
	[TimeMask] [varchar](50) NOT NULL CONSTRAINT [DF_bk_TimeMask]  DEFAULT ('t:m tt'),
	[TFormat] [varchar](50) NOT NULL CONSTRAINT [DF_bk_Format]  DEFAULT ('Local'),
	[RPP] [int] NOT NULL CONSTRAINT [DF_bk_RPP]  DEFAULT ((20)),
 CONSTRAINT [PK_bk] PRIMARY KEY CLUSTERED 
(
	[BKUUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[change_priorities]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[change_priorities](
	[ChangePriorityID] [int] IDENTITY(1,1) NOT NULL,
	[ChangePriorityUUID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_change_priorities_ChangePriorityUUID]  DEFAULT (newid()),
	[StartDate] [datetime] NOT NULL CONSTRAINT [DF_change_priorities_StartDate]  DEFAULT (getutcdate()),
	[EndDate] [datetime] NULL,
	[ChangePriority] [int] NOT NULL,
 CONSTRAINT [PK_change_priorities] PRIMARY KEY CLUSTERED 
(
	[ChangePriorityUUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[companies]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[companies](
	[CompanyID] [int] IDENTITY(1,1) NOT NULL,
	[CompanyUUID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_companies_CompanyUUID]  DEFAULT (newid()),
	[StartDate] [datetime] NOT NULL CONSTRAINT [DF_companies_StartDate]  DEFAULT (getutcdate()),
	[EndDate] [datetime] NULL,
	[CompanyName] [varchar](150) NOT NULL,
 CONSTRAINT [PK_companies] PRIMARY KEY CLUSTERED 
(
	[CompanyUUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[compliance_types]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[compliance_types](
	[complianceID] [int] IDENTITY(1,1) NOT NULL,
	[complianceUUID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_compliancetypes_complianceUUID]  DEFAULT (newid()),
	[StartDate] [datetime] NOT NULL CONSTRAINT [DF_compliancetypes_StartDate]  DEFAULT (getutcdate()),
	[EndDate] [datetime] NULL,
	[complianceType] [varchar](50) NOT NULL,
 CONSTRAINT [PK_compliancetypes] PRIMARY KEY CLUSTERED 
(
	[complianceUUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[datemasks]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[datemasks](
	[DateMaskID] [int] IDENTITY(1,1) NOT NULL,
	[DateMaskUUID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_datemasks_DateMaskUUID]  DEFAULT (newid()),
	[StartDate] [datetime] NOT NULL CONSTRAINT [DF_datemasks_StartDate]  DEFAULT (getutcdate()),
	[EndDate] [datetime] NULL,
	[DateMask] [varchar](50) NOT NULL CONSTRAINT [DF_datemasks_DateMask]  DEFAULT ('mm/d/yyyy'),
	[DateMaskExample] [varchar](50) NOT NULL CONSTRAINT [DF_datemasks_DateMaskExample]  DEFAULT ('01/1/2015'),
 CONSTRAINT [PK_datemasks] PRIMARY KEY CLUSTERED 
(
	[DateMaskUUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[dc_cabinets]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[dc_cabinets](
	[dcCabinetID] [int] IDENTITY(1,1) NOT NULL,
	[dcCabinetUUID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_dc_cabinets_dcCabinetUUID]  DEFAULT (newid()),
	[StartDate] [datetime] NOT NULL CONSTRAINT [DF_dc_cabinets_StartDate]  DEFAULT (getutcdate()),
	[EndDate] [datetime] NULL,
	[cabinet] [varchar](50) NOT NULL,
	[dcmoduleUUID] [uniqueidentifier] NOT NULL,
	[uSize] [numeric](2, 0) NULL,
	[manufacturerUUID] [uniqueidentifier] NULL,
 CONSTRAINT [PK_dc_cabinets] PRIMARY KEY CLUSTERED 
(
	[dcCabinetUUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[dc_modules]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[dc_modules](
	[dcModuleID] [int] IDENTITY(1,1) NOT NULL,
	[dcModuleUUID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_dc_modules_dcModuleUUID]  DEFAULT (newid()),
	[StartDate] [datetime] NOT NULL CONSTRAINT [DF_dc_modules_StartDate]  DEFAULT (getutcdate()),
	[EndDate] [datetime] NULL,
	[siteUUID] [uniqueidentifier] NOT NULL,
	[Module] [varchar](50) NOT NULL,
 CONSTRAINT [PK_dc_modules] PRIMARY KEY CLUSTERED 
(
	[dcModuleUUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[dependencies]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dependencies](
	[DependencyID] [int] IDENTITY(1,1) NOT NULL,
	[DependencyUUID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_Dependencies_DependencyUUID]  DEFAULT (newid()),
	[StartDate] [datetime] NOT NULL CONSTRAINT [DF_Dependencies_StartDate]  DEFAULT (getutcdate()),
	[EndDate] [datetime] NULL,
	[ParentUUID] [uniqueidentifier] NOT NULL,
	[ChildUUID] [uniqueidentifier] NOT NULL,
	[PersonUUID] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_Dependencies] PRIMARY KEY CLUSTERED 
(
	[DependencyUUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[disclaimers]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[disclaimers](
	[disclaimerID] [int] IDENTITY(1,1) NOT NULL,
	[disclaimerUUID] [uniqueidentifier] NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NULL,
 CONSTRAINT [PK_disclaimers] PRIMARY KEY CLUSTERED 
(
	[disclaimerUUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[dr_protection_groups]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[dr_protection_groups](
	[DRProtectionGroupID] [int] IDENTITY(1,1) NOT NULL,
	[DRProtectionGroupUUID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_dr_protection_groups_DRProtectionGroupUUID]  DEFAULT (newid()),
	[StartDate] [datetime] NOT NULL CONSTRAINT [DF_dr_protection_groups_StartDate]  DEFAULT (getutcdate()),
	[EndDate] [datetime] NULL,
	[DRProtectionGroup] [varchar](50) NOT NULL,
 CONSTRAINT [PK_dr_protection_groups] PRIMARY KEY CLUSTERED 
(
	[DRProtectionGroupUUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[dr_server_details]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dr_server_details](
	[DRDetailsID] [int] IDENTITY(1,1) NOT NULL,
	[DRDetailsUUID] [uniqueidentifier] NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NULL,
	[ServerUUID] [uniqueidentifier] NULL,
 CONSTRAINT [PK_dr_server_details] PRIMARY KEY CLUSTERED 
(
	[DRDetailsUUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[dr_servers]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dr_servers](
	[DRServerID] [int] IDENTITY(1,1) NOT NULL,
	[DRServerUUID] [uniqueidentifier] NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NULL,
	[ServerUUID] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_dr_servers] PRIMARY KEY CLUSTERED 
(
	[DRServerUUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[dr_validation]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dr_validation](
	[DRValidationID] [int] IDENTITY(1,1) NOT NULL,
	[DRValidationUUID] [uniqueidentifier] NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[ApplicationUUID] [uniqueidentifier] NULL,
	[PersonUUID] [uniqueidentifier] NULL,
	[IPAddress] [nvarchar](15) NULL,
 CONSTRAINT [PK_dr_validation] PRIMARY KEY CLUSTERED 
(
	[DRValidationUUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[dr_validation_date]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dr_validation_date](
	[DRValidationDateID] [int] IDENTITY(1,1) NOT NULL,
	[DRValidationDateUUID] [uniqueidentifier] NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NULL,
	[ApplicationUUID] [uniqueidentifier] NOT NULL,
	[DueDate] [datetime] NOT NULL,
 CONSTRAINT [PK_dr_validation_date] PRIMARY KEY CLUSTERED 
(
	[DRValidationDateUUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[file_icons]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[file_icons](
	[fileIconID] [int] IDENTITY(1,1) NOT NULL,
	[fileIconUUID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_fileicons_fileIconUUID]  DEFAULT (newid()),
	[StartDate] [datetime] NOT NULL CONSTRAINT [DF_fileicons_StartDate]  DEFAULT (getutcdate()),
	[EndDate] [datetime] NULL,
	[iconClass] [varchar](50) NULL,
	[fileExt] [varchar](50) NULL,
 CONSTRAINT [PK_fileicons] PRIMARY KEY CLUSTERED 
(
	[fileIconUUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[file_permissions]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[file_permissions](
	[FilePermissionID] [int] IDENTITY(1,1) NOT NULL,
	[FilePermissionUUID] [uniqueidentifier] NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NULL,
	[FileUUID] [uniqueidentifier] NOT NULL,
	[ADGroupUUID] [uniqueidentifier] NULL,
	[PersonUUID] [uniqueidentifier] NULL,
 CONSTRAINT [PK_file_permissions] PRIMARY KEY CLUSTERED 
(
	[FilePermissionUUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[files]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[files](
	[FileID] [int] IDENTITY(1,1) NOT NULL,
	[FileUUID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_files_FileUUID]  DEFAULT (newid()),
	[StartDate] [datetime] NOT NULL CONSTRAINT [DF_files_StartDate]  DEFAULT (getutcdate()),
	[EndDate] [datetime] NULL,
	[PersonUUID] [uniqueidentifier] NOT NULL,
	[IPNumber] [varchar](15) NOT NULL,
	[attemptedServerFile] [varchar](150) NULL,
	[clientDirectory] [varchar](250) NULL,
	[clientFile] [varchar](150) NULL,
	[clientFileExt] [varchar](50) NULL,
	[clientFileName] [varchar](200) NULL,
	[contentSubType] [varchar](150) NULL,
	[contentType] [varchar](150) NULL,
	[dateLastAccessed] [datetime] NULL,
	[fileExisted] [bit] NULL,
	[fileSize] [nvarchar](50) NULL,
	[fileWasAppended] [bit] NULL,
	[fileWasOverwritten] [bit] NULL,
	[fileWasRenamed] [bit] NULL,
	[fileWasSaved] [bit] NULL,
	[oldFileSize] [nvarchar](50) NULL,
	[serverDirectory] [varchar](250) NULL,
	[serverFile] [varchar](150) NULL,
	[serverFileExt] [varchar](50) NULL,
	[serverFileName] [varchar](200) NULL,
	[timeCreated] [datetime] NULL,
	[timeLastModified] [datetime] NULL,
	[fileContents] [varbinary](max) NULL,
	[fileDescription] [varchar](250) NULL,
	[RestrictFile] [bit] NOT NULL CONSTRAINT [DF_files_RestrictFile]  DEFAULT ((0)),
	[SharedFile] [bit] NOT NULL CONSTRAINT [DF_files_ShareFile]  DEFAULT ((0)),
 CONSTRAINT [PK_files] PRIMARY KEY CLUSTERED 
(
	[FileUUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[foo]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[foo](
	[i] [char](1) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[h_applications]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[h_applications](
	[h_ApplicationUUID] [uniqueidentifier] NOT NULL,
	[h_StartDate] [datetime] NOT NULL,
	[ApplicationTypeUUID] [uniqueidentifier] NULL,
	[StartDate] [datetime] NULL,
	[CompanyUUID] [uniqueidentifier] NOT NULL,
	[ChangePriorityUUID] [uniqueidentifier] NULL,
	[ApplicationName] [varchar](150) NULL,
	[ApplicationDescription] [varchar](150) NULL,
	[ApplicationUUID] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_h_applications] PRIMARY KEY CLUSTERED 
(
	[h_ApplicationUUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[h_dependencies]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[h_dependencies](
	[h_DependencyUUID] [uniqueidentifier] NOT NULL,
	[h_StartDate] [datetime] NOT NULL,
	[DependencyUUID] [uniqueidentifier] NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[ParentUUID] [uniqueidentifier] NOT NULL,
	[ChildUUID] [uniqueidentifier] NOT NULL,
	[PersonUUID] [uniqueidentifier] NOT NULL,
	[EndDate] [datetime] NULL,
 CONSTRAINT [PK_h_dependencies] PRIMARY KEY CLUSTERED 
(
	[h_DependencyUUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[h_persondata]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[h_persondata](
	[h_PersonDataID] [int] IDENTITY(1,1) NOT NULL,
	[h_PersonDataUUID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_h_persondata_h_PersonDataUUID]  DEFAULT (newid()),
	[h_StartDate] [datetime] NOT NULL CONSTRAINT [DF_h_persondata_h_StartDate]  DEFAULT (getutcdate()),
	[h_EndDate] [datetime] NULL,
	[PersonDataUUID] [uniqueidentifier] NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NULL,
	[PersonUUID] [uniqueidentifier] NOT NULL,
	[cn] [varchar](150) NULL,
	[givenName] [varchar](150) NULL,
	[sn] [varchar](150) NULL,
	[title] [varchar](150) NULL,
	[mail] [varchar](150) NULL,
	[distinguishedname] [varchar](500) NULL,
	[department] [varchar](150) NULL,
	[company] [varchar](150) NULL,
	[manageremployeeid] [int] NULL,
	[telephoneNumber] [varchar](50) NULL,
	[managerdistinguishedName] [varchar](500) NULL,
 CONSTRAINT [PK_h_persondata] PRIMARY KEY CLUSTERED 
(
	[h_PersonDataUUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[helptext]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[helptext](
	[HelpTextID] [int] IDENTITY(1,1) NOT NULL,
	[HelpTextUUID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_helptext_HelpTextUUID]  DEFAULT (newid()),
	[StartDate] [datetime] NOT NULL CONSTRAINT [DF_helptext_StartDate]  DEFAULT (getutcdate()),
	[EndDate] [datetime] NULL,
	[Template] [varchar](150) NOT NULL,
	[PersonUUID] [uniqueidentifier] NOT NULL,
	[HelpText] [nvarchar](max) NOT NULL,
	[urlA] [varchar](150) NOT NULL CONSTRAINT [DF_helptext_urlA]  DEFAULT ('Start'),
 CONSTRAINT [PK_helptext] PRIMARY KEY CLUSTERED 
(
	[HelpTextUUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[IdleVMReport]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[IdleVMReport](
	[IdleVMReportID] [int] IDENTITY(1,1) NOT NULL,
	[IdleVMReportUUID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_Table_1_IdleReportUUID]  DEFAULT (newid()),
	[ImportFile] [uniqueidentifier] NULL,
	[StartDate] [datetime] NOT NULL CONSTRAINT [DF_IdleVMReport_StartDate]  DEFAULT (getutcdate()),
	[Name] [varchar](50) NULL,
	[Policy_Name] [varchar](50) NULL,
	[CPU_Idle_Time] [numeric](18, 3) NULL,
	[Network_IO_Idle_Time] [numeric](18, 3) NULL,
	[Disk_IO_Idle_Time] [numeric](18, 3) NULL,
	[Disk_Space_Usable_Capacity_GB] [numeric](18, 3) NULL,
	[Memory_Consumed_GB] [numeric](18, 3) NULL,
 CONSTRAINT [PK_IdleVMReport] PRIMARY KEY CLUSTERED 
(
	[IdleVMReportUUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[logs]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[logs](
	[LogID] [int] IDENTITY(1,1) NOT NULL,
	[LogUUID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_logs_LogUUID]  DEFAULT (newid()),
	[StartDate] [datetime] NOT NULL CONSTRAINT [DF_logs_StartDate]  DEFAULT (getutcdate()),
	[PersonUUID] [uniqueidentifier] NOT NULL,
	[IPNumber] [varchar](15) NULL,
 CONSTRAINT [PK_logs] PRIMARY KEY CLUSTERED 
(
	[LogUUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[manufacturers]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[manufacturers](
	[ManufacturerID] [int] IDENTITY(1,1) NOT NULL,
	[ManufacturerUUID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_dc_manufacturers_dcManufacturerUUID]  DEFAULT (newid()),
	[StartDate] [datetime] NOT NULL CONSTRAINT [DF_dc_manufacturers_StartDate]  DEFAULT (getutcdate()),
	[EndDate] [datetime] NULL,
	[manufacturer] [varchar](50) NOT NULL,
 CONSTRAINT [PK_dc_manufacturers] PRIMARY KEY CLUSTERED 
(
	[ManufacturerUUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[oversized_servers]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[oversized_servers](
	[OverSizedID] [int] IDENTITY(1,1) NOT NULL,
	[OverSizedUUID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_oversized_servers_OverSizedUUID]  DEFAULT (newid()),
	[StartDate] [datetime] NOT NULL CONSTRAINT [DF_oversized_servers_StartDate]  DEFAULT (getutcdate()),
	[EndDate] [datetime] NULL,
	[ServerName] [varchar](50) NULL,
	[Policy] [varchar](50) NULL,
	[CPUProvisioned] [int] NULL,
	[CPURecommendation] [int] NULL,
	[CPUReclaimable] [int] NULL,
	[MemoryProvisioned] [numeric](8, 3) NULL,
	[MemoryRecommendation] [numeric](8, 3) NULL,
	[MemoryReclaimable] [numeric](8, 3) NULL,
	[DiskSpaceProvisioned] [numeric](8, 3) NULL,
	[DiskSpaceRecommendation] [numeric](8, 3) NULL,
	[DiskSpaceReclaimable] [numeric](8, 3) NULL,
 CONSTRAINT [PK_oversized_servers] PRIMARY KEY CLUSTERED 
(
	[OverSizedUUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[pci_validation]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pci_validation](
	[PCIValidationID] [int] IDENTITY(1,1) NOT NULL,
	[PCIValidationUUID] [uniqueidentifier] NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[ApplicationUUID] [uniqueidentifier] NOT NULL,
	[PersonUUID] [uniqueidentifier] NOT NULL,
	[IPAddress] [nvarchar](15) NULL,
 CONSTRAINT [PK_pci_validation] PRIMARY KEY CLUSTERED 
(
	[PCIValidationUUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[pci_validation_date]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pci_validation_date](
	[PCIValidationDateID] [int] IDENTITY(1,1) NOT NULL,
	[PCIValidationDateUUID] [uniqueidentifier] NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NULL,
	[ApplicationUUID] [uniqueidentifier] NOT NULL,
	[DueDate] [datetime] NOT NULL,
 CONSTRAINT [PK_pci_validation_date] PRIMARY KEY CLUSTERED 
(
	[PCIValidationDateUUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[people_leaders]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[people_leaders](
	[PeopleMGRID] [int] IDENTITY(1,1) NOT NULL,
	[PeopleMGRUUID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_people_leaders_PeopleMGRUUID]  DEFAULT (newid()),
	[StartDate] [datetime] NOT NULL CONSTRAINT [DF_people_leaders_StartDate]  DEFAULT (getutcdate()),
	[EndDate] [date] NULL,
	[Title] [varchar](100) NOT NULL,
 CONSTRAINT [PK_people_leaders] PRIMARY KEY CLUSTERED 
(
	[PeopleMGRUUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[permissions]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[permissions](
	[PermissionID] [int] IDENTITY(1,1) NOT NULL,
	[PermissionUUID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_permissions_PermissionUUID]  DEFAULT (newid()),
	[StartDate] [datetime] NOT NULL CONSTRAINT [DF_permissions_StartDate]  DEFAULT (getutcdate()),
	[EndDate] [datetime] NULL,
	[PersonUUID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_permissions_PersonUUID]  DEFAULT (newid()),
	[God] [bit] NOT NULL CONSTRAINT [DF_permissions_God]  DEFAULT ((0)),
	[Add_New_App] [bit] NOT NULL CONSTRAINT [DF_permissions_Add_New_App]  DEFAULT ((1)),
	[Add_New_Application_Type] [bit] NOT NULL CONSTRAINT [DF_permissions_Add_New_Application_Type]  DEFAULT ((0)),
	[Add_Disaster_Recovery] [bit] NOT NULL CONSTRAINT [DF_permissions_Add_Disaster_Recovery]  DEFAULT ((0)),
	[Add_Payment_Card_Industry] [bit] NOT NULL CONSTRAINT [DF_permissions_Add_Payment_Card_Industry]  DEFAULT ((0)),
	[Manage_Application_Types] [bit] NOT NULL CONSTRAINT [DF_permissions_Manage_Application_Types]  DEFAULT ((0)),
	[Add_News_Articles] [bit] NOT NULL CONSTRAINT [DF_permissions_Add_News_Articles]  DEFAULT ((0)),
 CONSTRAINT [PK_permissions] PRIMARY KEY CLUSTERED 
(
	[PermissionUUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[persondata]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[persondata](
	[PersonDataID] [int] IDENTITY(1,1) NOT NULL,
	[PersonDataUUID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_persondata_PersonDataUUID]  DEFAULT (newid()),
	[StartDate] [datetime] NOT NULL CONSTRAINT [DF_persondata_StartDate]  DEFAULT (getutcdate()),
	[EndDate] [datetime] NULL,
	[PersonUUID] [uniqueidentifier] NOT NULL,
	[cn] [varchar](150) NULL,
	[givenName] [varchar](150) NULL,
	[sn] [varchar](150) NULL,
	[title] [varchar](150) NULL,
	[mail] [varchar](150) NULL,
	[distinguishedname] [varchar](500) NULL,
	[department] [varchar](150) NULL,
	[company] [varchar](150) NULL,
	[telephoneNumber] [varchar](50) NULL,
	[managerdistinguishedName] [varchar](250) NULL,
	[ManagerPersonUUID] [uniqueidentifier] NULL,
	[LastUpdate] [datetime] NULL,
	[memberOf] [varchar](max) NULL,
 CONSTRAINT [PK_persondata] PRIMARY KEY CLUSTERED 
(
	[PersonDataUUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[persons]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[persons](
	[PersonID] [int] IDENTITY(1,1) NOT NULL,
	[PersonUUID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_persons_PersonUUID]  DEFAULT (newid()),
	[StartDate] [datetime] NOT NULL CONSTRAINT [DF_persons_StartDate]  DEFAULT (getutcdate()),
	[EndDate] [datetime] NULL,
	[employeeID] [int] NOT NULL CONSTRAINT [DF_persons_employeeID]  DEFAULT ((0)),
	[sAMAccountName] [varchar](150) NULL,
	[Type] [char](1) NULL CONSTRAINT [DF_persons_Type]  DEFAULT ('U'),
	[PeopleLeader] [bit] NOT NULL CONSTRAINT [DF_persons_PeopleLeader]  DEFAULT ((0)),
	[LastUpdate] [datetime] NULL,
 CONSTRAINT [PK_persons] PRIMARY KEY CLUSTERED 
(
	[PersonUUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[pivot]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pivot](
	[i] [int] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[s_arrays]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[s_arrays](
	[sArrayID] [int] IDENTITY(1,1) NOT NULL,
	[sArrayUUID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_s_arrays_sArrayUUID]  DEFAULT (newid()),
	[StartDate] [datetime] NOT NULL CONSTRAINT [DF_s_arrays_StartDate]  DEFAULT (getutcdate()),
	[EndDate] [datetime] NULL,
	[SiteUUID] [uniqueidentifier] NULL,
	[ModuleUUID] [uniqueidentifier] NULL,
	[Array] [varchar](50) NOT NULL,
 CONSTRAINT [PK_s_arrays] PRIMARY KEY CLUSTERED 
(
	[sArrayUUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[s_poolstates]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[s_poolstates](
	[sPoolStateID] [int] IDENTITY(1,1) NOT NULL,
	[sPoolStateUUID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_s_poolstates_sPoolStateUUID]  DEFAULT (newid()),
	[StartDate] [datetime] NOT NULL CONSTRAINT [DF_s_poolstates_StartDate]  DEFAULT (getutcdate()),
	[EndDate] [datetime] NULL,
	[State] [varchar](50) NOT NULL,
 CONSTRAINT [PK_s_poolstates] PRIMARY KEY CLUSTERED 
(
	[sPoolStateUUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[s_status]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[s_status](
	[StorageStatusID] [int] IDENTITY(1,1) NOT NULL,
	[StorageStatusUUID] [uniqueidentifier] NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NULL,
	[Status] [varchar](50) NOT NULL,
 CONSTRAINT [PK_storage_status] PRIMARY KEY CLUSTERED 
(
	[StorageStatusUUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[s_statuses]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[s_statuses](
	[sStatusID] [int] IDENTITY(1,1) NOT NULL,
	[sStatusUUID] [uniqueidentifier] NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NULL,
	[status] [varchar](50) NOT NULL,
 CONSTRAINT [PK_s_statuses] PRIMARY KEY CLUSTERED 
(
	[sStatusUUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[server_MetaData]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[server_MetaData](
	[serverMetaDataID] [int] IDENTITY(1,1) NOT NULL,
	[serverMetaDataUUID] [uniqueidentifier] NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NULL,
	[ServerUUID] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_server_MetaData] PRIMARY KEY CLUSTERED 
(
	[serverMetaDataUUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[servers]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[servers](
	[ServerID] [int] IDENTITY(1,1) NOT NULL,
	[ServerUUID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_servers_ServerUUID]  DEFAULT (newid()),
	[StartDate] [datetime] NOT NULL CONSTRAINT [DF_servers_StartDate]  DEFAULT (getutcdate()),
	[EndDate] [datetime] NULL,
	[ServerName] [varchar](50) NOT NULL,
	[vCenterUUID] [uniqueidentifier] NULL,
 CONSTRAINT [PK_servers] PRIMARY KEY CLUSTERED 
(
	[ServerUUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[settings]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[settings](
	[settingsID] [int] IDENTITY(1,1) NOT NULL,
	[settingsUUID] [uniqueidentifier] NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NULL,
	[AllowGodBypass] [bit] NOT NULL,
 CONSTRAINT [PK_settings] PRIMARY KEY CLUSTERED 
(
	[settingsUUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[site_news]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[site_news](
	[newsID] [int] IDENTITY(1,1) NOT NULL,
	[newsUUID] [uniqueidentifier] NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NULL,
	[PersonUUID] [uniqueidentifier] NOT NULL,
	[NewsText] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_site_news] PRIMARY KEY CLUSTERED 
(
	[newsUUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[site_purposes]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[site_purposes](
	[SitePurposeID] [int] IDENTITY(1,1) NOT NULL,
	[SitePurposeUUID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_site_purposes_SitePurposeUUID]  DEFAULT (newid()),
	[StartDate] [datetime] NOT NULL CONSTRAINT [DF_site_purposes_StartDate]  DEFAULT (getutcdate()),
	[EndDate] [datetime] NULL,
	[SitePurpose] [varchar](50) NOT NULL,
 CONSTRAINT [PK_site_purposes] PRIMARY KEY CLUSTERED 
(
	[SitePurposeUUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[sites]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[sites](
	[SiteID] [int] IDENTITY(1,1) NOT NULL,
	[SiteUUID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_sites_SiteUUID]  DEFAULT (newid()),
	[StartDate] [datetime] NOT NULL CONSTRAINT [DF_sites_StartDate]  DEFAULT (getutcdate()),
	[EndDate] [datetime] NULL,
	[SiteName] [varchar](50) NOT NULL,
	[SitePurposeUUID] [uniqueidentifier] NULL,
 CONSTRAINT [PK_sites] PRIMARY KEY CLUSTERED 
(
	[SiteUUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[sox_validation]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[sox_validation](
	[SOXValidationID] [int] IDENTITY(1,1) NOT NULL,
	[SOXValidationUUID] [uniqueidentifier] NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[ApplicationUUID] [uniqueidentifier] NOT NULL,
	[PersonUUID] [uniqueidentifier] NOT NULL,
	[IPAddress] [nvarchar](15) NULL,
 CONSTRAINT [PK_sox_validation] PRIMARY KEY CLUSTERED 
(
	[SOXValidationUUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[sox_validation_date]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[sox_validation_date](
	[SOXValidationDateID] [int] IDENTITY(1,1) NOT NULL,
	[SOXValidationDateUUID] [uniqueidentifier] NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NULL,
	[ApplicationUUID] [uniqueidentifier] NOT NULL,
	[DueDate] [datetime] NOT NULL,
 CONSTRAINT [PK_sox_validation_date] PRIMARY KEY CLUSTERED 
(
	[SOXValidationDateUUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[sweetalerts]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[sweetalerts](
	[SweetAlertID] [int] IDENTITY(1,1) NOT NULL,
	[SweetAlertUUID] [uniqueidentifier] NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NULL,
 CONSTRAINT [PK_sweetalerts] PRIMARY KEY CLUSTERED 
(
	[SweetAlertUUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[technologies]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[technologies](
	[technologyID] [int] IDENTITY(1,1) NOT NULL,
	[technologyUUID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_technologies_technologyUUID]  DEFAULT (newid()),
	[StartDate] [datetime] NOT NULL CONSTRAINT [DF_technologies_StartDate]  DEFAULT (getutcdate()),
	[EndDate] [datetime] NULL,
	[Technology] [varchar](150) NOT NULL,
	[WikiURL] [varchar](150) NULL,
	[GITURL] [varchar](150) NULL,
	[Notes] [varchar](250) NULL,
	[TechnologyURL] [varchar](150) NULL,
 CONSTRAINT [PK_technologies] PRIMARY KEY CLUSTERED 
(
	[technologyUUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[timemasks]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[timemasks](
	[TimeMaskID] [int] IDENTITY(1,1) NOT NULL,
	[TimeMaskUUID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_timemasks_TimeMaskUUID]  DEFAULT (newid()),
	[StartDate] [datetime] NOT NULL CONSTRAINT [DF_timemasks_StartDate]  DEFAULT (getutcdate()),
	[EndDate] [datetime] NULL,
	[TimeMask] [varchar](50) NOT NULL CONSTRAINT [DF_timemasks_TimeMask]  DEFAULT ('h:m:s tt'),
	[TimeMaskExample] [varchar](50) NOT NULL CONSTRAINT [DF_timemasks_TimeMaskExample]  DEFAULT ('1:1:1 AM'),
 CONSTRAINT [PK_timemasks] PRIMARY KEY CLUSTERED 
(
	[TimeMaskUUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[vCenter_Servers]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[vCenter_Servers](
	[vCenterID] [int] IDENTITY(1,1) NOT NULL,
	[vCenterUUID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_vCenter_Servers_vCenterUUID]  DEFAULT (newid()),
	[StartDate] [datetime] NOT NULL CONSTRAINT [DF_vCenter_Servers_StartDate]  DEFAULT (getutcdate()),
	[EndDate] [datetime] NULL,
	[vCenterHostName] [varchar](150) NOT NULL,
	[vCenterIP] [varchar](50) NULL,
	[SiteUUID] [uniqueidentifier] NULL,
 CONSTRAINT [PK_vCenter_Servers] PRIMARY KEY CLUSTERED 
(
	[vCenterUUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[vCenterImports]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[vCenterImports](
	[vCenterImportID] [int] IDENTITY(1,1) NOT NULL,
	[vCenterImportUUID] [uniqueidentifier] NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NULL,
	[vCenterUUID] [uniqueidentifier] NOT NULL,
	[ServerDumpFile] [varbinary](max) NULL,
 CONSTRAINT [PK_vCenterImports] PRIMARY KEY CLUSTERED 
(
	[vCenterImportUUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  View [dbo].[view_ActiveApplications]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[view_ActiveApplications]
	AS
SELECT TOP 100 PERCENT dbo.application_types.ApplicationType, dbo.applications.ApplicationName, dbo.applications.ApplicationUUID, dbo.persons.sAMAccountName
FROM     dbo.application_owners INNER JOIN
                  dbo.applications ON dbo.application_owners.ApplicationUUID = dbo.applications.ApplicationUUID INNER JOIN
                  dbo.application_types ON dbo.applications.ApplicationTypeUUID = dbo.application_types.ApplicationTypeUUID INNER JOIN
                  dbo.persons ON dbo.application_owners.PersonUUID = dbo.persons.PersonUUID
WHERE  (dbo.applications.EndDate IS NULL)
ORDER BY dbo.applications.ApplicationName
GO
/****** Object:  Index [persondataEndDate_NCidx]    Script Date: 10/27/2015 4:19:17 PM ******/
CREATE NONCLUSTERED INDEX [persondataEndDate_NCidx] ON [dbo].[persondata]
(
	[EndDate] ASC
)
INCLUDE ( 	[PersonUUID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[active_directory_memberships] ADD  CONSTRAINT [DF_active_directory_memberships_memberofUUID]  DEFAULT (newid()) FOR [memberofUUID]
GO
ALTER TABLE [dbo].[active_directory_memberships] ADD  CONSTRAINT [DF_active_directory_memberships_StartDate]  DEFAULT (getutcdate()) FOR [StartDate]
GO
ALTER TABLE [dbo].[application_compliance] ADD  CONSTRAINT [DF_application_compliance_applicationComplianceUUID]  DEFAULT (newid()) FOR [applicationComplianceUUID]
GO
ALTER TABLE [dbo].[application_compliance] ADD  CONSTRAINT [DF_application_compliance_StartDate]  DEFAULT (getutcdate()) FOR [StartDate]
GO
ALTER TABLE [dbo].[application_notes] ADD  CONSTRAINT [DF_application_notes_ApplicationNoteUUID]  DEFAULT (newid()) FOR [ApplicationNoteUUID]
GO
ALTER TABLE [dbo].[application_notes] ADD  CONSTRAINT [DF_application_notes_StartDate]  DEFAULT (getutcdate()) FOR [StartDate]
GO
ALTER TABLE [dbo].[application_notes] ADD  CONSTRAINT [DF_application_notes_ApplicationUUID]  DEFAULT (newid()) FOR [ApplicationUUID]
GO
ALTER TABLE [dbo].[approve_application_owner_change] ADD  CONSTRAINT [DF_approve_application_owner_change_ApprovalApplicationOwnerUUID]  DEFAULT (newid()) FOR [ApprovalApplicationOwnerUUID]
GO
ALTER TABLE [dbo].[approve_application_owner_change] ADD  CONSTRAINT [DF_approve_application_owner_change_StartDate]  DEFAULT (getutcdate()) FOR [StartDate]
GO
ALTER TABLE [dbo].[disclaimers] ADD  CONSTRAINT [DF_disclaimers_disclaimerUUID]  DEFAULT (newid()) FOR [disclaimerUUID]
GO
ALTER TABLE [dbo].[disclaimers] ADD  CONSTRAINT [DF_disclaimers_StartDate]  DEFAULT (getutcdate()) FOR [StartDate]
GO
ALTER TABLE [dbo].[dr_server_details] ADD  CONSTRAINT [DF_dr_server_details_DRDetailsUUID]  DEFAULT (newid()) FOR [DRDetailsUUID]
GO
ALTER TABLE [dbo].[dr_server_details] ADD  CONSTRAINT [DF_dr_server_details_StartDate]  DEFAULT (getutcdate()) FOR [StartDate]
GO
ALTER TABLE [dbo].[dr_servers] ADD  CONSTRAINT [DF_dr_servers_StartDate]  DEFAULT (getutcdate()) FOR [StartDate]
GO
ALTER TABLE [dbo].[dr_servers] ADD  CONSTRAINT [DF_dr_servers_ServerUUID]  DEFAULT (newid()) FOR [ServerUUID]
GO
ALTER TABLE [dbo].[dr_validation] ADD  CONSTRAINT [DF_dr_validation_DRValidationUUID]  DEFAULT (newid()) FOR [DRValidationUUID]
GO
ALTER TABLE [dbo].[dr_validation_date] ADD  CONSTRAINT [DF_dr_validation_date_DRValidationDateUUID]  DEFAULT (newid()) FOR [DRValidationDateUUID]
GO
ALTER TABLE [dbo].[dr_validation_date] ADD  CONSTRAINT [DF_dr_validation_date_StartDate]  DEFAULT (getutcdate()) FOR [StartDate]
GO
ALTER TABLE [dbo].[file_permissions] ADD  CONSTRAINT [DF_file_permissions_FilePermissionUUID]  DEFAULT (newid()) FOR [FilePermissionUUID]
GO
ALTER TABLE [dbo].[file_permissions] ADD  CONSTRAINT [DF_file_permissions_StartDate]  DEFAULT (getutcdate()) FOR [StartDate]
GO
ALTER TABLE [dbo].[h_applications] ADD  CONSTRAINT [DF_h_applications_h_ApplicationUUID]  DEFAULT (newid()) FOR [h_ApplicationUUID]
GO
ALTER TABLE [dbo].[h_applications] ADD  CONSTRAINT [DF_h_applications_h_StartDate]  DEFAULT (getutcdate()) FOR [h_StartDate]
GO
ALTER TABLE [dbo].[h_dependencies] ADD  CONSTRAINT [DF_h_dependencies_h_DependencyUUID]  DEFAULT (newid()) FOR [h_DependencyUUID]
GO
ALTER TABLE [dbo].[h_dependencies] ADD  CONSTRAINT [DF_h_dependencies_h_StartDate]  DEFAULT (getutcdate()) FOR [h_StartDate]
GO
ALTER TABLE [dbo].[h_dependencies] ADD  CONSTRAINT [DF_h_dependencies_DependencyUUID]  DEFAULT (newid()) FOR [DependencyUUID]
GO
ALTER TABLE [dbo].[pci_validation] ADD  CONSTRAINT [DF_pci_validation_PCIValidationUUID]  DEFAULT (newid()) FOR [PCIValidationUUID]
GO
ALTER TABLE [dbo].[pci_validation] ADD  CONSTRAINT [DF_pci_validation_StartDate]  DEFAULT (getutcdate()) FOR [StartDate]
GO
ALTER TABLE [dbo].[pci_validation_date] ADD  CONSTRAINT [DF_pci_validation_date_PCIValidationDateUUID]  DEFAULT (newid()) FOR [PCIValidationDateUUID]
GO
ALTER TABLE [dbo].[pci_validation_date] ADD  CONSTRAINT [DF_pci_validation_date_StartDate]  DEFAULT (getutcdate()) FOR [StartDate]
GO
ALTER TABLE [dbo].[s_status] ADD  CONSTRAINT [DF_storage_status_StorageStatusUUID]  DEFAULT (newid()) FOR [StorageStatusUUID]
GO
ALTER TABLE [dbo].[s_status] ADD  CONSTRAINT [DF_storage_status_StartDate]  DEFAULT (getutcdate()) FOR [StartDate]
GO
ALTER TABLE [dbo].[s_statuses] ADD  CONSTRAINT [DF_s_statuses_sStatusUUID]  DEFAULT (newid()) FOR [sStatusUUID]
GO
ALTER TABLE [dbo].[s_statuses] ADD  CONSTRAINT [DF_s_statuses_StartDate]  DEFAULT (getutcdate()) FOR [StartDate]
GO
ALTER TABLE [dbo].[server_MetaData] ADD  CONSTRAINT [DF_server_MetaData_serverMetaDataUUID]  DEFAULT (newid()) FOR [serverMetaDataUUID]
GO
ALTER TABLE [dbo].[server_MetaData] ADD  CONSTRAINT [DF_server_MetaData_StartDate]  DEFAULT (getutcdate()) FOR [StartDate]
GO
ALTER TABLE [dbo].[settings] ADD  CONSTRAINT [DF_settings_settingsUUID]  DEFAULT (newid()) FOR [settingsUUID]
GO
ALTER TABLE [dbo].[settings] ADD  CONSTRAINT [DF_settings_StartDate]  DEFAULT (getutcdate()) FOR [StartDate]
GO
ALTER TABLE [dbo].[site_news] ADD  CONSTRAINT [DF_site_news_newsUUID]  DEFAULT (newid()) FOR [newsUUID]
GO
ALTER TABLE [dbo].[site_news] ADD  CONSTRAINT [DF_site_news_StartDate]  DEFAULT (getutcdate()) FOR [StartDate]
GO
ALTER TABLE [dbo].[sox_validation] ADD  CONSTRAINT [DF_sox_validation_SOXValidationUUID]  DEFAULT (newid()) FOR [SOXValidationUUID]
GO
ALTER TABLE [dbo].[sox_validation] ADD  CONSTRAINT [DF_sox_validation_StartDate]  DEFAULT (getutcdate()) FOR [StartDate]
GO
ALTER TABLE [dbo].[sox_validation_date] ADD  CONSTRAINT [DF_sox_validation_date_SOXValidationUUID]  DEFAULT (newid()) FOR [SOXValidationDateUUID]
GO
ALTER TABLE [dbo].[sox_validation_date] ADD  CONSTRAINT [DF_sox_validation_date_StartDate]  DEFAULT (getutcdate()) FOR [StartDate]
GO
ALTER TABLE [dbo].[sweetalerts] ADD  CONSTRAINT [DF_sweetalerts_SweetAlertUUID]  DEFAULT (newid()) FOR [SweetAlertUUID]
GO
ALTER TABLE [dbo].[sweetalerts] ADD  CONSTRAINT [DF_sweetalerts_StartDate]  DEFAULT (getutcdate()) FOR [StartDate]
GO
ALTER TABLE [dbo].[vCenterImports] ADD  CONSTRAINT [DF_vCenterImports_vCenterImportUUID]  DEFAULT (newid()) FOR [vCenterImportUUID]
GO
ALTER TABLE [dbo].[vCenterImports] ADD  CONSTRAINT [DF_vCenterImports_StartDate]  DEFAULT (getutcdate()) FOR [StartDate]
GO
ALTER TABLE [dbo].[active_directory_members]  WITH CHECK ADD  CONSTRAINT [FK_active_directory_members_active_directory_groups] FOREIGN KEY([ADGroupUUID])
REFERENCES [dbo].[active_directory_groups] ([ADGroupUUID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[active_directory_members] CHECK CONSTRAINT [FK_active_directory_members_active_directory_groups]
GO
ALTER TABLE [dbo].[active_directory_members]  WITH CHECK ADD  CONSTRAINT [FK_active_directory_members_persons] FOREIGN KEY([PersonUUID])
REFERENCES [dbo].[persons] ([PersonUUID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[active_directory_members] CHECK CONSTRAINT [FK_active_directory_members_persons]
GO
ALTER TABLE [dbo].[application_files]  WITH CHECK ADD  CONSTRAINT [FK_application_files_applications] FOREIGN KEY([ApplicationUUID])
REFERENCES [dbo].[applications] ([ApplicationUUID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[application_files] CHECK CONSTRAINT [FK_application_files_applications]
GO
ALTER TABLE [dbo].[application_files]  WITH CHECK ADD  CONSTRAINT [FK_application_files_files] FOREIGN KEY([FileUUID])
REFERENCES [dbo].[files] ([FileUUID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[application_files] CHECK CONSTRAINT [FK_application_files_files]
GO
ALTER TABLE [dbo].[application_notes]  WITH CHECK ADD  CONSTRAINT [FK_application_notes_applications] FOREIGN KEY([ApplicationUUID])
REFERENCES [dbo].[applications] ([ApplicationUUID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[application_notes] CHECK CONSTRAINT [FK_application_notes_applications]
GO
ALTER TABLE [dbo].[application_owners]  WITH CHECK ADD  CONSTRAINT [FK_application_owners_applications] FOREIGN KEY([ApplicationUUID])
REFERENCES [dbo].[applications] ([ApplicationUUID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[application_owners] CHECK CONSTRAINT [FK_application_owners_applications]
GO
ALTER TABLE [dbo].[application_types]  WITH CHECK ADD  CONSTRAINT [FK_application_types_companies] FOREIGN KEY([CompanyUUID])
REFERENCES [dbo].[companies] ([CompanyUUID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[application_types] CHECK CONSTRAINT [FK_application_types_companies]
GO
ALTER TABLE [dbo].[bk]  WITH CHECK ADD  CONSTRAINT [FK_bk_persons] FOREIGN KEY([PersonUUID])
REFERENCES [dbo].[persons] ([PersonUUID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[bk] CHECK CONSTRAINT [FK_bk_persons]
GO
ALTER TABLE [dbo].[dc_cabinets]  WITH CHECK ADD  CONSTRAINT [FK_dc_cabinets_dc_modules] FOREIGN KEY([dcmoduleUUID])
REFERENCES [dbo].[dc_modules] ([dcModuleUUID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[dc_cabinets] CHECK CONSTRAINT [FK_dc_cabinets_dc_modules]
GO
ALTER TABLE [dbo].[dc_cabinets]  WITH CHECK ADD  CONSTRAINT [FK_dc_cabinets_manufacturers] FOREIGN KEY([manufacturerUUID])
REFERENCES [dbo].[manufacturers] ([ManufacturerUUID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[dc_cabinets] CHECK CONSTRAINT [FK_dc_cabinets_manufacturers]
GO
ALTER TABLE [dbo].[dc_modules]  WITH CHECK ADD  CONSTRAINT [FK_dc_modules_sites] FOREIGN KEY([siteUUID])
REFERENCES [dbo].[sites] ([SiteUUID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[dc_modules] CHECK CONSTRAINT [FK_dc_modules_sites]
GO
ALTER TABLE [dbo].[dependencies]  WITH CHECK ADD  CONSTRAINT [FK_dependencies_persons] FOREIGN KEY([PersonUUID])
REFERENCES [dbo].[persons] ([PersonUUID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[dependencies] CHECK CONSTRAINT [FK_dependencies_persons]
GO
ALTER TABLE [dbo].[dr_validation]  WITH CHECK ADD  CONSTRAINT [FK_dr_validation_applications] FOREIGN KEY([ApplicationUUID])
REFERENCES [dbo].[applications] ([ApplicationUUID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[dr_validation] CHECK CONSTRAINT [FK_dr_validation_applications]
GO
ALTER TABLE [dbo].[dr_validation]  WITH CHECK ADD  CONSTRAINT [FK_dr_validation_persons] FOREIGN KEY([PersonUUID])
REFERENCES [dbo].[persons] ([PersonUUID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[dr_validation] CHECK CONSTRAINT [FK_dr_validation_persons]
GO
ALTER TABLE [dbo].[dr_validation_date]  WITH CHECK ADD  CONSTRAINT [FK_dr_validation_date_applications] FOREIGN KEY([ApplicationUUID])
REFERENCES [dbo].[applications] ([ApplicationUUID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[dr_validation_date] CHECK CONSTRAINT [FK_dr_validation_date_applications]
GO
ALTER TABLE [dbo].[file_permissions]  WITH CHECK ADD  CONSTRAINT [FK_file_permissions_active_directory_groups] FOREIGN KEY([ADGroupUUID])
REFERENCES [dbo].[active_directory_groups] ([ADGroupUUID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[file_permissions] CHECK CONSTRAINT [FK_file_permissions_active_directory_groups]
GO
ALTER TABLE [dbo].[file_permissions]  WITH CHECK ADD  CONSTRAINT [FK_file_permissions_files] FOREIGN KEY([FileUUID])
REFERENCES [dbo].[files] ([FileUUID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[file_permissions] CHECK CONSTRAINT [FK_file_permissions_files]
GO
ALTER TABLE [dbo].[files]  WITH CHECK ADD  CONSTRAINT [FK_files_persons] FOREIGN KEY([PersonUUID])
REFERENCES [dbo].[persons] ([PersonUUID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[files] CHECK CONSTRAINT [FK_files_persons]
GO
ALTER TABLE [dbo].[pci_validation]  WITH CHECK ADD  CONSTRAINT [FK_pci_validation_applications] FOREIGN KEY([ApplicationUUID])
REFERENCES [dbo].[applications] ([ApplicationUUID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[pci_validation] CHECK CONSTRAINT [FK_pci_validation_applications]
GO
ALTER TABLE [dbo].[pci_validation]  WITH CHECK ADD  CONSTRAINT [FK_pci_validation_persons] FOREIGN KEY([PersonUUID])
REFERENCES [dbo].[persons] ([PersonUUID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[pci_validation] CHECK CONSTRAINT [FK_pci_validation_persons]
GO
ALTER TABLE [dbo].[pci_validation_date]  WITH CHECK ADD  CONSTRAINT [FK_pci_validation_date_applications] FOREIGN KEY([ApplicationUUID])
REFERENCES [dbo].[applications] ([ApplicationUUID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[pci_validation_date] CHECK CONSTRAINT [FK_pci_validation_date_applications]
GO
ALTER TABLE [dbo].[permissions]  WITH CHECK ADD  CONSTRAINT [FK_permissions_persons] FOREIGN KEY([PersonUUID])
REFERENCES [dbo].[persons] ([PersonUUID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[permissions] CHECK CONSTRAINT [FK_permissions_persons]
GO
ALTER TABLE [dbo].[persondata]  WITH CHECK ADD  CONSTRAINT [FK_persondata_persons] FOREIGN KEY([PersonUUID])
REFERENCES [dbo].[persons] ([PersonUUID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[persondata] CHECK CONSTRAINT [FK_persondata_persons]
GO
ALTER TABLE [dbo].[site_news]  WITH CHECK ADD  CONSTRAINT [FK_site_news_persons] FOREIGN KEY([PersonUUID])
REFERENCES [dbo].[persons] ([PersonUUID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[site_news] CHECK CONSTRAINT [FK_site_news_persons]
GO
ALTER TABLE [dbo].[sites]  WITH CHECK ADD  CONSTRAINT [FK_sites_site_purposes] FOREIGN KEY([SitePurposeUUID])
REFERENCES [dbo].[site_purposes] ([SitePurposeUUID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[sites] CHECK CONSTRAINT [FK_sites_site_purposes]
GO
ALTER TABLE [dbo].[sox_validation]  WITH CHECK ADD  CONSTRAINT [FK_sox_validation_applications] FOREIGN KEY([ApplicationUUID])
REFERENCES [dbo].[applications] ([ApplicationUUID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[sox_validation] CHECK CONSTRAINT [FK_sox_validation_applications]
GO
ALTER TABLE [dbo].[sox_validation]  WITH CHECK ADD  CONSTRAINT [FK_sox_validation_persons] FOREIGN KEY([PersonUUID])
REFERENCES [dbo].[persons] ([PersonUUID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[sox_validation] CHECK CONSTRAINT [FK_sox_validation_persons]
GO
ALTER TABLE [dbo].[sox_validation_date]  WITH CHECK ADD  CONSTRAINT [FK_sox_validation_date_applications] FOREIGN KEY([ApplicationUUID])
REFERENCES [dbo].[applications] ([ApplicationUUID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[sox_validation_date] CHECK CONSTRAINT [FK_sox_validation_date_applications]
GO
/****** Object:  StoredProcedure [dbo].[sp_APIGetAppNameAppUUID]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_APIGetAppNameAppUUID]
AS
BEGIN

	SET NOCOUNT ON;
	SELECT ApplicationName, ApplicationUUID
		FROM Applications
	WHERE EndDate IS NULL
	ORDER BY ApplicationName ASC
END

GO
/****** Object:  StoredProcedure [dbo].[sp_APIGetAppsWithDetails]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_APIGetAppsWithDetails]
AS
BEGIN

	SET NOCOUNT ON;
SELECT applications.StartDate, applications.ApplicationName, applications.ApplicationUUID, applications.PCI, applications.DR, applications.ProductionSiteUUID, applications.DRSiteUUID, applications.ApplicationDescription,
                  persons.sAMAccountName, persons.PersonUUID, sites.SiteName
FROM     applications INNER JOIN
                  application_owners ON applications.ApplicationUUID = application_owners.ApplicationUUID INNER JOIN
                  persons ON application_owners.PersonUUID = persons.PersonUUID INNER JOIN
                  sites ON applications.ProductionSiteUUID = sites.SiteUUID
WHERE  (applications.EndDate IS NULL)
ORDER BY applications.ApplicationName
END

GO
/****** Object:  StoredProcedure [dbo].[sp_APIKeyCheck]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_APIKeyCheck]
				@PublicKey UniqueIdentifier
AS
BEGIN

	SET NOCOUNT ON;
	SELECT COUNT(*) AS TCount
		FROM [dbo].[api_consumers]
	WHERE PublicKey = @PublicKey
	AND EndDate > (getUTCDate())
END

GO
/****** Object:  StoredProcedure [dbo].[sp_CheckPersonRecordBySamAccountName]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_CheckPersonRecordBySamAccountName]
	@SamAccountName varChar(150)
AS
BEGIN
	SET NOCOUNT ON;
				SELECT SamAccountName, PersonUUID
					FROM [dbo].[persons]
				WHERE SamAccountName = @SamAccountName
				AND EndDate IS NULL
END

GO
/****** Object:  StoredProcedure [dbo].[sp_Get30DayDR]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_Get30DayDR]
AS
BEGIN
	SET NOCOUNT ON;
		SELECT COUNT(*) AS TCount
			FROM dr_validation_date
		WHERE DueDate BETWEEN (getUTCDate()) AND (DATEADD(day,30,getUTCDate()))
END

GO
/****** Object:  StoredProcedure [dbo].[sp_Get30DayPCI]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_Get30DayPCI]
AS
BEGIN
	SET NOCOUNT ON;
		SELECT COUNT(*) AS TCount
			FROM pci_validation_date
		WHERE DueDate BETWEEN (getUTCDate()) AND (DATEADD(day,30,getUTCDate()))
END

GO
/****** Object:  StoredProcedure [dbo].[sp_Get60DayDR]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_Get60DayDR]
AS
BEGIN
	SET NOCOUNT ON;
		SELECT COUNT(*) AS TCount
			FROM dr_validation_date
		WHERE DueDate BETWEEN (getUTCDate()) AND (DATEADD(day,60,getUTCDate()))
END

GO
/****** Object:  StoredProcedure [dbo].[sp_Get60DayPCI]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_Get60DayPCI]
AS
BEGIN
	SET NOCOUNT ON;
		SELECT COUNT(*) AS TCount
			FROM pci_validation_date
		WHERE DueDate BETWEEN (DATEADD(day,31,getUTCDate())) AND (DATEADD(day,60,getUTCDate()))
END

GO
/****** Object:  StoredProcedure [dbo].[sp_Get90DayDR]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_Get90DayDR]
AS
BEGIN
	SET NOCOUNT ON;
		SELECT COUNT(*) AS TCount
			FROM dr_validation_date
		WHERE DueDate BETWEEN (getUTCDate()) AND (DATEADD(day,90,getUTCDate()))
END

GO
/****** Object:  StoredProcedure [dbo].[sp_Get90DayPCI]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_Get90DayPCI]
AS
BEGIN
	SET NOCOUNT ON;
		SELECT COUNT(*) AS TCount
			FROM pci_validation_date
		WHERE DueDate BETWEEN (DATEADD(day,61,getUTCDate())) AND (DATEADD(day,90,getUTCDate()))
END

GO
/****** Object:  StoredProcedure [dbo].[sp_GetActiveADGroups]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetActiveADGroups]

AS
BEGIN
SELECT P.PersonUUID, ADG.ADGroupUUID, ADG.SamAccountName, ADG.mail, ADG.StartDate
FROM     active_directory_groups ADG INNER JOIN
                  persons P ON ADG.SamAccountName = P.sAMAccountName
WHERE ADG.EndDate IS NULL
ORDER BY ADG.SamAccountName ASC
END

GO
/****** Object:  StoredProcedure [dbo].[sp_GetActiveAppCountByPersonUUID]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_GetActiveAppCountByPersonUUID]
					@PersonUUID UniqueIdentifier
AS
BEGIN
	SET NOCOUNT ON;
		SELECT COUNT(*) AS TCount
			FROM [dbo].[application_owners]
		WHERE PersonUUID = @PersonUUID
		AND EndDate IS NULL
END

GO
/****** Object:  StoredProcedure [dbo].[sp_GetActiveDirectoryGroups]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_GetActiveDirectoryGroups] 
AS
BEGIN
	SET NOCOUNT ON;
	SELECT ADGroupUUID, SamAccountName, CN
		FROM [dbo].[active_directory_groups]
	WHERE EndDate IS NULL
	ORDER BY CN ASC
END

GO
/****** Object:  StoredProcedure [dbo].[sp_GetADGroupsByApplicationUUID]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_GetADGroupsByApplicationUUID]
					@ApplicationUUID UniqueIdentifier
AS
BEGIN

	SET NOCOUNT ON;
				SELECT ADGroupUUID
					FROM application_owners
				WHERE ApplicationUUID = @ApplicationUUID
				AND ADGroupUUID IS NOT NULL
				AND EndDate IS NULL
END

GO
/****** Object:  StoredProcedure [dbo].[sp_GetADMembershipsByPersonUUID]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_GetADMembershipsByPersonUUID]
					@PersonUUID UniqueIdentifier
AS
BEGIN
	SET NOCOUNT ON;
		SELECT active_directory_groups.SamAccountName, active_directory_groups.ADGroupUUID
		FROM     active_directory_groups INNER JOIN
		                  active_directory_members ON active_directory_groups.ADGroupUUID = active_directory_members.ADGroupUUID
		WHERE active_directory_members.PersonUUID = @PersonUUID
		ORDER BY active_directory_groups.SamAccountName ASC
END

GO
/****** Object:  StoredProcedure [dbo].[sp_GetAllActiveApps]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_GetAllActiveApps]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
		SELECT applications.ApplicationName, applications.ApplicationDescription, persondata.cn, application_types.ApplicationType, persons.PersonUUID, 
		                  application_owners.ApplicationOwnerUUID, applications.ApplicationUUID, application_types.ApplicationTypeUUID, companies.CompanyName, 
		                  companies.CompanyUUID
		FROM     persons INNER JOIN
		                  persondata ON persons.PersonUUID = persondata.PersonUUID INNER JOIN
		                  application_owners INNER JOIN
		                  applications ON application_owners.ApplicationUUID = applications.ApplicationUUID ON persons.PersonUUID = application_owners.PersonUUID INNER JOIN
		                  application_types ON applications.ApplicationTypeUUID = application_types.ApplicationTypeUUID INNER JOIN
		                  companies ON applications.CompanyUUID = companies.CompanyUUID
		WHERE application_owners.OwnerType = 1
		AND applications.EndDate IS NULL
		ORDER BY applications.ApplicationName ASC
END

GO
/****** Object:  StoredProcedure [dbo].[sp_GetAllActiveAppsNameUUID]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_GetAllActiveAppsNameUUID]
AS
BEGIN
	SET NOCOUNT ON;
	SELECT ApplicationName, ApplicationUUID
		FROM [dbo].[applications]
	WHERE EndDate IS NULL
	ORDER BY ApplicationName ASC
END

GO
/****** Object:  StoredProcedure [dbo].[sp_GetAllActiveCompanies]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_GetAllActiveCompanies]
AS
BEGIN

	SET NOCOUNT ON;
				SELECT CompanyUUID, StartDate, CompanyName
					FROM companies
				WHERE EndDate IS NULL
				ORDER BY CompanyName ASC
END

GO
/****** Object:  StoredProcedure [dbo].[sp_GetAllActivePersonUUID]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetAllActivePersonUUID]

AS
BEGIN
	
				SELECT [PersonUUID]
					FROM [dbo].[persons]
				WHERE [EndDate] IS NULL
END

GO
/****** Object:  StoredProcedure [dbo].[sp_GetAllActiveTemplatesUUID]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetAllActiveTemplatesUUID]

AS
BEGIN
	
				SELECT [TemplateUUID]
					FROM [dbo].[templates]
				WHERE [EndDate] IS NULL
END

GO
/****** Object:  StoredProcedure [dbo].[sp_GetAllSMETypes]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_GetAllSMETypes]
AS
BEGIN
	SET NOCOUNT ON;
	SELECT [ApplicationSMETypeUUID], [SMEType]
		FROM [dbo].[application_sme_types]
	WHERE EndDate IS NULL
	ORDER BY [SMEType]
END

GO
/****** Object:  StoredProcedure [dbo].[sp_GetAlternateOwnerByApplicationUUID]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetAlternateOwnerByApplicationUUID]
					@ApplicationUUID UniqueIdentifier
AS
BEGIN
	SET NOCOUNT ON;
				SELECT persondata.personUUID, persondata.cn, persondata.mail
				FROM     application_owners INNER JOIN
				                  persondata ON application_owners.PersonUUID = persondata.PersonUUID
				WHERE application_owners.ApplicationUUID = @ApplicationUUID
				AND application_owners.EndDate IS NULL
				AND OwnerType = 0
				ORDER BY cn ASC
END

GO
/****** Object:  StoredProcedure [dbo].[sp_GetAppHistoryCountByApplicationUUID]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetAppHistoryCountByApplicationUUID]
					@ApplicationUUID UniqueIdentifier
AS
BEGIN
	SET NOCOUNT ON;
				SELECT COUNT(*) AS TCount
					FROM h_applications
				WHERE ApplicationUUID = @ApplicationUUID
END

GO
/****** Object:  StoredProcedure [dbo].[sp_GetApplicationDetailsByUUID]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[sp_GetApplicationDetailsByUUID] 
@AppUUID UniqueIdentifier
AS
SELECT application_owners.ApplicationOwnerID, application_owners.ApplicationOwnerUUID, application_owners.StartDate AS AOStartDate, application_owners.EndDate AS AOEndDate, 
                  application_owners.ApplicationUUID, application_owners.PersonUUID AS AOPersonUUID, application_owners.OwnerType, persondata.*, persons.*
FROM     application_owners INNER JOIN
                  persons ON application_owners.PersonUUID = persons.PersonUUID INNER JOIN
                  persondata ON persons.PersonUUID = persondata.PersonUUID
WHERE  (application_owners.ApplicationUUID = @AppUUID)
GO
/****** Object:  StoredProcedure [dbo].[sp_GetApplicationDetailsByUUID_2]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetApplicationDetailsByUUID_2]
				@ApplicationUUID UniqueIdentifier
AS
BEGIN
	SET NOCOUNT ON;
SELECT companies.CompanyName, change_priorities.ChangePriority, applications.ApplicationName, applications.ApplicationDescription, application_types.ApplicationType, 
                  application_types.ApplicationTypeUUID, applications.WikiURL, applications.StartDate, applications.PCI, applications.DR, applications.EndDate, applications.GITURL, 
                  applications.Utility, applications.SOX, applications.CorporateCritical
FROM     application_types INNER JOIN
                  applications ON application_types.ApplicationTypeUUID = applications.ApplicationTypeUUID INNER JOIN
                  change_priorities ON applications.ChangePriorityUUID = change_priorities.ChangePriorityUUID INNER JOIN
                  companies ON application_types.CompanyUUID = companies.CompanyUUID
WHERE  (applications.ApplicationUUID = @ApplicationUUID)
END

GO
/****** Object:  StoredProcedure [dbo].[sp_GetApplicationFilesByApplicationUUID]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_GetApplicationFilesByApplicationUUID]
					@ApplicationUUID UniqueIdentifier
AS
BEGIN

	SET NOCOUNT ON;
				SELECT files.StartDate, files.fileDescription, files.fileSize, files.clientFile, files.contentType, files.contentSubType, files.ClientFileExt, files.FileUUID
				FROM     application_files INNER JOIN
				                  files ON application_files.FileUUID = files.FileUUID
				WHERE ApplicationUUID = @ApplicationUUID
				AND application_files.EndDate IS NULL
				ORDER By files.ClientFile ASC
END

GO
/****** Object:  StoredProcedure [dbo].[sp_GetApplicationName]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_GetApplicationName] 
					@ApplicationUUID UniqueIdentifier

AS
BEGIN
	SET NOCOUNT ON;

	SELECT ApplicationName
		FROM [dbo].[applications]
		WHERE ApplicationUUID = @ApplicationUUID
END

GO
/****** Object:  StoredProcedure [dbo].[sp_GetApplicationNoteByApplicationNoteUUID]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_GetApplicationNoteByApplicationNoteUUID]
					@ApplicationNoteUUID UniqueIdentifier
AS
BEGIN

	SET NOCOUNT ON;
SELECT ApplicationNoteUUID, StartDate, ApplicationNote
FROM     application_notes
WHERE ApplicationNoteUUID = @ApplicationNoteUUID
END

GO
/****** Object:  StoredProcedure [dbo].[sp_GetApplicationNotesByApplicationUUID]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_GetApplicationNotesByApplicationUUID]
					@ApplicationUUID UniqueIdentifier
AS
BEGIN

	SET NOCOUNT ON;
				SELECT application_notes.ApplicationNoteUUID, application_notes.StartDate, application_notes.ApplicationNote, persondata.cn, application_notes.PersonUUID
				FROM     application_notes INNER JOIN
				                  persondata ON application_notes.PersonUUID = persondata.PersonUUID
				WHERE application_notes.ApplicationUUID = @ApplicationUUID
				AND application_notes.EndDate IS NULL
				ORDER BY application_notes.StartDate DESC
END

GO
/****** Object:  StoredProcedure [dbo].[sp_GetApplicationNotesLegacyByApplicationUUID]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_GetApplicationNotesLegacyByApplicationUUID]
					@ApplicationUUID UniqueIdentifier
AS
BEGIN

	SET NOCOUNT ON;
SELECT application_notes.ApplicationNoteUUID, application_notes.StartDate, application_notes.EndDate, application_notes.ApplicationNote, persondata.cn, 
                  application_notes.PersonUUID, persondata_1.PersonUUID AS EndDatePersonUUID, persondata_1.cn AS EndDateCN
FROM     application_notes INNER JOIN
                  persondata ON application_notes.PersonUUID = persondata.PersonUUID INNER JOIN
                  persondata AS persondata_1 ON application_notes.LastUpdatePersonUUID = persondata_1.PersonUUID
WHERE  (application_notes.ApplicationUUID = @ApplicationUUID) AND (application_notes.EndDate IS NOT NULL)
ORDER BY application_notes.EndDate DESC
END

GO
/****** Object:  StoredProcedure [dbo].[sp_GetApplicationsByOwnerUUID]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[sp_GetApplicationsByOwnerUUID]
@PersonUUID UniqueIdentifier
AS
SELECT applications.ApplicationName, applications.ApplicationDescription, persondata.cn, application_types.ApplicationType, persons.PersonUUID, 
                  application_owners.ApplicationOwnerUUID, applications.ApplicationUUID, application_types.ApplicationTypeUUID, companies.CompanyName, 
                  companies.CompanyUUID
FROM     persons INNER JOIN
                  persondata ON persons.PersonUUID = persondata.PersonUUID INNER JOIN
                  application_owners INNER JOIN
                  applications ON application_owners.ApplicationUUID = applications.ApplicationUUID ON persons.PersonUUID = application_owners.PersonUUID INNER JOIN
                  application_types ON applications.ApplicationTypeUUID = application_types.ApplicationTypeUUID INNER JOIN
                  companies ON applications.CompanyUUID = companies.CompanyUUID
WHERE  (application_owners.PersonUUID = @PersonUUID)
AND  (applications.EndDate IS NULL)
ORDER BY applications.ApplicationName

GO
/****** Object:  StoredProcedure [dbo].[sp_GetApplicationServersByApplicationUUID]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_GetApplicationServersByApplicationUUID]
					@ApplicationUUID UniqueIdentifier
AS
BEGIN

	SET NOCOUNT ON;
				SELECT servers.serverUUID, servers.ServerName, vCenter_Servers.vCenterHostName, sites.SiteName
				FROM     application_servers INNER JOIN
				                  servers ON application_servers.ServerUUID = servers.ServerUUID INNER JOIN
				                  vCenter_Servers ON servers.vCenterUUID = vCenter_Servers.vCenterUUID INNER JOIN
				                  sites ON vCenter_Servers.SiteUUID = sites.SiteUUID
				WHERE application_servers.ApplicationUUID = @ApplicationUUID
				AND application_servers.EndDate IS NULL
END

GO
/****** Object:  StoredProcedure [dbo].[sp_GetApplicationSMEsByApplicationUUID]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_GetApplicationSMEsByApplicationUUID]
					@ApplicationUUID UniqueIdentifier
AS
BEGIN
	SET NOCOUNT ON;
				SELECT application_smes.PersonUUID, persondata.cn, persondata.givenName, persondata.sn, persondata.telephoneNumber, persondata.mail, persons.sAMAccountName, application_sme_types.SMEType
				FROM     persons INNER JOIN
				                  persondata ON persons.PersonUUID = persondata.PersonUUID INNER JOIN
				                  application_sme_types INNER JOIN
				                  application_smes ON application_sme_types.ApplicationSMETypeUUID = application_smes.ApplicationSMETypeUUID ON 
				                  persons.PersonUUID = application_smes.PersonUUID AND persondata.PersonUUID = application_smes.PersonUUID
				WHERE application_smes.EndDate IS NULL
				AND application_smes.ApplicationUUID = @ApplicationUUID
				ORDER BY SMEType ASC, CN ASC
END

GO
/****** Object:  StoredProcedure [dbo].[sp_GetApplicationTechnologiesByApplicationUUID]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_GetApplicationTechnologiesByApplicationUUID]
					@ApplicationUUID UniqueIdentifier
AS
BEGIN
	SET NOCOUNT ON;
				SELECT technologies.Technology, technologies.technologyUUID
				FROM     application_technologies INNER JOIN
				                  technologies ON application_technologies.TechnologyUUID = technologies.technologyUUID
				WHERE application_technologies.EndDate IS NULL
				AND application_technologies.ApplicationUUID = @ApplicationUUID
				ORDER BY technologies.technology ASC
END

GO
/****** Object:  StoredProcedure [dbo].[sp_GetApplicationTypes]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[sp_GetApplicationTypes]
AS
BEGIN
SELECT application_types.ApplicationType, application_types.CompanyUUID, application_types.ApplicationTypeUUID, companies.CompanyName
FROM     application_types INNER JOIN
                  companies ON application_types.CompanyUUID = companies.CompanyUUID
WHERE application_types.EndDate IS NULL
ORDER BY application_types.ApplicationType ASC
END

GO
/****** Object:  StoredProcedure [dbo].[sp_GetApplicationURLsByApplicationUUID]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_GetApplicationURLsByApplicationUUID]
					@ApplicationUUID UniqueIdentifier
AS
BEGIN

	SET NOCOUNT ON;
SELECT Link, Note, ApplicationURLID
FROM     application_urls
WHERE  (ApplicationUUID = @ApplicationUUID) AND (EndDate IS NULL)
ORDER BY Note
END

GO
/****** Object:  StoredProcedure [dbo].[sp_GetAppOwnerByApplicationUUID]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_GetAppOwnerByApplicationUUID]
					@ApplicationUUID UniqueIdentifier
AS
BEGIN
	SET NOCOUNT ON;
		SELECT PersonUUID
			FROM [dbo].[application_owners]
		WHERE ApplicationUUID = @ApplicationUUID
		AND EndDate IS NULL
END

GO
/****** Object:  StoredProcedure [dbo].[sp_GetAppsByAppType]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_GetAppsByAppType]
					@ApplicationTypeUUID UniqueIdentifier
AS
BEGIN
	SET NOCOUNT ON;
		SELECT applications.ApplicationUUID, applications.ApplicationName, applications.ApplicationDescription, persondata.cn, persondata.mail, companies.CompanyName, application_owners.PersonUUID
		FROM     applications INNER JOIN
		                  application_owners ON applications.ApplicationUUID = application_owners.ApplicationUUID INNER JOIN
		                  persondata ON application_owners.PersonUUID = persondata.PersonUUID INNER JOIN
		                  companies ON applications.CompanyUUID = companies.CompanyUUID
		WHERE  (applications.ApplicationTypeUUID = @ApplicationTypeUUID) AND (applications.EndDate IS NULL)
			AND (application_owners.OwnerType = 1)
		ORDER BY applications.ApplicationName ASC
END

GO
/****** Object:  StoredProcedure [dbo].[sp_GetAppsByProductionSite]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_GetAppsByProductionSite]
					@ProductionSiteUUID UniqueIdentifier
AS
BEGIN
	SET NOCOUNT ON;
			SELECT applications.ApplicationName, applications.ApplicationDescription, persondata.cn, application_types.ApplicationType, persons.PersonUUID, 
			                  application_owners.ApplicationOwnerUUID, applications.ApplicationUUID, application_types.ApplicationTypeUUID, companies.CompanyName, 
			                  companies.CompanyUUID
			FROM     persons INNER JOIN
			                  persondata ON persons.PersonUUID = persondata.PersonUUID INNER JOIN
			                  application_owners INNER JOIN
			                  applications ON application_owners.ApplicationUUID = applications.ApplicationUUID ON persons.PersonUUID = application_owners.PersonUUID INNER JOIN
			                  application_types ON applications.ApplicationTypeUUID = application_types.ApplicationTypeUUID INNER JOIN
			                  companies ON applications.CompanyUUID = companies.CompanyUUID
			WHERE applications.EndDate IS NULL
			AND applications.ProductionSiteUUID = @ProductionSiteUUID
			ORDER BY applications.ApplicationName ASC
END

GO
/****** Object:  StoredProcedure [dbo].[sp_GetAppsWithDR]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_GetAppsWithDR]
AS
BEGIN
	SET NOCOUNT ON;
				SELECT ApplicationName, ApplicationUUID
					FROM applications
				WHERE EndDate IS NULL
				AND DR = 1
				ORDER BY ApplicationName ASC
END

GO
/****** Object:  StoredProcedure [dbo].[sp_GetAppsWithoutDR]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_GetAppsWithoutDR]
AS
BEGIN
	SET NOCOUNT ON;
				SELECT ApplicationName, ApplicationUUID
					FROM applications
				WHERE EndDate IS NULL
				AND DR = 0
				ORDER BY ApplicationName ASC
END

GO
/****** Object:  StoredProcedure [dbo].[sp_GetAppsWithoutPCI]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_GetAppsWithoutPCI]
AS
BEGIN
	SET NOCOUNT ON;
				SELECT ApplicationName, ApplicationUUID
					FROM applications
				WHERE EndDate IS NULL
				AND PCI = 0
				ORDER BY ApplicationName ASC
END

GO
/****** Object:  StoredProcedure [dbo].[sp_GetAppsWithPCI]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_GetAppsWithPCI]
AS
BEGIN
	SET NOCOUNT ON;
				SELECT ApplicationName, ApplicationUUID
					FROM applications
				WHERE EndDate IS NULL
				AND PCI = 1
				ORDER BY ApplicationName ASC
END

GO
/****** Object:  StoredProcedure [dbo].[sp_GetBK]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetBK]
	@PersonUUID UniqueIdentifier
AS
BEGIN
	SET NOCOUNT ON;
	SELECT [BKUUID],[DateMask],[TimeMask],[TFormat],[RPP]
		FROM [dbo].[bk]
	WHERE [PersonUUID] = @PersonUUID
	AND [EndDate] IS NULL
END

GO
/****** Object:  StoredProcedure [dbo].[sp_GetBK_CN]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_GetBK_CN]
					@PersonUUID UniqueIdentifier
AS
BEGIN
	SET NOCOUNT ON;
	SELECT [cn]
		FROM [dbo].[persondata]
	WHERE PersonUUID = @PersonUUID
	SELECT [BKUUID],[DateMask],[TimeMask],[TFormat],[RPP]
		FROM [dbo].[bk]
	WHERE [PersonUUID] = @PersonUUID
	AND [EndDate] IS NULL
END

GO
/****** Object:  StoredProcedure [dbo].[sp_GetChangePriorities]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[sp_GetChangePriorities]
AS
BEGIN
SELECT ChangePriorityUUID, ChangePriority
	FROM change_priorities
WHERE EndDate IS NULL
ORDER BY ChangePriority ASC
END

GO
/****** Object:  StoredProcedure [dbo].[sp_GetCN]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_GetCN]
					@PersonUUID UniqueIdentifier
AS
BEGIN
	SET NOCOUNT ON;
	SELECT [cn]
		FROM [dbo].[persondata]
	WHERE PersonUUID = @PersonUUID
END

GO
/****** Object:  StoredProcedure [dbo].[sp_GetCompanies]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetCompanies]
AS
BEGIN
	SET NOCOUNT ON;
					SELECT CompanyUUID, CompanyName
						FROM [dbo].[companies]
					WHERE EndDate IS NULL
					ORDER BY CompanyName ASC
END

GO
/****** Object:  StoredProcedure [dbo].[sp_GetDateMasks]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_GetDateMasks]
AS
BEGIN
	SET NOCOUNT ON;
					SELECT DateMask, DateMaskExample
						FROM datemasks
					WHERE EndDate IS NULL
					ORDER BY DateMask ASC
END

GO
/****** Object:  StoredProcedure [dbo].[sp_GetDependenciesDownStream]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_GetDependenciesDownStream]
					@ParentUUID UniqueIdentifier
AS
BEGIN

	SET NOCOUNT ON;
					SELECT Applications.ApplicationUUID, Applications.ApplicationName
					FROM     Applications INNER JOIN
					                  Dependencies ON Applications.ApplicationUUID = Dependencies.ChildUUID
					WHERE Dependencies.EndDate IS NULL
					AND Dependencies.ParentUUID = @ParentUUID
END

GO
/****** Object:  StoredProcedure [dbo].[sp_GetDependenciesUpStream]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_GetDependenciesUpStream]
					@ChildUUID UniqueIdentifier
AS
BEGIN

	SET NOCOUNT ON;
					SELECT Applications.ApplicationUUID, Applications.ApplicationName
					FROM     Applications INNER JOIN
					                  Dependencies ON Applications.ApplicationUUID = Dependencies.ParentUUID
					WHERE Dependencies.EndDate IS NULL
					AND Dependencies.ChildUUID = @ChildUUID
END

GO
/****** Object:  StoredProcedure [dbo].[sp_GetDNByPersonUUID]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[sp_GetDNByPersonUUID]
@PersonUUID UniqueIdentifier
AS
BEGIN
	SELECT [distinguishedname] AS DN
		FROM [dbo].[persondata]
	WHERE [PersonUUID] = @PersonUUID
	AND [EndDate] IS NULL
END

GO
/****** Object:  StoredProcedure [dbo].[sp_GetDownstreamDependenciesByApplicationUUID]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetDownstreamDependenciesByApplicationUUID]
					@ApplicationUUID UniqueIdentifier
AS
BEGIN
	SET NOCOUNT ON;
				SELECT Applications.ApplicationUUID, Applications.ApplicationName
				FROM     Applications INNER JOIN
				                  Dependencies ON Applications.ApplicationUUID = Dependencies.ChildUUID
				WHERE Dependencies.EndDate IS NULL
				AND Dependencies.ParentUUID = @ApplicationUUID
				ORDER BY ApplicationName ASC
END

GO
/****** Object:  StoredProcedure [dbo].[sp_GetDRDueDateByApplicationUUID]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetDRDueDateByApplicationUUID]
					@ApplicationUUID UniqueIdentifier
AS
BEGIN
	SET NOCOUNT ON;
					SELECT DueDate
						FROM dr_validation_date
					WHERE ApplicationUUID = @ApplicationUUID
					AND EndDate IS NULL
END

GO
/****** Object:  StoredProcedure [dbo].[sp_GetInActiveAppCountByPersonUUID]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_GetInActiveAppCountByPersonUUID]
					@PersonUUID UniqueIdentifier
AS
BEGIN
	SET NOCOUNT ON;
		SELECT COUNT(*) AS TCount
			FROM [dbo].[application_owners]
		WHERE PersonUUID = @PersonUUID
		AND EndDate IS NOT NULL
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetInActiveApplicationsByOwnerUUID]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[sp_GetInActiveApplicationsByOwnerUUID]
@PersonUUID UniqueIdentifier
AS
SELECT applications.ApplicationName, applications.ApplicationDescription, persondata.cn, application_types.ApplicationType, persons.PersonUUID, 
                  application_owners.ApplicationOwnerUUID, applications.ApplicationUUID, application_types.ApplicationTypeUUID, companies.CompanyName, 
                  companies.CompanyUUID
FROM     persons INNER JOIN
                  persondata ON persons.PersonUUID = persondata.PersonUUID INNER JOIN
                  application_owners INNER JOIN
                  applications ON application_owners.ApplicationUUID = applications.ApplicationUUID ON persons.PersonUUID = application_owners.PersonUUID INNER JOIN
                  application_types ON applications.ApplicationTypeUUID = application_types.ApplicationTypeUUID INNER JOIN
                  companies ON applications.CompanyUUID = companies.CompanyUUID
WHERE  (application_owners.PersonUUID = @PersonUUID)
AND  (applications.EndDate IS NOT NULL)
ORDER BY applications.ApplicationName

GO
/****** Object:  StoredProcedure [dbo].[sp_GetIsUtility]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetIsUtility]
					@ApplicationUUID UniqueIdentifier
AS
BEGIN
	SET NOCOUNT ON;
				SELECT COUNT(*) AS TCount
					FROM [dbo].[utilities]
				WHERE ApplicationUUID = @ApplicationUUID
END

GO
/****** Object:  StoredProcedure [dbo].[sp_GetNews]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[sp_GetNews]
AS
BEGIN
	SELECT persondata.cn, persondata.title, persondata.department, persondata.mail, news.News, news.NewsUUID, news.StartDate
	FROM     news INNER JOIN
					  persondata ON news.PersonUUID = persondata.PersonUUID
	WHERE news.StartDate IS NULL
	ORDER BY news.StartDate DESC
END

GO
/****** Object:  StoredProcedure [dbo].[sp_GetOverDueDR]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_GetOverDueDR]
AS
BEGIN
	SET NOCOUNT ON;
		SELECT COUNT(*) AS TCount
			FROM dr_validation_date
		WHERE DueDate <= (getUTCDate())
END

GO
/****** Object:  StoredProcedure [dbo].[sp_GetOverDuePCI]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_GetOverDuePCI]
AS
BEGIN
	SET NOCOUNT ON;
		SELECT COUNT(*) AS TCount
			FROM pci_validation_date
		WHERE DueDate < (getUTCDate())
END

GO
/****** Object:  StoredProcedure [dbo].[sp_GetPCIDueDateByApplicationUUID]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetPCIDueDateByApplicationUUID]
					@ApplicationUUID UniqueIdentifier
AS
BEGIN
	SET NOCOUNT ON;
					SELECT DueDate
						FROM pci_validation_date
					WHERE ApplicationUUID =  @ApplicationUUID
					AND EndDate IS NULL
END

GO
/****** Object:  StoredProcedure [dbo].[sp_GetPermissionsByPersonUUID]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_GetPermissionsByPersonUUID]
	@PersonUUID UniqueIdentifier
AS
BEGIN
	SET NOCOUNT ON;
SELECT [God],[Add_New_App],[Add_New_Application_Type],[Add_Disaster_Recovery],[Add_Payment_Card_Industry],[Manage_Application_Types],[Add_News_Articles]
	FROM [dbo].[permissions]
WHERE PersonUUID = @PersonUUID
AND EndDate IS NULL
END

GO
/****** Object:  StoredProcedure [dbo].[sp_GetPerson_CN_Sam_UUID]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetPerson_CN_Sam_UUID]

AS
BEGIN

	SET NOCOUNT ON;
SELECT persondata.cn, persons.sAMAccountName, persons.PersonUUID
FROM     persondata INNER JOIN
                  persons ON persondata.PersonUUID = persons.PersonUUID
		WHERE persons.EndDate IS NULL
ORDER BY persondata.cn ASC
END

GO
/****** Object:  StoredProcedure [dbo].[sp_GetPersonDataByUUID]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[sp_GetPersonDataByUUID]
@PersonUUID UniqueIdentifier
AS
SELECT persons.employeeID, persons.PeopleLeader, persons.EndDate, persondata.*
FROM     persondata INNER JOIN
                  persons ON persondata.PersonUUID = persons.PersonUUID
WHERE persons.PersonUUID = @PersonUUID
GO
/****** Object:  StoredProcedure [dbo].[sp_GetPrimaryOwnerByApplicationUUID]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetPrimaryOwnerByApplicationUUID]
					@ApplicationUUID UniqueIdentifier
AS
BEGIN
	SET NOCOUNT ON;
				SELECT persondata.cn, persondata.mail, persondata.personUUID
				FROM     application_owners INNER JOIN
				                  persondata ON application_owners.PersonUUID = persondata.PersonUUID
				WHERE application_owners.ApplicationUUID = @ApplicationUUID
				AND application_owners.OwnerType = 1
END

GO
/****** Object:  StoredProcedure [dbo].[sp_GetProductionSiteByApplicationUUID]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetProductionSiteByApplicationUUID]
					@ApplicationUUID UniqueIdentifier
AS
BEGIN
	SET NOCOUNT ON;
				SELECT sites.SiteName
				FROM     applications INNER JOIN
				                  sites ON applications.ProductionSiteUUID = sites.SiteUUID
				WHERE applications.ApplicationUUID = @ApplicationUUID
END

GO
/****** Object:  StoredProcedure [dbo].[sp_GetRecoverySiteByApplicationUUID]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetRecoverySiteByApplicationUUID]
					@ApplicationUUID UniqueIdentifier
AS
BEGIN
	SET NOCOUNT ON;
				SELECT sites.SiteName
				FROM     applications INNER JOIN
				                  sites ON applications.DRSiteUUID = sites.SiteUUID
				WHERE applications.ApplicationUUID = @ApplicationUUID
END

GO
/****** Object:  StoredProcedure [dbo].[sp_GetSites]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetSites]

AS
BEGIN

	SET NOCOUNT ON;
SELECT SiteUUID, SiteName
	FROM dbo.sites
END

GO
/****** Object:  StoredProcedure [dbo].[sp_GetTimeMasks]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_GetTimeMasks]
AS
BEGIN
	SET NOCOUNT ON;
					SELECT TimeMask, TimeMaskExample
						FROM timemasks
					WHERE EndDate IS NULL
					ORDER BY TimeMask ASC
END

GO
/****** Object:  StoredProcedure [dbo].[sp_GetTotalAppCount]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[sp_GetTotalAppCount]
AS
BEGIN
		SELECT COUNT(*) TCount
			FROM applications
		WHERE EndDate IS NULL
END

GO
/****** Object:  StoredProcedure [dbo].[sp_GetUpstreamDependenciesByApplicationUUID]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetUpstreamDependenciesByApplicationUUID]
					@ApplicationUUID UniqueIdentifier
AS
BEGIN
	SET NOCOUNT ON;
				SELECT Applications.ApplicationUUID, Applications.ApplicationName
				FROM     Applications INNER JOIN
				                  Dependencies ON Applications.ApplicationUUID = Dependencies.ParentUUID
				WHERE Dependencies.EndDate IS NULL
				AND Dependencies.ChildUUID = @ApplicationUUID
				ORDER BY ApplicationName ASC
END

GO
/****** Object:  StoredProcedure [dbo].[sp_InsertBK]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_InsertBK]
	@PersonUUID UniqueIdentifier
AS
BEGIN
	SET NOCOUNT ON;
	INSERT INTO [dbo].[bk]
		([PersonUUID])
	VALUES(@PersonUUID)
END

GO
/****** Object:  StoredProcedure [dbo].[sp_InsertLogRecord]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_InsertLogRecord]
					@PersonUUID UniqueIdentifier,
					@IPNumber VarChar(15)
AS
BEGIN

	SET NOCOUNT ON;
						INSERT INTO [dbo].[logs]
							([PersonUUID],[IPNumber])
						VALUES (@PersonUUID, @IPNumber)
END

GO
/****** Object:  StoredProcedure [dbo].[sp_InsertPermissions]    Script Date: 10/27/2015 4:19:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_InsertPermissions]
					@PersonUUID UniqueIdentifier
AS
BEGIN
	INSERT INTO [dbo].[permissions]
		([PersonUUID])
	VALUES(@PersonUUID)
END

GO
USE [master]
GO
ALTER DATABASE [cmdb_db] SET  READ_WRITE 
GO
