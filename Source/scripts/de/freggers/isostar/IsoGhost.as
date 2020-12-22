package de.freggers.isostar
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.filters.BlurFilter;
   import flash.filters.ColorMatrixFilter;
   
   public class IsoGhost extends IsoSortable
   {
      
      public static var STARTALPHA:String = "a";
      
      public static var ENDALPHA:String = "b";
      
      public static var DURATION:String = "c";
      
      public static var STEPS:String = "d";
      
      public static var COLOR:String = "e";
      
      public static var BLUR:String = "f";
      
      public static var MODE:String = "g";
      
      public static var UPDATEINTERVAL:String = "h";
      
      public static var MODE_COPYFRAME:uint = 0;
      
      public static var MODE_SOLIDCOLOR:uint = 1;
      
      public static var MODE_COLORCYCLE:uint = 2;
      
      public static var MODE_COLORFADE:uint = 3;
       
      
      protected var _content:Bitmap;
      
      private var _currentstep:uint = 0;
      
      private var _steps:uint;
      
      private var _duration:int;
      
      private var _startalpha:Number;
      
      private var _endalpha:Number;
      
      private var _lastupdate:int = 0;
      
      private var _mode:uint;
      
      private var _color:uint = 4.294967295E9;
      
      private var _blur:int = 0;
      
      private var _colormatrix_filter:ColorMatrixFilter;
      
      private var _blur_filter:BlurFilter;
      
      public function IsoGhost(param1:IsoSortable, param2:Number = 1, param3:Number = 0.5, param4:int = 3000, param5:uint = 10, param6:uint = 4.294967295E9, param7:uint = 0, param8:uint = 0)
      {
         this._mode = MODE_COPYFRAME;
         super();
         this._duration = param4;
         this._steps = param5;
         this._startalpha = param2;
         this._endalpha = param3;
         this._color = param6;
         this._mode = param8;
         this._blur = param7;
         this.init(param1);
      }
      
      private function init(param1:IsoSortable) : void
      {
         var _loc2_:Array = null;
         var _loc4_:Array = null;
         if(this._mode == MODE_SOLIDCOLOR || this._mode == MODE_COLORCYCLE || this._mode == MODE_COLORFADE)
         {
            this._colormatrix_filter = new ColorMatrixFilter();
            if(this._mode == MODE_SOLIDCOLOR)
            {
               _loc4_ = this._colormatrix_filter.matrix;
               _loc4_[0] = 0.3;
               _loc4_[4] = this._color >> 16 & 255;
               _loc4_[6] = 0.3;
               _loc4_[9] = this._color >> 8 & 255;
               _loc4_[12] = 0.3;
               _loc4_[14] = this._color & 255;
               this._colormatrix_filter.matrix = _loc4_;
            }
            _loc2_ = [this._colormatrix_filter];
         }
         if(this._blur > 0)
         {
            this._blur_filter = new BlurFilter(this._blur,this._blur,1);
            if(_loc2_)
            {
               _loc2_.push(this._blur_filter);
            }
            else
            {
               _loc2_ = [this._blur_filter];
            }
         }
         this.filters = _loc2_;
         this.min_u = param1.min_u;
         this.max_u = param1.max_u;
         this.max_v = param1.max_v;
         this.min_v = param1.min_v;
         this.min_z = param1.min_z;
         this.max_z = param1.max_z;
         this.baseX = param1.baseX;
         this.baseY = param1.baseY;
         this.depth = param1.depth;
         this.alpha = param1.alpha;
         this.isoU = param1.isoU - 0.1;
         this.isoV = param1.isoV - 0.1;
         this.isoZ = param1.isoZ;
         this.x = param1.x;
         this.y = param1.y;
         this.bounds = param1.bounds.clone();
         var _loc3_:BitmapData = new BitmapData(param1.bounds.width,param1.bounds.height,true,0);
         _loc3_.draw(param1);
         this._content = new Bitmap(_loc3_);
         this.addChild(this._content);
      }
      
      override public function update(param1:int) : void
      {
         var _loc3_:Array = null;
         var _loc4_:Array = null;
         var _loc5_:Number = NaN;
         if(param1 - this._lastupdate < this._duration / this._steps)
         {
            return;
         }
         this._lastupdate = param1;
         var _loc2_:Number = this._currentstep / this._steps;
         this.alpha = this._endalpha + (1 - _loc2_) * (this._startalpha - this._endalpha);
         if(this._mode == MODE_COLORCYCLE)
         {
            _loc5_ = this._steps / 3;
            if(0 <= this._currentstep && this._currentstep < _loc5_)
            {
               _loc2_ = this._currentstep / _loc5_;
               this._color = (255 * (1 - _loc2_) & 255) << 16 | (255 * _loc2_ & 255) << 8;
            }
            else if(_loc5_ <= this._currentstep && this._currentstep < 2 * _loc5_)
            {
               _loc2_ = (this._currentstep - _loc5_) / _loc5_;
               this._color = (255 * (1 - _loc2_) & 255) << 8 | 255 * _loc2_ & 255;
            }
            else if(2 * _loc5_ <= this._currentstep && this._currentstep <= 3 * _loc5_)
            {
               _loc2_ = (this._currentstep - 2 * _loc5_) / _loc5_;
               this._color = 255 * (1 - _loc2_) & 255 | (255 * _loc2_ & 255) << 16;
            }
            _loc3_ = this._colormatrix_filter.matrix;
            _loc3_[0] = 0.3;
            _loc3_[4] = this._color >> 16 & 255;
            _loc3_[6] = 0.3;
            _loc3_[9] = this._color >> 8 & 255;
            _loc3_[12] = 0.3;
            _loc3_[14] = this._color & 255;
            this._colormatrix_filter.matrix = _loc3_;
            _loc4_ = this.filters;
            _loc4_[0] = this._colormatrix_filter;
            this.filters = _loc4_;
         }
         else if(this._mode == MODE_COLORFADE)
         {
            _loc3_ = this._colormatrix_filter.matrix;
            _loc3_[0] = 0.3 + 0.7 * (1 - _loc2_);
            _loc3_[4] = this._color >> 16 & 255 * _loc2_;
            _loc3_[6] = 0.3 + 0.7 * (1 - _loc2_);
            _loc3_[9] = this._color >> 8 & 255 * _loc2_;
            _loc3_[12] = 0.3 + 0.7 * (1 - _loc2_);
            _loc3_[14] = this._color & 255 * _loc2_;
            this._colormatrix_filter.matrix = _loc3_;
            _loc4_ = this.filters;
            _loc4_[0] = this._colormatrix_filter;
            this.filters = _loc4_;
         }
         this._currentstep++;
         if(this._currentstep > this._steps)
         {
            if(group)
            {
               group.removeIsoSortable(this);
               this.cleanup();
            }
         }
      }
      
      override public function cleanup() : void
      {
         var _loc1_:BitmapData = null;
         if(this._content && this._content.bitmapData)
         {
            _loc1_ = this._content.bitmapData;
            this._content.bitmapData = null;
            _loc1_.dispose();
         }
      }
      
      override public function toString() : String
      {
         return "IsoGhost#[l=" + min_u + ", r=" + max_u + ", b=" + min_v + ", f=" + max_v + ", b=" + min_z + ", t=" + max_z + "]";
      }
   }
}
