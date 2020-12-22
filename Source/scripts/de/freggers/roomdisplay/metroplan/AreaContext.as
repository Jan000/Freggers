package de.freggers.roomdisplay.metroplan
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.filters.ColorMatrixFilter;
   import flash.geom.Rectangle;
   
   public final class AreaContext
   {
      
      public static const DISABLED_FILTER:ColorMatrixFilter = new ColorMatrixFilter([0.3,0.3,0.3,0.3,0,0.3,0.3,0.3,0.3,0,0.3,0.3,0.3,0.3,0,0,0,0,1,0]);
      
      private static const USER_COUNT_BG_COLOR:int = 16098343;
      
      private static const USER_COUNT_FG_COLOR:int = 16777215;
      
      public static const FLAG_DISABLED:int = 1;
      
      public static const FLAG_INBACKGROUND:int = 2;
       
      
      private var _flags:int;
      
      private var _mc:MovieClip;
      
      private var _label:String;
      
      private var _nusers:uint = 0;
      
      private var _enabled:Boolean = true;
      
      public var countIcon:ItemCount;
      
      private var _playerIcon:DisplayObject;
      
      public var x:Number;
      
      public var y:Number;
      
      public var areaselectors:Array;
      
      public function AreaContext(param1:MovieClip)
      {
         super();
         this.areaselectors = new Array();
         this.completeMC(param1);
         this._label = param1.name;
         this._mc = param1;
         this.x = this._mc.x;
         this.y = this._mc.y;
      }
      
      public function get label() : String
      {
         return this._label;
      }
      
      private function completeMC(param1:MovieClip) : void
      {
         param1.gotoAndStop(1);
         if(this.countIcon != null && this.countIcon.parent != null)
         {
            this.countIcon.parent.removeChild(this.countIcon);
         }
         this.countIcon = new ItemCount(USER_COUNT_BG_COLOR,USER_COUNT_FG_COLOR,36);
         this.countIcon.areaCount = this.areaselectors.length;
         this.countIcon.userCount = this._nusers;
         param1["usercount"].addChild(this.countIcon);
      }
      
      public function get gfx() : MovieClip
      {
         return this._mc;
      }
      
      public function addAreaSelector(param1:AreaSelector) : Boolean
      {
         if(this.areaselectors.indexOf(param1) >= 0)
         {
            return false;
         }
         this.areaselectors.push(param1);
         this.areaselectors.sortOn("id",Array.NUMERIC);
         this._nusers = this._nusers + param1.nusers;
         if(this.countIcon)
         {
            this.countIcon.areaCount = this.areaselectors.length;
            this.countIcon.userCount = this._nusers;
         }
         return true;
      }
      
      public function removeAllAreaSelectors() : void
      {
         this.areaselectors.length = 0;
         this._nusers = 0;
      }
      
      public function get nusers() : uint
      {
         return this._nusers;
      }
      
      public function get isCurrent() : Boolean
      {
         var _loc1_:AreaSelector = null;
         for each(_loc1_ in this.areaselectors)
         {
            if(_loc1_.isCurrent)
            {
               return true;
            }
         }
         return false;
      }
      
      public function get enabled() : Boolean
      {
         return this._enabled;
      }
      
      public function set playerIcon(param1:DisplayObject) : void
      {
         if(this._playerIcon != null && this._playerIcon.parent != null)
         {
            this._playerIcon.parent.removeChild(this._playerIcon);
         }
         if(!param1)
         {
            return;
         }
         this._playerIcon = param1;
         var _loc2_:Rectangle = this._mc.getBounds(this._mc);
         var _loc3_:Rectangle = this._playerIcon.getBounds(this._playerIcon);
         this._playerIcon.x = -_loc3_.width / 2 - _loc3_.x;
         this._playerIcon.y = -_loc3_.height - _loc3_.y;
         this._mc["playericon"].addChild(this._playerIcon);
      }
      
      public function set flags(param1:int) : void
      {
         if(param1 == this._flags)
         {
            return;
         }
         this._flags = param1;
         if(this._flags & FLAG_DISABLED || this._flags & FLAG_INBACKGROUND)
         {
            this._mc.filters = [DISABLED_FILTER];
         }
         else
         {
            this._mc.filters = null;
         }
         this._enabled = !(this._flags & FLAG_DISABLED);
      }
      
      public function get flags() : int
      {
         return this._flags;
      }
   }
}
