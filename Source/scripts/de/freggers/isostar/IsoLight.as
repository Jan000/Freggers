package de.freggers.isostar
{
   import de.freggers.data.Lightmap;
   import flash.display.Bitmap;
   import flash.display.BlendMode;
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.geom.Vector3D;
   
   public class IsoLight extends Sprite
   {
       
      
      private var _lightmap:Lightmap;
      
      private var _isHard:Boolean = false;
      
      private var _lightingSprite:Sprite;
      
      private var _dir:int;
      
      private var _uvz:Vector3D;
      
      private var _isoparent:IIsoContainer;
      
      public function IsoLight(param1:IIsoContainer, param2:Lightmap, param3:Vector3D = null, param4:int = 0)
      {
         super();
         if(param3 == null)
         {
            param3 = new Vector3D();
         }
         this.mouseEnabled = this.mouseChildren = false;
         this._uvz = param3;
         this._isoparent = param1;
         this.lightmap = param2;
         this.dir = param4;
      }
      
      public function set lightmap(param1:Lightmap) : void
      {
         if(this._lightmap == param1)
         {
            return;
         }
         this._lightmap = param1;
         this.create();
         this.update();
      }
      
      public function get lightmap() : Lightmap
      {
         return this._lightmap;
      }
      
      public function set isHard(param1:Boolean) : void
      {
         this._isHard = param1;
         this.create();
         this.update();
      }
      
      public function update() : void
      {
         var _loc1_:Point = IsoGrid.xy(this.uvz.x,this.uvz.y,this.uvz.z);
         x = _loc1_.x;
         y = _loc1_.y;
      }
      
      public function get size_u() : int
      {
         return this._lightmap.width;
      }
      
      public function get size_v() : int
      {
         return this._lightmap.height;
      }
      
      public function cleanup() : void
      {
      }
      
      protected function create() : void
      {
         var _loc6_:Bitmap = null;
         var _loc1_:uint = 0;
         while(_loc1_ < this.numChildren)
         {
            this.removeChildAt(_loc1_);
            _loc1_++;
         }
         if(!this._lightmap)
         {
            return;
         }
         var _loc2_:Point = IsoGrid.dim(this.size_u,this.size_v,IsoGrid.MODE_SUB);
         var _loc3_:Number = this.size_v * IsoGrid.tile_width / (2 * IsoGrid.upt);
         var _loc4_:Sprite = new Sprite();
         var _loc5_:Sprite = new Sprite();
         this._lightingSprite = new Sprite();
         _loc6_ = new Bitmap(this._lightmap.lightenBmd,"auto",true);
         _loc6_.blendMode = BlendMode.ADD;
         _loc6_.x = -this._lightmap.offset.x;
         _loc6_.y = -this._lightmap.offset.y;
         this._lightingSprite.addChild(_loc6_);
         _loc5_.addChild(this._lightingSprite);
         _loc4_.addChild(_loc5_);
         _loc5_.rotation = 45;
         _loc4_.width = _loc2_.x;
         _loc4_.height = _loc2_.y;
         addChild(_loc4_);
      }
      
      public function get uvz() : Vector3D
      {
         return this._uvz;
      }
      
      public function uvzValues(param1:Number, param2:Number, param3:Number) : void
      {
         var _loc4_:Boolean = false;
         if(this._uvz.x != param1)
         {
            this._uvz.x = param1;
            _loc4_ = true;
         }
         if(this._uvz.y != param2)
         {
            this._uvz.y = param2;
            _loc4_ = true;
         }
         if(this._uvz.z != param3)
         {
            this._uvz.z = param3;
            _loc4_ = true;
         }
         if(_loc4_)
         {
            this.update();
         }
      }
      
      public function set uvz(param1:Vector3D) : void
      {
         if(this._uvz.equals(param1))
         {
            return;
         }
         this._uvz = param1;
         this.update();
      }
      
      public function set dir(param1:int) : void
      {
         if(param1 == this._dir)
         {
            return;
         }
         if(param1 < 0 || param1 > 7)
         {
            return;
         }
         this._dir = param1;
         this._lightingSprite.rotation = this._dir * -45;
      }
      
      public function get dir() : int
      {
         return this._dir;
      }
      
      public function get isoparent() : IIsoContainer
      {
         return this._isoparent;
      }
   }
}
