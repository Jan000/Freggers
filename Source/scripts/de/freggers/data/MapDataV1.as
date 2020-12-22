package de.freggers.data
{
   public class MapDataV1 implements IMapData
   {
      
      public static const SPEED_BITS:int = 2;
      
      public static const TOPHEIGHT_BITS:int = 6;
      
      public static const TOPDIR_BITS:int = 4;
      
      public static const HEIGHT_BITS:int = 12;
      
      public static const SPEED_MAX:int = 3;
      
      public static const TOPHEIGHT_MAX:int = 63;
      
      public static const TOPDIR_MAX:int = 15;
      
      public static const HEIGHT_MAX:int = 4095;
      
      public static const SPEED_OFFSET:int = 0;
      
      public static const TOPHEIGHT_OFFSET:int = SPEED_OFFSET + SPEED_BITS;
      
      public static const TOPDIR_OFFSET:int = TOPHEIGHT_OFFSET + TOPHEIGHT_BITS;
      
      public static const HEIGHT_OFFSET:int = TOPDIR_OFFSET + TOPDIR_BITS;
       
      
      private var _data:int;
      
      public function MapDataV1(param1:int)
      {
         super();
         this._data = param1;
      }
      
      public function get data() : int
      {
         return this._data;
      }
      
      public function get speed() : int
      {
         return this._data & SPEED_MAX;
      }
      
      public function get topheight() : int
      {
         return this._data >> TOPHEIGHT_OFFSET & TOPHEIGHT_MAX;
      }
      
      public function get topdir() : int
      {
         return this._data >> TOPDIR_OFFSET & TOPDIR_MAX;
      }
      
      public function get height() : int
      {
         return this._data >> HEIGHT_OFFSET & HEIGHT_MAX;
      }
      
      public function toString() : String
      {
         return String(this.height);
      }
   }
}
