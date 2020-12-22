package de.freggers.roomlib
{
   import de.freggers.data.Level;
   import de.freggers.data.LevelBackground;
   
   public class Room
   {
       
      
      public var roomGui:String;
      
      public var roomContextLabel:String;
      
      public var desc:String;
      
      public var audioTrackID:Number = -1;
      
      public var soundConfig:Array;
      
      public var bg:LevelBackground;
      
      public var data:Level;
      
      public var topic:String;
      
      public var userOwnsRoom:Boolean;
      
      public var ownerUserId:int;
      
      public var ownerUserName:String;
      
      public var onBrightnessChange:Function = null;
      
      private var _wobID:uint;
      
      private var _brightness:int;
      
      public function Room(param1:uint)
      {
         super();
         this._wobID = param1;
      }
      
      public function get wobID() : uint
      {
         return this._wobID;
      }
      
      public function get brightness() : int
      {
         return this._brightness;
      }
      
      public function set brightness(param1:int) : void
      {
         var value:int = param1;
         if(value > 100)
         {
            value = 100;
         }
         else if(value < 0)
         {
            value = 0;
         }
         value = Math.round(value / 25) * 25;
         if(this._brightness != value)
         {
            this._brightness = value;
            if(this.onBrightnessChange != null)
            {
               try
               {
                  this.onBrightnessChange();
                  return;
               }
               catch(err:Error)
               {
                  return;
               }
            }
         }
      }
      
      public function get gui() : String
      {
         return this.roomGui.split(/\./)[1];
      }
      
      public function get contextLabel() : String
      {
         return this.roomContextLabel.split(/\./)[1];
      }
   }
}
