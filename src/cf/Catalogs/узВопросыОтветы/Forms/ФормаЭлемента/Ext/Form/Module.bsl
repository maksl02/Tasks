﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
//{[-](фрагмент УДАЛЕН)milanse 31.05.2020 22:12:10  уставновил отбор в списке вопросов в задаче, реквизит заолняется из даных заполнения - этот фрагмент избыточен
	//Если Параметры.Свойство("Задача") Тогда
	//	пОбъект = РеквизитФормыВЗначение("Объект"); 
	//	пОбъект.Заполнить(Параметры.Задача);
	//	ЗначениеВРеквизитФормы(пОбъект,"Объект");		
	//Конецесли;
	//}milanse 31.05.2020 22:12:10
	
	// +SZ #236 16.01.2021
	Если Параметры.Свойство("Задача") Тогда
	     Объект.Задача=Параметры.Задача;
	КонецЕсли;
	// -SZ #236 16.01.2021

	Если Объект.Ссылка.Пустая() Тогда
		Объект.Автор = Пользователи.ТекущийПользователь();
		Объект.ДатаСоздания = ТекущаяДатаСеанса();		
	Конецесли;
	
	УстановитьВидимостьДоступность();
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьДоступность()
	
КонецПроцедуры 

//{[-](фрагмент УДАЛЕН)milanse 31.05.2020 20:46:11
//&НаКлиенте
//Процедура ВопросПриИзменении(Элемент)
//	Объект.Наименование = Объект.Вопрос;
//КонецПроцедуры
//}milanse 31.05.2020 20:46:11
//+ #201 Иванов А.Б. 2020-05-23 Изменения от Дениса Урянского @d-hurricane
&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	//{[+](фрагмент ДОБАВЛЕН), milanse 31.05.2020 22:10:53
	УстановитьФорматированныеДокументы(ТекущийОбъект);
	//}milanse 31.05.2020 22:10:53
	
КонецПроцедуры //- #201 Иванов А.Б. 2020-05-23 Изменения от Дениса Урянского @d-hurricane

//+ #201 Иванов А.Б. 2020-05-23 Изменения от Дениса Урянского @d-hurricane
&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
КонецПроцедуры //- #201 Иванов А.Б. 2020-05-23 Изменения от Дениса Урянского @d-hurricane

//+ #206 Иванов А.Б. 2020-06-06 @milanse 
//{[+](фрагмент ДОБАВЛЕН), milanse 31.05.2020 22:17:31
&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	СохранитьФорматированныйДокумент(ТекущийОбъект);
	Если ЗначениеЗаполнено(ТекущийОбъект.Вопрос) Тогда
		ТекущийОбъект.Наименование = ТекущийОбъект.Вопрос;
	ИначеЕсли НЕ ЗначениеЗаполнено(ТекущийОбъект.Наименование) Тогда
		ТекущийОбъект.Наименование = "Вопрос "+ТекущийОбъект.Код;	
	КонецЕсли; 
КонецПроцедуры //- #206 Иванов А.Б. 2020-06-06 @milanse 

//+ #206 Иванов А.Б. 2020-06-06 @milanse 
&НаСервере
Процедура СохранитьФорматированныйДокумент(Знач ТекущийОбъект)
	
	ТекущийОбъект.ВопросХранилище = Новый ХранилищеЗначения(ФорматированныйВопрос,Новый СжатиеДанных(9));
	ТекущийОбъект.Вопрос = СтроковыеФункцииКлиентСервер.ИзвлечьТекстИзHTML(ФорматированныйВопрос.ПолучитьТекст());
	ТекущийОбъект.ОтветХранилище = Новый ХранилищеЗначения(ФорматированныйОтвет,Новый СжатиеДанных(9));
	ТекущийОбъект.Ответ = СтроковыеФункцииКлиентСервер.ИзвлечьТекстИзHTML(ФорматированныйОтвет.ПолучитьТекст());
	
КонецПроцедуры //- #206 Иванов А.Б. 2020-06-06 @milanse 

