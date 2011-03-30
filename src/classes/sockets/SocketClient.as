package classes.sockets{
	
		import flash.events.ErrorEvent;
		import flash.events.Event;
		import flash.events.IOErrorEvent;
		import flash.events.ProgressEvent;
		import flash.events.SecurityErrorEvent;
		import flash.net.ServerSocket;
		import flash.net.Socket;
		import flash.utils.ByteArray;
		
		import mx.controls.Alert;
		
		import spark.components.TextArea;
		
		public class SocketClient extends Socket{
			private var serverURL:String;
			private var portNumber:int;
			private var state:int = 0;
			
			
			public function SocketClient(host:String = null, port:uint = 0){
				super();
				serverURL = host;
				portNumber = port;
				
				configureListeners();
				if (host && port)  {
					super.connect(host, port);
				}				
			}
			
			private function configureListeners():void {
				addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
				addEventListener(Event.CONNECT, connectHandler);
				addEventListener(Event.CLOSE, closeHandler);
				addEventListener(ErrorEvent.ERROR, errorHandler);
				addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
				addEventListener(ProgressEvent.SOCKET_DATA, dataHandler);
			}
			
			public function closeSocket():void{
				try {
					flush();
					close();
				}
				catch (error:Error){
					trace(error.message);
				}
			}
			
			public function writeToSocket(ba:ByteArray):void{
				try {
					writeBytes(ba);
					flush();
				}
				catch (error:Error){
					trace(error.message);
					
				}
			}
			
			
			public function connectHandler(e:Event):void{
				trace("Socket Connected");
			}
			
			public function closeHandler(e:Event):void	{
				trace("Socket Closed" );
				new ClientManager();
		//		new ServerManager();
			}
			
			public function errorHandler(e:ErrorEvent):void	{
				trace("Error " + e.text);
			}
			
			public function ioErrorHandler(e:IOErrorEvent):void	{
				trace("IO Error " + e.text + " check to make sure the socket server is running.");
			}
			private function securityErrorHandler(event:SecurityErrorEvent):void {
				trace("securityErrorHandler: " + event);
			}
			
			public function dataHandler(e:ProgressEvent):void{
				trace("Data Received - total bytes " +e.bytesTotal + " ");
				var bytes:ByteArray = new ByteArray();
				readBytes(bytes);
				trace("Bytes received " + bytes);
				trace(bytes);
			}
		}
	}