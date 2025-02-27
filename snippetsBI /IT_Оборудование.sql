SELECT 
    [category] AS [Категория КЕ],
    [unit] AS [Наименование и гиперссылка на КЕ],
    [Status_unit_name] AS [Статус],
    [location_unit] AS [Месторасположение]
FROM 
    [TotalReportDB].[dbo].[(Проведение IT-работ)_(unit)]
WHERE 
    [enterprise_owner_unit] = 'DOMODEDOVO ASSET MANAGEMENT'
    AND [Last_version] = 1
    AND ([delete] IS NULL OR [delete] = '')
    AND (
        -- Выборка 1 и 2 (Терминалы въезда-выезда с разными функциями)
        (
            category = 'Оборудование АПС/Терминал въезда-выезда' 
            AND 
            (
                function_unit IN ('Контроль въезда', 'Въездной парковочный терминал')    -- Выборка 1
                OR 
                function_unit IN ('Контроль выезда', 'Выездной парковочный терминал')    -- Выборка 2
            )
        )
        -- Выборки 3-8 (остальные категории без условий на function_unit)
        OR category = 'Оборудование АПС/Кассовый автомат'            -- Выборка 3
        OR category = 'Оборудование АПС/Шлагбаум'                   -- Выборка 4
        OR category = 'Оборудование АПС/Видеокамера (распознавание номерных знаков автомобилей)' -- Выборка 5
        OR category = 'Оборудование АПС/Мультикон'                  -- Выборка 6
        OR category = 'Оборудование АПС/Банкнотоприемник'           -- Выборка 7
