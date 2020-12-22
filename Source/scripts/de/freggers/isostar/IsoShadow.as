package de.freggers.isostar
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.filters.BlurFilter;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.geom.Vector3D;
   
   public class IsoShadow extends AIsoFlatThing
   {
      
      private static const GRIP_COLOR:uint = 0;
      
      private static const BLUR:BlurFilter = new BlurFilter(3,3);
       
      
      private var _grip:BitmapData;
      
      private var _gripbounds:Rectangle;
      
      private var _subgripbounds:Rectangle;
      
      private var _bmd:BitmapData;
      
      private var _config:IsoShadowConfig;
      
      public function IsoShadow(param1:IIsoContainer, param2:BitmapData, param3:Vector3D = null, param4:IsoShadowConfig = null)
      {
         super(param1,param3);
         this.mouseEnabled = this.mouseChildren = false;
         if(!param4)
         {
            this._config = new IsoShadowConfig();
         }
         else
         {
            this._config = param4;
         }
         this.grip = param2;
      }
      
      public function set config(param1:IsoShadowConfig) : void
      {
         this._config = param1;
         this.create();
      }
      
      public function set grip(param1:BitmapData) : void
      {
         if(this._grip == param1)
         {
            return;
         }
         this._grip = param1;
         this._gripbounds = this._grip.rect;
         this._subgripbounds = this._grip.getColorBoundsRect(4294967295,4278190080);
         this.create();
         this.updateBoundingBox();
         this.recalc();
      }
      
      public function get grip() : BitmapData
      {
         return this._grip;
      }
      
      public function set scale(param1:Number) : void
      {
         if(param1 == this._config.scale)
         {
            return;
         }
         this._config.scale = param1;
         this.create();
         this.recalc();
      }
      
      public function get scale() : Number
      {
         return this._config.scale;
      }
      
      override public function setIsoPosition(param1:Number, param2:Number, param3:Number) : void
      {
         super.setIsoPosition(param1,param2,param3);
         this.updateBoundingBox();
      }
      
      public function set brightness(param1:Number) : void
      {
         if(param1 == this._config.alpha)
         {
            return;
         }
         param1 = Math.max(0.1,Math.min(0.3,param1));
         var _loc2_:String = isoparent.background.roomName;
         if(_loc2_.search("_winter") != -1)
         {
            param1 = 0.1;
         }
         this._config.alpha = param1;
         if(content)
         {
            content.alpha = param1;
         }
      }
      
      public function get brightness() : Number
      {
         return this._config.alpha;
      }
      
      public function set isHard(param1:Boolean) : void
      {
         if(param1 == this._config.isHard)
         {
            return;
         }
         this._config.isHard = param1;
         this.create();
      }
      
      public function get isHard() : Boolean
      {
         return this._config.isHard;
      }
      
      override protected function recalc() : void
      {
         if(!content)
         {
            return;
         }
         var _loc1_:Point = IsoGrid.xy(isoU,isoV,isoparent.getHeightAt(isoU,isoV));
         x = _loc1_.x - content.width / 2;
         y = _loc1_.y - content.height / 2;
         super.recalc();
      }
      
      private function updateBoundingBox() : void
      {
         if(!this._grip)
         {
            return;
         }
         min_u = isoU - this._gripbounds.width / 2 + this._subgripbounds.x;
         max_u = min_u + this._subgripbounds.width;
         min_v = isoV - this._gripbounds.height / 2 + this._subgripbounds.y;
         max_v = min_v + this._subgripbounds.height;
         min_z = isoZ;
         max_z = isoU;
      }
      
      public function get size_u() : int
      {
         return this._grip.width;
      }
      
      public function get size_v() : int
      {
         return this._grip.height;
      }
      
      protected function create() : void
      {
         var _loc6_:Sprite = null;
         var _loc7_:Matrix = null;
         if(!this._grip)
         {
            return;
         }
         var _loc1_:Point = IsoGrid.dim(this.size_u,this.size_v,IsoGrid.MODE_SUB);
         var _loc2_:Number = this.size_v * IsoGrid.tile_width / (2 * IsoGrid.upt);
         var _loc3_:Sprite = new Sprite();
         var _loc4_:Sprite = new Sprite();
         this._bmd = new BitmapData(this._grip.width * 1.25,this._grip.height * 1.25,true,0);
         var _loc5_:Rectangle = this._grip.getColorBoundsRect(4278190080,0,false);
         if(_loc5_.isEmpty())
         {
            _loc6_ = new Sprite();
            _loc6_.graphics.beginFill(this._config.color);
            _loc6_.graphics.drawEllipse(0,0,this._grip.width,this._grip.height);
            _loc6_.graphics.endFill();
            _loc7_ = new Matrix();
            _loc7_.tx = (this._bmd.width - _loc6_.width) / 2;
            _loc7_.ty = (this._bmd.height - _loc6_.height) / 2;
            this._bmd.draw(_loc6_,_loc7_);
         }
         else
         {
            this._bmd.copyPixels(this._grip,this._grip.rect,new Point((this._bmd.width - this._grip.width) / 2,(this._bmd.height - this._grip.height) / 2));
            if(this._config.color != GRIP_COLOR)
            {
               this._bmd.threshold(this._bmd,this._bmd.rect,this._bmd.rect.topLeft,"!=",GRIP_COLOR,this._config.color);
            }
         }
         if(!this._config.isHard)
         {
            this._bmd.applyFilter(this._bmd,this._bmd.rect,this._bmd.rect.topLeft,BLUR);
         }
         _loc3_.addChild(new Bitmap(this._bmd,"auto",true));
         _loc4_.addChild(_loc3_);
         _loc3_.rotation = 45;
         _loc3_.x = _loc2_ * _loc3_.width / _loc1_.x;
         _loc4_.width = _loc1_.x * this._config.scale;
         _loc4_.height = _loc1_.y * this._config.scale;
         this.content = _loc4_;
         this.content.alpha = this._config.alpha;
      }
      
      public function set color(param1:int) : void
      {
         if(this._config.color == param1)
         {
            return;
         }
         this._config.color = param1 | 4278190080;
         this.create();
      }
      
      public function get color() : int
      {
         return this._config.color & 16777215;
      }
      
      public function get subgripbounds() : Rectangle
      {
         return this._subgripbounds;
      }
      
      public function get gripbounds() : Rectangle
      {
         return this._gripbounds;
      }
      
      override public function cleanup() : void
      {
         super.cleanup();
         if(this._bmd)
         {
            this._bmd.dispose();
         }
      }
   }
}
