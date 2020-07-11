﻿Функция ПолучитьМассивЗначенийКонстанты(ИмяКонстанты,ТипКонстанты,РеквизитТЧЗначения = "ЛевоеЗначение",Отказ = Ложь, ВыдаватьСообщенияОбОшибках = Истина) Экспорт 
	МассивЗначенийКонстанты = Неопределено;
	
	пКонстанта = ПредопределенноеЗначение("Справочник.узКонстанты."+ИмяКонстанты);
	
	Если ТипЗнч(ТипКонстанты) = Тип("Строка") Тогда
		ТипКонстанты = Тип(ТипКонстанты);
	Конецесли;	
	
	пТЧЗначения = пКонстанта.ТЧЗначения;
	Если пТЧЗначения.Количество() = 0 Тогда
		Если ВыдаватьСообщенияОбОшибках Тогда
			Сообщить("Ошибка! Не заполнена ТЧЗначения """+ИмяКонстанты+""", в константах");
		КонецЕсли;
		Отказ = Истина;			
		Возврат МассивЗначенийКонстанты;	
	Иначе
		МассивЗначенийКонстанты = Новый Массив(); 
	Конецесли;
	
	МассивОшибок = Новый Массив();
	
	Для каждого СтрокаТЧЗначения из пТЧЗначения цикл
		мЗначениеКонстанты = СтрокаТЧЗначения[РеквизитТЧЗначения];		
		Если мЗначениеКонстанты = Неопределено 
			ИЛИ НЕ ЗначениеЗаполнено(мЗначениеКонстанты) Тогда
			МассивОшибок.Добавить("Ошибка! не заполнен элемент в ТЧЗначения """+ИмяКонстанты+""", в константах");
			Отказ = Истина;
			Продолжить;
		Конецесли;
		Если ТипЗнч(мЗначениеКонстанты) <> ТипКонстанты Тогда
			МассивОшибок.Добавить("Ошибка! указан неверный тип для элемента """+ИмяКонстанты+""", в константах"
				+" должен быть тип ["+ТипКонстанты+"]");
			Отказ = Истина;
			Продолжить;			
		Конецесли;
		МассивЗначенийКонстанты.Добавить(мЗначениеКонстанты);
	Конеццикла;
	
	Если НЕ ЗначениеЗаполнено(МассивЗначенийКонстанты) Тогда
		МассивОшибок.Добавить("Ошибка! Не заполнена ТЧЗначения """+ИмяКонстанты+""", в константах");
		Отказ = Истина;		
	Конецесли;
	
	Если ВыдаватьСообщенияОбОшибках Тогда
		Для каждого ЭлМассиваОшибок из МассивОшибок цикл
			Сообщить(ЭлМассиваОшибок);
		Конеццикла;	
	Конецесли;
	
	Возврат МассивЗначенийКонстанты;
КонецФункции 

Функция ПолучитьЗначениеКонстанты(ИмяКонстанты,ТипКонстанты,Отказ = Ложь,ВыдаватьСообщенияОбОшибках = Истина, ВыдаватьИсключения = Ложь) Экспорт 
	Перем мЗначениеКонстанты;
	
	МассивОшибок = Новый Массив();
	
	пКонстанта = ПредопределенноеЗначение("Справочник.узКонстанты."+ИмяКонстанты);
	
	мЗначениеКонстанты = пКонстанта.Значение;	
	
	Если ТипЗнч(ТипКонстанты) = Тип("Строка") Тогда
		ТипКонстанты = Тип(ТипКонстанты);
	Конецесли;
	
	Если мЗначениеКонстанты = Неопределено 
		ИЛИ ТипЗнч(мЗначениеКонстанты) <> ТипКонстанты
		ИЛИ НЕ ЗначениеЗаполнено(мЗначениеКонстанты) Тогда
		
		МассивОшибок.Добавить("Ошибка! Не указано значение элемента """+ИмяКонстанты+""", в константах");
		Отказ = Истина;
	Конецесли;
	
	Если ВыдаватьСообщенияОбОшибках Тогда
		Для каждого ЭлМассиваОшибок из МассивОшибок цикл
			Сообщить(ЭлМассиваОшибок);
		Конеццикла;	
	Конецесли;
	
	Если Отказ 
		И ВыдаватьИсключения Тогда
		ВызватьИсключение "Ошибка! Не заполнена константа " + ИмяКонстанты;
	Конецесли;
	
	Возврат мЗначениеКонстанты;
КонецФункции //ПолучитьЗначениеКонстанты(ИмяКонстанты,ТипКонстанты)

Процедура УстановитьЗначениеКонстанты(ИмяКонстанты,ЗначениеКонстанты) Экспорт 
	
	пКонстанта = ПредопределенноеЗначение("Справочник.узКонстанты."+ИмяКонстанты);	
	пКонстантаОбъект = пКонстанта.ПолучитьОбъект();
	пКонстантаОбъект.Значение = ЗначениеКонстанты;
	пКонстантаОбъект.Записать();
	
КонецПроцедуры 