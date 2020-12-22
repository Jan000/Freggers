package de.freggers.isostar
{
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   import flash.geom.Vector3D;
   import flash.utils.Dictionary;
   
   public class IsoSortable extends Sprite
   {
      
      public static const FLAG_NO_COLLISION:int = 1;
      
      public static const FLAG_GROUPABLE:int = 2;
       
      
      private var _uvz:Vector3D;
      
      public var delta:Vector3D;
      
      var _flags:int = 0;
      
      private var _flagargs:Dictionary;
      
      private var _dirty:Boolean = false;
      
      public var bounds:Rectangle;
      
      public var min_u:int = 0;
      
      public var max_u:int = 0;
      
      public var min_v:int = 0;
      
      public var max_v:int = 0;
      
      public var min_z:int = 0;
      
      public var max_z:int = 0;
      
      public var baseX:int = 0;
      
      public var baseY:int = 0;
      
      public var depth:Number = 0;
      
      public var group:IsoSortableGroup;
      
      public var addid:uint = 0;
      
      public var treedepth:uint = 0;
      
      public function IsoSortable()
      {
         super();
         this.mouseEnabled = false;
         this._uvz = new Vector3D();
         this.delta = new Vector3D();
         this.bounds = new Rectangle();
         this._flagargs = new Dictionary();
         this.cacheAsBitmap = true;
      }
      
      public function get isoU() : Number
      {
         return this._uvz.x;
      }
      
      public function get isoV() : Number
      {
         return this._uvz.y;
      }
      
      public function get isoZ() : Number
      {
         return this._uvz.z;
      }
      
      public function setDirty() : void
      {
         if(this._dirty)
         {
            return;
         }
         this._dirty = true;
      }
      
      public function removeDirty() : void
      {
         if(!this._dirty)
         {
            return;
         }
         this._dirty = false;
      }
      
      public function isDirty() : Boolean
      {
         return this._dirty;
      }
      
      public function set flags(param1:int) : void
      {
         this._flags = param1;
      }
      
      public function get flags() : int
      {
         return this._flags;
      }
      
      public function getFlagArgs(param1:int) : Object
      {
         return this._flagargs[param1];
      }
      
      public function setFlagArgs(param1:int, param2:Object) : void
      {
         if(!param2)
         {
            delete this._flagargs[param1];
         }
         else
         {
            this._flagargs[param1] = param2;
         }
      }
      
      public function addGroupLayerTaint() : void
      {
         if(!this.group)
         {
            return;
         }
         this.group.setDirty();
      }
      
      public function set isoU(param1:Number) : void
      {
         if(this._uvz.x == param1)
         {
            this.delta.x = 0;
            return;
         }
         this.delta.x = param1 - this._uvz.x;
         this._uvz.x = this.min_u = this.max_u = param1;
         this.recalc();
      }
      
      public function set isoV(param1:Number) : void
      {
         if(this._uvz.y == param1)
         {
            this.delta.y = 0;
            return;
         }
         this.delta.y = param1 - this._uvz.y;
         this._uvz.y = this.max_v = this.min_v = param1;
         this.recalc();
      }
      
      public function set isoZ(param1:Number) : void
      {
         if(this._uvz.z == param1)
         {
            this.delta.z = 0;
            return;
         }
         this.delta.z = param1 - this._uvz.z;
         this._uvz.z = this.max_z = this.min_z = param1;
         this.recalc();
      }
      
      public function getIsoPosition(param1:Boolean = true) : Vector3D
      {
         return !!param1?this._uvz.clone():this._uvz;
      }
      
      public function setIsoPosition(param1:Number, param2:Number, param3:Number) : void
      {
         if(this._uvz.x != param1 || this._uvz.y != param2 || this._uvz.z != param3)
         {
            this.min_u = this.max_u = param1;
            this.max_v = this.min_v = param2;
            this.max_z = this.min_z = param3;
            this.delta.x = param1 - this._uvz.x;
            this.delta.y = param2 - this._uvz.y;
            this.delta.z = param3 - this._uvz.z;
            this._uvz.x = param1;
            this._uvz.y = param2;
            this._uvz.z = param3;
            this.recalc();
            if(this.group != null)
            {
               this.group.setDirty();
            }
         }
         else
         {
            this.delta.x = this.delta.y = this.delta.z = 0;
         }
      }
      
      protected function recalc() : void
      {
         this.depth = IsoGrid.depth(this._uvz.x,this._uvz.y,this._uvz.z);
         this.baseX = IsoGrid.uvztox(this._uvz.x,this._uvz.y,this._uvz.z);
         this.baseY = IsoGrid.uvztoy(this._uvz.x,this._uvz.y,this._uvz.z);
      }
      
      public function cleanup() : void
      {
      }
      
      public function update(param1:int) : void
      {
         this.delta.x = this.delta.y = this.delta.z = 0;
      }
      
      public function get displayindex() : int
      {
         if(!this.parent)
         {
            return -1;
         }
         if(!this.group)
         {
            return -1;
         }
         var _loc1_:int = this.group.getDisplayIndex(this);
         if(_loc1_ < 0)
         {
            return -1;
         }
         return this.group.treedepth * 300 + _loc1_;
      }
      
      public function intersectsArea(param1:Number, param2:Number, param3:Number, param4:Number) : Boolean
      {
         return !(param1 > this.max_u || param2 > this.max_v || this.min_u > param3 || this.min_v > param4);
      }
      
      public function containsArea(param1:Number, param2:Number, param3:Number, param4:Number) : Boolean
      {
         return this.containsUV(param1,param2) && this.containsUV(param3,param4);
      }
      
      public function containsUV(param1:Number, param2:Number) : Boolean
      {
         return param1 >= this.min_u && param1 <= this.max_u && param2 >= this.min_v && param2 <= this.max_v;
      }
      
      public function intersects(param1:IsoSortable, param2:Array = null, param3:Array = null, param4:Boolean = false) : Boolean
      {
         return this.intersectsArea(param1.min_u,param1.min_v,param1.max_u,param1.max_v);
      }
   }
}
