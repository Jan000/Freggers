package flashx.textLayout.edit
{
   import flashx.textLayout.elements.ContainerFormattedElement;
   import flashx.textLayout.elements.DivElement;
   import flashx.textLayout.elements.FlowElement;
   import flashx.textLayout.elements.FlowGroupElement;
   import flashx.textLayout.elements.FlowLeafElement;
   import flashx.textLayout.elements.LinkElement;
   import flashx.textLayout.elements.ParagraphElement;
   import flashx.textLayout.elements.SpanElement;
   import flashx.textLayout.elements.SubParagraphGroupElement;
   import flashx.textLayout.elements.TCYElement;
   import flashx.textLayout.elements.TextFlow;
   import flashx.textLayout.tlf_internal;
   
   use namespace tlf_internal;
   
   public class TextFlowEdit
   {
      
      private static var processedFirstFlowElement:Boolean = false;
       
      
      public function TextFlowEdit()
      {
         super();
      }
      
      private static function deleteRange(param1:FlowGroupElement, param2:int, param3:int) : int
      {
         var _loc5_:FlowElement = null;
         var _loc9_:SpanElement = null;
         var _loc13_:FlowElement = null;
         var _loc14_:int = 0;
         var _loc16_:int = 0;
         var _loc17_:int = 0;
         var _loc18_:Boolean = false;
         var _loc4_:int = 0;
         var _loc6_:Boolean = false;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc10_:Boolean = false;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc15_:int = -1;
         while(_loc4_ < param1.numChildren)
         {
            _loc5_ = param1.getChildAt(_loc4_);
            _loc7_ = param2 - _loc5_.parentRelativeStart;
            if(_loc7_ < 0)
            {
               _loc7_ = 0;
            }
            _loc8_ = param3 - _loc5_.parentRelativeStart;
            if(_loc7_ < _loc5_.textLength && _loc8_ > 0)
            {
               if(_loc7_ <= 0 && (_loc8_ > _loc5_.textLength || _loc8_ >= _loc5_.textLength && _loc5_ is ParagraphElement))
               {
                  _loc12_ = _loc5_.textLength;
                  _loc18_ = _loc4_ == param1.numChildren - 1 && _loc5_ is SpanElement && param1 is ParagraphElement;
                  if(_loc18_)
                  {
                     if(_loc15_ != -1)
                     {
                        param1.replaceChildren(_loc15_,_loc15_ + _loc16_);
                        _loc4_ = _loc4_ - _loc16_;
                        _loc11_ = _loc11_ + _loc17_;
                        param3 = param3 - _loc17_;
                        _loc15_ = -1;
                     }
                     param1.replaceChildren(_loc4_,_loc4_ + 1,null);
                     _loc4_++;
                     _loc11_ = _loc11_ + _loc12_;
                     param3 = param3 - _loc12_;
                  }
                  else
                  {
                     if(_loc15_ == -1)
                     {
                        _loc15_ = _loc4_;
                        _loc16_ = 0;
                        _loc17_ = 0;
                     }
                     _loc16_++;
                     _loc17_ = _loc17_ + _loc12_;
                     _loc4_++;
                  }
               }
               else
               {
                  if(_loc15_ != -1)
                  {
                     param1.replaceChildren(_loc15_,_loc15_ + _loc16_);
                     _loc4_ = _loc4_ - _loc16_;
                     _loc11_ = _loc11_ + _loc17_;
                     param3 = param3 - _loc17_;
                     _loc15_ = -1;
                  }
                  if(_loc5_ is SpanElement)
                  {
                     _loc9_ = _loc5_ as SpanElement;
                     if(_loc8_ > _loc9_.textLength)
                     {
                        _loc8_ = _loc9_.textLength;
                     }
                     _loc9_.replaceText(_loc7_,_loc8_,"");
                     _loc12_ = _loc8_ - _loc7_;
                     _loc11_ = _loc11_ + _loc12_;
                     param3 = param3 - _loc12_;
                  }
                  else if(!(_loc5_ is FlowGroupElement))
                  {
                     _loc12_ = _loc5_.textLength;
                     _loc11_ = _loc11_ + _loc5_.textLength;
                     param3 = param3 - _loc12_;
                     param1.replaceChildren(_loc4_,_loc4_ + 1,null);
                  }
                  else
                  {
                     if(!_loc10_ && _loc8_ >= _loc5_.textLength)
                     {
                        if(_loc5_ is ParagraphElement)
                        {
                           _loc6_ = true;
                        }
                        else if(_loc5_ is FlowGroupElement)
                        {
                           _loc14_ = (_loc5_ as FlowGroupElement).numChildren;
                           if(_loc14_ > 0)
                           {
                              _loc13_ = (_loc5_ as FlowGroupElement).getChildAt(_loc14_ - 1);
                              if(_loc13_ is ParagraphElement)
                              {
                                 _loc6_ = true;
                              }
                           }
                        }
                     }
                     _loc12_ = TextFlowEdit.deleteRange(_loc5_ as FlowGroupElement,_loc7_,_loc8_);
                     _loc11_ = _loc11_ + _loc12_;
                     param3 = param3 - _loc12_;
                     if(_loc6_ == true)
                     {
                        param3++;
                     }
                     if(!(_loc5_ is ParagraphElement))
                     {
                        _loc6_ = false;
                     }
                  }
                  if(_loc10_)
                  {
                     break;
                  }
                  _loc4_++;
               }
               _loc10_ = true;
            }
            else
            {
               if(_loc10_)
               {
                  break;
               }
               _loc4_++;
            }
         }
         if(_loc15_ != -1)
         {
            param1.replaceChildren(_loc15_,_loc15_ + _loc16_);
            _loc4_ = _loc4_ - _loc16_;
            _loc11_ = _loc11_ + _loc17_;
            param3 = param3 - _loc17_;
         }
         if(_loc6_)
         {
            joinNextParagraph(ParagraphElement(_loc5_.getPreviousSibling()));
         }
         return _loc11_;
      }
      
      private static function isFlowElementInArray(param1:Array, param2:FlowElement) : Boolean
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(param1 != null)
         {
            _loc3_ = param1.length;
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               if(param1[_loc4_] == param2)
               {
                  return true;
               }
               _loc4_++;
            }
         }
         return false;
      }
      
      private static function getContainer(param1:FlowElement) : ContainerFormattedElement
      {
         while(!(param1.parent is ContainerFormattedElement))
         {
            param1 = param1.parent;
         }
         return param1.parent as ContainerFormattedElement;
      }
      
      private static function isInsertableItem(param1:FlowElement, param2:Array, param3:Array) : Boolean
      {
         return param1 is ParagraphElement || !TextFlowEdit.isFlowElementInArray(param2,param1) && !TextFlowEdit.isFlowElementInArray(param3,param1);
      }
      
      private static function putDivAtEndOfContainer(param1:ContainerFormattedElement) : DivElement
      {
         var _loc2_:DivElement = new DivElement();
         var _loc3_:ParagraphElement = new ParagraphElement();
         _loc3_.replaceChildren(0,0,new SpanElement());
         _loc2_.replaceChildren(0,0,_loc3_);
         param1.replaceChildren(param1.numChildren,param1.numChildren,_loc2_);
         return _loc2_;
      }
      
      private static function putDivAtEndOfContainerAndInsertTextFlow(param1:TextFlow, param2:int, param3:FlowGroupElement, param4:Array, param5:Array, param6:Array) : int
      {
         var _loc11_:FlowElement = null;
         var _loc12_:int = 0;
         var _loc7_:int = param2;
         var _loc8_:ContainerFormattedElement = TextFlowEdit.getContainer(param1.findAbsoluteParagraph(_loc7_));
         var _loc9_:DivElement = TextFlowEdit.putDivAtEndOfContainer(_loc8_);
         param6.push(_loc9_);
         var _loc10_:Array = param3.mxmlChildren;
         param3.replaceChildren(0,param3.numChildren);
         for each(_loc11_ in _loc10_)
         {
            _loc7_ = TextFlowEdit.insertTextFlow(param1,_loc7_,_loc11_ as FlowGroupElement,param4,param5,param6);
         }
         _loc12_ = _loc9_.parent.getChildIndex(_loc9_);
         _loc9_.parent.replaceChildren(_loc12_,_loc12_ + 1,null);
         param6.pop();
         return _loc7_;
      }
      
      private static function isContainerSeparator(param1:FlowElement, param2:Array) : Boolean
      {
         var _loc3_:int = 0;
         var _loc4_:int = param2.length;
         while(_loc3_ < _loc4_)
         {
            if(param2[_loc3_] == param1)
            {
               return true;
            }
            _loc3_++;
         }
         return false;
      }
      
      private static function insertTextFlow(param1:TextFlow, param2:int, param3:FlowGroupElement, param4:Array = null, param5:Array = null, param6:Array = null) : int
      {
         var _loc8_:FlowElement = null;
         var _loc9_:DivElement = null;
         var _loc10_:FlowLeafElement = null;
         var _loc11_:ParagraphElement = null;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:Boolean = false;
         var _loc15_:FlowGroupElement = null;
         var _loc16_:Boolean = false;
         var _loc17_:ParagraphElement = null;
         var _loc18_:ParagraphElement = null;
         var _loc19_:int = 0;
         var _loc7_:int = param2;
         if(!TextFlowEdit.isInsertableItem(param3,param4,param5) || param3 is TextFlow)
         {
            if(param3 is TextFlow)
            {
               processedFirstFlowElement = false;
               _loc9_ = TextFlowEdit.putDivAtEndOfContainer(param1 as ContainerFormattedElement);
               param6 = new Array();
               param6.push(_loc9_);
            }
            _loc8_ = param3.getChildAt(0);
            if(TextFlowEdit.isInsertableItem(_loc8_,param4,param5))
            {
               _loc7_ = TextFlowEdit.putDivAtEndOfContainerAndInsertTextFlow(param1,_loc7_,param3,param4,param5,param6);
            }
            else
            {
               while(param3.numChildren > 0)
               {
                  _loc8_ = param3.getChildAt(0);
                  param3.replaceChildren(0,1,null);
                  _loc7_ = TextFlowEdit.insertTextFlow(param1,_loc7_,_loc8_ as FlowGroupElement,param4,param5,param6);
               }
            }
            if(param3 is TextFlow)
            {
               param1.replaceChildren(param1.numChildren - 1,param1.numChildren,null);
               if(_loc7_ >= param1.textLength)
               {
                  _loc7_ = param1.textLength - 1;
               }
               param6.pop();
            }
         }
         else
         {
            _loc10_ = null;
            if(param2 > 0)
            {
               _loc10_ = param1.findLeaf(param2 - 1);
            }
            _loc11_ = param1.findAbsoluteParagraph(param2);
            _loc12_ = param2 - _loc11_.getAbsoluteStart();
            _loc13_ = _loc11_.parent.getChildIndex(_loc11_);
            _loc14_ = true;
            if(_loc12_ > 0)
            {
               if(_loc12_ < _loc11_.textLength - 1)
               {
                  _loc11_.splitAtPosition(_loc12_);
               }
               else if(param3.textLength == 1 && !processedFirstFlowElement)
               {
                  if(TextFlowEdit.isFlowElementInArray(param5,param3) || TextFlowEdit.isFlowElementInArray(param4,param3))
                  {
                     processedFirstFlowElement = true;
                     return _loc7_;
                  }
                  _loc11_.splitAtPosition(_loc12_);
               }
               else
               {
                  _loc14_ = false;
               }
               param2++;
            }
            else
            {
               _loc13_--;
            }
            _loc15_ = _loc11_.parent;
            if(TextFlowEdit.isContainerSeparator(_loc15_,param6))
            {
               _loc13_ = _loc15_.parent.getChildIndex(_loc15_);
               _loc15_ = _loc15_.parent;
               _loc13_--;
            }
            _loc15_.replaceChildren(_loc13_ + 1,_loc13_ + 1,param3);
            _loc7_ = param2 + param3.textLength;
            if(param3 is ParagraphElement)
            {
               _loc16_ = TextFlowEdit.isFlowElementInArray(param5,param3);
               if(_loc14_ && _loc16_)
               {
                  if(_loc12_ == 0)
                  {
                     if(joinToNextParagraph(ParagraphElement(param3)))
                     {
                        _loc7_--;
                     }
                  }
                  else if(joinNextParagraph(ParagraphElement(param3)))
                  {
                     _loc7_--;
                  }
               }
               if(!processedFirstFlowElement)
               {
                  if(_loc12_ > 0)
                  {
                     _loc17_ = param3.getPreviousSibling() as ParagraphElement;
                     if(_loc17_ && joinNextParagraph(_loc17_))
                     {
                        _loc7_--;
                     }
                  }
               }
               if(_loc16_)
               {
                  _loc18_ = _loc15_.getTextFlow().findAbsoluteParagraph(_loc7_);
                  _loc19_ = _loc18_.getAbsoluteStart();
                  if(_loc7_ - _loc18_.getAbsoluteStart() == 0)
                  {
                     _loc7_--;
                  }
               }
            }
            processedFirstFlowElement = true;
         }
         return _loc7_;
      }
      
      public static function replaceRange(param1:TextFlow, param2:int, param3:int, param4:TextScrap = null) : int
      {
         var _loc5_:int = param2;
         if(param3 > param2)
         {
            deleteRange(param1,param2,param3);
         }
         if(param4 != null)
         {
            param4 = param4.clone();
            _loc5_ = insertTextFlow(param1,param2,param4.textFlow,param4.beginMissingArray,param4.endMissingArray);
         }
         return _loc5_;
      }
      
      public static function createTextScrap(param1:TextFlow, param2:int, param3:int) : TextScrap
      {
         var _loc6_:FlowElement = null;
         var _loc7_:FlowElement = null;
         var _loc8_:FlowElement = null;
         if(!param1 || param2 >= param3)
         {
            return null;
         }
         var _loc4_:TextFlow = param1.deepCopy(param2,param3) as TextFlow;
         _loc4_.normalize();
         var _loc5_:TextScrap = new TextScrap(_loc4_);
         if(_loc4_.textLength > 0)
         {
            _loc6_ = _loc4_.getLastLeaf();
            _loc7_ = param1.findLeaf(param2);
            _loc8_ = _loc4_.getFirstLeaf();
            while(_loc8_ && _loc7_)
            {
               if(param2 - _loc7_.getAbsoluteStart() > 0)
               {
                  _loc5_.addToBeginMissing(_loc8_);
               }
               _loc8_ = _loc8_.parent;
               _loc7_ = _loc7_.parent;
            }
            _loc7_ = param1.findLeaf(param3 - 1);
            _loc8_ = _loc4_.getLastLeaf();
            if(_loc8_ is SpanElement && !(_loc7_ is SpanElement))
            {
               _loc8_ = _loc4_.findLeaf(_loc4_.textLength - 2);
            }
            while(_loc8_ && _loc7_)
            {
               if(param3 < _loc7_.getAbsoluteStart() + _loc7_.textLength)
               {
                  _loc5_.addToEndMissing(_loc8_);
               }
               _loc8_ = _loc8_.parent;
               _loc7_ = _loc7_.parent;
            }
            return _loc5_;
         }
         return null;
      }
      
      public static function makeTCY(param1:TextFlow, param2:int, param3:int) : Boolean
      {
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:TCYElement = null;
         var _loc4_:Boolean = true;
         var _loc5_:ParagraphElement = param1.findAbsoluteParagraph(param2);
         if(!_loc5_)
         {
            return false;
         }
         while(_loc5_)
         {
            _loc6_ = _loc5_.getAbsoluteStart() + _loc5_.textLength;
            _loc7_ = Math.min(_loc6_,param3);
            if(canInsertSPBlock(param1,param2,_loc7_,TCYElement) && _loc5_.textLength > 1)
            {
               _loc8_ = new TCYElement();
               if(_loc4_)
               {
                  _loc4_ = insertNewSPBlock(param1,param2,_loc7_,_loc8_,TCYElement);
               }
               else
               {
                  insertNewSPBlock(param1,param2,_loc7_,_loc8_,TCYElement);
               }
            }
            else
            {
               _loc4_ = false;
            }
            if(_loc6_ < param3)
            {
               _loc5_ = param1.findAbsoluteParagraph(_loc7_);
               param2 = _loc7_;
            }
            else
            {
               _loc5_ = null;
            }
         }
         return _loc4_;
      }
      
      public static function makeLink(param1:TextFlow, param2:int, param3:int, param4:String, param5:String) : Boolean
      {
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:LinkElement = null;
         var _loc6_:Boolean = true;
         var _loc7_:ParagraphElement = param1.findAbsoluteParagraph(param2);
         if(!_loc7_)
         {
            return false;
         }
         while(_loc7_)
         {
            _loc8_ = _loc7_.getAbsoluteStart() + _loc7_.textLength;
            _loc9_ = Math.min(_loc8_,param3);
            _loc10_ = _loc9_ == _loc8_?int(_loc9_ - 1):int(_loc9_);
            if(_loc10_ > param2)
            {
               if(!canInsertSPBlock(param1,param2,_loc10_,LinkElement))
               {
                  return false;
               }
               _loc11_ = new LinkElement();
               _loc11_.href = param4;
               _loc11_.target = param5;
               if(_loc6_)
               {
                  _loc6_ = insertNewSPBlock(param1,param2,_loc10_,_loc11_,LinkElement);
               }
               else
               {
                  insertNewSPBlock(param1,param2,_loc10_,_loc11_,LinkElement);
               }
            }
            if(_loc8_ < param3)
            {
               _loc7_ = param1.findAbsoluteParagraph(_loc9_);
               param2 = _loc9_;
            }
            else
            {
               _loc7_ = null;
            }
         }
         return _loc6_;
      }
      
      public static function removeTCY(param1:TextFlow, param2:int, param3:int) : Boolean
      {
         if(param3 <= param2)
         {
            return false;
         }
         return findAndRemoveFlowGroupElement(param1,param2,param3,TCYElement);
      }
      
      public static function removeLink(param1:TextFlow, param2:int, param3:int) : Boolean
      {
         if(param3 <= param2)
         {
            return false;
         }
         return findAndRemoveFlowGroupElement(param1,param2,param3,LinkElement);
      }
      
      tlf_internal static function insertNewSPBlock(param1:TextFlow, param2:int, param3:int, param4:SubParagraphGroupElement, param5:Class) : Boolean
      {
         var _loc6_:int = param2;
         var _loc7_:FlowGroupElement = param1.findAbsoluteFlowGroupElement(_loc6_);
         var _loc8_:int = 0;
         var _loc9_:ParagraphElement = _loc7_.getParagraph();
         if(param3 == _loc9_.getAbsoluteStart() + _loc9_.textLength - 1)
         {
            param3++;
         }
         var _loc10_:int = _loc7_.parent.getAbsoluteStart();
         var _loc11_:int = _loc7_.getAbsoluteStart();
         if(_loc7_.parent && _loc7_.parent is param5 && !(_loc10_ == _loc11_ && _loc10_ + _loc7_.parent.textLength == _loc11_ + _loc7_.textLength))
         {
            return false;
         }
         if(!(_loc7_ is ParagraphElement) && _loc6_ == _loc11_ && _loc6_ + _loc7_.textLength <= param3)
         {
            _loc8_ = _loc7_.parent.getChildIndex(_loc7_);
            _loc7_ = _loc7_.parent;
         }
         if(_loc6_ >= _loc11_)
         {
            if(!(_loc7_ is param5))
            {
               _loc8_ = findAndSplitElement(_loc7_,_loc8_,_loc6_,true);
            }
            else
            {
               _loc8_ = findAndSplitElement(_loc7_.parent,_loc7_.parent.getChildIndex(_loc7_),_loc6_,false);
               _loc7_ = _loc7_.parent;
            }
         }
         if(_loc7_ is param5)
         {
            _loc11_ = _loc7_.getAbsoluteStart();
            _loc8_ = _loc7_.parent.getChildIndex(_loc7_);
            if(_loc6_ > _loc11_)
            {
               _loc8_ = _loc8_ + 1;
            }
            while(param3 >= _loc11_ + _loc7_.textLength)
            {
               _loc7_ = _loc7_.parent;
            }
            _loc7_.replaceChildren(_loc8_,_loc8_,param4);
         }
         else
         {
            _loc7_.replaceChildren(_loc8_,_loc8_,param4);
         }
         subsumeElementsToSPBlock(_loc7_,_loc8_ + 1,_loc6_,param3,param4,param5);
         return true;
      }
      
      tlf_internal static function splitElement(param1:FlowElement, param2:int, param3:Boolean) : void
      {
         var _loc4_:SubParagraphGroupElement = null;
         var _loc5_:SpanElement = null;
         if(param1 is SpanElement)
         {
            SpanElement(param1).splitAtPosition(param2);
         }
         else if(param1 is SubParagraphGroupElement && param3)
         {
            _loc4_ = SubParagraphGroupElement(param1);
            _loc5_ = _loc4_.findLeaf(param2) as SpanElement;
            if(_loc5_)
            {
               _loc5_.splitAtPosition(param2 - _loc5_.getElementRelativeStart(_loc4_));
            }
         }
         else if(param1 is FlowGroupElement)
         {
            FlowGroupElement(param1).splitAtPosition(param2);
         }
      }
      
      tlf_internal static function findAndSplitElement(param1:FlowGroupElement, param2:int, param3:int, param4:Boolean) : int
      {
         var _loc5_:FlowElement = null;
         var _loc6_:int = param3 - param1.getAbsoluteStart();
         while(param2 < param1.numChildren)
         {
            _loc5_ = param1.getChildAt(param2);
            if(_loc6_ == _loc5_.parentRelativeStart)
            {
               return param2;
            }
            if(_loc6_ > _loc5_.parentRelativeStart && _loc6_ < _loc5_.parentRelativeEnd)
            {
               splitElement(_loc5_,_loc6_ - _loc5_.parentRelativeStart,param4);
            }
            param2++;
         }
         return param2;
      }
      
      tlf_internal static function subsumeElementsToSPBlock(param1:FlowGroupElement, param2:int, param3:int, param4:int, param5:SubParagraphGroupElement, param6:Class) : int
      {
         var _loc8_:SubParagraphGroupElement = null;
         var _loc9_:FlowElement = null;
         var _loc10_:SubParagraphGroupElement = null;
         var _loc11_:int = 0;
         var _loc12_:FlowElement = null;
         var _loc7_:FlowElement = null;
         if(param2 >= param1.numChildren)
         {
            return param3;
         }
         while(param3 < param4)
         {
            _loc7_ = param1.getChildAt(param2);
            if(param3 + _loc7_.textLength > param4)
            {
               splitElement(_loc7_,param4 - _loc7_.getAbsoluteStart(),!(_loc7_ is param6));
            }
            param3 = param3 + _loc7_.textLength;
            param1.replaceChildren(param2,param2 + 1,null);
            if(_loc7_ is param6)
            {
               _loc8_ = _loc7_ as SubParagraphGroupElement;
               while(_loc8_.numChildren > 0)
               {
                  _loc9_ = _loc8_.getChildAt(0);
                  _loc8_.replaceChildren(0,1,null);
                  param5.replaceChildren(param5.numChildren,param5.numChildren,_loc9_);
               }
            }
            else
            {
               if(_loc7_ is SubParagraphGroupElement)
               {
                  flushSPBlock(_loc7_ as SubParagraphGroupElement,param6);
               }
               param5.replaceChildren(param5.numChildren,param5.numChildren,_loc7_);
               if(param5.numChildren == 1 && _loc7_ is SubParagraphGroupElement)
               {
                  _loc10_ = _loc7_ as SubParagraphGroupElement;
                  if(_loc10_.textLength == param5.textLength && param3 >= param4)
                  {
                     if(_loc10_.precedence > param5.precedence)
                     {
                        param5.replaceChildren(0,1,null);
                        while(_loc10_.numChildren > 0)
                        {
                           _loc12_ = _loc10_.getChildAt(0);
                           _loc10_.replaceChildren(0,1,null);
                           param5.replaceChildren(param5.numChildren,param5.numChildren,_loc12_);
                        }
                        _loc11_ = param5.parent.getChildIndex(param5);
                        param5.parent.replaceChildren(_loc11_,_loc11_ + 1,_loc10_);
                        _loc10_.replaceChildren(0,0,param5);
                     }
                  }
               }
            }
         }
         return param3;
      }
      
      tlf_internal static function findAndRemoveFlowGroupElement(param1:TextFlow, param2:int, param3:int, param4:Class) : Boolean
      {
         var _loc6_:FlowElement = null;
         var _loc7_:FlowGroupElement = null;
         var _loc8_:FlowGroupElement = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:FlowGroupElement = null;
         var _loc12_:FlowGroupElement = null;
         var _loc13_:int = 0;
         var _loc14_:FlowElement = null;
         var _loc15_:SubParagraphGroupElement = null;
         var _loc5_:int = param2;
         while(_loc5_ < param3)
         {
            _loc7_ = param1.findAbsoluteFlowGroupElement(_loc5_);
            while(_loc7_.parent && _loc7_.parent.getAbsoluteStart() == _loc7_.getAbsoluteStart() && !(_loc7_.parent is ParagraphElement))
            {
               _loc7_ = _loc7_.parent;
            }
            if(_loc7_ is param4)
            {
               _loc7_ = _loc7_.parent;
            }
            _loc8_ = _loc7_.parent;
            while(_loc8_ != null && !(_loc8_ is param4))
            {
               if(_loc8_.parent is param4)
               {
                  return false;
               }
               _loc8_ = _loc8_.parent;
            }
            _loc9_ = _loc7_.getAbsoluteStart();
            if(_loc8_ is param4 && (_loc9_ >= _loc5_ && _loc9_ + _loc7_.textLength <= param3))
            {
               _loc7_ = _loc8_.parent;
            }
            _loc10_ = _loc7_.findChildIndexAtPosition(_loc5_ - _loc9_);
            _loc6_ = _loc7_.getChildAt(_loc10_);
            if(_loc6_ is param4)
            {
               _loc11_ = _loc6_ as FlowGroupElement;
               _loc12_ = _loc11_.parent;
               _loc13_ = _loc12_.getChildIndex(_loc11_);
               if(_loc5_ > _loc11_.getAbsoluteStart())
               {
                  splitElement(_loc11_,_loc5_ - _loc11_.getAbsoluteStart(),false);
                  _loc5_ = _loc11_.getAbsoluteStart() + _loc11_.textLength;
               }
               else
               {
                  if(_loc11_.getAbsoluteStart() + _loc11_.textLength > param3)
                  {
                     splitElement(_loc11_,param3 - _loc11_.getAbsoluteStart(),false);
                  }
                  _loc5_ = _loc11_.getAbsoluteStart() + _loc11_.textLength;
                  while(_loc11_.numChildren > 0)
                  {
                     _loc14_ = _loc11_.getChildAt(0);
                     _loc11_.replaceChildren(0,1,null);
                     _loc12_.replaceChildren(_loc13_,_loc13_,_loc14_);
                     _loc13_++;
                  }
                  _loc12_.replaceChildren(_loc13_,_loc13_ + 1,null);
               }
            }
            else if(_loc6_ is SubParagraphGroupElement)
            {
               _loc15_ = SubParagraphGroupElement(_loc6_);
               if(_loc15_.numChildren == 1)
               {
                  _loc5_ = _loc15_.getAbsoluteStart() + _loc15_.textLength;
               }
               else
               {
                  _loc6_ = _loc15_.getChildAt(_loc15_.findChildIndexAtPosition(_loc5_ - _loc15_.getAbsoluteStart()));
                  _loc5_ = _loc6_.getAbsoluteStart() + _loc6_.textLength;
               }
            }
            else
            {
               _loc5_ = _loc6_.getAbsoluteStart() + _loc6_.textLength;
            }
         }
         return true;
      }
      
      tlf_internal static function canInsertSPBlock(param1:TextFlow, param2:int, param3:int, param4:Class) : Boolean
      {
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         if(param3 <= param2)
         {
            return false;
         }
         var _loc5_:FlowGroupElement = param1.findAbsoluteFlowGroupElement(param2);
         if(_loc5_.getParentByType(param4))
         {
            _loc5_ = _loc5_.getParentByType(param4) as FlowGroupElement;
         }
         var _loc6_:FlowGroupElement = param1.findAbsoluteFlowGroupElement(param3 - 1);
         if(_loc6_.getParentByType(param4))
         {
            _loc6_ = _loc6_.getParentByType(param4) as FlowGroupElement;
         }
         if(_loc5_ == _loc6_)
         {
            return true;
         }
         if(_loc5_.getParagraph() != _loc6_.getParagraph())
         {
            return false;
         }
         if(_loc5_ is param4 && _loc6_ is param4)
         {
            return true;
         }
         if(_loc5_ is SubParagraphGroupElement && !(_loc5_ is param4))
         {
            _loc7_ = _loc5_.getAbsoluteStart();
            if(param2 > _loc7_ && param3 > _loc7_ + _loc5_.textLength)
            {
               return false;
            }
         }
         else if((_loc5_.parent is SubParagraphGroupElement || _loc6_.parent is SubParagraphGroupElement) && _loc5_.parent != _loc6_.parent)
         {
            return false;
         }
         if(_loc6_ is SubParagraphGroupElement && !(_loc6_ is param4) && param3 > _loc6_.getAbsoluteStart())
         {
            _loc8_ = _loc6_.getAbsoluteStart();
            if(param2 < _loc8_ && param3 < _loc8_ + _loc6_.textLength)
            {
               return false;
            }
         }
         return true;
      }
      
      tlf_internal static function flushSPBlock(param1:SubParagraphGroupElement, param2:Class) : void
      {
         var _loc4_:FlowElement = null;
         var _loc5_:FlowGroupElement = null;
         var _loc6_:FlowElement = null;
         var _loc3_:int = 0;
         while(_loc3_ < param1.numChildren)
         {
            _loc4_ = param1.getChildAt(_loc3_);
            if(_loc4_ is param2)
            {
               _loc5_ = _loc4_ as FlowGroupElement;
               while(_loc5_.numChildren > 0)
               {
                  _loc6_ = _loc5_.getChildAt(0);
                  _loc5_.replaceChildren(0,1,null);
                  param1.replaceChildren(_loc3_,_loc3_,_loc6_);
               }
               _loc3_++;
               param1.replaceChildren(_loc3_,_loc3_ + 1,null);
            }
            else if(_loc4_ is SubParagraphGroupElement)
            {
               flushSPBlock(_loc4_ as SubParagraphGroupElement,param2);
               _loc3_++;
            }
            else
            {
               _loc3_++;
            }
         }
      }
      
      public static function joinNextParagraph(param1:ParagraphElement) : Boolean
      {
         var _loc2_:int = 0;
         var _loc3_:ParagraphElement = null;
         var _loc4_:FlowElement = null;
         if(param1 && param1.parent)
         {
            _loc2_ = param1.parent.getChildIndex(param1);
            if(_loc2_ != param1.parent.numChildren - 1)
            {
               _loc3_ = param1.parent.getChildAt(_loc2_ + 1) as ParagraphElement;
               if(_loc3_)
               {
                  while(_loc3_.numChildren > 0)
                  {
                     _loc4_ = _loc3_.getChildAt(0);
                     _loc3_.replaceChildren(0,1,null);
                     param1.replaceChildren(param1.numChildren,param1.numChildren,_loc4_);
                  }
                  param1.parent.replaceChildren(_loc2_ + 1,_loc2_ + 2,null);
                  return true;
               }
            }
         }
         return false;
      }
      
      public static function joinToNextParagraph(param1:ParagraphElement) : Boolean
      {
         var _loc2_:int = 0;
         var _loc3_:ParagraphElement = null;
         var _loc4_:int = 0;
         var _loc5_:FlowElement = null;
         if(param1 && param1.parent)
         {
            _loc2_ = param1.parent.getChildIndex(param1);
            if(_loc2_ != param1.parent.numChildren - 1)
            {
               _loc3_ = param1.parent.getChildAt(_loc2_ + 1) as ParagraphElement;
               if(_loc3_)
               {
                  _loc4_ = 0;
                  while(param1.numChildren > 0)
                  {
                     _loc5_ = param1.getChildAt(0);
                     param1.replaceChildren(0,1,null);
                     _loc3_.replaceChildren(_loc4_,_loc4_,_loc5_);
                     _loc4_++;
                  }
                  param1.parent.replaceChildren(_loc2_,_loc2_ + 1,null);
                  return true;
               }
            }
         }
         return false;
      }
   }
}
