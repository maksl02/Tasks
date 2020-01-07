﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

Функция ПриОпределенииНастроек() Экспорт
	
	Настройки = Новый Структура("ПредметыШаблонов, ОбщиеРеквизиты");
	Настройки.Вставить("ИспользоватьПроизвольныеПараметры", Ложь);
	Настройки.Вставить("ЗначенияПараметровСКД", Новый Структура);
	Настройки.Вставить("ФорматПисьма", "");
	Настройки.Вставить("РасширенныйСписокПолучателей", Ложь);
	Настройки.Вставить("ВсегдаПоказыватьФормуВыбораШаблонов", Истина);
	
	ОбщиеРеквизитыДерево = ШаблоныСообщенийСлужебный.ОпределитьОбщиеРеквизиты();
	Настройки.ОбщиеРеквизиты = ШаблоныСообщенийСлужебный.ОбщиеРеквизиты(ОбщиеРеквизитыДерево);
	Настройки.ПредметыШаблонов = ШаблоныСообщенийСлужебный.ОпределитьПредметыШаблонов();
	
	ШаблоныСообщенийПереопределяемый.ПриОпределенииНастроек(Настройки);
	Настройки.ОбщиеРеквизиты = ОбщиеРеквизитыДерево;
	
	Для каждого ПредметШаблона Из Настройки.ПредметыШаблонов Цикл
		Для каждого ПараметрСКД Из Настройки.ЗначенияПараметровСКД Цикл
			Если НЕ ПредметШаблона.ЗначенияПараметровСКД.Свойство(ПараметрСКД.Ключ)
				ИЛИ ПредметШаблона.ЗначенияПараметровСКД[ПараметрСКД.Ключ] = Null Тогда
					ПредметШаблона.ЗначенияПараметровСКД.Вставить(ПараметрСКД.Ключ, Настройки.ЗначенияПараметровСКД[ПараметрСКД.Ключ]);
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	Настройки.ПредметыШаблонов.Сортировать("Представление");
	
	Результат = Новый ФиксированнаяСтруктура(Настройки);
	Возврат Результат;
	
КонецФункции

#КонецОбласти
