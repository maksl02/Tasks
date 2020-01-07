﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Заполняет шаблон из структуры параметров, поддерживает форматирование, может оставлять обрамление шаблона.
//   Ограничение: должны присутствовать и левый и правый элементы обрамления.
//
// Параметры:
//   Шаблон - Строка - Исходный шаблон. Например "Добрый день, [ФИО]".
//   Параметры - Структура - Набор параметров, которые необходимо подставить в шаблон.
//      * Ключ - Имя параметра. Например "ФИО".
//      * Значение - Строка подстановки. Например "Иванов Иван Иванович".
//
// Возвращаемое значение: 
//   Строка - Шаблон с заполненными параметрами.
//
Функция ЗаполнитьШаблон(Шаблон, Параметры) Экспорт
	Левый = "["; // Начало обрамления параметра.
	Правый = "]"; // Конец обрамления параметра.
	ФорматЛевый = "("; // Начало обрамления формата.
	ФорматПравый = ")"; // Конец обрамления формата.
	ВырезатьОбрамление = Истина; // Истина означает, что обрамление параметра будет убрано из результата.
	
	Результат = Шаблон;
	Для Каждого КлючИЗначение Из Параметры Цикл
		// Замена "[ключ]" на "значение".
		Результат = СтрЗаменить(
			Результат,
			Левый + КлючИЗначение.Ключ + Правый, 
			?(ВырезатьОбрамление, "", Левый) + КлючИЗначение.Значение + ?(ВырезатьОбрамление, "", Правый));
		ДлинаФорматЛевый = СтрДлина(Левый + КлючИЗначение.Ключ + ФорматЛевый);
		// Замена "[ключ(формат)]" на "значение в формате".
		Поз1 = СтрНайти(Результат, Левый + КлючИЗначение.Ключ + ФорматЛевый);
		Пока Поз1 > 0 Цикл
			Поз2 = СтрНайти(Результат, ФорматПравый + Правый);
			Если Поз2 = 0 Тогда
				Прервать;
			КонецЕсли;
			ФорматнаяСтрока = Сред(Результат, Поз1 + ДлинаФорматЛевый, Поз2 - Поз1 - ДлинаФорматЛевый);
			Попытка
				НаЧтоЗаменить = ?(ВырезатьОбрамление, "", Левый) + Формат(КлючИЗначение.Значение, ФорматнаяСтрока) + ?(ВырезатьОбрамление, "", Правый);
			Исключение
				НаЧтоЗаменить = ?(ВырезатьОбрамление, "", Левый) + КлючИЗначение.Значение + ?(ВырезатьОбрамление, "", Правый);
			КонецПопытки;
			Результат = СтрЗаменить(
				Результат,
				Левый + КлючИЗначение.Ключ + ФорматЛевый + ФорматнаяСтрока + ФорматПравый + Правый, 
				НаЧтоЗаменить);
			Поз1 = СтрНайти(Результат, Левый + КлючИЗначение.Ключ + ФорматЛевый);
		КонецЦикла;
	КонецЦикла;
	Возврат Результат;
КонецФункции

