package classes
{
	import components.utils.UserDropDownList;
	import components.utils.interfaces.INotifyForm;
	import components.wins.application.messages.ChatWindow;
	import components.wins.application.messages.MessageForm;
	import components.wins.tasktodo.task.additions.NotifyForm;
	import components.wins.tasktodo.task.additions.NotifyPrivateForm;
	
	import flash.display.DisplayObject;
	import flash.display.NativeWindowSystemChrome;
	import flash.display.NativeWindowType;
	import flash.display.Screen;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.clearTimeout;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	
	import mx.core.FlexGlobals;
	import mx.core.UIComponent;
	import mx.core.Window;
	import mx.events.EffectEvent;
	import mx.events.FlexEvent;
	
	import spark.components.Button;
	import spark.effects.Fade;
	import spark.events.IndexChangeEvent;

	public class NotifyManager{
		
		private static var instance:NotifyManager;
		private static var Appl:Object = FlexGlobals.topLevelApplication;
		/**
		 *	Счетчик окон
		 */ 
		private static var notifyCount:int = 0;	
		
		private static var chatWindow:ChatWindow;		
		
		private static var fadeIn:Fade = new Fade();
		private static var fadeOut:Fade = new Fade();
		
		private static var visibleBounds:Rectangle;
		
		/**
		 *	Координаты всплывающего окна
		 */  
		private static var point:Point = new Point();
		/**
		 *	Счетчик окон по двум направлениям
		 */ 
		private static var notifyCountXY:Point = new Point(1, 1);
		
		public function NotifyManager()	{
			
			instance = this;
			visibleBounds = Screen.mainScreen.visibleBounds;
			initFade();
			
			var param:Object = {event_type: "345", status_alias: "task_incomplete", priority: 0, urgency: 0, id_project_text: "test project", id_staff_owner_text: "owner", name: "private function setNotify(idTask:String, project:String, taskOwner:String, dsc:String):void{"}
	/*		var param2:Object = {event_type: "345", priority: 1, urgency: 0, id_project_text: "test project", id_staff_owner_text: "owner", name: "private function setNotify(idTask:String, project:String, taskOwner:String, dsc:String):void{"}
			var param3:Object = {event_type: "345", priority: 0, urgency: 1, id_project_text: "test project", id_staff_owner_text: "owner", name: "private function setNotify(idTask:String, project:String, taskOwner:String, dsc:String):void{"}
			var param4:Object = {event_type: "345", priority: 1, urgency: 1, id_project_text: "test project", id_staff_owner_text: "owner", status_alias: "task_impossible"}
			var param5:Object = {event_type: "345", priority: 0, urgency: 0, id_project_text: "test project", id_staff_owner_text: "owner", status_alias: "task_complete"}
	*/	
						
		//	setInterval(function():void{setNotifyTask(param)},2000);
		//	setNotifyTask(param)

		}
		
		private static function initFade():void{
			fadeIn.alphaFrom = 0;
			fadeIn.alphaTo = 1;
			fadeIn.duration = 1000;	
			
			fadeOut.alphaFrom = 1;
			fadeOut.alphaTo = 0;
			fadeOut.duration = 300;
			fadeOut.addEventListener(EffectEvent.EFFECT_END, fadeOutEnd);
		}
		
		/**
		 * 	Добавление оповещений о задаче
		 */ 
		public static function setTasks(tasks:Array):void{			
			var i:int = tasks.length; 			
			while (--i > -1){ 
				setNotifyTask(tasks[i]);
			} 
		}
		
		public static function setNotifyMessage(data:Object):void{
				setNotify(new MessageForm(), data);
		}			
		
		public static function setNotifyTask(data:Object):void{		
			if(data.type != "private_task")
				setNotify(new NotifyForm(), data);
			else
				setNotify(new NotifyPrivateForm(), data);
		}	
		
		private static function setNotify(form:INotifyForm, data:Object):void{
			UIComponent(form).initialize();
	//		UIComponent(form).addEventListener(FlexEvent.CREATION_COMPLETE, showMe, false, 0, true);
			form.data = data;
			
			var width:Number = DisplayObject(form).width;
			var height:Number = DisplayObject(form).height;	
		
			point.x = visibleBounds.width - width*notifyCountXY.x;
			point.y = visibleBounds.height - height*notifyCountXY.y;
			
			if(point.y < 0){
				notifyCountXY.x++;
				notifyCountXY.y = 1;
				point.x = visibleBounds.width - width*notifyCountXY.x;
				point.y = visibleBounds.height - height*notifyCountXY.y;
			}
				
			var bounds:Rectangle = new Rectangle(
				point.x,
				point.y,
				width,
				height
			);
			
			var win:Window = new Window();
			win.width = width;
			win.height = height;
			win.setStyle("showFlexChrome", false);
			
			win.type = NativeWindowType.LIGHTWEIGHT;
			win.systemChrome = NativeWindowSystemChrome.NONE;
			//		win.systemChrome = NativeWindowSystemChrome.STANDARD;
			win.alwaysInFront = true;
			win.maximizable = false; 
			win.minimizable = false; 
			win.resizable = false;
			win.showStatusBar = false;
			win.transparent = true;			
			
			
			win.data = data;
			
			if(form is MessageForm)				
				win.addEventListener(MouseEvent.CLICK, openNotifyMessage, false, 0, true);
			else
				win.addEventListener(MouseEvent.CLICK, openNotifyTask, false, 0, true);
			
			win.addEventListener(MouseEvent.CONTEXT_MENU, closeNotify, false, 0, true);
			
			win.addChild(form as DisplayObject);	

			win.open(false);
			win.nativeWindow.bounds = bounds;				
			
			//win.activate();
			notifyCountXY.y++;				
			notifyCount++;
			
			fadeIn.play([form]);
		}

		private static function openNotifyTask(e:MouseEvent):void{	
			var win:Window = e.currentTarget as Window;
			var item:Object = Window(e.currentTarget).data;
			var winTitle:String = "Задача: " + item.id_task;
			
	//		closeNotify(null, win);	return
			
			if(item.type != "private_task"){		
				closeNotify(null, win);				
				Appl.stage.nativeWindow.visible = true;
				Appl.stage.nativeWindow.activate();
				WinManager.addWin("TaskCard", item, winTitle);
			}
			else{
				if(e.target.id && e.target.id=="ok"){
					var param:Object = {time:UserDropDownList(NotifyPrivateForm(win.getChildAt(0)).time).selectedItem.value};
					Remote.setRequest("PrivateTask", instance, "delay", param, item.id_private_task);
					closeNotify(null, win);				
					Appl.stage.nativeWindow.visible = true;
					Appl.stage.nativeWindow.activate();
				}else if(e.target.parent.parent is UserDropDownList){
					var ddl:UserDropDownList = e.target.parent.parent;
					ddl.openDropDown();
				}else{																				
					closeNotify(null, win);				
					Appl.stage.nativeWindow.visible = true;
					Appl.stage.nativeWindow.activate();
					WinManager.addWin("PrivateTaskCard", item, winTitle);
				}
			}
		}
		
		
		private static function openNotifyMessage(e:MouseEvent):void{
			var item:Object = Window(e.currentTarget).data;
			closeNotify(e);
			NotifyManager.openChatWindow();
		}
		
		private static function closeNotify(e:MouseEvent = null, win0:Window = null):void{
			var win:Window;
			if(e != null)
				win = e.currentTarget as Window;
			else
				win = win0;
			
			fadeOut.play([win.getChildAt(0)]);
		}
		
		private static function fadeOutEnd(e:EffectEvent):void{
			trueCloseNotify(e.effectInstance.target.parent as Window);
		}
		
		private static function trueCloseNotify(win:Window):void{
		//	win.removeAllChildren();
			setTimeout(function():void{win.close();win=null},100);	
			
			notifyCount--;
			
			if(notifyCount == 0)
				notifyCountXY = new Point(1, 1);
		}	
		
		public static function openChatWindow():void{	
			if(chatWindow!=null)
				return;
			
			chatWindow = new ChatWindow();
			chatWindow.addEventListener(Event.CLOSE, onCloseChat, false, 0, true);
			chatWindow.setStyle("showFlexChrome", false);
			
			chatWindow.type = NativeWindowType.NORMAL;
			chatWindow.systemChrome = NativeWindowSystemChrome.STANDARD;
		//	win.systemChrome = NativeWindowSystemChrome.STANDARD;
			chatWindow.alwaysInFront = false;
		//	win.maximizable = false; 
		//	win.minimizable = false; 
		//	win.resizable = false;
			chatWindow.showStatusBar = false;
		//	win.transparent = true;			
			chatWindow.focusEnabled = false;	
			chatWindow.open(false);			
			chatWindow.activate();			
		}
		
		private static function onCloseChat(e:Event):void{
			chatWindow = null;
			trace("chatWindow close");
		}		
	}
}