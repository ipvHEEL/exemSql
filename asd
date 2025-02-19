софрмируй выборку из этой таблицы
/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [id]
      ,[$sysFrom]
      ,[$sysTo]
      ,[$timestamp]
      ,[status_unit]
      ,[unit]
      ,[universalid]
      ,[dateversionedit]
      ,[category]
      ,[modifieddatetime]
      ,[filepath]
      ,[last_version]
      ,[units]
      ,[identifier_unit]
      ,[db_name]
      ,[dbreplicaid]
      ,[server_name]
      ,[type_units]
      ,[unidunit]
      ,[code_units]
      ,[owner]
      ,[system_name_unit]
      ,[enterprise_owner_unit]
      ,[versionunid]
      ,[delete]
      ,[unidwork]
      ,[serial_number_unit]
      ,[unid]
      ,[form]
      ,[type]
      ,[date_extention_unit]
      ,[fix_amount_unit]
      ,[virtual_unit]
      ,[dependent_service_unit]
      ,[location_unit]
      ,[model_unit]
      ,[install_os_unit]
      ,[break_in_date_unit]
      ,[function_unit]
      ,[norm_extention_unit]
      ,[parentunid]
      ,[last_versionunid]
      ,[holder_unit]
      ,[renter_unit]
      ,[holder_unit_id]
      ,[versiondate]
      ,[owner_id]
      ,[status_unit_name]
      ,[status_unit_name_id]
      ,[status_unit_id]
      ,[enterprise_owner_unit_id]
      ,[date_warrant_unit]
      ,[category_unit]
      ,[category_unit_id]
      ,[configuration_unit]
      ,[additional_information_unit]
      ,[fields_unit]
      ,[deleted]
      ,[id_channel_unit]
      ,[date_tech_unit]
      ,[drive_subsystem_unit]
      ,[versionfirstname]
      ,[ram_unit]
      ,[ip_address_unit]
      ,[cpu_unit]
      ,[identifier_number_unit]
  FROM [TotalReportDB].[dbo].[(Проведение IT-работ)_(unit)]

выборка 1  Условия отбора:
1.3.1. Категория КЕ (поле "category") = Оборудование АПС/Терминал въезда-выезда
И
1.3.2. Предприятие-Владелец (поле "enterprise_owner_unit") =  DOMODEDOVO ASSET MANAGEMENT
И
1.3.3. Назначение (поле "function_unit") = Контроль въезда ИЛИ Въездной парковочный терминал
И
1.3.4. Версия КЕ (поле "Last_version") = 1
И
1.3.5. Поле "delete" пустое ИЛИ отсутствует
1.4. Выгружаемые данные:
1.4.1. Категория КЕ (поле "category")
1.4.2. Наименование и гиперссылка на КЕ (поле "unit")
1.4.3. Статус (поле "Status_unit_name") 
1.4.4. Месторасположение (поле "location_unit")

выборка 2
 Условия отбора:
2.3.1. Категория КЕ (поле "category") = Оборудование АПС/Терминал въезда-выезда
И
2.3.2. Предприятие-Владелец (поле "enterprise_owner_unit") =  DOMODEDOVO ASSET MANAGEMENT
И
2.3.3. Назначение (поле "function_unit") = Контроль выезда ИЛИ Выездной парковочный терминал
И
2.3.4. Версия КЕ (поле "Last_version") = 1
И
2.3.5. Поле "delete" пустое ИЛИ отсутствует
2.4. Выгружаемые данные:
2.4.1. Категория КЕ (поле "category")
2.4.2. Наименование и гиперссылка на КЕ (поле "unit")
2.4.3. Статус (поле "Status_unit_name") 
2.4.4. Месторасположение (поле "location_unit")
выборка 3
3.3. Условия отбора:
3.3.1. Категория КЕ (поле "category") = Оборудование АПС/Кассовый автомат
И
3.3.2. Предприятие-Владелец (поле "enterprise_owner_unit") =  DOMODEDOVO ASSET MANAGEMENT
И
3.3.3. Версия КЕ (поле "Last_version") = 1
И
3.3.4. Поле "delete" пустое ИЛИ отсутствует
3.4. Выгружаемые данные:
3.4.1. Категория КЕ (поле "category") 
3.4.2. Наименование и гиперссылка на КЕ (поле "unit")
3.4.3. Статус (поле "Status_unit_name") 
3.4.4. Месторасположение (поле "location_unit")

