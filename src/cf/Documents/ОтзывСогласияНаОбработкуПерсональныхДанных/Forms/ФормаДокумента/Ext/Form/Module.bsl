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
	
	Если Параметры.Ключ.Пустая() Тогда
		// Заполняем значениями по умолчанию.
		Объект.Ответственный = Пользователи.ТекущийПользователь();
		Если Не Параметры.Свойство("ДатаСогласия", Объект.ДатаОтзыва) Тогда
			Объект.ДатаОтзыва = ТекущаяДатаСеанса();
		КонецЕсли;
		Если Не ЗначениеЗаполнено(Объект.Организация) Тогда
			Если Параметры.Свойство("Организация") Тогда
				Объект.Организация = Параметры.Организация;
			Иначе
				Если Не Метаданные.ОпределяемыеТипы.Организация.Тип.СодержитТип(Тип("Строка")) Тогда
					ПолноеИмя = Метаданные.НайтиПоТипу(Метаданные.ОпределяемыеТипы.Организация.Тип.Типы()[0]).ПолноеИмя();
					ИмяСправочникаОрганизации = "Справочники." + СтрРазделить(ПолноеИмя, ".")[1];
					МодульОрганизации = ОбщегоНазначения.ОбщийМодуль(ИмяСправочникаОрганизации);
					Объект.Организация = МодульОрганизации.ОрганизацияПоУмолчанию();
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		ЗаполнитьДанныеОрганизации();
		Если Параметры.Свойство("Субъект") Тогда
			Объект.Субъект = Параметры.Субъект;
		КонецЕсли;
		УстановитьСведенияДействующегоСогласия();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	УстановитьСведенияДействующегоСогласия();
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ДатыЗапретаИзменения") Тогда
		МодульДатыЗапретаИзменения = ОбщегоНазначения.ОбщийМодуль("ДатыЗапретаИзменения");
		МодульДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("ИзмененаДатаСкрытияПерсональныхДанных");
	
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
Процедура ОрганизацияПриИзменении(Элемент)
	
	ОрганизацияПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтветственныйЗаОбработкуПерсональныхДанныхПриИзменении(Элемент)
	
	ОтветственныйЗаПДнПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура СубъектПриИзменении(Элемент)
	
	СубъектПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаОтзываПриИзменении(Элемент)
	
	ДатаОтзываПриИзмененииНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	
	ЗаполнитьДанныеОрганизации();
	УстановитьСведенияДействующегоСогласия();
	
КонецПроцедуры

&НаСервере
Процедура ОтветственныйЗаПДнПриИзмененииНаСервере()
	
	Объект.ФИООтветственногоЗаОбработкуПДн = Неопределено;
	
	Если Не ЗначениеЗаполнено(Объект.ОтветственныйЗаОбработкуПерсональныхДанных) Тогда
		Возврат;
	КонецЕсли;
	
	ОтветственныйФизическоеЛицо = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.ОтветственныйЗаОбработкуПерсональныхДанных, "ФизическоеЛицо");
	ЗащитаПерсональныхДанныхПереопределяемый.ЗаполнитьФИОФизическогоЛица(ОтветственныйФизическоеЛицо, Объект.ФИООтветственногоЗаОбработкуПДн);
	
КонецПроцедуры

&НаСервере
Процедура СубъектПриИзмененииНаСервере()
	
	УстановитьСведенияДействующегоСогласия();
	
КонецПроцедуры

&НаСервере
Процедура ДатаОтзываПриИзмененииНаСервере()
	
	УстановитьСведенияДействующегоСогласия();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДанныеОрганизации()
	
	ДанныеОрганизации = ЗащитаПерсональныхДанных.ОписаниеДанныхОрганизации();
	
	ЗащитаПерсональныхДанныхПереопределяемый.ДополнитьДанныеОрганизацииОператораПерсональныхДанных(Объект.Организация, ДанныеОрганизации, Объект.ДатаОтзыва);
	
	Объект.ЮридическийАдресОрганизации = ДанныеОрганизации.АдресОрганизации;
	Объект.ОтветственныйЗаОбработкуПерсональныхДанных = ДанныеОрганизации.ОтветственныйЗаОбработкуПерсональныхДанных;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьСведенияДействующегоСогласия()
	
	Если ЗначениеЗаполнено(Объект.Субъект) И Объект.Субъект.ЭтоГруппа Тогда
		ВызватьИсключение НСтр("ru = 'Для отзыва согласия на обработку персональных данных необходимо выбрать элемент, а не группу.'");
	КонецЕсли;
	
	// Если не заполнена организация или субъект, не отображаем вообще никаких сведений.
	Если Не ЗначениеЗаполнено(Объект.Организация) Или Не ЗначениеЗаполнено(Объект.Субъект) Тогда
		Элементы.СведенияОСогласииГруппа.Видимость = Ложь;
		Возврат;
	КонецЕсли;
	
	Элементы.СведенияОСогласииГруппа.Видимость = Истина;
	
	// Запрашиваем сведения о действующем согласии.
	Согласие = ЗащитаПерсональныхДанных.ДействующееСогласиеНаОбработкуПерсональныхДанных(Объект.Субъект, Объект.Организация, Объект.ДатаОтзыва, Объект.Ссылка);
	
	Если Согласие = Неопределено Тогда
		// Не обнаружено действующего согласия.
		Элементы.СведенияКартинка.Картинка = БиблиотекаКартинок.Предупреждение32;
		Элементы.СведенияТекст.Заголовок = НСтр("ru = 'Не обнаружено действующего согласия на обработку персональных данных субъекта.'");
		Возврат;
	КонецЕсли;
	
	// Обнаружено действующее согласие - готовим форматированную строку.
	
	// Пример сообщения: "У субъекта 20.03.2014 было получено согласие, которое действует до 20.03.2017".
	Если ЗначениеЗаполнено(Согласие.СрокДействия) Тогда
		СведенияТекст = СтроковыеФункции.ФорматированнаяСтрока(
			НСтр("ru = 'У субъекта %1 было получено <a href=""%2"">согласие</a>, которое действует до %3.'"),
			Формат(Согласие.ДатаПолучения, "ДЛФ=D"), ПолучитьНавигационнуюСсылку(Согласие.ДокументОснование), Формат(Согласие.СрокДействия, "ДЛФ=D"));
	Иначе	
		СведенияТекст = СтроковыеФункции.ФорматированнаяСтрока(
			НСтр("ru = 'У субъекта %1 было получено <a href=""%2"">согласие</a>, которое действует бессрочно.'"),
			Формат(Согласие.ДатаПолучения, "ДЛФ=D"), ПолучитьНавигационнуюСсылку(Согласие.ДокументОснование));
	КонецЕсли;
	Элементы.СведенияТекст.Заголовок = СведенияТекст;
	
КонецПроцедуры

#КонецОбласти
