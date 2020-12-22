package de.freggers.roomdisplay
{
   import de.freggers.net.data.GhosttrailData;
   import flash.geom.Vector3D;
   
   public class ThrowData
   {
       
      
      public var sourcelocation:Vector3D;
      
      public var targetlocation:Vector3D;
      
      public var gui:String;
      
      public var ghosttrail:GhosttrailData = null;
      
      public var endeffect:EffectData = null;
      
      public var height:uint;
      
      public var duration:uint;
      
      public function ThrowData(param1:Vector3D, param2:Vector3D, param3:uint, param4:uint, param5:String, param6:GhosttrailData = null, param7:EffectData = null)
      {
         super();
         this.gui = param5;
         this.sourcelocation = param1;
         this.targetlocation = param2;
         this.height = param3;
         this.duration = param4;
         this.ghosttrail = param6;
         this.endeffect = param7;
      }
   }
}
