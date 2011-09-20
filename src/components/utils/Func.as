package components.utils{
	import components.wins.tasktodo.calendar.additions.timeInput;
	
	import flash.display.NativeMenuItem;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.filesystem.*;
	import flash.net.FileFilter;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.utils.*;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.controls.DateField;
	import mx.controls.HRule;
	import mx.controls.LinkButton;
	import mx.core.UIComponent;
	import mx.events.ListEvent;
	import mx.events.ValidationResultEvent;
	import mx.utils.ObjectUtil;
	import mx.validators.Validator;
	
	import spark.components.CheckBox;
	import spark.components.ComboBox;
	import spark.components.DropDownList;
	import spark.components.HGroup;
	import spark.components.TextArea;
	import spark.components.TextInput;

	/**
	 * 	Набор статических функций
	 */
	public final class Func {
		/**
		 * 	Возвращает класс объекта
		 * @param	obj	объект
		 * @return
		 */
		public static function getClass(obj:Object):Class {
			return Class(getDefinitionByName(getQualifiedClassName(obj)));
		}
		public static function getClassByName(name:String):Class {
			return Class(getDefinitionByName(name));
		}
		/**
		 * 	Возвращает индекс элемента checkbox selected
		 * @param	obj	контейнер элементов
		 * @return
		 */
		public static function getNameBoolInput(obj:Object):String{
			for (var i:int=0; i<obj.numChildren; i++){				
				if(obj.getChildAt(i).hasOwnProperty("selected") && obj.getChildAt(i).selected){
					var str:String = UIComponent(obj.getChildAt(i)).id;					
				}
			}
			return str.charAt(str.length-1);
		}
		/**
		 * 	Перевод Boolean to String
		 * @param	val
		 * @return
		 */
		public static function BoolStr(val:Boolean):String{
			if(val)
				return "1";
			else
				return "0";
		}
		/**
		 * 	Разворачивает слеши в одну сторону
		 * @param	val
		 * @return
		 */
		public static function slash(val:String):String{
			while (val.search("/")!=-1)
				val = val.replace("/","\\")
			return val;			
		}
		
		public static function backSlash(val:String):String{
			return val.split("\\").join("/");	
		}
		
		public static function compareStrings(str1:String, str2:String):Boolean{
			var removeHtmlRegExp:RegExp = new RegExp("<[^<]+?>", "gi");	
			str1 = str1.replace(removeHtmlRegExp, "").split(" ").join("").split("\n").join("");
			str2 = str2.replace(removeHtmlRegExp, "").split(" ").join("").split("\n").join("");
			return str1 == str2;
		}
		
		public static function getHTML(val:String):String{	
	//		return val;
			return val.replace('<p>&nbsp;</p>', '').split("\r\n").join("");
		}
		
		/**
		 * 	Выбор файла
		 * 
		 * @param	caller объект(страница) вызвавший функцию
		 * @param	type	тип файла
		 * @param	field	текстовое поле для получения адреса
		 * @param	path	папка для файла(имя шаблона)
		 * @param	newTemp	флаг используется при создании шаблона
		 * @param	list	флаг используется для файлов галереи
		 */
		public static function setFilePath(caller:Object, func:String, type:String = "", copy:Boolean = false):void{	
			
			var filter:FileFilter;
			var filters:Array;
			var destination:File;
			var newPath:String = "/";
			
			
			switch (type){
				case "objImage": 		filter = new FileFilter("Графическое содержимое", "*.jpg;*.gif;*.png");
					break;
				case "objSound":		filter = new FileFilter("Звуковое содержимое", "*.mp3;*.wav;*.aiff;*.au");
					break;
				case "objText":			filter = new FileFilter("Текстовое содержимое слайда", "*.txt");
					break;
				case "objSwf":			filter = new FileFilter("Файл SWF", "*.swf");
					break;	
			}	
			if(filter != null)
				filters = [filter];
			
			var fileToOpen:File = new File();
			try {
				fileToOpen.browseForOpen("Open", filters);
				fileToOpen.addEventListener(Event.SELECT, fileSelected);
			}
			catch (error:Error){
				trace("Failed:", error.message)
			}	
			
			function fileSelected(event:Event):void {	
				if(!copy){
					caller[func](fileToOpen.nativePath);						
					return;			
				}
				destination = File.documentsDirectory.resolvePath(newPath + fileToOpen.name);
				fileToOpen.addEventListener(Event.COMPLETE, fileMoveCompleteHandler);
				fileToOpen.addEventListener(IOErrorEvent.IO_ERROR, fileMoveIOErrorEventHandler);
				fileToOpen.copyToAsync(destination);				
			}
			function fileMoveCompleteHandler(event:Event=null):void {
				fileToOpen.removeEventListener(Event.COMPLETE, fileMoveCompleteHandler);
																///события в компонентах(не галерея)
				//caller.relPath[field] = relPath;
				//caller[field].text = fileToOpen.name;	
		
			}
			function getPath(p:String):String{
				return p;
			}
			function fileMoveIOErrorEventHandler(event:IOErrorEvent):void {
				trace("I/O Error.", event); 
			//	Main.alert.show(Lang.fileExist+"\n"+Lang.rewriteFile ,"confirm");
			//	EventManager.addEventListener(Main.alert,AlkoEvent.GET_ALERT_ANSWER,doRewrite,false,0,true,true); 
			}
			function doRewrite(e:Event):void{
			/*	if(Main.alert.ans){
					Main.alert.removeEventListener(AlkoEvent.GET_ALERT_ANSWER,doRewrite);
					fileToOpen.addEventListener(Event.COMPLETE, fileMoveCompleteHandler);
					fileToOpen.addEventListener(IOErrorEvent.IO_ERROR, fileMoveIOErrorEventHandler);
					fileToOpen.copyToAsync(destination,true);					
				}*/
			}	
		}
		/**
		 * 	Создание текстовых файлов
		 * @param	path	путь
		 * @param	val		текст файла
		 */
		public static function saveToFile(path:String, val:Object):void{
			var file:File = File.documentsDirectory;
			file = file.resolvePath(path);
			var fs:FileStream = new FileStream();
			fs.open(file, FileMode.WRITE);
			fs.writeUTFBytes(val.toString());
			fs.close();
		}
		/**
		 * 	Формирование коротких путей
		 * @param	val		длинный путь
		 * @return	имя файла
		 */
		public static function shortPath(val:String):Object{
			var obj:Object = new Object();
			var i:int
			i = val.lastIndexOf("\\")+1;
			if(i==0)
			i = val.lastIndexOf("/")+1;
			obj.name = val.substr(i);
			obj.path = val.substring(0,i);
			return obj;
		}
		/**
		 * 	Очистка всех текстовых полей в контейнере
		 * @param	par	контейнер
		 */
		public static function clearInputs(par:Object):void{
			for(var i:int=0; i<par.numChildren; i++){
				if(par.getChildAt(i) is TextInput && par.getChildAt(i).hasOwnProperty("text")){
					par.getChildAt(i).text = "";
				}	
				if(par.getChildAt(i).hasOwnProperty("numChildren") && par.getChildAt(i).numChildren>0)
					clearInputs(par.getChildAt(i))	
			}
		}
		
		
		public static function showInputs(par:Object, obj:Object, access:Object = null):Object{
			if(!access)
				var access:Object = {};
			
			for(var i:int=0; i<par.numChildren; i++){
				if(par.getChildAt(i).hasOwnProperty("enabled") && !par.getChildAt(i).enabled)
					continue;
				if(par is CustomEditor){
					obj[par.id] = par.text;
					return obj
				}
				if(par.getChildAt(i) is DateField){
					//trace(par.getChildAt(i).id, par.getChildAt(i),  par.getChildAt(i).text);
					obj[par.getChildAt(i).id] = par.getChildAt(i).text;
				}
				else if(par.getChildAt(i) is timeInput){
					obj[par.getChildAt(i).id] = par.getChildAt(i).time;					
				}
				else if(par.getChildAt(i) is ComboBox  || par.getChildAt(i) is DropDownList){
				//	trace([par.getChildAt(i).id],  par.getChildAt(i).selectedItem[par.getChildAt(i).id]);
					if(par.getChildAt(i).selectedIndex < 0)
						obj[par.getChildAt(i).id] = null;			
					else
						obj[par.getChildAt(i).id] = par.getChildAt(i).selectedItem[par.getChildAt(i).id];					
				}
				else if(!par.getChildAt(i).hasOwnProperty("selectedItem") && (par.getChildAt(i) is TextInput || par.getChildAt(i) is TextArea)){
					var e:* = par.getChildAt(i);
					
					//trace(par.getChildAt(i).id, par.getChildAt(i),  par.getChildAt(i).text);
					if(par.getChildAt(i).id!="editor")
						obj[par.getChildAt(i).id] = par.getChildAt(i).text;
					else
						obj.dsc = par.getChildAt(i).text;
				}else if(par.getChildAt(i) is CheckBox){
					var d:CheckBox = par.getChildAt(i);
					
					if(d && d.id && (d.id.search("action_")>=0 || d.id.search("staff_")>=0 || d.id.search("project_")>=0 || d.id.search("task_")>=0 || d.id.search("calendar_")>=0 || d.id.search("holiday_")>=0 || d.id.search("private_")>=0)){						
						access[d.id] = d.selected;
					}else
						obj[par.getChildAt(i).id] = par.getChildAt(i).selected;
				}
				if(!(par.getChildAt(i) is ComboBox) && par.getChildAt(i).hasOwnProperty("numChildren") && par.getChildAt(i).numChildren>0)
					showInputs(par.getChildAt(i), obj, access)				
			}
			if(!obj.hasOwnProperty("access") && getLength(access)>0)
				obj.access = access;
			return obj;
		}
		
		public static function getLength(o:Object):uint	{
			var len:uint = 0;
			for (var item:* in o)
				if (item != "mx_internal_uid")
					len++;
			return len;
		}
		
		
		
		/**
		 * 	Открытие папки дерева по двойному клику
		 * @param	e
		 */
		public static function treeDblClick(e:ListEvent):void{
			if(e.target.selectedItem.children && !e.target.isItemOpen(e.target.selectedItem)){
				e.target.expandItem(e.target.selectedItem,true);
			}
			else if(e.target.selectedItem.children && e.target.isItemOpen(e.target.selectedItem)){
				e.target.expandItem(e.target.selectedItem,false);
			}
			//e.target.validateNow();
		}
		/**
		 * 	Открытие ссылки в браузере
		 * @param	link	ссылка
		 */
		public static function gotoLink(link:String):void{
			var request:URLRequest = new URLRequest(link);				
			try {
				navigateToURL(request, "_blank");					
			} catch (e:Error) {}
		}
		
		public static function convertTime_minutesToHoursMin( minutes:int ):String {
			var _hours:int = Math.floor( minutes / 60 );
			var _min:int = minutes % 60;
			
			if( minutes == 0 ) {
				return "less than a minute";
			}
			
			var _time:String;
			if( _hours > 0 ) { // get hours and mintutes
				_time = ( _hours > 1 ) ? _hours + " hours " : _hours + " hour ";
				if( _min > 0 ) {
					_time += ( _min > 1 ) ? "and " + _min + " minutes" : "and 1 minute";
				}
			} else { // just get minutes
				_time = ( _min > 1 ) ? _min + " minutes" : "1 minute";
			}
			return _time;
		}
		
		public static function getDateDifference(date:Date):Number{
			return Math.ceil((date.getTime() - new Date().getTime())/(1000*60*60*24));
		}
		
		/**
		 * Get the name of the day from the date
		 */
		public static function getDayNameFromDate( date:Date, short:Boolean = false):String {
			
			if(short)
				switch( date.day ) {
					case 0 :
						return 'Вс';
					case 1 :
						return 'Пн';
					case 2 :
						return 'Вт';
					case 3 :
						return 'Ср';
					case 4 :
						return 'Чт';
					case 5 :
						return 'Пт';
					case 6 :
						return 'Сб';
					default :
						return '';
				}
			
			switch( date.day ) {
				case 0 :
					return 'Воскресенье';
				case 1 :
					return 'Понедельник';
				case 2 :
					return 'Вторник';
				case 3 :
					return 'Среда';
				case 4 :
					return 'Четверг';
				case 5 :
					return 'Пятница';
				case 6 :
					return 'Суббота';
				default :
					return '';
			}
		}
		
		/**
		 * Get the month name from the date
		 */
		public static function getMonthNameFromDate( date:Date ):String {
			return Globals.months[date.month].charAt(0).toUpperCase() + Globals.months[date.month].substr(1);
		}
		
		/**
		 * 	Get MySQL string from date
		 */
		public static function getMySQLDate( date:Date ):String {
			var s:String = date.fullYear + '-';
			
			// add the month
			if( date.month < 9 ) {
				s += '0' + ( date.month + 1 ) + '-';
			} else {
				s += ( date.month + 1 ) + '-';
			}
			
			// add the day
			if( date.date < 10 ) {
				s += '0' + date.date;
			} else {
				s += date.date;
			}
			
			return s;
		}
		
		/**
		 * 	Get MySQL string from date
		 */
		public static function getMySQLDate2( date:Date, delta:int = 0 ):String {
			date.date += delta;
			var s:String = "";
			// add the day
			if( date.date < 10 ) {
				s += '0' + date.date + '-';
			} else {
				s += date.date + '-';
			}
			
			// add the month
			if( date.month < 9 ) {
				s += '0' + ( date.month + 1 ) + '-';
			} else {
				s += ( date.month + 1 ) + '-';
			}
			
			s += date.fullYear;
			
			return s;
		}
		
		/**
		 * Make a Date object from a MySQL date string
		 */
		public static function convertMySQLDateToActionscript( s:String ):Date {
			var a:Array = s.split( '-' );
			return new Date( a[0], a[1] - 1, a[2] );
		}
		
		public static function convertStringDate( s:String ):String {
			if(!s)
				return "";
			var a:Array = s.split( '-' );
			return a[2]+"-"+a[1]+"-"+a[0];
		}
		
		public static function convertStringDateTime(s:String, date:Boolean = false, time:Boolean = false):String {
			if(!s)
				return "";
			var a:Array = s.split(' ');
			if(date)
				return convertStringDate(a[0]);
			else if(time)
				return a[1].substr(0, 5);
			else
				return a[1].substr(0, 5)+"  "+convertStringDate(a[0]);
		}		
		/**
		 * 	Convert an MySQL Timestamp to an Actionscript Date
		 * 	Thanks to Pascal Brewing brewing@alice-dsl.de for the beautiful simplicity.
		 */
		public static function convertMySQLTimeStampToASDate( time:String ):Date{
			var pattern:RegExp = /[: -]/g;
			time = time.replace( pattern, ',' );
			var timeArray:Array = time.split( ',' );
			var date:Date = new Date( 	timeArray[0], timeArray[1]-1, timeArray[2],
				timeArray[3], timeArray[4], timeArray[5] );
			return date as Date;
		}
		
		/**
		 * 	Convert an MySQL Timestamp to an Actionscript Date
		 * 	Thanks to Pascal Brewing brewing@alice-dsl.de for the beautiful simplicity.
		 */
		public static function convertASDateToMySQLTimestamp( d:Date ):String {
			var s:String = d.fullYear + '-';
			s += prependZero( d.month + 1 ) + '-';
			s += prependZero( d.day ) + ' ';
			
			s += prependZero( d.hours ) + ':';
			s += prependZero( d.minutes ) + ':';
			s += prependZero( d.seconds );			
			
			return s;
		}
		
		public static function getLogTime( d:Date ):String {
			var s:String = prependZero( d.date ) + '.';
			s += prependZero( d.month + 1 ) + '  ';
			
			s += prependZero( d.hours ) + ':';
			s += prependZero( d.minutes ) + ':';
			s += prependZero( d.seconds );			
			
			return s;
		}
		
		private static function prependZero( n:Number ):String {
			var s:String = ( n < 10 ) ? '0' + n : n.toString();
			return s;
		}
		
		/********************************
		 * 	The following three methods are useful for video player time displays
		 ********************************/
		
		/**
		 * 	Input the seconds and return a string of the form: hours:mins:secs
		 */
		public static function convertSecondsTo_HoursMinsSec( seconds:int ):String {
			var timeOut:String;
			var hours:int = int( seconds / 3600 );
			var mins:int = int( ( seconds - ( hours * 3600 ) ) / 60 )
			var secs:int = seconds % 60;
			
			if( isNaN( hours ) || isNaN( mins ) || isNaN( secs ) ) {
				return "--:--:--";
			}
			
			var minS:String = ( mins < 10 ) ? "0" + mins : String( mins );
			
			var secS:String = ( secs < 10 ) ? "0" + secs : String( secs );
			
			var hourS:String = String( hours );
			timeOut = hourS + ":" + minS + ":" + secS;
			return timeOut;	
		}
		
		/**
		 * 	Input the seconds and return a string of the form: mins:sec
		 */
		public static function convertSecondsTo_MinsSec( seconds:int ):String {
			var timeOut:String;
			var mins:int = int( seconds / 60 )
			var secs:int = seconds % 60;
			
			if( isNaN( mins ) || isNaN( secs ) ) {
				return "--:--";
			}
			
			var minS:String = ( mins < 10 ) ? "0" + mins : String( mins );
			var secS:String = ( secs < 10 ) ? "0" + secs : String( secs );
			
			timeOut = minS + ":" + secS;
			return timeOut;	
		}
		
		/**
		 * 	Input seconds and return a string of the form: hours:min
		 */
		public static function getHoursMinutes( seconds:int ):String {
			var timeOut:String;
			var hours:int = int( seconds / 3600 );
			var mins:int = int( ( seconds - ( hours * 3600 ) ) / 60 )
			var secs:int = seconds % 60;
			
			if( isNaN( hours ) || isNaN( mins ) || isNaN( secs ) ) {
				return "--:--";
			}
			
			var minS:String = ( mins < 10 ) ? "0" + mins : String( mins );
			
			var hourS:String = String( hours );
			timeOut = hourS + ":" + minS;
			return timeOut;	
		}
		
		public static function convertStringTimeToNumber( str:String ):Number {
			if(!str)
				return 0;
			var a:Array = str.split( ':' );
			return parseInt(a[0])*60 + parseInt(a[1]);
		}
		public static function convertNumberToStringTime( num:Number ):String {
			if(num==0)
				return "";
			var hh:Number = int(num/60);
			var min:Number = num - hh*60;
			return hh + ":"+ ((min < 10) ? ("0" + min) : min);
		}
		public static function convertStringTimeToNumber2( str:String ):Number {
			if(!str)
				return 0;
			var a:Array = str.split( ':' );
			return parseInt(a[0])+parseInt(a[1])/100;
		}
		
		public static function getProviderIndex(data:ArrayCollection, field:String, value:String):int{
			if(data)
				for(var i:int=0; i<data.length; i++){
					if(data[i][field] == value){
						return i;
					}
				}
			return -1;
		}
		
		public static function insertBlankItem(data:ArrayCollection, field:String, new_field:String="", old_field:String=""):ArrayCollection{
			var newData:ArrayCollection = new ArrayCollection( ObjectUtil.copy( data.source ) as Array );
			for each(var o:Object in newData){
				o[new_field] = o[old_field];
			}
			var o0:Object = {};
			o0[field] = "";
			newData.addItemAt(o0, 0);
			return newData;
		}
		
		private static function clone(source:Object):*{
			var myBA:ByteArray = new ByteArray();
			myBA.writeObject(source);
			myBA.position = 0;
			return(myBA.readObject()); 
		}
		
		public static function insertBlankItem2(data:Array, field:String, val:String=""):Array{
			var newData:Array = clone(data);
			var o:Object = {};
			o[field] = val;
			newData.unshift(o);
			return newData;
		}
		
		public static function myNameLabelFunction(item:Object):String {
			if(item.name_second=="")
				return "";
			return item.name_second+" "+item.name_first.charAt(0)+".";//+item.name_middle.charAt(0)+".";
		}
		
		public static function getMenuSeparator():NativeMenuItem{
			return new NativeMenuItem("",true);
		}
		
		public static function getHRule(w:Number):HRule{
			var hr:HRule = new HRule();
			hr.horizontalCenter = 0;
			if(w==100)
				hr.percentWidth = 100;
			else
				hr.width = w;
			return hr;
		}
		
		public static function openFile(path:String):void{		
			if(path.search("http:")==0){
				Func.openLink(path);
				return;
			}else if(path.search("www.")==0){
				Func.openLink("http://"+path);
				return;
			}
			var file:File = File.desktopDirectory.resolvePath(path);
			file.addEventListener(IOErrorEvent.IO_ERROR, function():void{
															Alert.show("Файл не существует", "Error");
															});
			try{
				file.openWithDefaultApplication();
			}catch(e:Error){
				Alert.show("Файл не существует", "Error");
			}
		}
		
		public static function openLink(url:String):void{
			navigateToURL(new URLRequest(url), "_blank");
		}
		
		public static function openFileLinkButton(e:MouseEvent):void{
			if(e.target.data!=null)
				Func.openFile(e.target.data.link);
			else
				Func.openFile(e.target.label);
		}		

		public static function createFileList(path:String, comment:String):HGroup{
			
			[Embed(source="assets/icons/document.png")]
			var fileIcon:Class;
			[Embed(source="assets/icons/folder-horizontal.png")]
			var folderIcon:Class;
			
			var iconClass:Class = fileIcon;
			
			var f:File = new File(path);
			if(f.isDirectory)
				iconClass = folderIcon;
			
			var hg:HGroup = new HGroup();
			hg.verticalAlign = "top";
			hg.percentWidth = 100;
			var pathLabel:LinkButton = new LinkButton();
			pathLabel.addEventListener(MouseEvent.CLICK, Func.openFileLinkButton, false, 0, true);
			pathLabel.setStyle("textAlign", "left");
			pathLabel.setStyle("color", 0x3380DD);
			pathLabel.setStyle("icon", iconClass);
			pathLabel.percentWidth = 50;
			pathLabel.label = Func.shortPath(path).name;
			pathLabel.toolTip = path;
			pathLabel.data = {link:path};
			hg.addElement(pathLabel);
			
			var ta:TextArea = new TextArea();
			ta.editable = false;
			ta.text = comment;
			ta.percentWidth = 50;
			ta.heightInLines = NaN;
			ta.setStyle("borderVisible", false);
			hg.addElement(ta);
			return hg;
		}
		
		
		public static function getCalendarMonths():ArrayCollection{
			var d:Date = new Date();
			var arr:Array = [];
			for(var i:int = 5; i>=0; i--){
				var m:String = ((d.month+1<10)) ? ("0"+(d.month+1)):(d.month+1).toString()
				arr.push({name:Globals.months[d.month]+", "+d.fullYearUTC, date: d.fullYearUTC+"-"+m});
				d.month--;
			}
			return new ArrayCollection(arr);
		}
		
		public static function initHide(e:Event):void{
			e.currentTarget.visible = false;
			e.currentTarget.includeInLayout = false;
		}
		
		public static function validateForm(validatorArray:Array):Boolean{
			var validatorErrorArray:Array = Validator.validateAll(validatorArray);;
			var isValidForm:Boolean = validatorErrorArray.length == 0;
			if (!isValidForm)  {
				var err:ValidationResultEvent;
				var errorMessageArray:Array = [];
				for each (err in validatorErrorArray) {
					var errField:String = err.currentTarget.source.parent.label;
					errorMessageArray.push("'"+errField + "' - обязательное поле"/* + err.message*/);
				}
				Alert.show(errorMessageArray.join("\n"), "Форма не заполнена...", Alert.OK);
				return false;
			}
			return true;
		}
		
				
		public static function capitalize(str:String) : String {
			var firstChar:String = str.substr(0, 1); 
			var restOfString:String = str.substr(1, str.length); 
			
			return firstChar.toUpperCase()+restOfString.toLowerCase(); 
		}
		
		
		public static function fNumToWord(vNum:Number, ext:Boolean = true) : String{
			
			var ar:Array = vNum.toString().split(".");
			vNum = ar[0];
			
			if(ar.length > 1)
				var numkop:int = ar[1];
			

			
			var mWords:Array =  ["", 
				"один", "два", "три", "четыре", "пять", "шесть", "семь", "восемь", "девять", "десять", 
				"одиннадцать", "двенадцать", "тринадцать", "четырнадцать", "пятнадцать", "шестнадцать", "семнадцать", "восемнадцать", "девятнадцать", "двадцать"
			];
			mWords[30] = "тридцать";
			mWords[40] = "сорок";
			mWords[50] = "пятьдесят";
			mWords[60] = "шестьдесят";
			mWords[70] = "семдесят";
			mWords[80] = "восемдесят";
			mWords[90] = "девяносто";
			mWords[100] = "сто";
			mWords[200] = "двести";
			mWords[300] = "триста";
			mWords[400] = "четыреста";
			mWords[500] = "пятьсот";
			mWords[600] = "шестьсот";
			mWords[700] = "семьсот";
			mWords[800] = "восемьсот";
			mWords[900] = "девятьсот";
						
			var v : int;
			var vWord : String;
			var vString : String;
			
			vWord = "";	
			if (vNum < 21) vWord += mWords[vNum];
			else if (vNum < 100){
				vWord += mWords[10 * Math.floor(vNum / 10)];
				v = vNum % 10;
				vString = " ";
				if (v > 0) vWord += vString + mWords[v];
			} 
			else if (vNum < 1000){
				vWord += mWords[100 * Math.floor(vNum / 100)];
				v = vNum % 100;		
				if (v > 0) vWord += " " + fNumToWord(v, false);
			}
			else if (vNum < 1000000){
				//vString = (String(vNum).substr( -3) == "000") ? " тысяча" : " тысяч";
				
				var exc:String = fNumToWord(Math.floor(vNum / 1000), false);
				var last_th:String = Math.floor(vNum/1000).toString().substr(-1);

				var last_th_int:int = parseInt(last_th);
				switch (last_th_int) {
					case 1: 
						if(Math.floor(vNum / 1000) != 11 && Math.floor(vNum / 1000) != 111){
							vString = ' тысяча';
						}else{
							vString = ' тысяч';
						}
						break;
					case 2: case 3: case 4: vString = ' тысячи'; 
						break;
					default: 	vString = ' тысяч';
						break;
				}				

				var excAr:Array = exc.split(" ");
				for(var i:int = 0; i < excAr.length; ++i){
					if(excAr[i]=="один")
						excAr[i]="одна";
					else if(excAr[i]=="два")
						excAr[i]="две";
				}
				exc = excAr.join(" ");
				
				
				if(Math.floor(vNum/1000) > 10 && Math.floor(vNum/1000) < 21){
					vString = ' тысяч';
				}
				
				
				
			//	vWord += fNumToWord(Math.floor(vNum / 1000), false) + vString;
				vWord += exc + vString;
				v = vNum % 1000;
				if (v > 0)
				{
					vWord += " ";
					if (v < 100)
						vWord += " ";
					vWord += fNumToWord(v, false);
				}
			} else{
				vString = (String(vNum).substr( -6) == "000000") ? " миллион" : " миллионов";
				vWord += fNumToWord(Math.floor(vNum / 1000000), false) + vString;
				v = vNum % 1000000;
				if (v > 0)
				{
					vWord += " ";
					if (v < 100)
						vWord += " ";
					vWord += fNumToWord(v, false);
				}
			}
			
					
			if(ext){
				var last_ch:String = vNum.toString().substr(-1);
								
				var rub:String;
				
				var last_ch_int:int = parseInt(last_ch);
				
				switch (last_ch_int) {
					case 1: rub = 'рубль'; 
							break;
					case 2: case 3: case 4: rub = 'рубля'; 
											break;
					default: 	rub = 'рублей';
								break;
				}
				if(vNum  > 10 && vNum < 15){
					rub = 'рублей';
				}
				if(vNum > 100){
					last_ch_int = parseInt(vNum.toString().substr(-2));
					if(last_ch_int > 10 && last_ch_int < 15){
						rub = 'рублей';
					}
				}
				
			//	vWord += vNum + " ("+ rub + ") " + getKop(numkop);
				if(vNum > 0)
					vWord = vNum.toString() + " (" + Func.capitalize(vWord) + ") " + rub +" "+ getKop(numkop);
				else
					vWord = getKop(numkop);
			}
			
			function getKop(num:int):String{
				var last_ch:String = num.toString().substr(-1);
				var k:String;
				var last_ch_int:int = parseInt(last_ch);
				switch (last_ch_int) {
					case 1: k = 'копейка';
						break;
					case 2: case 3: case 4: k = 'копейки';
						break;
					default: 	k = 'копеек';
						break;
				}
				if(num  > 10 && num < 15){
					k = 'копеек';
				}
				return num + " " + k;
			}
			
			
			return vWord;
		}
		
		public static function placeHolderTextInputOnFocusIn(e:FocusEvent, str:String):void{
			var t:TextInput = e.currentTarget as TextInput;
			t.addEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
			if(t.text==str){
				t.text = "";
			}
			t.styleName = "act";
			
			function onFocusOut(event:FocusEvent):void{
				t.removeEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
				if(t.text==""){
					t.text = str;
					t.styleName = "def";
					//	if(t.name == "password_f")
					//		t.displayAsPassword = false;
				}	
			}
		}
	
		public static function arrConcatUnique(arr:Array, arr2:Array):Array{
					
			for(var i:uint = 0; i<arr.length; i++){
				if(arr2[i]){
					arr[i] = arr2[i]
				}				
			}					
			return arr;
		}


		
	}
}