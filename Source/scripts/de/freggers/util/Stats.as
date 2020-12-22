package de.freggers.util
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.system.System;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.utils.getTimer;
   
   public class Stats extends Sprite
   {
       
      
      protected var graph:BitmapData;
      
      protected var fpsText:TextField;
      
      protected var msText:TextField;
      
      protected var memText:TextField;
      
      protected var format:TextFormat;
      
      protected var fps:int;
      
      protected var timer:int;
      
      protected var ms:int;
      
      protected var msPrev:int;
      
      protected var mem:Number;
      
      public function Stats()
      {
         super();
         this.msPrev = 0;
         this.mem = 0;
         this.graph = new BitmapData(60,50,false,819);
         var _loc1_:Bitmap = new Bitmap(this.graph);
         _loc1_.y = 35;
         this.addChild(_loc1_);
         this.format = new TextFormat("_sans",9);
         this.graphics.beginFill(819);
         this.graphics.drawRect(0,0,60,35);
         this.graphics.endFill();
         this.fpsText = new TextField();
         this.msText = new TextField();
         this.memText = new TextField();
         this.fpsText.defaultTextFormat = this.msText.defaultTextFormat = this.memText.defaultTextFormat = this.format;
         this.fpsText.width = this.msText.width = this.memText.width = 60;
         this.fpsText.selectable = this.msText.selectable = this.memText.selectable = false;
         this.fpsText.textColor = 16776960;
         this.fpsText.text = "FPS: ";
         this.addChild(this.fpsText);
         this.msText.y = 10;
         this.msText.textColor = 65280;
         this.msText.text = "MS: ";
         this.addChild(this.msText);
         this.memText.y = 20;
         this.memText.textColor = 65535;
         this.memText.text = "MEM: ";
         this.addChild(this.memText);
         this.addEventListener(MouseEvent.CLICK,this.mouseHandler);
         this.addEventListener(Event.ENTER_FRAME,this.update);
      }
      
      protected function mouseHandler(param1:MouseEvent) : void
      {
         if(this.mouseY > this.height * 0.35)
         {
            this.stage.frameRate--;
         }
         else
         {
            this.stage.frameRate++;
         }
         this.fpsText.text = "FPS: " + this.fps + " / " + this.stage.frameRate;
      }
      
      protected function update(param1:Event) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(!stage)
         {
            return;
         }
         this.timer = getTimer();
         this.fps++;
         if(this.timer - 1000 > this.msPrev)
         {
            this.msPrev = this.timer;
            this.mem = int(System.totalMemory / 1048576 * 1000) / 1000;
            _loc2_ = int(Math.min(50,50 / this.stage.frameRate * this.fps));
            _loc3_ = int(Math.min(50,Math.sqrt(Math.sqrt(this.mem * 5000)))) - 2;
            this.graph.scroll(1,0);
            this.graph.fillRect(new Rectangle(0,0,1,this.graph.height),819);
            this.graph.setPixel(0,this.graph.height - _loc2_,16776960);
            this.graph.setPixel(0,this.graph.height - (this.timer - this.ms >> 1),65280);
            this.graph.setPixel(0,this.graph.height - _loc3_,65535);
            this.fpsText.text = "FPS: " + this.fps + " / " + this.stage.frameRate;
            this.memText.text = "MEM: " + this.mem;
            this.fps = 0;
         }
         this.msText.text = "MS: " + (this.timer - this.ms);
         this.ms = this.timer;
      }
      
      public function cleanup() : void
      {
         removeEventListener(MouseEvent.CLICK,this.mouseHandler);
         removeEventListener(Event.ENTER_FRAME,this.update);
      }
   }
}
