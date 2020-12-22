package de.freggers.roomdisplay
{
   import caurina.transitions.Tweener;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class CenteredMessageManager extends Sprite
   {
      
      private static const FADEIN_TIME:Number = 0.5;
      
      private static const FADEOUT_TIME:Number = 0.5;
      
      private static const MAX_ALPHA:Number = 0.7;
       
      
      private var currentMessage:CenteredMessage;
      
      private var delayTimer:Timer;
      
      public function CenteredMessageManager()
      {
         super();
         addEventListener(Event.ADDED_TO_STAGE,function(param1:Event):void
         {
            stage.addEventListener(Event.RESIZE,handleResize);
         });
      }
      
      public function addMessage(param1:String) : void
      {
         this.removeCurrentMessage();
         this.currentMessage = new CenteredMessage(param1,stage);
         this.showCurrentMessage();
      }
      
      public function removeCurrentMessage() : void
      {
         if(this.currentMessage)
         {
            removeChild(this.currentMessage.displayObj);
            if(Tweener.isTweening(this.currentMessage.displayObj))
            {
               Tweener.removeTweens(this.currentMessage.displayObj);
            }
            this.currentMessage = null;
         }
         if(this.delayTimer)
         {
            this.delayTimer.stop();
            this.delayTimer = null;
         }
      }
      
      private function handleResize(param1:Event) : void
      {
         var _loc2_:DisplayObject = null;
         if(this.currentMessage)
         {
            _loc2_ = this.currentMessage.displayObj;
            _loc2_.x = (stage.stageWidth - _loc2_.width) / 2;
            _loc2_.y = (stage.stageHeight - _loc2_.height) / 2;
         }
      }
      
      private function showCurrentMessage() : void
      {
         addChild(this.currentMessage.displayObj);
         Tweener.addTween(this.currentMessage.displayObj,{
            "alpha":MAX_ALPHA,
            "time":FADEIN_TIME,
            "onComplete":this.fadeInComplete
         });
      }
      
      private function fadeInComplete() : void
      {
         this.startMessageDelay();
      }
      
      private function startMessageDelay() : void
      {
         this.delayTimer = new Timer(this.currentMessage.getDelay(),1);
         this.delayTimer.addEventListener(TimerEvent.TIMER,function():void
         {
            Tweener.addTween(currentMessage.displayObj,{
               "alpha":0,
               "time":FADEOUT_TIME,
               "onComplete":fadeOutComplete
            });
         });
         this.delayTimer.start();
      }
      
      private function fadeOutComplete() : void
      {
         removeChild(this.currentMessage.displayObj);
         this.currentMessage = null;
      }
   }
}

import de.freggers.roomlib.util.StyleSheetBuilder;
import de.freggers.util.TextRenderer;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.display.Stage;
import flash.text.StyleSheet;

class CenteredMessage
{
    
   
   public var message:String;
   
   public var displayObj:DisplayObject;
   
   private var stage:Stage;
   
   function CenteredMessage(param1:String, param2:Stage)
   {
      super();
      this.stage = param2;
      this.message = param1;
      this.displayObj = this.renderMessage(param1);
   }
   
   public function getDelay() : Number
   {
      var _loc1_:uint = this.message.match(/\w+/g).length;
      return 500 + _loc1_ * 300;
   }
   
   private function renderMessage(param1:String) : DisplayObject
   {
      var _loc2_:StyleSheet = new StyleSheetBuilder(".own").add("fontSize",18).add("fontFamily","Arial,Helvetica,Verdana,\'Lucida Grande\',sans-serif").build();
      var _loc3_:uint = 8;
      var _loc4_:uint = 10;
      var _loc5_:* = "<span class=\"own\">" + param1 + "</span>";
      var _loc6_:BitmapData = TextRenderer.renderToBitmap(_loc5_,_loc2_,700);
      var _loc7_:Bitmap = new Bitmap(_loc6_);
      _loc7_.x = _loc3_;
      _loc7_.y = _loc3_;
      var _loc8_:Sprite = new Sprite();
      _loc8_.graphics.beginFill(16777215,1);
      _loc8_.graphics.drawRoundRect(0,0,_loc7_.width + _loc3_ * 2,_loc7_.height + _loc3_ * 2,_loc4_,_loc4_);
      _loc8_.graphics.endFill();
      _loc8_.x = (this.stage.stageWidth - _loc8_.width) / 2;
      _loc8_.y = (this.stage.stageHeight - _loc8_.height) / 5;
      _loc8_.addChild(_loc7_);
      _loc8_.alpha = 0;
      return _loc8_;
   }
}