//+ #206 Иванов А.Б. 2020-06-06 @milanse 
&НаСервере
Процедура УстановитьФорматированныеДокументы(ТекущийОбъект)
	
	ВопросХранилище = ТекущийОбъект.ВопросХранилище.ПОлучить();
	Если ВопросХранилище = Неопределено Тогда
		ФорматированныйВопрос.УстановитьHTML(ТекущийОбъект.Вопрос,Новый Структура);
	Иначе
		ФорматированныйВопрос = ВопросХранилище;
	КонецЕсли;
	
	ОтветХранилище = ТекущийОбъект.ОтветХранилище.ПОлучить();
	Если ОтветХранилище = Неопределено Тогда
		ФорматированныйОтвет.УстановитьHTML(ТекущийОбъект.Ответ,Новый Структура);
	Иначе
		ФорматированныйОтвет = ОтветХранилище;
	КонецЕсли;
	
КонецПроцедуры //- #206 Иванов А.Б. 2020-06-06 @milanse 

//+ #206 Иванов А.Б. 2020-06-06 @milanse 
&НаКлиенте
Процедура УстановитьДоступностьКоманд(ИмяРеквизита)
	
	Если ИмяРеквизита = "Вопрос" Тогда
		Элементы.ВключитьРедактированиеВопрос.Пометка = НЕ Элементы.ФорматированныйВопрос.ТолькоПросмотр;
		Элементы.ВставитьЗадачуВопрос.Доступность = НЕ Элементы.ФорматированныйВопрос.ТолькоПросмотр; 
	ИначеЕсли ИмяРеквизита = "Ответ" Тогда
		Элементы.ВключитьРедактированиеОтвет.Пометка = НЕ Элементы.ФорматированныйОтвет.ТолькоПросмотр;
		Элементы.ВставитьЗадачуОтвет.Доступность = НЕ Элементы.ФорматированныйОтвет.ТолькоПросмотр;
	КонецЕсли;

КонецПроцедуры //- #206 Иванов А.Б. 2020-06-06 @milanse 

//+ #206 Иванов А.Б. 2020-06-06 @milanse 
&НаКлиенте
Процедура ВключитьРедактирование(Команда)
	Если Команда.Имя = "ВключитьРедактированиеВопрос" Тогда
		Элементы.ФорматированныйВопрос.ТолькоПросмотр = НЕ Элементы.ФорматированныйВопрос.ТолькоПросмотр;
		УстановитьДоступностьКоманд("Вопрос");
	Иначе
		Элементы.ФорматированныйОтвет.ТолькоПросмотр = НЕ Элементы.ФорматированныйОтвет.ТолькоПросмотр;
		УстановитьДоступностьКоманд("Ответ");
	КонецЕсли;
КонецПроцедуры //- #206 Иванов А.Б. 2020-06-06 @milanse 

//+ #206 Иванов А.Б. 2020-06-06 @milanse 
&НаКлиенте
Процедура ВставитьЗадачу(Команда)
	
	Если Команда.Имя = "ВставитьЗадачуВопрос" Тогда
		ПарамертыОповещения = Новый Структура("Элемент,ИмяРеквизита",Элементы.ФорматированныйВопрос,"ФорматированныйВопрос");
	Иначе
		ПарамертыОповещения = Новый Структура("Элемент,ИмяРеквизита",Элементы.ФорматированныйОтвет,"ФорматированныйОтвет");
	КонецЕсли; 
	СсылкаНаЗадачу = Неопределено;
	ПоказатьВводЗначения(Новый ОписаниеОповещения("ВыборЗадачиОкончание",ЭтотОбъект,ПарамертыОповещения),СсылкаНаЗадачу,"Выберете задачу для вставки ссылки",Тип("СправочникСсылка.узЗадачи"));
	
КонецПроцедуры //- #206 Иванов А.Б. 2020-06-06 @milanse 

