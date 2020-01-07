﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Создает структуру отбора, для дальнейшей передачи на сервер,
// и использования в качестве параметров отбора динамических списков вызываемых форм.
//
Функция СоздатьСтруктуруПараметраОтбора(ТипОтбора,ЛевоеЗначение,ВидСравнения,ПравоеЗначение) Экспорт

	СтруктураВозврата = Новый Структура;
	СтруктураВозврата.Вставить("ТипОтбора",ТипОтбора);
	СтруктураВозврата.Вставить("ЛевоеЗначение",ЛевоеЗначение);
	СтруктураВозврата.Вставить("ВидСравнения",ВидСравнения);
	СтруктураВозврата.Вставить("ПравоеЗначение",ПравоеЗначение);
	
	Возврат СтруктураВозврата;

КонецФункции

// Начинает процесс интервью с выбранным респондентом.
//
// Параметры:
//  Респондент   - ОпределяемыйТип.Респондент - респондент, с которым проводится интервью.
//  ШаблонАнкеты - СправочникСсылка.ШаблоныАнкет - шаблон, по которому проводится интервью.
//               - Неопределено - пользователь выбирает шаблон из справочника.
//
Процедура НачатьИнтервью(Респондент, ШаблонАнкеты=Неопределено) Экспорт
	
	Если ШаблонАнкеты=Неопределено Тогда
	
		ОписаниеОповещения = Новый ОписаниеОповещения("НачатьИнтервьюСВыборомШаблонаЗавершение", ЭтотОбъект, Респондент);
		
		ПоказатьВводЗначения(ОписаниеОповещения, Неопределено, , Тип("СправочникСсылка.ШаблоныАнкет"));
		
	Иначе
		
		ОткрытьФормуИнтервью(Респондент, ШаблонАнкеты);
		
	КонецЕсли;
		
КонецПроцедуры

// Открывает форму новой анкеты в режиме интервью с выбранным респондентом и шаблоном анкеты.
//
Процедура ОткрытьФормуИнтервью(Респондент, ШаблонАнкеты)
	
	ЗначенияЗаполнения = Новый Структура;
	ЗначенияЗаполнения.Вставить("Респондент", Респондент);
	ЗначенияЗаполнения.Вставить("ШаблонАнкеты", ШаблонАнкеты);
	ЗначенияЗаполнения.Вставить("РежимАнкетирования", ПредопределенноеЗначение("Перечисление.РежимыАнкетирования.Интервью"));
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
	ПараметрыФормы.Вставить("ТолькоФормаЗаполнения", Истина);
	
	ФормаАнкеты = ОткрытьФорму("Документ.Анкета.ФормаОбъекта", ПараметрыФормы);
	
	Если ФормаАнкеты <> Неопределено Тогда
		ЗаполнитьЗначенияСвойств(ФормаАнкеты, ЗначенияЗаполнения);
	КонецЕсли;
	
КонецПроцедуры

// Обработчик результата работы процедуры НачатьИнтервьюСВыборомШаблона.
//
Процедура НачатьИнтервьюСВыборомШаблонаЗавершение(ВыбранныйШаблон, Респондент) Экспорт
	
	Если ВыбранныйШаблон = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОткрытьФормуИнтервью(Респондент, ВыбранныйШаблон);	
	
КонецПроцедуры

#КонецОбласти
