﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

//+ #286 Иванов А.Б. 2017-12-17
Функция узПолучитьУчетнуюЗаписьДляОтправкиУведомленийДляКонтрагентов() Экспорт
	Перем пУчетнаяЗапись;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	УчетныеЗаписиЭлектроннойПочты.Ссылка
	|ИЗ
	|	Справочник.УчетныеЗаписиЭлектроннойПочты КАК УчетныеЗаписиЭлектроннойПочты
	|ГДЕ
	|	УчетныеЗаписиЭлектроннойПочты.узИспользоватьДляОтправкиКотрагентам";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		пУчетнаяЗапись = Выборка.Ссылка;
	КонецЦикла;
	
	Возврат пУчетнаяЗапись;
КонецФункции                              

#КонецОбласти

#КонецЕсли

#Область СлужебныеПроцедурыИФункции

Функция РазрешенияУчетныхЗаписей(УчетнаяЗапись = Неопределено) Экспорт
	
	Результат = Новый Соответствие;
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	УчетныеЗаписиЭлектроннойПочты.ПротоколВходящейПочты КАК Протокол,
	|	УчетныеЗаписиЭлектроннойПочты.СерверВходящейПочты КАК Сервер,
	|	УчетныеЗаписиЭлектроннойПочты.ПортСервераВходящейПочты КАК Порт,
	|	УчетныеЗаписиЭлектроннойПочты.Ссылка
	|ПОМЕСТИТЬ СервераЭлектроннойПочты
	|ИЗ
	|	Справочник.УчетныеЗаписиЭлектроннойПочты КАК УчетныеЗаписиЭлектроннойПочты
	|ГДЕ
	|	УчетныеЗаписиЭлектроннойПочты.ПротоколВходящейПочты <> """"
	|	И УчетныеЗаписиЭлектроннойПочты.ПометкаУдаления = ЛОЖЬ
	|	И УчетныеЗаписиЭлектроннойПочты.ИспользоватьДляПолучения = ИСТИНА
	|	И УчетныеЗаписиЭлектроннойПочты.СерверВходящейПочты <> """"
	|	И УчетныеЗаписиЭлектроннойПочты.ПортСервераВходящейПочты > 0
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	""SMTP"",
	|	УчетныеЗаписиЭлектроннойПочты.СерверИсходящейПочты,
	|	УчетныеЗаписиЭлектроннойПочты.ПортСервераИсходящейПочты,
	|	УчетныеЗаписиЭлектроннойПочты.Ссылка
	|ИЗ
	|	Справочник.УчетныеЗаписиЭлектроннойПочты КАК УчетныеЗаписиЭлектроннойПочты
	|ГДЕ
	|	УчетныеЗаписиЭлектроннойПочты.ПометкаУдаления = ЛОЖЬ
	|	И УчетныеЗаписиЭлектроннойПочты.ИспользоватьДляОтправки = ИСТИНА
	|	И УчетныеЗаписиЭлектроннойПочты.СерверИсходящейПочты <> """"
	|	И УчетныеЗаписиЭлектроннойПочты.ПортСервераИсходящейПочты > 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СервераЭлектроннойПочты.Ссылка КАК Ссылка,
	|	СервераЭлектроннойПочты.Протокол КАК Протокол,
	|	СервераЭлектроннойПочты.Сервер КАК Сервер,
	|	СервераЭлектроннойПочты.Порт КАК Порт
	|ИЗ
	|	СервераЭлектроннойПочты КАК СервераЭлектроннойПочты
	|ГДЕ
	|	&Ссылка = НЕОПРЕДЕЛЕНО
	|
	|СГРУППИРОВАТЬ ПО
	|	СервераЭлектроннойПочты.Протокол,
	|	СервераЭлектроннойПочты.Сервер,
	|	СервераЭлектроннойПочты.Порт,
	|	СервераЭлектроннойПочты.Ссылка
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	СервераЭлектроннойПочты.Ссылка,
	|	СервераЭлектроннойПочты.Протокол,
	|	СервераЭлектроннойПочты.Сервер,
	|	СервераЭлектроннойПочты.Порт
	|ИЗ
	|	СервераЭлектроннойПочты КАК СервераЭлектроннойПочты
	|ГДЕ
	|	СервераЭлектроннойПочты.Ссылка = &Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	СервераЭлектроннойПочты.Протокол,
	|	СервераЭлектроннойПочты.Сервер,
	|	СервераЭлектроннойПочты.Порт,
	|	СервераЭлектроннойПочты.Ссылка
	|ИТОГИ ПО
	|	Ссылка";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Ссылка", УчетнаяЗапись);
	
	МодульРаботаВБезопасномРежиме = ОбщегоНазначения.ОбщийМодуль("РаботаВБезопасномРежиме");
	
	УчетныеЗаписи = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока УчетныеЗаписи.Следующий() Цикл
		Разрешения = Новый Массив;
		НастройкиУчетнойЗаписи = УчетныеЗаписи.Выбрать();
		Пока НастройкиУчетнойЗаписи.Следующий() Цикл
			Разрешения.Добавить(
				МодульРаботаВБезопасномРежиме.РазрешениеНаИспользованиеИнтернетРесурса(
					НастройкиУчетнойЗаписи.Протокол,
					НастройкиУчетнойЗаписи.Сервер,
					НастройкиУчетнойЗаписи.Порт,
					НСтр("ru = 'Электронная почта.'")));
		КонецЦикла;
		Результат.Вставить(УчетныеЗаписи.Ссылка, Разрешения);
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Процедура ОпределитьНастройкиУчетнойЗаписи(Параметры, АдресРезультата) Экспорт
	
	АдресЭлектроннойПочты = Параметры.АдресЭлектроннойПочты;
	Пароль = Параметры.Пароль;
	
	НайденныйПрофильSMTP = Неопределено;
	НайденныйПрофильIMAP = Неопределено;
	НайденныйПрофильPOP = Неопределено;
	
	Если Параметры.ДляОтправки Тогда
		НайденныйПрофильSMTP = ОпределитьНастройкиSMTP(АдресЭлектроннойПочты, Пароль);
	КонецЕсли;
	
	Если Параметры.ДляОтправки Или Параметры.ДляПолучения Тогда
		НайденныйПрофильIMAP = ОпределитьНастройкиIMAP(АдресЭлектроннойПочты, Пароль);
		Если НайденныйПрофильIMAP = Неопределено И Параметры.ДляПолучения Тогда
			НайденныйПрофильPOP = ОпределитьНастройкиPOP(АдресЭлектроннойПочты, Пароль);
		КонецЕсли;
	КонецЕсли;
	
	Результат = Новый Структура;
	
	Если НайденныйПрофильIMAP <> Неопределено Тогда
		Результат.Вставить("ИмяПользователяДляПолученияПисем", НайденныйПрофильIMAP.ПользовательIMAP);
		Результат.Вставить("ПарольДляПолученияПисем", НайденныйПрофильIMAP.ПарольIMAP);
		Результат.Вставить("Протокол", "IMAP");
		Результат.Вставить("СерверВходящейПочты", НайденныйПрофильIMAP.АдресСервераIMAP);
		Результат.Вставить("ПортСервераВходящейПочты", НайденныйПрофильIMAP.ПортIMAP);
		Результат.Вставить("ИспользоватьЗащищенноеСоединениеДляВходящейПочты", НайденныйПрофильIMAP.ИспользоватьSSLIMAP);
	КонецЕсли;
	
	Если НайденныйПрофильPOP <> Неопределено Тогда
		Результат.Вставить("ИмяПользователяДляПолученияПисем", НайденныйПрофильPOP.Пользователь);
		Результат.Вставить("ПарольДляПолученияПисем", НайденныйПрофильPOP.Пароль);
		Результат.Вставить("Протокол", "POP");
		Результат.Вставить("СерверВходящейПочты", НайденныйПрофильPOP.АдресСервераPOP3);
		Результат.Вставить("ПортСервераВходящейПочты", НайденныйПрофильPOP.ПортPOP3);
		Результат.Вставить("ИспользоватьЗащищенноеСоединениеДляВходящейПочты", НайденныйПрофильPOP.ИспользоватьSSLPOP3);
	КонецЕсли;
	
	Если НайденныйПрофильSMTP <> Неопределено Тогда
		Результат.Вставить("ИмяПользователяДляОтправкиПисем", НайденныйПрофильSMTP.ПользовательSMTP);
		Результат.Вставить("ПарольДляОтправкиПисем", НайденныйПрофильSMTP.ПарольSMTP);
		Результат.Вставить("СерверИсходящейПочты", НайденныйПрофильSMTP.АдресСервераSMTP);
		Результат.Вставить("ПортСервераИсходящейПочты", НайденныйПрофильSMTP.ПортSMTP);
		Результат.Вставить("ИспользоватьЗащищенноеСоединениеДляИсходящейПочты", НайденныйПрофильSMTP.ИспользоватьSSLSMTP);
	КонецЕсли;
	
	Результат.Вставить("ДляПолучения", НайденныйПрофильIMAP <> Неопределено Или НайденныйПрофильPOP <> Неопределено);
	Результат.Вставить("ДляОтправки", НайденныйПрофильSMTP <> Неопределено);
	
	ПоместитьВоВременноеХранилище(Результат, АдресРезультата);
	
КонецПроцедуры

Функция ОпределитьНастройкиPOP(АдресЭлектроннойПочты, Пароль)
	Для Каждого Профиль Из ПрофилиPOP(АдресЭлектроннойПочты, Пароль) Цикл
		СообщениеСервера = ПроверитьПодключениеКСерверуВходящейПочты(Профиль, ПротоколИнтернетПочты.POP3);
		
		Если ОшибкаАутентификации(СообщениеСервера) Тогда
			Для Каждого ИмяПользователя Из ВариантыИмениПользователя(АдресЭлектроннойПочты) Цикл
				УстановитьИмяПользователя(Профиль, ИмяПользователя);
				СообщениеСервера = ПроверитьПодключениеКСерверуВходящейПочты(Профиль, ПротоколИнтернетПочты.POP3);
				Если Не ОшибкаАутентификации(СообщениеСервера) Тогда
					Прервать;
				КонецЕсли;
			КонецЦикла;
			Если ОшибкаАутентификации(СообщениеСервера) Тогда
				Прервать;
			КонецЕсли;
		КонецЕсли;
		
		Если ПодключениеВыполнено(СообщениеСервера) Тогда
			Возврат Профиль;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Неопределено;
КонецФункции

Функция ОпределитьНастройкиIMAP(АдресЭлектроннойПочты, Пароль)
	Для Каждого Профиль Из ПрофилиIMAP(АдресЭлектроннойПочты, Пароль) Цикл
		СообщениеСервера = ПроверитьПодключениеКСерверуВходящейПочты(Профиль, ПротоколИнтернетПочты.IMAP);
		
		Если ОшибкаАутентификации(СообщениеСервера) Тогда
			Для Каждого ИмяПользователя Из ВариантыИмениПользователя(АдресЭлектроннойПочты) Цикл
				УстановитьИмяПользователя(Профиль, ИмяПользователя);
				СообщениеСервера = ПроверитьПодключениеКСерверуВходящейПочты(Профиль, ПротоколИнтернетПочты.IMAP);
				Если Не ОшибкаАутентификации(СообщениеСервера) Тогда
					Прервать;
				КонецЕсли;
			КонецЦикла;
			Если ОшибкаАутентификации(СообщениеСервера) Тогда
				Прервать;
			КонецЕсли;
		КонецЕсли;
		
		Если ПодключениеВыполнено(СообщениеСервера) Тогда
			Возврат Профиль;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Неопределено;
КонецФункции

Функция ОпределитьНастройкиSMTP(АдресЭлектроннойПочты, Пароль)
	Для Каждого Профиль Из ПрофилиSMTP(АдресЭлектроннойПочты, Пароль) Цикл
		СообщениеСервера = ПроверитьПодключениеКСерверуИсходящейПочты(Профиль, АдресЭлектроннойПочты);
		
		Если ОшибкаАутентификации(СообщениеСервера) Тогда
			Для Каждого ИмяПользователя Из ВариантыИмениПользователя(АдресЭлектроннойПочты) Цикл
				УстановитьИмяПользователя(Профиль, ИмяПользователя);
				СообщениеСервера = ПроверитьПодключениеКСерверуИсходящейПочты(Профиль, АдресЭлектроннойПочты);
				Если Не ОшибкаАутентификации(СообщениеСервера) Тогда
					Прервать;
				КонецЕсли;
			КонецЦикла;
			Если ОшибкаАутентификации(СообщениеСервера) Тогда
				Прервать;
			КонецЕсли;
		КонецЕсли;
		
		Если ПодключениеВыполнено(СообщениеСервера) Тогда
			Возврат Профиль;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Неопределено;
КонецФункции

Функция ПрофилиPOP(АдресЭлектроннойПочты, Пароль)
	Результат = Новый Массив;
	НастройкиПрофиля = НастройкиПоУмолчанию(АдресЭлектроннойПочты, Пароль);
	
	Для Каждого ВариантНастройкиПодключения Из ВариантыНастройкиПодключенияКСерверуPOP(АдресЭлектроннойПочты) Цикл
		Профиль = Новый ИнтернетПочтовыйПрофиль;
		ЗаполнитьЗначенияСвойств(НастройкиПрофиля, ВариантНастройкиПодключения);
		ЗаполнитьЗначенияСвойств(Профиль, ИнтернетПочтовыйПрофиль(НастройкиПрофиля, ПротоколИнтернетПочты.POP3));
		Результат.Добавить(Профиль);
	КонецЦикла;
	
	Возврат Результат;
КонецФункции

Функция ПрофилиIMAP(АдресЭлектроннойПочты, Пароль)
	Результат = Новый Массив;
	НастройкиПрофиля = НастройкиПоУмолчанию(АдресЭлектроннойПочты, Пароль);
	
	Для Каждого ВариантНастройкиПодключения Из ВариантыНастройкиПодключенияКСерверуIMAP(АдресЭлектроннойПочты) Цикл
		Профиль = Новый ИнтернетПочтовыйПрофиль;
		ЗаполнитьЗначенияСвойств(НастройкиПрофиля, ВариантНастройкиПодключения);
		ЗаполнитьЗначенияСвойств(Профиль, ИнтернетПочтовыйПрофиль(НастройкиПрофиля, ПротоколИнтернетПочты.IMAP));
		Результат.Добавить(Профиль);
	КонецЦикла;
	
	Возврат Результат;
КонецФункции

Функция ПрофилиSMTP(АдресЭлектроннойПочты, Пароль)
	Результат = Новый Массив;
	НастройкиПрофиля = НастройкиПоУмолчанию(АдресЭлектроннойПочты, Пароль);
	
	Для Каждого ВариантНастройкиПодключения Из ВариантыНастройкиПодключенияКСерверуSMTP(АдресЭлектроннойПочты) Цикл
		Профиль = Новый ИнтернетПочтовыйПрофиль;
		ЗаполнитьЗначенияСвойств(НастройкиПрофиля, ВариантНастройкиПодключения);
		ЗаполнитьЗначенияСвойств(Профиль, ИнтернетПочтовыйПрофиль(НастройкиПрофиля, ПротоколИнтернетПочты.SMTP));
		Результат.Добавить(Профиль);
	КонецЦикла;
	
	Возврат Результат;
КонецФункции

Функция ОшибкаАутентификации(СообщениеСервера)
	Возврат СтрНайти(НРег(СообщениеСервера), "auth") > 0
		Или СтрНайти(НРег(СообщениеСервера), "password") > 0
		Или СтрНайти(НРег(СообщениеСервера), "credentials") > 0;
КонецФункции

Функция ПодключениеВыполнено(СообщениеСервера)
	Возврат ПустаяСтрока(СообщениеСервера);
КонецФункции

Процедура УстановитьИмяПользователя(Профиль, ИмяПользователя)
	Если Не ПустаяСтрока(Профиль.Пользователь) Тогда
		Профиль.Пользователь = ИмяПользователя;
	КонецЕсли;
	Если Не ПустаяСтрока(Профиль.ПользовательIMAP) Тогда
		Профиль.ПользовательIMAP = ИмяПользователя;
	КонецЕсли;
	Если Не ПустаяСтрока(Профиль.ПользовательSMTP) Тогда
		Профиль.ПользовательSMTP = ИмяПользователя;
	КонецЕсли;
КонецПроцедуры

Функция НастройкиПоУмолчанию(АдресЭлектроннойПочты, Пароль)
	
	Позиция = СтрНайти(АдресЭлектроннойПочты, "@");
	ИмяСервераВУчетнойЗаписи = Сред(АдресЭлектроннойПочты, Позиция + 1);
	
	Настройки = Новый Структура;
	
	Настройки.Вставить("ИмяПользователяДляПолученияПисем", АдресЭлектроннойПочты);
	Настройки.Вставить("ИмяПользователяДляОтправкиПисем", АдресЭлектроннойПочты);
	
	Настройки.Вставить("ПарольДляОтправкиПисем", Пароль);
	Настройки.Вставить("ПарольДляПолученияПисем", Пароль);
	
	Настройки.Вставить("Протокол", "POP");
	Настройки.Вставить("СерверВходящейПочты", "pop." + ИмяСервераВУчетнойЗаписи);
	Настройки.Вставить("ПортСервераВходящейПочты", 995);
	Настройки.Вставить("ИспользоватьЗащищенноеСоединениеДляВходящейПочты", Истина);
	Настройки.Вставить("ИспользоватьБезопасныйВходНаСерверВходящейПочты", Ложь);
	
	Настройки.Вставить("СерверИсходящейПочты", "smtp." + ИмяСервераВУчетнойЗаписи);
	Настройки.Вставить("ПортСервераИсходящейПочты", 465);
	Настройки.Вставить("ИспользоватьЗащищенноеСоединениеДляИсходящейПочты", Истина);
	Настройки.Вставить("ИспользоватьБезопасныйВходНаСерверИсходящейПочты", Ложь);
	Настройки.Вставить("ТребуетсяВходНаСерверПередОтправкой", Ложь);
	
	Настройки.Вставить("ДлительностьОжиданияСервера", 30);
	Настройки.Вставить("ОставлятьКопииПисемНаСервере", Истина);
	Настройки.Вставить("УдалятьПисьмаССервераЧерез", 0);
	
	Возврат Настройки;
	
КонецФункции

Функция ПроверитьПодключениеКСерверуВходящейПочты(Профиль, Протокол) Экспорт
	
	ИнтернетПочта = Новый ИнтернетПочта;
	
	ТекстОшибки = "";
	Попытка
		ИнтернетПочта.Подключиться(Профиль, Протокол);
	Исключение
		ТекстОшибки = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
	КонецПопытки;
	
	ИнтернетПочта.Отключиться();
	
	Если Протокол = ПротоколИнтернетПочты.POP3 Тогда
		ТекстДляЖурнала = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("%1:%2%3 (%4)" + Символы.ПС + "%5",
			Профиль.АдресСервераPOP3,
			Профиль.ПортPOP3,
			?(Профиль.ИспользоватьSSLPOP3, "/SSL", ""),
			Профиль.Пользователь,
			?(ПустаяСтрока(ТекстОшибки), НСтр("ru = 'OK'"), ТекстОшибки));
	Иначе
		ТекстДляЖурнала = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("%1:%2%3 (%4)" + Символы.ПС + "%5",
			Профиль.АдресСервераIMAP,
			Профиль.ПортIMAP,
			?(Профиль.ИспользоватьSSLIMAP, "/SSL", ""),
			Профиль.ПользовательIMAP,
			?(ПустаяСтрока(ТекстОшибки), НСтр("ru = 'OK'"), ТекстОшибки));
	КонецЕсли;
	
	ЗаписьЖурналаРегистрации(НСтр("ru = 'Проверка подключения к почтовому серверу'", ОбщегоНазначения.КодОсновногоЯзыка()), 
		УровеньЖурналаРегистрации.Информация, , , ТекстДляЖурнала);
	
	Возврат ТекстОшибки;
	
КонецФункции

Функция ПроверитьПодключениеКСерверуИсходящейПочты(Профиль, АдресЭлектроннойПочты) Экспорт
	
	Тема = НСтр("ru = 'Тестовое сообщение 1С:Предприятие'");
	Тело = НСтр("ru = 'Это сообщение отправлено подсистемой электронной почты 1С:Предприятие'");
	ИмяОтправителяПисем = НСтр("ru = '1С:Предприятие'");
	
	Письмо = Новый ИнтернетПочтовоеСообщение;
	Письмо.Тема = Тема;
	
	Получатель = Письмо.Получатели.Добавить(АдресЭлектроннойПочты);
	Получатель.ОтображаемоеИмя = ИмяОтправителяПисем;
	
	Письмо.ИмяОтправителя = ИмяОтправителяПисем;
	Письмо.Отправитель.ОтображаемоеИмя = ИмяОтправителяПисем;
	Письмо.Отправитель.Адрес = АдресЭлектроннойПочты;
	
	Текст = Письмо.Тексты.Добавить(Тело);
	Текст.ТипТекста = ТипТекстаПочтовогоСообщения.ПростойТекст;

	ИнтернетПочта = Новый ИнтернетПочта;
	
	ТекстОшибки = "";
	Попытка
		ИнтернетПочта.Подключиться(Профиль);
		ИнтернетПочта.Послать(Письмо);
	Исключение
		ТекстОшибки = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
	КонецПопытки;
	
	ИнтернетПочта.Отключиться();
	
	ТекстДляЖурнала = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("%1:%2%3 (%4)" + Символы.ПС + "%5",
		Профиль.АдресСервераSMTP,
		Профиль.ПортSMTP,
		?(Профиль.ИспользоватьSSLSMTP, "/SSL", ""),
		Профиль.ПользовательSMTP,
		?(ПустаяСтрока(ТекстОшибки), НСтр("ru = 'OK'"), ТекстОшибки));
		
	ЗаписьЖурналаРегистрации(НСтр("ru = 'Проверка подключения к почтовому серверу'", ОбщегоНазначения.КодОсновногоЯзыка()), 
		УровеньЖурналаРегистрации.Информация, , , ТекстДляЖурнала);
	
	Возврат ТекстОшибки;
	
КонецФункции

Функция ИнтернетПочтовыйПрофиль(НастройкиПрофиля, Протокол)
	
	ДляПолучения = Протокол <> ПротоколИнтернетПочты.SMTP;
	
	Профиль = Новый ИнтернетПочтовыйПрофиль;
	Если ДляПолучения Или НастройкиПрофиля.ТребуетсяВходНаСерверПередОтправкой Тогда
		Если Протокол = ПротоколИнтернетПочты.IMAP Тогда
			Профиль.АдресСервераIMAP = НастройкиПрофиля.СерверВходящейПочты;
			Профиль.ИспользоватьSSLIMAP = НастройкиПрофиля.ИспользоватьЗащищенноеСоединениеДляВходящейПочты;
			Профиль.ПарольIMAP = НастройкиПрофиля.ПарольДляПолученияПисем;
			Профиль.ПользовательIMAP = НастройкиПрофиля.ИмяПользователяДляПолученияПисем;
			Профиль.ПортIMAP = НастройкиПрофиля.ПортСервераВходящейПочты;
			Профиль.ТолькоЗащищеннаяАутентификацияIMAP = НастройкиПрофиля.ИспользоватьБезопасныйВходНаСерверВходящейПочты;
		Иначе
			Профиль.АдресСервераPOP3 = НастройкиПрофиля.СерверВходящейПочты;
			Профиль.ИспользоватьSSLPOP3 = НастройкиПрофиля.ИспользоватьЗащищенноеСоединениеДляВходящейПочты;
			Профиль.Пароль = НастройкиПрофиля.ПарольДляПолученияПисем;
			Профиль.Пользователь = НастройкиПрофиля.ИмяПользователяДляПолученияПисем;
			Профиль.ПортPOP3 = НастройкиПрофиля.ПортСервераВходящейПочты;
			Профиль.ТолькоЗащищеннаяАутентификацияPOP3 = НастройкиПрофиля.ИспользоватьБезопасныйВходНаСерверВходящейПочты;
		КонецЕсли;
	КонецЕсли;
	
	Если Не ДляПолучения Тогда
		Профиль.POP3ПередSMTP = НастройкиПрофиля.ТребуетсяВходНаСерверПередОтправкой;
		Профиль.АдресСервераSMTP = НастройкиПрофиля.СерверИсходящейПочты;
		Профиль.ИспользоватьSSLSMTP = НастройкиПрофиля.ИспользоватьЗащищенноеСоединениеДляИсходящейПочты;
		Профиль.ПарольSMTP = НастройкиПрофиля.ПарольДляОтправкиПисем;
		Профиль.ПользовательSMTP = НастройкиПрофиля.ИмяПользователяДляОтправкиПисем;
		Профиль.ПортSMTP = НастройкиПрофиля.ПортСервераИсходящейПочты;
		Профиль.ТолькоЗащищеннаяАутентификацияSMTP = НастройкиПрофиля.ИспользоватьБезопасныйВходНаСерверИсходящейПочты;
	КонецЕсли;
	
	Профиль.Таймаут = НастройкиПрофиля.ДлительностьОжиданияСервера;
	
	Возврат Профиль;
	
КонецФункции

Функция ВариантыИмениПользователя(АдресЭлектроннойПочты)
	
	Позиция = СтрНайти(АдресЭлектроннойПочты, "@");
	ИмяПользователяВУчетнойЗаписи = Лев(АдресЭлектроннойПочты, Позиция - 1);
	
	Результат = Новый Массив;
	Результат.Добавить(ИмяПользователяВУчетнойЗаписи);
	
	Возврат Результат;
	
КонецФункции

Функция ВариантыНастройкиПодключенияКСерверуIMAP(АдресЭлектроннойПочты) Экспорт
	
	Позиция = СтрНайти(АдресЭлектроннойПочты, "@");
	ИмяСервераВУчетнойЗаписи = Сред(АдресЭлектроннойПочты, Позиция + 1);
	
	Результат = Новый ТаблицаЗначений;
	Результат.Колонки.Добавить("СерверВходящейПочты");
	Результат.Колонки.Добавить("ПортСервераВходящейПочты");
	Результат.Колонки.Добавить("ИспользоватьЗащищенноеСоединениеДляВходящейПочты");
	
	// icloud.com
	Если ИмяСервераВУчетнойЗаписи = "icloud.com" Тогда
		ВариантНастройки = Результат.Добавить();
		ВариантНастройки.СерверВходящейПочты = "imap.mail.me.com";
		ВариантНастройки.ПортСервераВходящейПочты = 993;
		ВариантНастройки.ИспользоватьЗащищенноеСоединениеДляВходящейПочты = Истина;
		Возврат Результат;
	КонецЕсли;
	
	// outlook.com
	Если ИмяСервераВУчетнойЗаписи = "outlook.com" Тогда
		ВариантНастройки = Результат.Добавить();
		ВариантНастройки.СерверВходящейПочты = "imap-mail.outlook.com";
		ВариантНастройки.ПортСервераВходящейПочты = 993;
		ВариантНастройки.ИспользоватьЗащищенноеСоединениеДляВходящейПочты = Истина;
		Возврат Результат;
	КонецЕсли;

	// Стандартные настройки, подходящие для ящиков gmail, yandex и mail.ru
	// имя сервера с префиксом "imap.", защищенное соединение.
	ВариантНастройки = Результат.Добавить();
	ВариантНастройки.СерверВходящейПочты = "imap." + ИмяСервераВУчетнойЗаписи;
	ВариантНастройки.ПортСервераВходящейПочты = 993;
	ВариантНастройки.ИспользоватьЗащищенноеСоединениеДляВходящейПочты = Истина;
	
	// Имя сервера с префиксом "mail.", защищенное соединение.
	ВариантНастройки = Результат.Добавить();
	ВариантНастройки.СерверВходящейПочты = "mail." + ИмяСервераВУчетнойЗаписи;
	ВариантНастройки.ПортСервераВходящейПочты = 993;
	ВариантНастройки.ИспользоватьЗащищенноеСоединениеДляВходящейПочты = Истина;
	
	// Имя сервера без префикса "imap.", защищенное соединение.
	ВариантНастройки = Результат.Добавить();
	ВариантНастройки.СерверВходящейПочты = ИмяСервераВУчетнойЗаписи;
	ВариантНастройки.ПортСервераВходящейПочты = 993;
	ВариантНастройки.ИспользоватьЗащищенноеСоединениеДляВходящейПочты = Истина;
	
	// Имя сервера с префиксом "imap.", незащищенное соединение.
	ВариантНастройки = Результат.Добавить();
	ВариантНастройки.СерверВходящейПочты = "imap." + ИмяСервераВУчетнойЗаписи;
	ВариантНастройки.ПортСервераВходящейПочты = 143;
	ВариантНастройки.ИспользоватьЗащищенноеСоединениеДляВходящейПочты = Ложь;
	
	// Имя сервера с префиксом "mail.", незащищенное соединение.
	ВариантНастройки = Результат.Добавить();
	ВариантНастройки.СерверВходящейПочты = "mail." + ИмяСервераВУчетнойЗаписи;
	ВариантНастройки.ПортСервераВходящейПочты = 143;
	ВариантНастройки.ИспользоватьЗащищенноеСоединениеДляВходящейПочты = Ложь;
	
	// Имя сервера без префикса "imap.", незащищенное соединение.
	ВариантНастройки = Результат.Добавить();
	ВариантНастройки.СерверВходящейПочты = ИмяСервераВУчетнойЗаписи;
	ВариантНастройки.ПортСервераВходящейПочты = 143;
	ВариантНастройки.ИспользоватьЗащищенноеСоединениеДляВходящейПочты = Ложь;
	
	Возврат Результат;
	
КонецФункции

Функция ВариантыНастройкиПодключенияКСерверуPOP(АдресЭлектроннойПочты)
	
	Позиция = СтрНайти(АдресЭлектроннойПочты, "@");
	ИмяСервераВУчетнойЗаписи = Сред(АдресЭлектроннойПочты, Позиция + 1);
	
	Результат = Новый ТаблицаЗначений;
	Результат.Колонки.Добавить("СерверВходящейПочты");
	Результат.Колонки.Добавить("ПортСервераВходящейПочты");
	Результат.Колонки.Добавить("ИспользоватьЗащищенноеСоединениеДляВходящейПочты");
	
	// Стандартные настройки, подходящие для ящиков  gmail, yandex и mail.ru
	// имя сервера с префиксом "pop.", защищенное соединение.
	ВариантНастройки = Результат.Добавить();
	ВариантНастройки.СерверВходящейПочты = "pop." + ИмяСервераВУчетнойЗаписи;
	ВариантНастройки.ПортСервераВходящейПочты = 995;
	ВариантНастройки.ИспользоватьЗащищенноеСоединениеДляВходящейПочты = Истина;
	
	// Имя сервера с префиксом "pop3.", защищенное соединение.
	ВариантНастройки = Результат.Добавить();
	ВариантНастройки.СерверВходящейПочты = "pop3." + ИмяСервераВУчетнойЗаписи;
	ВариантНастройки.ПортСервераВходящейПочты = 995;
	ВариантНастройки.ИспользоватьЗащищенноеСоединениеДляВходящейПочты = Истина;
	
	// Имя сервера с префиксом "mail.", защищенное соединение.
	ВариантНастройки = Результат.Добавить();
	ВариантНастройки.СерверВходящейПочты = "mail." + ИмяСервераВУчетнойЗаписи;
	ВариантНастройки.ПортСервераВходящейПочты = 995;
	ВариантНастройки.ИспользоватьЗащищенноеСоединениеДляВходящейПочты = Истина;
	
	// Имя сервера без префиксов, защищенное соединение.
	ВариантНастройки = Результат.Добавить();
	ВариантНастройки.СерверВходящейПочты = ИмяСервераВУчетнойЗаписи;
	ВариантНастройки.ПортСервераВходящейПочты = 995;
	ВариантНастройки.ИспользоватьЗащищенноеСоединениеДляВходящейПочты = Истина;
	
	// Имя сервера с префиксом "pop.", незащищенное соединение.
	ВариантНастройки = Результат.Добавить();
	ВариантНастройки.СерверВходящейПочты = "pop." + ИмяСервераВУчетнойЗаписи;
	ВариантНастройки.ПортСервераВходящейПочты = 110;
	ВариантНастройки.ИспользоватьЗащищенноеСоединениеДляВходящейПочты = Ложь;
	
	// Имя сервера с префиксом "pop3", незащищенное соединение.
	ВариантНастройки = Результат.Добавить();
	ВариантНастройки.СерверВходящейПочты = "pop3." + ИмяСервераВУчетнойЗаписи;
	ВариантНастройки.ПортСервераВходящейПочты = 110;
	ВариантНастройки.ИспользоватьЗащищенноеСоединениеДляВходящейПочты = Ложь;
	
	// Имя сервера с префиксом "mail.", незащищенное соединение.
	ВариантНастройки = Результат.Добавить();
	ВариантНастройки.СерверВходящейПочты = "mail." + ИмяСервераВУчетнойЗаписи;
	ВариантНастройки.ПортСервераВходящейПочты = 110;
	ВариантНастройки.ИспользоватьЗащищенноеСоединениеДляВходящейПочты = Ложь;
	
	// Имя сервера без префиксов, незащищенное соединение.
	ВариантНастройки = Результат.Добавить();
	ВариантНастройки.СерверВходящейПочты = ИмяСервераВУчетнойЗаписи;
	ВариантНастройки.ПортСервераВходящейПочты = 110;
	ВариантНастройки.ИспользоватьЗащищенноеСоединениеДляВходящейПочты = Ложь;
	
	Возврат Результат;
	
КонецФункции

Функция ВариантыНастройкиПодключенияКСерверуSMTP(АдресЭлектроннойПочты) Экспорт
	
	Позиция = СтрНайти(АдресЭлектроннойПочты, "@");
	ИмяСервераВУчетнойЗаписи = Сред(АдресЭлектроннойПочты, Позиция + 1);
	
	Результат = Новый ТаблицаЗначений;
	Результат.Колонки.Добавить("СерверИсходящейПочты");
	Результат.Колонки.Добавить("ПортСервераИсходящейПочты");
	Результат.Колонки.Добавить("ИспользоватьЗащищенноеСоединениеДляИсходящейПочты");
	
	// icloud.com
	Если ИмяСервераВУчетнойЗаписи = "icloud.com" Тогда
		ВариантНастройки = Результат.Добавить();
		ВариантНастройки.СерверИсходящейПочты = "smtp.mail.me.com";
		ВариантНастройки.ПортСервераИсходящейПочты = 587;
		ВариантНастройки.ИспользоватьЗащищенноеСоединениеДляИсходящейПочты = Ложь;
		Возврат Результат;
	КонецЕсли;
	
	// outlook.com
	Если ИмяСервераВУчетнойЗаписи = "outlook.com" Тогда
		ВариантНастройки = Результат.Добавить();
		ВариантНастройки.СерверИсходящейПочты = "smtp-mail.outlook.com";
		ВариантНастройки.ПортСервераИсходящейПочты = 587;
		ВариантНастройки.ИспользоватьЗащищенноеСоединениеДляИсходящейПочты = Ложь;
		Возврат Результат;
	КонецЕсли;
	
	// Стандартные настройки, подходящие для ящиков gmail, yandex и mail.ru
	// имя сервера с префиксом "smtp.", защищенное соединение, порт 465.
	ВариантНастройки = Результат.Добавить();
	ВариантНастройки.СерверИсходящейПочты = "smtp." + ИмяСервераВУчетнойЗаписи;
	ВариантНастройки.ПортСервераИсходящейПочты = 465;
	ВариантНастройки.ИспользоватьЗащищенноеСоединениеДляИсходящейПочты = Истина;
	
	// Имя сервера с префиксом "mail.", защищенное соединение, порт 465.
	ВариантНастройки = Результат.Добавить();
	ВариантНастройки.СерверИсходящейПочты = "mail." + ИмяСервераВУчетнойЗаписи;
	ВариантНастройки.ПортСервераИсходящейПочты = 465;
	ВариантНастройки.ИспользоватьЗащищенноеСоединениеДляИсходящейПочты = Истина;
	
	// Имя сервера без префиксов, защищенное соединение, порт 465.
	ВариантНастройки = Результат.Добавить();
	ВариантНастройки.СерверИсходящейПочты = ИмяСервераВУчетнойЗаписи;
	ВариантНастройки.ПортСервераИсходящейПочты = 465;
	ВариантНастройки.ИспользоватьЗащищенноеСоединениеДляИсходящейПочты = Истина;
	
	// Имя сервера с префиксом "smtp.", защищенное (STARTTLS) соединение, порт 587.
	ВариантНастройки = Результат.Добавить();
	ВариантНастройки.СерверИсходящейПочты = "smtp." + ИмяСервераВУчетнойЗаписи;
	ВариантНастройки.ПортСервераИсходящейПочты = 587;
	ВариантНастройки.ИспользоватьЗащищенноеСоединениеДляИсходящейПочты = Ложь;
	
	// Имя сервера с префиксом "mail.", защищенное (STARTTLS) соединение, порт 587.
	ВариантНастройки = Результат.Добавить();
	ВариантНастройки.СерверИсходящейПочты = "mail." + ИмяСервераВУчетнойЗаписи;
	ВариантНастройки.ПортСервераИсходящейПочты = 587;
	ВариантНастройки.ИспользоватьЗащищенноеСоединениеДляИсходящейПочты = Ложь;
	
	// Имя сервера без префиксов, защищенное (STARTTLS) соединение, порт 587.
	ВариантНастройки = Результат.Добавить();
	ВариантНастройки.СерверИсходящейПочты = ИмяСервераВУчетнойЗаписи;
	ВариантНастройки.ПортСервераИсходящейПочты = 587;
	ВариантНастройки.ИспользоватьЗащищенноеСоединениеДляИсходящейПочты = Ложь;
	
	// Имя сервера с префиксом "smtp.", незащищенное соединение.
	ВариантНастройки = Результат.Добавить();
	ВариантНастройки.СерверИсходящейПочты = "smtp." + ИмяСервераВУчетнойЗаписи;
	ВариантНастройки.ПортСервераИсходящейПочты = 25;
	ВариантНастройки.ИспользоватьЗащищенноеСоединениеДляИсходящейПочты = Ложь;
	
	// Имя сервера с префиксом "mail.", незащищенное соединение.
	ВариантНастройки = Результат.Добавить();
	ВариантНастройки.СерверИсходящейПочты = "mail." + ИмяСервераВУчетнойЗаписи;
	ВариантНастройки.ПортСервераИсходящейПочты = 25;
	ВариантНастройки.ИспользоватьЗащищенноеСоединениеДляИсходящейПочты = Ложь;
	
	// Имя сервера без префиксов, незащищенное соединение.
	ВариантНастройки = Результат.Добавить();
	ВариантНастройки.СерверИсходящейПочты = ИмяСервераВУчетнойЗаписи;
	ВариантНастройки.ПортСервераИсходящейПочты = 25;
	ВариантНастройки.ИспользоватьЗащищенноеСоединениеДляИсходящейПочты = Ложь;
	
	Возврат Результат;
	
КонецФункции

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	Если ВидФормы = "ФормаОбъекта" 
		И Не Параметры.Свойство("ЗначениеКопирования")
		И ПравоДоступа("Редактирование", Метаданные.Справочники.УчетныеЗаписиЭлектроннойПочты)
		И (Не Параметры.Свойство("Ключ") 
			Или Не РаботаСПочтовымиСообщениями.УчетнаяЗаписьНастроена(Параметры.Ключ, Ложь, Ложь) И ИзменениеРазрешено(Параметры.Ключ)) Тогда
		
		ВыбраннаяФорма = "ПомощникНастройкиУчетнойЗаписи";
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
КонецПроцедуры

Функция ИзменениеРазрешено(УчетнаяЗапись) Экспорт
	Результат = ПравоДоступа("Редактирование", Метаданные.Справочники.УчетныеЗаписиЭлектроннойПочты);
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		Результат = Результат И МодульУправлениеДоступом.ИзменениеРазрешено(УчетнаяЗапись);
	КонецЕсли;
	Возврат Результат;
КонецФункции

Функция РеквизитыТребующиеВводаПароляДляИзменения() Экспорт
	
	Возврат "ИспользоватьДляОтправки,ИспользоватьДляПолучения,СерверВходящейПочты,СерверИсходящейПочты,ВладелецУчетнойЗаписи,ИспользоватьЗащищенноеСоединениеДляВходящейПочты,ИспользоватьЗащищенноеСоединениеДляИсходящейПочты,ИспользоватьБезопасныйВходНаСерверВходящейПочты,ИспользоватьБезопасныйВходНаСерверИсходящейПочты,Пользователь,ПользовательSMTP";
	
КонецФункции

Функция ТребуетсяПроверкаПароля(Ссылка, ЗначенияРеквизитовПередЗаписью) Экспорт
	
	Если Ссылка.Пустая() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	СписокРеквизитов = РеквизитыТребующиеВводаПароляДляИзменения();
	ЗаписанныеЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ссылка, СписокРеквизитов);
	
	Результат = ЗначениеЗаполнено(ЗаписанныеЗначенияРеквизитов.ВладелецУчетнойЗаписи);
	Если Результат Тогда
		ДоИзменения = Новый Структура(СписокРеквизитов);
		ЗаполнитьЗначенияСвойств(ДоИзменения, ЗаписанныеЗначенияРеквизитов);
		ПослеИзменения = Новый Структура(СписокРеквизитов);
		ЗаполнитьЗначенияСвойств(ПослеИзменения, ЗначенияРеквизитовПередЗаписью);
		Результат = ОбщегоНазначения.ЗначениеВСтрокуXML(ДоИзменения) <> ОбщегоНазначения.ЗначениеВСтрокуXML(ПослеИзменения);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ПроверитьВозможностьПодключенияКПочтовомуСерверу(Знач УчетнаяЗапись, Знач ВходящаяПочта) Экспорт
	
	УстановитьОтключениеБезопасногоРежима(Истина);
	Профиль = РаботаСПочтовымиСообщениямиСлужебный.ИнтернетПочтовыйПрофиль(УчетнаяЗапись, ВходящаяПочта);
	
	Если ВходящаяПочта Тогда
		Протокол = ПротоколИнтернетПочты.POP3;
		Если ОбщегоНазначения.ЗначениеРеквизитаОбъекта(УчетнаяЗапись, "ПротоколВходящейПочты") = "IMAP" Тогда
			Протокол = ПротоколИнтернетПочты.IMAP;
		КонецЕсли;
		ТекстОшибки = ПроверитьПодключениеКСерверуВходящейПочты(Профиль, Протокол);
	Иначе
		Адрес = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(УчетнаяЗапись, "АдресЭлектроннойПочты");
		ТекстОшибки = ПроверитьПодключениеКСерверуИсходящейПочты(Профиль, Адрес);
	КонецЕсли;
	
	Возврат ТекстОшибки;
	
КонецФункции

Функция ПроверитьНастройкиУчетнойЗаписи(УчетнаяЗапись) Экспорт
	
	НастройкиУчетнойЗаписи = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(УчетнаяЗапись, "ИспользоватьДляОтправки,ИспользоватьДляПолучения,ПротоколВходящейПочты,АдресЭлектроннойПочты");
	
	ТекстСообщения = Новый Массив;
	ТехническиеПодробности = Новый Массив;
	ВыполненныеПроверки = Новый Массив;
	
	ОшибкаАутентификации = Ложь;
	ТребуетсяПроверкаНастроекИсходящейПочты = Ложь;
	ТребуетсяПроверкаНастроекВходящейПочты = Ложь;
	УчетнаяЗаписьИспользуется = НастройкиУчетнойЗаписи.ИспользоватьДляОтправки Или НастройкиУчетнойЗаписи.ИспользоватьДляПолучения;
	
	Если НастройкиУчетнойЗаписи.ИспользоватьДляОтправки Тогда
		ТекстОшибки = ПроверитьВозможностьПодключенияКПочтовомуСерверу(УчетнаяЗапись, Ложь);
		Если ЗначениеЗаполнено(ТекстОшибки) Тогда
			ТехническиеПодробности.Добавить(ТекстОшибки);
			
			ОшибкаАутентификации = ОшибкаАутентификации(ТекстОшибки);
			Если ОшибкаАутентификации(ТекстОшибки) Тогда
				ТекстСообщения.Добавить(НСтр("ru = 'Отправка тестового сообщения не выполнена: не удалось авторизоваться.'"));
			Иначе
				ТекстСообщения.Добавить(НСтр("ru = 'Отправка тестового сообщения не выполнена.'"));
				ТребуетсяПроверкаНастроекИсходящейПочты = Истина;
			КонецЕсли;
		Иначе
			ВыполненныеПроверки.Добавить("- " + НСтр("ru = 'Выполнена отправка тестового сообщения.'"));
		КонецЕсли;
		
	КонецЕсли;
	
	Если НастройкиУчетнойЗаписи.ИспользоватьДляПолучения Тогда
		
		ТекстОшибки = ПроверитьВозможностьПодключенияКПочтовомуСерверу(УчетнаяЗапись, Истина);
		Если ЗначениеЗаполнено(ТекстОшибки) Тогда
			ТехническиеПодробности.Добавить(ТекстОшибки);
			
			ОшибкаАутентификации = ОшибкаАутентификации(ТекстОшибки);
			Если ОшибкаАутентификации(ТекстОшибки) Тогда
				ТекстСообщения.Добавить(НСтр("ru = 'Подключение к серверу входящей почты не выполнено: не удалось авторизоваться.'"));
			Иначе
				ТекстСообщения.Добавить(НСтр("ru = 'Подключение к серверу входящей почты не выполнено.'"));
				ТребуетсяПроверкаНастроекВходящейПочты = Истина;
			КонецЕсли;
		Иначе
			ВыполненныеПроверки.Добавить("- " + НСтр("ru = 'Выполнено подключение к серверу входящей почты.'"));
		КонецЕсли;
		
	КонецЕсли;
	
	ОшибкиПодключения = "";
	
	Если ЗначениеЗаполнено(ТекстСообщения) Тогда
		ЧастиАдреса = СтрРазделить(НастройкиУчетнойЗаписи.АдресЭлектроннойПочты, "@", Истина);
		ДоменноеИмя = ЧастиАдреса[ЧастиАдреса.ВГраница()];
		ТекстСообщения = СтрСоединить(ТекстСообщения, Символы.ПС);
		ТехническиеПодробности = СтрСоединить(ТехническиеПодробности, Символы.ПС + Символы.ПС);
		
		Рекомендации = Новый Массив;
		Если ОшибкаАутентификации Тогда
			Рекомендации.Добавить(НСтр("ru = 'Проверьте правильность ввода логина и пароля, а также выбранный способ авторизации.'"));
		КонецЕсли;
		Если ТребуетсяПроверкаНастроекИсходящейПочты Тогда
			Рекомендации.Добавить(НСтр("ru = 'Проверьте настройки подключения к серверу исходящей почты.'"));
		КонецЕсли;
		Если ТребуетсяПроверкаНастроекИсходящейПочты Тогда
			Рекомендации.Добавить(НСтр("ru = 'Проверьте настройки подключения к серверу входящей почты.'"));
		КонецЕсли;
		Рекомендации = СтрСоединить(Рекомендации, Символы.ПС);
		
		ОшибкиПодключения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '%1
			|
			|%2
			|
			|Обратитесь к администратору почтового сервера ""%3"".
			|---
			|Технические подробности:
			|
			|%4'"), ТекстСообщения, Рекомендации, ДоменноеИмя, ТехническиеПодробности);
	КонецЕсли;
	
	ВыполненныеПроверки = СтрСоединить(ВыполненныеПроверки, Символы.ПС);
	
	Результат = Новый Структура;
	Результат.Вставить("ВыполненныеПроверки", ВыполненныеПроверки);
	Результат.Вставить("ОшибкиПодключения", ОшибкиПодключения);
	
	Возврат Результат;
	
КонецФункции

Процедура ПроверитьНастройкиУчетнойЗаписиВФоне(Параметры, АдресРезультата) Экспорт
	
	Результат = ПроверитьНастройкиУчетнойЗаписи(Параметры.УчетнаяЗапись);
	ПоместитьВоВременноеХранилище(Результат, АдресРезультата);
	
КонецПроцедуры

#КонецОбласти

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

// Возвращает реквизиты объекта, которые разрешается редактировать
// с помощью обработки группового изменения реквизитов.
//
// Возвращаемое значение:
//  Массив - список имен реквизитов объекта.
Функция РеквизитыРедактируемыеВГрупповойОбработке() Экспорт
	
	Результат = Новый Массив;
	Результат.Добавить("ИспользоватьДляОтправки");
	Результат.Добавить("ИспользоватьДляПолучения");
	Возврат Результат;
	
КонецФункции

// Конец СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	
	Ограничение.Текст =
	"РазрешитьЧтение
	|ГДЕ
	|	ЗначениеРазрешено(Ссылка)
	|	ИЛИ ЗначениеРазрешено(ВладелецУчетнойЗаписи, ПустаяСсылка КАК Ложь)
	|;
	|РазрешитьИзменениеЕслиРазрешеноЧтение
	|ГДЕ
	|	ЗначениеРазрешено(ВладелецУчетнойЗаписи, ПустаяСсылка КАК Ложь)";
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Регистрирует на плане обмена ОбновлениеИнформационнойБазы объекты,
// которые необходимо обновить на новую версию.
//
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Взаимодействия") Тогда
		МодульВзаимодействия = ОбщегоНазначения.ОбщийМодуль("Взаимодействия");
		МодульВзаимодействия.ЗарегистрироватьУчетныеЗаписиЭлектроннойПочтыКОбработкеДляПереходаНаНовуюВерсию(Параметры);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	УчетныеЗаписи = Новый Массив;
	Выборка = ОбновлениеИнформационнойБазы.ВыбратьСсылкиДляОбработки(Параметры.Очередь, "Справочник.УчетныеЗаписиЭлектроннойПочты");
	Пока Выборка.Следующий() Цикл
		УчетныеЗаписи.Добавить(Выборка.Ссылка);
	КонецЦикла;
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	УчетныеЗаписиЭлектроннойПочты.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.УчетныеЗаписиЭлектроннойПочты КАК УчетныеЗаписиЭлектроннойПочты
	|ГДЕ
	|	УчетныеЗаписиЭлектроннойПочты.Ссылка В(&УчетныеЗаписи)";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("УчетныеЗаписи", УчетныеЗаписи);
	
	Блокировка = Новый БлокировкаДанных;
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Взаимодействия") Тогда
		МодульВзаимодействия = ОбщегоНазначения.ОбщийМодуль("Взаимодействия");
		МодульВзаимодействия.ПередУстановкойБлокировкиВОбработчикеОбновленияУчетныхЗаписейЭлектроннойПочты(Блокировка);
	КонецЕсли;
	Блокировка.Добавить("Справочник.УчетныеЗаписиЭлектроннойПочты");
	
	НачатьТранзакцию();
	Попытка
		Блокировка.Заблокировать();
		
		ВладельцыУчетныхЗаписей = Новый Соответствие;
		Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Взаимодействия") Тогда
			МодульВзаимодействия = ОбщегоНазначения.ОбщийМодуль("Взаимодействия");
			ВладельцыУчетныхЗаписей = МодульВзаимодействия.ВладельцыУчетныхЗаписейЭлектроннойПочты(УчетныеЗаписи);
		КонецЕсли;
		
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			УчетнаяЗапись = Выборка.Ссылка.ПолучитьОбъект();
			УчетнаяЗапись.ДополнительныеСвойства.Вставить("НеПроверятьИзменениеНастроек");
			Если ВладельцыУчетныхЗаписей[Выборка.Ссылка] <> Неопределено Тогда
				УчетнаяЗапись.ВладелецУчетнойЗаписи = ВладельцыУчетныхЗаписей[Выборка.Ссылка];
			КонецЕсли;
			ОбновлениеИнформационнойБазы.ЗаписатьДанные(УчетнаяЗапись);
		КонецЦикла;
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Обновление персональных учетных записей'", ОбщегоНазначения.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка,,, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ВызватьИсключение;
	КонецПопытки;
	
	Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Параметры.Очередь, "Справочник.УчетныеЗаписиЭлектроннойПочты");
	
КонецПроцедуры

#КонецОбласти
