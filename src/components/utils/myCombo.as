package components.utils
{
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import mx.collections.ArrayCollection;
	import mx.core.mx_internal;
	
	import spark.components.ComboBox;
	import spark.events.TextOperationEvent;
	
	use namespace mx_internal
	
	public class myCombo extends ComboBox
	{
		
		private var ti:String = "";		
		
		public function myCombo(){
			super();			
		}
		

	/*	override protected function textInput_changeHandler(event:TextOperationEvent):void{  
			ti = super.textInput.text;
			super.textInput_changeHandler(event);
			super.textInput.text = ti;
			super.textInput.selectRange(ti.length, ti.length);
			
			if(findMatchingItems(ti).length > 0){
		//		trace("yes")
		//		super.textInput.setStyle("backgroundColor", 0xffffff);
		//		super.textInput.setStyle("color", 0x000000);
		//		this.openDropDown();				
			}else{
		//		trace("no")
		//		super.textInput.setStyle("backgroundColor", 0xff0000);
		//		super.textInput.setStyle("color", 0xffffff);				
		//		this.closeDropDown(true);
		//		super.textInput.setFocus();
			} 

		}*/
		override mx_internal function keyDownHandlerHelper(event:KeyboardEvent):void{			
			if (event.keyCode != Keyboard.HOME && event.keyCode != Keyboard.END ){
				super.keyDownHandler(event);
			}			
		}
		
		private function findMatchingItems(input:String):Vector.<int>{
			// For now, just select the first match
			var startIndex:int;
			var stopIndex:int;
			var retVal:int;  
			var retVector:Vector.<int> = new Vector.<int>;
			
			retVal = findStringLoop(input, 0, dataProvider.length); 
			
			if (retVal != -1)
				retVector.push(retVal);
			return retVector;
		}
		
	}
}