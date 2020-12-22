package de.freggers.roomdisplay
{
   import caurina.transitions.Tweener;
   import flash.display.Sprite;
   import flash.filters.DropShadowFilter;
   import flash.filters.GlowFilter;
   
   public class MyLoader extends LoaderGfx
   {
       
      
      private var _progress:Number;
      
      private var _glowsign:Number;
      
      private var _glow:Number;
      
      private var _hiding:Boolean;
      
      private var _showing:Boolean;
      
      private var _border:Sprite;
      
      public function MyLoader(param1:int, param2:int)
      {
         super();
         this.cnt.blue.width = this.cnt.bluemask.width;
         this.cnt.blue.x = this.cnt.bluemask.x;
         this.cnt.blue.y = this.cnt.bluemask.y + cnt.bluemask.height + cnt.bluetop.height;
         this.cnt.bluetop.x = 0;
         this.cnt.blue.height = this._progress = 0;
         this.cnt.bluetop.y = this.cnt.blue.y + 5;
         this.bg.width = param1;
         this.bg.height = param2;
         this.cnt.x = this.bg.width / 2 - 120;
         this.cnt.y = -this.cnt.height;
         this.cnt.filters = [new DropShadowFilter(2,2,0,0.75,4,4,1,1)];
         this._border = new Sprite();
         this._border.graphics.beginFill(153);
         this._border.graphics.drawRect(0,0,100,100);
         this._border.graphics.endFill();
         this._border.width = param1;
         this._border.height = param2;
         this._border.filters = [new GlowFilter(0,0.65,20,20,1,10,true,true)];
         addChild(this._border);
         this._glowsign = 1;
         this._glow = 0;
         cnt.cacheAsBitmap = true;
         bg.cacheAsBitmap = true;
      }
      
      public function show() : void
      {
         if(this._showing)
         {
            return;
         }
         this._showing = true;
         this._progress = 0;
         Tweener.addTween(cnt,{
            "y":this.bg.height / 2,
            "time":0,
            "transition":"easeInOutElastic",
            "onComplete":this.__moveInComplete
         });
      }
      
      public function cleanup() : void
      {
         Tweener.removeTweens(cnt);
         Tweener.removeTweens(bg);
      }
      
      public function hide() : void
      {
         if(this._hiding)
         {
            return;
         }
         this._hiding = true;
         if(!this._showing)
         {
            Tweener.addTween(cnt,{
               "y":this.bg.height + cnt.height + 20,
               "time":0,
               "transition":"easeOutBounce",
               "onComplete":this.__moveOutComplete
            });
         }
      }
      
      private function __moveOutComplete() : void
      {
         Tweener.addTween(bg,{
            "alpha":0,
            "time":0,
            "transition":"easeOutCirc",
            "onComplete":this.__fadeOutComplete
         });
      }
      
      private function __moveInComplete() : void
      {
         this._showing = false;
         dispatchEvent(new MyLoaderEvent(MyLoaderEvent.VISIBLE));
      }
      
      private function __fadeInComplete() : void
      {
         Tweener.addTween(cnt,{
            "y":this.bg.height / 2,
            "time":0,
            "transition":"easeInOutElastic",
            "onComplete":this.__moveInComplete
         });
      }
      
      private function __fadeOutComplete() : void
      {
         this._hiding = false;
         dispatchEvent(new MyLoaderEvent(MyLoaderEvent.HIDDEN));
      }
      
      public function set progress(param1:Number) : void
      {
         this._progress = param1;
         this.cnt.blue.height = (this.cnt.bluemask.height + this.cnt.bluetop.height) * this._progress;
         this.cnt.blue.y = this.cnt.bluemask.y + this.cnt.bluemask.height - this.cnt.blue.height + this.cnt.bluetop.height;
         this.cnt.bluetop.y = this.cnt.blue.y + 5;
      }
      
      public function get progress() : Number
      {
         return this._progress;
      }
      
      public function update(param1:int) : void
      {
         this._glow = this._glow + this._glowsign * 0.3;
         if(this._glow > 10)
         {
            this._glowsign = -1;
         }
         if(this._glow <= 0)
         {
            this._glowsign = 1;
         }
         cnt.glowtarget.filters = [new GlowFilter(10027008,this._glow / 10,6,6)];
      }
      
      public function handleResize(param1:int, param2:int) : void
      {
         bg.width = param1;
         bg.height = param2;
         this._border.width = param1;
         this._border.height = param2;
         cnt.x = bg.width / 2 - 120;
         cnt.y = bg.height / 2;
      }
   }
}
