package de.freggers.isostar
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.geom.Vector3D;
   
   public class IsoDisplayObject extends AIsoFlatThing
   {
       
      
      private var _gripbounds:Rectangle;
      
      private var _displayobject:DisplayObject;
      
      public function IsoDisplayObject(param1:IIsoContainer, param2:uint, param3:uint, param4:DisplayObject = null, param5:Vector3D = null)
      {
         super(param1,param5);
         this._gripbounds = new Rectangle(0,0,param2,param3);
         this._displayobject = param4;
         this.create();
         this.updateBoundingBox();
         this.recalc();
      }
      
      override public function setIsoPosition(param1:Number, param2:Number, param3:Number) : void
      {
         super.setIsoPosition(param1,param2,param3);
         this.updateBoundingBox();
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
         if(!this._gripbounds)
         {
            return;
         }
         min_u = isoU - this._gripbounds.width / 2;
         max_u = min_u + this._gripbounds.width;
         min_v = isoV - this._gripbounds.height / 2;
         max_v = min_v + this._gripbounds.height;
         min_z = isoZ;
         max_z = isoU;
      }
      
      public function set displayObject(param1:DisplayObject) : void
      {
         if(param1 == this._displayobject)
         {
            return;
         }
         this._displayobject = param1;
         this.create();
         this.updateBoundingBox();
         this.recalc();
      }
      
      public function get displayObject() : DisplayObject
      {
         return this._displayobject;
      }
      
      public function get size_u() : int
      {
         return this._gripbounds.width;
      }
      
      public function get size_v() : int
      {
         return this._gripbounds.height;
      }
      
      protected function create() : void
      {
         if(!this._displayobject)
         {
            return;
         }
         var _loc1_:Point = IsoGrid.dim(this.size_u,this.size_v,IsoGrid.MODE_SUB);
         var _loc2_:Number = this.size_v * IsoGrid.tile_width / (2 * IsoGrid.upt);
         var _loc3_:Sprite = new Sprite();
         var _loc4_:Sprite = new Sprite();
         _loc3_.addChild(this._displayobject);
         _loc4_.addChild(_loc3_);
         _loc3_.rotation = 45;
         _loc3_.x = _loc2_ * _loc3_.width / _loc1_.x;
         _loc4_.width = _loc1_.x;
         _loc4_.height = _loc1_.y;
         this.content = _loc4_;
      }
   }
}
