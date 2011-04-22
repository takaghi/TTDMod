package classes{
	import components.utils.Func;
	
	import flash.desktop.DockIcon;
	import flash.desktop.NativeApplication;
	import flash.desktop.NotificationType;
	import flash.desktop.SystemTrayIcon;
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	import flash.display.NativeWindow;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NativeWindowDisplayStateEvent;
	
	import mx.core.BitmapAsset;
	import mx.core.FlexGlobals;
	
	public class RootMenuManager{
		
		private var Appl:Object = FlexGlobals.topLevelApplication;
		
		private var exts:Array = [];
		
		[Embed(source="tray2.png")]
		[Bindable]
		public var TrayIcon:Class;
		
		private static var instance:RootMenuManager;
		private var windows:NativeMenu = new NativeMenu();
		
		public function RootMenuManager(){	
			instance = this;
			//exts = ExtManager.getExtentions();
			setMenu();
			setTrayIcon();		
		}	
		
		private function setMenu():void{
			if(NativeWindow.supportsMenu){
				Appl.nativeWindow.menu = createRootMenu();
			}
		}
		
		private function setTrayIcon():void{
			if (NativeApplication.supportsSystemTrayIcon){					
				var trayIcon:BitmapAsset = new TrayIcon() as BitmapAsset;
				
				NativeApplication.nativeApplication.icon.bitmaps = [trayIcon.bitmapData];
				
				var sysTrayIcon:SystemTrayIcon =  NativeApplication.nativeApplication.icon as SystemTrayIcon;
				sysTrayIcon.tooltip = "TTDMod";
				sysTrayIcon.addEventListener(MouseEvent.CLICK,undock);
				sysTrayIcon.menu = createRootMenu();
				Appl.addEventListener(NativeWindowDisplayStateEvent.DISPLAY_STATE_CHANGE, onChange);
			}
		}
		
		private function onChange(e:NativeWindowDisplayStateEvent):void{
		//	trace("ApplicationWindow stage changed from " + e.beforeDisplayState + " to " + e.afterDisplayState);
		//	if(e.afterDisplayState == "minimized")
		//		dock();
		}			
		private function dock(event:Event = null):void{
			Appl.stage.nativeWindow.visible = false;  
			
			//NativeApplication.nativeApplication.icon.bitmaps = [trayIcon];
		}
		
		private function undock(event:Event = null):void{
			Appl.stage.nativeWindow.visible = true;
			Appl.stage.nativeWindow.activate();
			notify();
			//NativeApplication.nativeApplication.icon.bitmaps = [];
		}
		
		private function createRootMenu():NativeMenu{
			var menu:NativeMenu = new NativeMenu();
			var tasks:NativeMenu = new NativeMenu();
			var calendar:NativeMenu = new NativeMenu();
			var users:NativeMenu = new NativeMenu();
		//	var windows:NativeMenu = new NativeMenu();
			var projects:NativeMenu = new NativeMenu();
			var messages:NativeMenu = new NativeMenu();
			var extentions:NativeMenu = new NativeMenu();
			var help:NativeMenu = new NativeMenu();
			/////////////////////////////////
			
			var calendarFull:NativeMenuItem = new NativeMenuItem("Календарь");
			calendarFull.name = "Calendar";
			calendarFull.addEventListener(Event.SELECT, openWindow, false, 0, true);
			
			var holydays:NativeMenuItem = new NativeMenuItem("Праздники");
			holydays.name = "Holydays";
			holydays.addEventListener(Event.SELECT, openWindow, false, 0, true);
			
			var calStat:NativeMenuItem = new NativeMenuItem("Статистика");
			calStat.name = "CalStatistic";
			calStat.addEventListener(Event.SELECT, openWindow, false, 0, true);
			
			calendar.addItem(calendarFull);
			calendar.addItem(holydays);
			calendar.addItem(calStat);
			
			
			
			
			/////////////////////////////////
			
			var taskList:NativeMenuItem = new NativeMenuItem("Список");
			taskList.name = "Tasks";
			taskList.addEventListener(Event.SELECT, openWindow, false, 0, true);
			taskList.keyEquivalent = "t";
			
			var taskAdd:NativeMenuItem = new NativeMenuItem("Добавить");
			taskAdd.name = "Task";
			taskAdd.addEventListener(Event.SELECT, openWindow, false, 0, true);
			//taskAdd.keyEquivalent = "a";

			var taskMove:NativeMenuItem = new NativeMenuItem("Перенести");
			taskMove.name = "MoveTasks";
			taskMove.addEventListener(Event.SELECT, openWindow, false, 0, true);
			//taskAdd.keyEquivalent = "a";
			
			var taskSearch:NativeMenuItem = new NativeMenuItem("Поиск");
			taskSearch.name = "SearchTasks";
			taskSearch.addEventListener(Event.SELECT, openWindow, false, 0, true);
			//taskAdd.keyEquivalent = "a";
			
			var privateTasks:NativeMenuItem = new NativeMenuItem("Личные задачи");
			privateTasks.name = "PrivateTasks";
			privateTasks.addEventListener(Event.SELECT, openWindow, false, 0, true);
			//taskAdd.keyEquivalent = "a";

			tasks.addItem(taskList);
			if(Globals.access.task_add)
				tasks.addItem(taskAdd);
			if(Globals.access.task_move)
				tasks.addItem(taskMove);
			tasks.addItem(taskSearch);
			if(Globals.access.private_task_show)
				tasks.addItem(privateTasks);
			
			//////////////////////////////////
			
			
			var userList:NativeMenuItem = new NativeMenuItem("Список");
			userList.name = "Users";
			userList.addEventListener(Event.SELECT, openWindow, false, 0, true);
			userList.keyEquivalent = "l";
			
			var userAdd:NativeMenuItem = new NativeMenuItem("Добавить");
			userAdd.name = "User";
			userAdd.addEventListener(Event.SELECT, openWindow, false, 0, true);
		//	userAdd.keyEquivalent = "a";
			
			users.addItem(userList);
			if(Globals.access.staff_add)
				users.addItem(userAdd);
			
			//////////////////////////////////
			
			var projList:NativeMenuItem = new NativeMenuItem("Список");
			projList.name = "Projects";
			projList.addEventListener(Event.SELECT, openWindow, false, 0, true);
			//projList.keyEquivalent = "l";
			
			var privateList:NativeMenuItem = new NativeMenuItem("Админ.части");
			privateList.name = "PrivateList";
			privateList.addEventListener(Event.SELECT, openWindow, false, 0, true);
		//	projAdd.keyEquivalent = "a";
			
			projects.addItem(projList);
			if(Globals.access.private_list_show)
				projects.addItem(privateList);
		//	if(Globals.access.project_add)
		//		projects.addItem(projAdd);
						
			//////////////////////////////////
			
			var chatWindow:NativeMenuItem = new NativeMenuItem("Написать");
			chatWindow.name = "NewMessage";
			chatWindow.addEventListener(Event.SELECT, openNativeWindow, false, 0, true);
			//projList.keyEquivalent = "l";
			
			messages.addItem(chatWindow);
			
			//////////////////////////////////
			
			var extManager:NativeMenuItem = new NativeMenuItem("Менеджер");
			extManager.name = "ExtManager";
			extManager.addEventListener(Event.SELECT, openWindow, false, 0, true);
			//userList.keyEquivalent = "l";	
			
			var extLoader:NativeMenuItem = new NativeMenuItem("Загрузчик");
			extLoader.name = "ExtLoader";
			//extLoader.data = {};
			extLoader.addEventListener(Event.SELECT, openWindow, false, 0, true);
			
			extentions.addItem(extManager); 
			extentions.addItem(Func.getMenuSeparator());
			
			for(var i:int=0; i<exts.length; i++){
				var e:NativeMenuItem = new NativeMenuItem(exts[i].name);
				e.name = "ExtLoader";
				e.data = exts[i];
				e.addEventListener(Event.SELECT, openWindow, false, 0, true);
				extentions.addItem(e);
			}
			extentions.addItem(Func.getMenuSeparator());
			extentions.addItem(extLoader);
			
			//////////////////////////////////		
			
			if(windows.numItems==0){
				var tile:NativeMenuItem = new NativeMenuItem("Мозайкой");
				tile.addEventListener(Event.SELECT, function():void{WinManager.tileWin(true)});
				//tile.keyEquivalent = "l";
				
				var cascade:NativeMenuItem = new NativeMenuItem("Каскадом");
				cascade.addEventListener(Event.SELECT, function():void{WinManager.tileWin()});
				//	cascade.keyEquivalent = "a";
				
				var closeAllWin:NativeMenuItem = new NativeMenuItem("Закрыть все");
				closeAllWin.addEventListener(Event.SELECT, closeAll);
				//	cascade.keyEquivalent = "a";
								
				windows.addItem(tile);
				windows.addItem(cascade);				
				windows.addItem(closeAllWin);				
			}
			
			//////////////////////////////////
			var log:NativeMenuItem = new NativeMenuItem("Лог");
			log.addEventListener(Event.SELECT, FlexGlobals.topLevelApplication.main.showLog, false, 0, true);
		//	log.keyEquivalent = "h";
			
			var settings:NativeMenuItem = new NativeMenuItem("Настройки");
			settings.name = "Settings";
			settings.addEventListener(Event.SELECT, openWindow, false, 0, true);
			//helpList.keyEquivalent = "h";
			
			var clearCache:NativeMenuItem = new NativeMenuItem("Очистить кеш");
		//	settings.name = "Settings";
			clearCache.addEventListener(Event.SELECT, clearRemoteCache, false, 0, true);
			//helpList.keyEquivalent = "h";
			
			var helpList:NativeMenuItem = new NativeMenuItem("Справка");
			helpList.name = "Help";
			helpList.addEventListener(Event.SELECT, openWindow, false, 0, true);
			helpList.keyEquivalent = "h";
			
			var about:NativeMenuItem = new NativeMenuItem("О программе");
			//about.name = "test";
			//about.addEventListener(Event.SELECT, openWindow, false, 0, true);
			//	userAdd.keyEquivalent = "a";
			
			help.addItem(log);
			help.addItem(settings);
			help.addItem(clearCache);
			help.addItem(helpList);
			help.addItem(about);
						
			
			if(Globals.access.task_show)
				menu.addSubmenu(tasks, "Задачи");
			menu.addSubmenu(calendar, "Календарь");
			if(Globals.access.staff_show)
				menu.addSubmenu(users, "Пользователи");
			if(Globals.access.project_show)
				menu.addSubmenu(projects, "Проекты");
			menu.addSubmenu(messages, "Сообщения");
		//	menu.addSubmenu(extentions, "Расширения");
			menu.addSubmenu(windows, "Окна");
			menu.addSubmenu(help, "Справка");
			
			
			var exit:NativeMenuItem = new NativeMenuItem("Выход");
			exit.addEventListener(Event.SELECT, function():void{
							FlexGlobals.topLevelApplication.main.exit(); 
							NativeApplication.nativeApplication.exit();
					});
			menu.addItem(exit);	
			
			
			return menu;
		}
		
		private function notify():void{ 
			if(NativeApplication.supportsDockIcon){
				var dock:DockIcon = NativeApplication.nativeApplication.icon as DockIcon;
				dock.bounce(NotificationType.CRITICAL);
			} else if (NativeApplication.supportsSystemTrayIcon){
				Appl.stage.nativeWindow.notifyUser(NotificationType.CRITICAL);
			}
		}
		
		
		private function openWindow(event:Event):void{
			WinManager.addWin(event.target.name, event.target.data);
			undock();
		}
		
		private function closeAll(event:Event):void{
			WinManager.closeAll();
		}
		
		private function openNativeWindow(event:Event):void{
			NotifyManager.openChatWindow();	
		}
		
		public static function updateWindowMenu(winList:Array):void{
			for(var i:int = instance.windows.numItems - 1; i > 2; i--){
				instance.windows.removeItemAt(i);
			}
			if(winList.length>0)
				instance.windows.addItem(Func.getMenuSeparator());
			
			var m:NativeMenuItem
			for(var j:int=0; j < winList.length; j++){
				m = new NativeMenuItem(winList[j].title);
				instance.addEvent(m, j);				
				instance.windows.addItem(m);
			}
			if(m)
				m.checked = true;			
		}
		private function addEvent(item:NativeMenuItem, num:int):void{
			item.addEventListener(Event.SELECT, function():void{
				for(var i:int = 0; i < windows.numItems; i++){
					windows.getItemAt(i).checked = false;
				}
				item.checked = true; 
				WinManager.frontWindow(num);
			});
		}
		
		private function clearRemoteCache(event:Event):void{
			Remote.clearCache();
			
			//очистка поля задач
			SharedManager.clearObj("task_name");
		}
	}
}