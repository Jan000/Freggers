package de.freggers.net.data
{
   public interface IWOBStatus extends IWobData
   {
       
      
      function get sound() : SoundBlock;
      
      function get lightmap() : LightmapData;
      
      function get effect() : EffectData;
      
      function get ghostTrail() : GhosttrailData;
   }
}
