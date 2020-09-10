#Область ПрограммныйИнтерфейс

Процедура ЗапуститьОбработкуДанныхВФоне(Знач ИдентификаторWebhook,
											Знач ДанныеТелаЗапроса,
											Знач ЭтоРучнойЗапуск = Ложь) Экспорт
	
	Перем ТекстСообщения;
	Перем ПараметрыПроектаРепозитория;
	Перем КлючЗапросаGitLab;	
	Перем ПараметрыЗадания;
	Перем АктивныеЗадания;
	Перем ДополнительныеПараметры;
	
	ДополнительныеПараметры = Логирование.ДополнительныеДанные();
	ДополнительныеПараметры.Объект = ИдентификаторWebhook;
	
	Если ТипЗнч(ДанныеТелаЗапроса) <> Тип("Соответствие") Тогда
		
		ТекстСообщения = НСтр("ru = 'Неверный формат данных в теле запроса.'");
		Логирование.Ошибка( "Core.ОбработкаДанныхВФоне", ТекстСообщения, ДополнительныеПараметры );
		
		Возврат;
		
	КонецЕсли;
	
	КлючЗапросаGitLab = ДанныеТелаЗапроса.Получить("checkout_sha");
	
	Если КлючЗапросаGitLab = Неопределено Тогда
		
		ТекстСообщения = НСтр("ru = 'Запрос не идентифицирован (отсутствует checkout_sha).'");
		Логирование.Ошибка( "Core.ОбработкаДанныхВФоне", ТекстСообщения, ДополнительныеПараметры );
		
		Возврат;
		
	КонецЕсли;
	
	ПараметрыПроектаРепозитория = ПараметрыПроектаИзТелаЗапроса(ДанныеТелаЗапроса);
	АктивныеЗадания             = АктивныеЗадачиПоКлючу(КлючЗапросаGitLab);
	
	Если ЗначениеЗаполнено(АктивныеЗадания) Тогда
		
		ТекстСообщения = НСтр("ru = '%1: задание уже было запущено и активно.'");
		ТекстСообщения = СтрШаблон(ТекстСообщения, КлючЗапросаGitLab);
		Логирование.Предупреждение( "Core.ОбработкаДанныхВФоне", ТекстСообщения, ДополнительныеПараметры );
		
		Возврат;
		
	КонецЕсли;
	
	ПараметрыЗадания = Новый Массив;
	ПараметрыЗадания.Добавить(ИдентификаторWebhook);
	ПараметрыЗадания.Добавить(КлючЗапросаGitLab);
	ПараметрыЗадания.Добавить(ДанныеТелаЗапроса);
	ПараметрыЗадания.Добавить(ПараметрыПроектаРепозитория);
	ПараметрыЗадания.Добавить(ЭтоРучнойЗапуск);

	// Перехват всех ошибок с логированием происходит внутри фонового.
	// Работу текущей процедуры не заворачивать в попытка...исключение. 
	ФоновыеЗадания.Выполнить("СервисыGitLab.ФоноваяОбработкаДанныхЗапроса",
							 ПараметрыЗадания,
							 КлючЗапросаGitLab,
							 "СервисыGitLab: " + КлючЗапросаGitLab);
							 
	ТекстСообщения = НСтр("ru = '%1: запущена обработка данных. Ручной запуск: %2.'");
	ТекстСообщения = СтрШаблон(ТекстСообщения, КлючЗапросаGitLab, Строка(ЭтоРучнойЗапуск));

	Логирование.Информация("Core.ОбработкаДанныхВФоне.Начало", ТекстСообщения, ДополнительныеПараметры);
	
КонецПроцедуры


#Область Webhooks




// Сохраняет исходные данные HTTP-запроса (См. РегистрСведений.ОбработчикиСобытий).
// 
// Параметры:
// 	ИдентификаторWebhook - СправочникСсылка.ОбработчикиСобытий - ссылка на описание webhook;
// 	Ключ - Строка - значение checkout_sha коммита;
// 	ДанныеТелаЗапроса - (См. ПолучитьДанныеТелаЗапроса.ДанныеТелаЗапроса);
Процедура СохранитьДанныеТелаЗапросаВИБ(Знач ИдентификаторWebhook, Знач Ключ, Знач ДанныеТелаЗапроса) Экспорт
	
	СохранитьДанныеВИБ(ИдентификаторWebhook, Ключ, "ДанныеТелаЗапроса", ДанныеТелаЗапроса);

КонецПроцедуры

// Сохраняет двоичные данные внешних файлов с их описанием (См. РегистрСведений.ОбработчикиСобытий).
// 
// Параметры:
// 	ИдентификаторWebhook - СправочникСсылка.ОбработчикиСобытий - ссылка на описание webhook;
// 	Ключ - Строка - значение checkout_sha коммита;
// 	ДвоичныеДанные - (См. ПодготовитьДанныеДляОтправки);
Процедура СохранитьДвоичныеДанныеВИБ(Знач ИдентификаторWebhook, Знач Ключ, Знач ДвоичныеДанные) Экспорт
	
	СохранитьДанныеВИБ(ИдентификаторWebhook, Ключ, "ДвоичныеДанные", ДвоичныеДанные);

КонецПроцедуры

#КонецОбласти

#Область ФоновыеЗадания

