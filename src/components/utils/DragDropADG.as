package components.utils
{
		import flash.geom.Point;
		
		import mx.controls.AdvancedDataGrid;
		import mx.controls.listClasses.IListItemRenderer;
		import mx.core.DragSource;
		import mx.events.DragEvent;
		import mx.managers.DragManager;
		import mx.utils.ObjectUtil;
		
		public class DragDropADG extends AdvancedDataGrid
		{
			private var itemRendererUnderPoint:IListItemRenderer
			
			public function DragDropADG()
			{
				super();
			}
			
			override protected function dragStartHandler(event:DragEvent):void
			{
				/* Create a new Array from the Array of selectedItems, filtering out items 
				that are not "branches". */
				var selectedBranches:Array /* of Object */ = 
					selectedItems.filter(hasCategories);
				
				function hasCategories(element:*, index:int, array:Array):Boolean
				{
					
					for(var s:String in element)
						trace(s)
					
					/* Returns true if the item is a Branch (has children in the categories 
					property). */
					return (element.hasOwnProperty("day") && element.day != null);
				}
				
				/* Exit if no Branches are selected. This will stop the drag operation from 
				starting. */
				if (selectedBranches.length == 0)
					return;
				
				/* Reset the selectedItems Array to include only selected Branches. This 
				will deselect any "non-Branch" items. */
				selectedItems = selectedBranches;
				
				/* Create a copy of the Array of selected indices to be sorted for 
				display in the drag proxy. */
				var sortedSelectedIndices:Array /* of int */ = 
					ObjectUtil.copy(selectedIndices) as Array /* of int */;
				
				// Sort the selected indices
				sortedSelectedIndices.sort(Array.NUMERIC);
				
				/* Create an new Array to store the selected Branch items sorted in the 
				order that they are displayed in the AdvancedDataGrid. */
				var draggedBranches:Array = [];
				
				var itemRendererAtIndex:IListItemRenderer;
				
				for each (var index:int in sortedSelectedIndices)
				{
					itemRendererAtIndex = indexToItemRenderer(index);
					
					var branchItem:Object = itemRendererAtIndex.data;
					
					draggedBranches.push(branchItem);
				}
				
				// Create a new DragSource Object to store data about the Drag operation.
				var dragSource:DragSource = new DragSource();
				
				// Add the Array of Branches to be dragged to the DragSource Object.
				dragSource.addData(draggedBranches, "draggedBranches");
				
				// Create a new Container to serve as the Drag Proxy.
				var dragProxy:DragProxyContainer = new DragProxyContainer();
				
				/* Update the labels in the Drag Proxy using the "label" field of the items 
				being dragged. */
				dragProxy.setLabelText(draggedBranches);
				
				/* Create a point relative to this component from the mouse 
				cursor location (for the DragEvent). */
				var eventPoint:Point = new Point(event.localX, event.localY);
				
				// Initiate the Drag Event
				DragManager.doDrag(this, dragSource, event, dragProxy, -eventPoint.x, -eventPoint.y, 0.8);
			}
			
			/* This function runs when ANY item is dragged over any part of this 
			AdvancedDataGrid (even if the item is from another component). */
			override protected function dragEnterHandler(event:DragEvent):void{
				/* If the item(s) being dragged does/do not contain dragged Branches, 
				it/they are being dragged from another component; exit the function to 
				prevent a drop from occurring. */
				if (!event.dragSource.hasFormat("draggedBranches"))
					return;
				
				var dropIndex:int = calculateDropIndex(event);
				
				/* Get the itemRenderer of the current drag target, to determine if the 
				drag target can accept a drop. */
				var dropTargetItemRenderer:IListItemRenderer = indexToItemRenderer(dropIndex);
				
				/* If the item is being dragged where there is no itemRenderer, exit the 
				function, to prevent a drop from occurring. */ 
				if (dropTargetItemRenderer == null)
					return;
				
				/* If the item is being dragged onto an itemRenderer with no data, exit the 
				function, to prevent a drop from occurring. */ 
				if (dropTargetItemRenderer.data == null)
					return;
				
				/* Store the underlying item for the itemRenderer being dragged over, to 
				validate that it can be dropped there. */
				var dragEnterItem:Object = dropTargetItemRenderer.data
				
				if (!dragEnterItem.hasOwnProperty("day"))
					return;
					
				if (dragEnterItem.day == null)
					return;
				
				var eventDragSource:DragSource = event.dragSource;
				
				eventDragSource.addData(dragEnterItem, "dropTargetItem");
				
				/* Add an dragDrop Event Listener to the itemRenderer so that the 
				necessary will run when it is dropped.*/
				dropTargetItemRenderer.addEventListener(DragEvent.DRAG_DROP, itemRenderer_dragDropHandler);
				
				// Specify that the itemRenderer being dragged over can accept a drop.
				DragManager.acceptDragDrop(dropTargetItemRenderer);
			}
			
			/* Perform any logic that you want to occur once the user drops the item. */
			private function itemRenderer_dragDropHandler(event:DragEvent):void
			{
				var eventDragSource:DragSource = event.dragSource;
				
				var dropTargetItem:Object = eventDragSource.dataForFormat("dropTargetItem");
				
				if (dropTargetItem == null)
					return;
				
				var draggedBranchesData:Object = eventDragSource.dataForFormat("draggedBranches");
				
				var draggedBranches:Array /* of Object */ = 
					draggedBranchesData as Array /* of Object */;
				
				// Call any other functions to update your underlying data, etc.
				
				trace("itemRenderer_dragDropHandler")
			}
		}
}