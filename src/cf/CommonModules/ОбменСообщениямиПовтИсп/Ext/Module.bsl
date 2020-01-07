﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Возвращает ссылку на объект WSПрокси для заданного узла обмена.
//
// Параметры:
//   КонечнаяТочка - ПланОбменаСсылка.
//
Функция WSПроксиКонечнойТочки(КонечнаяТочка, Таймаут) Экспорт
	
	СтруктураНастроек = РегистрыСведений.НастройкиТранспортаОбменаСообщениями.НастройкиТранспортаWS(КонечнаяТочка);
	
	СтрокаСообщенияОбОшибке = "";
	
	Результат = ОбменСообщениямиВнутренний.ПолучитьWSПрокси(СтруктураНастроек, СтрокаСообщенияОбОшибке, Таймаут);
	
	Если Результат = Неопределено Тогда
		ВызватьИсключение СтрокаСообщенияОбОшибке;
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

// Возвращает массив менеджеров справочников, которые могут использоваться для хранения
// сообщений.
//
Функция ПолучитьСправочникиСообщений() Экспорт
	
	МассивСправочников = Новый Массив();
	
	Если РаботаВМоделиСервисаПовтИсп.ЭтоРазделеннаяКонфигурация() Тогда
		МодульСообщенияВМоделиСервисаРазделениеДанных = ОбщегоНазначения.ОбщийМодуль("СообщенияВМоделиСервисаРазделениеДанных");
		МодульСообщенияВМоделиСервисаРазделениеДанных.ПриЗаполненииСправочниковСообщений(МассивСправочников);
	КонецЕсли;
	
	МассивСправочников.Добавить(Справочники.СообщенияСистемы);
	
	Возврат Новый ФиксированныйМассив(МассивСправочников);
	
КонецФункции

#КонецОбласти
