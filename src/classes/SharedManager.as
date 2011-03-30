package classes
{
	import flash.net.SharedObject;

	public class SharedManager{
		
		private static var so:SharedObject = SharedObject.getLocal("TTDMod_SharedObject");
		
		public function SharedManager()
		{
		}
		
		public static function setObj(name:String, data:Object):void{
			so.data[name] = data;
			so.flush();
		}
		public static function getObj(name:String):Object{
			return so.data[name];
		}
		
		public static function clearObj(name:String):void{
			delete so.data[name];
		}
	}
}