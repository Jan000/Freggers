package de.schulterklopfer.interaction.data
{
   import flash.display.InteractiveObject;
   import flash.events.MouseEvent;
   
   public class MouseManagerData
   {
      
      public static const CLICK:String = MouseEvent.CLICK;
      
      public static const MOUSE_MOVE:String = MouseEvent.MOUSE_MOVE;
      
      public static const MOUSE_UP:String = MouseEvent.MOUSE_UP;
      
      public static const MOUSE_DOWN:String = MouseEvent.MOUSE_DOWN;
      
      public static const DOUBLE_CLICK:String = MouseEvent.DOUBLE_CLICK;
      
      public static const MOUSE_OVER:String = MouseEvent.MOUSE_OVER;
      
      public static const MOUSE_OUT:String = MouseEvent.MOUSE_OUT;
      
      public static const MOUSE_WHEEL:String = MouseEvent.MOUSE_WHEEL;
      
      public static const ROLL_OUT:String = MouseEvent.ROLL_OUT;
      
      public static const ROLL_OVER:String = MouseEvent.ROLL_OVER;
      
      public static const START_DRAG:String = "startDrag";
      
      public static const STOP_DRAG:String = "stopDrag";
      
      public static const MOUSE_DOWN_AND_HOLD:String = "mouseDownAndHold";
      
      public static const MOUSE_DOWN_AND_HOLD_ACTION:String = "mouseDownAndHoldAction";
      
      public static const DRAG:String = "drag";
       
      
      public var mouseEvent:MouseEvent;
      
      public var type:String;
      
      public var target:Object;
      
      public var currentTarget:Object;
      
      public var bubbles:Boolean;
      
      public var cancelable:Boolean;
      
      public var localX:Number;
      
      public var localY:Number;
      
      public var stageX:Number;
      
      public var stageY:Number;
      
      public var mouseDownAndHold:Boolean;
      
      public var relatedObject:InteractiveObject;
      
      public var ctrlKey:Boolean;
      
      public var altKey:Boolean;
      
      public var shiftKey:Boolean;
      
      public var buttonDown:Boolean;
      
      public var delta:int;
      
      public var miscargs:Object;
      
      public var deltaX:Number;
      
      public var deltaY:Number;
      
      public function MouseManagerData(param1:MouseEvent = null)
      {
         var _loc2_:MouseEvent = null;
         super();
         if(!param1)
         {
            return;
         }
         this.target = param1.target;
         this.currentTarget = param1.currentTarget;
         this.type = param1.type;
         this.bubbles = param1.bubbles;
         this.cancelable = param1.cancelable;
         this.mouseEvent = param1;
         if(param1 is MouseEvent)
         {
            _loc2_ = param1 as MouseEvent;
            this.localX = _loc2_.localX;
            this.localY = _loc2_.localY;
            this.stageX = _loc2_.stageX;
            this.stageY = _loc2_.stageY;
            this.ctrlKey = _loc2_.ctrlKey;
            this.altKey = _loc2_.altKey;
            this.shiftKey = _loc2_.shiftKey;
            this.buttonDown = _loc2_.buttonDown;
            this.delta = _loc2_.delta;
         }
      }
      
      public function clone() : MouseManagerData
      {
         var _loc1_:MouseManagerData = new MouseManagerData();
         _loc1_.target = this.target;
         _loc1_.currentTarget = this.currentTarget;
         _loc1_.type = this.type;
         _loc1_.bubbles = this.bubbles;
         _loc1_.cancelable = this.cancelable;
         _loc1_.localX = this.localX;
         _loc1_.localY = this.localY;
         _loc1_.stageX = this.stageX;
         _loc1_.stageY = this.stageY;
         _loc1_.ctrlKey = this.ctrlKey;
         _loc1_.altKey = this.altKey;
         _loc1_.shiftKey = this.shiftKey;
         _loc1_.buttonDown = this.buttonDown;
         _loc1_.delta = this.delta;
         _loc1_.mouseDownAndHold = this.mouseDownAndHold;
         _loc1_.mouseEvent = this.mouseEvent;
         return _loc1_;
      }
      
      public function toString() : String
      {
         return "MouseManagerData [type=" + this.type + ", currentTarget=" + this.currentTarget + ", target=" + this.target + ", local=(" + this.localX + ", y=" + this.localY + "), stage=(" + this.stageX + ", " + this.stageY + ")]";
      }
   }
}
