﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)

	Если ОбменДанными.Загрузка Тогда
		Возврат;	
	КонецЕсли;
	
	Если ЗначениеЗаполнено(РольИсполнителя) Тогда
		
		Наименование = Строка(РольИсполнителя);
		
		Если ЗначениеЗаполнено(ОсновнойОбъектАдресации) Тогда
			Наименование = Наименование + ", " + Строка(ОсновнойОбъектАдресации);
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ДополнительныйОбъектАдресации) Тогда
			Наименование = Наименование + ", " + Строка(ДополнительныйОбъектАдресации);
		КонецЕсли;
	Иначе
		Наименование = НСтр("ru = 'Без ролевой адресации'");
	КонецЕсли;
	
	// Проверка дубля.
	Запрос = Новый Запрос(
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ГруппыИсполнителейЗадач.Ссылка
		|ИЗ
		|	Справочник.ГруппыИсполнителейЗадач КАК ГруппыИсполнителейЗадач
		|ГДЕ
		|	ГруппыИсполнителейЗадач.РольИсполнителя = &РольИсполнителя
		|	И ГруппыИсполнителейЗадач.ОсновнойОбъектАдресации = &ОсновнойОбъектАдресации
		|	И ГруппыИсполнителейЗадач.ДополнительныйОбъектАдресации = &ДополнительныйОбъектАдресации
		|	И ГруппыИсполнителейЗадач.Ссылка <> &Ссылка");
	Запрос.УстановитьПараметр("РольИсполнителя", РольИсполнителя);
	Запрос.УстановитьПараметр("ОсновнойОбъектАдресации", ОсновнойОбъектАдресации);
	Запрос.УстановитьПараметр("ДополнительныйОбъектАдресации", ДополнительныйОбъектАдресации);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Если НЕ Запрос.Выполнить().Пустой() Тогда
		ВызватьИсключение(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Уже есть группа исполнителей задач, для которой заданы:
			           |роль исполнителя ""%1"",
			           |основной объект адресации ""%2""
			           |и дополнительный объект адресации ""%3""'"),
			Строка(РольИсполнителя),
			Строка(ОсновнойОбъектАдресации),
			Строка(ДополнительныйОбъектАдресации)));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли