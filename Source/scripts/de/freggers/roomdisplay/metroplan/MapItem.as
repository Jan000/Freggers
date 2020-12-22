package de.freggers.roomdisplay.metroplan
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.filters.ColorMatrixFilter;
   import flash.filters.GlowFilter;
   
   public class MapItem extends Sprite
   {
      
      protected static const HIGHLIGHT_COLOR:int = 16098343;
      
      protected static const DISABLED_ALPHA:Number = 0.4;
      
      protected static const ENABLED_ALPHA:Number = 1;
      
      protected static const HIGHLIGHT_FILTER:GlowFilter = new GlowFilter(HIGHLIGHT_COLOR,1,4,4,4,4);
      
      public static const DISABLED_FILTER:ColorMatrixFilter = new ColorMatrixFilter([0.3,0.3,0.3,0.3,0,0.3,0.3,0.3,0.3,0,0.3,0.3,0.3,0.3,0,0.05,0.05,0.05,0.05,0]);
       
      
      protected var _gfx:DisplayObject;
      
      private var _hightlight:Boolean = false;
      
      private var _enabled:Boolean = true;
      
      public var mapX:int = 0;
      
      public var mapY:int = 0;
      
      public var screenX:int = 0;
      
      public var screenY:int = 0;
      
      public var screenScaleMultiplier:Number = 1;
      
      public var scaleMultiplier:Number = 1;
      
      public function MapItem()
      {
         super();
         mouseChildren = false;
      }
      
      public function set gfx(param1:DisplayObject) : void
      {
         if(this._gfx && this._gfx.parent == this)
         {
            removeChild(this._gfx);
         }
         this._gfx = param1;
         if(this._gfx)
         {
            addChild(this._gfx);
            this.updateHighlight();
         }
      }
      
      public function set highlight(param1:Boolean) : void
      {
         this._hightlight = param1;
         this.updateHighlight();
      }
      
      public function get highlight() : Boolean
      {
         return this._hightlight;
      }
      
      public function set enabled(param1:Boolean) : void
      {
         this._enabled = param1;
         this.filters = !!param1?null:[DISABLED_FILTER];
      }
      
      public function get enabled() : Boolean
      {
         return this._enabled;
      }
      
      protected function updateHighlight() : void
      {
      }
      
      public function cleanup() : void
      {
      }
   }
}