// Поиск всех фоновых заданий по наименованию.
// 
// Параметры:
// 	Наименование - Строка - наименование фонового задания;
// Возвращаемое значение:
// 	- Массив из ФоновоеЗадание - найденные фоновые задания;
Функция ЗадачиПоНаименованию(Знач Наименование) Экспорт
	
	Перем ПараметрыОтбора;
	Перем ВсеФоновыеЗадания;
	
	ПараметрыОтбора = Новый Структура("Наименование", Наименование);
	ВсеФоновыеЗадания = ФоновыеЗадания.ПолучитьФоновыеЗадания(ПараметрыОтбора);
	
	Возврат ВсеФоновыеЗадания;
	
КонецФункции

#КонецОбласти

#Область ДанныеЗапроса

// Подготавливает необходимые данные для формирования запроса к api GitLab на получение данных по всем запросам на merge.  
// 
// Параметры:
//	ДанныеТелаЗапроса - Соответствие - преобразованные в Соответствие данные HTTP-запроса;
// Возвращаемое значение:
// 	Структура - Описание:
// * СекретныйКлюч - Строка - ключ пользователя с доступом к api GitLab;
// * URL - Строка - веб-адрес запроса на merge;
Функция СформироватьЗапросНаMergeRequests(Знач ДанныеТелаЗапроса) Экспорт
	
	Перем ПараметрыПроекта;
	
	Перем Схема;
	Перем ИмяСервера;
	Перем Проект;
	
	Перем Запрос;
	
	ПараметрыПроекта = ПараметрыПроектаИзТелаЗапроса(ДанныеТелаЗапроса);
	
	Схема      = ПараметрыПроекта.СтруктураURI.Схема;
	ИмяСервера = ПараметрыПроекта.СтруктураURI.Сервер;
	Проект     = ПараметрыПроекта.Идентификатор;
	
	Запрос = Новый Структура;
	Запрос.Вставить("URL", СтрШаблон("%1://%2/api/v4/projects/%3/merge_requests", Схема, ИмяСервера, Проект));
	Запрос.Вставить("СекретныйКлюч", НастройкаСервисов.GitLabUserPrivateToken());
	
	Возврат Запрос;
	
КонецФункции

// Получение данных тела запроса по идентификационному номеру коммита.
// 
// Параметры:
//	ДанныеТелаЗапроса - Соответствие - преобразованные в Соответствие данные HTTP-запроса;
// 	ИскомыйИдентификатор - Строка - идентификационный номер коммита;
// Возвращаемое значение:
// 	Неопределено, Соответствие - возвращает коллекцию данных по коммиту, либо Неопределено, если данные не найдены; 
Функция ПолучитьДанныеКоммитаИзТелаЗапроса(Знач ДанныеТелаЗапроса, Знач ИскомыйИдентификатор = "") Экспорт
	
	Перем Результат;
	Перем Коммиты;
	Перем Идентификатор;
	
	Результат = Неопределено;
	
	Если ТипЗнч(ДанныеТелаЗапроса) <> Тип("Соответствие") ИЛИ ПустаяСтрока(ИскомыйИдентификатор) Тогда
		Возврат Результат;
	КонецЕсли;
	
	Коммиты = ДанныеТелаЗапроса.Получить("commits");
	
	Если Коммиты = Неопределено ИЛИ ТипЗнч(Коммиты) <> Тип("Массив") Тогда
		Возврат Результат;
	КонецЕсли;
	
	Для каждого Коммит Из Коммиты Цикл

		Идентификатор = Коммит.Получить("id");
		Если Идентификатор = Неопределено ИЛИ Идентификатор <> ИскомыйИдентификатор Тогда
			Продолжить;
		КонецЕсли;
		
		Результат = Коммит;
		
		Прервать;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Проверяет наличие записи о пользовательских настройках маршрутизации в данных тела запроса для определенного коммита.
// 
// Параметры:
//	ДанныеТелаЗапроса - Соответствие - преобразованные в Соответствие данные HTTP-запроса;
// 	ИдентификаторКоммита - Строка - идентификационный номер коммита;
// Возвращаемое значение:
// 	Булево - Истина, пользовательские настройки для коммита существуют, иначе - Ложь;
Функция ЕстьПользовательскиеНастройкиВДанныхКоммита(Знач ДанныеТелаЗапроса, Знач ИдентификаторКоммита) Экспорт
	
	Перем ДанныеКоммита;
	Перем Результат;
	
	Результат = Ложь;
	
	ДанныеКоммита = ПолучитьДанныеКоммитаИзТелаЗапроса(ДанныеТелаЗапроса, ИдентификаторКоммита);
	Если ДанныеКоммита = Неопределено ИЛИ ТипЗнч(ДанныеКоммита) <> Тип("Соответствие") Тогда
		Возврат Результат;
	КонецЕсли;
		
	ПользовательскиеНастройки = ДанныеКоммита.Получить("user_settings");
	
	Если ПользовательскиеНастройки <> Неопределено Тогда
		Результат = Истина;
	КонецЕсли;

	Возврат Результат;
	
КонецФункции

// Удаляет пользовательский вариант настроек маршрутизации для определенного коммита в данных тела запроса.
// 
// Параметры:
//	ДанныеТелаЗапроса - Соответствие - преобразованные в Соответствие данные HTTP-запроса;
// 	ИдентификаторКоммита - Строка - идентификационный номер коммита;
// 	НастройкиПоУмолчанию - Строка - (возвращаемый параметр), текст настройки маршрутизации в формате JSON
// 		из файла настроек внешнего хранилища;
Процедура УдалитьПользовательскиеНастройкиВДанныхКоммита(Знач ДанныеТелаЗапроса,
															Знач ИдентификаторКоммита,
															НастройкиПоУмолчанию = "") Экспорт
	
	Перем ДанныеКоммита;
	Перем Настройки;
	
	ДанныеКоммита = ПолучитьДанныеКоммитаИзТелаЗапроса(ДанныеТелаЗапроса, ИдентификаторКоммита);
	Если ДанныеКоммита = Неопределено ИЛИ ТипЗнч(ДанныеКоммита) <> Тип("Соответствие") Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеКоммита.Удалить("user_settings");
	Настройки = ДанныеКоммита.Получить("settings");
	
	Если Настройки <> Неопределено Тогда
		НастройкиПоУмолчанию = Настройки.Получить("json");
	КонецЕсли;

