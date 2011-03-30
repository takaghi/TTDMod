package classes{
	import mx.controls.Alert;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.remoting.Operation;
	import mx.rpc.remoting.RemoteObject;
	
	public class Remote	{		
		

		private static var cacheData:Object = {
												Users_getLiteList : 0,
												Users_getDepartments : 0,
												Users_getDv3 : 0,
												Projects_getLiteList : 0,
												Calendar_getStatusList : 0		
											};
		
		public function Remote(){
		}
		
		public static function login(caller:Object, param:Object = null):void{
			var ro:RemoteObject = new RemoteObject("GenericAIRDestination");
			ro.endpoint = Globals.endpoint;// "http://tasktodo.alkodesign.ru/WEBORB/weborb.php" 
			ro.source = "TTD_true.Authorization";
			ro.operations = {"login": new Operation (null,"login")};
			ro.showBusyCursor = true;
			ro.initialize();
			//use weak references so we don't need to remove the event listeners
			ro.login.addEventListener(ResultEvent.RESULT,handleComplete, false, 0, true);
			ro.login.addEventListener(FaultEvent.FAULT, handleFault, false, 0, true); 
			ro.login(param);
			
			function handleComplete(result:ResultEvent ):void{
			//	if(Remote.checkResult(result.result))
					caller.getLoginResult(result.result);
					ro.login.removeEventListener(ResultEvent.RESULT,handleComplete);
					ro.login.removeEventListener(FaultEvent.FAULT, handleFault); 
					caller = null;
					ro = null;
			} 			
			function handleFault( fault:FaultEvent ):void{  
//				caller.getLoginFault(fault.fault.faultString)
				Alert.show( "Серверная ошибка - (Authorization->login)\n" + fault.fault.faultString, "Error" );
				ro.login.removeEventListener(ResultEvent.RESULT,handleComplete);
				ro.login.removeEventListener(FaultEvent.FAULT, handleFault);
				caller = null;
				ro = null;
			}   
		}
		
		
		
		public static function setRequest(name:String, caller:Object, method:String, param:Object = null, id:* = null, dataID:* = null):void{
			
			var strMethod:String = name+"_"+method;
			var strMethodResult:String = strMethod+"Result";

			var cache:Object = cacheData[strMethod];
			if(cache && cache != 0){
				caller[strMethodResult](cache);
				return;
			}
			
			var ro:RemoteObject = new RemoteObject("GenericAIRDestination");
			ro.endpoint = Globals.endpoint;//"http://tasktodo.alkodesign.ru/WEBORB/weborb.php" 
			ro.source = "TTD_true."+name;
			ro.operations = {method: new Operation (null, method)};
			if(name!="ServiceManager")
				ro.showBusyCursor = true;
			ro.initialize();

			ro[method].addEventListener(ResultEvent.RESULT,handleComplete);
			ro[method].addEventListener(FaultEvent.FAULT, handleFault); 

			ro.getOperation(method).send(Globals.userKey, param, id);
			
			

			
			function handleComplete(result:ResultEvent ):void{
			//	if(method!="logout")
			//		return;
				
				if(checkResult(result.result)){
					if(name != "ServiceManager")
						StatusManager.setStatus(caller, Globals.methods[strMethod], param, id);
					if(dataID)
						caller[strMethodResult](result.result, dataID);
					else
						caller[strMethodResult](result.result);
					
					if((name=="Tasks" || name=="PrivateTask") && (method=="add" 
						|| method=="delete" 
						|| method =="edit" 
						|| method=="move"
						|| method=="incomplete"
						|| method=="confirmCancel"
						|| method=="cancel"
						|| method=="complete"
						|| method=="confirmComplete"
						|| method=="addComment")){				
							WinManager.update(caller, "task");
					}
					if(name=="PrivateTask" && (method=="add"
						|| method =="edit"
						|| method=="cancel"
						|| method=="complete")){				
						WinManager.updateWidget("private_tasks");
					}
					
					trace("WinManager.update",name,method)
					
					WinManager.update(caller, "application");
					if(cache!=null && cache == 0){
						cacheData[strMethod] = result.result;
					}
				}
				
				ro[method].removeEventListener(ResultEvent.RESULT,handleComplete);
				ro[method].removeEventListener(FaultEvent.FAULT, handleFault); 
				caller = null;
				ro = null;
			} 			
			function handleFault( fault:FaultEvent ):void{  
				StatusManager.setStatus(caller, Globals.methods[strMethod], param, id, fault.fault.faultString);
				Alert.show( "Серверная ошибка - ("+name+"->"+method+")\n" + fault.fault.faultString, "Error" );
				ro[method].removeEventListener(ResultEvent.RESULT,handleComplete);
				ro[method].removeEventListener(FaultEvent.FAULT, handleFault); 
				caller = null;
				ro = null;
			}   
			
			function checkResult(result:Object):Boolean{
				if(result == null){
					StatusManager.setStatus(caller, Globals.methods[strMethod], param, id, "result = null");
					Alert.show( "result = null", "Error" );
					return false;
				}
				var message:String = "";	
				if(result.messages){
					for(var i:int=0; i<result.messages.length; i++){
						var code:String = "err"+result.messages[i].code;
						message += Globals.errors[code]+"\n";
					}
					message = (message=="")? "пусто":message;
				}
				if(result.data == null){
					StatusManager.setStatus(caller, Globals.methods[strMethod], param, id, message);
					Alert.show( "!!Серверная ошибка: " + message, "Error" );
					return false;
				}
				return true;
			}
			
		}
		
		public static function clearCache():void{
			for(var name:String in cacheData){
				cacheData[name] = 0;
			}
		}
		
		
	}
}