package
{
   import flash.display.MovieClip;
   
   public dynamic class WalkDest extends MovieClip
   {
       
      
      public function WalkDest()
      {
         super();
         addFrameScript(0,frame1,19,frame20);
      }
      
      function frame20() : *
      {
         gotoAndStop("init");
      }
      
      function frame1() : *
      {
         stop();
      }
   }
}