КонецПроцедуры

// Добавляет пользовательский вариант настроек маршрутизации для определенного коммита в данных тела запроса.
// 
// Параметры:
//	ДанныеТелаЗапроса - Соответствие - (возвращаемое значение), преобразованные в Соответствие данные HTTP-запроса;
// 	ИдентификаторКоммита - Строка - идентификационный номер коммита;
// 	JSON - Строка - текст настроек маршрутизации в формате JSON;
Процедура ДополнитьДанныеТелаЗапросаПользовательскимиНастройками(Знач ИдентификаторКоммита,
																	Знач JSON,
																	ДанныеТелаЗапроса) Экспорт
	
	Перем ДанныеКоммита;
	Перем ПользовательскиеНастройки;
	Перем Запись;
	Перем Поток;
	
	ДанныеКоммита = ПолучитьДанныеКоммитаИзТелаЗапроса(ДанныеТелаЗапроса, ИдентификаторКоммита);
	
	Если ДанныеКоммита = Неопределено ИЛИ ТипЗнч(ДанныеКоммита) <> Тип("Соответствие") Тогда
		Возврат;
	КонецЕсли;

	Поток = Новый ПотокВПамяти();
	Запись = Новый ЗаписьДанных(Поток);
	Запись.ЗаписатьСтроку(JSON);
	Поток.Перейти(0, ПозицияВПотоке.Начало);

	ПользовательскиеНастройки = Неопределено;
	ОбщегоНазначения.ПотокВКоллекциюКакJSON(Поток, Истина, Истина, ПользовательскиеНастройки);
	
	Если ПользовательскиеНастройки <> Неопределено Тогда
		ДанныеКоммита.Вставить("user_settings", ПользовательскиеНастройки);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

// Получение исходных данных запроса и настроек маршрутизации в формате json из сохраненных данных запроса.
// 
// Параметры:
// 	КлючЗаписи - РегистрСведенийКлючЗаписи.ОбработчикиСобытий - ключ записи с сохраненными записями;
// 	Действие - "ОткрытьJSONТелаЗапроса", "ОткрытьJSONМаршрутизации";
// Возвращаемое значение:
// 	- Неопределено - если не найдена запись с данными на регистре сведений; 
// 	- Строка - json HTTP-запроса;
// 	- ТаблицаЗначений - таблица настроек маршрутизации в формате json:
// * Коммит - Строка - номер коммита; 
// * ТекстJSON - Строка - json настроек маршрутизации;
Функция ИсходныеДанныеЗапросаВФорматеJSON(Знач КлючЗаписи, Знач Действие) Экспорт
	
	Перем ДанныеТелаЗапроса;
	Перем Настройки;
	Перем НоваяСтрока;
	Перем Результат;
	
	Результат = Неопределено;

	ДанныеТелаЗапроса = РегистрыСведений.ДанныеОбработчиковСобытий.ПолучитьДанныеТелаЗапроса(КлючЗаписи);
	Если ДанныеТелаЗапроса = Неопределено Тогда
		Возврат Результат;
	КонецЕсли;
	
	Если Действие = "ОткрытьJSONТелаЗапроса" Тогда
		
		Результат = "";
		Результат = ДанныеТелаЗапроса.Получить("json");
		
	ИначеЕсли Действие = "ОткрытьJSONМаршрутизации" Тогда
		
		Результат = Новый ТаблицаЗначений;
		Результат.Колонки.Добавить("Коммит", Новый ОписаниеТипов("Строка"));
		Результат.Колонки.Добавить("ТекстJSON", Новый ОписаниеТипов("Строка"));
		Результат.Колонки.Добавить("ПользовательскийВариант", Новый ОписаниеТипов("Булево"));
		
		Коммиты = ДанныеТелаЗапроса.Получить("commits");
		Для каждого Коммит Из Коммиты Цикл
			НоваяСтрока = Результат.Добавить();
			НоваяСтрока.Коммит = Коммит.Получить("id");
			
			ПользовательскиеНастройки = Коммит.Получить("user_settings");
			ЕстьПользовательскиеНастройки = ?(ПользовательскиеНастройки <> Неопределено, Истина, Ложь);
			
			Если ЕстьПользовательскиеНастройки Тогда
				Настройки = ПользовательскиеНастройки;
			Иначе
				Настройки = Коммит.Получить("settings");
			КонецЕсли;
			
			Если Настройки = Неопределено Тогда
				НоваяСтрока.ТекстJSON = "";
				Продолжить;
			КонецЕсли;
			НоваяСтрока.ТекстJSON = Настройки.Получить("json");
			НоваяСтрока.ПользовательскийВариант = ЕстьПользовательскиеНастройки;
		КонецЦикла;
		
	Иначе
		
		Результат = Неопределено;
		
	КонецЕсли;
	
	Возврат Результат;
		
КонецФункции


