package classes.sockets
{
	
	import flash.net.ServerSocket;
	import flash.utils.ByteArray;
	
	
	public class ClientManager{
		
		private static var client:SocketClient; 
		private static var log:String;
		
		private static var server:String;
		private static var port:String;
		
		
		public function ClientManager()	{
			connect();
		}
		
		private static function connect():void	{
			client = new SocketClient("localhost", 1235);
		}
		
		public static function send(o:Object, ip:String):void{	
			client = new SocketClient(ip, 1235);
			trace(ip)
			var bytes:ByteArray = new ByteArray();
			//		bytes.writeUTFBytes(command.text + "\n");
			bytes.writeObject(o);
			if (ClientManager.client != null)	{
				trace("Writing to socket");
				ClientManager.client.writeToSocket(bytes);
			}
			else{    				
				ClientManager.connect();
			}			
		}
	/*	public static function send(server:String, port:String, o:Object):void{
			if(!client)
				ClientManager.client = new SocketClient("localhost", 1235);
			
			var bytes:ByteArray = new ByteArray();
	//		bytes.writeUTFBytes(command.text + "\n");
			bytes.writeObject(o);
			if (ClientManager.client != null)	{
				trace("Writing to socket");
				ClientManager.client.writeToSocket(bytes);
			}
			else{    				
				ClientManager.connect();
				ClientManager.send("localhost", port, o)
			}			
		}*/
		
		
	}
}