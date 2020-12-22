package de.freggers.isostar.grouping
{
   import de.freggers.isostar.IsoSortable;
   import flash.geom.Rectangle;
   
   public final class GroupData
   {
       
      
      public var area:Rectangle;
      
      public var isosortables:Vector.<IsoSortable>;
      
      public var subGroupData1:GroupData;
      
      public var subGroupData2:GroupData;
      
      public function GroupData(param1:Rectangle, param2:Vector.<IsoSortable>)
      {
         super();
         this.area = param1;
         this.isosortables = param2;
      }
   }
}
