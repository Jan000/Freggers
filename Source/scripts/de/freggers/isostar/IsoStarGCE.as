package de.freggers.isostar
{
   public class IsoStarGCE
   {
       
      
      public var forceDirty:Boolean = false;
      
      public var isoSortable:IsoSortable;
      
      public function IsoStarGCE(param1:IsoSortable, param2:Boolean = false)
      {
         super();
         this.forceDirty = param2;
         this.isoSortable = param1;
      }
   }
}
