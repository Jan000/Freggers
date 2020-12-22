package de.schulterklopfer.interaction.manager
{
   import flash.display.DisplayObjectContainer;
   import flash.display.InteractiveObject;
   import flash.display.Stage;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   
   public final class InteractionManager
   {
      
      private static var _objects:Vector.<InteractiveObject>;
      
      private static var _groupByObject:Dictionary;
      
      private static var _objectsByGroup:Dictionary;
      
      private static var _inited:Boolean = false;
      
      private static var _disabledObjects:Dictionary;
       
      
      public function InteractionManager()
      {
         super();
      }
      
      private static function init() : void
      {
         _objects = new Vector.<InteractiveObject>();
         _objectsByGroup = new Dictionary(true);
         _groupByObject = new Dictionary(true);
         _disabledObjects = new Dictionary(true);
         _inited = true;
      }
      
      public static function registerForMouse(param1:InteractiveObject, param2:Function = null, param3:String = null, param4:int = 0) : void
      {
         if(!_inited)
         {
            init();
         }
         if(_objects.indexOf(param1) > -1)
         {
            return;
         }
         _objects.push(param1);
         if(param3 != null)
         {
            _setGroupFor(param3,param1);
         }
         MouseManager.registerCallback(param1,param2);
         MouseManager.enableMouseEventsFor(param1,true,handleMouse,false,param4);
         enableMouseFor(param1);
      }
      
      public static function removeForMouse(param1:InteractiveObject) : void
      {
         if(!_inited)
         {
            return;
         }
         var _loc2_:int = _objects.indexOf(param1);
         if(_loc2_ == -1)
         {
            return;
         }
         disableMouseFor(param1);
         _objects.splice(_loc2_,1);
         _deleteGroupFor(param1);
         deleteMouseHandlerCallbackFor(param1);
      }
      
      public static function removeGroupForMouse(param1:String) : void
      {
         var _loc3_:int = 0;
         if(!_inited)
         {
            return;
         }
         var _loc2_:Vector.<InteractiveObject> = _objectsByGroup[param1];
         if(_loc2_ == null)
         {
            return;
         }
         _loc3_ = 0;
         while(_loc3_ < _loc2_.length)
         {
            if(_loc2_[_loc3_] != null)
            {
               removeForMouse(_loc2_[_loc3_]);
            }
            _loc3_++;
         }
      }
      
      private static function _setGroupFor(param1:String, param2:InteractiveObject) : void
      {
         if(_objectsByGroup[param1] == null)
         {
            _objectsByGroup[param1] = new Vector.<InteractiveObject>();
         }
         var _loc3_:Vector.<InteractiveObject> = _objectsByGroup[param1];
         if(_loc3_.indexOf(param2) == -1)
         {
            _loc3_.push(param2);
            _groupByObject[param2] = param1;
         }
      }
      
      private static function _deleteGroupFor(param1:InteractiveObject) : void
      {
         var _loc4_:int = 0;
         var _loc2_:String = _groupByObject[param1];
         if(_loc2_ == null)
         {
            return;
         }
         delete _groupByObject[param1];
         var _loc3_:Vector.<InteractiveObject> = _objectsByGroup[_loc2_];
         if(_loc3_ != null)
         {
            _loc4_ = _loc3_.indexOf(param1);
            if(_loc4_ >= 0)
            {
               _loc3_.splice(_loc4_,1);
               if(_loc3_.length == 0)
               {
                  delete _objectsByGroup[_loc2_];
               }
            }
         }
      }
      
      public static function setGroupFor(param1:InteractiveObject, param2:String) : void
      {
         if(!_inited)
         {
            return;
         }
         var _loc3_:int = _objects.indexOf(param1);
         if(_loc3_ == -1)
         {
            return;
         }
         if(_groupByObject[param1] == param2)
         {
            return;
         }
         if(_groupByObject[param1] != null)
         {
            _deleteGroupFor(param1);
         }
         _setGroupFor(param2,param1);
      }
      
      public static function deleteGroupFor(param1:InteractiveObject) : void
      {
         if(!_inited)
         {
            return;
         }
         var _loc2_:int = _objects.indexOf(param1);
         if(_loc2_ == -1)
         {
            return;
         }
         _deleteGroupFor(param1);
      }
      
      public static function setMouseHandlerCallbackFor(param1:InteractiveObject, param2:Function) : void
      {
         if(!_inited)
         {
            return;
         }
         MouseManager.registerCallback(param1,param2);
      }
      
      public static function getMouseHandlerCallbackFor(param1:InteractiveObject) : Function
      {
         if(!_inited)
         {
            return null;
         }
         return MouseManager.getCallbackFor(param1);
      }
      
      public static function setMouseHandlerCallbackForGroup(param1:String, param2:Function) : void
      {
         var _loc4_:int = 0;
         if(!_inited)
         {
            return;
         }
         var _loc3_:Vector.<InteractiveObject> = _objectsByGroup[param1];
         if(_loc3_ == null)
         {
            return;
         }
         var _loc5_:int = _loc3_.length;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            if(_loc3_[_loc4_] != null)
            {
               setMouseHandlerCallbackFor(_loc3_[_loc4_],param2);
            }
            _loc4_++;
         }
      }
      
      public static function deleteMouseHandlerCallbackFor(param1:InteractiveObject) : void
      {
         MouseManager.registerCallback(param1,null);
      }
      
      public static function enableMouseFor(param1:InteractiveObject, param2:Boolean = false) : void
      {
         if(param1 is Stage)
         {
            return;
         }
         if(param2 && _disabledObjects[param1])
         {
            return;
         }
         param1.mouseEnabled = true;
         if(param1 is DisplayObjectContainer)
         {
            (param1 as DisplayObjectContainer).mouseChildren = true;
         }
         delete _disabledObjects[param1];
      }
      
      public static function disableMouseFor(param1:InteractiveObject, param2:Boolean = false) : void
      {
         if(param1 is Stage)
         {
            return;
         }
         param1.mouseEnabled = false;
         if(param1 is DisplayObjectContainer)
         {
            (param1 as DisplayObjectContainer).mouseChildren = false;
         }
         if(!param2)
         {
            _disabledObjects[param1] = true;
         }
      }
      
      public static function disableMouseForAll(param1:Boolean = false) : void
      {
         if(!_inited)
         {
            return;
         }
         disableMouseForAllExcept(null,param1);
      }
      
      public static function enableMouseForAll(param1:Boolean = false) : void
      {
         if(!_inited)
         {
            return;
         }
         enableMouseForAllExcept(null,param1);
      }
      
      public static function disableMouseForGroup(param1:String, param2:Boolean = false) : void
      {
         var _loc4_:int = 0;
         if(!_inited)
         {
            return;
         }
         var _loc3_:Vector.<InteractiveObject> = _objectsByGroup[param1];
         if(_loc3_ == null)
         {
            return;
         }
         var _loc5_:int = _loc3_.length;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            if(_loc3_[_loc4_] != null)
            {
               disableMouseFor(_loc3_[_loc4_],param2);
            }
            _loc4_++;
         }
      }
      
      public static function enableMouseForGroup(param1:String, param2:Boolean = false) : void
      {
         var _loc4_:int = 0;
         if(!_inited)
         {
            return;
         }
         var _loc3_:Vector.<InteractiveObject> = _objectsByGroup[param1];
         if(_loc3_ == null)
         {
            return;
         }
         var _loc5_:int = _loc3_.length;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            if(_loc3_[_loc4_] != null)
            {
               enableMouseFor(_loc3_[_loc4_],param2);
            }
            _loc4_++;
         }
      }
      
      public static function disableMouseForAllExcept(param1:InteractiveObject, param2:Boolean = false) : void
      {
         var _loc3_:int = 0;
         if(!_inited)
         {
            return;
         }
         var _loc4_:int = _objects.length;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            if(!(_objects[_loc3_] == null || param1 == _objects[_loc3_]))
            {
               disableMouseFor(_objects[_loc3_],param2);
            }
            _loc3_++;
         }
      }
      
      public static function enableMouseForAllExcept(param1:InteractiveObject, param2:Boolean = false) : void
      {
         var _loc3_:int = 0;
         if(!_inited)
         {
            return;
         }
         var _loc4_:int = _objects.length;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            if(!(_objects[_loc3_] == null || param1 == _objects[_loc3_]))
            {
               enableMouseFor(_objects[_loc3_],param2);
            }
            _loc3_++;
         }
      }
      
      private static function handleMouse(param1:MouseEvent) : void
      {
         if(!(param1.currentTarget is InteractiveObject))
         {
            return;
         }
         MouseManager.handle(param1);
      }
   }
}
