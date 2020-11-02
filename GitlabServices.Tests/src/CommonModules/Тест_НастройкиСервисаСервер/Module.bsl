#Region Internal

// @unit-test
Процедура ПараметрыПолучателя(Фреймворк) Экспорт

	НачатьТранзакцию();	
	Попытка
		// given
		Константы.ReceiverAccessToken.Установить("998");
		Константы.ТаймаутДоставкиФайла.Установить(999);
		// when
		Результат = НастройкаСервисов.ПараметрыПолучателя();
		// then
		Фреймворк.ПроверитьРавенство(Результат.Количество(), 3);
		Фреймворк.ПроверитьРавенство(Результат.Адрес, "localhost/receiver/hs/gitlab");
		Фреймворк.ПроверитьРавенство(Результат.Token, "998");
		Фреймворк.ПроверитьРавенство(Результат.Таймаут, 999);		

		ОтменитьТранзакцию();					
		
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;

КонецПроцедуры

// @unit-test
Процедура ПараметрыПолучателяОтрицательныйТаймаутДоставкиФайла(Фреймворк) Экспорт

	НачатьТранзакцию();	
	Попытка
		// given
		Константы.ReceiverAccessToken.Установить("998");
		Константы.ТаймаутДоставкиФайла.Установить(999);
		// when
		Результат = НастройкаСервисов.ПараметрыПолучателя();
		// then
		Фреймворк.ПроверитьРавенство(Результат.Количество(), 3);
		Фреймворк.ПроверитьРавенство(Результат.Адрес, "localhost/receiver/hs/gitlab");
		Фреймворк.ПроверитьРавенство(Результат.Token, "998");
		Константы.ТаймаутДоставкиФайла.Установить(-5);
		Результат = НастройкаСервисов.ПараметрыПолучателя();
		Фреймворк.ПроверитьРавенство(Результат.Таймаут, 0);

		ОтменитьТранзакцию();					
		
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;

КонецПроцедуры

// @unit-test
Процедура CurrentSettings(Фреймворк) Экспорт

	НачатьТранзакцию();	
	Попытка
		// given		
		Константы.ОбрабатыватьЗапросыВнешнегоХранилища.Установить(Истина);
		Константы.ИмяФайлаНастроекМаршрутизации.Установить("ИмяФайла.json");
		Константы.GitLabPersonalAccessToken.Установить("GitLabPersonalAccessToken");
		Константы.GitLabTimeout.Установить(998);
		Константы.ReceiverAccessToken.Установить("ReceiverAccessToken");
		Константы.ТаймаутДоставкиФайла.Установить(999);
		// when
		Результат = НастройкаСервисов.CurrentSettings();
		// then
		Фреймворк.ПроверитьТип(Результат, "ФиксированнаяСтруктура");
		Фреймворк.ПроверитьРавенство(Результат.Количество(), 6);
		Фреймворк.ПроверитьИстину(Результат.ОбрабатыватьЗапросыВнешнегоХранилища);
		Фреймворк.ПроверитьРавенство(Результат.ИмяФайлаНастроекМаршрутизации, "ИмяФайла.json");
		Фреймворк.ПроверитьРавенство(Результат.GitLabPersonalAccessToken, "GitLabPersonalAccessToken");		
		Фреймворк.ПроверитьРавенство(Результат.GitLabTimeout, 998);		
		Фреймворк.ПроверитьРавенство(Результат.AccessTokenReceiver, "ReceiverAccessToken");
		Фреймворк.ПроверитьРавенство(Результат.ТаймаутДоставкиФайла, 999);		
		
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;

КонецПроцедуры

#EndRegion