#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Сохраняет "исходные данные HTTP-запроса" или "обрабатываемые файлы" (См. РегистрСведений.ОбработчикиСобытий).
// 
// Параметры:
// 	ИдентификаторWebhook - СправочникСсылка.ОбработчикиСобытий - ссылка на описание webhook;
// 	Ключ - Строка - значение checkout_sha коммита;
// 	Ресурс - Строка - имя ресурса, в который записываются данные;
// 	Данные - Соответствие - любое значение, сохраняется в формате ХранилищеЗначения;
Процедура СохранитьДанныеВИБ(Знач ИдентификаторWebhook, Знач Ключ, Знач Ресурс, Знач Данные)
	
	Перем ТекстСообщения;
	
	Перем Блокировка;
	Перем ЭлементБлокировки;
	Перем ПараметрыКлюча;
	Перем КлючЗаписи;
	Перем ХранилищеЗначенияДанные;
	Перем ЗаписываемыеДанные;
	
//	Блокировка = Новый БлокировкаДанных;
//	ЭлементБлокировки       = Блокировка.Добавить("РегистрСведений.ДанныеОбработчиковСобытий");
//	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Разделяемый;
//	ЭлементБлокировки.УстановитьЗначение("Идентификатор", ИдентификаторWebhook);
//	ЭлементБлокировки.УстановитьЗначение("Ключ", Ключ);
//	Блокировка.Заблокировать();

	НачатьТранзакцию();	
	Попытка
		ПараметрыКлюча = Новый Структура;
		ПараметрыКлюча.Вставить("Идентификатор", ИдентификаторWebhook);
		ПараметрыКлюча.Вставить("Ключ", Ключ);
		КлючЗаписи = РегистрыСведений.ДанныеОбработчиковСобытий.СоздатьКлючЗаписи(ПараметрыКлюча);
		ХранилищеЗначенияДанные = Новый ХранилищеЗначения(Данные);
		ЗаписываемыеДанные = Новый Структура(Ресурс, ХранилищеЗначенияДанные);
		РегистрыСведений.ДанныеОбработчиковСобытий.ЗаписатьЗначенияРесурсов(КлючЗаписи, ЗаписываемыеДанные); 
		ЗафиксироватьТранзакцию();
	Исключение
		Если ТранзакцияАктивна() Тогда
			ОтменитьТранзакцию();
		КонецЕсли;
		
		ТекстСообщения = НСтр("ru = 'Не удалось сохранить данные в ИБ для ресурса: %1.'");
		ТекстСообщения = СтрШаблон(ТекстСообщения, Ресурс);
		
		ДополнительныеПараметры = Логирование.ДополнительныеДанные();
		ДополнительныеПараметры.Объект = ИдентификаторWebhook;
		Логирование.Предупреждение( "Core.СохранениеДанных", ТекстСообщения, ДополнительныеПараметры );
		
		Возврат;
	
	КонецПопытки;
	
КонецПроцедуры

#Область ФоновыеЗадания

Процедура ФоноваяОбработкаДанныхЗапроса(Знач ИдентификаторWebhook,
										Знач КлючЗапросаGitLab,
										Знач ДанныеТелаЗапроса,
										Знач ПараметрыПроектаРепозитория,
										Знач ЭтоРучнойЗапуск = Ложь) Экспорт
	
	Перем ПараметрыЗапроса;
	Перем ДанныеДляОтправки;
	Перем ПараметрыДоставки;
	Перем КлючОтправкиФайла;
	Перем ТекстСообщения;
	Перем ДополнительныеПараметры;
	
	ДополнительныеПараметры = Логирование.ДополнительныеДанные();
	ДополнительныеПараметры.Объект = ИдентификаторWebhook;
	
	Попытка
		
		ПараметрыЗапроса = Новый Структура;
		ПараметрыЗапроса.Вставить("КлючЗапросаGitLab", КлючЗапросаGitLab);
		ПараметрыЗапроса.Вставить("ПараметрыПроектаРепозитория", ПараметрыПроектаРепозитория);
		ПараметрыЗапроса.Вставить("ДанныеТелаЗапроса", ДанныеТелаЗапроса);
		ПараметрыЗапроса.Вставить("ЭтоРучнойЗапуск", ЭтоРучнойЗапуск);
		ПараметрыЗапроса = Новый ФиксированнаяСтруктура(ПараметрыЗапроса);
		
		ДанныеДляОтправки = ПодготовитьДанныеКОтправке(ИдентификаторWebhook, ПараметрыЗапроса);
		
		Если ДанныеДляОтправки.Количество() = 0 Тогда
			
			ТекстСообщения = НСтр("ru = '%1: нет данных для отправки. Задание завершено.'");
			ТекстСообщения = СтрШаблон(ТекстСообщения, КлючЗапросаGitLab);
			Логирование.Информация( "Core.ОбработкаДанныхВФоне", ТекстСообщения, ДополнительныеПараметры );
			
			Возврат;
			
		КонецЕсли;
		
//		ПараметрыДоставки = ИнициализироватьПараметрыДоставки();
//		ПараметрыДоставки.Token = AccessTokenReceiver();
//		ПараметрыДоставки.Таймаут = ТаймаутДоставкиФайла();
		
		ПараметрыДоставки = НастройкаСервисов.ПараметрыПолучателя(); 
		
		Для каждого ТочкаДоставки Из ДанныеДляОтправки Цикл
			
			ПараметрыДоставки.АдресДоставки = ТочкаДоставки.Адрес;
			
			КлючОтправкиФайла = КлючЗапросаGitLab + "|" + ТочкаДоставки.ИмяФайла + "|" + ТочкаДоставки.Адрес;
			
			ПараметрыЗадания = Новый Массив;
