package components.utils
{
	import classes.SharedManager;
	
	import components.utils.renderers.CustomDropDownListItemRenderer;
	
	import flash.events.FocusEvent;
	
	import mx.collections.ArrayCollection;
	import mx.core.ClassFactory;
	import mx.events.FlexEvent;
	
	import spark.components.ComboBox;
	
	public class SugCombo extends ComboBox
	{
		
		private var myData:Array = [];
		
		public function SugCombo(){
			super();
			this.addEventListener(FocusEvent.FOCUS_OUT, function():void{
																updateData();
																});
			this.addEventListener(FlexEvent.INITIALIZE, setData);
			this.itemRenderer = new ClassFactory(components.utils.renderers.CustomDropDownListItemRenderer)
		}
		
		private function setData(e:FlexEvent):void{
			trace(this.id)
			if(SharedManager.getObj(this.id)!=null){
				myData = SharedManager.getObj(this.id) as Array
				this.dataProvider = new ArrayCollection(myData);
			}
		}
		
		private function updateData(s:String = ""):void{
			if(SharedManager.getObj(this.id)!=null){
				myData = SharedManager.getObj(this.id) as Array;
			}
			var txt:String = (s == "") ? super.textInput.text : s;
			var eq:Boolean = false;
			var o:Object = {label: txt};
			for(var i:int=0; i<myData.length; i++){
				if(myData[i].label == txt){
					eq = true;
					break;
				}
			}
			
			if(!eq && txt!=""){
				myData.push(o);
				myData.sort();
				SharedManager.setObj(this.id, myData);
			}
			
			this.dataProvider = new ArrayCollection(myData);
			this.selectedItem = o;
		}
		
		public function set text(s:String):void{
			updateData(s);			
		}
		public function get text():String{
			return super.textInput.text;			
		}
	}
}