-- =================================================================================
-- Номер Акта/Кодекса:         К09470/01-18
-- Номер Приказа/Распоряжения: РАСП10137/00-18
-- Версия BI:                  1
-- Параметр:                   Нормируемый параметр количества
--                             Своевременность подтверждения Справки-расчета резерва по оплате отпусков для целей бухгалтерского учета (ручной, подлежащий автоматизации)
-- Ссылка:                     Notes://DB03/C3256416005D5671/0/C7FD1DDCE20E414C43258270002F4AEE
-- Автор:                      Куанчалеев А.Б.
-- =================================================================================
DECLARE 
 @Period_Date VarChar(MAX) =                Cast( '31.12.' AS VarChar(MAX) ) + Cast( Year( GetDate() ) - 1 AS VarChar(MAX) )        -- Отчетный период 
,@Norm_Date   Date         = Convert( Date, Cast( '25.01.' AS VarChar(MAX) ) + Cast( Year( GetDate() )     AS VarChar(MAX) ), 104 ) -- Нормативная дата 
; 
------ Выборка № 1 
DECLARE @TableSet1 TABLE
(
 [UNID]               VarChar(32)
,[Link_LN]            VarChar(MAX)
,[Predpr]             VarChar(MAX)
,[Forma]              VarChar(MAX)
,[Name_Jur]           VarChar(MAX)
,[Forma_and_Name_Jur] VarChar(MAX)
)
;
WITH CTE AS 
(
SELECT                                                      [UNID]
      ,[dbo].[svf_make_LN_link]([Server_Name],[DBReplicaID],[UniversalID]) AS [Link_LN] 
      ,                                                     [Predpr]
      ,                                                     [Forma]
      ,                                                     [Name_Jur]
FROM   [dbo].[(Юридическая структура EL)_(CardJur)] WITH (NoLock)
WHERE  [Act]          =  '1'
  AND  [FlagCategory] <> '2'
  AND  [PositionStr]  <> '0'
  AND  [Status]       <> '80'
  AND  [Country]      IN (N'Россия')
  AND  [CodCategory]  IN ('NA')
  AND  [Forma]    NOT IN ('', 'Иностранное ЮЛ', 'Филиал') 
)
INSERT INTO @TableSet1
       SELECT DISTINCT *
             ,         [Forma] + ' ' + [Name_Jur]
       FROM   [CTE]
       WHERE  [UNID] <> ''
;
------ Выборка № 2 
DECLARE @TableSet2 TABLE
(
 [UNID]                VarChar(32)
,[Link_LN]             VarChar(MAX)
,[Account_Number]      VarChar(MAX)
,[Registration_Number] VarChar(MAX)
,[Period_Date]         VarChar(MAX)
,[StatConfirmDate]     DateTime
,[Initiator_LN_Edit]   VarChar(MAX)
,[Initiator_FIO]       VarChar(MAX)
,[Jur_Person_Name]     VarChar(MAX)
)
;
WITH CTE AS 
(
SELECT                                                      [UNID]
      ,[dbo].[svf_make_LN_link]([Server_Name],[DBReplicaID],[UniversalID])                                  AS [Link_LN] 
      ,                                                     [Account_Number]
      ,                                                     [Registration_Number]
      ,                                                     [Period_Date]
      ,    CASE WHEN [StatConfirmDate] <> '1900-01-01' THEN [StatConfirmDate] ELSE NULL END                 AS [StatConfirmDate]
      ,                                                     [Initiator_LN_Edit]
      ,                                                     [Initiator_FIO] + ' (' + [Initiator_Path] + ')' AS [Initiator_FIO]

FROM   [dbo].[(Подготовка документов v3.0)_(Project_wo_link)] WITH (NoLock) 
WHERE  [UNID]         <> ''
 AND   [Type_Project] IN ('Справка-расчет резерва по оплате отпусков для целей бухгалтерского учета')
 AND   convert(varchar(10),[Period_Date],104)  =  @Period_Date
)
INSERT INTO @TableSet2
       SELECT DISTINCT [PrD].*
             ,         [Prt].[Jur_Person_Name]
       FROM   [CTE]                                  AS [PrD] 
       JOIN   [dbo].[(Подготовка документов)_(Part)] AS [Prt] WITH (NoLock) ON [PrD].[UNID] = [Prt].[ParentDocUNID]
