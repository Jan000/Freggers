package de.schulterklopfer.interaction.manager
{
   import de.schulterklopfer.interaction.data.MouseManagerData;
   import flash.display.InteractiveObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import flash.utils.getTimer;
   
   public class MouseManager
   {
      
      public static var CLICK_AND_HOLD_INTERVAL:Number = 300;
      
      public static var CLICK_AND_HOLD_ACTION_INTERVAL:Number = 700;
      
      public static var MOVE_THRESHHOLD:Number = 4;
      
      private static var _mouseEventData:Dictionary;
      
      private static const ALL_MOUSE_EVENTS:Array = [MouseEvent.CLICK,MouseEvent.DOUBLE_CLICK,MouseEvent.MOUSE_MOVE,MouseEvent.MOUSE_OUT,MouseEvent.MOUSE_OVER,MouseEvent.ROLL_OUT,MouseEvent.ROLL_OVER,MouseEvent.MOUSE_DOWN,MouseEvent.MOUSE_UP];
      
      private static var _controller:Sprite;
      
      private static var _inited:Boolean = false;
      
      private static var _currentTime:int;
      
      private static var _mouseDownAt:Point = new Point();
      
      private static var _mouseDownTime:int = -1;
      
      private static var _mouseMoved:Boolean;
      
      private static var _mouseDownAndHold:Boolean;
      
      private static var _mouseDownAndHoldAction:Boolean;
      
      private static var _draggedObject:InteractiveObject;
      
      private static var _draggingStarted:Boolean = false;
       
      
      public function MouseManager()
      {
         super();
      }
      
      private static function postMouseEventWrapperData(param1:MouseEventData) : void
      {
         var eventData:MouseEventData = param1;
         var o:InteractiveObject = eventData.currentMouseData.currentTarget as InteractiveObject;
         if(eventData.callback != null)
         {
            try
            {
               eventData.callback(eventData.currentMouseData);
               return;
            }
            catch(e:ArgumentError)
            {
               return;
            }
         }
      }
      
      private static function init() : void
      {
         _mouseEventData = new Dictionary(true);
         _controller = new Sprite();
         _currentTime = getTimer();
         _controller.addEventListener(Event.ENTER_FRAME,MouseManager.onEnterFrame);
         _inited = true;
      }
      
      private static function onEnterFrame(param1:Event) : void
      {
         var _loc2_:MouseEventData = null;
         _currentTime = getTimer();
         if(_mouseMoved || _mouseDownTime == -1)
         {
            return;
         }
         if(!_mouseDownAndHold)
         {
            if(_currentTime - _mouseDownTime > CLICK_AND_HOLD_INTERVAL)
            {
               _mouseDownAndHold = true;
               _mouseDownAndHoldAction = false;
               for each(_loc2_ in _mouseEventData)
               {
                  if(_loc2_.currentMouseData != null)
                  {
                     if(!_draggingStarted)
                     {
                        if(_loc2_.currentMouseData.type == MouseManagerData.MOUSE_DOWN)
                        {
                           _loc2_.currentMouseData.type = MouseManagerData.MOUSE_DOWN_AND_HOLD;
                           _loc2_.lastMouseData = _loc2_.currentMouseData.clone();
                           postMouseEventWrapperData(_loc2_.clone());
                        }
                     }
                  }
               }
            }
         }
         else if(_mouseDownAndHold && !_mouseDownAndHoldAction)
         {
            if(_currentTime - _mouseDownTime > CLICK_AND_HOLD_INTERVAL + CLICK_AND_HOLD_ACTION_INTERVAL)
            {
               _mouseDownAndHoldAction = true;
               for each(_loc2_ in _mouseEventData)
               {
                  if(_loc2_.currentMouseData != null)
                  {
                     if(!_draggingStarted)
                     {
                        if(_loc2_.currentMouseData.type == MouseManagerData.MOUSE_DOWN_AND_HOLD)
                        {
                           _loc2_.currentMouseData.type = MouseManagerData.MOUSE_DOWN_AND_HOLD_ACTION;
                           _loc2_.lastMouseData = _loc2_.currentMouseData.clone();
                           postMouseEventWrapperData(_loc2_.clone());
                        }
                     }
                  }
               }
            }
         }
      }
      
      private static function handleMouseUp(param1:MouseEventData) : void
      {
         _mouseDownTime = -1;
         if(_draggingStarted && param1.currentMouseData.currentTarget == _draggedObject)
         {
            param1.currentMouseData.type = MouseManagerData.STOP_DRAG;
            postMouseEventWrapperData(param1.clone());
            _draggingStarted = false;
         }
         param1.currentMouseData.type = MouseManagerData.MOUSE_UP;
         postMouseEventWrapperData(param1.clone());
      }
      
      public static function stageMouseUp() : void
      {
         if(_draggingStarted)
         {
            handleMouseUp(_mouseEventData[_draggedObject]);
         }
      }
      
      public static function handle(param1:MouseEvent) : void
      {
         var _loc2_:MouseEventData = null;
         var _loc3_:MouseManagerData = null;
         if(!_inited)
         {
            init();
         }
         _loc2_ = _mouseEventData[param1.currentTarget];
         if(_loc2_ == null)
         {
            return;
         }
         _loc2_.lastMouseData = _loc2_.currentMouseData;
         _loc2_.currentMouseData = new MouseManagerData(param1);
         if(_mouseDownTime != -1)
         {
            _mouseMoved = Math.abs(_mouseDownAt.x - _loc2_.currentMouseData.stageX) > MOVE_THRESHHOLD || Math.abs(_mouseDownAt.y - _loc2_.currentMouseData.stageY) > MOVE_THRESHHOLD;
         }
         switch(param1.type)
         {
            case MouseEvent.CLICK:
               if(!_mouseMoved && !_mouseDownAndHold)
               {
                  postMouseEventWrapperData(_loc2_.clone());
               }
               _mouseDownAndHold = _mouseDownAndHoldAction = false;
               break;
            case MouseEvent.DOUBLE_CLICK:
               if(!_mouseMoved && !_mouseDownAndHold)
               {
                  postMouseEventWrapperData(_loc2_.clone());
               }
               _mouseDownAndHold = _mouseDownAndHoldAction = false;
               break;
            case MouseEvent.MOUSE_DOWN:
               _mouseMoved = false;
               _mouseDownAt.x = _loc2_.currentMouseData.stageX;
               _mouseDownAt.y = _loc2_.currentMouseData.stageY;
               _mouseDownTime = getTimer();
               _mouseDownAndHold = _mouseDownAndHoldAction = false;
               _loc2_.currentMouseData.type = MouseManagerData.MOUSE_DOWN;
               _draggedObject = _loc2_.currentMouseData.currentTarget as InteractiveObject;
               postMouseEventWrapperData(_loc2_.clone());
               break;
            case MouseEvent.MOUSE_UP:
               handleMouseUp(_loc2_);
               break;
            case MouseEvent.MOUSE_MOVE:
               if(!_mouseDownAndHold && _mouseDownTime != -1 && _mouseMoved && param1.currentTarget == _draggedObject && !_draggingStarted)
               {
                  _loc2_.currentMouseData.type = MouseManagerData.START_DRAG;
                  _draggingStarted = true;
                  postMouseEventWrapperData(_loc2_.clone());
               }
               if(_draggingStarted && _draggedObject == param1.currentTarget)
               {
                  _loc2_.currentMouseData.type = MouseManagerData.DRAG;
                  if(_loc2_.lastMouseData != null)
                  {
                     _loc2_.currentMouseData.deltaX = _loc2_.currentMouseData.stageX - _loc2_.lastMouseData.stageX;
                     _loc2_.currentMouseData.deltaY = _loc2_.currentMouseData.stageY - _loc2_.lastMouseData.stageY;
                  }
                  else
                  {
                     _loc2_.currentMouseData.deltaX = _loc2_.currentMouseData.deltaX = 0;
                  }
                  postMouseEventWrapperData(_loc2_.clone());
               }
               else
               {
                  _loc2_.currentMouseData.type = MouseManagerData.MOUSE_MOVE;
                  postMouseEventWrapperData(_loc2_.clone());
               }
               break;
            default:
               postMouseEventWrapperData(_loc2_.clone());
         }
      }
      
      public static function registerCallback(param1:InteractiveObject, param2:Function) : void
      {
         if(!_inited)
         {
            init();
         }
         var _loc3_:MouseEventData = new MouseEventData();
         _loc3_.callback = param2;
         if(param2 != null)
         {
            _mouseEventData[param1] = _loc3_;
         }
         else
         {
            delete _mouseEventData[param1];
         }
      }
      
      public static function getCallbackFor(param1:InteractiveObject) : Function
      {
         if(!_inited)
         {
            init();
         }
         var _loc2_:MouseEventData = _mouseEventData[param1];
         if(_loc2_ == null)
         {
            return null;
         }
         return _loc2_.callback;
      }
      
      public static function enableMouseEventsFor(param1:InteractiveObject, param2:Boolean, param3:Function, param4:Boolean = false, param5:int = 0) : void
      {
         var _loc6_:int = 0;
         var _loc7_:int = ALL_MOUSE_EVENTS.length;
         if(param2)
         {
            _loc6_ = 0;
            while(_loc6_ < _loc7_)
            {
               param1.addEventListener(ALL_MOUSE_EVENTS[_loc6_],param3,param4,param5,true);
               _loc6_++;
            }
         }
         else
         {
            _loc6_ = 0;
            while(_loc6_ < _loc7_)
            {
               param1.removeEventListener(ALL_MOUSE_EVENTS[_loc6_],param3,param4);
               _loc6_++;
            }
         }
      }
   }
}
