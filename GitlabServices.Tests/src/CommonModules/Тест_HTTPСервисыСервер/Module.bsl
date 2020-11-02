// BSLLS-выкл.
#Region Internal

// @unit-test
Процедура СтруктураОтвета(Фреймворк) Экспорт

	// when
	Результат = HTTPСервисы.СтруктураОтвета();
	// then
	Фреймворк.ПроверитьРавенство(Результат.Количество(), 2);
	Фреймворк.ПроверитьИстину(Результат.Свойство("type"));
	Фреймворк.ПроверитьИстину(Результат.Свойство("message"));
	
КонецПроцедуры

//@unit-test
Процедура ОписаниеНеСуществующегоСервиса(Фреймворк) Экспорт

	// given
	Константы.ОбрабатыватьЗапросыВнешнегоХранилища.Установить(Истина);
	URL = "фэйк";
	// when
	ОписаниеСервиса = HTTPСервисы.ОписаниеСервиса(URL);
	// then
	Фреймворк.ПроверитьРавенство(ОписаниеСервиса, Неопределено);

КонецПроцедуры

//@unit-test
Процедура ОписаниеСуществующегоСервиса(Фреймворк) Экспорт

	// given
	Константы.ОбрабатыватьЗапросыВнешнегоХранилища.Установить(Истина);
	URL = "gitlab";
	// when
	ОписаниеСервиса = HTTPСервисы.ОписаниеСервиса(URL);
	// then
	ОписаниеСервиса = HTTPСервисы.ОписаниеСервиса("gitlab");
	Фреймворк.ПроверитьИстину(ОписаниеСервиса.Свойство("name"));
	Фреймворк.ПроверитьИстину(ОписаниеСервиса.Свойство("desc"));
	Фреймворк.ПроверитьИстину(ОписаниеСервиса.Свойство("enabled"));
	Фреймворк.ПроверитьИстину(ОписаниеСервиса.Свойство("templates"));
	Фреймворк.ПроверитьРавенство(ОписаниеСервиса.templates.Количество(), 2);
	Фреймворк.ПроверитьИстину(ОписаниеСервиса.templates[0].Свойство("name"));
	Фреймворк.ПроверитьИстину(ОписаниеСервиса.templates[0].Свойство("desc"));
	Фреймворк.ПроверитьИстину(ОписаниеСервиса.templates[0].Свойство("template"));
	Фреймворк.ПроверитьИстину(ОписаниеСервиса.templates[0].Свойство("methods"));
	Фреймворк.ПроверитьРавенство(ОписаниеСервиса.templates[0].methods.Количество(), 1);
	Фреймворк.ПроверитьИстину(ОписаниеСервиса.templates[0].methods[0].Свойство("name"));
	Фреймворк.ПроверитьИстину(ОписаниеСервиса.templates[0].methods[0].Свойство("desc"));
	Фреймворк.ПроверитьИстину(ОписаниеСервиса.templates[0].methods[0].Свойство("method"));

КонецПроцедуры

// @unit-test
Процедура ОписаниеСервисаURLBadURL(Фреймворк) Экспорт
	
	// given
	Константы.ОбрабатыватьЗапросыВнешнегоХранилища.Установить(Истина);
	URL = "йохохо";
	// when
	Попытка
		HTTPСервисы.ОписаниеСервисаURL(URL);
		ВызватьИсключение НСтр("ru = 'Должна быть ошибка при вызове метода, но это не так.'");
	Исключение
		// then
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		Фреймворк.ПроверитьВхождение(КраткоеПредставлениеОшибки(ИнформацияОбОшибке),
		 							"Couldn't resolve host name");
	КонецПопытки;		

КонецПроцедуры

// @unit-test
Процедура ОписаниеСервисаURLПустойURL(Фреймворк) Экспорт
	
	// given
	Константы.ОбрабатыватьЗапросыВнешнегоХранилища.Установить(Истина);
	URL = "";
	// when
	Результат = HTTPСервисы.ОписаниеСервисаURL(URL);
	//then
	Фреймворк.ПроверитьТип(Результат, "Неопределено", "Пустой адрес");