//			ПараметрыЗадания.Добавить(ИдентификаторWebhook);
//			ПараметрыЗадания.Добавить(КлючЗапросаGitLab);

			ПараметрыЗадания.Добавить(ТочкаДоставки.ИмяФайла);
			ПараметрыЗадания.Добавить(ТочкаДоставки.ДвоичныеДанные);
			ПараметрыЗадания.Добавить(ПараметрыДоставки);
			
			// В 8.3.14 реализован иной способ ожидания выполнения заданий, возможен пересмотр обработки исключений.
			Попытка
				
				АктивныеЗадания = АктивныеЗадачиПоКлючу(КлючОтправкиФайла);
				
				Если ЗначениеЗаполнено(АктивныеЗадания) Тогда
					
					ТекстСообщения = НСтр("ru = '%1: Задание отправки файла уже было запущено и активно: КлючФайла: %2'");
					ТекстСообщения = СтрШаблон(ТекстСообщения, КлючЗапросаGitLab, КлючОтправкиФайла);
					Логирование.Предупреждение( "Core.ПередачаФайлаВИБПриемник", ТекстСообщения, ДополнительныеПараметры );
					
					Продолжить;
					
				КонецЕсли;
				
				ЗаданиеОтправкаФайла = ФоновыеЗадания.Выполнить("ПередачаДанных.ОтправитьФайл",
																ПараметрыЗадания,
																КлючОтправкиФайла,
																"СервисыGitLab: " + КлючЗапросаGitLab);
			Исключение
				
				ТекстСообщения = НСтр("ru = '%1: UUID: %2; %3'");
				ТекстСообщения = СтрШаблон(ТекстСообщения,
										   КлючЗапросаGitLab,
										   ЗаданиеОтправкаФайла.УникальныйИдентификатор,
										   ИнформацияОбОшибке().Описание);
										   
				Логирование.Ошибка("Core.ПередачаФайлаВИБПриемник", ТекстСообщения, ДополнительныеПараметры );
				
			КонецПопытки;
			
		КонецЦикла;
		
		ТекстСообщения = НСтр("ru = '%1: количество файлов к отправке: %2'");
		ТекстСообщения = СтрШаблон(ТекстСообщения, КлючЗапросаGitLab, ДанныеДляОтправки.Количество());
		Логирование.Информация("Core.ОбработкаДанныхВФоне.Окончание", ТекстСообщения, ДополнительныеПараметры );
		
	Исключение
		
		ТекстСообщения = НСтр("ru = '%1: %2'");
		ТекстСообщения = СтрШаблон(ТекстСообщения, КлючЗапросаGitLab, ИнформацияОбОшибке().Описание);
		Логирование.Ошибка("Core.ОбработкаДанныхВФоне", ТекстСообщения, ДополнительныеПараметры);
		
	КонецПопытки;
	
КонецПроцедуры

Функция АктивныеЗадачиПоКлючу(Знач Ключ)
	
	Перем ПараметрыОтбора;
	Перем ВсеФоновыеЗадания;
	Перем АктивныеИсполнители;
	
	ПараметрыОтбора = Новый Структура("Ключ, Состояние", Ключ, СостояниеФоновогоЗадания.Активно);
	ВсеФоновыеЗадания = ФоновыеЗадания.ПолучитьФоновыеЗадания(ПараметрыОтбора);
	АктивныеИсполнители = Новый Массив;
	Для каждого Фоновое Из ВсеФоновыеЗадания Цикл
		Если Фоновое.Состояние = СостояниеФоновогоЗадания.Активно Тогда
			АктивныеИсполнители.Добавить(Фоновое);
		КонецЕсли;
	КонецЦикла;
	
	Возврат АктивныеИсполнители;
	
КонецФункции

#КонецОбласти


#Область РаботаСДанными

// TODO к удалению
// Получает параметры проекта репозитория из преобразованных в Соответствие данных тела запроса.
// 
// Параметры:
// 	ДанныеТелаЗапроса - (См. ПолучитьДанныеТелаЗапроса.ДанныеТелаЗапроса).
// Возвращаемое значение:
// 	Структура - Описание:
// * Идентификатор - Строка - идентификатор проекта.
// * СтруктураURI - (См. ОбщегоНазначенияКлиентСервер.СтруктураURI). 
Функция ПараметрыПроектаИзТелаЗапроса(Знач ДанныеТелаЗапроса)
	
	Перем ОписаниеПроекта;
	Перем ВебАдрес;
	Перем Идентификатор;
	Перем СтруктураURI;
	
	Перем Результат;
	
	Результат = Новый Структура;
	
	Если ДанныеТелаЗапроса = Неопределено Тогда
		Возврат Результат;
	КонецЕсли;
	
	ОписаниеПроекта = ДанныеТелаЗапроса.Получить("project");
	
	ВебАдрес      = ОписаниеПроекта.Получить("web_url");
	Идентификатор = Строка(ОписаниеПроекта.Получить("id"));
	Результат.Вставить("Идентификатор", Идентификатор);
	
	// TODO перепроверить вызов
	СтруктураURI = КоннекторHTTP.РазобратьURL(ВебАдрес);
	НачалоПуть = СтрНайти(ВебАдрес, СтруктураURI.Путь) - 1;
	URLСервера = ?(НачалоПуть >= 0, Лев(ВебАдрес, НачалоПуть), "" );
	СтруктураURI.Вставить( "URLСервера", URLСервера );
	Результат.Вставить("СтруктураURI", Новый ФиксированнаяСтруктура(СтруктураURI));
	
	Возврат Результат;
	
КонецФункции

