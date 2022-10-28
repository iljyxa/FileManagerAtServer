#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Параметры.Свойство("ПолноеИмяФайла", Путь);

	Файл = Новый Файл(Путь);

	Имя = Файл.Имя;

	Размер = ПолучитьРазмерФайла(Путь);
	РазмерПредставление = ПредставлениеРазмераФайла(Размер);

	ВремяИзменения = Файл.ПолучитьВремяИзменения();
	Скрытый = Файл.ПолучитьНевидимость();
	ТолькоЧтение = Файл.ПолучитьТолькоЧтение();

	Заголовок = "Свойства: " + Имя;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)

	Если Модифицированность Тогда
		ЗаписатьИзмененияВФайл();
	КонецЕсли;

	Закрыть(Строка(Путь));

КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	Закрыть();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаписатьИзмененияВФайл()

	Файл = Новый Файл(Путь);

	Если Имя <> Файл.Имя Тогда
		ПереместитьФайл(Файл.Путь + "\" + Файл.Имя, Файл.Путь + "\" + Имя);
		Файл = Новый Файл(Файл.Путь + "\" + Имя);
	КонецЕсли;

	Если Скрытый <> Файл.ПолучитьНевидимость() Тогда
		Файл.УстановитьНевидимость(Скрытый);
	КонецЕсли;

	Если ТолькоЧтение <> Файл.ПолучитьТолькоЧтение() Тогда
		Файл.УстановитьТолькоЧтение(ТолькоЧтение);
	КонецЕсли;

	Файл.УстановитьВремяИзменения(ТекущаяДатаСеанса());

КонецПроцедуры

&НаСервереБезКонтекста
Функция ПредставлениеРазмераФайла(Знач Размер)

	Если Размер < 1024 Тогда
		Возврат Строка(Размер) + " Б";
	ИначеЕсли Размер < (1024 * 1024) Тогда
		Возврат Строка(Размер / 1024) + " КБ";
	ИначеЕсли Размер < (1024 * 1024 * 1024) Тогда
		Возврат Строка(Окр(Размер / 1024 / 1024, 2)) + " МБ";
	ИначеЕсли Размер < (1024 * 1024 * 1024 * 1024) Тогда
		Возврат Строка(Окр(Размер / 1024 / 1024 / 1024, 2)) + " ГБ";
	Иначе
		Возврат Строка(Окр(Размер / 1024 / 1024 / 1024 / 1024, 2)) + " ТБ";
	КонецЕсли;

КонецФункции

&НаСервере
Функция ПолучитьРазмерФайла(ПолноеИмяФайла)

	Файл = Новый Файл(ПолноеИмяФайла);

	РазмерФайла = 0;

	Если Файл.ЭтоФайл() Тогда
		РазмерФайла = Файл.Размер();
	Иначе // Это каталог. Ищем все файлы в каталоге и подкаталогах и возвращаем сумму размеров всех файлов
		ФайлыКаталога = НайтиФайлы(ПолноеИмяФайла, "*", Истина);

		Для Каждого Файл Из ФайлыКаталога Цикл 
			//@skip-check empty-except-statement
			Попытка
				РазмерФайла = РазмерФайла + Файл.Размер();
			Исключение
			КонецПопытки;
		КонецЦикла;

	КонецЕсли;

	Возврат РазмерФайла;

КонецФункции

#КонецОбласти