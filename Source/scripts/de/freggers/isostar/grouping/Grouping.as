package de.freggers.isostar.grouping
{
   import de.freggers.isostar.IsoSortable;
   import de.freggers.isostar.IsoSortableGroup;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   import flash.utils.getTimer;
   
   public final class Grouping
   {
       
      
      public function Grouping()
      {
         super();
      }
      
      public static function buildGroups(param1:IsoSortableGroup) : void
      {
         var _loc7_:IsoSortable = null;
         var _loc8_:int = 0;
         var _loc2_:int = getTimer();
         param1.flatten();
         var _loc3_:Vector.<IsoSortableGroup> = new Vector.<IsoSortableGroup>();
         var _loc4_:Vector.<IsoSortable> = param1.isosortables;
         var _loc5_:Vector.<IsoSortable> = new Vector.<IsoSortable>();
         var _loc6_:Vector.<IsoSortable> = new Vector.<IsoSortable>();
         var _loc9_:int = _loc4_.length;
         _loc8_ = 0;
         while(_loc8_ < _loc9_)
         {
            _loc7_ = _loc4_[_loc8_] as IsoSortable;
            if(_loc7_)
            {
               if((_loc7_.flags & IsoSortable.FLAG_GROUPABLE) != 0)
               {
                  _loc5_.push(_loc7_);
               }
               else
               {
                  _loc6_.push(_loc7_);
               }
            }
            _loc8_++;
         }
         buildGroupFromGroupData(findGroupsInIsoSortables(_loc5_),param1,1,_loc3_);
         checkGroupingArr(_loc6_);
      }
      
      public static function checkGroupingArr(param1:Vector.<IsoSortable>, param2:Boolean = false) : void
      {
         var _loc3_:IsoSortable = null;
         var _loc4_:int = 0;
         var _loc5_:int = param1.length;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc3_ = param1[_loc4_] as IsoSortable;
            if(_loc3_)
            {
               checkGrouping(_loc3_,param2);
            }
            _loc4_++;
         }
      }
      
      public static function checkGrouping(param1:IsoSortable, param2:Boolean = false) : void
      {
         var _loc3_:IsoSortableGroup = null;
         if(!param1 || !param1.group)
         {
            return;
         }
         if(param1.group.intersectsArea(param1.min_u,param1.min_v,param1.max_u,param1.max_v))
         {
            _loc3_ = param1.group.searchGroupDown(param1.min_u,param1.min_v,param1.max_u,param1.max_v);
         }
         else
         {
            _loc3_ = param1.group.searchGroupUp(param1.min_u,param1.min_v,param1.max_u,param1.max_v);
            if(_loc3_)
            {
               _loc3_ = _loc3_.searchGroupDown(param1.min_u,param1.min_v,param1.max_u,param1.max_v);
            }
         }
         if(!_loc3_)
         {
            return;
         }
         if(_loc3_ == param1.group)
         {
            if(param2)
            {
               _loc3_.setDirty();
            }
            return;
         }
         if(param1.group)
         {
            param1.group.removeIsoSortable(param1);
         }
         _loc3_.addIsoSortable(param1);
      }
      
      public static function findGroupsInIsoSortables(param1:Vector.<IsoSortable>) : GroupData
      {
         var _loc2_:GroupData = new GroupData(findBoundsInIsoSortables(param1),param1);
         Grouping.splitGroupData(_loc2_);
         Grouping.cleanupTree(_loc2_);
         return _loc2_;
      }
      
      private static function findBoundsInIsoSortables(param1:Vector.<IsoSortable>) : Rectangle
      {
         var _loc2_:IsoSortable = null;
         var _loc8_:int = 0;
         var _loc3_:Number = 0;
         var _loc4_:Number = 0;
         var _loc5_:Number = Number.MAX_VALUE;
         var _loc6_:Number = Number.MAX_VALUE;
         var _loc7_:int = param1.length;
         _loc8_ = 0;
         while(_loc8_ < _loc7_)
         {
            _loc2_ = param1[_loc8_];
            if(_loc2_ != null)
            {
               _loc3_ = _loc2_.max_u > _loc3_?Number(_loc2_.max_u):Number(_loc3_);
               _loc4_ = _loc2_.max_v > _loc4_?Number(_loc2_.max_v):Number(_loc4_);
               _loc5_ = _loc2_.min_u < _loc5_?Number(_loc2_.min_u):Number(_loc5_);
               _loc6_ = _loc2_.min_v < _loc6_?Number(_loc2_.min_v):Number(_loc6_);
            }
            _loc8_++;
         }
         return new Rectangle(_loc5_,_loc6_,_loc3_ - _loc5_ + 1,_loc4_ - _loc6_ + 1);
      }
      
      private static function splitGroupData(param1:GroupData) : void
      {
         var _loc2_:Rectangle = null;
         var _loc3_:Rectangle = null;
         var _loc4_:IsoSortable = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc10_:CutData = null;
         var _loc11_:CutData = null;
         var _loc12_:CutData = null;
         if(param1.area == null || param1.isosortables == null)
         {
            return;
         }
         var _loc8_:Vector.<CutData> = findCuts(param1.isosortables,param1.area,CutData.CUT_HORIZONTAL);
         var _loc9_:Vector.<CutData> = findCuts(param1.isosortables,param1.area,CutData.CUT_VERTICAL);
         if(_loc8_)
         {
            _loc11_ = _loc8_[0];
         }
         if(_loc9_)
         {
            _loc10_ = _loc9_[0];
         }
         if(_loc10_ && _loc11_)
         {
            _loc12_ = _loc11_.weight < _loc10_.weight?_loc11_:_loc10_;
         }
         else if(_loc10_)
         {
            _loc12_ = _loc10_;
         }
         else if(_loc11_)
         {
            _loc12_ = _loc11_;
         }
         else
         {
            return;
         }
         if(_loc12_.cutDirection == CutData.CUT_HORIZONTAL)
         {
            _loc2_ = new Rectangle(param1.area.x,param1.area.y,param1.area.width,_loc12_.cutPosition);
            _loc3_ = new Rectangle(param1.area.x,param1.area.y + _loc12_.cutPosition,param1.area.width,param1.area.height - _loc12_.cutPosition);
         }
         else
         {
            _loc2_ = new Rectangle(param1.area.x,param1.area.y,_loc12_.cutPosition,param1.area.height);
            _loc3_ = new Rectangle(param1.area.x + _loc12_.cutPosition,param1.area.y,param1.area.width - _loc12_.cutPosition,param1.area.height);
         }
         param1.subGroupData1 = new GroupData(_loc2_,_loc12_.isosortablesBeforeCut);
         param1.subGroupData2 = new GroupData(_loc3_,_loc12_.isosortablesAfterCut);
         if(param1.isosortables != null)
         {
            if(param1.subGroupData1.isosortables != null)
            {
               _loc7_ = param1.subGroupData1.isosortables.length;
               _loc6_ = 0;
               while(_loc6_ < _loc7_)
               {
                  _loc4_ = param1.subGroupData1.isosortables[_loc6_] as IsoSortable;
                  if(_loc4_)
                  {
                     _loc5_ = param1.isosortables.indexOf(_loc4_);
                     if(_loc5_ != -1)
                     {
                        param1.isosortables.splice(_loc5_,1);
                     }
                  }
                  _loc6_++;
               }
            }
            if(param1.subGroupData2.isosortables != null)
            {
               _loc7_ = param1.subGroupData2.isosortables.length;
               _loc6_ = 0;
               while(_loc6_ < _loc7_)
               {
                  _loc4_ = param1.subGroupData2.isosortables[_loc6_] as IsoSortable;
                  _loc5_ = param1.isosortables.indexOf(_loc4_);
                  if(_loc5_ != -1)
                  {
                     param1.isosortables.splice(_loc5_,1);
                  }
                  _loc6_++;
               }
            }
         }
         splitGroupData(param1.subGroupData1);
         splitGroupData(param1.subGroupData2);
      }
      
      private static function findCuts(param1:Vector.<IsoSortable>, param2:Rectangle, param3:Boolean = false) : Vector.<CutData>
      {
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc13_:IsoSortable = null;
         var _loc14_:Boolean = false;
         var _loc19_:Vector.<IsoSortable> = null;
         var _loc20_:Vector.<IsoSortable> = null;
         var _loc4_:int = param1.length;
         var _loc5_:Vector.<CutData> = new Vector.<CutData>(_loc4_ - 1);
         var _loc6_:Dictionary = new Dictionary(true);
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc12_:int = 0;
         var _loc15_:Number = 0;
         var _loc16_:Number = 1;
         var _loc17_:Vector.<IsoSortable> = new Vector.<IsoSortable>(_loc4_,true);
         var _loc18_:Dictionary = new Dictionary(true);
         _loc9_ = 0;
         while(_loc9_ < _loc4_)
         {
            _loc18_[param1[_loc9_]] = param1[_loc9_];
            _loc9_++;
         }
         var _loc21_:Rectangle = new Rectangle(param2.x,param2.y);
         var _loc22_:Rectangle = new Rectangle();
         if(param3)
         {
            _loc21_.width = param2.width;
         }
         else
         {
            _loc21_.height = param2.height;
         }
         do
         {
            _loc14_ = false;
            if(param3)
            {
               _loc21_.height = _loc12_;
            }
            else
            {
               _loc21_.width = _loc12_;
            }
            _loc9_ = 0;
            while(_loc9_ < _loc4_)
            {
               _loc13_ = param1[_loc9_] as IsoSortable;
               if(!(_loc13_ == null || _loc6_[_loc13_] == true))
               {
                  _loc22_.x = _loc13_.min_u;
                  _loc22_.y = _loc13_.min_v;
                  _loc22_.width = _loc13_.max_u - _loc13_.min_u + 1;
                  _loc22_.height = _loc13_.max_v - _loc13_.min_v + 1;
                  if(_loc21_.containsRect(_loc22_))
                  {
                     _loc6_[_loc13_] = true;
                     _loc17_[_loc7_++] = _loc13_;
                     delete _loc18_[_loc13_];
                  }
                  else if(_loc21_.intersects(_loc22_))
                  {
                     _loc14_ = _loc14_ || true;
                  }
               }
               _loc9_++;
            }
            if(!_loc14_)
            {
               _loc15_ = _loc7_ / _loc4_ - 0.5;
               if(_loc15_ < 0)
               {
                  _loc15_ = _loc15_ * -1;
               }
               if(_loc15_ < 0.5 && _loc16_ != _loc15_)
               {
                  if(_loc15_ > _loc16_)
                  {
                     break;
                  }
                  _loc19_ = _loc17_.slice();
                  _loc19_.length = _loc7_;
                  _loc20_ = new Vector.<IsoSortable>(_loc4_ - _loc7_);
                  _loc10_ = 0;
                  for each(_loc13_ in _loc18_)
                  {
                     _loc20_[_loc10_++] = _loc13_;
                  }
                  _loc5_[_loc8_++] = new CutData(param2,_loc12_,_loc15_,_loc19_,_loc20_,param3);
                  _loc16_ = _loc15_;
               }
            }
            _loc12_++;
         }
         while(_loc7_ < _loc4_);
         
         if(_loc8_ == 0)
         {
            return null;
         }
         _loc5_.length = _loc8_;
         return _loc5_.reverse();
      }
      
      private static function cleanupTree(param1:GroupData) : void
      {
         if(param1.subGroupData1 != null)
         {
            cleanupTree(param1.subGroupData1);
         }
         if(param1.subGroupData2 != null)
         {
            cleanupTree(param1.subGroupData2);
         }
         if(param1.subGroupData1 != null && param1.subGroupData1.isosortables.length == 1)
         {
            param1.isosortables = param1.isosortables.concat(param1.subGroupData1.isosortables);
            if(param1.subGroupData1.subGroupData1 == null && param1.subGroupData1.subGroupData2 == null)
            {
               param1.subGroupData1 = null;
            }
         }
         if(param1.subGroupData2 != null && param1.subGroupData2.isosortables.length <= 1 && param1.subGroupData2.subGroupData1 == null && param1.subGroupData2.subGroupData2 == null)
         {
            param1.isosortables = param1.isosortables.concat(param1.subGroupData2.isosortables);
            if(param1.subGroupData2.subGroupData1 == null && param1.subGroupData2.subGroupData2 == null)
            {
               param1.subGroupData2 = null;
            }
         }
      }
      
      private static function buildGroupFromGroupData(param1:GroupData, param2:IsoSortableGroup, param3:int, param4:Vector.<IsoSortableGroup>) : void
      {
         var _loc6_:int = 0;
         var _loc7_:IsoSortable = null;
         if(param1 == null || param2 == null)
         {
            return;
         }
         var _loc5_:IsoSortableGroup = new IsoSortableGroup(param1.area);
         _loc5_.treedepth = param3;
         var _loc8_:int = param1.isosortables.length;
         _loc6_ = 0;
         while(_loc6_ < _loc8_)
         {
            _loc7_ = param1.isosortables[_loc6_] as IsoSortable;
            if(_loc7_)
            {
               if(_loc7_.group)
               {
                  _loc7_.group.removeIsoSortable(_loc7_);
               }
               _loc5_.addIsoSortable(_loc7_);
            }
            _loc6_++;
         }
         param3++;
         if(param1.subGroupData1 != null)
         {
            buildGroupFromGroupData(param1.subGroupData1,_loc5_,param3,param4);
         }
         if(param1.subGroupData2 != null)
         {
            buildGroupFromGroupData(param1.subGroupData2,_loc5_,param3,param4);
         }
         param4.push(_loc5_);
         param2.addIsoSortable(_loc5_);
      }
   }
}
