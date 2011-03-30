package components.utils
{
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	
	import mx.controls.DataGrid;
	import mx.controls.listClasses.ListBaseContentHolder;
	import mx.core.FlexShape;
	
	public class CustomDataGrid extends DataGrid{
		
		public var customRowBackground:Boolean = false;
		
		
		public function CustomDataGrid(){
			super();
		}	
    

		override protected function drawRowBackground(s:Sprite, rowIndex:int, y:Number, height:Number, color:uint, dataIndex:int):void{ 
			if(!customRowBackground){
				super.drawRowBackground(s, rowIndex, y, height, color, dataIndex);
				return;
			}
			var contentHolder:ListBaseContentHolder = ListBaseContentHolder(s.parent);              
			var background:Shape;             
			if (rowIndex < s.numChildren){
				background = Shape(s.getChildAt(rowIndex));
			}else{
				background = new FlexShape();
				background.name = "background";
				s.addChild(background);
			}
			
			background.y = y;
			
			// Height is usually as tall is the items in the row, but not if
			// it would extend below the bottom of listContent
			var height:Number = Math.min(height, contentHolder.height - y);
			
			var g:Graphics = background.graphics;
			g.clear();
			
			var color2:uint;
			if(this.dataProvider && dataIndex < this.dataProvider.length){
				if(this.dataProvider.getItemAt(dataIndex).color){
					color2 = this.dataProvider.getItemAt(dataIndex).color;
				}
				else{
					color2 = 0xffffff;//color;
				}
			}
			else{
				color2 = 0xffffff;
			}
			g.beginFill(color2, getStyle("backgroundAlpha"));
			g.drawRect(0, 0, contentHolder.width, height);
			g.endFill();
		}		
	}
}



