# language: ru

@tree
@classname=ModuleExceptionPath

Функционал: GitLabServices.Tests.Тест_СтроковыеФункцииКлиент
	Как Разработчик
	Я Хочу чтобы возвращаемое значение метода совпадало с эталонным
	Чтобы я мог гарантировать работоспособность метода

Сценарий: ПерекодироватьСтроку
	И я выполняю код встроенного языка
	| 'Тест_СтроковыеФункцииКлиент.ПерекодироватьСтроку(Контекст());' |