Функция ПодготовитьДанныеКОтправке(Знач ИдентификаторWebhook, Знач Параметры)
	
	Перем КлючЗапроса;
	Перем ДанныеТелаЗапроса;

	Перем ТочкиДоставки;
	Перем НовыйКлючЗаписи;
	Перем ДанныеДляОтправки;
	Перем ТекстСообщения;
	
	ДанныеТелаЗапроса = Параметры.ДанныеТелаЗапроса;
	Таймаут = НастройкаСервисов.ТаймаутGitLab();

	ДополнительныеПараметры = Логирование.ДополнительныеДанные();
	ДополнительныеПараметры.Объект = ИдентификаторWebhook;	

	ТекстСообщения = НСтр("ru = '%1: подготовка данных к отправке.'");
	ТекстСообщения = СтрШаблон(ТекстСообщения, Параметры.КлючЗапросаGitLab);

	Логирование.Информация("Core.ПодготовкаДанных.Начало", ТекстСообщения, ДополнительныеПараметры);

	Если Параметры.ЭтоРучнойЗапуск Тогда
		НовыйКлючЗаписи = Новый Структура("Идентификатор, Ключ", ИдентификаторWebhook, Параметры.КлючЗапросаGitLab);
		КлючЗапроса = РегистрыСведений.ДанныеОбработчиковСобытий.СоздатьКлючЗаписи(НовыйКлючЗаписи);
		ДанныеДляОтправки = РегистрыСведений.ДанныеОбработчиковСобытий.ПолучитьДанныеОтправки(КлючЗапроса);
	Иначе

		ДанныеДляОтправки = Gitlab.ПолучитьФайлыКОтправкеПоДаннымЗапроса(ИдентификаторWebhook, ДанныеТелаЗапроса);
		Маршрутизация.ДополнитьЗапросНастройкамиМаршрутизации(ДанныеТелаЗапроса, ДанныеДляОтправки);

		СервисыGitLab.СохранитьДанныеТелаЗапросаВИБ(ИдентификаторWebhook, Параметры.КлючЗапросаGitLab, ДанныеТелаЗапроса);
		СервисыGitLab.СохранитьДвоичныеДанныеВИБ(ИдентификаторWebhook, Параметры.КлючЗапросаGitLab, ДанныеДляОтправки);
	КонецЕсли;
	
	ТочкиДоставки     = ТочкиДоставкиФайлов(ИдентификаторWebhook, ДанныеТелаЗапроса, ДанныеДляОтправки);
	ДанныеДляОтправки = РаспределитьДанныеПоМаршрутам(ДанныеДляОтправки, ТочкиДоставки);
	
	ТекстСообщения = НСтр("ru = '%1: подготовка данных к отправке.'");
	ТекстСообщения = СтрШаблон(ТекстСообщения, Параметры.КлючЗапросаGitLab);
	Логирование.Информация("Core.ПодготовкаДанных.Окончание", ТекстСообщения, ДополнительныеПараметры );
	
	Возврат ДанныеДляОтправки;
	
КонецФункции

// Распределяет двоичные данные для отправки по точкам доставки.
//
// Параметры:
// 	ДанныеДляОтправки - (См. ОписаниеТаблицыДанныхДляОтправки);
// 	ТочкиДоставки - (См. ТочкиДоставкиФайловИзДанныхЗапроса);
// Возвращаемое значение:
// 	(См. ОписаниеТаблицыДанныхДляОтправки).
Функция РаспределитьДанныеПоМаршрутам(Знач ДанныеДляОтправки, Знач ТочкиДоставки)
	
	Перем ПараметрыОтбора;
	Перем НайденныеДвоичныеДанные;
	Перем ДвоичныеДанные;
	Перем НоваяСтрока;
	Перем Результат;
	
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("Коммит", );
	ПараметрыОтбора.Вставить("ПолноеИмяФайла", );
	
	Результат = ТочкиДоставки.СкопироватьКолонки();
	
	Для каждого ТочкаДоставки Из ТочкиДоставки Цикл
		
		ПараметрыОтбора.Коммит   		= ТочкаДоставки.Коммит;
		ПараметрыОтбора.ПолноеИмяФайла 	= ТочкаДоставки.ПолноеИмяФайла;
		
		НайденныеДвоичныеДанные = ДанныеДляОтправки.НайтиСтроки(ПараметрыОтбора);
		
		Если ЗначениеЗаполнено(НайденныеДвоичныеДанные) Тогда
			
			ДвоичныеДанные = НайденныеДвоичныеДанные[0].ДвоичныеДанные;
			
			Если ДвоичныеДанные <> Неопределено Тогда
				
				НоваяСтрока = Результат.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, ТочкаДоставки);
				НоваяСтрока.ДвоичныеДанные = ДвоичныеДанные;
				
			КонецЕсли;
		
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Подготавливает таблицу точек доставки файлов до сервисов ИБ-получателей.
// 
// Параметры:
// Возвращаемое значение:
// 	ТаблицаЗначений - описание:
// * Коммит - Строка - идентификатор коммита;
// * ИмяФайла - Строка - имя файла;
// * ПолноеИмяФайла - Строка - имя файла вместе с директориями;
// * Адрес - Строка - адрес сервиса ИБ-получателя;
Функция ОписаниеТаблицыТочекДоставкиФайлов()

	Перем ТаблицаЗначений;
	
	ТаблицаЗначений = Новый ТаблицаЗначений;
	ТаблицаЗначений.Колонки.Добавить("Коммит", Новый ОписаниеТипов("Строка")); 
	ТаблицаЗначений.Колонки.Добавить("ИмяФайла", Новый ОписаниеТипов("Строка")); 
	ТаблицаЗначений.Колонки.Добавить("ПолноеИмяФайла", Новый ОписаниеТипов("Строка")); 
	ТаблицаЗначений.Колонки.Добавить("Адрес", Новый ОписаниеТипов("Строка"));
	ТаблицаЗначений.Колонки.Добавить("ДвоичныеДанные", Новый ОписаниеТипов("ДвоичныеДанные"));
	
	Возврат ТаблицаЗначений;
	
