﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	НастройкиПодсистемы = НапоминанияПользователяСлужебный.НастройкиПодсистемы();
	
	Объект.Пользователь = Пользователи.ТекущийПользователь();
	
	Если Параметры.Свойство("Источник") Тогда 
		Объект.Источник = Параметры.Источник;
		Объект.Описание = ОбщегоНазначения.ПредметСтрокой(Объект.Источник);
	КонецЕсли;
	
	Если Параметры.Свойство("Ключ") Тогда
		ИсходныеПараметры = Новый Структура("Пользователь,ВремяСобытия,Источник");
		ЗаполнитьЗначенияСвойств(ИсходныеПараметры, Параметры.Ключ);
		ИсходныеПараметры = Новый ФиксированнаяСтруктура(ИсходныеПараметры);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.Источник) Тогда
		ЗаполнитьСписокРеквизитовИсточника();
	КонецЕсли;
	
	ЗаполнитьВариантыПериодичности();
	ОпределитьВыбранныйВариантПериодичности();	
	
	ЭтоНовый = Не ЗначениеЗаполнено(Объект.ИсходныйКлючЗаписи);
	Элементы.Удалить.Видимость = Не ЭтоНовый;
	
	Элементы.Предмет.Видимость = ЗначениеЗаполнено(Объект.Источник);
	Элементы.ПредметНапоминания.Заголовок = ОбщегоНазначения.ПредметСтрокой(Объект.Источник);
	Если ЗначениеЗаполнено(Объект.Источник) Тогда
		КлючСохраненияПоложенияОкна = "НапоминаниеПоПредмету";
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом

	Расписание = ТекущийОбъект.Расписание.Получить();
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если ТекущийОбъект.СпособУстановкиВремениНапоминания = Перечисления.СпособыУстановкиВремениНапоминания.ОтносительноТекущегоВремени Тогда
		ТекущийОбъект.ВремяСобытия = ТекущаяДатаСеанса() + Объект.ИнтервалВремениНапоминания;
		ТекущийОбъект.СрокНапоминания = ТекущийОбъект.ВремяСобытия;
		ТекущийОбъект.СпособУстановкиВремениНапоминания = Перечисления.СпособыУстановкиВремениНапоминания.ВУказанноеВремя;
	ИначеЕсли ТекущийОбъект.СпособУстановкиВремениНапоминания = Перечисления.СпособыУстановкиВремениНапоминания.ОтносительноВремениПредмета Тогда
		ДатаВИсточнике = НапоминанияПользователяСлужебный.ПолучитьЗначениеРеквизитаПредмета(Объект.Источник, Объект.ИмяРеквизитаИсточника);
		Если ЗначениеЗаполнено(ДатаВИсточнике) Тогда
			ДатаВИсточнике = ВычислитьБлижайшуюДату(ДатаВИсточнике);
			ТекущийОбъект.ВремяСобытия = ДатаВИсточнике;
			ТекущийОбъект.СрокНапоминания = ДатаВИсточнике - Объект.ИнтервалВремениНапоминания;
		Иначе
			ТекущийОбъект.ВремяСобытия = '00010101';
		КонецЕсли;
	ИначеЕсли ТекущийОбъект.СпособУстановкиВремениНапоминания = Перечисления.СпособыУстановкиВремениНапоминания.ВУказанноеВремя Тогда
		ТекущийОбъект.СрокНапоминания = Объект.ВремяСобытия;
	ИначеЕсли ТекущийОбъект.СпособУстановкиВремениНапоминания = Перечисления.СпособыУстановкиВремениНапоминания.Периодически Тогда
		БлижайшееВремяНапоминания = НапоминанияПользователяСлужебный.ПолучитьБлижайшуюДатуСобытияПоРасписанию(Расписание);
		Если БлижайшееВремяНапоминания = Неопределено Тогда
			БлижайшееВремяНапоминания = ТекущаяДатаСеанса();
		КонецЕсли;
		ТекущийОбъект.ВремяСобытия = БлижайшееВремяНапоминания;
		ТекущийОбъект.СрокНапоминания = ТекущийОбъект.ВремяСобытия;
	КонецЕсли;
	
	Если ТекущийОбъект.СпособУстановкиВремениНапоминания <> Перечисления.СпособыУстановкиВремениНапоминания.Периодически Тогда
		Расписание = Неопределено;
	КонецЕсли;
	
	ТекущийОбъект.Расписание = Новый ХранилищеЗначения(Расписание, Новый СжатиеДанных(9));
	
	НаборЗаписей = РегистрыСведений.НапоминанияПользователя.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Пользователь.Установить(ТекущийОбъект.Пользователь);
	НаборЗаписей.Отбор.Источник.Установить(ТекущийОбъект.Источник);
	НаборЗаписей.Прочитать();
	Если НаборЗаписей.Количество() > 0 Тогда
		ЗанятоеВремя = НаборЗаписей.Выгрузить(,"ВремяСобытия").ВыгрузитьКолонку("ВремяСобытия");
		Пока ЗанятоеВремя.Найти(ТекущийОбъект.ВремяСобытия) <> Неопределено Цикл
			ТекущийОбъект.ВремяСобытия = ТекущийОбъект.ВремяСобытия + 1;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// если это новая запись
	Если Не ЗначениеЗаполнено(Объект.ИсходныйКлючЗаписи) Тогда
		Если Элементы.ИмяРеквизитаИсточника.СписокВыбора.Количество() > 0 Тогда
			Объект.ИмяРеквизитаИсточника = Элементы.ИмяРеквизитаИсточника.СписокВыбора[0].Значение;
			Объект.СпособУстановкиВремениНапоминания = ПредопределенноеЗначение("Перечисление.СпособыУстановкиВремениНапоминания.ОтносительноВремениПредмета");
		КонецЕсли;
		Объект.ВремяСобытия = ОбщегоНазначенияКлиент.ДатаСеанса();
	КонецЕсли;
	
	ЗаполнитьСписокВремени();
	
	ЗаполнитьСпособыОповещения();
	Если Элементы.ИмяРеквизитаИсточника.СписокВыбора.Количество() = 0 Тогда
		Элементы.СпособУстановкиВремениНапоминания.СписокВыбора.Удалить(Элементы.СпособУстановкиВремениНапоминания.СписокВыбора.НайтиПоЗначению(ПолучитьКлючПоЗначениюВСоответствии(ПолучитьПредопределенныеСпособыОповещения(),ПредопределенноеЗначение("Перечисление.СпособыУстановкиВремениНапоминания.ОтносительноВремениПредмета"))));
	КонецЕсли;		
		
	Если Объект.ИнтервалВремениНапоминания > 0 Тогда
		ИнтервалВремениСтрокой = НапоминанияПользователяКлиентСервер.ПредставлениеВремени(Объект.ИнтервалВремениНапоминания);
	КонецЕсли;
	
	ПредопределенныеСпособыОповещения = ПолучитьПредопределенныеСпособыОповещения();
	ВыбранныйСпособ = ПолучитьКлючПоЗначениюВСоответствии(ПредопределенныеСпособыОповещения, Объект.СпособУстановкиВремениНапоминания);
	
	Если Объект.СпособУстановкиВремениНапоминания = ПредопределенноеЗначение("Перечисление.СпособыУстановкиВремениНапоминания.ОтносительноТекущегоВремени") Тогда
		СпособУстановкиВремениНапоминания = НСтр("ru = 'через'") + " " + НапоминанияПользователяКлиентСервер.ПредставлениеВремени(Объект.ИнтервалВремениНапоминания);
	Иначе
		СпособУстановкиВремениНапоминания = ВыбранныйСпособ;
	КонецЕсли;
	
	УстановитьВидимость();
	
	ОбновитьРасчетноеВремяНапоминания();
	ПодключитьОбработчикОжидания("ОбновитьРасчетноеВремяНапоминания", 1);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	// для обновления кэша
	СтруктураПараметров = НапоминанияПользователяКлиентСервер.ОписаниеНапоминания(Объект, Истина);
	СтруктураПараметров.Вставить("ИндексКартинки", 2);
	
	НапоминанияПользователяКлиент.ОбновитьЗаписьВКэшеОповещений(СтруктураПараметров);
	
	НапоминанияПользователяКлиент.СброситьТаймерПроверкиТекущихОповещений();
	
	Если ЗначениеЗаполнено(Объект.Источник) Тогда 
		ОповеститьОбИзменении(Объект.Источник);
	КонецЕсли;
	
	Оповестить("Запись_НапоминанияПользователя", Новый Структура, ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	Если ИсходныеПараметры <> Неопределено Тогда 
		НапоминанияПользователяКлиент.УдалитьЗаписьИзКэшаОповещений(ИсходныеПараметры);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СпособУстановкиВремениНапоминанияПриИзменении(Элемент)
	ОчиститьСообщения();
	
	ИнтервалВремени = НапоминанияПользователяКлиентСервер.ПолучитьИнтервалВремениИзСтроки(СпособУстановкиВремениНапоминания);
	Если ИнтервалВремени > 0 Тогда
		ИнтервалВремениСтрокой = НапоминанияПользователяКлиентСервер.ПредставлениеВремени(ИнтервалВремени);
		СпособУстановкиВремениНапоминания = НСтр("ru = 'через'") + " " + ИнтервалВремениСтрокой;
	Иначе
		Если Элементы.СпособУстановкиВремениНапоминания.СписокВыбора.НайтиПоЗначению(СпособУстановкиВремениНапоминания) = Неопределено Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Интервал времени не определен.'"), , "СпособУстановкиВремениНапоминания");
		КонецЕсли;
	КонецЕсли;
	
	ПредопределенныеСпособыОповещения = ПолучитьПредопределенныеСпособыОповещения();
	ВыбранныйСпособ = ПредопределенныеСпособыОповещения.Получить(СпособУстановкиВремениНапоминания);
	
	Если ВыбранныйСпособ = Неопределено Тогда
		Объект.СпособУстановкиВремениНапоминания = ПредопределенноеЗначение("Перечисление.СпособыУстановкиВремениНапоминания.ОтносительноТекущегоВремени");
	Иначе
		Объект.СпособУстановкиВремениНапоминания = ВыбранныйСпособ;
	КонецЕсли;
	
	Объект.ИнтервалВремениНапоминания = ИнтервалВремени;
	
	УстановитьВидимость();		
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииИнтервалаВремени(Элемент)
	Объект.ИнтервалВремениНапоминания = НапоминанияПользователяКлиентСервер.ПолучитьИнтервалВремениИзСтроки(ИнтервалВремениСтрокой);
	Если Объект.ИнтервалВремениНапоминания > 0 Тогда
		ИнтервалВремениСтрокой = НапоминанияПользователяКлиентСервер.ПредставлениеВремени(Объект.ИнтервалВремениНапоминания);
	Иначе
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Интервал времени не определен'"), , "ИнтервалВремениСтрокой");
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВариантПериодичностиПриИзменении(Элемент)
	ПриИзмененииРасписания();
КонецПроцедуры

&НаКлиенте
Процедура ВариантПериодичностиОткрытие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ПриИзмененииРасписания();
КонецПроцедуры

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	ЗаполнитьСписокВремени();
КонецПроцедуры

&НаКлиенте
Процедура ВремяПриИзменении(Элемент)
	Объект.ВремяСобытия = НачалоМинуты(Объект.ВремяСобытия);
КонецПроцедуры

&НаКлиенте
Процедура ПредметНапоминанияНажатие(Элемент)
	ПоказатьЗначение(, Объект.Источник);
КонецПроцедуры

&НаКлиенте
Процедура ИмяРеквизитаИсточникаОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Удалить(Команда)
	
	КнопкиДиалога = Новый СписокЗначений;
	КнопкиДиалога.Добавить(КодВозвратаДиалога.Да, НСтр("ru = 'Удалить'"));
	КнопкиДиалога.Добавить(КодВозвратаДиалога.Отмена, НСтр("ru = 'Не удалять'"));
	
	ОписаниеОповещения = Новый ОписаниеОповещения("УдалитьНапоминание", ЭтотОбъект);
	ПоказатьВопрос(ОписаниеОповещения, НСтр("ru = 'Удалить напоминание?'"), КнопкиДиалога);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УдалитьНапоминание(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ЭтотОбъект.Модифицированность = Ложь;
		Если ИсходныеПараметры <> Неопределено Тогда 
			ОтключитьНапоминание();
			НапоминанияПользователяКлиент.УдалитьЗаписьИзКэшаОповещений(ИсходныеПараметры);
			Оповестить("Запись_НапоминанияПользователя", Новый Структура, Объект.ИсходныйКлючЗаписи);
			ОповеститьОбИзменении(Тип("РегистрСведенийКлючЗаписи.НапоминанияПользователя"));
		КонецЕсли;
		Если ЭтотОбъект.Открыта() Тогда
			Закрыть();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОтключитьНапоминание()
	НапоминанияПользователяСлужебный.ОтключитьНапоминание(ИсходныеПараметры, Ложь);
КонецПроцедуры

&НаСервереБезКонтекста
Функция РеквизитИсточникаСуществуетИСодержитТипДата(МетаданныеИсточника, ИмяРеквизита, ПроверятьДату = Ложь)
	Результат = Ложь;
	Если МетаданныеИсточника.Реквизиты.Найти(ИмяРеквизита) <> Неопределено
		И МетаданныеИсточника.Реквизиты[ИмяРеквизита].Тип.СодержитТип(Тип("Дата")) Тогда
			Результат = Истина;
	КонецЕсли;
	Возврат Результат;
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ПолучитьКлючПоЗначениюВСоответствии(Соответствие, Значение)
	Результат = Неопределено;
	Для Каждого КлючИЗначение Из Соответствие Цикл
		Если ТипЗнч(Значение) = Тип("РасписаниеРегламентногоЗадания") Тогда
			Если ОбщегоНазначенияКлиентСервер.РасписанияОдинаковые(КлючИЗначение.Значение, Значение) Тогда
		    	Возврат КлючИЗначение.Ключ;
			КонецЕсли;
		Иначе
			Если КлючИЗначение.Значение = Значение Тогда
				Возврат КлючИЗначение.Ключ;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	Возврат Результат;	
КонецФункции

&НаКлиенте
Функция ПолучитьПредопределенныеСпособыОповещения()
	Результат = Новый Соответствие;
	Результат.Вставить(НСтр("ru = 'относительно предмета'"), ПредопределенноеЗначение("Перечисление.СпособыУстановкиВремениНапоминания.ОтносительноВремениПредмета"));
	Результат.Вставить(НСтр("ru = 'в указанное время'"), ПредопределенноеЗначение("Перечисление.СпособыУстановкиВремениНапоминания.ВУказанноеВремя"));
	Результат.Вставить(НСтр("ru = 'периодически'"), ПредопределенноеЗначение("Перечисление.СпособыУстановкиВремениНапоминания.Периодически"));
	Возврат Результат;
КонецФункции

&НаКлиенте
Процедура ЗаполнитьСпособыОповещения()
	СпособыОповещения = Элементы.СпособУстановкиВремениНапоминания.СписокВыбора;
	СпособыОповещения.Очистить();
	Для Каждого Способ Из ПолучитьПредопределенныеСпособыОповещения() Цикл
		СпособыОповещения.Добавить(Способ.Ключ);
	КонецЦикла;	
	
	Элементы.ИнтервалВремениОтносительноИсточника.СписокВыбора.Очистить();
	ИнтервалыВремени = НастройкиПодсистемы.СтандартныеИнтервалы;
	Для Каждого Интервал Из ИнтервалыВремени Цикл
		СпособыОповещения.Добавить(НСтр("ru = 'через'") + " " + Интервал);
		Элементы.ИнтервалВремениОтносительноИсточника.СписокВыбора.Добавить(Интервал);
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСписокВремени()
	Элементы.Время.СписокВыбора.Очистить();
	Для Час = 0 По 23 Цикл 
		Для Период = 0 По 1 Цикл
			Время = Час*60*60 + Период*30*60;
			Элементы.Время.СписокВыбора.Добавить(НачалоДня(Объект.ВремяСобытия) + Время, "" + Час + ":" + Формат(Период*30,"ЧЦ=2; ЧН=00"));		
		КонецЦикла;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокРеквизитовИсточника()
	
	РеквизитыСДатами = Новый Массив;
	
	// заполняем по умолчанию
	МетаданныеИсточника = Объект.Источник.Метаданные();	
	Для Каждого Реквизит Из МетаданныеИсточника.Реквизиты Цикл
		Если Не СтрНачинаетсяС(НРег(Реквизит.Имя), НРег("Удалить"))
			И РеквизитИсточникаСуществуетИСодержитТипДата(МетаданныеИсточника, Реквизит.Имя) Тогда
			РеквизитыСДатами.Добавить(Реквизит.Имя);
		КонецЕсли;
	КонецЦикла;
	
	// Получаем переопределенный массив реквизитов.
	ИнтеграцияПодсистемБСП.ПриЗаполненииСпискаРеквизитовИсточникаСДатамиДляНапоминания(Объект.Источник, РеквизитыСДатами);
	НапоминанияПользователяПереопределяемый.ПриЗаполненииСпискаРеквизитовИсточникаСДатамиДляНапоминания(Объект.Источник, РеквизитыСДатами);
	
	// Поддержка обратной совместимости.
	НапоминанияПользователяКлиентСерверПереопределяемый.ПриЗаполненииСпискаРеквизитовИсточникаСДатамиДляНапоминания(Объект.Источник, РеквизитыСДатами);
	
	Элементы.ИмяРеквизитаИсточника.СписокВыбора.Очистить();
	ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.Источник, СтрСоединить(РеквизитыСДатами, ","));
	
	Для Каждого ИмяРеквизита Из РеквизитыСДатами Цикл
		Если РеквизитИсточникаСуществуетИСодержитТипДата(МетаданныеИсточника, ИмяРеквизита) Тогда
			Если ТипЗнч(Объект.Источник[ИмяРеквизита]) = Тип("Дата") Тогда
				Реквизит = МетаданныеИсточника.Реквизиты.Найти(ИмяРеквизита);
				ПредставлениеРеквизита = Реквизит.Представление();
				ДатаВРеквизите = ЗначенияРеквизитов[Реквизит.Имя];
				БлижайшаяДата = ВычислитьБлижайшуюДату(ДатаВРеквизите);
				Если ЗначениеЗаполнено(БлижайшаяДата) И ДатаВРеквизите < ТекущаяДатаСеанса() Тогда
					ПредставлениеРеквизита = ПредставлениеРеквизита + " (" + Формат(БлижайшаяДата, "ДЛФ=D") + ")";
				КонецЕсли;
				Если Элементы.ИмяРеквизитаИсточника.СписокВыбора.НайтиПоЗначению(ИмяРеквизита) = Неопределено Тогда
					Элементы.ИмяРеквизитаИсточника.СписокВыбора.Добавить(ИмяРеквизита, ПредставлениеРеквизита);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьВариантыПериодичности()
	Элементы.ВариантПериодичности.СписокВыбора.Очистить();
	СписокРасписаний = НастройкиПодсистемы.Расписания;
	Для Каждого СтандартноеРасписание Из СписокРасписаний Цикл
		Элементы.ВариантПериодичности.СписокВыбора.Добавить(СтандартноеРасписание.Ключ, СтандартноеРасписание.Ключ);
	КонецЦикла;
	Элементы.ВариантПериодичности.СписокВыбора.СортироватьПоПредставлению();
	Элементы.ВариантПериодичности.СписокВыбора.Добавить("", НСтр("ru = 'по заданному расписанию...'"));	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВидимость()
	
	ПредопределенныеСпособыОповещения = ПолучитьПредопределенныеСпособыОповещения();
	ВыбранныйСпособ = ПредопределенныеСпособыОповещения.Получить(СпособУстановкиВремениНапоминания);
	
	Если ВыбранныйСпособ <> Неопределено Тогда
		Если ВыбранныйСпособ = ПредопределенноеЗначение("Перечисление.СпособыУстановкиВремениНапоминания.ВУказанноеВремя") Тогда
			Элементы.ПанельДетальныхНастроек.ТекущаяСтраница = Элементы.ДатаВремя;
		ИначеЕсли ВыбранныйСпособ = ПредопределенноеЗначение("Перечисление.СпособыУстановкиВремениНапоминания.ОтносительноВремениПредмета") Тогда
			Элементы.ПанельДетальныхНастроек.ТекущаяСтраница = Элементы.НастройкаИсточника;
		ИначеЕсли ВыбранныйСпособ = ПредопределенноеЗначение("Перечисление.СпособыУстановкиВремениНапоминания.Периодически") Тогда
			Элементы.ПанельДетальныхНастроек.ТекущаяСтраница = Элементы.НастройкаПериодичности;
		КонецЕсли;			
	Иначе
		Элементы.ПанельДетальныхНастроек.ТекущаяСтраница = Элементы.БезДетализации;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьДиалогНастройкиРасписания()
	Если Расписание = Неопределено Тогда 
		Расписание = Новый РасписаниеРегламентногоЗадания;
		Расписание.ПериодПовтораДней = 1;
	КонецЕсли;
	ДиалогРасписания = Новый ДиалогРасписанияРегламентногоЗадания(Расписание);
	ОписаниеОповещения = Новый ОписаниеОповещения("ОткрытьДиалогНастройкиРасписанияЗавершение", ЭтотОбъект);
	ДиалогРасписания.Показать(ОписаниеОповещения);
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьДиалогНастройкиРасписанияЗавершение(ВыбранноеРасписание, ДополнительныеПараметры) Экспорт
	Если ВыбранноеРасписание = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Расписание = ВыбранноеРасписание;
	Если Не РасписаниеСоответствуетТребованиям(Расписание) Тогда 
		ПоказатьПредупреждение(, НСтр("ru = 'Периодичность в течение дня не поддерживается, соответствующие настройки очищены.'"));
	КонецЕсли;
	НормализоватьРасписание(Расписание);
	ОпределитьВыбранныйВариантПериодичности();
КонецПроцедуры

&НаКлиенте
Функция РасписаниеСоответствуетТребованиям(ПроверяемоеРасписание)
	Если ПроверяемоеРасписание.ПериодПовтораВТечениеДня > 0 Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Для Каждого РасписаниеДня Из ПроверяемоеРасписание.ДетальныеРасписанияДня Цикл
		Если РасписаниеДня.ПериодПовтораВТечениеДня > 0 Тогда
			Возврат Ложь;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Истина;
КонецФункции

&НаКлиенте
Процедура НормализоватьРасписание(НормализуемоеРасписание);
	НормализуемоеРасписание.ВремяКонца = '000101010000';
	НормализуемоеРасписание.ПериодПовтораВТечениеДня = 0;
	НормализуемоеРасписание.ПаузаПовтора = 0;
	НормализуемоеРасписание.ИнтервалЗавершения = 0;
	Для Каждого РасписаниеДня Из НормализуемоеРасписание.ДетальныеРасписанияДня Цикл
		РасписаниеДня.ВремяКонца = '000101010000';
		РасписаниеДня.ВремяЗавершения =  РасписаниеДня.ВремяКонца;
		РасписаниеДня.ПериодПовтораВТечениеДня = 0;
		РасписаниеДня.ПаузаПовтора = 0;
		РасписаниеДня.ИнтервалЗавершения = 0;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ОпределитьВыбранныйВариантПериодичности()
	СтандартныеРасписания = НастройкиПодсистемы.Расписания;
	
	Если Расписание = Неопределено Тогда
		ВариантПериодичности = Элементы.ВариантПериодичности.СписокВыбора.Получить(0).Значение;
		Расписание = СтандартныеРасписания[ВариантПериодичности];
	Иначе
		ВариантПериодичности = ПолучитьКлючПоЗначениюВСоответствии(СтандартныеРасписания, Расписание);
	КонецЕсли;
	
	Элементы.ВариантПериодичности.КнопкаОткрытия = ПустаяСтрока(ВариантПериодичности);
	Элементы.ВариантПериодичности.Подсказка = Расписание;
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииРасписания()
	ПользовательскаяНастройка = ПустаяСтрока(ВариантПериодичности);
	Если ПользовательскаяНастройка Тогда
		ОткрытьДиалогНастройкиРасписания();
	Иначе
		СтандартныеРасписания = НастройкиПодсистемы.Расписания;
		Расписание = СтандартныеРасписания[ВариантПериодичности];
	КонецЕсли;
	ОпределитьВыбранныйВариантПериодичности();
КонецПроцедуры

&НаСервере
Функция ВычислитьБлижайшуюДату(ИсходнаяДата)
	ТекущаяДата = ТекущаяДатаСеанса();
	Если Не ЗначениеЗаполнено(ИсходнаяДата) Или ИсходнаяДата > ТекущаяДата Тогда
		Возврат ИсходнаяДата;
	КонецЕсли;
	
	Результат = ДобавитьМесяц(ИсходнаяДата, 12 * (Год(ТекущаяДата) - Год(ИсходнаяДата)));
	Если Результат < ТекущаяДата Тогда
		Результат = ДобавитьМесяц(Результат, 12);
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

&НаКлиенте
Функция РасчетноеВремяСтрокой()
	
	ТекущаяДата = ОбщегоНазначенияКлиент.ДатаСеанса();
	РасчетноеВремяНапоминания = ТекущаяДата + Объект.ИнтервалВремениНапоминания;
	
	ВыводитьДату = День(РасчетноеВремяНапоминания) <> День(ТекущаяДата);
	
	ДатаСтрокой = Формат(РасчетноеВремяНапоминания,"ДЛФ=DD");
	ВремяСтрокой = Формат(РасчетноеВремяНапоминания,"ДФ=H:mm");
	
	Возврат "(" + ?(ВыводитьДату, ДатаСтрокой + " ", "") +  ВремяСтрокой + ")";
	
КонецФункции

&НаКлиенте
Процедура ОбновитьРасчетноеВремяНапоминания()
	Элементы.РасчетноеВремяНапоминания.Заголовок = РасчетноеВремяСтрокой();
КонецПроцедуры

#КонецОбласти
