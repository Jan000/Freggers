package flashx.textLayout.conversion
{
   import flashx.textLayout.elements.IConfiguration;
   import flashx.textLayout.elements.TextFlow;
   
   public class TextConverter
   {
      
      public static const TEXT_FIELD_HTML_FORMAT:String = "textFieldHTMLFormat";
      
      public static const PLAIN_TEXT_FORMAT:String = "plainTextFormat";
      
      public static const TEXT_LAYOUT_FORMAT:String = "textLayoutFormat";
       
      
      public function TextConverter()
      {
         super();
      }
      
      public static function importToFlow(param1:Object, param2:String, param3:IConfiguration = null) : TextFlow
      {
         var _loc4_:ITextImporter = getImporter(param2,param3);
         return _loc4_.importToFlow(param1);
      }
      
      public static function export(param1:TextFlow, param2:String, param3:String) : Object
      {
         var _loc4_:ITextExporter = getExporter(param2);
         return _loc4_.export(param1,param3);
      }
      
      public static function getImporter(param1:String, param2:IConfiguration = null) : ITextImporter
      {
         switch(param1)
         {
            case TEXT_LAYOUT_FORMAT:
               return new TextLayoutImporter(param2);
            case PLAIN_TEXT_FORMAT:
               return new PlainTextImporter(param2);
            case TEXT_FIELD_HTML_FORMAT:
               return new HtmlImporter(param2);
            default:
               return null;
         }
      }
      
      public static function getExporter(param1:String) : ITextExporter
      {
         switch(param1)
         {
            case TEXT_LAYOUT_FORMAT:
               return new TextLayoutExporter();
            case PLAIN_TEXT_FORMAT:
               return new PlainTextExporter();
            case TEXT_FIELD_HTML_FORMAT:
               return new HtmlExporter();
            default:
               return null;
         }
      }
   }
}
