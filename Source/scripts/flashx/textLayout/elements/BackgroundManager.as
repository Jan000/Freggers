package flashx.textLayout.elements
{
   import flash.display.DisplayObjectContainer;
   import flash.display.Shape;
   import flash.geom.Rectangle;
   import flash.text.engine.TextLine;
   import flash.utils.Dictionary;
   import flashx.textLayout.compose.TextFlowLine;
   import flashx.textLayout.container.ContainerController;
   import flashx.textLayout.tlf_internal;
   
   use namespace tlf_internal;
   
   public class BackgroundManager
   {
       
      
      private var _textFlow:TextFlow;
      
      private var _lineDict:Dictionary;
      
      public function BackgroundManager()
      {
         super();
         this._lineDict = new Dictionary(true);
      }
      
      public function set textFlow(param1:TextFlow) : void
      {
         this._textFlow = param1;
      }
      
      public function get textFlow() : TextFlow
      {
         return this._textFlow;
      }
      
      public function addRect(param1:TextFlowLine, param2:FlowLeafElement, param3:Rectangle, param4:uint, param5:Number) : void
      {
         var _loc6_:TextLine = param1.getTextLine();
         if(this._lineDict[_loc6_] == null)
         {
            this._lineDict[_loc6_] = new Array();
         }
         var _loc7_:Object = new Object();
         _loc7_.rect = param3;
         _loc7_.fle = param2;
         _loc7_.color = param4;
         _loc7_.alpha = param5;
         var _loc8_:Boolean = true;
         var _loc9_:int = param2.getAbsoluteStart();
         var _loc10_:int = 0;
         while(_loc10_ < this._lineDict[_loc6_].length)
         {
            if(this._lineDict[_loc6_][_loc10_].fle.getAbsoluteStart() == _loc9_)
            {
               this._lineDict[_loc6_][_loc10_] = _loc7_;
               _loc8_ = false;
            }
            _loc10_++;
         }
         if(_loc8_)
         {
            this._lineDict[_loc6_].push(_loc7_);
         }
      }
      
      public function finalizeLine(param1:TextFlowLine) : void
      {
      }
      
      tlf_internal function get lineDict() : Dictionary
      {
         return this._lineDict;
      }
      
      public function drawAllRects(param1:Shape, param2:ContainerController) : void
      {
         var _loc3_:* = null;
         var _loc4_:Array = null;
         var _loc5_:Rectangle = null;
         var _loc6_:Rectangle = null;
         var _loc7_:Object = null;
         var _loc8_:int = 0;
         for(_loc3_ in this._lineDict)
         {
            _loc4_ = this._lineDict[_loc3_];
            if(_loc4_.length)
            {
               _loc5_ = _loc4_[0].columnRect;
               _loc8_ = 0;
               while(_loc8_ < _loc4_.length)
               {
                  _loc7_ = _loc4_[_loc8_];
                  _loc6_ = _loc7_.rect;
                  _loc6_.x = _loc6_.x + _loc3_.x;
                  _loc6_.y = _loc6_.y + _loc3_.y;
                  TextFlowLine.constrainRectToColumn(this.textFlow,_loc6_,_loc5_,0,0,param2.compositionWidth,param2.compositionHeight);
                  param1.graphics.beginFill(_loc7_.color,_loc7_.alpha);
                  param1.graphics.moveTo(_loc6_.left,_loc6_.top);
                  param1.graphics.lineTo(_loc6_.right,_loc6_.top);
                  param1.graphics.lineTo(_loc6_.right,_loc6_.bottom);
                  param1.graphics.lineTo(_loc6_.left,_loc6_.bottom);
                  param1.graphics.endFill();
                  _loc8_++;
               }
               continue;
            }
         }
      }
      
      public function removeLineFromCache(param1:TextLine) : void
      {
         delete this._lineDict[param1];
      }
      
      public function onUpdateComplete(param1:ContainerController) : void
      {
         var _loc3_:Shape = null;
         var _loc4_:int = 0;
         var _loc5_:TextLine = null;
         var _loc6_:int = 0;
         var _loc7_:Rectangle = null;
         var _loc8_:TextFlowLine = null;
         var _loc2_:DisplayObjectContainer = param1.container as DisplayObjectContainer;
         if(_loc2_ && _loc2_.numChildren)
         {
            _loc3_ = param1.getBackgroundShape();
            _loc3_.graphics.clear();
            _loc4_ = 0;
            while(_loc4_ < param1.textLines.length)
            {
               _loc5_ = param1.textLines[_loc4_];
               if(this._lineDict[_loc5_])
               {
                  if(this._lineDict[_loc5_].length)
                  {
                     _loc6_ = 0;
                     while(_loc6_ < this._lineDict[_loc5_].length)
                     {
                        _loc7_ = this._lineDict[_loc5_][_loc6_].rect.clone();
                        _loc8_ = _loc5_.userData as TextFlowLine;
                        if(_loc8_)
                        {
                           _loc8_.convertLineRectToContainer(_loc7_,true);
                        }
                        _loc3_.graphics.beginFill(this._lineDict[_loc5_][_loc6_].color,this._lineDict[_loc5_][_loc6_].alpha);
                        _loc3_.graphics.moveTo(_loc7_.left,_loc7_.top);
                        _loc3_.graphics.lineTo(_loc7_.right,_loc7_.top);
                        _loc3_.graphics.lineTo(_loc7_.right,_loc7_.bottom);
                        _loc3_.graphics.lineTo(_loc7_.left,_loc7_.bottom);
                        _loc3_.graphics.endFill();
                        _loc6_++;
                     }
                  }
               }
               _loc4_++;
            }
         }
      }
   }
}
