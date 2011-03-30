package classes.sockets
{
	import classes.NotifyManager;
	
	import components.wins.application.messages.ChatWindow;
	
	import flash.net.ServerSocket;

	public class ServerManager extends ServerSocket{
		
		import flash.events.Event;
		import flash.events.MouseEvent;
		import flash.events.ProgressEvent;
		import flash.events.ServerSocketConnectEvent;
		import flash.net.ServerSocket;
		import flash.net.Socket;
		import flash.utils.ByteArray;
		
		import mx.controls.Alert;
				
		private var port:Number = 1235;
		
		public function ServerManager()	{
			addEventListener(Event.CONNECT, socketConnectHandler);
			addEventListener(Event.CLOSE,socketCloseHandler);
			addEventListener(ServerSocketConnectEvent.CONNECT, socketConnectHandler);
			bind(port);
			listen();  
			trace("Listening on port " + port + "...\n");
//			new ClientManager();
		}
		
		private function socketConnectHandler(event:ServerSocketConnectEvent):void	{
			var socket:Socket = event.socket;
			trace("Socket connection established on port " + port );
			socket.addEventListener(ProgressEvent.SOCKET_DATA, socketDataHandler);
		}
		
		private function socketDataHandler(event:ProgressEvent):void{	trace(11)
			try	{
				var socket:Socket = event.target as Socket;
		//		var bytes:ByteArray = new ByteArray();
		//		socket.readBytes(bytes);
				var o:Object = socket.readObject();
			//	log.text += ""+bytes;
				socket.flush();
		//		NotifyManager.setNotifyMessage({dsc:bytes});
				NotifyManager.setNotifyMessage(o);
				ChatWindow.addMessage(o, true);
			}
			catch (error:Error)	{
				Alert.show(error.message, "Error");
			}
		}
		
		protected function socketCloseHandler(e:Event):void	{
			trace("Socket Closed!!!");
		}

	}
}