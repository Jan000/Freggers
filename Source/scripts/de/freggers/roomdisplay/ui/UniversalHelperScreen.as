package de.freggers.roomdisplay.ui
{
   import de.freggers.notify.events.CloseEvent;
   import de.freggers.notify.events.RequestActionEvent;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flashx.textLayout.compose.StandardFlowComposer;
   import flashx.textLayout.container.ContainerController;
   import flashx.textLayout.conversion.TextConverter;
   import flashx.textLayout.elements.InlineGraphicElementStatus;
   import flashx.textLayout.elements.TextFlow;
   import flashx.textLayout.events.StatusChangeEvent;
   
   public class UniversalHelperScreen extends UniversalHelperScreenGfx
   {
      
      private static const WIDTH:int = 350;
      
      private static const MAX_HEIGHT:int = 9999;
       
      
      private var _markup:String;
      
      private var bTextFlow:TextFlow;
      
      private var bodyTextContainer:Sprite;
      
      private var bodyController:ContainerController;
      
      public function UniversalHelperScreen(param1:String)
      {
         super();
         this._markup = param1;
         this.init();
      }
      
      private function init() : void
      {
         close.mouseChildren = false;
         close.buttonMode = true;
         close.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
         {
            dispatchEvent(new CloseEvent(RequestActionEvent.EXECUTE));
         });
         this.bTextFlow = TextConverter.importToFlow(this._markup,TextConverter.TEXT_LAYOUT_FORMAT);
         if(this.bTextFlow == null)
         {
            return;
         }
         this.bTextFlow.flowComposer = new StandardFlowComposer();
         this.bTextFlow.addEventListener(StatusChangeEvent.INLINE_GRAPHIC_STATUS_CHANGE,this.recomposeOnLoadComplete,false,0,true);
         this.bodyTextContainer = new Sprite();
         this.bodyController = new ContainerController(this.bodyTextContainer);
         this.bTextFlow.flowComposer.addController(this.bodyController);
         textLayer.addChild(this.bodyTextContainer);
         this.bodyController.setCompositionSize(WIDTH,MAX_HEIGHT);
         this.bTextFlow.flowComposer.updateAllControllers();
         this.layout();
      }
      
      private function recomposeOnLoadComplete(param1:StatusChangeEvent) : void
      {
         if(param1.status == InlineGraphicElementStatus.ERROR)
         {
         }
         if(param1.element.getTextFlow() == this.bTextFlow && param1.status == InlineGraphicElementStatus.SIZE_PENDING)
         {
            this.bTextFlow.flowComposer.updateAllControllers();
            this.layout();
         }
      }
      
      private function layout() : void
      {
         var _loc1_:Rectangle = this.bodyController.getContentBounds();
         this.background.height = _loc1_.height + textLayer.y + 90;
         textLayer.x = (this.background.width - _loc1_.width) / 2;
      }
   }
}