КонецПроцедуры

// @unit-test
Процедура ОписаниеСервисаURLНеверныйТип(Фреймворк) Экспорт
	
	// given
	Константы.ОбрабатыватьЗапросыВнешнегоХранилища.Установить(Истина);
	URL = Новый Массив;
	// when
	Результат = HTTPСервисы.ОписаниеСервисаURL(URL);
	//then
	Фреймворк.ПроверитьТип(Результат, "Неопределено", "Неверный тип");

КонецПроцедуры

// @unit-test
Процедура ОписаниеСервисаURLНеверноеИмяСервиса(Фреймворк) Экспорт
	
	// given
	Константы.ОбрабатыватьЗапросыВнешнегоХранилища.Установить(Истина);
	URL = "http://transmitter/api/hs/gitlab";
	URL = URL + "йохохо";
	// when
	Результат = HTTPСервисы.ОписаниеСервисаURL(URL);
	//then
	Фреймворк.ПроверитьТип(Результат, "Неопределено", "Ошибка в имени сервиса");

КонецПроцедуры

// @unit-test
Процедура ОписаниеСервисаURLОшибкаПреобразования(Фреймворк) Экспорт
	
	// given
	Константы.ОбрабатыватьЗапросыВнешнегоХранилища.Установить(Истина);
	URL = "http://www.example.com";
	// when
	Результат = HTTPСервисы.ОписаниеСервисаURL(URL);
	//then
	Фреймворк.ПроверитьТип(Результат, "Неопределено", "Ошибка преобразования тела ответа в коллекцию");

КонецПроцедуры

// @unit-test
Процедура ОписаниеСервисаURL404NotFound(Фреймворк) Экспорт
	
	// given
	Константы.ОбрабатыватьЗапросыВнешнегоХранилища.Установить(Истина);
	URL = "http://www.example.com/NotFound";
	// when
	Результат = HTTPСервисы.ОписаниеСервисаURL(URL);
	//then
	Фреймворк.ПроверитьТип(Результат, "Неопределено", "Страница не найдена");

КонецПроцедуры

// @unit-test
Процедура ОписаниеСервисаURL(Фреймворк) Экспорт
	
	// given
	Константы.ОбрабатыватьЗапросыВнешнегоХранилища.Установить(Истина);
	URL = "http://transmitter/api/hs/gitlab";
	URL = URL + "/services";
	// when
	Результат = HTTPСервисы.ОписаниеСервисаURL(URL);
	// then
	Фреймворк.ПроверитьИстину(Результат.Свойство("Response"));
	Фреймворк.ПроверитьТип(Результат.Response, "Структура", "Веб-сервис не отвечает.");
	Фреймворк.ПроверитьЗаполненность(Результат.Response, "Ответ веб-сервиса не должен быть пустым.");
	Фреймворк.ПроверитьРавенство(Результат.Response.КодСостояния, 200, "Веб-сервис отвечает, но с ошибкой.");
	Фреймворк.ПроверитьРавенство(Результат.Количество(), 3);
	Фреймворк.ПроверитьИстину(Результат.Свойство("Response"));
	Фреймворк.ПроверитьИстину(Результат.Свойство("Data"));
	Фреймворк.ПроверитьИстину(Результат.Свойство("JSON"));
	Фреймворк.ПроверитьВхождение(Результат.JSON, """version""");
	Фреймворк.ПроверитьВхождение(Результат.JSON, """services""");
	Фреймворк.ПроверитьВхождение(Результат.JSON, """enabled""");
	Фреймворк.ПроверитьВхождение(Результат.JSON, """templates""");
	Фреймворк.ПроверитьВхождение(Результат.JSON, """template""");
	Фреймворк.ПроверитьВхождение(Результат.JSON, """methods""");
	Фреймворк.ПроверитьВхождение(Результат.JSON, """method""");	

КонецПроцедуры

