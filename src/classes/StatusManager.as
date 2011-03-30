package classes
{
	import components.utils.Func;
	
	import flash.utils.getQualifiedClassName;

	public class StatusManager{
		
		private static var appl:Object;
		
		private static var logList:Array = [];
		private static var colors:Object = {ok: 0xb4d2bb, error:0xf5ac8b};
		
		public function StatusManager(appl:Object){
			StatusManager.appl = appl;
		}
		public static function setStatus(module:Object, action:String, param:Object=null, id:*=null, error:String = ""):void{
			StatusManager.appl.status = action;
			var paramString:String = "";
			if(id){
				paramString += "id: " + id + "\n";
			}
			if(param){				
				for(var key:String in param){
					if(param[key]!="")
						paramString += key + ": " + param[key]+ "\n";
				}
			}
			var o:Object = { 
								time: Func.getLogTime(new Date()),
								module: getQualifiedClassName(module),
								action: action,
								param: paramString,
								error: error,
								color: (error=="")?colors["ok"]:colors["error"]
							}
			StatusManager.logList.unshift(o);
		}
		
		public static function getLog():Object{
			return {log: StatusManager.logList};
		}
	}
}