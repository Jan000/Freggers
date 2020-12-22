package de.freggers.isostar
{
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   
   public class IsoSortableGroup extends IsoSortable
   {
       
      
      private var _isosortablecontainer:Sprite;
      
      private var _isosortables:Vector.<IsoSortable>;
      
      private var _idlecount:uint;
      
      public function IsoSortableGroup(param1:Rectangle)
      {
         this._idlecount = uint(Math.random() * (IsoStar.INTERLACEIDLEFRAMES + 1));
         super();
         this._isosortablecontainer = new Sprite();
         this._isosortables = new Vector.<IsoSortable>();
         this._isosortablecontainer.mouseEnabled = false;
         max_z = min_z = 0;
         min_u = param1.x;
         min_v = param1.y;
         max_u = min_u + param1.width - 1;
         max_v = min_v + param1.height - 1;
         this.isoU = min_u + (max_u - min_u) / 2;
         this.isoV = min_v + (max_v - min_v) / 2;
         depth = IsoGrid.depth(isoU,isoV,isoZ);
         addChild(this._isosortablecontainer);
      }
      
      private static function customSortMain_Vector(param1:Vector.<IsoSortable>) : void
      {
         var _loc3_:int = 0;
         var _loc4_:IsoSortable = null;
         var _loc5_:IsoSortable = null;
         var _loc2_:int = 0;
         var _loc6_:uint = 0;
         var _loc7_:int = param1.length;
         var _loc8_:int = _loc7_ * _loc7_;
         var _loc9_:int = 0;
         while(_loc2_ < _loc7_)
         {
            _loc3_ = _loc2_ - 1;
            _loc4_ = param1[_loc2_];
            _loc5_ = _loc2_ > 0?param1[_loc3_]:null;
            if(!_loc4_ || !_loc5_)
            {
               _loc2_++;
            }
            else
            {
               if(_loc9_++ >= _loc8_)
               {
                  break;
               }
               if(_loc4_.max_u < _loc5_.min_u)
               {
                  param1[_loc2_] = _loc5_;
                  param1[_loc3_] = _loc4_;
                  _loc2_--;
               }
               else if(_loc4_.min_u > _loc5_.max_u)
               {
                  _loc2_++;
               }
               else if(_loc4_.max_v < _loc5_.min_v)
               {
                  param1[_loc2_] = _loc5_;
                  param1[_loc3_] = _loc4_;
                  _loc2_--;
               }
               else if(_loc4_.min_v > _loc5_.max_v)
               {
                  _loc2_++;
               }
               else if(_loc4_.max_z < _loc5_.min_z)
               {
                  param1[_loc2_] = _loc5_;
                  param1[_loc3_] = _loc4_;
                  _loc2_--;
               }
               else if(_loc4_.min_z > _loc5_.max_z)
               {
                  _loc2_++;
               }
               else if(_loc4_.depth < _loc5_.depth)
               {
                  param1[_loc2_] = _loc5_;
                  param1[_loc3_] = _loc4_;
                  _loc2_--;
               }
               else if(_loc4_.depth > _loc5_.depth)
               {
                  _loc2_++;
               }
               else if(_loc4_.isoZ < _loc5_.isoZ)
               {
                  param1[_loc2_] = _loc5_;
                  param1[_loc3_] = _loc4_;
                  _loc2_--;
               }
               else if(_loc4_.isoZ > _loc5_.isoZ)
               {
                  _loc2_++;
               }
               else if(_loc4_.addid < _loc5_.addid)
               {
                  param1[_loc2_] = _loc5_;
                  param1[_loc3_] = _loc4_;
                  _loc2_--;
               }
               else
               {
                  _loc2_++;
               }
            }
         }
      }
      
      private static function compareBase(param1:IsoSortable, param2:IsoSortable) : int
      {
         if(param1.baseX > param2.baseX)
         {
            return 1;
         }
         if(param1.baseX < param2.baseX)
         {
            return -1;
         }
         if(param1.baseY > param2.baseY)
         {
            return 1;
         }
         if(param1.baseY < param2.baseY)
         {
            return -1;
         }
         return 0;
      }
      
      public function addIsoSortable(param1:IsoSortable) : void
      {
         param1.group = this;
         param1.addid = ++IsoStar.CURRENTADDID;
         if(param1.parent != this._isosortablecontainer)
         {
            this._isosortablecontainer.addChild(param1);
         }
         if(this._isosortables.indexOf(param1) == -1)
         {
            this._isosortables.push(param1);
         }
         min_z = this.findBottom();
         max_z = this.findTop();
         setDirty();
      }
      
      public function getDisplayIndex(param1:IsoSortable) : int
      {
         if(!this._isosortablecontainer || param1.parent != this._isosortablecontainer)
         {
            return -1;
         }
         return this._isosortablecontainer.getChildIndex(param1);
      }
      
      public function swapIsoSortables(param1:IsoSortable, param2:IsoSortable) : void
      {
         if(!this._isosortablecontainer || param1.parent != this._isosortablecontainer || param2.parent != this._isosortablecontainer)
         {
            return;
         }
         this._isosortablecontainer.swapChildren(param1,param2);
      }
      
      public function findBottom() : uint
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:IsoSortable = null;
         var _loc1_:uint = 4294967295;
         var _loc5_:int = this._isosortables.length;
         _loc3_ = 0;
         while(_loc3_ < _loc5_)
         {
            _loc4_ = this._isosortables[_loc3_];
            if(_loc4_)
            {
               if(_loc4_ is IsoSortableGroup)
               {
                  _loc2_ = (_loc4_ as IsoSortableGroup).findBottom();
               }
               else if(_loc4_ is IsoSprite)
               {
                  _loc2_ = (_loc4_ as IsoSprite).min_z;
               }
               _loc1_ = _loc1_ < _loc2_?uint(_loc1_):uint(_loc2_);
            }
            _loc3_++;
         }
         return _loc1_;
      }
      
      public function findTop() : uint
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:IsoSortable = null;
         var _loc1_:uint = 0;
         var _loc5_:int = this._isosortables.length;
         _loc3_ = 0;
         while(_loc3_ < _loc5_)
         {
            _loc4_ = this._isosortables[_loc3_];
            if(_loc4_)
            {
               if(_loc4_ is IsoSortableGroup)
               {
                  _loc2_ = (_loc4_ as IsoSortableGroup).findTop();
               }
               else if(_loc4_ is IsoSprite)
               {
                  _loc2_ = (_loc4_ as IsoSprite).max_z;
               }
               _loc1_ = _loc1_ > _loc2_?uint(_loc1_):uint(_loc2_);
            }
            _loc3_++;
         }
         return _loc1_;
      }
      
      protected function computeBounds() : void
      {
         var _loc1_:Rectangle = null;
         var _loc2_:uint = 0;
         var _loc3_:IsoSortable = null;
         var _loc4_:int = this._isosortables.length;
         _loc2_ = 0;
         while(_loc2_ < _loc4_)
         {
            _loc3_ = this._isosortables[_loc2_];
            if(_loc3_)
            {
               if(!_loc1_)
               {
                  _loc1_ = _loc3_.bounds.clone();
               }
               else
               {
                  _loc1_ = _loc1_.union(_loc3_.bounds);
               }
            }
            _loc2_++;
         }
         if(!_loc1_)
         {
            _loc1_ = new Rectangle();
         }
         bounds = _loc1_;
         if(group)
         {
            group.computeBounds();
         }
      }
      
      public function removeIsoSortable(param1:IsoSortable) : void
      {
         if(!param1 || !this._isosortablecontainer.contains(param1))
         {
            return;
         }
         var _loc2_:int = this._isosortables.indexOf(param1);
         param1.group = null;
         param1.addid = 0;
         if(param1.parent == this._isosortablecontainer)
         {
            this._isosortablecontainer.removeChild(param1);
         }
         if(_loc2_ >= 0)
         {
            this._isosortables.splice(_loc2_,1);
         }
         this.computeBounds();
         setDirty();
      }
      
      override public function update(param1:int) : void
      {
         var _loc2_:IsoSortable = null;
         if(this._idlecount == IsoStar.INTERLACEIDLEFRAMES)
         {
            this._idlecount = 0;
            this.update_interlaced(param1);
         }
         else
         {
            this._idlecount++;
         }
         for each(_loc2_ in this._isosortables)
         {
            _loc2_.update(param1);
         }
      }
      
      public function update_interlaced(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(isDirty())
         {
            removeDirty();
            _loc2_ = this._isosortables.length;
            if(_loc2_ >= 2)
            {
               this._isosortables.sort(compareBase);
               customSortMain_Vector(this._isosortables);
               _loc3_ = 0;
               while(_loc3_ < _loc2_)
               {
                  this._isosortablecontainer.setChildIndex(this._isosortables[_loc3_],_loc3_);
                  _loc3_++;
               }
            }
            this.computeBounds();
         }
      }
      
      public function searchGroupDown(param1:Number, param2:Number, param3:Number, param4:Number) : IsoSortableGroup
      {
         var _loc5_:IsoSortableGroup = null;
         var _loc6_:IsoSortableGroup = null;
         var _loc7_:uint = 0;
         if(!intersectsArea(param1,param2,param3,param4))
         {
            return null;
         }
         var _loc8_:int = this._isosortables.length;
         _loc7_ = 0;
         while(_loc7_ < _loc8_)
         {
            _loc6_ = this._isosortables[_loc7_] as IsoSortableGroup;
            if(_loc6_)
            {
               _loc5_ = _loc6_.searchGroupDown(param1,param2,param3,param4);
               if(_loc5_)
               {
                  return _loc5_;
               }
            }
            _loc7_++;
         }
         return this;
      }
      
      public function searchGroupUp(param1:Number, param2:Number, param3:Number, param4:Number) : IsoSortableGroup
      {
         if(intersectsArea(param1,param2,param3,param4))
         {
            return this;
         }
         if(!this.group)
         {
            return null;
         }
         return this.group.searchGroupUp(param1,param2,param3,param4);
      }
      
      public function get groupslocked() : Boolean
      {
         if(!this.group)
         {
            return false;
         }
         return this.group.groupslocked;
      }
      
      public function getIsoStar() : IsoStar
      {
         if(!this.group)
         {
            return null;
         }
         return this.group.getIsoStar();
      }
      
      override public function cleanup() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:IsoSortable = null;
         super.cleanup();
         var _loc3_:int = this._isosortables.length;
         _loc1_ = 0;
         while(_loc1_ < _loc3_)
         {
            _loc2_ = this._isosortables[_loc1_];
            if(_loc2_ != null)
            {
               if(_loc2_.parent != null)
               {
                  _loc2_.parent.removeChild(_loc2_);
               }
               _loc2_.cleanup();
            }
            _loc1_++;
         }
         this._isosortables.length = 0;
      }
      
      public function addIsoLight(param1:IsoLight) : void
      {
         if(!this.group)
         {
            return;
         }
         this.group.addIsoLight(param1);
      }
      
      public function addIsoShadow(param1:IsoShadow) : void
      {
         if(!this.group)
         {
            return;
         }
         this.group.addIsoShadow(param1);
      }
      
      public function removeIsoLight(param1:IsoLight) : void
      {
         if(!this.group)
         {
            return;
         }
         this.group.removeIsoLight(param1);
      }
      
      public function removeIsoShadow(param1:IsoShadow) : void
      {
         if(!this.group)
         {
            return;
         }
         this.group.removeIsoShadow(param1);
      }
      
      public function onScreen(param1:IsoSortable) : Boolean
      {
         if(this.group)
         {
            return this.group.onScreen(param1);
         }
         return true;
      }
      
      public function get isosortablecontainer() : DisplayObjectContainer
      {
         return this._isosortablecontainer;
      }
      
      public function removeAllIsoSortables() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:IsoSortable = null;
         var _loc3_:int = this._isosortables.length;
         _loc1_ = 0;
         while(_loc1_ < _loc3_)
         {
            _loc2_ = this._isosortables[_loc1_];
            if(_loc2_)
            {
               if(_loc2_ is IsoSortableGroup)
               {
                  (_loc2_ as IsoSortableGroup).removeAllIsoSortables();
               }
               this.removeIsoSortable(_loc2_);
            }
            _loc1_++;
         }
         this._isosortables.length = 0;
      }
      
      public function flatten() : void
      {
         var _loc2_:uint = 0;
         var _loc3_:IsoSortable = null;
         var _loc1_:Array = new Array();
         this.collectIsoSortables(_loc1_);
         var _loc4_:uint = _loc1_.length;
         _loc2_ = 0;
         while(_loc2_ < _loc4_)
         {
            _loc3_ = _loc1_[_loc2_] as IsoSortable;
            if(!(!_loc3_ || !_loc3_.group))
            {
               if(_loc3_ is IsoSprite)
               {
                  if(_loc3_.group != this)
                  {
                     _loc3_.group.removeIsoSortable(_loc3_);
                     this.addIsoSortable(_loc3_);
                  }
               }
               else if(_loc3_ is IsoSortableGroup)
               {
                  _loc3_.group.removeIsoSortable(_loc3_);
               }
            }
            _loc2_++;
         }
      }
      
      protected function collectIsoSortables(param1:Array) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:IsoSortable = null;
         var _loc4_:int = this._isosortables.length;
         _loc2_ = 0;
         while(_loc2_ < _loc4_)
         {
            _loc3_ = this._isosortables[_loc2_];
            if(_loc3_)
            {
               if(_loc3_ is IsoSortableGroup)
               {
                  (_loc3_ as IsoSortableGroup).collectIsoSortables(param1);
               }
               param1.push(_loc3_);
            }
            _loc2_++;
         }
      }
      
      public function collectIsoSprites(param1:Vector.<IsoSprite>) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:IsoSortable = null;
         var _loc4_:int = this._isosortables.length;
         _loc2_ = 0;
         while(_loc2_ < _loc4_)
         {
            _loc3_ = this._isosortables[_loc2_];
            if(_loc3_)
            {
               if(_loc3_ is IsoSortableGroup)
               {
                  (_loc3_ as IsoSortableGroup).collectIsoSprites(param1);
               }
               else if(_loc3_ is IsoSprite)
               {
                  param1.push(_loc3_);
               }
            }
            _loc2_++;
         }
      }
      
      public function findIsoSpritesOver(param1:int, param2:int) : Vector.<IsoSprite>
      {
         var _loc3_:Vector.<IsoSprite> = null;
         var _loc4_:Vector.<IsoSprite> = null;
         var _loc5_:IsoSortable = null;
         var _loc6_:uint = 0;
         if(!this.containsUV(param1,param2))
         {
            return null;
         }
         var _loc7_:int = this._isosortables.length;
         _loc6_ = 0;
         while(_loc6_ < _loc7_)
         {
            _loc5_ = this._isosortables[_loc6_];
            if(_loc5_)
            {
               if(_loc5_ is IsoSortableGroup)
               {
                  _loc4_ = (_loc5_ as IsoSortableGroup).findIsoSpritesOver(param1,param2);
                  if(_loc4_)
                  {
                     if(!_loc3_)
                     {
                        _loc3_ = _loc4_;
                     }
                     else
                     {
                        _loc3_ = _loc3_.concat(_loc4_);
                     }
                  }
               }
               else if(_loc5_ is IsoSprite)
               {
                  if(!_loc3_)
                  {
                     _loc3_ = new Vector.<IsoSprite>();
                  }
                  if(_loc5_.containsUV(param1,param2))
                  {
                     _loc3_.push(_loc5_);
                  }
               }
            }
            _loc6_++;
         }
         return _loc3_;
      }
      
      public function detectCollisionObject(param1:IsoSprite) : Boolean
      {
         var _loc2_:IsoSortable = null;
         var _loc3_:IsoSortableGroup = null;
         if(!intersects(param1,null,null,false))
         {
            return false;
         }
         for each(_loc2_ in this._isosortables)
         {
            if(!(!_loc2_ || _loc2_ == param1 || !param1.intersects(_loc2_)))
            {
               if(_loc2_ is IsoSprite)
               {
                  return true;
               }
               _loc3_ = _loc2_ as IsoSortableGroup;
               if(_loc3_ && _loc3_.detectCollisionObject(param1))
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      public function get isosortables() : Vector.<IsoSortable>
      {
         return this._isosortables;
      }
      
      public function get isosortablegroups() : Vector.<IsoSortable>
      {
         return this._isosortables.filter(this.__filter_isIsoSortableGroup);
      }
      
      private function __filter_isIsoSortableGroup(param1:IsoSortable, param2:int, param3:Vector.<IsoSortable>) : Boolean
      {
         return param1 is IsoSortableGroup;
      }
      
      public function notifyRemoveFlag(param1:IsoSortable, param2:uint) : void
      {
         if(group)
         {
            group.notifyRemoveFlag(param1,param2);
         }
      }
      
      public function notifyAddFlag(param1:IsoSortable, param2:uint) : void
      {
         if(group)
         {
            group.notifyAddFlag(param1,param2);
         }
      }
      
      override public function set isoU(param1:Number) : void
      {
      }
      
      override public function set isoV(param1:Number) : void
      {
      }
      
      override public function set isoZ(param1:Number) : void
      {
      }
      
      override public function setIsoPosition(param1:Number, param2:Number, param3:Number) : void
      {
      }
      
      override public function toString() : String
      {
         return "ISG#" + addid + "[l=" + min_u + ", r=" + max_u + ", b=" + min_v + ", f=" + max_v + ", b=" + min_z + ", t=" + max_z + ", group=" + group + "]";
      }
   }
}
