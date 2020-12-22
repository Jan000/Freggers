package flashx.textLayout.compose
{
   import flashx.textLayout.container.ContainerController;
   import flashx.textLayout.formats.BlockProgression;
   import flashx.textLayout.formats.VerticalAlign;
   import flashx.textLayout.tlf_internal;
   
   use namespace tlf_internal;
   
   public final class VerticalJustifier
   {
       
      
      public function VerticalJustifier()
      {
         super();
      }
      
      public static function applyVerticalAlignmentToColumn(param1:ContainerController, param2:String, param3:Array, param4:int, param5:int) : void
      {
         var _loc6_:IVerticalAdjustmentHelper = null;
         var _loc7_:int = 0;
         if(param1.rootElement.computedFormat.blockProgression == BlockProgression.RL)
         {
            _loc6_ = new RL_VJHelper(ContainerController(param1));
         }
         else
         {
            _loc6_ = new TB_VJHelper(ContainerController(param1));
         }
         switch(param2)
         {
            case VerticalAlign.MIDDLE:
               _loc6_.computeMiddleAdjustment(param3[param4 + param5 - 1]);
               _loc7_ = param4;
               while(_loc7_ < param4 + param5)
               {
                  _loc6_.applyMiddleAdjustment(param3[_loc7_]);
                  _loc7_++;
               }
               break;
            case VerticalAlign.BOTTOM:
               _loc6_.computeBottomAdjustment(param3[param4 + param5 - 1]);
               _loc7_ = param4;
               while(_loc7_ < param4 + param5)
               {
                  _loc6_.applyBottomAdjustment(param3[_loc7_]);
                  _loc7_++;
               }
               break;
            case VerticalAlign.JUSTIFY:
               _loc6_.computeJustifyAdjustment(param3,param4,param5);
               _loc6_.applyJustifyAdjustment(param3,param4,param5);
         }
      }
   }
}

import flashx.textLayout.compose.IVerticalJustificationLine;

interface IVerticalAdjustmentHelper
{
    
   
   function computeMiddleAdjustment(param1:IVerticalJustificationLine) : void;
   
   function applyMiddleAdjustment(param1:IVerticalJustificationLine) : void;
   
   function computeBottomAdjustment(param1:IVerticalJustificationLine) : void;
   
   function applyBottomAdjustment(param1:IVerticalJustificationLine) : void;
   
   function computeJustifyAdjustment(param1:Array, param2:int, param3:int) : void;
   
   function applyJustifyAdjustment(param1:Array, param2:int, param3:int) : void;
}

import flashx.textLayout.compose.IVerticalJustificationLine;
import flashx.textLayout.compose.TextFlowLine;
import flashx.textLayout.container.ContainerController;
import flashx.textLayout.tlf_internal;

use namespace tlf_internal;

class TB_VJHelper implements IVerticalAdjustmentHelper
{
    
   
   private var _textFrame:ContainerController;
   
   private var adj:Number;
   
   function TB_VJHelper(param1:ContainerController)
   {
      super();
      this._textFrame = param1;
   }
   
   private function getBottomOfLine(param1:IVerticalJustificationLine) : Number
   {
      return this.getBaseline(param1) + param1.descent;
   }
   
   private function getBaseline(param1:IVerticalJustificationLine) : Number
   {
      if(param1 is TextFlowLine)
      {
         return param1.y + param1.ascent;
      }
      return param1.y;
   }
   
   private function setBaseline(param1:IVerticalJustificationLine, param2:Number) : void
   {
      if(param1 is TextFlowLine)
      {
         param1.y = param2 - param1.ascent;
      }
      else
      {
         param1.y = param2;
      }
   }
   
   public function computeMiddleAdjustment(param1:IVerticalJustificationLine) : void
   {
      var _loc2_:Number = this._textFrame.compositionHeight - Number(this._textFrame.effectivePaddingBottom);
      this.adj = (_loc2_ - this.getBottomOfLine(param1)) / 2;
      if(this.adj < 0)
      {
         this.adj = 0;
      }
   }
   
   public function applyMiddleAdjustment(param1:IVerticalJustificationLine) : void
   {
      param1.y = param1.y + this.adj;
   }
   
   public function computeBottomAdjustment(param1:IVerticalJustificationLine) : void
   {
      var _loc2_:Number = this._textFrame.compositionHeight - Number(this._textFrame.effectivePaddingBottom);
      this.adj = _loc2_ - this.getBottomOfLine(param1);
      if(this.adj < 0)
      {
         this.adj = 0;
      }
   }
   
   public function applyBottomAdjustment(param1:IVerticalJustificationLine) : void
   {
      param1.y = param1.y + this.adj;
   }
   
