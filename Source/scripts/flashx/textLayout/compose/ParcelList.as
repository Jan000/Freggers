package flashx.textLayout.compose
{
   import flash.geom.Rectangle;
   import flash.text.engine.TextLine;
   import flashx.textLayout.container.ColumnState;
   import flashx.textLayout.container.ContainerController;
   import flashx.textLayout.container.ScrollPolicy;
   import flashx.textLayout.formats.BlockProgression;
   import flashx.textLayout.formats.ITextLayoutFormat;
   import flashx.textLayout.formats.LineBreak;
   import flashx.textLayout.tlf_internal;
   
   use namespace tlf_internal;
   
   public class ParcelList implements IParcelList
   {
      
      private static const MAX_HEIGHT:Number = 900000000;
      
      private static const MAX_WIDTH:Number = 900000000;
      
      private static var _sharedParcelList:ParcelList;
       
      
      protected var _flowComposer:IFlowComposer;
      
      protected var _totalDepth:Number;
      
      protected var _hasContent:Boolean;
      
      private var _parcelArray:Array;
      
      private var _numParcels:int;
      
      private var _singleParcel:Parcel;
      
      protected var _currentParcelIndex:int;
      
      protected var _currentParcel:Parcel;
      
      protected var _notifyOnParcelChange:Function;
      
      private var _columnIndex:int;
      
      private var _columnController:ContainerController;
      
      private var _explicitLineBreaks:Boolean;
      
      protected var _blockProgression:String;
      
      public function ParcelList()
      {
         super();
         this._numParcels = 0;
      }
      
      tlf_internal static function getParcelList() : ParcelList
      {
         var _loc1_:ParcelList = !!_sharedParcelList?_sharedParcelList:new ParcelList();
         _sharedParcelList = null;
         return _loc1_;
      }
      
      tlf_internal static function releaseParcelList(param1:IParcelList) : void
      {
         if(_sharedParcelList == null)
         {
            _sharedParcelList = param1 as ParcelList;
            if(_sharedParcelList)
            {
               _sharedParcelList.releaseAnyReferences();
            }
         }
      }
      
      tlf_internal function releaseAnyReferences() : void
      {
         this._flowComposer = null;
         this._columnController = null;
         this._numParcels = 0;
         this._parcelArray = null;
         if(this._singleParcel)
         {
            this._singleParcel.releaseAnyReferences();
         }
      }
      
      protected function get numParcels() : int
      {
         return this._numParcels;
      }
      
      protected function getParcelAtIndex(param1:int) : Parcel
      {
         return this._numParcels == 1?this._singleParcel:this._parcelArray[param1];
      }
      
      protected function insertParcel(param1:int, param2:Parcel) : void
      {
         if(this._numParcels == 0)
         {
            this._singleParcel = param2;
         }
         else
         {
            if(this._numParcels == 1)
            {
               this._parcelArray = [this._singleParcel];
            }
            this._parcelArray.splice(param1,0,param2);
         }
         this._numParcels++;
      }
      
      protected function set parcels(param1:Array) : void
      {
         this._numParcels = param1.length;
         if(this._numParcels == 0)
         {
            this._parcelArray = null;
         }
         else if(this._numParcels == 1)
         {
            this._parcelArray = null;
            this._singleParcel = param1[0];
         }
         else
         {
            this._parcelArray = param1;
         }
      }
      
      public function get left() : Number
      {
         return this._currentParcel.left;
      }
      
      public function get right() : Number
      {
         return this._currentParcel.right;
      }
      
      public function get top() : Number
      {
         return this._currentParcel.top;
      }
      
      public function get bottom() : Number
      {
         return this._currentParcel.bottom;
      }
      
      public function get width() : Number
      {
         return this._currentParcel.width;
      }
      
      public function get height() : Number
      {
         return this._currentParcel.height;
      }
      
      public function get fitAny() : Boolean
      {
         return this._currentParcel.fitAny;
      }
      
      public function get controller() : ContainerController
      {
         return this._columnController;
      }
      
      public function get columnIndex() : int
      {
         return this._columnIndex;
      }
      
      public function get explicitLineBreaks() : Boolean
      {
         return this._explicitLineBreaks;
      }
      
      private function get measureWidth() : Boolean
      {
         if(this._explicitLineBreaks)
         {
            return true;
         }
         if(!this._currentParcel)
         {
            return false;
         }
         if(this._blockProgression == BlockProgression.TB)
         {
            return this._currentParcel.measureWidth;
         }
         return this._currentParcel.measureHeight;
      }
      
      private function get measureHeight() : Boolean
      {
         if(!this._currentParcel)
         {
            return false;
         }
         if(this._blockProgression == BlockProgression.TB)
         {
            return this._currentParcel.measureHeight;
         }
         return this._currentParcel.measureWidth;
      }
      
      public function get totalDepth() : Number
      {
         return this._totalDepth;
      }
      
      public function get notifyOnParcelChange() : Function
      {
         return this._notifyOnParcelChange;
      }
      
      public function set notifyOnParcelChange(param1:Function) : void
      {
         this._notifyOnParcelChange = param1;
      }
      
      public function addTotalDepth(param1:Number) : Number
      {
         this._hasContent = true;
         this._totalDepth = this._totalDepth + param1;
         return this._totalDepth;
      }
      
      protected function reset() : void
      {
         this._totalDepth = 0;
         this._hasContent = false;
         this._columnIndex = 0;
         this._currentParcelIndex = 0;
         if(this._numParcels != 0)
         {
            this._currentParcel = this.getParcelAtIndex(this._currentParcelIndex);
            this._columnController = this._currentParcel.controller;
            this._columnIndex = 0;
         }
         else
         {
            this._currentParcel = null;
            this._columnController = null;
            this._columnIndex = -1;
         }
      }
      
      private function addParcel(param1:Rectangle, param2:ContainerController, param3:int, param4:int) : void
      {
         var _loc5_:Parcel = this._numParcels == 0 && this._singleParcel?this._singleParcel.initialize(param1.x,param1.y,param1.width,param1.height,param2,param3,param4):new Parcel(param1.x,param1.y,param1.width,param1.height,param2,param3,param4);
         if(this._numParcels == 0)
         {
            this._singleParcel = _loc5_;
         }
         else if(this.numParcels == 1)
         {
            this._parcelArray = [this._singleParcel,_loc5_];
         }
         else
         {
            this._parcelArray.push(_loc5_);
         }
         this._numParcels++;
      }
      
      protected function addOneControllerToParcelList(param1:ContainerController) : void
      {
         var _loc4_:Rectangle = null;
         var _loc2_:ColumnState = param1.columnState;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.columnCount)
         {
            _loc4_ = _loc2_.getColumnAt(_loc3_);
            if(!_loc4_.isEmpty())
            {
               this.addParcel(_loc4_,param1,_loc3_,Parcel.FULL_COLUMN);
            }
            _loc3_++;
         }
      }
      
      public function beginCompose(param1:IFlowComposer, param2:int, param3:Boolean) : void
      {
         var _loc5_:int = 0;
         this._flowComposer = param1;
         var _loc4_:ITextLayoutFormat = param1.rootElement.computedFormat;
         this._explicitLineBreaks = _loc4_.lineBreak == LineBreak.EXPLICIT;
         this._blockProgression = _loc4_.blockProgression;
         if(param1.numControllers != 0)
         {
            if(param2 < 0)
            {
               param2 = param1.numControllers - 1;
            }
            else
            {
               param2 = Math.min(param2,param1.numControllers - 1);
            }
            _loc5_ = 0;
            do
            {
               this.addOneControllerToParcelList(ContainerController(param1.getControllerAt(_loc5_)));
            }
            while(_loc5_++ != param2);
            
            if(param2 == param1.numControllers - 1)
            {
               this.adjustForScroll(ContainerController(ContainerController(param1.getControllerAt(param1.numControllers - 1))),param3);
            }
         }
         this.reset();
      }
      
      private function adjustForScroll(param1:ContainerController, param2:Boolean) : void
      {
         var _loc3_:Parcel = null;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         if(this._blockProgression != BlockProgression.RL)
         {
            if(param1.verticalScrollPolicy != ScrollPolicy.OFF)
            {
               _loc3_ = this.getParcelAtIndex(this._numParcels - 1);
               if(_loc3_)
               {
                  _loc4_ = param1.effectivePaddingBottom + param1.effectivePaddingTop;
                  _loc3_.bottom = param1.verticalScrollPosition + _loc3_.height + _loc4_;
                  _loc3_.fitAny = true;
                  _loc3_.composeToPosition = param2;
               }
            }
         }
         else if(param1.horizontalScrollPolicy != ScrollPolicy.OFF)
         {
            _loc3_ = this.getParcelAtIndex(this._numParcels - 1);
            if(_loc3_)
            {
               _loc5_ = param1.effectivePaddingRight + param1.effectivePaddingLeft;
               _loc3_.left = param1.horizontalScrollPosition - _loc3_.width - _loc5_;
               _loc3_.fitAny = true;
               _loc3_.composeToPosition = param2;
            }
         }
      }
      
      public function getComposeXCoord(param1:Rectangle) : Number
      {
         return this._blockProgression == BlockProgression.RL?Number(param1.right):Number(param1.left);
      }
      
      public function getComposeYCoord(param1:Rectangle) : Number
      {
         return param1.top;
      }
      
      public function getComposeWidth(param1:Rectangle) : Number
      {
         if(this.measureWidth)
         {
            return TextLine.MAX_LINE_WIDTH;
         }
         return this._blockProgression == BlockProgression.RL?Number(param1.height):Number(param1.width);
      }
      
      public function getComposeHeight(param1:Rectangle) : Number
      {
         if(this.measureHeight)
         {
            return TextLine.MAX_LINE_WIDTH;
         }
         return this._blockProgression == BlockProgression.RL?Number(param1.width):Number(param1.height);
      }
      
      public function isColumnStart() : Boolean
      {
         return !this._hasContent && this._currentParcel.topOfColumn;
      }
      
      public function atLast() : Boolean
      {
         return this._numParcels == 0 || this._currentParcelIndex == this._numParcels - 1;
      }
      
      public function atEnd() : Boolean
      {
         return this._numParcels == 0 || this._currentParcelIndex >= this._numParcels;
      }
      
      public function next() : Boolean
      {
         var _loc2_:ContainerController = null;
         var _loc1_:* = this._currentParcelIndex + 1 < this._numParcels;
         this._notifyOnParcelChange(!!_loc1_?this.getParcelAtIndex(this._currentParcelIndex + 1):null);
         this._currentParcelIndex = this._currentParcelIndex + 1;
         this._totalDepth = 0;
         this._hasContent = false;
         if(_loc1_)
         {
            this._currentParcel = this.getParcelAtIndex(this._currentParcelIndex);
            _loc2_ = this._currentParcel.controller;
            if(_loc2_ == this._columnController)
            {
               this._columnIndex++;
            }
            else
            {
               this._columnIndex = 0;
               this._columnController = _loc2_;
            }
         }
         else
         {
            this._currentParcel = null;
            this._columnIndex = -1;
            this._columnController = null;
         }
         return _loc1_;
      }
      
      public function createParcel(param1:Rectangle, param2:String, param3:Boolean) : Boolean
      {
         return false;
      }
      
      public function createParcelExperimental(param1:Rectangle, param2:String) : Boolean
      {
         return false;
      }
      
      public function get currentParcel() : Parcel
      {
         return this._currentParcel;
      }
      
      public function getLineSlug(param1:Rectangle, param2:Number, param3:Number = 0) : Boolean
      {
         var _loc4_:Number = NaN;
         if(this._currentParcelIndex < this._numParcels)
         {
            _loc4_ = this.getComposeWidth(this._currentParcel);
            if(_loc4_ > param3)
            {
               if(this.currentParcel.composeToPosition || this._totalDepth + (!!this._currentParcel.fitAny?1:int(param2)) <= this.getComposeHeight(this._currentParcel))
               {
                  if(this._blockProgression != BlockProgression.RL)
                  {
                     param1.x = this.left;
                     param1.y = this._currentParcel.top + this._totalDepth;
                     param1.width = _loc4_;
                     param1.height = param2;
                  }
                  else
                  {
                     param1.x = this.left;
                     param1.y = this._currentParcel.top;
                     param1.width = this._currentParcel.width - this._totalDepth;
                     param1.height = _loc4_;
                  }
                  return true;
               }
            }
         }
         return false;
      }
   }
}