выборка 4
 Условия отбора:
4.3.1. Категория КЕ (поле "category") = Оборудование АПС/Шлагбаум
И
4.3.2. Предприятие-Владелец (поле "enterprise_owner_unit") =  DOMODEDOVO ASSET MANAGEMENT
И
4.3.3. Версия КЕ (поле "Last_version") = 1
И
4.3.4. Поле "delete" пустое ИЛИ отсутствует
4.4. Выгружаемые данные:
4.4.1. Категория КЕ (поле "category")
4.4.2. Наименование и гиперссылка на КЕ (поле "unit")
4.4.3. Статус (поле "Status_unit_name") 
4.4.4. Месторасположение (поле "location_unit")


выборка 5
 Условия отбора:
5.3.1. Категория КЕ (поле "category") = Оборудование АПС/Видеокамера (распознавание номерных знаков автомобилей)
И
5.3.2. Предприятие-Владелец (поле "enterprise_owner_unit") =  DOMODEDOVO ASSET MANAGEMENT
И
5.3.3. Версия КЕ (поле "Last_version") = 1
И
5.3.4. Поле "delete" пустое ИЛИ отсутствует
5.4. Выгружаемые данные:
5.4.1. Категория КЕ (поле "category")
5.4.2. Наименование и гиперссылка на КЕ (поле "unit")
5.4.3. Статус (поле "Status_unit_name") 



выборка 6
Условия отбора:
6.3.1. Категория КЕ (поле "category") = Оборудование АПС/Мультикон
И
6.3.2. Предприятие-Владелец (поле "enterprise_owner_unit") =  DOMODEDOVO ASSET MANAGEMENT
И
6.3.3. Версия КЕ (поле "Last_version") = 1
И
6.3.4. Поле "delete" пустое ИЛИ отсутствует
6.4. Выгружаемые данные:
6.4.1. Категория КЕ (поле "category")
6.4.2. Наименование и гиперссылка на КЕ (поле "unit")
6.4.3. Статус (поле "Status_unit_name") 

выборка 7 

7.3. Условия отбора:
7.3.1. Категория КЕ (поле "category") = Оборудование АПС/Банкнотоприемник
И
7.3.2. Предприятие-Владелец (поле "enterprise_owner_unit") =  DOMODEDOVO ASSET MANAGEMENT
И
7.3.3. Версия КЕ (поле "Last_version") = 1
И
7.3.4. Поле "delete" пустое ИЛИ отсутствует
7.4. Выгружаемые данные:
7.4.1. Категория КЕ (поле "category")
7.4.2. Наименование и гиперссылка на КЕ (поле "unit")
7.4.3. Статус (поле "Status_unit_name") 

выборка 8
 Условия отбора:
8.3.1. Категория КЕ (поле "category") = Оборудование АПС/Оборудование Uniteller
И
8.3.2. Предприятие-Владелец (поле "enterprise_owner_unit") =  DOMODEDOVO ASSET MANAGEMENT
И
8.3.3. Версия КЕ (поле "Last_version") = 1
И
8.3.4. Поле "delete" пустое ИЛИ отсутствует
8.4. Выгружаемые данные:
8.4.1. Категория КЕ (поле "category")
8.4.2. Наименование и гиперссылка на КЕ (поле "unit")
8.4.3. Статус (поле "Status_unit_name") 
сделай так что бы все это выгружалось одним запросом в ms sql
