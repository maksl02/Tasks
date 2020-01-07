﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыЗаписи = Новый Структура;
	ПараметрыЗаписи.Вставить("Ключ", КлючЗаписиРегистра(ПараметрКоманды));
	ПараметрыЗаписи.Вставить("ЗначенияЗаполнения", Новый Структура("КонечнаяТочка", ПараметрКоманды));
	
	ОткрытьФорму("РегистрСведений.НастройкиТранспортаОбменаСообщениями.ФормаЗаписи",
		ПараметрыЗаписи, ПараметрыВыполненияКоманды.Источник);
	
КонецПроцедуры
	
#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция КлючЗаписиРегистра(КонечнаяТочка)
	
	Возврат РегистрыСведений.НастройкиТранспортаОбменаСообщениями.СоздатьКлючЗаписи(
		Новый Структура("КонечнаяТочка", КонечнаяТочка));
	
КонецФункции

#КонецОбласти
