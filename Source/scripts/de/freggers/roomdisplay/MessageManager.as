package de.freggers.roomdisplay
{
   import caurina.transitions.Tweener;
   import de.freggers.roomlib.IsoObjectContainer;
   import de.schulterklopfer.interaction.data.MouseManagerData;
   import de.schulterklopfer.interaction.manager.InteractionManager;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.getTimer;
   
   public class MessageManager extends Sprite
   {
      
      public static const MODE_NORMAL:int = 0;
      
      public static const MODE_EMOTICON:int = 1;
      
      private static const MSGTIMEOUTS:Array = [120000,3500];
      
      private static const MAXLAYERS:int = 3;
      
      private static const TWEEN_HORIZONTAL:String = "horiz";
       
      
      private var _maxheight:int;
      
      private var _width:int;
      
      private var _updatedWidth:int;
      
      private var _updatedMaxheight:int;
      
      private var _messages:Array;
      
      private var _messagelayers:Array;
      
      private var _dragMessages:Boolean = false;
      
      private var _grabOffset:Number;
      
      private var _leftToRightFactor:Number = 0;
      
      private var _uiRect:Rectangle;
      
      private var _columnRect:Rectangle;
      
      private var toremove:Array;
      
      public function MessageManager(param1:int, param2:int)
      {
         var _loc3_:Sprite = null;
         super();
         this._maxheight = param1;
         this._updatedMaxheight = param1;
         this._width = param2;
         this._updatedWidth = this._width;
         this._columnRect = new Rectangle();
         this._messages = new Array();
         this._messagelayers = new Array(MAXLAYERS);
         this.toremove = new Array();
         var _loc4_:int = 0;
         while(_loc4_ < this._messagelayers.length)
         {
            _loc3_ = new Sprite();
            this._messagelayers[_loc4_] = _loc3_;
            _loc3_.mouseEnabled = false;
            addChild(_loc3_);
            _loc4_++;
         }
      }
      
      public function handleMouseManagerData(param1:MouseManagerData) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:MessageContainer = null;
         param1.mouseEvent.stopImmediatePropagation();
         switch(param1.type)
         {
            case MouseManagerData.START_DRAG:
               if(param1.target is MessageContainer)
               {
                  _loc4_ = param1.target as MessageContainer;
                  if(_loc4_ && _loc4_.mode == MODE_NORMAL)
                  {
                     this._dragMessages = true;
                     this._grabOffset = param1.stageX - (this._width - this._columnRect.width) * this._leftToRightFactor;
                     return;
                  }
               }
               break;
            case MouseManagerData.STOP_DRAG:
            case MouseManagerData.MOUSE_UP:
               if(this._dragMessages)
               {
                  this._dragMessages = false;
                  return;
               }
               break;
            case MouseManagerData.DRAG:
               if(this._dragMessages)
               {
                  this._leftToRightFactor = (param1.stageX - this._grabOffset) / (this._width - this._columnRect.width);
                  if(this._leftToRightFactor < 0)
                  {
                     this._leftToRightFactor = 0;
                  }
                  else if(this._leftToRightFactor > 1)
                  {
                     this._leftToRightFactor = 1;
                  }
                  this.updateMessageColumnPosition();
                  this._columnRect.x = (this._width - this._columnRect.width) * this._leftToRightFactor;
                  if(this._uiRect && this._columnRect.intersects(this._uiRect))
                  {
                     this.discardMessages(this._uiRect.y);
                  }
                  return;
               }
               break;
         }
         if(param1.target is MessageContainer)
         {
            (param1.target as MessageContainer).handleMouseManagerData(param1);
         }
         else if(param1.target is TextBarClose && param1.type == MouseManagerData.CLICK)
         {
            this.removeMessage((param1.target as TextBarClose).parent as MessageContainer);
         }
      }
      
      private function updateMessageColumnPosition() : void
      {
         var _loc2_:MessageContainer = null;
         var _loc3_:Number = NaN;
         var _loc1_:uint = this._messages.length;
         var _loc4_:uint = 0;
         while(_loc4_ < _loc1_)
         {
            _loc2_ = this._messages[_loc4_];
            if(_loc2_.mode == MODE_NORMAL)
            {
               Tweener.removeTweens(_loc2_,"x");
               _loc3_ = (this._width - _loc2_.width) * this._leftToRightFactor;
               _loc2_.target.x = _loc3_;
               _loc2_.x = _loc3_;
            }
            _loc4_++;
         }
      }
      
      public function update(param1:int) : void
      {
         var timenow:int = param1;
         if(this._messages.length == 0)
         {
            return;
         }
         this._messages.forEach(function(param1:MessageContainer, param2:int, param3:Array):void
         {
            if(param1 && param1.timestamp + param1.timeout < timenow)
            {
               toremove.push(param1);
            }
         });
         if(this._updatedMaxheight != this._maxheight)
         {
            if(this._updatedMaxheight < this._maxheight)
            {
               this.discardMessages(this._updatedMaxheight);
            }
            this._maxheight = this._updatedMaxheight;
         }
         if(this._uiRect && this._columnRect.intersects(this._uiRect))
         {
            this.discardMessages(this._uiRect.y);
         }
         if(this.toremove.length > 0)
         {
            if(this.cleanupMessages() > 0)
            {
               this.recomputeColumnWidth();
            }
         }
         if(this._updatedWidth != this._width)
         {
            this._width = this._updatedWidth;
            this.updateMessageColumnPosition();
         }
      }
      
      private function recomputeColumnWidth() : void
      {
         var columnWidth:Number = NaN;
         columnWidth = 0;
         this._messages.forEach(function(param1:MessageContainer, param2:int, param3:Array):void
         {
            if(columnWidth < param1.width)
            {
               columnWidth = param1.width;
            }
         });
         this._columnRect.width = columnWidth;
      }
      
      private function cleanupMessages() : uint
      {
         var _loc2_:Array = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:MessageContainer = null;
         var _loc6_:int = 0;
         var _loc1_:uint = 0;
         if(this.toremove.length > 0)
         {
            _loc2_ = this.toremove.concat();
            this.toremove.length = 0;
            _loc4_ = _loc2_.length;
            _loc3_ = 0;
            while(_loc3_ < _loc4_)
            {
               _loc5_ = _loc2_[_loc3_];
               _loc6_ = this._messages.indexOf(_loc5_);
               if(_loc6_ >= 0)
               {
                  this._messages.splice(_loc6_,1);
                  (this._messagelayers[_loc5_.layer] as DisplayObjectContainer).removeChild(_loc5_);
                  if(_loc5_.mode == MODE_NORMAL)
                  {
                     this._columnRect.height = this._columnRect.height - _loc5_.target.height;
                     this.shiftMessagesUpFrom(_loc6_,_loc5_.target.height);
                     _loc1_++;
                  }
                  InteractionManager.removeForMouse(_loc5_);
                  _loc5_.cleanup();
               }
               _loc3_++;
            }
            if(this._columnRect.height < 0)
            {
               this._columnRect.height = 0;
            }
         }
         return _loc1_;
      }
      
      private function shiftMessagesUpFrom(param1:int, param2:Number) : void
      {
         var _loc3_:MessageContainer = null;
         if(param1 < 0 || param1 >= this._messages.length || param2 == 0)
         {
            return;
         }
         var _loc4_:uint = this._messages.length;
         var _loc5_:uint = param1;
         while(_loc5_ < _loc4_)
         {
            _loc3_ = this._messages[_loc5_] as MessageContainer;
            if(_loc3_ && _loc3_.mode == MODE_NORMAL)
            {
               _loc3_.target.y = _loc3_.target.y - param2;
               Tweener.addTween(_loc3_,{
                  "y":_loc3_.target.y,
                  "time":0.5,
                  "transition":"easeOutBack"
               });
            }
            _loc5_++;
         }
      }
      
      private function discardMessages(param1:Number) : void
      {
         var _loc4_:MessageContainer = null;
         var _loc2_:Number = this._columnRect.height - param1;
         if(_loc2_ <= 0)
         {
            return;
         }
         var _loc3_:uint = this._messages.length;
         var _loc5_:uint = 0;
         while(_loc5_ < _loc3_)
         {
            _loc4_ = this._messages[_loc5_];
            if(_loc4_.mode == MODE_NORMAL)
            {
               _loc2_ = _loc2_ - _loc4_.target.height;
               if(this.toremove.indexOf(_loc4_) < 0)
               {
                  this.toremove.push(_loc4_);
               }
               if(_loc2_ <= 0)
               {
                  break;
               }
            }
            _loc5_++;
         }
      }
      
      public function addMessage(param1:int, param2:IsoObjectContainer, param3:String, param4:Sprite, param5:Point, param6:int, param7:Boolean, param8:Function = null, param9:Object = null) : void
      {
         var _loc10_:MessageContainer = null;
         var _loc11_:Number = NaN;
         if(param6 < 0 || param6 > MSGTIMEOUTS.length)
         {
            return;
         }
         if(param1 < 0 || param1 >= MAXLAYERS)
         {
            return;
         }
         if(this._updatedMaxheight != this._maxheight)
         {
            this._maxheight = this._updatedMaxheight;
         }
         switch(param6)
         {
            case MODE_NORMAL:
               _loc11_ = this._columnRect.height + param4.height;
               if(_loc11_ > this._maxheight)
               {
                  this.discardMessages(this._maxheight - param4.height);
               }
               _loc10_ = new MessageContainer(this,param1,param2,param3,param4,new Rectangle(0,this._columnRect.height,param4.width,param4.height),getTimer(),MSGTIMEOUTS[param6],param6,param7,true,param9);
               if(this._columnRect.width < _loc10_.width)
               {
                  this._columnRect.width = _loc10_.width;
               }
               _loc10_.target.x = (this._width - _loc10_.width) * this._leftToRightFactor;
               this._columnRect.height = this._columnRect.height + param4.height;
               _loc10_.x = param5.x;
               _loc10_.y = param5.y;
               _loc10_.scale = 0.25;
               Tweener.addTween(_loc10_,{
                  "y":_loc10_.target.y,
                  "scale":1,
                  "time":0.5,
                  "transition":"easeOutCirc",
                  "onComplete":this.__moveUpComplete,
                  "onCompleteParams":[_loc10_]
               });
               break;
            case MODE_EMOTICON:
               _loc10_ = new MessageContainer(this,param1,param2,param3,param4,new Rectangle(param5.x,param4.height,param4.width,param4.height),getTimer(),MSGTIMEOUTS[param6],param6);
               _loc10_.mouseEnabled = _loc10_.mouseChildren = false;
               _loc10_.x = param5.x;
               _loc10_.y = param5.y;
               _loc10_.scale = 0.25;
               Tweener.addTween(_loc10_,{
                  "time":0.5,
                  "scale":1,
                  "transition":"easeOutBack",
                  "onComplete":this.__moveUpComplete,
                  "onCompleteParams":[_loc10_]
               });
         }
         if(_loc10_)
         {
            this._messages.push(_loc10_);
            this._messagelayers[param1].addChild(_loc10_);
            if(param8 != null)
            {
               _loc10_.buttonMode = true;
               _loc10_.mouseHandlerCallback = param8;
            }
         }
      }
      
      private function __moveUpComplete(param1:MessageContainer) : void
      {
         switch(param1.mode)
         {
            case MODE_NORMAL:
               if(param1.x != param1.target.x)
               {
                  if(!this._dragMessages)
                  {
                     Tweener.addTween(param1,{
                        "x":param1.target.x,
                        "time":0.5,
                        "transition":"easeOutBounce"
                     });
                  }
                  else
                  {
                     param1.x = param1.target.x;
                  }
               }
               break;
            case MODE_EMOTICON:
               Tweener.addTween(param1,{
                  "y":param1.target.y,
                  "alpha":0,
                  "scale":3,
                  "time":0.5,
                  "delay":0.5,
                  "onComplete":this.removeMessage,
                  "onCompleteParams":[param1]
               });
         }
      }
      
      public function highlightMessagesOf(param1:IsoObjectContainer) : void
      {
         var _loc2_:MessageContainer = null;
         for each(_loc2_ in this._messages)
         {
            if(_loc2_.sender && param1 && _loc2_.sender.wobId == param1.wobId)
            {
               _loc2_.highlight = true;
            }
         }
      }
      
      public function removeHighlights() : void
      {
         var _loc1_:MessageContainer = null;
         for each(_loc1_ in this._messages)
         {
            _loc1_.highlight = false;
         }
      }
      
      public function removeMessage(param1:MessageContainer) : void
      {
         if(!param1)
         {
            return;
         }
         var _loc2_:int = this._messages.indexOf(param1);
         if(_loc2_ == -1)
         {
            return;
         }
         if(this.toremove.indexOf(param1) < 0)
         {
            this.toremove.push(param1);
         }
      }
      
      public function handleResize(param1:int, param2:int) : void
      {
         this._updatedMaxheight = param2 - 10;
         this._updatedWidth = param1;
      }
      
      public function setUIRect(param1:Rectangle) : void
      {
         this._uiRect = param1;
      }
   }
}
