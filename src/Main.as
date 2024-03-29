package{	
	
	import classes.NotifyManager;
	import classes.Remote;
	import classes.RootMenuManager;
	import classes.ServiceManager;
	import classes.SettingManager;
	import classes.StatusManager;
	import classes.WinManager;
	import classes.sockets.ClientManager;
	import classes.sockets.ServerManager;
	
	import components.LoginForm;
	
	import flash.events.Event;
	import flash.net.ServerSocket;
	
	import mx.core.FlexGlobals;
	
	public class Main{			
		
		private var Appl:Object = FlexGlobals.topLevelApplication;	
		private var server:ServerSocket;
		private var client:ClientManager;
				
		public function Main(){
			new WinManager(Appl.winContainer);
			new SettingManager();
			
			new LoginForm().show();
			
	//		new RootMenuManager();
	//отключить
	//		Remote.Vars(this, "getList");
			
			new NotifyManager();	
		//	server = new ServerManager();
		//	client = new ClientManager();
			
		}		
		
		/**
		 * Устанавливает пользователя в системе, настраивает меню в зависимости от прав
		 * @param key персональный ключ пользователя(session ID)
		 * @param id_staff ID пользователя в базе
		 * @param access права пользователя
		 * 
		 */
		public function setUser(key:String, id_staff:String, access:Object):void{	
			Globals.userKey = key;
			Globals.id_staff = id_staff;
			Globals.access = access;
			new RootMenuManager();
			Remote.setRequest("Vars", this, "getList");
			new ServiceManager();
			
			Appl.winContainer.visible = true;
		}

		
		public function Vars_getListResult(result:Object):void{
			if(result.data){
				Globals.vars = result.data;
			}else{
				if(result.messages.length>0){
				//	Alert.show( "Server reported an error - " + result.messages[0].text, "Error" );
				}
			}			
		}
		
		public function showLog(e:Event=null):void{
			WinManager.addWin("Log", StatusManager.getLog(), "Sheldon's log", 600, 400);
		}
		public function updateLog():Object{
			return StatusManager.getLog();
		}
		
		public function exit():void{
			Remote.setRequest("Authorization", this, "logout1");
		}
	}
}