-- =============================================
-- Версия BI:               1
-- Автор:                   Рогов А.Д.
-- Дата создания:           2025.02.27
-- Карточка параметра:      К01911/00-25, РАСП01473/00-25 (Notes://DB23/C3256416005D5671/0/15211A1B00969A5A43257FD80057B377)
-- Параметр:                Полнота и достоверность сведений, заявленных в Уведомлении об участии в иностранных компаниях
-- =============================================
DECLARE 
	@datefrom DATETIME,
	@dateto DATETIME

SET @datefrom = dbo.svf_get_first_day_month_before(GETDATE())
SET @dateto = dbo.svf_get_last_day_month_before(GETDATE())

DECLARE @table TABLE( -- таблица для хранения unid'а акта 
unid VARCHAR(MAX)
,name VARCHAR(MAX))
------------------------Выборка 1-------------------------------------
INSERT INTO @table
SELECT unid 
FROM dbo.[(Акты)_(Документ)]  WITH (nolock)
WHERE viewactname = 'Чек-лист технологического надзора' -- 1.3.1. Вид нормативного акта (поле ViewActName) - Чек-лист технологического надзора
AND
[name]  = 'Проверка полноты и достоверности сведений, заявленных в Уведомлении об участии в иностранных компаниях'; -- 1.3.2.. Тематика акта (поле name) - Проверка полноты и достоверности сведений, заявленных в Уведомлении об участии в иностранных компаниях
-----------------------------------------------------------------------
------------------------Выборка 2--------------------------------------
WITH cte AS (
SELECT 
	dbo.svf_make_LN_link_desc(server_name, dbreplicaid, universalid, xnode_number) as link -- 2.4.1. Номер Журнала технадзора с гиперссылкой (поле "xNode_Number")
	, xnode_creator -- 2.4.2. Инициатор (поле "xNode_Creator")Инициатор (поле "xNode_Creator")
	, xnode_closed -- 2.4.3. Дата подтверждения ("xNode_Closed")
	, xnode_object -- 2.4.4. Проверенные объекты (поле "xNode_Object"
	, NULL as 'xnode_error' -- Заглушка для Union all
	, 1 'cnt' -- 2.5.1. Количество документов, определенных Выборкой 2.
	, 0 as 'cnt1' -- Заглушка для Union all
FROM dbo.[(Сводки ТН)_(f.BookS)] bks  with (nolock) -- 2.3.1. Тип журнала Поле  Form = "f.BookS" 
JOIN @table t
ON bks.xnode_actrootunid = t.unid -- 2.3.3. Поле "Основной акт" (xNode_ActRoot) = документ из Выборки 1 (п.1.4.1.)
WHERE
		xnode_closed BETWEEN @datefrom AND @dateto -- 2.3.2. Дата подтверждения попадает в отчетный период, определенный в соответствии с разделом Определения и обозначения Бизнес-логики (поле "xNode_Closed")
-----------------------------------------------------------------------
UNION ALL
------------------------Выборка 3--------------------------------------
SELECT 
	 dbo.svf_make_LN_link_desc(bks.server_name, bks.dbreplicaid, bks.universalid,  bks.xnode_number) as link --3.4.1. Номер Журнала технадзора с гиперссылкой (поле "xNode_Number")
	,xnode_creator -- 3.4.2. Инициатор (поле "xNode_Creator")Инициатор (поле "xNode_Creator")
	,xnode_closed -- 3.4.3. Дата подтверждения ("xNode_Closed"
	, NULL as 'xnode_object' -- Заглушка для Union all
	, xnode_error -- 3.4.4. Нарушения  (поле "xNode_Error")
	, 0 as 'cnt' -- Заглушка для Union all
	, 1 cnt1 -- 3.5.1. Количество документов, определенных Выборкой 3.
FROM dbo.[(Сводки ТН)_(f.BookS)] bks WITH (nolock) -- 3.3.1. Тип журнала Поле  Form = "f.BookS"  
JOIN @table t 
ON bks.xnode_actrootunid = t.unid --3.3.3. Поле "Основной акт" (xNode_ActRoot) = документ из Выборки 1 (п.1.4.1.)
WHERE xnode_error > 0 -- 3.3.4. В поле Нарушения  (поле "xNode_Error") указано значение больше 0.
	AND 
	  xnode_closed BETWEEN @datefrom AND @dateto -- 3.3.2. Дата подтверждения попадает в отчетный период, определенный в соответствии с разделом Определения и обозначения Бизнес-логики (поле "xNode_Closed")
-----------------------------------------------------------------------
)
SELECT * FROM cte

UNION ALL

select 'Документы не найдены'
	, NULL
	, NULL
	, NULL
	, NULL
	, 0
	, 0
WHERE NOT EXISTS (SELECT NULL FROM cte)

