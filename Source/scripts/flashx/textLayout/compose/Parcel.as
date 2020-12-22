package flashx.textLayout.compose
{
   import flash.geom.Rectangle;
   import flashx.textLayout.container.ContainerController;
   import flashx.textLayout.tlf_internal;
   
   use namespace tlf_internal;
   
   public class Parcel extends Rectangle
   {
      
      public static const TOP_OF_COLUMN:int = 1;
      
      public static const BOT_OF_COLUMN:int = 2;
      
      public static const FULL_COLUMN:int = 3;
       
      
      private var _controller:ContainerController;
      
      private var _columnCoverage:int;
      
      private var _column:int;
      
      private var _fitAny:Boolean;
      
      private var _composeToPosition:Boolean;
      
      public function Parcel(param1:Number, param2:Number, param3:Number, param4:Number, param5:ContainerController, param6:int, param7:int)
      {
         super(param1,param2,param3,param4);
         this._controller = param5;
         this._column = param6;
         this._columnCoverage = param7;
         this._fitAny = false;
         this._composeToPosition = false;
      }
      
      public function initialize(param1:Number, param2:Number, param3:Number, param4:Number, param5:ContainerController, param6:int, param7:int) : Parcel
      {
         this.x = param1;
         this.y = param2;
         this.width = param3;
         this.height = param4;
         this._controller = param5;
         this._column = param6;
         this._columnCoverage = param7;
         this._fitAny = false;
         this._composeToPosition = false;
         return this;
      }
      
      tlf_internal function releaseAnyReferences() : void
      {
         this._controller = null;
      }
      
      public function replaceBounds(param1:Rectangle) : void
      {
         this.x = param1.x;
         this.y = param1.y;
         this.width = param1.width;
         this.height = param1.height;
      }
      
      public function get controller() : ContainerController
      {
         return this._controller;
      }
      
      public function get topOfColumn() : Boolean
      {
         return (this._columnCoverage & TOP_OF_COLUMN) == TOP_OF_COLUMN;
      }
      
      public function get columnCoverage() : int
      {
         return this._columnCoverage;
      }
      
      public function set columnCoverage(param1:int) : void
      {
         this._columnCoverage = param1;
      }
      
      public function get column() : int
      {
         return this._column;
      }
      
      public function get fitAny() : Boolean
      {
         return this._fitAny;
      }
      
      public function set fitAny(param1:Boolean) : void
      {
         this._fitAny = param1;
      }
      
      public function get composeToPosition() : Boolean
      {
         return this._composeToPosition;
      }
      
      public function set composeToPosition(param1:Boolean) : void
      {
         this._composeToPosition = param1;
      }
      
      public function get measureWidth() : Boolean
      {
         return this.controller.measureWidth;
      }
      
      public function get measureHeight() : Boolean
      {
         return this.controller.measureHeight;
      }
   }
}
