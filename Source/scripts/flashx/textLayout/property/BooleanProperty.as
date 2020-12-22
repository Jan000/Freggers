package flashx.textLayout.property
{
   import flashx.textLayout.formats.FormatValue;
   import flashx.textLayout.tlf_internal;
   
   use namespace tlf_internal;
   
   public class BooleanProperty extends Property
   {
       
      
      public function BooleanProperty(param1:String, param2:Boolean, param3:Boolean, param4:String)
      {
         super(param1,param2,param3,param4);
      }
      
      override public function setHelper(param1:*, param2:*) : *
      {
         if(param2 === null)
         {
            param2 = undefined;
         }
         if(param2 === undefined || param2 is Boolean || param2 == FormatValue.INHERIT)
         {
            return param2;
         }
         if(param2 == "true" || param2 == "false")
         {
            return param2 == "true";
         }
         Property.errorHandler(this,param2);
         return param1;
      }
      
      override public function hash(param1:Object, param2:uint) : uint
      {
         if(param1 == FormatValue.INHERIT)
         {
            return UintProperty.doHash(inheritHashValue,param2);
         }
         return UintProperty.doHash(!!(param1 as Boolean)?uint(1):uint(0),param2);
      }
   }
}
