package classes{
	
	import components.utils.Func;
	import components.utils.TitleGroup;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	
	import spark.components.CheckBox;
	import spark.components.HGroup;
	import spark.components.Label;
	import spark.components.NumericStepper;
	import spark.components.VGroup;
	import spark.layouts.VerticalLayout;
		
	public class SettingManager	{
		
		/**
		 * Настройки поумолчанию
		 * 
		 */ 
		private static var settingsArray:Array = [
			{	component: "components.LoginForm", 
				sub: "endpoint",
				title: "Выбор хоста",
				options: [
					{	title	:	"Отображать",
						type	:	"boolean",
						name	:	"visible",
						value	:	false
					}
					
				]},
			
			{	component: "widgets.NDS", 
				title: "НДС форма",
				options: [
							{	title	:	"Отображать форму",
								type	:	"boolean",
								name	:	"visible",
								value	:	false
								}
					
				]},
			
			{	component: "widgets.PrivateTasks", 
				title: "Личные задачи",
				options: [
							{	title	:	"Отображать личные задачи",
								type	:	"boolean",
								name	:	"visible",
								value	:	false
							},
							{	title	:	"Ширина",
								type	:	"number",
								name	:	"width",
								value	:	250
							}
				]}
		]; 
		
		private static var componentsArr:Dictionary = new Dictionary(true);
		
		
		private static var instance:SettingManager;
		
		public static var controller:VGroup = new VGroup();
		
		public function SettingManager(){
			instance = this;
			if(SharedManager.getObj("settings")!=null){	
				trace("readSettings")
				settingsArray = Func.arrConcatUnique(settingsArray, SharedManager.getObj("settings") as Array)
	//			settingsArray = SharedManager.getObj("settings") as Array
			}
			readAllSettings();
		}
		
		private function readAllSettings():void{			
			createController();
		}
		
		private function createController():void{
			for(var i:int=0; i < settingsArray.length; ++i){
				var o:Object = settingsArray[i];
				var group:TitleGroup = new TitleGroup();
				group.title = o.title;
				group.percentWidth = 100;
				group.layout = new VerticalLayout();
				
				for(var j:int=0; j<o.options.length; ++j){
					var op:Object = o.options[j];
					
					switch(op.type){
						
						case "boolean" :	
							group.addElement(getCheck(o.component, op));
							break;
						case "number" :	
							group.addElement(getNum(o.component, op));
							break;
						default : return;
					}
					
					
				/*	for(var s:Object in componentsArr){
						if(getQualifiedClassName(s).replace("::", ".") == o.component){
							DisplayObject(s)[op.name] = op.value;
						}
					}	*/
					
				}
				controller.addElement(group);
				
			}
			
			function getCheck(componentClass:String, op:Object):CheckBox{
				var check:CheckBox = new CheckBox();
				check.label = op.title;
				check.selected = op.value;
				check.addEventListener(Event.CHANGE, function():void{updateProperty(componentClass, op, check.selected)});
				return check;
			}
			function getNum(componentClass:String, op:Object):HGroup{
				var hg:HGroup = new HGroup();
				hg.verticalAlign = "middle";
				var l:Label = new Label();
				l.text = op.title;
				var num:NumericStepper = new NumericStepper();
				num.value = op.value;
				num.maximum = 700;
				num.minimum = 100;
				num.addEventListener(Event.CHANGE, function():void{updateProperty(componentClass, op, num.value)});
				hg.addElement(l);
				hg.addElement(num);
				return hg;
			}
		}
		
		private function updateProperty(componentClass:String, op:Object, value:*):void{
//			trace("updateProperty: "+componentClass+ " "+value)
			for(var s:Object in componentsArr){
				if(getQualifiedClassName(s).replace("::", ".") == componentClass){
					DisplayObject(s)[op.name] = value;
					op.value = value;
				}
			}	
			
		}		
		
		public static function initComponent(component:*):void{									
			if(UIComponent(component).initialized){
			
				for(var i:int=0; i < settingsArray.length; i++){
					var o:Object = settingsArray[i];
					
					if(getQualifiedClassName(component).replace("::", ".") == o.component){
						for(var j:int=0; j<o.options.length; ++j){
							var op:Object = o.options[j];
							
							switch(op.type){							
								case "boolean" : case "number" :
									DisplayObject(component)[op.name] = op.value;
									break;
								default : return;
							}
						}				
					}				
				}
			}else{
				UIComponent(component).addEventListener(FlexEvent.INITIALIZE, setOptions);
			}
			
			trace("initComponent", component, component.name, getQualifiedClassName(component))
			componentsArr[component] = component.name;
			
		}
		
		private static function setOptions(e:FlexEvent):void{
			var component:UIComponent = e.target as UIComponent;
			component.removeEventListener(FlexEvent.INITIALIZE, setOptions);
			
			for(var i:int=0; i < settingsArray.length; i++){
				var o:Object = settingsArray[i];

				if(getQualifiedClassName(component).replace("::", ".") == o.component){
					for(var j:int=0; j<o.options.length; ++j){
						var op:Object = o.options[j];
						
						trace(o.sub)
						switch(op.type){							
							case "boolean" : case "number" :
								if(o.sub)
									DisplayObject(component)[o.sub][op.name] = op.value;
								else
									DisplayObject(component)[op.name] = op.value;
								break;
							default : return;
						}
					}				
				}				
			}
		}
		
		public static function update():void{			
			SharedManager.setObj("settings", settingsArray);
		}
		
	}
}