   public function computeJustifyAdjustment(param1:Array, param2:int, param3:int) : void
   {
      this.adj = 0;
      if(param3 == 1)
      {
         return;
      }
      var _loc4_:IVerticalJustificationLine = param1[param2];
      var _loc5_:Number = this.getBaseline(_loc4_);
      var _loc6_:IVerticalJustificationLine = param1[param2 + param3 - 1];
      var _loc7_:Number = this._textFrame.compositionHeight - Number(this._textFrame.effectivePaddingBottom);
      var _loc8_:Number = _loc7_ - this.getBottomOfLine(_loc6_);
      if(_loc8_ < 0)
      {
         return;
      }
      var _loc9_:Number = this.getBaseline(_loc6_);
      this.adj = _loc8_ / (_loc9_ - _loc5_);
   }
   
   public function applyJustifyAdjustment(param1:Array, param2:int, param3:int) : void
   {
      var _loc7_:IVerticalJustificationLine = null;
      var _loc8_:Number = NaN;
      var _loc9_:Number = NaN;
      if(param3 == 1 || this.adj == 0)
      {
         return;
      }
      var _loc4_:IVerticalJustificationLine = param1[param2];
      var _loc5_:Number = this.getBaseline(_loc4_);
      var _loc6_:Number = _loc5_;
      var _loc10_:int = 1;
      while(_loc10_ < param3)
      {
         _loc7_ = param1[_loc10_ + param2];
         _loc9_ = this.getBaseline(_loc7_);
         _loc8_ = _loc5_ + (_loc9_ - _loc6_) * (1 + this.adj);
         this.setBaseline(_loc7_,_loc8_);
         _loc6_ = _loc9_;
         _loc5_ = _loc8_;
         _loc10_++;
      }
   }
}

import flashx.textLayout.compose.IVerticalJustificationLine;
import flashx.textLayout.container.ContainerController;
import flashx.textLayout.tlf_internal;

use namespace tlf_internal;

class RL_VJHelper implements IVerticalAdjustmentHelper
{
    
   
   private var _textFrame:ContainerController;
   
   private var adj:Number = 0;
   
   function RL_VJHelper(param1:ContainerController)
   {
      super();
      this._textFrame = param1;
   }
   
   public function computeMiddleAdjustment(param1:IVerticalJustificationLine) : void
   {
      var _loc2_:Number = this._textFrame.compositionWidth - Number(this._textFrame.effectivePaddingLeft);
      this.adj = (_loc2_ + param1.x - param1.descent) / 2;
      if(this.adj < 0)
      {
         this.adj = 0;
      }
   }
   
   public function applyMiddleAdjustment(param1:IVerticalJustificationLine) : void
   {
      param1.x = param1.x - this.adj;
   }
   
   public function computeBottomAdjustment(param1:IVerticalJustificationLine) : void
   {
      var _loc2_:Number = this._textFrame.compositionWidth - Number(this._textFrame.effectivePaddingLeft);
      this.adj = _loc2_ + param1.x - param1.descent;
      if(this.adj < 0)
      {
         this.adj = 0;
      }
   }
   
   public function applyBottomAdjustment(param1:IVerticalJustificationLine) : void
   {
      param1.x = param1.x - this.adj;
   }
   
   public function computeJustifyAdjustment(param1:Array, param2:int, param3:int) : void
   {
      this.adj = 0;
      if(param3 == 1)
      {
         return;
      }
      var _loc4_:IVerticalJustificationLine = param1[param2];
      var _loc5_:Number = _loc4_.x;
      var _loc6_:IVerticalJustificationLine = param1[param2 + param3 - 1];
      var _loc7_:Number = Number(this._textFrame.effectivePaddingLeft) - this._textFrame.compositionWidth;
      var _loc8_:Number = _loc6_.x - _loc6_.descent - _loc7_;
      if(_loc8_ < 0)
      {
         return;
      }
      var _loc9_:Number = _loc6_.x;
      this.adj = _loc8_ / (_loc5_ - _loc9_);
   }
   
   public function applyJustifyAdjustment(param1:Array, param2:int, param3:int) : void
   {
      var _loc7_:IVerticalJustificationLine = null;
      var _loc8_:Number = NaN;
      var _loc9_:Number = NaN;
      if(param3 == 1 || this.adj == 0)
      {
         return;
      }
      var _loc4_:IVerticalJustificationLine = param1[param2];
      var _loc5_:Number = _loc4_.x;
      var _loc6_:Number = _loc5_;
      var _loc10_:int = 1;
      while(_loc10_ < param3)
      {
         _loc7_ = param1[_loc10_ + param2];
         _loc9_ = _loc7_.x;
         _loc8_ = _loc5_ - (_loc6_ - _loc9_) * (1 + this.adj);
         _loc7_.x = _loc8_;
         _loc6_ = _loc9_;
         _loc5_ = _loc8_;
         _loc10_++;
      }
   }
}
