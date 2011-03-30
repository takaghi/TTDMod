package classes
{
	
	import components.utils.Func;
	import components.wins.application.*;
	import components.wins.application.extensions.*;
	import components.wins.tasktodo.calendar.*;
	import components.wins.tasktodo.project.*;
	import components.wins.tasktodo.staff.*;
	import components.wins.tasktodo.task.*;
	
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import flexmdi.containers.MDIWindow;
	import flexmdi.effects.IMDIEffectsDescriptor;
	import flexmdi.managers.MDIManager;
	
	import mx.core.FlexGlobals;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;

	public class WinManager extends MDIManager{

		
		private static var oneWindow:Boolean = false;
		private static var Appl:Object = FlexGlobals.topLevelApplication;
		
		private static var instance:WinManager;
		
		private static var paths:Object = {
			Tasks		:	"components.wins.tasktodo.task.Tasks",
			Task		:	"components.wins.tasktodo.task.Task",
			TaskCard	:	"components.wins.tasktodo.task.TaskCard",
			MoveTasks	:	"components.wins.tasktodo.task.MoveTasks",
			SearchTasks	:	"components.wins.tasktodo.task.SearchTasks",
			PrivateTasks:	"components.wins.tasktodo.task.PrivateTasks",
			PrivateTaskCard:	"components.wins.tasktodo.task.PrivateTaskCard",
			PrivateTask:	"components.wins.tasktodo.task.PrivateTask",
			
			Users		:	"components.wins.tasktodo.staff.Users",
			User		:	"components.wins.tasktodo.staff.User",
			UserCard	:	"components.wins.tasktodo.staff.UserCard",
			
			Projects	:	"components.wins.tasktodo.project.Projects",
			PrivateList	:	"components.wins.tasktodo.project.PrivateList",
			
			Calendar	:	"components.wins.tasktodo.calendar.Calendar",
			Holydays	:	"components.wins.tasktodo.calendar.Holydays",
			CalStatistic:	"components.wins.tasktodo.calendar.CalStatistic",
			
			Log			:	"components.wins.application.Log",			
			Settings	:	"components.wins.application.Settings",			
			Help		:	"components.wins.application.Help"			
		}
		
		/////классы окон/////
		private var calendar:Calendar;
		private var calstatistic:CalStatistic;
		private var holydays:Holydays;
		private var users:Users;
		private var user:User;
		private var usercard:UserCard;
		private var projects:Projects;
		private var privatelist:PrivateList;
		private var privatetaskcard:PrivateTaskCard;
		private var privatetask:PrivateTask;
		private var extmanager:ExtManager;
		private var extloader:ExtLoader;
		private var tasks:Tasks;
		private var task:Task;
		private var taskcard:TaskCard;
		private var searchtasks:SearchTasks;
		private var privatetasks:PrivateTasks;
		private var movetasks:MoveTasks;
		private var log:Log;
		private var settings:Settings;
		private var help:Help;
		/////////////////////
		
		
		public function WinManager(container:UIComponent, effects:IMDIEffectsDescriptor = null){		
			super(container, effects);
			instance = this;
			tilePadding = 0;
		}
		
		/**
		 * Открывает новое окно
		 * @param param имя класса окна
		 * @param data данные
		 * @param title заголовок окна
		 * @param w ширина
		 * @param h высота
		 * @param openMethod метод при инициализации окна
		 * 
		 */ 
		public static function addWin(name:String, data:Object = null, title:String = "", w:Number = 680, h:Number = 480, openMethod:String = "", openArgs:Array = null):void{	
			
			if(testOpened(name, data))
				return;
			
			if(name=="Task"){
				w = 480;
				h = 550;
			}		
			var ClassReference:Class = getDefinitionByName(WinManager.paths[name]) as Class; //Func.getClass(WinManager[name.toLowerCase()]);
			var win:MDIWindow = new ClassReference() as MDIWindow;
			win.minHeight = (win.minHeight < h)? h : win.minHeight;
			win.minWidth = (win.minWidth < w)? w : win.minWidth;
						
			win.data = data;		
			if(openMethod!=''){
				win.addEventListener(FlexEvent.CREATION_COMPLETE, function():void{
											Tasks(win)[openMethod](openArgs);
				})
			}
			if(title!="")
				win.title = title;
			
			if(oneWindow){
				for(var i:int = 0; i< instance.windowList.length ; i++){
					if(Func.getClass(instance.windowList[i]) == Func.getClass(win)){
						instance.bringToFront(instance.windowList[i]);
						return;
					}
				}
			}
			
			win.width = (win.minWidth < w)?w:win.minWidth//Appl.winContainer.width;
			win.height = (win.minHeight < h)?h:win.minHeight//Appl.winContainer.height;
			instance.add(win);
			win.x = (instance.windowList.length-1) * 20;
			win.y = (instance.windowList.length-1) * 20;
			win.setStyle("dropShadowVisible", false);
			//win.maximize();
			instance.updateWindowMenu();				
		}
		
		/**
		 * 	Проверяет, не открыто ли окно с задачей.
		 * 	Если открыто - переводит на него фокус, не создает новое
		 * 	@param name имя класса окна
		 * 	@param data данные окна
		 * 
		 */ 
		private static function testOpened(name:String, data:Object = null):Boolean{
			if(data!=null && (name=="TaskCard" || name=="Task")){
				for(var i:int=0; i < instance.windowList.length; i++){
					var win:MDIWindow = instance.windowList[i] as MDIWindow;						
					if(win.data != null && win.data.id_task == data.id_task){
						frontWindow(i);
						return true;
					}
				}	
			}	
			return false;
		}
		
		/**
		 * 	Закрывает одно окно, открывает другое
		 * 	@param win закрываемое окно
		 * 	@param name имя класса нового окна
		 * 	@param data данные нового окна
		 * 	@param title заголовок нового окна
		 */ 
		public static function close_open(win:MDIWindow, name:String = "", data:Object = null, title:String = ""):void{		
			instance.remove(win);
			if(name!="")
				addWin(name, data, title);
			instance.updateWindowMenu();
		}
		
		override public function remove(window:MDIWindow):void{
			super.remove(window);
			updateWindowMenu();
		}
		
		public static function frontWindow(i:int):void{
			instance.bringToFront(instance.windowList[i]);
		}
		
		private function updateWindowMenu():void{
			RootMenuManager.updateWindowMenu(windowList);
		}
		
		public static function tileWin(type:Boolean = false):void{
			if(!type)
				instance.cascade();
			else
				instance.tile();
		}
		
		public static function update(win:Object, path:String):void{		
			for(var i:int=0; i<instance.windowList.length; i++){
				if((!(win is MDIWindow) || MDIWindow(win)!=instance.windowList[i]) && getQualifiedClassName(instance.windowList[i]).search("."+path+".")>=0){
					MDIWindow(instance.windowList[i]).refresh();
				}
			}
		}
		
		public static function closeAll():void{
			for(var i:int=0; i<instance.windowList.length; i++){
				MDIWindow(instance.windowList[i]).close();
			}
		}
		
		public static function test(win:MDIWindow):void{
			instance.add(win);
			win.x = (instance.windowList.length-1) * 20;
			win.y = (instance.windowList.length-1) * 20;
			win.setStyle("dropShadowVisible", false);
			instance.updateWindowMenu();	
		}
		
		public static function updateWidget(name:String):void{		
			Appl[name].update();
		}
		
	}
}