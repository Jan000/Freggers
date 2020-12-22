package flashx.textLayout.compose
{
   import flash.geom.Rectangle;
   import flashx.textLayout.container.ContainerController;
   
   public interface IParcelList
   {
       
      
      function beginCompose(param1:IFlowComposer, param2:int, param3:Boolean) : void;
      
      function get notifyOnParcelChange() : Function;
      
      function set notifyOnParcelChange(param1:Function) : void;
      
      function get left() : Number;
      
      function get right() : Number;
      
      function get top() : Number;
      
      function get bottom() : Number;
      
      function get width() : Number;
      
      function get height() : Number;
      
      function get columnIndex() : int;
      
      function get totalDepth() : Number;
      
      function addTotalDepth(param1:Number) : Number;
      
      function get controller() : ContainerController;
      
      function get currentParcel() : Parcel;
      
      function next() : Boolean;
      
      function atLast() : Boolean;
      
      function atEnd() : Boolean;
      
      function isColumnStart() : Boolean;
      
      function get explicitLineBreaks() : Boolean;
      
      function createParcel(param1:Rectangle, param2:String, param3:Boolean) : Boolean;
      
      function createParcelExperimental(param1:Rectangle, param2:String) : Boolean;
      
      function getLineSlug(param1:Rectangle, param2:Number, param3:Number = 0) : Boolean;
      
      function getComposeXCoord(param1:Rectangle) : Number;
      
      function getComposeYCoord(param1:Rectangle) : Number;
      
      function getComposeWidth(param1:Rectangle) : Number;
      
      function getComposeHeight(param1:Rectangle) : Number;
   }
}
