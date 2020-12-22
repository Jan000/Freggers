package de.freggers.isostar.grouping
{
   import de.freggers.isostar.IsoSortable;
   import flash.geom.Rectangle;
   
   final class CutData
   {
      
      public static const CUT_HORIZONTAL:Boolean = true;
      
      public static const CUT_VERTICAL:Boolean = false;
       
      
      public var cuttedArea:Rectangle;
      
      public var weight:Number = 0;
      
      public var cutPosition:int = -1;
      
      public var cutDirection:Boolean = false;
      
      public var isosortablesBeforeCut:Vector.<IsoSortable>;
      
      public var isosortablesAfterCut:Vector.<IsoSortable>;
      
      function CutData(param1:Rectangle, param2:int, param3:Number, param4:Vector.<IsoSortable>, param5:Vector.<IsoSortable>, param6:Boolean)
      {
         super();
         this.cuttedArea = param1;
         this.cutPosition = param2;
         this.weight = param3;
         this.isosortablesBeforeCut = param4;
         this.isosortablesAfterCut = param5;
         this.cutDirection = param6;
      }
      
      public function toString() : String
      {
         return "CutData[cut=" + this.cutPosition + ", weight=" + this.weight + ", down=" + this.cutDirection + "]";
      }
   }
}
