package flashx.textLayout.elements
{
   import flash.events.EventDispatcher;
   import flash.text.engine.ContentElement;
   import flash.text.engine.GroupElement;
   import flash.utils.getQualifiedClassName;
   import flashx.textLayout.tlf_internal;
   
   use namespace tlf_internal;
   
   public class SubParagraphGroupElement extends FlowGroupElement
   {
      
      tlf_internal static const NO_ATTACHED_LISTENERS:uint = 0;
      
      tlf_internal static const INTERNAL_ATTACHED_LISTENERS:uint = 1;
      
      tlf_internal static const CLIENT_ATTACHED_LISTENERS:uint = 2;
      
      tlf_internal static const kMaxSPGEPrecedence:uint = 1000;
      
      tlf_internal static const kMinSPGEPrecedence:uint = 0;
       
      
      private var _groupElement:GroupElement;
      
      private var _attachedListenerStatus:uint;
      
      private var _canMerge:Boolean;
      
      public function SubParagraphGroupElement()
      {
         this._canMerge = true;
         this._attachedListenerStatus = NO_ATTACHED_LISTENERS;
         super();
      }
      
      override tlf_internal function createContentElement() : void
      {
         var _loc2_:FlowElement = null;
         if(this._groupElement)
         {
            return;
         }
         computedFormat;
         this._groupElement = new GroupElement(null);
         var _loc1_:int = 0;
         while(_loc1_ < numChildren)
         {
            _loc2_ = getChildAt(_loc1_);
            _loc2_.createContentElement();
            _loc1_++;
         }
         if(parent)
         {
            parent.insertBlockElement(this,this._groupElement);
         }
      }
      
      override tlf_internal function releaseContentElement() : void
      {
         var _loc2_:FlowElement = null;
         if(!this.canReleaseContentElement() || this.groupElement == null)
         {
            return;
         }
         var _loc1_:int = 0;
         while(_loc1_ < numChildren)
         {
            _loc2_ = getChildAt(_loc1_);
            _loc2_.releaseContentElement();
            _loc1_++;
         }
         this._groupElement = null;
         if(_computedFormat)
         {
            _computedFormat = null;
         }
      }
      
      override tlf_internal function canReleaseContentElement() : Boolean
      {
         return this._attachedListenerStatus == NO_ATTACHED_LISTENERS;
      }
      
      tlf_internal function get precedence() : uint
      {
         return kMaxSPGEPrecedence;
      }
      
      tlf_internal function get groupElement() : GroupElement
      {
         return this._groupElement;
      }
      
      tlf_internal function get attachedListenerStatus() : int
      {
         return this._attachedListenerStatus;
      }
      
      override tlf_internal function createContentAsGroup() : GroupElement
      {
         return this.groupElement;
      }
      
      override tlf_internal function removeBlockElement(param1:FlowElement, param2:ContentElement) : void
      {
         var _loc3_:int = this.getChildIndex(param1);
         this.groupElement.replaceElements(_loc3_,_loc3_ + 1,null);
      }
      
      override tlf_internal function insertBlockElement(param1:FlowElement, param2:ContentElement) : void
      {
         var _loc3_:int = 0;
         var _loc4_:Vector.<ContentElement> = null;
         var _loc5_:ParagraphElement = null;
         if(this.groupElement)
         {
            _loc3_ = this.getChildIndex(param1);
            _loc4_ = new Vector.<ContentElement>();
            _loc4_.push(param2);
            this.groupElement.replaceElements(_loc3_,_loc3_,_loc4_);
         }
         else
         {
            param1.releaseContentElement();
            _loc5_ = getParagraph();
            if(_loc5_)
            {
               _loc5_.createTextBlock();
            }
         }
      }
      
      override tlf_internal function hasBlockElement() : Boolean
      {
         return this.groupElement != null;
      }
      
      override tlf_internal function setParentAndRelativeStart(param1:FlowGroupElement, param2:int) : void
      {
         if(param1 == parent)
         {
            return;
         }
         if(parent && parent.hasBlockElement() && this.groupElement)
         {
            parent.removeBlockElement(this,this.groupElement);
         }
         if(param1 && !param1.hasBlockElement() && this.groupElement)
         {
            param1.createContentElement();
         }
         super.setParentAndRelativeStart(param1,param2);
         if(parent && parent.hasBlockElement())
         {
            if(!this.groupElement)
            {
               this.createContentElement();
            }
            else
            {
               parent.insertBlockElement(this,this.groupElement);
            }
         }
      }
      
      override public function replaceChildren(param1:int, param2:int, ... rest) : void
      {
         var _loc4_:ParagraphElement = this.getParagraph();
         var _loc5_:FlowLeafElement = !!_loc4_?_loc4_.getLastLeaf():null;
         var _loc6_:Array = [param1,param2];
         super.replaceChildren.apply(this,_loc6_.concat(rest));
         if(_loc4_)
         {
            _loc4_.ensureTerminatorAfterReplace(_loc5_);
         }
      }
      
      tlf_internal function getEventMirror(param1:uint = 2) : EventDispatcher
      {
         var _loc2_:ParagraphElement = null;
         if(!this._groupElement)
         {
            _loc2_ = getParagraph();
            if(_loc2_)
            {
               _loc2_.getTextBlock();
            }
            else
            {
               this.createContentElement();
            }
         }
         if(this._groupElement.eventMirror == null)
         {
            this._groupElement.eventMirror = new EventDispatcher();
         }
         this._attachedListenerStatus = this._attachedListenerStatus | param1;
         return this._groupElement.eventMirror;
      }
      
      override tlf_internal function normalizeRange(param1:uint, param2:uint) : void
      {
         var _loc4_:FlowElement = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:FlowElement = null;
         var _loc8_:SpanElement = null;
         var _loc3_:int = findChildIndexAtPosition(param1);
         if(_loc3_ != -1 && _loc3_ < numChildren)
         {
            _loc4_ = getChildAt(_loc3_);
            param1 = param1 - _loc4_.parentRelativeStart;
            while(true)
            {
               _loc5_ = _loc4_.parentRelativeStart + _loc4_.textLength;
               _loc4_.normalizeRange(param1,param2 - _loc4_.parentRelativeStart);
               _loc6_ = _loc4_.parentRelativeStart + _loc4_.textLength;
               param2 = param2 + (_loc6_ - _loc5_);
               if(_loc4_.textLength == 0 && !_loc4_.bindableElement)
               {
                  this.replaceChildren(_loc3_,_loc3_ + 1);
               }
               else if(_loc4_.mergeToPreviousIfPossible())
               {
                  _loc7_ = this.getChildAt(_loc3_ - 1);
                  _loc7_.normalizeRange(0,_loc7_.textLength);
               }
               else
               {
                  _loc3_++;
               }
               if(_loc3_ == numChildren)
               {
                  break;
               }
               _loc4_ = getChildAt(_loc3_);
               if(_loc4_.parentRelativeStart > param2)
               {
                  break;
               }
               param1 = 0;
            }
         }
         if(numChildren == 0 && parent != null)
         {
            _loc8_ = new SpanElement();
            this.replaceChildren(0,0,_loc8_);
            _loc8_.normalizeRange(0,_loc8_.textLength);
         }
      }
      
      override tlf_internal function canOwnFlowElement(param1:FlowElement) : Boolean
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:int = 0;
         if(param1 is FlowLeafElement)
         {
            return true;
         }
         var _loc2_:SubParagraphGroupElement = param1 as SubParagraphGroupElement;
         if(_loc2_)
         {
            _loc3_ = getQualifiedClassName(this);
            _loc4_ = getQualifiedClassName(param1);
            _loc5_ = !!parent?getQualifiedClassName(parent):null;
            if(_loc4_ == _loc3_ || _loc4_ == _loc5_)
            {
               return false;
            }
            _loc6_ = 0;
            while(_loc6_ < _loc2_.numChildren)
            {
               if(getQualifiedClassName(_loc2_.getChildAt(_loc6_)) == _loc3_)
               {
                  return false;
               }
               _loc6_++;
            }
            return true;
         }
         return false;
      }
      
      tlf_internal function acceptTextBefore() : Boolean
      {
         return true;
      }
      
      tlf_internal function acceptTextAfter() : Boolean
      {
         return true;
      }
   }
}
