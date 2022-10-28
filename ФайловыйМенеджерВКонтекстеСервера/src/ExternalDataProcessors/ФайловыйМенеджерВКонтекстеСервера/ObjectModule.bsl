Функция ПолучитьРазмерФайла(ПолноеИмяФайла) Экспорт
	
	Файл = Новый Файл(ПолноеИмяФайла);
	
	Размер = 0;
	
	Если Файл.ЭтоФайл() Тогда
		Размер = Файл.Размер();
	Иначе // Это каталог. Ищем все файлы в каталоге и подкаталогах и возвращаем сумму размеров всех файлов
		ФайлыКаталога = НайтиФайлы(ПолноеИмяФайла, "*", Истина);
		Для каждого Файл Из ФайлыКаталога Цикл Попытка Размер = Размер + Файл.Размер(); Исключение КонецПопытки; КонецЦикла;  // Цикл может выполняться очень много раз - немного экономим времени.
	КонецЕсли; 
	
	Возврат Размер;
	
КонецФункции

Функция ПредставлениеРазмераФайла(Знач Размер) Экспорт
	
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
 
// Возвращает Истина, если текущий сеанс выполняется на сервере, работающем под управлением ОС Windows.
//
// Возвращаемое значение:
//  Булево - Истина, если сервер работает под управлением ОС Windows.
//
Функция ЭтоWindowsСервер() Экспорт
	
	СистемнаяИнформация = Новый СистемнаяИнформация;
	Возврат СистемнаяИнформация.ТипПлатформы = ТипПлатформы.Windows_x86 
		Или СистемнаяИнформация.ТипПлатформы = ТипПлатформы.Windows_x86_64;
	
КонецФункции