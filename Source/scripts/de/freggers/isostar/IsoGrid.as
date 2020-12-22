package de.freggers.isostar
{
   import flash.geom.Point;
   import flash.geom.Vector3D;
   
   public class IsoGrid
   {
      
      public static const MODE_MAIN:int = 1000;
      
      public static const MODE_SUB:int = 1001;
      
      public static const CAMERA:Vector3D = new Vector3D(100000,100000,100000);
      
      public static const DIAGONAL_UNITS:Number = Math.sqrt(2 * upt * upt);
      
      public static const PIXELS_PER_DIAGONAL_UNIT:Number = tile_width / DIAGONAL_UNITS;
      
      public static const SIN30:Number = Math.sin(Math.PI / 6);
      
      public static const COS30:Number = Math.cos(Math.PI / 6);
      
      public static const COS45:Number = Math.cos(Math.PI / 4);
      
      public static const COS30xSQRT1_2:Number = COS30 * Math.SQRT1_2;
      
      private static const heightfactor:Number = 40 / 32;
      
      public static var upt:int = 16;
      
      public static var tile_width:int = 64;
      
      public static var tile_height:int = 32;
       
      
      public function IsoGrid()
      {
         super();
      }
      
      public static function main2sub(param1:Number, param2:Number, param3:Number = 0) : Vector3D
      {
         return new Vector3D(param1 * upt,param2 * upt,param3 * upt);
      }
      
      public static function sub2main(param1:Number, param2:Number, param3:Number = 0) : Vector3D
      {
         return new Vector3D(param1 / upt,param2 / upt,param3 / upt);
      }
      
      public static function height2units(param1:Number, param2:int = 1001) : Number
      {
         switch(param2)
         {
            case MODE_SUB:
               return Number(param1 * upt) / (Number(tile_height) * heightfactor);
            case MODE_MAIN:
               return Number(param1) / (Number(tile_height) * heightfactor);
            default:
               return 0;
         }
      }
      
      public static function units2height(param1:Number, param2:int = 1001) : Number
      {
         switch(param2)
         {
            case MODE_SUB:
               return Number(param1) * (Number(tile_height) * heightfactor / Number(upt));
            case MODE_MAIN:
               return param1 * tile_height * heightfactor;
            default:
               return 0;
         }
      }
      
      public static function xy(param1:Number, param2:Number, param3:Number, param4:int = 1001) : Point
      {
         var _loc5_:Vector3D = null;
         switch(param4)
         {
            case MODE_SUB:
               return new Point(uvztox(param1,param2,param3),uvztoy(param1,param2,param3));
            case MODE_MAIN:
               _loc5_ = main2sub(param1,param2,param3);
               return new Point(uvztox(_loc5_.x,_loc5_.y,_loc5_.z),uvztoy(_loc5_.x,_loc5_.y,_loc5_.z));
            default:
               return null;
         }
      }
      
      public static function dim(param1:Number, param2:Number, param3:int = 1001) : Point
      {
         var _loc4_:int = (param1 + param2) * tile_width / 2;
         var _loc5_:int = (param1 + param2) * tile_height / 2;
         if(param3 == MODE_SUB)
         {
            _loc4_ = _loc4_ / upt;
            _loc5_ = _loc5_ / upt;
         }
         return new Point(_loc4_,_loc5_);
      }
      
      public static function xyztouvz(param1:Number, param2:Number, param3:Number = 0, param4:int = 1001) : Vector3D
      {
         var _loc5_:Vector3D = new Vector3D(xyztou(param1,param2,param3),xyztov(param1,param2,param3),param3);
         switch(param4)
         {
            case MODE_SUB:
               return _loc5_;
            case MODE_MAIN:
               return sub2main(_loc5_.x,_loc5_.y,_loc5_.z);
            default:
               return null;
         }
      }
      
      public static function distance(param1:Vector3D) : Number
      {
         return -1 * Math.sqrt(Math.pow(CAMERA.x - param1.x,2) + Math.pow(CAMERA.y - param1.y,2) + Math.pow(CAMERA.z - param1.z,2));
      }
      
      public static function perspectiveScale(param1:Number, param2:Number, param3:Number) : Number
      {
         return 0.75;
      }
      
      public static function depth(param1:Number = 0, param2:Number = 0, param3:Number = 0) : Number
      {
         return param1 + param2;
      }
      
      public static function xyztou(param1:Number, param2:Number, param3:Number) : Number
      {
         return upt * (param2 / tile_height + param1 / tile_width) + param3 * heightfactor;
      }
      
      public static function xyztov(param1:Number, param2:Number, param3:Number) : Number
      {
         return upt * (param2 / tile_height - param1 / tile_width) + param3 * heightfactor;
      }
      
      public static function uvztox(param1:Number, param2:Number, param3:Number) : Number
      {
         return (param1 - param2) * tile_width / (2 * upt);
      }
      
      public static function uvztoy(param1:Number, param2:Number, param3:Number) : Number
      {
         return (param1 + param2) * tile_height / (2 * upt) - param3 * tile_height * heightfactor / upt;
      }
   }
}
