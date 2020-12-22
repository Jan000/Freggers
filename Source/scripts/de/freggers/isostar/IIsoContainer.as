package de.freggers.isostar
{
   import de.freggers.data.IMapData;
   import de.freggers.data.Level;
   import de.freggers.data.LevelBackground;
   import de.freggers.util.ICroppedBitmapDataContainer;
   import flash.geom.Point;
   
   public interface IIsoContainer
   {
       
      
      function get level() : Level;
      
      function get sprites() : Vector.<IsoSortable>;
      
      function get offset() : Point;
      
      function getLightAt(param1:int, param2:int) : uint;
      
      function removeLight(param1:IsoSprite) : void;
      
      function addLight(param1:IsoSprite) : void;
      
      function markLightDirty(param1:IsoSprite) : void;
      
      function addIsoLight(param1:IsoLight) : void;
      
      function removeIsoLight(param1:IsoLight) : void;
      
      function setDirty() : void;
      
      function getMask(param1:int, param2:int) : ICroppedBitmapDataContainer;
      
      function hasMasks() : Boolean;
      
      function getMapData(param1:int, param2:int, param3:int = 0) : IMapData;
      
      function getHeightAt(param1:int, param2:int) : int;
      
      function get background() : LevelBackground;
   }
}