КонецФункции

// По данным преобразованного в Соответствие тела запроса подготавливает таблицу точек доставки файлов.
//
// Параметры:
// 	ИдентификаторWebhook - СправочникСсылка.ОбработчикиСобытий - ссылка на описание webhook;
// 	ДанныеТелаЗапроса - (См. ПолучитьДанныеТелаЗапроса.ДанныеТелаЗапроса)
// Возвращаемое значение:
// 	(См. ОписаниеТаблицыТочекДоставкиФайлов).
Функция ТочкиДоставкиФайлов(Знач ИдентификаторWebhook, Знач ДанныеТелаЗапроса, Знач ДанныеДляОтправки)
	
	Перем Коммиты;
	Перем ТочкиДоставки;
	
	Коммиты       = ДанныеТелаЗапроса.Получить("commits");
	ТочкиДоставки = ОписаниеТаблицыТочекДоставкиФайлов();
	
	ТочкиДоставкиФайловПоВсемИзменениям(ИдентификаторWebhook, ДанныеДляОтправки, Коммиты, ТочкиДоставки);
	СкорректироватьТочкиДоставкиФайлов(ИдентификаторWebhook, Коммиты, ТочкиДоставки);
	
	Возврат ТочкиДоставки;
	
КонецФункции

// Корректирует полный перечень точек доставки файлов применяя правила маршрутизации.
//
// Параметры:
// 	ИдентификаторWebhook - СправочникСсылка.ОбработчикиСобытий - ссылка на описание webhook;
// 	Коммиты - Соответствие - (См. ДополнитьДанныеЗапросаНастройками.ДанныеТелаЗапроса)
// 	ТочкиДоставки - (См. ОписаниеТаблицыТочекДоставкиФайлов).
Процедура СкорректироватьТочкиДоставкиФайлов(Знач ИдентификаторWebhook, Знач Коммиты, ТочкиДоставки)
	
	Перем ТекстСообщения;
	Перем ДоступныеСервисыДоставки;
	Перем ИдентификаторКоммита;
	Перем Настройки;
	
	ДополнительныеПараметры = Логирование.ДополнительныеДанные();
	ДополнительныеПараметры.Объект = ИдентификаторWebhook;	
	
	Для каждого Коммит Из Коммиты Цикл
		
		ИдентификаторКоммита = Коммит.Получить("id");
		Настройки            = Коммит.Получить("settings");
		
		Если Настройки = Неопределено Тогда
			ТекстСообщения = СтрШаблон(НСтр("ru = '%1: отстутствуют настройки маршрутизации.'"), ИдентификаторКоммита);
			Логирование.Информация("Core.ФормированиеМаршрутовДоставки", ТекстСообщения, ДополнительныеПараметры);
			Продолжить;
			
		КонецЕсли;
		
		ДоступныеСервисыДоставки = ДоступныеСервисыДоставки(Настройки);
		СкорректироватьТочкиДоставкиФайловКоммита(ИдентификаторКоммита, Настройки, ДоступныеСервисыДоставки, ТочкиДоставки);
		
	КонецЦикла;
	
КонецПроцедуры

// Формирует перечень точек доставки файлов на основании правил маршрутизации для определенного коммита.
//
// Параметры:
// 	ИдентификаторКоммита - Строка - идентификатор коммита;
// 	Настройки - Соответствие - (См. ДополнитьДанныеЗапросаНастройками.ДанныеТелаЗапроса)
// 	ДоступныеСервисыДоставки - (См. ДоступныеСервисыДоставки)
// 	ТочкиДоставки - (См. ОписаниеТаблицыТочекДоставкиФайлов).
Процедура СкорректироватьТочкиДоставкиФайловКоммита(Знач ИдентификаторКоммита,
													Знач Настройки,
													Знач ДоступныеСервисыДоставки,
														 ТочкиДоставки)
                                                         
	Перем НастройкиДоставкиФайлов;
	Перем ПолноеИмяФайла;
	Перем Исключения;
	Перем ИсключаемыйАдрес;
	
	НастройкиДоставкиФайлов = Неопределено;
	НастройкиДоставкиФайлов = Настройки.Получить("epf");
	
	Если НастройкиДоставкиФайлов = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("Коммит", ИдентификаторКоммита);
	ПараметрыОтбора.Вставить("ПолноеИмяФайла",);
	ПараметрыОтбора.Вставить("Адрес",);
	
	Для каждого НастройкаДоставкиФайла Из НастройкиДоставкиФайлов Цикл
		
		ПолноеИмяФайла = НастройкаДоставкиФайла.Получить("file");
		
		Если ПолноеИмяФайла = Неопределено ИЛИ ПустаяСтрока(ПолноеИмяФайла) Тогда
			Продолжить;
		КонецЕсли;
		
		Исключения = НастройкаДоставкиФайла.Получить("exclude");
		
		Если Исключения = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		Для каждого ТекущееИсключение Из Исключения Цикл
			
			ИсключаемыйАдрес = ДоступныеСервисыДоставки.Получить(ТекущееИсключение);
			
			Если ИсключаемыйАдрес <> Неопределено Тогда
				
				ПараметрыОтбора.ПолноеИмяФайла = ПолноеИмяФайла;
				ПараметрыОтбора.Адрес          = ИсключаемыйАдрес;
				
				НайденныеСтроки = ТочкиДоставки.НайтиСтроки(ПараметрыОтбора);
				
				Для каждого УдаляемаяСтрока Из НайденныеСтроки Цикл
					ТочкиДоставки.Удалить(УдаляемаяСтрока);
				КонецЦикла;
			
			КонецЕсли;
		
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

