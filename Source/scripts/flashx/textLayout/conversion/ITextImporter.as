package flashx.textLayout.conversion
{
   import flashx.textLayout.elements.TextFlow;
   
   public interface ITextImporter
   {
       
      
      function importToFlow(param1:Object) : TextFlow;
      
      function get errors() : Vector.<String>;
      
      function get throwOnError() : Boolean;
      
      function set throwOnError(param1:Boolean) : void;
   }
}