// @unit-test:fast
Процедура ServicesGET(Фреймворк) Экспорт
	
	// given
	Константы.ОбрабатыватьЗапросыВнешнегоХранилища.Установить(Истина);
	URL = "http://transmitter/api/hs/gitlab";
	URL = URL + "/services";
	// when
	Результат = HTTPConnector.Get(URL);
	// then
	Фреймворк.ПроверитьРавенство(Результат.КодСостояния, 200);
	ТелоОтвета = HTTPConnector.КакТекст(Результат, КодировкаТекста.UTF8);
	Фреймворк.ПроверитьВхождение(ТелоОтвета, """version""");
	Фреймворк.ПроверитьВхождение(ТелоОтвета, """services""");
	Фреймворк.ПроверитьВхождение(ТелоОтвета, """enabled""");
	Фреймворк.ПроверитьВхождение(ТелоОтвета, """templates""");
	Фреймворк.ПроверитьВхождение(ТелоОтвета, """template""");
	Фреймворк.ПроверитьВхождение(ТелоОтвета, """methods""");
	Фреймворк.ПроверитьВхождение(ТелоОтвета, """method""");	

КонецПроцедуры

// @unit-test:fast
Процедура WebhooksPOST(Фреймворк) Экспорт
	
	PROCESSED_REQUEST_MESSAGE = НСтр( "ru = 'Запрос с сервера GitLab обработан.';
									|en = 'The request from the GitLab server has been processed.'" );	

	// given
	УдалитьВсеОбработчикиСобытий();
	Тест_ОбработчикиСобытийСервер.ДобавитьОбработчикСобытий("ЮнитТест1", "блаблаблаюниттест");
	Константы.ОбрабатыватьЗапросыВнешнегоХранилища.Установить(Истина);
	
	URL = "http://transmitter/api/" + CurrentLanguage().LanguageCode + "/hs/gitlab";
	URL = URL + "/webhooks/epf/push";
	ЭталонWebHookGitLab = "/home/usr1cv8/test/request-epf-push.json";
	Текст = Новый ЧтениеТекста(ЭталонWebHookGitLab, КодировкаТекста.UTF8);
	JSON = Текст.Прочитать();

	// when
	Результат = HTTPConnector.Post(URL, JSON, ДополнительныеПараметрыУспешногоЗапроса());

	// then
	Фреймворк.ПроверитьРавенство(Результат.КодСостояния, 200);
	ТелоОтвета = Тест_ОбщийМодульСервер.КакТекст(Результат, КодировкаТекста.UTF8);
	Фреймворк.ПроверитьВхождение(ТелоОтвета, PROCESSED_REQUEST_MESSAGE);

КонецПроцедуры

// @unit-test
Процедура WebhooksPOST403Forbidden(Фреймворк) Экспорт
	
	KEY_NOT_FOUND_MESSAGE = НСтр( "ru = 'Секретный ключ не найден.';
									|en = 'The Secret Key is not found.'" );
	
	// given
	УдалитьВсеОбработчикиСобытий();
	Тест_ОбработчикиСобытийСервер.ДобавитьОбработчикСобытий("ЮнитТест1", "блаблаблаюниттест");
	Константы.ОбрабатыватьЗапросыВнешнегоХранилища.Установить(Ложь);

	
	URL = "http://transmitter/api/" + CurrentLanguage().LanguageCode + "/hs/gitlab";
	URL = URL + "/webhooks/epf/push";
	JSON = "{}";
	
	Заголовки = Новый Соответствие;
	Заголовки.Вставить("Content-Type", "application/json");
	Заголовки.Вставить("X-Gitlab-Event", "Push Hook");
	Заголовки.Вставить("X-Gitlab-Token", "ФэйковыйСекретныйКлюч");
	Дополнительно = Новый Структура;
	Дополнительно.Вставить("Заголовки", Заголовки);
	Дополнительно.Вставить("Таймаут", 5);

	// when
	Результат = HTTPConnector.Post(URL, JSON, Дополнительно);
	
	// then
	Фреймворк.ПроверитьРавенство(Результат.КодСостояния, 403);
	ТелоОтвета = HTTPConnector.КакТекст(Результат, КодировкаТекста.UTF8);
	Фреймворк.ПроверитьВхождение(ТелоОтвета, KEY_NOT_FOUND_MESSAGE);
	
КонецПроцедуры

// @unit-test
Процедура WebhooksPOST423Locked(Фреймворк) Экспорт
	
	LOADING_DISABLED_MESSAGE = НСтр( "ru = 'Загрузка из внешнего хранилища отключена.';
									|en = 'Loading of the files is disabled.'" );

	// given
	УдалитьВсеОбработчикиСобытий();
	Тест_ОбработчикиСобытийСервер.ДобавитьОбработчикСобытий("ЮнитТест1", "блаблаблаюниттест");
	Константы.ОбрабатыватьЗапросыВнешнегоХранилища.Установить(Ложь);
	
	URL = "http://transmitter/api/" + CurrentLanguage().LanguageCode + "/hs/gitlab";
	URL = URL + "/webhooks/epf/push";
	JSON = "{}";
	
	// when
	Результат = HTTPConnector.Post(URL, JSON, ДополнительныеПараметрыУспешногоЗапроса());

	// then
	Фреймворк.ПроверитьРавенство(Результат.КодСостояния, 423);
	ТелоОтвета = HTTPConnector.КакТекст(Результат, КодировкаТекста.UTF8);
	Фреймворк.ПроверитьВхождение(ТелоОтвета, LOADING_DISABLED_MESSAGE);

КонецПроцедуры

// @unit-test
Процедура WebhooksPOST400BadRequestXGitlabEvent(Фреймворк) Экспорт

	// given
	УдалитьВсеОбработчикиСобытий();
	Тест_ОбработчикиСобытийСервер.ДобавитьОбработчикСобытий("ЮнитТест1", "блаблаблаюниттест");
	Константы.ОбрабатыватьЗапросыВнешнегоХранилища.Установить(Истина);
	
	URL = "http://transmitter/api/" + CurrentLanguage().LanguageCode + "/hs/gitlab";
	URL = URL + "/webhooks/epf/push";
	JSON = "{}";
	
	Заголовки = Новый Соответствие;
	Заголовки.Вставить("Content-Type", "application/json");
	Заголовки.Вставить("X-Gitlab-Event", "Push Hook2");
	Заголовки.Вставить("X-Gitlab-Token", "блаблаблаюниттест");
	Дополнительно = Новый Структура;
	Дополнительно.Вставить("Заголовки", Заголовки);
	Дополнительно.Вставить("Таймаут", 5);

	// when
	Результат = HTTPConnector.Post(URL, JSON, Дополнительно);

	// then
	Фреймворк.ПроверитьРавенство(Результат.КодСостояния, 400, "400 Push Hook2");
	ТелоОтвета = HTTPConnector.КакТекст(Результат, КодировкаТекста.UTF8);
	Фреймворк.ПроверитьИстину(ПустаяСтрока(ТелоОтвета), "400 Push Hook2");

КонецПроцедуры

// @unit-test
Процедура WebhooksPOST400BadRequestBadURLEpf(Фреймворк) Экспорт

	// given
	УдалитьВсеОбработчикиСобытий();
	Тест_ОбработчикиСобытийСервер.ДобавитьОбработчикСобытий("ЮнитТест1", "блаблаблаюниттест");
	Константы.ОбрабатыватьЗапросыВнешнегоХранилища.Установить(Истина);
	
	URL = "http://transmitter/api/" + CurrentLanguage().LanguageCode + "/hs/gitlab";
	URL = URL + "/webhooks/epf3/push";
	JSON = "{}";

	// when
	Результат = HTTPConnector.Post(URL, JSON, ДополнительныеПараметрыУспешногоЗапроса());

	// then
	Фреймворк.ПроверитьРавенство(Результат.КодСостояния, 400, "400 BadURLEpf");
	ТелоОтвета = HTTPConnector.КакТекст(Результат, КодировкаТекста.UTF8);
	Фреймворк.ПроверитьИстину(ПустаяСтрока(ТелоОтвета), "400 BadURLEpf");

КонецПроцедуры

// @unit-test
Процедура WebhooksPOST400BadRequestBadURLPush(Фреймворк) Экспорт

	// given
	УдалитьВсеОбработчикиСобытий();
	Тест_ОбработчикиСобытийСервер.ДобавитьОбработчикСобытий("ЮнитТест1", "блаблаблаюниттест");
	Константы.ОбрабатыватьЗапросыВнешнегоХранилища.Установить(Истина);
	
	URL = "http://transmitter/api/" + CurrentLanguage().LanguageCode + "/hs/gitlab";
	URL = URL + "/webhooks/epf/push3";
	JSON = "{}";
	
	// when
	Результат = HTTPConnector.Post(URL, JSON, ДополнительныеПараметрыУспешногоЗапроса());

	// then
	Фреймворк.ПроверитьРавенство(Результат.КодСостояния, 400, "400 BadURLPush");
	ТелоОтвета = HTTPConnector.КакТекст(Результат, КодировкаТекста.UTF8);
	Фреймворк.ПроверитьИстину(ПустаяСтрока(ТелоОтвета), "400 BadURLPush");

КонецПроцедуры

// @unit-test:dev
Процедура WebhooksPOST400BadRequestCheckoutSHA(Фреймворк) Экспорт

	// given
	УдалитьВсеОбработчикиСобытий();
	Тест_ОбработчикиСобытийСервер.ДобавитьОбработчикСобытий("ЮнитТест1", "блаблаблаюниттест");
	Константы.ОбрабатыватьЗапросыВнешнегоХранилища.Установить(Истина);
	
	URL = "http://transmitter/api/" + CurrentLanguage().LanguageCode + "/hs/gitlab";
	URL = URL + "/webhooks/epf/push";
	JSON = "{
	   |  ""object_kind"": ""push"",
	   |  ""project_id"": 178,
	   |  ""project"": {
	   |    ""id"": 178,
	   |    ""name"": ""TestEpf"",
	   |    ""web_url"": ""http://git.a/a.strizhachuk/testepf"",
	   |    ""description"": """"
	   |  },
	   |  ""commits"": [
	   |    {
	   |      ""id"": ""87fc6b2782f1bcadce980cb52941e2bd90974c0f"",
	   |      ""message"": ""Merge branch ''ttt'' into ''master''\n\nTtt\n\nSee merge request a.strizhachuk/testepf!2""
	   |    },
	   |    {
	   |      ""id"": ""bb8c1e02e420afffe601ada9f1171991d0404e68"",
	   |      ""message"": ""test\n""
	   |    },
	   |    {
	   |      ""id"": ""2fb9499926026288d1e9b9c6586338fff4ec996b"",
	   |      ""message"": ""test\n""
	   |    }
	   |  ],
	   |  ""total_commits_count"": 3
	   |  }
	   |}";

	// when
	Результат = HTTPConnector.Post(URL, JSON, ДополнительныеПараметрыУспешногоЗапроса());

	// then
	Фреймворк.ПроверитьРавенство(Результат.КодСостояния, 400, "400 checkout_sha");
	ТелоОтвета = Тест_ОбщийМодульСервер.КакТекст(Результат, КодировкаТекста.UTF8);
	Фреймворк.ПроверитьИстину(ПустаяСтрока(ТелоОтвета), "400 checkout_sha");

КонецПроцедуры

// @unit-test
Процедура WebhooksPOST400BadRequestProject(Фреймворк) Экспорт

	// given
	УдалитьВсеОбработчикиСобытий();
	Тест_ОбработчикиСобытийСервер.ДобавитьОбработчикСобытий("ЮнитТест1", "блаблаблаюниттест");
	Константы.ОбрабатыватьЗапросыВнешнегоХранилища.Установить(Истина);
	
	URL = "http://transmitter/api/" + CurrentLanguage().LanguageCode + "/hs/gitlab";
	URL = URL + "/webhooks/epf/push";
	JSON = "{
		   |  ""object_kind"": ""push"",
		   |  ""checkout_sha"": ""87fc6b2782f1bcadce980cb52941e2bd90974c0f"",
		   |  ""project_id"": 178,
		   |  ""commits"": [
		   |    {
		   |      ""id"": ""87fc6b2782f1bcadce980cb52941e2bd90974c0f"",
		   |      ""message"": ""Merge branch ''ttt'' into ''master''\n\nTtt\n\nSee merge request a.strizhachuk/testepf!2""
		   |    },
		   |    {
		   |      ""id"": ""bb8c1e02e420afffe601ada9f1171991d0404e68"",
		   |      ""message"": ""test\n""
		   |    },
		   |    {
		   |      ""id"": ""2fb9499926026288d1e9b9c6586338fff4ec996b"",
		   |      ""message"": ""test\n""
		   |    }
		   |  ],
		   |  ""total_commits_count"": 3
		   |  }
		   |}";

	// when
	Результат = HTTPConnector.Post(URL, JSON, ДополнительныеПараметрыУспешногоЗапроса());

	// then
	Фреймворк.ПроверитьРавенство(Результат.КодСостояния, 400, "400 project");
	ТелоОтвета = Тест_ОбщийМодульСервер.КакТекст(Результат, КодировкаТекста.UTF8);
	Фреймворк.ПроверитьИстину(ПустаяСтрока(ТелоОтвета), "400 project");

КонецПроцедуры

// @unit-test
Процедура WebhooksPOST400BadRequestProjectWebURL(Фреймворк) Экспорт

	// given
	УдалитьВсеОбработчикиСобытий();
	Тест_ОбработчикиСобытийСервер.ДобавитьОбработчикСобытий("ЮнитТест1", "блаблаблаюниттест");
	Константы.ОбрабатыватьЗапросыВнешнегоХранилища.Установить(Истина);
	
	URL = "http://transmitter/api/" + CurrentLanguage().LanguageCode + "/hs/gitlab";
	URL = URL + "/webhooks/epf/push";
	JSON = "{
		   |  ""object_kind"": ""push"",
		   |  ""checkout_sha"": ""87fc6b2782f1bcadce980cb52941e2bd90974c0f"",
		   |  ""project_id"": 178,
		   |  ""project"": {
		   |    ""id"": 178,
		   |    ""name"": ""TestEpf"",
		   |    ""description"": """"
		   |  },
		   |  ""commits"": [
		   |    {
		   |      ""id"": ""87fc6b2782f1bcadce980cb52941e2bd90974c0f"",
		   |      ""message"": ""Merge branch ''ttt'' into ''master''\n\nTtt\n\nSee merge request a.strizhachuk/testepf!2""
		   |    },
		   |    {
		   |      ""id"": ""bb8c1e02e420afffe601ada9f1171991d0404e68"",
		   |      ""message"": ""test\n""
		   |    },
		   |    {
		   |      ""id"": ""2fb9499926026288d1e9b9c6586338fff4ec996b"",
		   |      ""message"": ""test\n""
		   |    }
		   |  ],
		   |  ""total_commits_count"": 3
		   |  }
		   |}";
	
	// when
	Результат = HTTPConnector.Post(URL, JSON, ДополнительныеПараметрыУспешногоЗапроса());

	// then
	Фреймворк.ПроверитьРавенство(Результат.КодСостояния, 400, "400 project/web_url");
	ТелоОтвета = Тест_ОбщийМодульСервер.КакТекст(Результат, КодировкаТекста.UTF8);
	Фреймворк.ПроверитьИстину(ПустаяСтрока(ТелоОтвета), "400 project/web_url");

КонецПроцедуры

// @unit-test
Процедура WebhooksPOST400BadRequestCommits(Фреймворк) Экспорт

	// given
	УдалитьВсеОбработчикиСобытий();
	Тест_ОбработчикиСобытийСервер.ДобавитьОбработчикСобытий("ЮнитТест1", "блаблаблаюниттест");
	Константы.ОбрабатыватьЗапросыВнешнегоХранилища.Установить(Истина);
	
	URL = "http://transmitter/api/" + CurrentLanguage().LanguageCode + "/hs/gitlab";
	URL = URL + "/webhooks/epf/push";
	JSON = "{
		   |  ""object_kind"": ""push"",
		   |  ""checkout_sha"": ""87fc6b2782f1bcadce980cb52941e2bd90974c0f"",
		   |  ""project_id"": 178,
		   |  ""project"": {
		   |    ""id"": 178,
		   |    ""name"": ""TestEpf"",
		   |    ""web_url"": ""http://git.a/a.strizhachuk/testepf"",
		   |    ""description"": """"
		   |  },
		   |  ""total_commits_count"": 3
		   |  }
		   |}";
	
	// when
	Результат = HTTPConnector.Post(URL, JSON, ДополнительныеПараметрыУспешногоЗапроса());

	// then
	Фреймворк.ПроверитьРавенство(Результат.КодСостояния, 400, "400 commits");
	ТелоОтвета = Тест_ОбщийМодульСервер.КакТекст(Результат, КодировкаТекста.UTF8);
	Фреймворк.ПроверитьИстину(ПустаяСтрока(ТелоОтвета), "400 commits");

КонецПроцедуры

// @unit-test
Процедура WebhooksPOST400BadRequestCommitsId(Фреймворк) Экспорт

	// given
	УдалитьВсеОбработчикиСобытий();
	Тест_ОбработчикиСобытийСервер.ДобавитьОбработчикСобытий("ЮнитТест1", "блаблаблаюниттест");
	Константы.ОбрабатыватьЗапросыВнешнегоХранилища.Установить(Истина);
	
	URL = "http://transmitter/api/" + CurrentLanguage().LanguageCode + "/hs/gitlab";
	URL = URL + "/webhooks/epf/push";
	JSON = "{
		   |  ""object_kind"": ""push"",
		   |  ""checkout_sha"": ""87fc6b2782f1bcadce980cb52941e2bd90974c0f"",
		   |  ""project_id"": 178,
		   |  ""project"": {
		   |    ""id"": 178,
		   |    ""name"": ""TestEpf"",
		   |    ""web_url"": ""http://git.a/a.strizhachuk/testepf"",
		   |    ""description"": """"
		   |  },
		   |  ""commits"": [
		   |    {
		   |      ""message"": ""Merge branch ''ttt'' into ''master''\n\nTtt\n\nSee merge request a.strizhachuk/testepf!2""
		   |    },
		   |    {
		   |      ""id"": ""bb8c1e02e420afffe601ada9f1171991d0404e68"",
		   |      ""message"": ""test\n""
		   |    },
		   |    {
		   |      ""id"": ""2fb9499926026288d1e9b9c6586338fff4ec996b"",
		   |      ""message"": ""test\n""
		   |    }
		   |  ],
		   |  ""total_commits_count"": 3
		   |  }
		   |}";

	// when
	Результат = HTTPConnector.Post(URL, JSON, ДополнительныеПараметрыУспешногоЗапроса());

	// then
	Фреймворк.ПроверитьРавенство(Результат.КодСостояния, 400, "400 commits/id");
	ТелоОтвета = Тест_ОбщийМодульСервер.КакТекст(Результат, КодировкаТекста.UTF8);
	Фреймворк.ПроверитьИстину(ПустаяСтрока(ТелоОтвета), "400 commits/id");

КонецПроцедуры

#EndRegion

#Region Private

Функция ДополнительныеПараметрыУспешногоЗапроса()
	
	Заголовки = Новый Соответствие;
	Заголовки.Вставить("Content-Type", "application/json");
	Заголовки.Вставить("X-Gitlab-Event", "Push Hook");
	Заголовки.Вставить("X-Gitlab-Token", "блаблаблаюниттест");
	Дополнительно = Новый Структура;
	Дополнительно.Вставить("Заголовки", Заголовки);
	Дополнительно.Вставить("Таймаут", 5);
	
	Возврат Дополнительно;
	 
КонецФункции


Процедура УдалитьВсеОбработчикиСобытий()
	
	Тест_ОбщийМодульСервер.СправочникиУдалитьВсеДанные("ОбработчикиСобытий");

КонецПроцедуры

#EndRegion