// Формирует представление способов доставки в соответствии с параметрами доставки.
//
// Параметры:
//   ПараметрыДоставки - Структура - См. ВыполнитьРассылку(), параметр ПараметрыДоставки.
//
// Возвращаемое значение:
//   Строка - Представление способов доставки.
//
Функция ПредставлениеСпособовДоставки(ПараметрыДоставки) Экспорт
	Префикс = НСтр("ru = 'Результат'");
	ТекстПредставления = "";
	Суффикс = "";
	
	Если Не ПараметрыДоставки.ТолькоУведомить Тогда
		
		ТекстПредставления = ТекстПредставления 
		+ ?(ТекстПредставления = "", Префикс, " " + НСтр("ru = 'и'")) 
		+ " "
		+ НСтр("ru = 'отправлен по почте (см. вложения)'");
		
	КонецЕсли;
	
	Если ПараметрыДоставки.ВыполненаВПапку Тогда
		
		ТекстПредставления = ТекстПредставления 
		+ ?(ТекстПредставления = "", Префикс, " " + НСтр("ru = 'и'")) 
		+ " "
		+ НСтр("ru = 'доставлен в папку'")
		+ " ";
		
		Ссылка = ПолучитьНавигационнуюСсылкуИнформационнойБазы() +"#"+ ПолучитьНавигационнуюСсылку(ПараметрыДоставки.Папка);
		
		Если ПараметрыДоставки.ПисьмоВФорматеHTML Тогда
			ТекстПредставления = ТекстПредставления 
			+ "<a href = '"
			+ Ссылка
			+ "'>" 
			+ Строка(ПараметрыДоставки.Папка)
			+ "</a>";
		Иначе
			ТекстПредставления = ТекстПредставления 
			+ """"
			+ Строка(ПараметрыДоставки.Папка)
			+ """";
			Суффикс = Суффикс + ":" + Символы.ПС + "<" + Ссылка + ">";
		КонецЕсли;
		
	КонецЕсли;
	
	Если ПараметрыДоставки.ВыполненаВСетевойКаталог Тогда
		
		ТекстПредставления = ТекстПредставления 
		+ ?(ТекстПредставления = "", Префикс, " " + НСтр("ru = 'и'")) 
		+ " "
		+ НСтр("ru = 'доставлен в сетевой каталог'")
		+ " ";
		
		Если ПараметрыДоставки.ПисьмоВФорматеHTML Тогда
			ТекстПредставления = ТекстПредставления 
			+ "<a href = '"
			+ ПараметрыДоставки.СетевойКаталогWindows
			+ "'>" 
			+ ПараметрыДоставки.СетевойКаталогWindows
			+ "</a>";
		Иначе
			ТекстПредставления = ТекстПредставления 
			+ "<"
			+ ПараметрыДоставки.СетевойКаталогWindows
			+ ">";
		КонецЕсли;
		
	КонецЕсли;
	
	Если ПараметрыДоставки.ВыполненаНаFTP Тогда
		
		ТекстПредставления = ТекстПредставления 
		+ ?(ТекстПредставления = "", Префикс, " " + НСтр("ru = 'и'")) 
		+ " "
		+ НСтр("ru = 'доставлен на FTP ресурс'")
		+ " ";
		
		Ссылка = "ftp://"
		+ ПараметрыДоставки.Сервер 
		+ ":"
		+ Формат(ПараметрыДоставки.Порт, "ЧН=0; ЧГ=0") 
		+ ПараметрыДоставки.Каталог;
		
		Если ПараметрыДоставки.ПисьмоВФорматеHTML Тогда
			ТекстПредставления = ТекстПредставления 
			+ "<a href = '"
			+ Ссылка
			+ "'>" 
			+ Ссылка
			+ "</a>";
		Иначе
			ТекстПредставления = ТекстПредставления 
			+ "<"
			+ Ссылка
			+ ">";
		КонецЕсли;
		
	КонецЕсли;
	
	ТекстПредставления = ТекстПредставления + ?(Суффикс = "", ".", Суффикс);
	
	Возврат ТекстПредставления;
КонецФункции

Функция ПредставлениеСписка(Коллекция, ИмяКолонки = "", МаксимумСимволов = 60) Экспорт
	Результат = Новый Структура;
	Результат.Вставить("Всего", 0);
	Результат.Вставить("ДлинаПолного", 0);
	Результат.Вставить("ДлинаКраткого", 0);
	Результат.Вставить("Краткое", "");
	Результат.Вставить("Полное", "");
	Результат.Вставить("МаксимумПревышен", Ложь);
	Для Каждого Объект Из Коллекция Цикл
		ПредставлениеЗначения = Строка(?(ИмяКолонки = "", Объект, Объект[ИмяКолонки]));
		Если ПустаяСтрока(ПредставлениеЗначения) Тогда
			Продолжить;
		КонецЕсли;
		Если Результат.Всего = 0 Тогда
			Результат.Всего        = 1;
			Результат.Полное       = ПредставлениеЗначения;
			Результат.ДлинаПолного = СтрДлина(ПредставлениеЗначения);
		Иначе
			Полное       = Результат.Полное + ", " + ПредставлениеЗначения;
			ДлинаПолного = Результат.ДлинаПолного + 2 + СтрДлина(ПредставлениеЗначения);
			Если Не Результат.МаксимумПревышен И ДлинаПолного > МаксимумСимволов Тогда
				Результат.Краткое          = Результат.Полное;
				Результат.ДлинаКраткого    = Результат.ДлинаПолного;
				Результат.МаксимумПревышен = Истина;
			КонецЕсли;
			Результат.Всего        = Результат.Всего + 1;
			Результат.Полное       = Полное;
			Результат.ДлинаПолного = ДлинаПолного;
		КонецЕсли;
	КонецЦикла;
	Если Результат.Всего > 0 И Не Результат.МаксимумПревышен Тогда
		Результат.Краткое       = Результат.Полное;
		Результат.ДлинаКраткого = Результат.ДлинаПолного;
		Результат.МаксимумПревышен = Результат.ДлинаПолного > МаксимумСимволов;
	КонецЕсли;
	Возврат Результат;
КонецФункции

#КонецОбласти
