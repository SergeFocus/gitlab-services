#Region Public

// Отправка файла в информационную базу получателя. Адрес подключения определяется из параметра доставки.
// На конечных точках (базах получателях) должен быть реализован API обновления внешних отчетов и обработок:
// https://app.swaggerhub.com/apis-docs/astrizhachuk/gitlab-services-receiver/1.0.0
// 
// Параметры:
// 	ИмяФайла - Строка - имя файла, по которому производится поиск и замена внешних отчетов и обработок (UTF-8);
// 	Данные - ДвоичныеДанные - тело файла в двоичном формате;
// 	ПараметрыДоставки - Структура - параметры доставки файла:
// * Адрес - Строка - адрес веб-сервиса для работы с внешними отчетами и обработками в информационной базе получателе;
// * Token - Строка - token доступа к сервису получателя;
// * Таймаут - Число - таймаут соединения с сервисом, секунд (если 0 - таймаут не установлен);
// 	ПараметрыСобытия - Неопределено, Структура - описание события, запустившее отправку файла:
// * ОбработчикСобытия - СправочникСсылка.ОбработчикиСобытий - ссылка на элемент справочника с обработчиками событий;
// * CheckoutSHA - Строка - уникальный идентификатор события (commit SHA), для которого запускается отправка файла;
//
Процедура ОтправитьФайл( Знач ИмяФайла, Знач Данные, Знач ПараметрыДоставки, ПараметрыСобытия = Неопределено ) Экспорт
	
	Var Заголовки;
	Var ПараметрыЗапроса;
	Var Ответ;
	Var КодСостояния;
	Var Сообщение;
	
	MISSING_DELIVERY_MESSAGE = НСтр( "ru = 'Отсутствуют параметры доставки файлов.';
									|en = 'File delivery options are missing.'" );
	Ответ = Неопределено;
	
	Попытка
		
		Если ( ТипЗнч(ПараметрыДоставки) <> Тип("Структура")
				ИЛИ НЕ ПараметрыДоставки.Свойство("Адрес")
				ИЛИ НЕ ПараметрыДоставки.Свойство("Token") ) Тогда
			
			ВызватьИсключение MISSING_DELIVERY_MESSAGE;
			
		КонецЕсли; 
		
		Заголовки = Новый Соответствие();
		Заголовки.Вставить( "Token", ПараметрыДоставки.Token );
		Заголовки.Вставить( "Name", КодироватьСтроку(ИмяФайла, СпособКодированияСтроки.URLВКодировкеURL) );
		
		ПараметрыЗапроса = Новый Структура();
		ПараметрыЗапроса.Вставить( "Заголовки", Заголовки );
		ПараметрыЗапроса.Вставить( "Таймаут", ПараметрыДоставки.Таймаут );
		
		Ответ = HTTPConnector.Post( ПараметрыДоставки.Адрес, Данные, ПараметрыЗапроса );
		
		Сообщение = СформироватьСообщение( Ответ, ИмяФайла, ПараметрыДоставки );
	
		Если ( НЕ HTTPStatusCodesClientServerCached.isOk(Ответ.КодСостояния) ) Тогда
			
			ВызватьИсключение Сообщение;
			
		КонецЕсли;
		
		ВыполнитьЛогированиеСообщения( Сообщение, ПараметрыСобытия, Ответ.КодСостояния );
		
	Исключение
		
		КодСостояния = ?( Ответ = Неопределено,
			HTTPStatusCodesClientServerCached.FindCodeById("INTERNAL_SERVER_ERROR"),
			Ответ.КодСостояния );
			
		Сообщение = ИнформацияОбОшибке().Описание;
		
		ВыполнитьЛогированиеСообщения( Сообщение, ПараметрыСобытия, КодСостояния );
		
		ВызватьИсключение Сообщение;
		
	КонецПопытки;
		
КонецПроцедуры

#EndRegion

#Region Private

Процедура ВыполнитьЛогированиеСообщения( Сообщение, Знач ПараметрыСобытия, Знач КодСостояния )
	
	Var HTTPОтвет;
	Var ПараметрыЛогирования;
	
	EVENT_MESSAGE = НСтр( "ru = 'Core.ОтправкаДанныхПолучателю';en = 'Core.SendingFileReceiver'" );
	
	ПараметрыЛогирования = Неопределено;
	
	Если ( ПараметрыСобытия <> Неопределено ) Тогда
		
		HTTPОтвет = Новый HTTPСервисОтвет( КодСостояния );
		ПараметрыЛогирования = Логирование.ДополнительныеПараметры( ПараметрыСобытия.ОбработчикСобытия, HTTPОтвет );
		Сообщение = Логирование.ДополнитьСообщениеПрефиксом( Сообщение, ПараметрыСобытия.CheckoutSHA );
		
	КонецЕсли;
	
	Если ( HTTPStatusCodesClientServerCached.isOk(КодСостояния) ) Тогда
		
		Логирование.Информация( EVENT_MESSAGE, Сообщение, ПараметрыЛогирования );

	Иначе
		
		Логирование.Ошибка( EVENT_MESSAGE, Сообщение, ПараметрыЛогирования );
		
	КонецЕсли;
	
КонецПроцедуры

Функция СформироватьСообщение( Знач Ответ, Знач ИмяФайла, Знач ПараметрыДоставки )
	
	Var ТекстОтвета;
	Var Результат;
	
	DELIVERY_MESSAGE = НСтр( "ru = 'адрес доставки: %1; файл: %2';en = 'delivery address: %1; file: %2'" );
	ERROR_STATUS_CODE_MESSAGE = НСтр( "ru = '[ Ошибка ]: Код ответа: ';en = '[ Error ]: Response Code: '" );
	SERVER_RESPONSE_MESSAGE = НСтр( "ru = '; текст ответа:';en = '; response message:'" ); 
	
	Результат = СтрШаблон( DELIVERY_MESSAGE, ПараметрыДоставки.Адрес, ИмяФайла );
	
	Если ( HTTPStatusCodesClientServerCached.isOk(Ответ.КодСостояния) ) Тогда
		
		ТекстОтвета = HTTPConnector.КакТекст(Ответ, КодировкаТекста.UTF8);
		
	Иначе
		
		ТекстОтвета = ERROR_STATUS_CODE_MESSAGE + Ответ.КодСостояния;
		
	КонецЕсли;
	
	Возврат Результат + SERVER_RESPONSE_MESSAGE + Символы.ПС + ТекстОтвета;
	
КонецФункции

#EndRegion
