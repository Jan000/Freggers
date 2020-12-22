package flashx.textLayout.edit
{
   import flashx.textLayout.elements.FlowElement;
   import flashx.textLayout.elements.FlowGroupElement;
   import flashx.textLayout.elements.TextFlow;
   import flashx.textLayout.elements.TextRange;
   import flashx.textLayout.tlf_internal;
   
   use namespace tlf_internal;
   
   public class TextScrap
   {
       
      
      private var _textFlow:TextFlow;
      
      private var _beginMissingArray:Array;
      
      private var _endMissingArray:Array;
      
      public function TextScrap(param1:TextFlow = null)
      {
         super();
         this._textFlow = param1;
         this._textFlow.flowComposer = null;
         this._beginMissingArray = new Array();
         this._endMissingArray = new Array();
      }
      
      public static function createTextScrap(param1:TextRange) : TextScrap
      {
         return TextFlowEdit.createTextScrap(param1.textFlow,param1.absoluteStart,param1.absoluteEnd);
      }
      
      tlf_internal function get textFlow() : TextFlow
      {
         return this._textFlow;
      }
      
      tlf_internal function isBeginMissing(param1:FlowElement) : Boolean
      {
         var _loc2_:int = this._beginMissingArray.length;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(this._beginMissingArray[_loc3_] == param1)
            {
               return true;
            }
            _loc3_++;
         }
         return false;
      }
      
      tlf_internal function isEndMissing(param1:FlowElement) : Boolean
      {
         var _loc2_:int = this._endMissingArray.length;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(this._endMissingArray[_loc3_] == param1)
            {
               return true;
            }
            _loc3_++;
         }
         return false;
      }
      
      tlf_internal function addToBeginMissing(param1:FlowElement) : void
      {
         this._beginMissingArray.push(param1);
      }
      
      tlf_internal function addToEndMissing(param1:FlowElement) : void
      {
         this._endMissingArray.push(param1);
      }
      
      tlf_internal function get beginMissingArray() : Array
      {
         return this._beginMissingArray;
      }
      
      tlf_internal function get endMissingArray() : Array
      {
         return this._endMissingArray;
      }
      
      tlf_internal function set beginMissingArray(param1:Array) : void
      {
         this._beginMissingArray = param1;
      }
      
      tlf_internal function set endMissingArray(param1:Array) : void
      {
         this._endMissingArray = param1;
      }
      
      public function clone() : TextScrap
      {
         var _loc6_:FlowElement = null;
         var _loc7_:int = 0;
         var _loc9_:Array = null;
         var _loc10_:Array = null;
         var _loc1_:TextFlow = this.textFlow.deepCopy() as TextFlow;
         var _loc2_:TextScrap = new TextScrap(_loc1_);
         var _loc3_:Array = this._beginMissingArray;
         var _loc4_:Array = this._endMissingArray;
         var _loc5_:int = _loc3_.length - 2;
         var _loc8_:FlowElement = _loc2_.textFlow;
         if(_loc3_.length > 0)
         {
            _loc9_ = new Array();
            _loc9_.push(_loc8_);
            while(_loc5_ >= 0)
            {
               _loc6_ = _loc3_[_loc5_];
               _loc7_ = _loc6_.parent.getChildIndex(_loc6_);
               if(_loc8_ is FlowGroupElement)
               {
                  _loc8_ = (_loc8_ as FlowGroupElement).getChildAt(_loc7_);
                  _loc9_.push(_loc8_);
               }
               _loc5_--;
            }
            _loc2_.beginMissingArray = _loc9_;
         }
         _loc5_ = _loc4_.length - 2;
         _loc8_ = _loc2_.textFlow;
         if(_loc4_.length > 0)
         {
            _loc10_ = new Array();
            _loc10_.push(_loc8_);
            while(_loc5_ >= 0)
            {
               _loc6_ = _loc4_[_loc5_];
               _loc7_ = _loc6_.parent.getChildIndex(_loc6_);
               if(_loc8_ is FlowGroupElement)
               {
                  _loc8_ = (_loc8_ as FlowGroupElement).getChildAt(_loc7_);
                  _loc10_.push(_loc8_);
               }
               _loc5_--;
            }
            _loc2_.endMissingArray = _loc10_;
         }
         return _loc2_;
      }
   }
}