// Формирует перечень точек доставки файлов для всех изменений без учета правил маршрутизации.
//
// Параметры:
// 	ИдентификаторWebhook - СправочникСсылка.ОбработчикиСобытий - ссылка на описание webhook;
//	ДанныеДляОтправки - (См. ОписаниеТаблицыДанныхДляОтправки)
// 	Коммиты - Соответствие - (См. ДополнитьДанныеЗапросаНастройками.ДанныеТелаЗапроса)
// 	ТочкиДоставки - (См. ОписаниеТаблицыТочекДоставкиФайлов).
Процедура ТочкиДоставкиФайловПоВсемИзменениям(Знач ИдентификаторWebhook,
											  Знач ДанныеДляОтправки,
											  Знач Коммиты,
												   ТочкиДоставки)
                                                   
	Перем ТекстСообщения;
	Перем ДоступныеСервисыДоставки;
	Перем ИдентификаторКоммита;
	Перем Настройки;
	
	ДополнительныеПараметры = Логирование.ДополнительныеДанные();
	ДополнительныеПараметры.Объект = ИдентификаторWebhook;	
	
	Для каждого Коммит Из Коммиты Цикл
		
		ИдентификаторКоммита = Коммит.Получить("id");
		
		Настройки = Коммит.Получить("user_settings");
		
		Если Настройки = Неопределено Тогда
			Настройки = Коммит.Получить("settings");
		КонецЕсли;
		
		Если Настройки = Неопределено Тогда
			
			ТекстСообщения = СтрШаблон(НСтр("ru = '%1: отстутствуют настройки маршрутизации.'"), ИдентификаторКоммита);
			Логирование.Информация( "Core.ФормированиеМаршрутовДоставки", ТекстСообщения, ДополнительныеПараметры );
			Продолжить;
			
		КонецЕсли;
		
		ДоступныеСервисыДоставки = ДоступныеСервисыДоставки(Настройки);
		ТочкиДоставкиФайловПоВсемИзменениямКоммита(ИдентификаторКоммита,
												   ДанныеДляОтправки,
												   ДоступныеСервисыДоставки,
												   ТочкиДоставки);
		
	КонецЦикла;
	
КонецПроцедуры


// Формирует перечень точек доставки файлов для всех изменений без учета правил маршрутизации для определенного коммита.
//
// Параметры:
// 	ИдентификаторКоммита - Строка - индентификатор коммита;
//	ДанныеДляОтправки - (См. ОписаниеТаблицыДанныхДляОтправки)
// 	ДоступныеСервисыДоставки - (См. ДоступныеСервисыДоставки)
// 	ТочкиДоставки - (См. ОписаниеТаблицыТочекДоставкиФайлов).
Процедура ТочкиДоставкиФайловПоВсемИзменениямКоммита(Знач ИдентификаторКоммита,
													 Знач ДанныеДляОтправки,
													 Знач ДоступныеСервисыДоставки,
														  ТочкиДоставки)
														  	
	Перем ПараметрыОтбора;
	Перем НайденныеСтроки;
	Перем НоваяСтрока;
	
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("Коммит", ИдентификаторКоммита);
	
	НайденныеСтроки = ДанныеДляОтправки.НайтиСтроки(ПараметрыОтбора);
	
	Для каждого Файл Из НайденныеСтроки Цикл
		
		Для каждого СервисДоставки Из ДоступныеСервисыДоставки Цикл
			
			Если СервисДоставки.Значение = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			
			НоваяСтрока = ТочкиДоставки.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Файл, , "ДвоичныеДанные");
			НоваяСтрока.Адрес = СервисДоставки.Значение;
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

// По данным настроек маршрутизации подготавливает список доступных сервисов.
// 
// Параметры:
// 	Настройки - Соответствие - настройки маршрутизации для конкретного коммита.  
// Возвращаемое значение:
// 	Соответствие - доступные сервисы доставки:
//	* Ключ - Строка - имя сервиса
//	* Значение - Строка - адрес сервиса
Функция ДоступныеСервисыДоставки(Знач Настройки)
	
	Перем Результат;
	Перем ВсеСервисыДоставки;
	Перем ИмяСервиса;
	Перем СервисВключен;
	Перем АдресСервиса;
	
	Результат          = Новый Соответствие;
	ВсеСервисыДоставки = Неопределено;
	
	ВсеСервисыДоставки = Настройки.Получить("ws");
	
	Если ВсеСервисыДоставки = Неопределено Тогда
		Возврат Результат;
	КонецЕсли;
	
	Для каждого СервисДоставки Из ВсеСервисыДоставки Цикл
		
		ИмяСервиса = СервисДоставки.Получить("name");
		Если ИмяСервиса = Неопределено ИЛИ ПустаяСтрока(ИмяСервиса) Тогда
			Продолжить;
		КонецЕсли;
		
		СервисВключен = СервисДоставки.Получить("enabled");
		Если СервисВключен <> Неопределено И СервисВключен Тогда
			
			АдресСервиса = СервисДоставки.Получить("address");
			Если АдресСервиса <> Неопределено И НЕ ПустаяСтрока(АдресСервиса) Тогда
				Результат.Вставить(ИмяСервиса, АдресСервиса);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецОбласти