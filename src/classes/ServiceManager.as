package classes{
	
	import flash.utils.setInterval;
	
	import mx.core.FlexGlobals;
	
	import widgets.MainButtons;
	import widgets.PrivateTasks;
	
	
	/**
	 * 	Сервисные запросы
	 */
	public class ServiceManager{
		
		private var oneTime:Boolean = true;
		
		private var mainButtons:MainButtons = FlexGlobals.topLevelApplication.mainButtons;
		private var private_tasks:PrivateTasks = FlexGlobals.topLevelApplication.private_tasks;
		private var idle:Boolean = false;
		
		public function ServiceManager(){			
			update()
			setInterval(update, 120000);
		//	setInterval(update, 2600);
		}
		
		private function update():void{
			if(!Globals.idleFactor){
				Remote.setRequest("ServiceManager", this, "refresh");
				idle = false;
			}
			else
				idleRequest();
		}
		/**
		 * не работаем
		 */
		private function idleRequest():void{
			if(!idle)
				Remote.setRequest("ServiceManager", this, "refresh", {afk:1});
			idle = true;
		}
		
		public function ServiceManager_refreshResult(result:Object):void{
			//return;
			
			if(result.data){
				if(result.data.tasks){
					NotifyManager.setTasks(result.data.tasks);
				}	
				if(result.data.info){
//					FlexGlobals.topLevelApplication.serviceInfo.data = result.data.info;
					mainButtons.data = result.data.info;
				}
				if(result.data.online){
					Globals.onlineUsers = result.data.online;
				}
				
				if(oneTime){
					private_tasks.update();
					oneTime = false;
				}				
			}
		}
	}
}