;
------ Выборка № 3 
DECLARE @TableSet3 TABLE
(
 [ACL_StaffLN] VarChar(MAX)
,[PersonFIO]   VarChar(MAX)
,[ShortPath]   VarChar(MAX)
,[UnitPredpr]  VarChar(MAX)
)
; 
WITH CTE AS
(
SELECT [UNID]
FROM   [dbo].[(Структура)_(1)] WITH (NoLock)
WHERE  [Active]   =  '1'
  AND  [TypeUnit] =  '3'
  AND  [UnitName] IN ('Начальник финансово-экономического подразделения')
)
INSERT INTO @TableSet3
       SELECT DISTINCT [ACL_StaffLN]
             ,         [PersonFIO]
             ,Replace( [ShortPath], '|', '\' )
             ,         [UnitPredpr]
       FROM   [CTE]                   AS [TBL]
       JOIN   [dbo].[(Структура)_(1)] AS [Str] WITH (NoLock) ON CharIndex( [TBL].[UNID], [Str].[MatrixUNID] ) > 0
        AND   [Active]    =  '1'
        AND   [TypeUnit]  =  '2'
        AND   [PersonFIO] <> ''
        AND   [StfUID]    <> ''
;
------ Предварительная таблица 
WITH CTE( [Row_Number], [Name_Jur], [Predpr], [RC], [Account_Number], [Registration_Number], [Jur_Person_Name], [Period_Date], [Norm_Date], [StatConfirmDate], [Type], [Rank] ) AS 
(
SELECT               Row_Number() OVER( ORDER BY [Jur].[Forma] + ' ' + [Jur].[Name_Jur] )
         ,'<A HRef="' + [Jur].[Link_LN] + '">' + [Jur].[Forma] + ' ' + [Jur].[Name_Jur] + '</A>' 
         ,                                                             [Jur].[Predpr]
          -- Центр ответственности 
         ,CASE
              WHEN [PrD].[UNID] IS NOT NULL THEN [Initiator_FIO]
              WHEN [PrD].[UNID] IS     NULL THEN Stuff( Cast( (
                                                              SELECT   Cast( ',' AS VarChar(MAX) ) + Char(10) + [PersonFIO] + ' (' + [ShortPath] + ')' 
                                                              FROM     @TableSet3
                                                              WHERE    [Predpr] = [UnitPredpr]
                                                              ORDER BY [PersonFIO], [ShortPath]
                                                              /*------------*/
                                                              FOR XML PATH('')
                                                              /*------------*/
                                                              ) AS VarChar(MAX) ), 1, 2, '' )
          END 
         ,                                                             [PrD].[Account_Number]
         ,              IsNull( '<A HRef="' + [PrD].[Link_LN] + '">' + [PrD].[Registration_Number] + '</A>', Cast( 'Нет данных' AS VarChar(MAX) ) )
         ,              IsNull(                                        [PrD].[Jur_Person_Name]             , Cast( 'Нет данных' AS VarChar(MAX) ) )
         ,                                                             @Period_Date
         ,                                      Convert( VarChar(MAX), @Norm_Date             , 104 )
         ,              IsNull(                 Convert( VarChar(MAX), [PrD].[StatConfirmDate], 104 )      , Cast( 'Нет данных' AS VarChar(MAX) ) )
          -- Тип ККП 
         ,CASE 
              -- Нарушение 
              WHEN       [PrD].[UNID]                      IS NULL       THEN 1 -- Документ не создан 
              WHEN       [PrD].[StatConfirmDate]           IS NULL       THEN 2 -- Документ    создан, но не подтвержден 
              WHEN Cast( [PrD].[StatConfirmDate] AS Date ) >  @Norm_Date THEN 3 -- Документ    создан,       подтвержден, но позже нормативной даты 
              -- Соответствие норме 
              WHEN Cast( [PrD].[StatConfirmDate] AS Date ) <= @Norm_Date THEN 0
          END 
          -- Базовая значимость 
         ,CASE 
              WHEN       [PrD].[UNID]                      IS NULL       THEN Cast( '3' AS VarChar(MAX) )
              WHEN       [PrD].[StatConfirmDate]           IS NULL       THEN Cast( '1' AS VarChar(MAX) )
              WHEN Cast( [PrD].[StatConfirmDate] AS Date ) >  @Norm_Date THEN Cast( '1' AS VarChar(MAX) )
          END 
FROM      @TableSet1 AS [Jur] 
LEFT JOIN @TableSet2 AS [PrD] ON [Jur].[Forma_and_Name_Jur] = [PrD].[Jur_Person_Name]
),
------ Таблица для шапки 
TotalTable AS 
(
SELECT (SELECT Count(*) FROM [CTE] WHERE [Type] > 0)                                             AS [Qty_Vio]
      ,(SELECT Count(*) FROM [CTE] WHERE [Type] = 0)                                             AS [Qty_NRM]
      ,GetDate()                                                                                 AS [Cur_Day]
      ,DateAdd( Day, 1, @Norm_Date )                                                             AS [Vio_Day]
      ,Cast( '01.01.' AS VarChar(MAX) ) + SubString( @Period_Date, 7, 4 ) + ' - ' + @Period_Date AS [NRM_PRD] 
)
------ Таблица-результат 
SELECT      *
FROM        [TotalTable]
OUTER APPLY [CTE] 

