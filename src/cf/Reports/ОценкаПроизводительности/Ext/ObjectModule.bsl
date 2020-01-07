﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	ПериодНастройка = КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("Период");
	ПериодНастройкаПользовательская = КомпоновщикНастроек.ПользовательскиеНастройки.Элементы.Найти(ПериодНастройка.ИдентификаторПользовательскойНастройки);
	
	ПараметрДанных = КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("НачалоПериода");
	ПараметрДанных.Значение = УниверсальноеВремя(ПериодНастройкаПользовательская.Значение.ДатаНачала);
	ПараметрДанных.Использование = Истина;
	
	ПараметрДанных = КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("КонецПериода");
	ПараметрДанных.Значение = УниверсальноеВремя(ПериодНастройкаПользовательская.Значение.ДатаОкончания);
	ПараметрДанных.Использование = Истина;
	
	ПериодСравненияНастройка = КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("ПериодСравнения");
	ПериодСравненияНастройкаПользовательская = КомпоновщикНастроек.ПользовательскиеНастройки.Элементы.Найти(ПериодСравненияНастройка.ИдентификаторПользовательскойНастройки);
	
	Если ПериодСравненияНастройкаПользовательская <> Неопределено
		И ПериодСравненияНастройкаПользовательская.Использование Тогда
	
		ПараметрДанных = КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("НачалоПериодаСравненияЧисло");
		ПараметрДанных.Значение = (УниверсальноеВремя(ПериодСравненияНастройкаПользовательская.Значение.ДатаНачала) - Дата(1,1,1)) * 1000;
		ПараметрДанных.Использование = Истина;
		
		ПараметрДанных = КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("КонецПериодаСравненияЧисло");
		ПараметрДанных.Значение = (УниверсальноеВремя(ПериодСравненияНастройкаПользовательская.Значение.ДатаОкончания) - Дата(1,1,1)) * 1000;
		ПараметрДанных.Использование = Истина;
		
		
		ПараметрДанных = КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("ВидСравнения");
		ПараметрДанныхВидСравнения = КомпоновщикНастроек.ПользовательскиеНастройки.Элементы.Найти(ПараметрДанных.ИдентификаторПользовательскойНастройки);
		Если ПараметрДанныхВидСравнения.Значение = "ЛевоеСоединение" Тогда
			ТекстЗапроса = СхемаКомпоновкиДанных.НаборыДанных.НаборДанныхЗамеры.Запрос;
			СхемаКомпоновкиДанных.НаборыДанных.НаборДанныхЗамеры.Запрос = СтрЗаменить(ТекстЗапроса, "{ЛЕВОЕ СОЕДИНЕНИЕ}", "ЛЕВОЕ СОЕДИНЕНИЕ");
		ИначеЕсли ПараметрДанныхВидСравнения.Значение = "ВнутреннееСоединение" Тогда
			ТекстЗапроса = СхемаКомпоновкиДанных.НаборыДанных.НаборДанныхЗамеры.Запрос;
			СхемаКомпоновкиДанных.НаборыДанных.НаборДанныхЗамеры.Запрос = СтрЗаменить(ТекстЗапроса, "{ЛЕВОЕ СОЕДИНЕНИЕ}", "ВНУТРЕННЕЕ СОЕДИНЕНИЕ");
		ИначеЕсли ПараметрДанныхВидСравнения.Значение = "ПолноеСоединение" Тогда
			ТекстЗапроса = СхемаКомпоновкиДанных.НаборыДанных.НаборДанныхЗамеры.Запрос;
			СхемаКомпоновкиДанных.НаборыДанных.НаборДанныхЗамеры.Запрос = СтрЗаменить(ТекстЗапроса, "{ЛЕВОЕ СОЕДИНЕНИЕ}", "ПОЛНОЕ СОЕДИНЕНИЕ");
		КонецЕсли;
	Иначе
		
		Если ПериодСравненияНастройкаПользовательская = Неопределено Тогда
			ПериодСравненияНастройка.Использование = Ложь;
			ПараметрДанныхВидСравнения = КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("ВидСравнения");
			ПараметрДанныхВидСравнения.Использование = Ложь;
		КонецЕсли;
		
		ПараметрДанных = КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("НачалоПериодаСравненияЧисло");
        ПараметрДанных.Значение = 2;
        ПараметрДанных.Использование = Истина;
        
        ПараметрДанных = КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("КонецПериодаСравненияЧисло");
        ПараметрДанных.Значение = 1;
        ПараметрДанных.Использование = Истина;
        
		ТекстЗапроса = СхемаКомпоновкиДанных.НаборыДанных.НаборДанныхЗамеры.Запрос;
		СхемаКомпоновкиДанных.НаборыДанных.НаборДанныхЗамеры.Запрос = СтрЗаменить(ТекстЗапроса, "{ЛЕВОЕ СОЕДИНЕНИЕ}", "ЛЕВОЕ СОЕДИНЕНИЕ");
	КонецЕсли;

	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли