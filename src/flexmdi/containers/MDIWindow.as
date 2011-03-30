/*
Copyright (c) 2007 FlexMDI Contributors.  See:
    http://code.google.com/p/flexmdi/wiki/ProjectContributors

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

package flexmdi.containers
{
	import components.utils.skins.borderBottom;
	import components.utils.winTitle;
	
	import flash.display.DisplayObject;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.utils.getQualifiedClassName;
	
	import flexmdi.events.MDIWindowEvent;
	import flexmdi.managers.MDIManager;
	
	import mx.containers.Canvas;
	import mx.containers.Panel;
	import mx.controls.Button;
	import mx.controls.Label;
	import mx.core.Container;
	import mx.core.FlexGlobals;
	import mx.core.UIComponent;
	import mx.core.UITextField;
	import mx.core.mx_internal;
	import mx.managers.CursorManager;
	import mx.styles.CSSStyleDeclaration;
	import mx.styles.StyleManager;
	
	import spark.components.BorderContainer;
	
	
	
	//--------------------------------------
	//  Events
	//--------------------------------------

	/**
	 *  Dispatched when the minimize button is clicked.
	 *
	 *  @eventType flexmdi.events.MDIWindowEvent.MINIMIZE
	 */
	[Event(name="addedToManager", type="flexmdi.events.MDIWindowEvent")]	

	/**
	 *  Dispatched when the minimize button is clicked.
	 *
	 *  @eventType flexmdi.events.MDIWindowEvent.MINIMIZE
	 */
	[Event(name="refresh", type="flexmdi.events.MDIWindowEvent")]	
	
	/**
	 *  Dispatched when the minimize button is clicked.
	 *
	 *  @eventType flexmdi.events.MDIWindowEvent.MINIMIZE
	 */
	[Event(name="minimize", type="flexmdi.events.MDIWindowEvent")]
	
	/**
	 *  If the window is minimized, this event is dispatched when the titleBar is clicked. 
	 * 	If the window is maxmimized, this event is dispatched upon clicking the restore button
	 *  or double clicking the titleBar.
	 *
	 *  @eventType flexmdi.events.MDIWindowEvent.RESTORE
	 */
	[Event(name="restore", type="flexmdi.events.MDIWindowEvent")]
	
	/**
	 *  Dispatched when the maximize button is clicked or when the window is in a
	 *  normal state (not minimized or maximized) and the titleBar is double clicked.
	 *
	 *  @eventType flexmdi.events.MDIWindowEvent.MAXIMIZE
	 */
	[Event(name="maximize", type="flexmdi.events.MDIWindowEvent")]
	
	/**
	 *  Dispatched when the close button is clicked.
	 *
	 *  @eventType flexmdi.events.MDIWindowEvent.CLOSE
	 */
	[Event(name="close", type="flexmdi.events.MDIWindowEvent")]
	
	/**
	 *  Dispatched when the window gains focus and is given topmost z-index of MDIManager's children.
	 *
	 *  @eventType flexmdi.events.MDIWindowEvent.FOCUS_START
	 */
	[Event(name="focusStart", type="flexmdi.events.MDIWindowEvent")]
	
	/**
	 *  Dispatched when the window loses focus and no longer has topmost z-index of MDIManager's children.
	 *
	 *  @eventType flexmdi.events.MDIWindowEvent.FOCUS_END
	 */
	[Event(name="focusEnd", type="flexmdi.events.MDIWindowEvent")]
	
	/**
	 *  Dispatched when the window starts being dragged.
	 *
	 *  @eventType flexmdi.events.MDIWindowEvent.DRAG_START
	 */
	[Event(name="dragStart", type="flexmdi.events.MDIWindowEvent")]
	
	/**
	 *  Dispatched while the window is being dragged.
	 *
	 *  @eventType flexmdi.events.MDIWindowEvent.DRAG
	 */
	[Event(name="drag", type="flexmdi.events.MDIWindowEvent")]
	
	/**
	 *  Dispatched when the window stops being dragged.
	 *
	 *  @eventType flexmdi.events.MDIWindowEvent.DRAG_END
	 */
	[Event(name="dragEnd", type="flexmdi.events.MDIWindowEvent")]
	
	/**
	 *  Dispatched when a resize handle is pressed.
	 *
	 *  @eventType flexmdi.events.MDIWindowEvent.RESIZE_START
	 */
	[Event(name="resizeStart", type="flexmdi.events.MDIWindowEvent")]
	
	/**
	 *  Dispatched while the mouse is down on a resize handle.
	 *
	 *  @eventType flexmdi.events.MDIWindowEvent.RESIZE
	 */
	[Event(name="resize", type="flexmdi.events.MDIWindowEvent")]
	
	/**
	 *  Dispatched when the mouse is released from a resize handle.
	 *
	 *  @eventType flexmdi.events.MDIWindowEvent.RESIZE_END
	 */
	[Event(name="resizeEnd", type="flexmdi.events.MDIWindowEvent")]
	
	
	//--------------------------------------
	//  Skins + Styles
	//--------------------------------------
	
	/**
	 *  Style declaration name for the window when it has focus.
	 *
	 *  @default "mdiWindowFocus"
	 */
	[Style(name="styleNameFocus", type="String", inherit="no")]
	
	/**
	 *  Style declaration name for the window when it does not have focus.
	 *
	 *  @default "mdiWindowNoFocus"
	 */
	[Style(name="styleNameNoFocus", type="String", inherit="no")]
	
	/**
	 *  Style declaration name for the text in the title bar
	 * 	when the window is in focus. If <code>titleStyleName</code> (inherited from Panel)
	 *  is set, titleStyleNameFocus will be overridden by it.
	 *
	 *  @default "mdiWindowTitleStyle"
	 */
	[Style(name="titleStyleNameFocus", type="String", inherit="no")]
	
	/**
	 *  Style declaration name for the text in the title bar
	 * 	when the window is not in focus. If <code>titleStyleName</code> (inherited from Panel)
	 *  is set, <code>titleStyleNameNoFocus</code> will be overridden by it.
	 *  If <code>titleStyleNameNoFocus</code> is not set but <code>titleStyleNameFocus</code>
	 *  is, <code>titleStyleNameFocus</code> will be used, regardless of the window's focus state.
	 */
	[Style(name="titleStyleNameNoFocus", type="String", inherit="no")]
	
	/**
	 *  Reference to class that will contain window control buttons like
	 *  minimize, close, etc. Changes to this style will be detected and will
	 *  initiate the instantiation and addition of a new class instance.
	 *
	 *  @default flexmdi.containers.MDIWindowControlsContainer
	 */
	[Style(name="windowControlsClass", type="Class", inherit="no")]

	/**
	 *  Style declaration name for the window's refresh button.
	 *  If <code>minimizeBtnStyleNameNoFocus</code> is not provided this style
	 *  will be used regardless of the window's focus. If <code>minimizeBtnStyleNameNoFocus</code>
	 *  is provided this style will be applied only when the window has focus.
	 *
	 *  @default "mdiWindowMinimizeBtn"
	 */
	[Style(name="refreshBtnStyleName", type="String", inherit="no")]
	
	/**
	 *  Style declaration name for the window's minimize button when window does not have focus.
	 *  See <code>minimizeBtnStyleName</code> documentation for details.
	 */
	[Style(name="refreshBtnStyleNameNoFocus", type="String", inherit="no")]
	

	
	/**
	 *  Style declaration name for the window's minimize button.
	 *  If <code>minimizeBtnStyleNameNoFocus</code> is not provided this style
	 *  will be used regardless of the window's focus. If <code>minimizeBtnStyleNameNoFocus</code>
	 *  is provided this style will be applied only when the window has focus.
	 *
	 *  @default "mdiWindowMinimizeBtn"
	 */
	[Style(name="minimizeBtnStyleName", type="String", inherit="no")]
	
	/**
	 *  Style declaration name for the window's minimize button when window does not have focus.
	 *  See <code>minimizeBtnStyleName</code> documentation for details.
	 */
	[Style(name="minimizeBtnStyleNameNoFocus", type="String", inherit="no")]
	
	/**
	 *  Style declaration name for the window's maximize button.
	 *  If <code>maximizeBtnStyleNameNoFocus</code> is not provided this style
	 *  will be used regardless of the window's focus. If <code>maximizeBtnStyleNameNoFocus</code>
	 *  is provided this style will be applied only when the window has focus.
	 *
	 *  @default "mdiWindowMaximizeBtn"
	 */
	[Style(name="maximizeBtnStyleName", type="String", inherit="no")]
	
	/**
	 *  Style declaration name for the window's maximize button when window does not have focus.
	 *  See <code>maximizeBtnStyleName</code> documentation for details.
	 */
	[Style(name="maximizeBtnStyleNameNoFocus", type="String", inherit="no")]
	
	/**
	 *  Style declaration name for the window's restore button.
	 *  If <code>restoreBtnStyleNameNoFocus</code> is not provided this style
	 *  will be used regardless of the window's focus. If <code>restoreBtnStyleNameNoFocus</code>
	 *  is provided this style will be applied only when the window has focus.
	 *
	 *  @default "mdiWindowRestoreBtn"
	 */
	[Style(name="restoreBtnStyleName", type="String", inherit="no")]
	
	/**
	 *  Style declaration name for the window's restore button when window does not have focus.
	 *  See <code>restoreBtnStyleName</code> documentation for details.
	 */
	[Style(name="restoreBtnStyleNameNoFocus", type="String", inherit="no")]
	
	/**
	 *  Style declaration name for the window's close button.
	 *  If <code>closeBtnStyleNameNoFocus</code> is not provided this style
	 *  will be used regardless of the window's focus. If <code>closeBtnStyleNameNoFocus</code>
	 *  is provided this style will be applied only when the window has focus.
	 *
	 *  @default "mdiWindowCloseBtn"
	 */
	[Style(name="closeBtnStyleName", type="String", inherit="no")]
	
	/**
	 *  Style declaration name for the window's close button when window does not have focus.
	 *  See <code>closeBtnStyleName</code> documentation for details.
	 */
	[Style(name="closeBtnStyleNameNoFocus", type="String", inherit="no")]
	
	
	/**
	 *  Name of the class used as cursor when resizing the window horizontally.
	 */
	[Style(name="resizeCursorHorizontalSkin", type="Class", inherit="no")]
	
	/**
	 *  Distance to horizontally offset resizeCursorHorizontalSkin.
	 */
	[Style(name="resizeCursorHorizontalXOffset", type="Number", inherit="no")]
	
	/**
	 *  Distance to vertically offset resizeCursorHorizontalSkin.
	 */
	[Style(name="resizeCursorHorizontalYOffset", type="Number", inherit="no")]
	
	
	/**
	 *  Name of the class used as cursor when resizing the window vertically.
	 */
	[Style(name="resizeCursorVerticalSkin", type="Class", inherit="no")]
	
	/**
	 *  Distance to horizontally offset resizeCursorVerticalSkin.
	 */
	[Style(name="resizeCursorVerticalXOffset", type="Number", inherit="no")]
	
	/**
	 *  Distance to vertically offset resizeCursorVerticalSkin.
	 */
	[Style(name="resizeCursorVerticalYOffset", type="Number", inherit="no")]
	
	
	/**
	 *  Name of the class used as cursor when resizing from top left or bottom right corner.
	 */
	[Style(name="resizeCursorTopLeftBottomRightSkin", type="Class", inherit="no")]
	
	/**
	 *  Distance to horizontally offset resizeCursorTopLeftBottomRightSkin.
	 */
	[Style(name="resizeCursorTopLeftBottomRightXOffset", type="Number", inherit="no")]
	
	/**
	 *  Distance to vertically offset resizeCursorTopLeftBottomRightSkin.
	 */
	[Style(name="resizeCursorTopLeftBottomRightYOffset", type="Number", inherit="no")]
	
	
	/**
	 *  Name of the class used as cursor when resizing from top right or bottom left corner.
	 */
	[Style(name="resizeCursorTopRightBottomLeftSkin", type="Class", inherit="no")]
	
	/**
	 *  Distance to horizontally offset resizeCursorTopRightBottomLeftSkin.
	 */
	[Style(name="resizeCursorTopRightBottomLeftXOffset", type="Number", inherit="no")]
	
	/**
	 *  Distance to vertically offset resizeCursorTopRightBottomLeftSkin.
	 */
	[Style(name="resizeCursorTopRightBottomLeftYOffset", type="Number", inherit="no")]
	
	
	/**
	 * Central window class used in flexmdi. Includes min/max/close buttons by default.
	 */
	public class MDIWindow extends Panel
	{		
		/**
	     * Size of edge handles. Can be adjusted to affect "sensitivity" of resize area.
	     */
	    public var edgeHandleSize:Number = 4;
	    
	    /**
	     * Size of corner handles. Can be adjusted to affect "sensitivity" of resize area.
	     */
		public var cornerHandleSize:Number = 10;
	    
	    /**
	     * @private
	     * Internal storage for windowState property.
	     */
		private var _windowState:int;
		
		/**
	     * @private
	     * Internal storage of previous state, used in min/max/restore logic.
	     */
		private var _prevWindowState:int;
		
		/**
		 * @private
		 * Internal storage of style name to be applied when window is in focus.
		 */
		private var _styleNameFocus:String;
		
		/**
		 * @private
		 * Internal storage of style name to be applied when window is out of focus.
		 */
		private var _styleNameNoFocus:String;
		
		/**
	     * Parent of window controls (min, restore/max and close buttons).
	     */
		private var _windowControls:MDIWindowControlsContainer;
		
		/**
		 * @private
		 * Flag to determine whether or not close button is visible.
		 */
		private var _showCloseButton:Boolean = true;
		
		/**
		 * Height of window when minimized.
		 */
		private var _minimizeHeight:Number;
		
		/**
		 * Flag determining whether or not this window is resizable.
		 */
		public var resizable:Boolean = true;
		
		/**
		 * Flag determining whether or not this window is draggable.
		 */
		public var draggable:Boolean = true;
		
		/**
	     * @private
	     * Resize handle for top edge of window.
	     */
		private var resizeHandleTop:Button;
		
		/**
	     * @private
	     * Resize handle for right edge of window.
	     */
		private var resizeHandleRight:Button;
		
		/**
	     * @private
	     * Resize handle for bottom edge of window.
	     */
		private var resizeHandleBottom:Button;
		
		/**
	     * @private
	     * Resize handle for left edge of window.
	     */
		private var resizeHandleLeft:Button;
		
		/**
	     * @private
	     * Resize handle for top left corner of window.
	     */
		private var resizeHandleTL:Button;
		
		/**
	     * @private
	     * Resize handle for top right corner of window.
	     */
		private var resizeHandleTR:Button;
		
		/**
	     * @private
	     * Resize handle for bottom right corner of window.
	     */
		private var resizeHandleBR:Button;
		
		/**
	     * @private
	     * Resize handle for bottom left corner of window.
	     */
		private var resizeHandleBL:Button;		
		
		/**
		 * Resize handle currently in use.
		 */
		private var currentResizeHandle:Button;
		
		/**
	     * Rectangle to represent window's size and position when resize begins
	     * or window's size/position is saved.
	     */
		public var savedWindowRect:Rectangle;
		
		private var minDimensions:Object = {};
		
		/**
		 * @private
		 * Flag used to intelligently dispatch resize related events
		 */
		private var _resizing:Boolean;
		
		/**
		 * Invisible shape laid over titlebar to prevent funkiness from clicking in title textfield.
		 * Making it public gives child components like controls container access to size of titleBar.
		 */
		public var titleBarOverlay:winTitle;
		
		/**
		 * @private
		 * Flag used to intelligently dispatch drag related events
		 */
		private var _dragging:Boolean;
		
		/**
		 * @private
	     * Mouse's x position when resize begins.
	     */
		private var dragStartMouseX:Number;
		
		/**
		 * @private
	     * Mouse's y position when resize begins.
	     */
		private var dragStartMouseY:Number;
		
		/**
		 * @private
	     * Maximum allowable x value for resize. Used to enforce minWidth.
	     */
		private var dragMaxX:Number;
		
		/**
		 * @private
	     * Maximum allowable x value for resize. Used to enforce minHeight.
	     */
		private var dragMaxY:Number;
		
		/**
		 * @private
	     * Amount the mouse's x position has changed during current resizing.
	     */
		private var dragAmountX:Number;
		
		/**
		 * @private
	     * Amount the mouse's y position has changed during current resizing.
	     */
		private var dragAmountY:Number;
		
		/**
	     * Window's context menu.
	     */
		public var winContextMenu:ContextMenu = null;
		
		/**
		 * Reference to MDIManager instance this window is managed by, if any.
	     */
		public var windowManager:MDIManager;
		
		/**
		 * @private
		 * Storage var to hold value originally assigned to styleName since it gets toggled per focus change.
		 */
		private var _windowStyleName:Object;
		
		/**
		 * @private
		 * Storage var for hasFocus property.
		 */
		private var _hasFocus:Boolean;
		
		/**
		 * @private store the backgroundAlpha when minimized.
	     */
		private var backgroundAlphaRestore:Number = 1;
		
		// assets for default buttons
		[Embed(source="/flexmdi/assets/img/refreshButton.png")]
		private static var DEFAULT_REFRESH_BUTTON:Class;
		
	/*	[Embed(source="/flexmdi/assets/img/minimizeButton.png")]
		private static var DEFAULT_MINIMIZE_BUTTON:Class;
		
		[Embed(source="/flexmdi/assets/img/maximizeButton.png")]
		private static var DEFAULT_MAXIMIZE_BUTTON:Class;*/
		
		[Embed(source="/flexmdi/assets/img/minimizeButton.png")]
		private static var DEFAULT_MINIMIZE_BUTTON:Class;
		
		[Embed(source="/flexmdi/assets/img/restoreButton.png")]
		private static var DEFAULT_MAXIMIZE_BUTTON:Class;
		
		[Embed(source="/flexmdi/assets/img/maximizeButton.png")]
		private static var DEFAULT_RESTORE_BUTTON:Class;
		
		[Embed(source="/flexmdi/assets/img/closeButton.png")]
		private static var DEFAULT_CLOSE_BUTTON:Class;
		
		[Embed(source="/flexmdi/assets/img/resizeCursorH.gif")]
		private static var DEFAULT_RESIZE_CURSOR_HORIZONTAL:Class;
		private static var DEFAULT_RESIZE_CURSOR_HORIZONTAL_X_OFFSET:Number = -10;
		private static var DEFAULT_RESIZE_CURSOR_HORIZONTAL_Y_OFFSET:Number = -10;
		
		[Embed(source="/flexmdi/assets/img/resizeCursorV.gif")]
		private static var DEFAULT_RESIZE_CURSOR_VERTICAL:Class;
		private static var DEFAULT_RESIZE_CURSOR_VERTICAL_X_OFFSET:Number = -10;
		private static var DEFAULT_RESIZE_CURSOR_VERTICAL_Y_OFFSET:Number = -10;
		
		[Embed(source="/flexmdi/assets/img/resizeCursorTLBR.gif")]
		private static var DEFAULT_RESIZE_CURSOR_TL_BR:Class;
		private static var DEFAULT_RESIZE_CURSOR_TL_BR_X_OFFSET:Number = -10;
		private static var DEFAULT_RESIZE_CURSOR_TL_BR_Y_OFFSET:Number = -10;
		
		[Embed(source="/flexmdi/assets/img/resizeCursorTRBL.gif")]
		private static var DEFAULT_RESIZE_CURSOR_TR_BL:Class;
		private static var DEFAULT_RESIZE_CURSOR_TR_BL_X_OFFSET:Number = -10;
		private static var DEFAULT_RESIZE_CURSOR_TR_BL_Y_OFFSET:Number = -10;
		
		private static var classConstructed:Boolean = classConstruct();
		
		
		/**
		 * Define and prepare default styles.
		 */
		private static function classConstruct():Boolean{
			
			
			
			//------------------------
		    //  type selector
		    //------------------------
			var selector:CSSStyleDeclaration = FlexGlobals.topLevelApplication.styleManager.getStyleDeclaration("MDIWindow");
			
		
			
			if(!selector)
			{
				selector = new CSSStyleDeclaration();
			}
			// these are default names for secondary styles. these can be set in CSS and will affect
			// all windows that don't have an override for these styles.
			selector.defaultFactory = function():void{
				this.styleNameFocus = "mdiWindowFocus";
				this.styleNameNoFocus = "mdiWindowNoFocus";
				
				this.titleStyleName = "mdiWindowTitleStyle";
				
				this.refreshBtnStyleName = "mdiWindowRefreshBtn";
				this.minimizeBtnStyleName = "mdiWindowMinimizeBtn";
				this.maximizeBtnStyleName = "mdiWindowMaximizeBtn";
				this.restoreBtnStyleName = "mdiWindowRestoreBtn";				
				this.closeBtnStyleName = "mdiWindowCloseBtn";
				
				this.windowControlsClass = MDIWindowControlsContainer;
				
				this.resizeCursorHorizontalSkin = DEFAULT_RESIZE_CURSOR_HORIZONTAL;
				this.resizeCursorHorizontalXOffset = DEFAULT_RESIZE_CURSOR_HORIZONTAL_X_OFFSET;
				this.resizeCursorHorizontalYOffset = DEFAULT_RESIZE_CURSOR_HORIZONTAL_Y_OFFSET;
				
				this.resizeCursorVerticalSkin = DEFAULT_RESIZE_CURSOR_VERTICAL;
				this.resizeCursorVerticalXOffset = DEFAULT_RESIZE_CURSOR_VERTICAL_X_OFFSET;
				this.resizeCursorVerticalYOffset = DEFAULT_RESIZE_CURSOR_VERTICAL_Y_OFFSET;
				
				this.resizeCursorTopLeftBottomRightSkin = DEFAULT_RESIZE_CURSOR_TL_BR;
				this.resizeCursorTopLeftBottomRightXOffset = DEFAULT_RESIZE_CURSOR_TL_BR_X_OFFSET;
				this.resizeCursorTopLeftBottomRightYOffset = DEFAULT_RESIZE_CURSOR_TL_BR_Y_OFFSET;
				
				this.resizeCursorTopRightBottomLeftSkin = DEFAULT_RESIZE_CURSOR_TR_BL;
				this.resizeCursorTopRightBottomLeftXOffset = DEFAULT_RESIZE_CURSOR_TR_BL_X_OFFSET;
				this.resizeCursorTopRightBottomLeftYOffset = DEFAULT_RESIZE_CURSOR_TR_BL_Y_OFFSET;
			}
				
			//------------------------
			//  refresh button
			//------------------------
			var refreshBtnStyleName:String = selector.getStyle("refreshBtnStyleName");
			var refreshBtnSelector:CSSStyleDeclaration = FlexGlobals.topLevelApplication.styleManager.getStyleDeclaration("." + refreshBtnStyleName);
			if(!refreshBtnSelector)
			{
				refreshBtnSelector = new CSSStyleDeclaration();
			}
			refreshBtnSelector.defaultFactory = function():void
			{
				this.upSkin = DEFAULT_REFRESH_BUTTON;
				this.overSkin = DEFAULT_REFRESH_BUTTON;
				this.downSkin = DEFAULT_REFRESH_BUTTON;
				this.disabledSkin = DEFAULT_REFRESH_BUTTON;
			}					
			FlexGlobals.topLevelApplication.styleManager.setStyleDeclaration("." + refreshBtnStyleName, refreshBtnSelector, false);

						
			//------------------------
		    //  minimize button
		    //------------------------
			var minimizeBtnStyleName:String = selector.getStyle("minimizeBtnStyleName");
			var minimizeBtnSelector:CSSStyleDeclaration = FlexGlobals.topLevelApplication.styleManager.getStyleDeclaration("." + minimizeBtnStyleName);
			if(!minimizeBtnSelector)
			{
				minimizeBtnSelector = new CSSStyleDeclaration();
			}
			minimizeBtnSelector.defaultFactory = function():void
			{
				this.upSkin = DEFAULT_MINIMIZE_BUTTON;
				this.overSkin = DEFAULT_MINIMIZE_BUTTON;
				this.downSkin = DEFAULT_MINIMIZE_BUTTON;
				this.disabledSkin = DEFAULT_MINIMIZE_BUTTON;
			}					
			FlexGlobals.topLevelApplication.styleManager.setStyleDeclaration("." + minimizeBtnStyleName, minimizeBtnSelector, false);
			
			//------------------------
		    //  maximize button
		    //------------------------
			var maximizeBtnStyleName:String = selector.getStyle("maximizeBtnStyleName");
			var maximizeBtnSelector:CSSStyleDeclaration = FlexGlobals.topLevelApplication.styleManager.getStyleDeclaration("." + maximizeBtnStyleName);
			if(!maximizeBtnSelector)
			{
				maximizeBtnSelector = new CSSStyleDeclaration();
			}
			maximizeBtnSelector.defaultFactory = function():void
			{
				this.upSkin = DEFAULT_MAXIMIZE_BUTTON;
				this.overSkin = DEFAULT_MAXIMIZE_BUTTON;
				this.downSkin = DEFAULT_MAXIMIZE_BUTTON;
				this.disabledSkin = DEFAULT_MAXIMIZE_BUTTON;
			}					
			FlexGlobals.topLevelApplication.styleManager.setStyleDeclaration("." + maximizeBtnStyleName, maximizeBtnSelector, false);
			
			//------------------------
		    //  restore button
		    //------------------------
			var restoreBtnStyleName:String = selector.getStyle("restoreBtnStyleName");
			var restoreBtnSelector:CSSStyleDeclaration = FlexGlobals.topLevelApplication.styleManager.getStyleDeclaration("." + restoreBtnStyleName);
			if(!restoreBtnSelector)
			{
				restoreBtnSelector = new CSSStyleDeclaration();
			}
			restoreBtnSelector.defaultFactory = function():void
			{
				this.upSkin = DEFAULT_RESTORE_BUTTON;
				this.overSkin = DEFAULT_RESTORE_BUTTON;
				this.downSkin = DEFAULT_RESTORE_BUTTON;
				this.disabledSkin = DEFAULT_RESTORE_BUTTON;
			}					
			FlexGlobals.topLevelApplication.styleManager.setStyleDeclaration("." + restoreBtnStyleName, restoreBtnSelector, false);
			
			//------------------------
		    //  close button
		    //------------------------
			var closeBtnStyleName:String = selector.getStyle("closeBtnStyleName");
			var closeBtnSelector:CSSStyleDeclaration = FlexGlobals.topLevelApplication.styleManager.getStyleDeclaration("." + closeBtnStyleName);
			if(!closeBtnSelector)
			{
				closeBtnSelector = new CSSStyleDeclaration();
			}
			closeBtnSelector.defaultFactory = function():void
			{
				this.upSkin = DEFAULT_CLOSE_BUTTON;
				this.overSkin = DEFAULT_CLOSE_BUTTON;
				this.downSkin = DEFAULT_CLOSE_BUTTON;
				this.disabledSkin = DEFAULT_CLOSE_BUTTON;
			}
			FlexGlobals.topLevelApplication.styleManager.setStyleDeclaration("." + closeBtnStyleName, closeBtnSelector, false);
			
			// apply it all
			FlexGlobals.topLevelApplication.styleManager.setStyleDeclaration("MDIWindow", selector, false);
			
			
			return true;
		}
		
		/**
		 * Constructor
	     */
		public function MDIWindow()
		{
			super();
			minWidth = minHeight = width = height = 200;
			windowState = MDIWindowState.NORMAL;
			doubleClickEnabled = true;
			super.setStyle("headerHeight", 22);
			
			windowControls = new MDIWindowControlsContainer();
			//updateContextMenu();
		}

		
		public function added():void{
			dispatchEvent(new MDIWindowEvent(MDIWindowEvent.ADDED_TO_MANAGER, this));
		}
		
		public function get windowStyleName():Object{
			return _windowStyleName;
		}
		
		public function set windowStyleName(value:Object):void{
			if(_windowStyleName === value)
				return;
			
			_windowStyleName = value;
			updateStyles();
		}
		
		/**
		 * Create resize handles and window controls.
		 */
		override protected function createChildren():void{
			super.createChildren();			
			
			if(!titleBarOverlay)
			{
				titleBarOverlay = new winTitle();// = new Canvas();
				titleBarOverlay.width = this.width - 2;
				titleBarOverlay.height = this.titleBar.height + 2;
				titleBarOverlay.x = 1;
				titleBarOverlay.y = 1;				
										
				rawChildren.addChild(titleBarOverlay);
				updateContextMenu();
			}
			
			// edges
			if(!resizeHandleTop)
			{
				resizeHandleTop = new Button();
				resizeHandleTop.x = cornerHandleSize * .5;
				resizeHandleTop.y = -(edgeHandleSize * .5);
				resizeHandleTop.height = edgeHandleSize;
				resizeHandleTop.alpha = 0;
				resizeHandleTop.focusEnabled = false;
				rawChildren.addChild(resizeHandleTop);
			}
			
			if(!resizeHandleRight)
			{
				resizeHandleRight = new Button();
				resizeHandleRight.y = cornerHandleSize * .5;
				resizeHandleRight.width = edgeHandleSize;
				resizeHandleRight.alpha = 0;
				resizeHandleRight.focusEnabled = false;
				rawChildren.addChild(resizeHandleRight);
			}
			
			if(!resizeHandleBottom)
			{
				resizeHandleBottom = new Button();
				resizeHandleBottom.x = cornerHandleSize * .5;
				resizeHandleBottom.height = edgeHandleSize;
				resizeHandleBottom.alpha = 0;
				resizeHandleBottom.focusEnabled = false;
				rawChildren.addChild(resizeHandleBottom);
			}
			
			if(!resizeHandleLeft)
			{
				resizeHandleLeft = new Button();
				resizeHandleLeft.x = -(edgeHandleSize * .5);
				resizeHandleLeft.y = cornerHandleSize * .5;
				resizeHandleLeft.width = edgeHandleSize;
				resizeHandleLeft.alpha = 0;
				resizeHandleLeft.focusEnabled = false;
				rawChildren.addChild(resizeHandleLeft);
			}
			
			// corners
			if(!resizeHandleTL)
			{
				resizeHandleTL = new Button();
				resizeHandleTL.x = resizeHandleTL.y = -(cornerHandleSize * .3);
				resizeHandleTL.width = resizeHandleTL.height = cornerHandleSize;
				resizeHandleTL.alpha = 0;
				resizeHandleTL.focusEnabled = false;
				rawChildren.addChild(resizeHandleTL);
			}
			
			if(!resizeHandleTR)
			{
				resizeHandleTR = new Button();
				resizeHandleTR.width = resizeHandleTR.height = cornerHandleSize;
				resizeHandleTR.alpha = 0;
				resizeHandleTR.focusEnabled = false;
				rawChildren.addChild(resizeHandleTR);
			}
			
			if(!resizeHandleBR)
			{
				resizeHandleBR = new Button();
				resizeHandleBR.width = resizeHandleBR.height = cornerHandleSize;
				resizeHandleBR.alpha = 0;
				resizeHandleBR.focusEnabled = false;
				rawChildren.addChild(resizeHandleBR);
			}
			
			if(!resizeHandleBL)
			{
				resizeHandleBL = new Button();
				resizeHandleBL.width = resizeHandleBL.height = cornerHandleSize;
				resizeHandleBL.alpha = 0;
				resizeHandleBL.focusEnabled = false;
				rawChildren.addChild(resizeHandleBL);
			}
			
			// bring windowControls to top as they are created in constructor
			rawChildren.setChildIndex(DisplayObject(windowControls), rawChildren.numChildren - 1);
			
			addListeners();
		}
		
		/**
		 * Position and size resize handles and window controls.
		 */
		override protected function updateDisplayList(w:Number, h:Number):void{
			super.updateDisplayList(w, h);
			
			titleBarOverlay.width = this.width - 2;
			titleBarOverlay.height = this.titleBar.height + 2;
			
			// edges
			resizeHandleTop.x = cornerHandleSize * .5;
			resizeHandleTop.y = -(edgeHandleSize * .5);
			resizeHandleTop.width = this.width - cornerHandleSize;
			resizeHandleTop.height = edgeHandleSize;
			
			resizeHandleRight.x = this.width - edgeHandleSize * .5;
			resizeHandleRight.y = cornerHandleSize * .5;
			resizeHandleRight.width = edgeHandleSize;
			resizeHandleRight.height = this.height - cornerHandleSize;
			
			resizeHandleBottom.x = cornerHandleSize * .5;
			resizeHandleBottom.y = this.height - edgeHandleSize * .5;
			resizeHandleBottom.width = this.width - cornerHandleSize;
			resizeHandleBottom.height = edgeHandleSize;
			
			resizeHandleLeft.x = -(edgeHandleSize * .5);
			resizeHandleLeft.y = cornerHandleSize * .5;
			resizeHandleLeft.width = edgeHandleSize;
			resizeHandleLeft.height = this.height - cornerHandleSize;
			
			// corners
			resizeHandleTL.x = resizeHandleTL.y = -(cornerHandleSize * .5);
			resizeHandleTL.width = resizeHandleTL.height = cornerHandleSize;
			
			resizeHandleTR.x = this.width - cornerHandleSize * .5;
			resizeHandleTR.y = -(cornerHandleSize * .5);
			resizeHandleTR.width = resizeHandleTR.height = cornerHandleSize;
			
			resizeHandleBR.x = this.width - cornerHandleSize * .5;
			resizeHandleBR.y = this.height - cornerHandleSize * .5;
			resizeHandleBR.width = resizeHandleBR.height = cornerHandleSize;
			
			resizeHandleBL.x = -(cornerHandleSize * .5);
			resizeHandleBL.y = this.height - cornerHandleSize * .5;
			resizeHandleBL.width = resizeHandleBL.height = cornerHandleSize;
			
			// cause windowControls container to update
			UIComponent(windowControls).invalidateDisplayList();
		}
		
		override public function set title(t:String):void	{
			//super.title = t;
			windowControls.title.text = t;
		}
		override public function get title():String	{
			return windowControls.title.text;
		}
	
		
		
		public function get hasFocus():Boolean{
			return _hasFocus;
		}
		
		/**
		 * Property is set by MDIManager when a window's focus changes. Triggers an update to the window's styleName.
		 */
		public function set hasFocus(value:Boolean):void{
			// guard against unnecessary processing
			if(_hasFocus == value)
				return;
			
			// set new value
			_hasFocus = value;
			updateStyles();
		}
		
		/**
		 * Mother of all styling functions. All styles fall back to the defaults if necessary.
		 */
		private function updateStyles():void{			
			// set window's styleName based on focus status
			if(hasFocus){
				titleBarOverlay.active = true;
				//titleBarOverlay.setStyle("backgroundColor", 0x82c6d0);
			}
			else{
				if(titleBarOverlay != null)
					titleBarOverlay.active = false;
					//titleBarOverlay.setStyle("backgroundColor", 0x999999);
			}
			
			if(refreshBtn){
				refreshBtn.styleName = "mdiWindowRefreshBtn";
			}
			
			if(minimizeBtn){
					minimizeBtn.styleName = "mdiWindowMinimizeBtn";
			}
			
			// style maximize/restore button
			if(maximizeRestoreBtn){
				// fork on windowState
				if(maximized){
						maximizeRestoreBtn.styleName = "mdiWindowMaximizeBtn";
				}
				else{
						maximizeRestoreBtn.styleName = "mdiWindowRestoreBtn";
				}
			}			
			// style close button
			if(closeBtn){
					closeBtn.styleName = "mdiWindowCloseBtn";
			}
		}
		

		/**
		 * Detects change to styleName that is executed by MDIManager indicating a change in focus.
		 * Iterates over window controls and adjusts their styles if they're focus-aware.
		 */
		override public function styleChanged(styleProp:String):void{
			super.styleChanged(styleProp);
			
			if(!styleProp || styleProp == "styleName")
				updateStyles(); 
		}
		
		/**
		 * Reference to class used to create windowControls property.
		 */
		public function get windowControls():MDIWindowControlsContainer	{
			return _windowControls;
		}
		
		/**
		 * When reference is set windowControls will be reinstantiated, meaning runtime switching is supported.
		 */
		public function set windowControls(controlsContainer:MDIWindowControlsContainer):void{
			if(_windowControls)
			{
				var cntnr:Container = Container(windowControls);
				cntnr.removeAllChildren();
				rawChildren.removeChild(cntnr);
				_windowControls = null;
			}
			
			_windowControls = controlsContainer;
			_windowControls.window = this;
			rawChildren.addChild(UIComponent(_windowControls));
			if(windowState == MDIWindowState.MINIMIZED)
			{
				showControls = false;
			}
		}

		/**
		 * Minimize window button.
		 */
		public function set refreshAllow(b:Boolean):void{
			windowControls.refreshBtn.visible = b;
		}
		public function get refreshBtn():Button{
			return windowControls.refreshBtn;
		}		
		
		/**
		 * Minimize window button.
		 */
		public function get minimizeBtn():Button{
			return windowControls.minimizeBtn;
		}
		
		/**
		 * Maximize/restore window button.
		 */
		public function get maximizeRestoreBtn():Button{
			return windowControls.maximizeRestoreBtn;
		}
		
		/**
		 * Close window button.
		 */
		public function get closeBtn():Button{
			return windowControls.closeBtn;
		}
		
		public function get showCloseButton():Boolean{
			return _showCloseButton;
		}
		
		public function set showCloseButton(value:Boolean):void{
			_showCloseButton = value;
			if(closeBtn && closeBtn.visible != value)
			{
				closeBtn.visible = value;
				invalidateDisplayList();
			}
		}
		
		/**
		 * Returns reference to titleTextField which is protected by default.
		 * Provided to allow MDIWindowControlsContainer subclasses as much freedom as possible.
		 */
		public function getTitleTextField():UITextField{
			return titleTextField as UITextField;
		}
		
		/**
		 * Returns reference to titleIconObject which is mx_internal by default.
		 * Provided to allow MDIWindowControlsContainer subclasses as much freedom as possible.
		 */
		public function getTitleIconObject():DisplayObject{
			use namespace mx_internal;
			return titleIconObject as DisplayObject;
		}
		
		/**
		 * Save style settings for minimizing.
	     */
		public function saveStyle():void{
			//this.backgroundAlphaRestore = this.getStyle("backgroundAlpha");
		}
		
		/**
		 * Restores style settings for restore and maximize
	     */
		public function restoreStyle():void	{
			//this.setStyle("backgroundAlpha", this.backgroundAlphaRestore);
		}
		
		/**
		 * Add listeners for resize handles and window controls.
		 */
		private function addListeners():void{
			// edges
			resizeHandleTop.addEventListener(MouseEvent.ROLL_OVER, onResizeButtonRollOver, false, 0, true);
			resizeHandleTop.addEventListener(MouseEvent.ROLL_OUT, onResizeButtonRollOut, false, 0, true);
			resizeHandleTop.addEventListener(MouseEvent.MOUSE_DOWN, onResizeButtonPress, false, 0, true);
			
			resizeHandleRight.addEventListener(MouseEvent.ROLL_OVER, onResizeButtonRollOver, false, 0, true);
			resizeHandleRight.addEventListener(MouseEvent.ROLL_OUT, onResizeButtonRollOut, false, 0, true);
			resizeHandleRight.addEventListener(MouseEvent.MOUSE_DOWN, onResizeButtonPress, false, 0, true);
			
			resizeHandleBottom.addEventListener(MouseEvent.ROLL_OVER, onResizeButtonRollOver, false, 0, true);
			resizeHandleBottom.addEventListener(MouseEvent.ROLL_OUT, onResizeButtonRollOut, false, 0, true);
			resizeHandleBottom.addEventListener(MouseEvent.MOUSE_DOWN, onResizeButtonPress, false, 0, true);
			
			resizeHandleLeft.addEventListener(MouseEvent.ROLL_OVER, onResizeButtonRollOver, false, 0, true);
			resizeHandleLeft.addEventListener(MouseEvent.ROLL_OUT, onResizeButtonRollOut, false, 0, true);
			resizeHandleLeft.addEventListener(MouseEvent.MOUSE_DOWN, onResizeButtonPress, false, 0, true);
			
			// corners
			resizeHandleTL.addEventListener(MouseEvent.ROLL_OVER, onResizeButtonRollOver, false, 0, true);
			resizeHandleTL.addEventListener(MouseEvent.ROLL_OUT, onResizeButtonRollOut, false, 0, true);
			resizeHandleTL.addEventListener(MouseEvent.MOUSE_DOWN, onResizeButtonPress, false, 0, true);
			
			resizeHandleTR.addEventListener(MouseEvent.ROLL_OVER, onResizeButtonRollOver, false, 0, true);
			resizeHandleTR.addEventListener(MouseEvent.ROLL_OUT, onResizeButtonRollOut, false, 0, true);
			resizeHandleTR.addEventListener(MouseEvent.MOUSE_DOWN, onResizeButtonPress, false, 0, true);
			
			resizeHandleBR.addEventListener(MouseEvent.ROLL_OVER, onResizeButtonRollOver, false, 0, true);
			resizeHandleBR.addEventListener(MouseEvent.ROLL_OUT, onResizeButtonRollOut, false, 0, true);
			resizeHandleBR.addEventListener(MouseEvent.MOUSE_DOWN, onResizeButtonPress, false, 0, true);
			
			resizeHandleBL.addEventListener(MouseEvent.ROLL_OVER, onResizeButtonRollOver, false, 0, true);
			resizeHandleBL.addEventListener(MouseEvent.ROLL_OUT, onResizeButtonRollOut, false, 0, true);
			resizeHandleBL.addEventListener(MouseEvent.MOUSE_DOWN, onResizeButtonPress, false, 0, true);
			
			// titleBar overlay
			titleBarOverlay.addEventListener(MouseEvent.MOUSE_DOWN, onTitleBarPress, false, 0, true);
			titleBarOverlay.addEventListener(MouseEvent.MOUSE_UP, onTitleBarRelease, false, 0, true);
			titleBarOverlay.addEventListener(MouseEvent.DOUBLE_CLICK, maximizeRestore, false, 0, true);
			titleBarOverlay.addEventListener(MouseEvent.CLICK, unMinimize, false, 0, true);
			
			// window controls
			addEventListener(MouseEvent.CLICK, windowControlClickHandler, false, 0, true);
			
			// clicking anywhere brings window to front
			addEventListener(MouseEvent.MOUSE_DOWN, bringToFrontProxy, false, 0, true);
			titleBarOverlay.contextMenu.addEventListener(ContextMenuEvent.MENU_SELECT, bringToFrontProxy, false, 0, true);
		}
		
		/**
		 * Click handler for default window controls (minimize, maximize/restore and close).
		 */
		private function windowControlClickHandler(event:MouseEvent):void{
			if(windowControls)
			{
				if(windowControls.minimizeBtn && event.target == windowControls.minimizeBtn)
				{
					minimize();
				}
				else if(windowControls.maximizeRestoreBtn && event.target == windowControls.maximizeRestoreBtn)
				{
					maximizeRestore();
				}
				else if(windowControls.closeBtn && event.target == windowControls.closeBtn)
				{
					close();
				}
				else if(windowControls.refreshBtn && event.target == windowControls.refreshBtn)
				{
					refresh();
				}
			}
		}
		
		/**
		 * Called automatically by clicking on window this now delegates execution to the manager.
		 */
		private function bringToFrontProxy(event:Event):void{
			windowManager.bringToFront(this);
		}
		
		/**
		 *  Minimize the window.
		 */
		public function minimize(event:MouseEvent = null):void{
			// if the panel is floating, save its state
			if(windowState == MDIWindowState.NORMAL){
				savePanel();
			}
		//	this.width = 200;
			this.minWidth = 200;
			dispatchEvent(new MDIWindowEvent(MDIWindowEvent.MINIMIZE, this));
			windowState = MDIWindowState.MINIMIZED;
			
		//	showControls = false;
		}
		
		
		/**
		 *  Called from maximize/restore button 
		 * 
		 *  @event MouseEvent (optional)
		 */
		public function maximizeRestore(event:MouseEvent = null):void{
			if(windowState == MDIWindowState.NORMAL)
			{
				savePanel();
				maximize();
			}
			else
			{
				restore();
			}
		}
		
		/**
		 * Restores the window to its last floating position.
		 */
		public function restore():void{
			windowState = MDIWindowState.NORMAL;
			updateStyles();
			if(this.minDimensions.minWidth)
				this.minWidth = this.minDimensions.minWidth;
			if(this.minDimensions.minHeight)
				this.minHeight = this.minDimensions.minHeight;
			dispatchEvent(new MDIWindowEvent(MDIWindowEvent.RESTORE, this));
		}
		
		/**
		 * Maximize the window.
		 */
		public function maximize():void	{
			if(windowState == MDIWindowState.NORMAL){
				savePanel();
			}
			showControls = true;
			windowState = MDIWindowState.MAXIMIZED;
			updateStyles();
			dispatchEvent(new MDIWindowEvent(MDIWindowEvent.MAXIMIZE, this));
		}
		
		/**
		 * Close the window.
		 */
		public function close(event:MouseEvent = null):void	{
			dispatchEvent(new MDIWindowEvent(MDIWindowEvent.CLOSE, this));
		}
		
		/**
		 * Close the window.
		 */
		public function refresh(event:MouseEvent = null):void	{
			dispatchEvent(new MDIWindowEvent(MDIWindowEvent.REFRESH, this));
		}
		
		/**
		 * Save the panel's floating coordinates.
		 * 
		 * @private
		 */
		private function savePanel():void{
			savedWindowRect = new Rectangle(this.x, this.y, this.width, this.height);
			minDimensions = {minWidth: this.minWidth, minHeight: this.minHeight};
		}
		
		/**
		 * Title bar dragging.
		 * 
		 * @private
		 */
		private function onTitleBarPress(event:MouseEvent):void	{
			// only floating windows can be dragged
			if(this.windowState == MDIWindowState.NORMAL && draggable){
				if(windowManager.enforceBoundaries)	{
					this.startDrag(false, new Rectangle(0, 0, parent.width - this.width, parent.height - this.height));
				}
				else{
					this.startDrag();
				}				
				
				systemManager.addEventListener(MouseEvent.MOUSE_MOVE, onWindowMove, false, 0, true);
				systemManager.addEventListener(MouseEvent.MOUSE_UP, onTitleBarRelease, false, 0, true);
				systemManager.stage.addEventListener(Event.MOUSE_LEAVE, onTitleBarRelease, false, 0, true);
			}
		}
		
		private function onWindowMove(event:MouseEvent):void{
			if(!_dragging){
				_dragging = true;
				// clear styles (future versions may allow enforcing constraints on drag)
				this.clearStyle("top");
				this.clearStyle("right");
				this.clearStyle("bottom");
				this.clearStyle("left");
				dispatchEvent(new MDIWindowEvent(MDIWindowEvent.DRAG_START, this));
			}
			dispatchEvent(new MDIWindowEvent(MDIWindowEvent.DRAG, this));
		}
		
		private function onTitleBarRelease(event:Event):void{
			this.stopDrag();
			if(_dragging)
			{
				_dragging = false;
				dispatchEvent(new MDIWindowEvent(MDIWindowEvent.DRAG_END, this));
			}
			systemManager.removeEventListener(MouseEvent.MOUSE_MOVE, onWindowMove);
			systemManager.removeEventListener(MouseEvent.MOUSE_UP, onTitleBarRelease);
			systemManager.stage.removeEventListener(Event.MOUSE_LEAVE, onTitleBarRelease);
		}
		
		/**
		 * Mouse down on any resize handle.
		 */
		private function onResizeButtonPress(event:MouseEvent):void	{
			if(windowState == MDIWindowState.NORMAL && resizable){
				currentResizeHandle = event.target as Button;
				setCursor(currentResizeHandle);
				dragStartMouseX = parent.mouseX;
				dragStartMouseY = parent.mouseY;
				savePanel();
				
				dragMaxX = savedWindowRect.x + (savedWindowRect.width - minWidth);
				dragMaxY = savedWindowRect.y + (savedWindowRect.height - minHeight);
				
				systemManager.addEventListener(Event.ENTER_FRAME, updateWindowSize, false, 0, true);
				systemManager.addEventListener(MouseEvent.MOUSE_MOVE, onResizeButtonDrag, false, 0, true);
				systemManager.addEventListener(MouseEvent.MOUSE_UP, onResizeButtonRelease, false, 0, true);
				systemManager.stage.addEventListener(Event.MOUSE_LEAVE, onMouseLeaveStage, false, 0, true);
			}
		}
		
		private function onResizeButtonDrag(event:MouseEvent):void
		{
			if(!_resizing)
			{
				_resizing = true;
				dispatchEvent(new MDIWindowEvent(MDIWindowEvent.RESIZE_START, this));
			}			
			dispatchEvent(new MDIWindowEvent(MDIWindowEvent.RESIZE, this));
		}
		
		/**
		 * Mouse move while mouse is down on a resize handle
		 */
		private function updateWindowSize(event:Event):void
		{
			if(windowState == MDIWindowState.NORMAL && resizable)
			{
				dragAmountX = parent.mouseX - dragStartMouseX;
				dragAmountY = parent.mouseY - dragStartMouseY;
				
				if(currentResizeHandle == resizeHandleTop && parent.mouseY > 0)
				{
					this.y = Math.min(savedWindowRect.y + dragAmountY, dragMaxY);
					this.height = Math.max(savedWindowRect.height - dragAmountY, minHeight);
				}
				else if(currentResizeHandle == resizeHandleRight && parent.mouseX < parent.width)
				{
					this.width = Math.max(savedWindowRect.width + dragAmountX, minWidth);
				}
				else if(currentResizeHandle == resizeHandleBottom && parent.mouseY < parent.height)
				{
					this.height = Math.max(savedWindowRect.height + dragAmountY, minHeight);
				}
				else if(currentResizeHandle == resizeHandleLeft && parent.mouseX > 0)
				{
					this.x = Math.min(savedWindowRect.x + dragAmountX, dragMaxX);
					this.width = Math.max(savedWindowRect.width - dragAmountX, minWidth);
				}
				else if(currentResizeHandle == resizeHandleTL && parent.mouseX > 0 && parent.mouseY > 0)
				{
					this.x = Math.min(savedWindowRect.x + dragAmountX, dragMaxX);
					this.y = Math.min(savedWindowRect.y + dragAmountY, dragMaxY);
					this.width = Math.max(savedWindowRect.width - dragAmountX, minWidth);
					this.height = Math.max(savedWindowRect.height - dragAmountY, minHeight);				
				}
				else if(currentResizeHandle == resizeHandleTR && parent.mouseX < parent.width && parent.mouseY > 0)
				{
					this.y = Math.min(savedWindowRect.y + dragAmountY, dragMaxY);
					this.width = Math.max(savedWindowRect.width + dragAmountX, minWidth);
					this.height = Math.max(savedWindowRect.height - dragAmountY, minHeight);
				}
				else if(currentResizeHandle == resizeHandleBR && parent.mouseX < parent.width && parent.mouseY < parent.height)
				{
					this.width = Math.max(savedWindowRect.width + dragAmountX, minWidth);
					this.height = Math.max(savedWindowRect.height + dragAmountY, minHeight);
				}
				else if(currentResizeHandle == resizeHandleBL && parent.mouseX > 0 && parent.mouseY < parent.height)
				{
					this.x = Math.min(savedWindowRect.x + dragAmountX, dragMaxX);
					this.width = Math.max(savedWindowRect.width - dragAmountX, minWidth);
					this.height = Math.max(savedWindowRect.height + dragAmountY, minHeight);
				}
			}
		}
		
		private function onResizeButtonRelease(event:MouseEvent = null):void
		{
			if(windowState == MDIWindowState.NORMAL && resizable)
			{
				if(_resizing)
				{
					_resizing = false;
					dispatchEvent(new MDIWindowEvent(MDIWindowEvent.RESIZE_END, this));
				}
				currentResizeHandle = null;
				systemManager.removeEventListener(Event.ENTER_FRAME, updateWindowSize);
				systemManager.removeEventListener(MouseEvent.MOUSE_MOVE, onResizeButtonDrag);
				systemManager.removeEventListener(MouseEvent.MOUSE_UP, onResizeButtonRelease);
				systemManager.stage.removeEventListener(Event.MOUSE_LEAVE, onMouseLeaveStage);
				CursorManager.removeCursor(CursorManager.currentCursorID);
			}
		}
		
		private function onMouseLeaveStage(event:Event):void
		{
			onResizeButtonRelease();
			systemManager.stage.removeEventListener(Event.MOUSE_LEAVE, onMouseLeaveStage);
		}
		
		/**
		 * Restore window to state it was in prior to being minimized.
		 */
		public function unMinimize(event:MouseEvent = null):void
		{
			if(minimized)
			{
				showControls = true;
				
				if(_prevWindowState == MDIWindowState.NORMAL)
				{
					restore();
				}
				else
				{
					maximize();
				}
			}
		}
		
		private function setCursor(target:Button):void{
		}
		
		private function onResizeButtonRollOver(event:MouseEvent):void{
			// only floating windows can be resized
			// event.buttonDown is to detect being dragged over
			if(windowState == MDIWindowState.NORMAL && resizable && !event.buttonDown)
			{
				setCursor(event.target as Button);
			}
		}
		
		private function onResizeButtonRollOut(event:MouseEvent):void{
			if(!event.buttonDown)
			{
				CursorManager.removeCursor(CursorManager.currentCursorID);
			}
		}
		
		public function set showControls(value:Boolean):void{
			Container(windowControls).visible = value;
		}
		
		private function get windowState():int{
			return _windowState;
		}
		
		private function set windowState(newState:int):void
		{
			_prevWindowState = _windowState;
			_windowState = newState;
			
			updateContextMenu();
		}
		
		public function get minimized():Boolean
		{
			return _windowState == MDIWindowState.MINIMIZED;
		}
		
		public function get maximized():Boolean
		{
			return _windowState == MDIWindowState.MAXIMIZED;
		}
		
		public function get minimizeHeight():Number
		{
			return titleBar.height+3;
		}
		
		public static const CONTEXT_MENU_LABEL_MINIMIZE:String = "Minimize";
		public static const CONTEXT_MENU_LABEL_MAXIMIZE:String = "Maximize";
		public static const CONTEXT_MENU_LABEL_RESTORE:String = "Restore";
		public static const CONTEXT_MENU_LABEL_CLOSE:String = "Close";
		
		public function updateContextMenu():void
		{
			var defaultContextMenu:ContextMenu = new ContextMenu();
				defaultContextMenu.hideBuiltInItems();
			
			var minimizeItem:ContextMenuItem = new ContextMenuItem(MDIWindow.CONTEXT_MENU_LABEL_MINIMIZE);
		  		minimizeItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, menuItemSelectHandler);
		  		minimizeItem.enabled = windowState != MDIWindowState.MINIMIZED;
		  		defaultContextMenu.customItems.push(minimizeItem);	
			
			var maximizeItem:ContextMenuItem = new ContextMenuItem(MDIWindow.CONTEXT_MENU_LABEL_MAXIMIZE);
		  		maximizeItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, menuItemSelectHandler);
		  		maximizeItem.enabled = windowState != MDIWindowState.MAXIMIZED;
		  		defaultContextMenu.customItems.push(maximizeItem);	
			
			var restoreItem:ContextMenuItem = new ContextMenuItem(MDIWindow.CONTEXT_MENU_LABEL_RESTORE);
		  		restoreItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, menuItemSelectHandler);
		  		restoreItem.enabled = windowState != MDIWindowState.NORMAL;
		  		defaultContextMenu.customItems.push(restoreItem);	
			
			var closeItem:ContextMenuItem = new ContextMenuItem(MDIWindow.CONTEXT_MENU_LABEL_CLOSE);
		  		closeItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, menuItemSelectHandler);
		  		defaultContextMenu.customItems.push(closeItem);  
	

			var arrangeItem:ContextMenuItem = new ContextMenuItem(MDIManager.CONTEXT_MENU_LABEL_TILE);
				arrangeItem.separatorBefore = true;
		  		arrangeItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, menuItemSelectHandler);	
		  		defaultContextMenu.customItems.push(arrangeItem);

       	 	var arrangeFillItem:ContextMenuItem = new ContextMenuItem(MDIManager.CONTEXT_MENU_LABEL_TILE_FILL);
		  		arrangeFillItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, menuItemSelectHandler);  	
		  		defaultContextMenu.customItems.push(arrangeFillItem);   
               	
            var cascadeItem:ContextMenuItem = new ContextMenuItem(MDIManager.CONTEXT_MENU_LABEL_CASCADE);
		  		cascadeItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, menuItemSelectHandler);
		  		defaultContextMenu.customItems.push(cascadeItem);                     	
			
			var showAllItem:ContextMenuItem = new ContextMenuItem(MDIManager.CONTEXT_MENU_LABEL_SHOW_ALL);
		  		showAllItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, menuItemSelectHandler);
		  		defaultContextMenu.customItems.push(showAllItem);  
			
        		if(this.titleBarOverlay)
				this.titleBarOverlay.contextMenu = defaultContextMenu;
		}
		
		private function menuItemSelectHandler(event:ContextMenuEvent):void
		{
			switch(event.target.caption)
			{
				case(MDIWindow.CONTEXT_MENU_LABEL_MINIMIZE):
					minimize();
				break;
				
				case(MDIWindow.CONTEXT_MENU_LABEL_MAXIMIZE):
					maximize();
				break;
				
				case(MDIWindow.CONTEXT_MENU_LABEL_RESTORE):
					if(this.windowState == MDIWindowState.MINIMIZED)
					{
						unMinimize();
					}
					else if(this.windowState == MDIWindowState.MAXIMIZED)
					{
						maximizeRestore();
					}	
				break;
				
				case(MDIWindow.CONTEXT_MENU_LABEL_CLOSE):
					close();
				break;
				
				case(MDIManager.CONTEXT_MENU_LABEL_TILE):
					this.windowManager.tile(false, this.windowManager.tilePadding);
				break;
				
				case(MDIManager.CONTEXT_MENU_LABEL_TILE_FILL):
					this.windowManager.tile(true, this.windowManager.tilePadding);
				break;
				
				case(MDIManager.CONTEXT_MENU_LABEL_CASCADE):
					this.windowManager.cascade();
				break;
				
				case(MDIManager.CONTEXT_MENU_LABEL_SHOW_ALL):
					this.windowManager.showAllWindows();
				break;

			}
		}
	}
}