//+ #206 Иванов А.Б. 2020-06-06 @milanse 
&НаКлиенте
Процедура ВыборЗадачиОкончание(Параметр,ДополнительныеПараметры) Экспорт
	
	Если Параметр <> Неопределено Тогда
		ВыделениеНачало = Неопределено;
		ВыделениеКонец = Неопределено;
		ДополнительныеПараметры.Элемент.ПолучитьГраницыВыделения(ВыделениеНачало,ВыделениеКонец);
		Если ВыделениеНачало <> Неопределено Тогда
			КодЗадачи = КодЗадачи(Параметр);
			ТекстСсылки = ЭтотОбъект[ДополнительныеПараметры.ИмяРеквизита].Вставить(ВыделениеНачало,"#"+Формат(КодЗадачи,"ЧГ=0"));
			ТекстСсылки.НавигационнаяСсылка = ПолучитьНавигационнуюСсылку(Параметр);
			Пробел = ЭтотОбъект[ДополнительныеПараметры.ИмяРеквизита].Вставить(ТекстСсылки.ЗакладкаКонца," ");
			ДополнительныеПараметры.Элемент.УстановитьГраницыВыделения(Пробел.ЗакладкаКонца,Пробел.ЗакладкаКонца);
		КонецЕсли; 
	КонецЕсли; 
	
КонецПроцедуры //- #206 Иванов А.Б. 2020-06-06 @milanse 

//+ #206 Иванов А.Б. 2020-06-06 @milanse 
&НаСервереБезКонтекста
Функция КодЗадачи(Параметр)
	
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Параметр,"Код");
	
КонецФункции //- #206 Иванов А.Б. 2020-06-06 @milanse 

//+ #206 Иванов А.Б. 2020-06-06 @milanse 
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УстановитьДоступностьКоманд("Вопрос");
	УстановитьДоступностьКоманд("Ответ");
КонецПроцедуры //- #206 Иванов А.Б. 2020-06-06 @milanse 

//}milanse 31.05.2020 22:17:31

//{[+](фрагмент ДОБАВЛЕН), milanse 07.06.2020 1:03:51
&НаКлиенте
Процедура КомандаПолноэкранныйРежим(Команда)
	ПараметрыФормы = Новый Структура();
	ДопПараметры = НОвый Структура();
	Если Команда.Имя = "КомандаПолноэкранныйРежимВопрос" Тогда
		ПараметрыФормы.Вставить("ФорматированныйТекст",ФорматированныйВопрос);
		ДопПараметры.Вставить("Реквизит","ФорматированныйВопрос");
	ИначеЕсли Команда.Имя = "КомандаПолноэкранныйРежимВопрос" Тогда
		ПараметрыФормы.Вставить("ФорматированныйТекст",ФорматированныйОтвет);
		ДопПараметры.Вставить("Реквизит","ФорматированныйОтвет");
	КонецЕсли;
	
	ПараметрыФормы.Вставить("ЗаголовокФормы",Заголовок);
	ОповещенияОЗакрытии = Новый ОписаниеОповещения("ВыполнитьПослеЗакрытияПолноэкранногоРежима", ЭтотОбъект,ДопПараметры);
	
	ОткрытьФорму("Справочник.узЗадачи.Форма.ФормаПолноэкранныйРежим",
		ПараметрыФормы,,,,,
		ОповещенияОЗакрытии,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);	
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьПослеЗакрытияПолноэкранногоРежима(РезультатЗакрытия, ДопПараметры) Экспорт
	Если РезультатЗакрытия = Неопределено Тогда
		Возврат;
	Конецесли;
	
	ЭтотОбъект[ДопПараметры.Реквизит] = РезультатЗакрытия.ФорматированныйТекст;
	
	ПерезагрузимДанныеНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПерезагрузимДанныеНаСервере()
	пОбъект = РеквизитФормыВЗначение("Объект"); 
	ЗначениеВРеквизитФормы(пОбъект,"Объект");
КонецПроцедуры 
//}milanse 07.06.2020 1:03:51

