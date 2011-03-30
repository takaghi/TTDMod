package components.utils
{
	import mx.containers.VBox;
	import mx.core.UITextField;
	
	[Bindable]
	public class DragProxyContainer extends VBox
	{
		private var textField:UITextField = new UITextField();
		
		public function DragProxyContainer()
		{
			super();
			
			minWidth = 150;
			
			addChild(textField);
		}
		
		public function setLabelText(items:Array, labelField:String = "label"):void
		{
			var labelText:String;
			
			var numItems:int = items.length;
			
			if (numItems > 1)
			{
				labelText = numItems.toString() + " items";
			}
			else
			{
				var firstItem:Object = items[0];
				
				labelText = firstItem[labelField];
			}
			
			textField.text = labelText;
		}
	}
}