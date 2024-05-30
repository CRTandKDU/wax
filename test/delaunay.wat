;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; delaunay                             ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Compiled by WAXC (Version May 30 2024);;

(module 
(import "jmc" "div" (func $wax::js::console.log (param i32) (param i32)))
(import "Math" "log"    (func $log   (param f32) (result f32)))
(import "Math" "exp"    (func $exp   (param f32) (result f32)))
(import "Math" "cos"    (func $cos   (param f32) (result f32)))
(import "Math" "sin"    (func $sin   (param f32) (result f32)))
(import "Math" "tan"    (func $tan   (param f32) (result f32)))
(import "Math" "cosh"   (func $cosh  (param f32) (result f32)))
(import "Math" "sinh"   (func $sinh  (param f32) (result f32)))
(import "Math" "tanh"   (func $tanh  (param f32) (result f32)))
(import "Math" "acos"   (func $acos  (param f32) (result f32)))
(import "Math" "asin"   (func $asin  (param f32) (result f32)))
(import "Math" "atan2"  (func $atan2 (param f32) (param  f32) (result f32)))
(import "Math" "pow"    (func $pow   (param f32) (param  f32) (result f32)))
(import "Math" "random" (func $random            (result f32)))

(func $fmax (param $x f32) (param $y f32) (result f32) (f32.max (local.get $x) (local.get $y)))
(func $fmin (param $x f32) (param $y f32) (result f32) (f32.min (local.get $x) (local.get $y)))
(func $fabs (param $x f32) (result f32) (f32.abs (local.get $x)))
(func $floor (param $x f32) (result f32) (f32.floor (local.get $x)))
(func $ceil (param $x f32) (result f32) (f32.ceil (local.get $x)))
(func $sqrt (param $x f32) (result f32) (f32.sqrt (local.get $x)))
(func $round (param $x f32) (result f32) (f32.nearest (local.get $x)))

(func $abs (param $x i32) (result i32)
  (if (i32.lt_s (local.get $x) (i32.const 0))(then
      (i32.sub (i32.const 0) (local.get $x))
      return
  ))
  (local.get $x)
)

(global $INFINITY f32 (f32.const 340282346638528859811704183484516925440))

;;=== User Code            BEGIN ===;;
  (func $circumcircle (export "circumcircle") (param $xp f32) (param $yp f32) (param $x1 f32) (param $y1 f32) (param $x2 f32) (param $y2 f32) (param $x3 f32) (param $y3 f32) (param $xcycr i32) (result i32)
    (local $rsqr f32)
    (local $fabsy1y2 f32)
    (local $fabsy2y3 f32)
    (local $yc f32)
    (local $xc f32)
    (local $m1 f32)
    (local $dx f32)
    (local $dy f32)
    (local $m2 f32)
    (local $tmp___4b f32)
    (local $tmp___4c f32)
    (local $tmp___4a f32)
    (local $mx1 f32)
    (local $my1 f32)
    (local $my2 f32)
    (local $drsqr f32)
    (local $tmp___4d i32)
    (local $mx2 f32)
    (local $tmp___4e f32)
    (local $tmp___0e__s181 f32)
    (local $tmp___1f__s183 f32)
    (local $tmp___2b__s184 f32)
    (local $tmp___3c__s184 i32)
    (local $tmp___0d__s181 f32)
    (local $tmp___2c__s184 f32)
    (local $tmp___3b__s184 f32)
    (local $tmp___1d__s183 f32)
    (local $tmp___3a__s184 f32)
    (local $tmp___0f__s181 f32)
    (local $tmp___1e__s183 f32)
    (local $tmp___2a__s184 f32)
    (local $tmp___0a__s181 f32)
    (local $tmp___1b__s183 f32)
    (local $tmp___2f__s184 f32)
    (local $tmp___3f__s185 f32)
    (local $tmp___1c__s183 f32)
    (local $tmp___0c__s181 f32)
    (local $tmp___2d__s184 f32)
    (local $tmp___3d__s185 f32)
    (local $tmp___0b__s181 f32)
    (local $tmp___1a__s183 f32)
    (local $tmp___2e__s184 f32)
    (local $tmp___3e__s185 f32)
    (local $tmp___07 i32)
    (local $tmp___43 f32)
    (local $tmp___04 i32)
    (local $tmp___28__s184 f32)
    (local $tmp___39__s184 f32)
    (local $tmp___05 i32)
    (local $tmp___29__s184 f32)
    (local $tmp___38__s184 f32)
    (local $tmp___02 f32)
    (local $tmp___46 f32)
    (local $tmp___09__s181 f32)
    (local $tmp___03 f32)
    (local $tmp___47 f32)
    (local $tmp___08__s181 f32)
    (local $tmp___00 f32)
    (local $tmp___44 f32)
    (local $tmp___18__s183 f32)
    (local $tmp___01 f32)
    (local $tmp___45 f32)
    (local $tmp___19__s183 f32)
    (local $tmp___14__s181 f32)
    (local $tmp___16__s183 f32)
    (local $tmp___33__s184 f32)
    (local $tmp___17__s183 f32)
    (local $tmp___23__s184 f32)
    (local $tmp___32__s184 f32)
    (local $tmp___48 f32)
    (local $tmp___06__s180 i32)
    (local $tmp___15__s182 i32)
    (local $tmp___31__s184 f32)
    (local $tmp___49 f32)
    (local $tmp___30__s184 f32)
    (local $tmp___10__s181 f32)
    (local $tmp___21__s183 f32)
    (local $tmp___26__s184 f32)
    (local $tmp___37__s184 f32)
    (local $tmp___42__s186 f32)
    (local $tmp___11__s181 f32)
    (local $tmp___20__s183 f32)
    (local $tmp___27__s184 f32)
    (local $tmp___36__s184 f32)
    (local $tmp___12__s181 f32)
    (local $tmp___24__s184 f32)
    (local $tmp___35__s184 f32)
    (local $tmp___40__s186 f32)
    (local $tmp___13__s181 f32)
    (local $tmp___22__s183 f32)
    (local $tmp___25__s184 f32)
    (local $tmp___34__s184 f32)
    (local $tmp___41__s186 f32)
    

    (call $wax::push_stack)
    
    
    
    
    
    
    
    
    
    
    
    
    (local.set $tmp___01 (f32.sub (local.get $y1) (local.get $y2)))
    (local.set $tmp___00 (call $fabs (local.get $tmp___01)))
    (local.set $fabsy1y2 (local.get $tmp___00))
    
    
    
    (local.set $tmp___03 (f32.sub (local.get $y2) (local.get $y3)))
    (local.set $tmp___02 (call $fabs (local.get $tmp___03)))
    (local.set $fabsy2y3 (local.get $tmp___02))
    
    
    
    
    
    (local.set $tmp___05 (f32.lt (local.get $fabsy1y2) (f32.const 0.0000001)))
    (if (local.get $tmp___05) (then
      
      (local.set $tmp___06__s180 (f32.lt (local.get $fabsy2y3) (f32.const 0.0000001)))
      (local.set $tmp___05 (local.get $tmp___06__s180))
    ))
    (local.set $tmp___04 (i32.ne (local.get $tmp___05) (i32.const 0)))
    (if (local.get $tmp___04) (then
      (call $wax::pop_stack)
      (i32.const 0)
      return
    ))
    
    (local.set $tmp___07 (f32.lt (local.get $fabsy1y2) (f32.const 0.0000001)))
    (if (local.get $tmp___07) (then
      
      
      
      (local.set $tmp___0a__s181 (f32.sub (local.get $x3) (local.get $x2)))
      
      (local.set $tmp___0b__s181 (f32.sub (local.get $y3) (local.get $y2)))
      (local.set $tmp___09__s181 (f32.div (local.get $tmp___0a__s181) (local.get $tmp___0b__s181)))
      (local.set $tmp___08__s181 (f32.sub (f32.const 0.0) (local.get $tmp___09__s181)))
      (local.set $m2 (local.get $tmp___08__s181))
      
      
      (local.set $tmp___0d__s181 (f32.add (local.get $x2) (local.get $x3)))
      (local.set $tmp___0c__s181 (f32.div (local.get $tmp___0d__s181) (f32.const 2.0)))
      (local.set $mx2 (local.get $tmp___0c__s181))
      
      
      (local.set $tmp___0f__s181 (f32.add (local.get $y2) (local.get $y3)))
      (local.set $tmp___0e__s181 (f32.div (local.get $tmp___0f__s181) (f32.const 2.0)))
      (local.set $my2 (local.get $tmp___0e__s181))
      
      
      (local.set $tmp___11__s181 (f32.add (local.get $x2) (local.get $x1)))
      (local.set $tmp___10__s181 (f32.div (local.get $tmp___11__s181) (f32.const 2.0)))
      (local.set $xc (local.get $tmp___10__s181))
      
      
      
      (local.set $tmp___14__s181 (f32.sub (local.get $xc) (local.get $mx2)))
      (local.set $tmp___13__s181 (f32.mul (local.get $m2) (local.get $tmp___14__s181)))
      (local.set $tmp___12__s181 (f32.add (local.get $tmp___13__s181) (local.get $my2)))
      (local.set $yc (local.get $tmp___12__s181))
    )(else
      
      (local.set $tmp___15__s182 (f32.lt (local.get $fabsy2y3) (f32.const 0.0000001)))
      (if (local.get $tmp___15__s182) (then
        
        
        
        (local.set $tmp___18__s183 (f32.sub (local.get $x2) (local.get $x1)))
        
        (local.set $tmp___19__s183 (f32.sub (local.get $y2) (local.get $y1)))
        (local.set $tmp___17__s183 (f32.div (local.get $tmp___18__s183) (local.get $tmp___19__s183)))
        (local.set $tmp___16__s183 (f32.sub (f32.const 0.0) (local.get $tmp___17__s183)))
        (local.set $m1 (local.get $tmp___16__s183))
        
        
        (local.set $tmp___1b__s183 (f32.add (local.get $x1) (local.get $x2)))
        (local.set $tmp___1a__s183 (f32.div (local.get $tmp___1b__s183) (f32.const 2.0)))
        (local.set $mx1 (local.get $tmp___1a__s183))
        
        
        (local.set $tmp___1d__s183 (f32.add (local.get $y1) (local.get $y2)))
        (local.set $tmp___1c__s183 (f32.div (local.get $tmp___1d__s183) (f32.const 2.0)))
        (local.set $my1 (local.get $tmp___1c__s183))
        
        
        (local.set $tmp___1f__s183 (f32.add (local.get $x3) (local.get $x2)))
        (local.set $tmp___1e__s183 (f32.div (local.get $tmp___1f__s183) (f32.const 2.0)))
        (local.set $xc (local.get $tmp___1e__s183))
        
        
        
        (local.set $tmp___22__s183 (f32.sub (local.get $xc) (local.get $mx1)))
        (local.set $tmp___21__s183 (f32.mul (local.get $m1) (local.get $tmp___22__s183)))
        (local.set $tmp___20__s183 (f32.add (local.get $tmp___21__s183) (local.get $my1)))
        (local.set $yc (local.get $tmp___20__s183))
      )(else
        
        
        
        (local.set $tmp___25__s184 (f32.sub (local.get $x2) (local.get $x1)))
        
        (local.set $tmp___26__s184 (f32.sub (local.get $y2) (local.get $y1)))
        (local.set $tmp___24__s184 (f32.div (local.get $tmp___25__s184) (local.get $tmp___26__s184)))
        (local.set $tmp___23__s184 (f32.sub (f32.const 0.0) (local.get $tmp___24__s184)))
        (local.set $m1 (local.get $tmp___23__s184))
        
        
        
        (local.set $tmp___29__s184 (f32.sub (local.get $x3) (local.get $x2)))
        
        (local.set $tmp___2a__s184 (f32.sub (local.get $y3) (local.get $y2)))
        (local.set $tmp___28__s184 (f32.div (local.get $tmp___29__s184) (local.get $tmp___2a__s184)))
        (local.set $tmp___27__s184 (f32.sub (f32.const 0.0) (local.get $tmp___28__s184)))
        (local.set $m2 (local.get $tmp___27__s184))
        
        
        (local.set $tmp___2c__s184 (f32.add (local.get $x1) (local.get $x2)))
        (local.set $tmp___2b__s184 (f32.div (local.get $tmp___2c__s184) (f32.const 2.0)))
        (local.set $mx1 (local.get $tmp___2b__s184))
        
        
        (local.set $tmp___2e__s184 (f32.add (local.get $x2) (local.get $x3)))
        (local.set $tmp___2d__s184 (f32.div (local.get $tmp___2e__s184) (f32.const 2.0)))
        (local.set $mx2 (local.get $tmp___2d__s184))
        
        
        (local.set $tmp___30__s184 (f32.add (local.get $y1) (local.get $y2)))
        (local.set $tmp___2f__s184 (f32.div (local.get $tmp___30__s184) (f32.const 2.0)))
        (local.set $my1 (local.get $tmp___2f__s184))
        
        
        (local.set $tmp___32__s184 (f32.add (local.get $y2) (local.get $y3)))
        (local.set $tmp___31__s184 (f32.div (local.get $tmp___32__s184) (f32.const 2.0)))
        (local.set $my2 (local.get $tmp___31__s184))
        
        
        
        
        
        (local.set $tmp___37__s184 (f32.mul (local.get $m1) (local.get $mx1)))
        
        
        (local.set $tmp___39__s184 (f32.mul (local.get $m2) (local.get $mx2)))
        (local.set $tmp___38__s184 (f32.sub (f32.const 0.0) (local.get $tmp___39__s184)))
        (local.set $tmp___36__s184 (f32.add (local.get $tmp___37__s184) (local.get $tmp___38__s184)))
        (local.set $tmp___35__s184 (f32.add (local.get $tmp___36__s184) (local.get $my2)))
        
        (local.set $tmp___3a__s184 (f32.sub (f32.const 0.0) (local.get $my1)))
        (local.set $tmp___34__s184 (f32.add (local.get $tmp___35__s184) (local.get $tmp___3a__s184)))
        
        (local.set $tmp___3b__s184 (f32.sub (local.get $m1) (local.get $m2)))
        (local.set $tmp___33__s184 (f32.div (local.get $tmp___34__s184) (local.get $tmp___3b__s184)))
        (local.set $xc (local.get $tmp___33__s184))
        
        (local.set $tmp___3c__s184 (f32.gt (local.get $fabsy1y2) (local.get $fabsy2y3)))
        (if (local.get $tmp___3c__s184) (then
          
          
          
          (local.set $tmp___3f__s185 (f32.sub (local.get $xc) (local.get $mx1)))
          (local.set $tmp___3e__s185 (f32.mul (local.get $m1) (local.get $tmp___3f__s185)))
          (local.set $tmp___3d__s185 (f32.add (local.get $tmp___3e__s185) (local.get $my1)))
          (local.set $yc (local.get $tmp___3d__s185))
        )(else
          
          
          
          (local.set $tmp___42__s186 (f32.sub (local.get $xc) (local.get $mx2)))
          (local.set $tmp___41__s186 (f32.mul (local.get $m2) (local.get $tmp___42__s186)))
          (local.set $tmp___40__s186 (f32.add (local.get $tmp___41__s186) (local.get $my2)))
          (local.set $yc (local.get $tmp___40__s186))
        ))
      ))
    ))
    
    (local.set $tmp___43 (f32.sub (local.get $x2) (local.get $xc)))
    (local.set $dx (local.get $tmp___43))
    
    (local.set $tmp___44 (f32.sub (local.get $y2) (local.get $yc)))
    (local.set $dy (local.get $tmp___44))
    
    
    (local.set $tmp___46 (f32.mul (local.get $dx) (local.get $dx)))
    
    (local.set $tmp___47 (f32.mul (local.get $dy) (local.get $dy)))
    (local.set $tmp___45 (f32.add (local.get $tmp___46) (local.get $tmp___47)))
    (local.set $rsqr (local.get $tmp___45))
    
    (local.set $tmp___48 (f32.sub (local.get $xp) (local.get $xc)))
    (local.set $dx (local.get $tmp___48))
    
    (local.set $tmp___49 (f32.sub (local.get $yp) (local.get $yc)))
    (local.set $dy (local.get $tmp___49))
    
    
    (local.set $tmp___4b (f32.mul (local.get $dx) (local.get $dx)))
    
    (local.set $tmp___4c (f32.mul (local.get $dy) (local.get $dy)))
    (local.set $tmp___4a (f32.add (local.get $tmp___4b) (local.get $tmp___4c)))
    (local.set $drsqr (local.get $tmp___4a))
    (f32.store (i32.add (local.get $xcycr) (i32.mul (i32.const 0) (i32.const 4)))(local.get $xc))
    (f32.store (i32.add (local.get $xcycr) (i32.mul (i32.const 1) (i32.const 4)))(local.get $yc))
    (f32.store (i32.add (local.get $xcycr) (i32.mul (i32.const 2) (i32.const 4)))(local.get $rsqr))
    
    
    (local.set $tmp___4e (f32.sub (local.get $drsqr) (local.get $rsqr)))
    (local.set $tmp___4d (f32.le (local.get $tmp___4e) (f32.const 0.0000001)))
    (call $wax::pop_stack)
    (local.get $tmp___4d)
    return
    (call $wax::pop_stack)
  )
  (func $delaunaytriangulate (export "delaunaytriangulate") (param $pxyz i32) (result i32)
    (local $tmp___11b__s1a6 i32)
    (local $tmp___11c__s1a7 i32)
    (local $tmp___11a__s1a6 i32)
    (local $tmp___10b__s1a2 i32)
    (local $tmp___10d__s1a4 i32)
    (local $tmp___10c__s1a2 i32)
    (local $tmp___10e__s1a4 i32)
    (local $tmp___11d__s1a4 i32)
    (local $tmp___10f__s1a4 i32)
    (local $xp f32)
    (local $y1 f32)
    (local $yp f32)
    (local $x1 f32)
    (local $complete i32)
    (local $tmp___10a__s18e i32)
    (local $x2 f32)
    (local $y3 f32)
    (local $y2 f32)
    (local $x3 f32)
    (local $xmax f32)
    (local $ymax f32)
    (local $dmax f32)
    (local $tmp___105__s1a1 i32)
    (local $tmp___111__s1a4 i32)
    (local $tmp___104__s1a1 i32)
    (local $tmp___110__s1a4 i32)
    (local $xmin f32)
    (local $xc__s192 f32)
    (local $tmp___108__s19f i32)
    (local $tmp___107__s1a1 i32)
    (local $tmp___113__s1a4 i32)
    (local $ymin f32)
    (local $tmp___109__s19f i32)
    (local $tmp___106__s1a1 i32)
    (local $tmp___112__s1a4 i32)
    (local $tmp___100__s1a0 i32)
    (local $tmp___101__s1a1 i32)
    (local $tmp___114__s1a4 i32)
    (local $tmp___115__s1a5 i32)
    (local $tmp___103__s1a1 i32)
    (local $tmp___116__s1a5 i32)
    (local $tmp___102__s1a1 i32)
    (local $tmp___117__s1a5 i32)
    (local $nv i32)
    (local $xmid f32)
    (local $ymid f32)
    (local $tmp___118__s1a4 i32)
    (local $tmp___119__s1a6 i32)
    (local $inside i32)
    (local $dx f32)
    (local $dy f32)
    (local $tmp___7a f32)
    (local $tmp___5a__s188 i32)
    (local $tmp___6b__s188 f32)
    (local $tmp___68__s18b f32)
    (local $tmp___90__s18e f32)
    (local $tmp___93__s18f i32)
    (local $tmp___9f__s192 i32)
    (local $tmp___6c__s188 i32)
    (local $tmp___69__s18b i32)
    (local $tmp___91__s18e i32)
    (local $j__s190 i32)
    (local $tmp___7c i32)
    (local $tmp___5c__s188 f32)
    (local $tmp___92__s18e i32)
    (local $tmp___9d__s192 f32)
    (local $tmp___c8__s194 i32)
    (local $tmp___7b i32)
    (local $tmp___5b__s188 i32)
    (local $tmp___6a__s188 i32)
    (local $tmp___9e__s192 i32)
    (local $tmp___c9__s194 i32)
    (local $tmp___d3__s199 i32)
    (local $tmp___4f i32)
    (local $tmp___7e f32)
    (local $i__s187 i32)
    (local $tmp___6f__s188 i32)
    (local $tmp___9b__s192 i32)
    (local $tmp___b8__s193 f32)
    (local $j__s195 i32)
    (local $tmp___d4__s199 i32)
    (local $tmp___e5__s199 i32)
    (local $tmp___7d f32)
    (local $tmp___5d__s188 i32)
    (local $tmp___5e__s189 f32)
    (local $tmp___9c__s192 i32)
    (local $tmp___b9__s193 f32)
    (local $tmp___d5__s199 i32)
    (local $tmp___ff__s1a0 i32)
    (local $tmp___5f__s189 i32)
    (local $tmp___a8__s192 i32)
    (local $tmp___d6__s199 i32)
    (local $tmp___e7__s199 i32)
    (local $tmp___f4__s199 i32)
    (local $tmp___fe__s1a0 i32)
    (local $tmp___7f f32)
    (local $tmp___94__s18f i32)
    (local $tmp___9a__s192 i32)
    (local $tmp___a9__s192 f32)
    (local $tmp___d7__s199 i32)
    (local $tmp___e6__s199 i32)
    (local $tmp___63__s18a f32)
    (local $tmp___a6__s192 i32)
    (local $tmp___b5__s192 i32)
    (local $tmp___c2__s194 i32)
    (local $tmp___f5__s196 i32)
    (local $k__s198 i32)
    (local $tmp___d8__s199 i32)
    (local $tmp___e9__s199 i32)
    (local $tmp___ec__s19c i32)
    (local $tmp___a7__s192 i32)
    (local $tmp___b4__s192 i32)
    (local $tmp___c3__s194 i32)
    (local $tmp___d9__s199 i32)
    (local $tmp___e8__s199 i32)
    (local $tmp___eb__s19c i32)
    (local $tmp___fd__s19f i32)
    (local $tmp___a4__s192 i32)
    (local $tmp___b6__s193 i32)
    (local $tmp___c0__s194 i32)
    (local $tmp___a5__s192 f32)
    (local $tmp___b7__s193 f32)
    (local $tmp___c1__s194 i32)
    (local $tmp___dc__s19a i32)
    (local $tmp___8b i32)
    (local $tmp___a2__s192 i32)
    (local $tmp___b1__s192 i32)
    (local $tmp___c6__s194 i32)
    (local $tmp___d2__s197 i32)
    (local $tmp___dd__s19a i32)
    (local $tmp___fa__s19f i32)
    (local $tmp___a3__s192 i32)
    (local $tmp___b0__s192 i32)
    (local $tmp___c7__s194 i32)
    (local $tmp___de__s19a i32)
    (local $tmp___ef__s19c i32)
    (local $tmp___a0__s192 i32)
    (local $tmp___b3__s192 f32)
    (local $tmp___c4__s194 i32)
    (local $tmp___d1__s196 i32)
    (local $tmp___df__s19a i32)
    (local $tmp___ee__s19c i32)
    (local $tmp___fc__s19f i32)
    (local $tmp___8a i32)
    (local $tmp___64__s18a i32)
    (local $edges__s18e i32)
    (local $tmp___a1__s192 f32)
    (local $tmp___b2__s192 f32)
    (local $tmp___c5__s194 i32)
    (local $tmp___d0__s196 i32)
    (local $tmp___ed__s19c i32)
    (local $tmp___fb__s19f i32)
    (local $tmp___53 i32)
    (local $tmp___71 f32)
    (local $tmp___62__s188 i32)
    (local $tmp___95__s191 i32)
    (local $tmp___ea__s199 i32)
    (local $tmp___52 i32)
    (local $tmp___70 f32)
    (local $tmp___da__s199 i32)
    (local $tmp___51 i32)
    (local $tmp___73 i32)
    (local $tmp___60__s188 i32)
    (local $tmp___8c__s18e i32)
    (local $tmp___97__s191 i32)
    (local $tmp___db__s199 i32)
    (local $xcycr i32)
    (local $tmp___50 i32)
    (local $tmp___72 f32)
    (local $tmp___61__s188 f32)
    (local $tmp___96__s191 i32)
    (local $tmp___57 f32)
    (local $tmp___75 f32)
    (local $tmp___66__s188 f32)
    (local $tmp___8e__s18e f32)
    (local $j__s19e i32)
    (local $tmp___f9__s19f i32)
    (local $tmp___56 i32)
    (local $tmp___74 f32)
    (local $tmp___67__s188 i32)
    (local $tmp___8d__s18e i32)
    (local $tmp___f8__s19f i32)
    (local $v i32)
    (local $tmp___55 f32)
    (local $tmp___77 f32)
    (local $tmp___88 f32)
    (local $tmp___54 i32)
    (local $tmp___76 f32)
    (local $tmp___89 i32)
    (local $tmp___65__s188 i32)
    (local $i__s18d i32)
    (local $tmp___8f__s18e i32)
    (local $tmp___79 f32)
    (local $tmp___86 f32)
    (local $tmp___59__s188 i32)
    (local $tmp___af__s192 i32)
    (local $tmp___bc__s194 i32)
    (local $tmp___cb__s194 i32)
    (local $tmp___e2__s19b i32)
    (local $tmp___78 f32)
    (local $tmp___87 f32)
    (local $tmp___bb__s194 i32)
    (local $tmp___cc__s194 i32)
    (local $tmp___e0__s19a i32)
    (local $tmp___e3__s19b i32)
    (local $i__s1a3 i32)
    (local $tmp___84 i32)
    (local $tmp___ad__s192 f32)
    (local $tmp___ba__s194 i32)
    (local $tmp___f7__s19f i32)
    (local $tmp___58 i32)
    (local $tmp___85 i32)
    (local $tmp___cd__s191 i32)
    (local $r__s192 f32)
    (local $tmp___ae__s192 i32)
    (local $tmp___ca__s194 i32)
    (local $tmp___e1__s19b i32)
    (local $tmp___f6__s19f i32)
    (local $tmp___82 f32)
    (local $tmp___6e__s18c i32)
    (local $tmp___ab__s192 i32)
    (local $tmp___f3__s19d i32)
    (local $tmp___83 f32)
    (local $tmp___6d__s18c f32)
    (local $tmp___98__s191 i32)
    (local $tmp___ac__s192 i32)
    (local $tmp___bf__s194 i32)
    (local $tmp___ce__s196 i32)
    (local $tmp___f2__s19d i32)
    (local $tmp___80 i32)
    (local $tmp___be__s194 i32)
    (local $tmp___cf__s196 i32)
    (local $tmp___e4__s19b i32)
    (local $tmp___f1__s19d i32)
    (local $tmp___81 i32)
    (local $tmp___99__s192 f32)
    (local $tmp___aa__s192 i32)
    (local $tmp___bd__s194 i32)
    (local $tmp___f0__s19d i32)
    

    (call $wax::push_stack)
    
    
    (local.set $tmp___4f (call $wax::arr_length (local.get $pxyz)))
    (local.set $nv (local.get $tmp___4f))
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    (local.set $tmp___50 (call $wax::calloc (i32.mul (i32.const 4) (i32.const 12))))
    (local.set $xcycr (local.get $tmp___50))
    
    
    (local.set $tmp___51 (call $wax::arr_new (i32.const 0)))
    (local.set $complete (local.get $tmp___51))
    
    
    (local.set $tmp___52 (call $wax::arr_new (i32.const 0)))
    (local.set $v (local.get $tmp___52))
    
    
    (local.set $tmp___54 (call $wax::arr_length (local.get $pxyz)))
    (local.set $tmp___53 (i32.lt_s (local.get $tmp___54) (i32.const 3)))
    (if (local.get $tmp___53) (then
      (call $wax::arr_free (local.get $complete))
      (call $wax::free (local.get $xcycr))
      (call $wax::pop_stack)
      (local.get $v)
      return
    ))
    
    
    (local.set $tmp___56 (call $wax::arr_get (local.get $pxyz) (i32.const 0)))
    (local.set $tmp___55 (f32.load (i32.add (local.get $tmp___56) (i32.mul (i32.const 0) (i32.const 4)))))
    (local.set $xmin (local.get $tmp___55))
    
    
    (local.set $tmp___58 (call $wax::arr_get (local.get $pxyz) (i32.const 0)))
    (local.set $tmp___57 (f32.load (i32.add (local.get $tmp___58) (i32.mul (i32.const 1) (i32.const 4)))))
    (local.set $ymin (local.get $tmp___57))
    (local.set $xmax (local.get $xmin))
    (local.set $ymax (local.get $ymin))
    (if (i32.const 1) (then
      
      (local.set $i__s187 (i32.const 1))
      block $tmp__block_0000000000B5B170
      loop $tmp__lp_1b7
        (if (i32.const 1) (then
        
          (call $wax::push_stack)
          
          
          (local.set $tmp___5a__s188 (i32.lt_s (local.get $i__s187) (local.get $nv)))
          (local.set $tmp___59__s188 (local.get $tmp___5a__s188))
          (if (local.get $tmp___59__s188) (then
          
          )(else
            (call $wax::pop_stack)
            (br $tmp__block_0000000000B5B170)
          ))
          
          
          
          (local.set $tmp___5d__s188 (call $wax::arr_get (local.get $pxyz) (local.get $i__s187)))
          (local.set $tmp___5c__s188 (f32.load (i32.add (local.get $tmp___5d__s188) (i32.mul (i32.const 0) (i32.const 4)))))
          (local.set $tmp___5b__s188 (f32.lt (local.get $tmp___5c__s188) (local.get $xmin)))
          (if (local.get $tmp___5b__s188) (then
            
            
            (local.set $tmp___5f__s189 (call $wax::arr_get (local.get $pxyz) (local.get $i__s187)))
            (local.set $tmp___5e__s189 (f32.load (i32.add (local.get $tmp___5f__s189) (i32.mul (i32.const 0) (i32.const 4)))))
            (local.set $xmin (local.get $tmp___5e__s189))
          ))
          
          
          
          (local.set $tmp___62__s188 (call $wax::arr_get (local.get $pxyz) (local.get $i__s187)))
          (local.set $tmp___61__s188 (f32.load (i32.add (local.get $tmp___62__s188) (i32.mul (i32.const 0) (i32.const 4)))))
          (local.set $tmp___60__s188 (f32.gt (local.get $tmp___61__s188) (local.get $xmax)))
          (if (local.get $tmp___60__s188) (then
            
            
            (local.set $tmp___64__s18a (call $wax::arr_get (local.get $pxyz) (local.get $i__s187)))
            (local.set $tmp___63__s18a (f32.load (i32.add (local.get $tmp___64__s18a) (i32.mul (i32.const 0) (i32.const 4)))))
            (local.set $xmax (local.get $tmp___63__s18a))
          ))
          
          
          
          (local.set $tmp___67__s188 (call $wax::arr_get (local.get $pxyz) (local.get $i__s187)))
          (local.set $tmp___66__s188 (f32.load (i32.add (local.get $tmp___67__s188) (i32.mul (i32.const 1) (i32.const 4)))))
          (local.set $tmp___65__s188 (f32.lt (local.get $tmp___66__s188) (local.get $ymin)))
          (if (local.get $tmp___65__s188) (then
            
            
            (local.set $tmp___69__s18b (call $wax::arr_get (local.get $pxyz) (local.get $i__s187)))
            (local.set $tmp___68__s18b (f32.load (i32.add (local.get $tmp___69__s18b) (i32.mul (i32.const 1) (i32.const 4)))))
            (local.set $ymin (local.get $tmp___68__s18b))
          ))
          
          
          
          (local.set $tmp___6c__s188 (call $wax::arr_get (local.get $pxyz) (local.get $i__s187)))
          (local.set $tmp___6b__s188 (f32.load (i32.add (local.get $tmp___6c__s188) (i32.mul (i32.const 1) (i32.const 4)))))
          (local.set $tmp___6a__s188 (f32.gt (local.get $tmp___6b__s188) (local.get $ymax)))
          (if (local.get $tmp___6a__s188) (then
            
            
            (local.set $tmp___6e__s18c (call $wax::arr_get (local.get $pxyz) (local.get $i__s187)))
            (local.set $tmp___6d__s18c (f32.load (i32.add (local.get $tmp___6e__s18c) (i32.mul (i32.const 1) (i32.const 4)))))
            (local.set $ymax (local.get $tmp___6d__s18c))
          ))
          
          (local.set $tmp___6f__s188 (i32.add (local.get $i__s187) (i32.const 1)))
          (local.set $i__s187 (local.get $tmp___6f__s188))
          (call $wax::pop_stack)

          (br $tmp__lp_1b7)
        ))
      end
      end
    ))
    
    (local.set $tmp___70 (f32.sub (local.get $xmax) (local.get $xmin)))
    (local.set $dx (local.get $tmp___70))
    
    (local.set $tmp___71 (f32.sub (local.get $ymax) (local.get $ymin)))
    (local.set $dy (local.get $tmp___71))
    
    
    (local.set $tmp___73 (f32.gt (local.get $dx) (local.get $dy)))
    
    (if (local.get $tmp___73) (then
      (local.set $tmp___74 (local.get $dx))
    )(else
      (local.set $tmp___74 (local.get $dy))
    ))
    (local.set $tmp___72 (local.get $tmp___74))
    (local.set $dmax (local.get $tmp___72))
    
    
    (local.set $tmp___76 (f32.add (local.get $xmax) (local.get $xmin)))
    
    (local.set $tmp___77 (f32.convert_i32_s (i32.const 2)))
    (local.set $tmp___75 (f32.div (local.get $tmp___76) (local.get $tmp___77)))
    (local.set $xmid (local.get $tmp___75))
    
    
    (local.set $tmp___79 (f32.add (local.get $ymax) (local.get $ymin)))
    
    (local.set $tmp___7a (f32.convert_i32_s (i32.const 2)))
    (local.set $tmp___78 (f32.div (local.get $tmp___79) (local.get $tmp___7a)))
    (local.set $ymid (local.get $tmp___78))
    
    (local.set $tmp___7b (call $wax::arr_length (local.get $pxyz)))
    
    
    
    (local.set $tmp___7e (f32.mul (f32.const 2.0) (local.get $dmax)))
    (local.set $tmp___7d (f32.sub (local.get $xmid) (local.get $tmp___7e)))
    
    (local.set $tmp___7f (f32.sub (local.get $ymid) (local.get $dmax)))
    (local.set $tmp___7c (call $w__vec_lit2 (i32.reinterpret_f32 (local.get $tmp___7d)) (i32.reinterpret_f32 (local.get $tmp___7f))))
    (call $wax::arr_insert (local.get $pxyz) (local.get $tmp___7b) (local.get $tmp___7c))
    
    (local.set $tmp___80 (call $wax::arr_length (local.get $pxyz)))
    
    
    
    (local.set $tmp___83 (f32.mul (f32.const 2.0) (local.get $dmax)))
    (local.set $tmp___82 (f32.add (local.get $ymid) (local.get $tmp___83)))
    (local.set $tmp___81 (call $w__vec_lit2 (i32.reinterpret_f32 (local.get $xmid)) (i32.reinterpret_f32 (local.get $tmp___82))))
    (call $wax::arr_insert (local.get $pxyz) (local.get $tmp___80) (local.get $tmp___81))
    
    (local.set $tmp___84 (call $wax::arr_length (local.get $pxyz)))
    
    
    
    (local.set $tmp___87 (f32.mul (f32.const 2.0) (local.get $dmax)))
    (local.set $tmp___86 (f32.add (local.get $xmid) (local.get $tmp___87)))
    
    (local.set $tmp___88 (f32.sub (local.get $ymid) (local.get $dmax)))
    (local.set $tmp___85 (call $w__vec_lit2 (i32.reinterpret_f32 (local.get $tmp___86)) (i32.reinterpret_f32 (local.get $tmp___88))))
    (call $wax::arr_insert (local.get $pxyz) (local.get $tmp___84) (local.get $tmp___85))
    
    
    (local.set $tmp___8a (i32.add (local.get $nv) (i32.const 1)))
    
    (local.set $tmp___8b (i32.add (local.get $nv) (i32.const 2)))
    (local.set $tmp___89 (call $w__vec_lit3 (local.get $nv) (local.get $tmp___8a) (local.get $tmp___8b)))
    (call $wax::arr_insert (local.get $v) (i32.const 0) (local.get $tmp___89))
    (call $wax::arr_insert (local.get $complete) (i32.const 0) (i32.const 0))
    (if (i32.const 1) (then
      
      (local.set $i__s18d (i32.const 0))
      block $tmp__block_0000000000B800D0
      loop $tmp__lp_1b8
        (if (i32.const 1) (then
        
          (call $wax::push_stack)
          
          
          (local.set $tmp___8d__s18e (i32.lt_s (local.get $i__s18d) (local.get $nv)))
          (local.set $tmp___8c__s18e (local.get $tmp___8d__s18e))
          (if (local.get $tmp___8c__s18e) (then
          
          )(else
            (call $wax::pop_stack)
            (br $tmp__block_0000000000B800D0)
          ))
          
          
          (local.set $tmp___8f__s18e (call $wax::arr_get (local.get $pxyz) (local.get $i__s18d)))
          (local.set $tmp___8e__s18e (f32.load (i32.add (local.get $tmp___8f__s18e) (i32.mul (i32.const 0) (i32.const 4)))))
          (local.set $xp (local.get $tmp___8e__s18e))
          
          
          (local.set $tmp___91__s18e (call $wax::arr_get (local.get $pxyz) (local.get $i__s18d)))
          (local.set $tmp___90__s18e (f32.load (i32.add (local.get $tmp___91__s18e) (i32.mul (i32.const 1) (i32.const 4)))))
          (local.set $yp (local.get $tmp___90__s18e))
          
          
          (local.set $tmp___92__s18e (call $wax::arr_new (i32.const 0)))
          (local.set $edges__s18e (local.get $tmp___92__s18e))
          (if (i32.const 1) (then
            
            
            
            (local.set $tmp___94__s18f (call $wax::arr_length (local.get $v)))
            (local.set $tmp___93__s18f (i32.sub (local.get $tmp___94__s18f) (i32.const 1)))
            (local.set $j__s190 (local.get $tmp___93__s18f))
            block $tmp__block_0000000000B8EB80
            loop $tmp__lp_1b9
              (if (i32.const 1) (then
              
                (call $wax::push_stack)
                
                
                (local.set $tmp___96__s191 (i32.ge_s (local.get $j__s190) (i32.const 0)))
                (local.set $tmp___95__s191 (local.get $tmp___96__s191))
                (if (local.get $tmp___95__s191) (then
                
                )(else
                  (call $wax::pop_stack)
                  (br $tmp__block_0000000000B8EB80)
                ))
                
                
                (local.set $tmp___98__s191 (call $wax::arr_get (local.get $complete) (local.get $j__s190)))
                (local.set $tmp___97__s191 (i32.eqz (local.get $tmp___98__s191)))
                (if (local.get $tmp___97__s191) (then
                  
                  
                  
                  
                  (local.set $tmp___9c__s192 (call $wax::arr_get (local.get $v) (local.get $j__s190)))
                  (local.set $tmp___9b__s192 (i32.load (i32.add (local.get $tmp___9c__s192) (i32.mul (i32.const 0) (i32.const 4)))))
                  (local.set $tmp___9a__s192 (call $wax::arr_get (local.get $pxyz) (local.get $tmp___9b__s192)))
                  (local.set $tmp___99__s192 (f32.load (i32.add (local.get $tmp___9a__s192) (i32.mul (i32.const 0) (i32.const 4)))))
                  (local.set $x1 (local.get $tmp___99__s192))
                  
                  
                  
                  
                  (local.set $tmp___a0__s192 (call $wax::arr_get (local.get $v) (local.get $j__s190)))
                  (local.set $tmp___9f__s192 (i32.load (i32.add (local.get $tmp___a0__s192) (i32.mul (i32.const 0) (i32.const 4)))))
                  (local.set $tmp___9e__s192 (call $wax::arr_get (local.get $pxyz) (local.get $tmp___9f__s192)))
                  (local.set $tmp___9d__s192 (f32.load (i32.add (local.get $tmp___9e__s192) (i32.mul (i32.const 1) (i32.const 4)))))
                  (local.set $y1 (local.get $tmp___9d__s192))
                  
                  
                  
                  
                  (local.set $tmp___a4__s192 (call $wax::arr_get (local.get $v) (local.get $j__s190)))
                  (local.set $tmp___a3__s192 (i32.load (i32.add (local.get $tmp___a4__s192) (i32.mul (i32.const 1) (i32.const 4)))))
                  (local.set $tmp___a2__s192 (call $wax::arr_get (local.get $pxyz) (local.get $tmp___a3__s192)))
                  (local.set $tmp___a1__s192 (f32.load (i32.add (local.get $tmp___a2__s192) (i32.mul (i32.const 0) (i32.const 4)))))
                  (local.set $x2 (local.get $tmp___a1__s192))
                  
                  
                  
                  
                  (local.set $tmp___a8__s192 (call $wax::arr_get (local.get $v) (local.get $j__s190)))
                  (local.set $tmp___a7__s192 (i32.load (i32.add (local.get $tmp___a8__s192) (i32.mul (i32.const 1) (i32.const 4)))))
                  (local.set $tmp___a6__s192 (call $wax::arr_get (local.get $pxyz) (local.get $tmp___a7__s192)))
                  (local.set $tmp___a5__s192 (f32.load (i32.add (local.get $tmp___a6__s192) (i32.mul (i32.const 1) (i32.const 4)))))
                  (local.set $y2 (local.get $tmp___a5__s192))
                  
                  
                  
                  
                  (local.set $tmp___ac__s192 (call $wax::arr_get (local.get $v) (local.get $j__s190)))
                  (local.set $tmp___ab__s192 (i32.load (i32.add (local.get $tmp___ac__s192) (i32.mul (i32.const 2) (i32.const 4)))))
                  (local.set $tmp___aa__s192 (call $wax::arr_get (local.get $pxyz) (local.get $tmp___ab__s192)))
                  (local.set $tmp___a9__s192 (f32.load (i32.add (local.get $tmp___aa__s192) (i32.mul (i32.const 0) (i32.const 4)))))
                  (local.set $x3 (local.get $tmp___a9__s192))
                  
                  
                  
                  
                  (local.set $tmp___b0__s192 (call $wax::arr_get (local.get $v) (local.get $j__s190)))
                  (local.set $tmp___af__s192 (i32.load (i32.add (local.get $tmp___b0__s192) (i32.mul (i32.const 2) (i32.const 4)))))
                  (local.set $tmp___ae__s192 (call $wax::arr_get (local.get $pxyz) (local.get $tmp___af__s192)))
                  (local.set $tmp___ad__s192 (f32.load (i32.add (local.get $tmp___ae__s192) (i32.mul (i32.const 1) (i32.const 4)))))
                  (local.set $y3 (local.get $tmp___ad__s192))
                  
                  (local.set $tmp___b1__s192 (call $circumcircle (local.get $xp) (local.get $yp) (local.get $x1) (local.get $y1) (local.get $x2) (local.get $y2) (local.get $x3) (local.get $y3) (local.get $xcycr)))
                  (local.set $inside (local.get $tmp___b1__s192))
                  
                  
                  (local.set $tmp___b2__s192 (f32.load (i32.add (local.get $xcycr) (i32.mul (i32.const 0) (i32.const 4)))))
                  (local.set $xc__s192 (local.get $tmp___b2__s192))
                  
                  
                  (local.set $tmp___b3__s192 (f32.load (i32.add (local.get $xcycr) (i32.mul (i32.const 2) (i32.const 4)))))
                  (local.set $r__s192 (local.get $tmp___b3__s192))
                  
                  
                  (local.set $tmp___b5__s192 (f32.lt (local.get $xc__s192) (local.get $xp)))
                  (if (local.get $tmp___b5__s192) (then
                    
                    
                    
                    (local.set $tmp___b8__s193 (f32.sub (local.get $xp) (local.get $xc__s192)))
                    
                    (local.set $tmp___b9__s193 (f32.sub (local.get $xp) (local.get $xc__s192)))
                    (local.set $tmp___b7__s193 (f32.mul (local.get $tmp___b8__s193) (local.get $tmp___b9__s193)))
                    (local.set $tmp___b6__s193 (f32.gt (local.get $tmp___b7__s193) (local.get $r__s192)))
                    (local.set $tmp___b5__s192 (local.get $tmp___b6__s193))
                  ))
                  (local.set $tmp___b4__s192 (i32.ne (local.get $tmp___b5__s192) (i32.const 0)))
                  (if (local.get $tmp___b4__s192) (then
                    (call $wax::arr_set (local.get $complete) (local.get $j__s190) (i32.const 1))
                  ))
                  (if (local.get $inside) (then
                    
                    (local.set $tmp___ba__s194 (call $wax::arr_length (local.get $edges__s18e)))
                    
                    
                    
                    (local.set $tmp___bd__s194 (call $wax::arr_get (local.get $v) (local.get $j__s190)))
                    (local.set $tmp___bc__s194 (i32.load (i32.add (local.get $tmp___bd__s194) (i32.mul (i32.const 0) (i32.const 4)))))
                    
                    
                    (local.set $tmp___bf__s194 (call $wax::arr_get (local.get $v) (local.get $j__s190)))
                    (local.set $tmp___be__s194 (i32.load (i32.add (local.get $tmp___bf__s194) (i32.mul (i32.const 1) (i32.const 4)))))
                    (local.set $tmp___bb__s194 (call $w__vec_lit2 (local.get $tmp___bc__s194) (local.get $tmp___be__s194)))
                    (call $wax::arr_insert (local.get $edges__s18e) (local.get $tmp___ba__s194) (local.get $tmp___bb__s194))
                    
                    (local.set $tmp___c0__s194 (call $wax::arr_length (local.get $edges__s18e)))
                    
                    
                    
                    (local.set $tmp___c3__s194 (call $wax::arr_get (local.get $v) (local.get $j__s190)))
                    (local.set $tmp___c2__s194 (i32.load (i32.add (local.get $tmp___c3__s194) (i32.mul (i32.const 1) (i32.const 4)))))
                    
                    
                    (local.set $tmp___c5__s194 (call $wax::arr_get (local.get $v) (local.get $j__s190)))
                    (local.set $tmp___c4__s194 (i32.load (i32.add (local.get $tmp___c5__s194) (i32.mul (i32.const 2) (i32.const 4)))))
                    (local.set $tmp___c1__s194 (call $w__vec_lit2 (local.get $tmp___c2__s194) (local.get $tmp___c4__s194)))
                    (call $wax::arr_insert (local.get $edges__s18e) (local.get $tmp___c0__s194) (local.get $tmp___c1__s194))
                    
                    (local.set $tmp___c6__s194 (call $wax::arr_length (local.get $edges__s18e)))
                    
                    
                    
                    (local.set $tmp___c9__s194 (call $wax::arr_get (local.get $v) (local.get $j__s190)))
                    (local.set $tmp___c8__s194 (i32.load (i32.add (local.get $tmp___c9__s194) (i32.mul (i32.const 2) (i32.const 4)))))
                    
                    
                    (local.set $tmp___cb__s194 (call $wax::arr_get (local.get $v) (local.get $j__s190)))
                    (local.set $tmp___ca__s194 (i32.load (i32.add (local.get $tmp___cb__s194) (i32.mul (i32.const 0) (i32.const 4)))))
                    (local.set $tmp___c7__s194 (call $w__vec_lit2 (local.get $tmp___c8__s194) (local.get $tmp___ca__s194)))
                    (call $wax::arr_insert (local.get $edges__s18e) (local.get $tmp___c6__s194) (local.get $tmp___c7__s194))
                    
                    (local.set $tmp___cc__s194 (call $wax::arr_get (local.get $v) (local.get $j__s190)))
                    (call $wax::free (local.get $tmp___cc__s194))
                    (call $wax::arr_remove (local.get $v) (local.get $j__s190) (i32.const 1))
                    (call $wax::arr_remove (local.get $complete) (local.get $j__s190) (i32.const 1))
                  ))
                ))
                
                (local.set $tmp___cd__s191 (i32.add (local.get $j__s190) (i32.const -1)))
                (local.set $j__s190 (local.get $tmp___cd__s191))
                (call $wax::pop_stack)

                (br $tmp__lp_1b9)
              ))
            end
            end
          ))
          (if (i32.const 1) (then
            
            (local.set $j__s195 (i32.const 0))
            block $tmp__block_0000000000BB2F10
            loop $tmp__lp_1ba
              (if (i32.const 1) (then
              
                (call $wax::push_stack)
                
                
                
                
                (local.set $tmp___d1__s196 (call $wax::arr_length (local.get $edges__s18e)))
                (local.set $tmp___d0__s196 (i32.sub (local.get $tmp___d1__s196) (i32.const 1)))
                (local.set $tmp___cf__s196 (i32.lt_s (local.get $j__s195) (local.get $tmp___d0__s196)))
                (local.set $tmp___ce__s196 (local.get $tmp___cf__s196))
                (if (local.get $tmp___ce__s196) (then
                
                )(else
                  (call $wax::pop_stack)
                  (br $tmp__block_0000000000BB2F10)
                ))
                (if (i32.const 1) (then
                  
                  
                  (local.set $tmp___d2__s197 (i32.add (local.get $j__s195) (i32.const 1)))
                  (local.set $k__s198 (local.get $tmp___d2__s197))
                  block $tmp__block_0000000000BAFF90
                  loop $tmp__lp_1bb
                    (if (i32.const 1) (then
                    
                      (call $wax::push_stack)
                      
                      
                      
                      (local.set $tmp___d5__s199 (call $wax::arr_length (local.get $edges__s18e)))
                      (local.set $tmp___d4__s199 (i32.lt_s (local.get $k__s198) (local.get $tmp___d5__s199)))
                      (local.set $tmp___d3__s199 (local.get $tmp___d4__s199))
                      (if (local.get $tmp___d3__s199) (then
                      
                      )(else
                        (call $wax::pop_stack)
                        (br $tmp__block_0000000000BAFF90)
                      ))
                      
                      
                      
                      
                      (local.set $tmp___d9__s199 (call $wax::arr_get (local.get $edges__s18e) (local.get $j__s195)))
                      (local.set $tmp___d8__s199 (i32.load (i32.add (local.get $tmp___d9__s199) (i32.mul (i32.const 0) (i32.const 4)))))
                      
                      
                      (local.set $tmp___db__s199 (call $wax::arr_get (local.get $edges__s18e) (local.get $k__s198)))
                      (local.set $tmp___da__s199 (i32.load (i32.add (local.get $tmp___db__s199) (i32.mul (i32.const 1) (i32.const 4)))))
                      (local.set $tmp___d7__s199 (i32.eq (local.get $tmp___d8__s199) (local.get $tmp___da__s199)))
                      (if (local.get $tmp___d7__s199) (then
                        
                        
                        
                        (local.set $tmp___de__s19a (call $wax::arr_get (local.get $edges__s18e) (local.get $j__s195)))
                        (local.set $tmp___dd__s19a (i32.load (i32.add (local.get $tmp___de__s19a) (i32.mul (i32.const 1) (i32.const 4)))))
                        
                        
                        (local.set $tmp___e0__s19a (call $wax::arr_get (local.get $edges__s18e) (local.get $k__s198)))
                        (local.set $tmp___df__s19a (i32.load (i32.add (local.get $tmp___e0__s19a) (i32.mul (i32.const 0) (i32.const 4)))))
                        (local.set $tmp___dc__s19a (i32.eq (local.get $tmp___dd__s19a) (local.get $tmp___df__s19a)))
                        (local.set $tmp___d7__s199 (local.get $tmp___dc__s19a))
                      ))
                      (local.set $tmp___d6__s199 (i32.ne (local.get $tmp___d7__s199) (i32.const 0)))
                      (if (local.get $tmp___d6__s199) (then
                        
                        (local.set $tmp___e1__s19b (call $wax::arr_get (local.get $edges__s18e) (local.get $j__s195)))
                        (i32.store (i32.add (local.get $tmp___e1__s19b) (i32.mul (i32.const 0) (i32.const 4)))(i32.const -1))
                        
                        (local.set $tmp___e2__s19b (call $wax::arr_get (local.get $edges__s18e) (local.get $j__s195)))
                        (i32.store (i32.add (local.get $tmp___e2__s19b) (i32.mul (i32.const 1) (i32.const 4)))(i32.const -1))
                        
                        (local.set $tmp___e3__s19b (call $wax::arr_get (local.get $edges__s18e) (local.get $k__s198)))
                        (i32.store (i32.add (local.get $tmp___e3__s19b) (i32.mul (i32.const 0) (i32.const 4)))(i32.const -1))
                        
                        (local.set $tmp___e4__s19b (call $wax::arr_get (local.get $edges__s18e) (local.get $k__s198)))
                        (i32.store (i32.add (local.get $tmp___e4__s19b) (i32.mul (i32.const 1) (i32.const 4)))(i32.const -1))
                      ))
                      
                      
                      
                      
                      (local.set $tmp___e8__s199 (call $wax::arr_get (local.get $edges__s18e) (local.get $j__s195)))
                      (local.set $tmp___e7__s199 (i32.load (i32.add (local.get $tmp___e8__s199) (i32.mul (i32.const 0) (i32.const 4)))))
                      
                      
                      (local.set $tmp___ea__s199 (call $wax::arr_get (local.get $edges__s18e) (local.get $k__s198)))
                      (local.set $tmp___e9__s199 (i32.load (i32.add (local.get $tmp___ea__s199) (i32.mul (i32.const 0) (i32.const 4)))))
                      (local.set $tmp___e6__s199 (i32.eq (local.get $tmp___e7__s199) (local.get $tmp___e9__s199)))
                      (if (local.get $tmp___e6__s199) (then
                        
                        
                        
                        (local.set $tmp___ed__s19c (call $wax::arr_get (local.get $edges__s18e) (local.get $j__s195)))
                        (local.set $tmp___ec__s19c (i32.load (i32.add (local.get $tmp___ed__s19c) (i32.mul (i32.const 1) (i32.const 4)))))
                        
                        
                        (local.set $tmp___ef__s19c (call $wax::arr_get (local.get $edges__s18e) (local.get $k__s198)))
                        (local.set $tmp___ee__s19c (i32.load (i32.add (local.get $tmp___ef__s19c) (i32.mul (i32.const 1) (i32.const 4)))))
                        (local.set $tmp___eb__s19c (i32.eq (local.get $tmp___ec__s19c) (local.get $tmp___ee__s19c)))
                        (local.set $tmp___e6__s199 (local.get $tmp___eb__s19c))
                      ))
                      (local.set $tmp___e5__s199 (i32.ne (local.get $tmp___e6__s199) (i32.const 0)))
                      (if (local.get $tmp___e5__s199) (then
                        
                        (local.set $tmp___f0__s19d (call $wax::arr_get (local.get $edges__s18e) (local.get $j__s195)))
                        (i32.store (i32.add (local.get $tmp___f0__s19d) (i32.mul (i32.const 0) (i32.const 4)))(i32.const -1))
                        
                        (local.set $tmp___f1__s19d (call $wax::arr_get (local.get $edges__s18e) (local.get $j__s195)))
                        (i32.store (i32.add (local.get $tmp___f1__s19d) (i32.mul (i32.const 1) (i32.const 4)))(i32.const -1))
                        
                        (local.set $tmp___f2__s19d (call $wax::arr_get (local.get $edges__s18e) (local.get $k__s198)))
                        (i32.store (i32.add (local.get $tmp___f2__s19d) (i32.mul (i32.const 0) (i32.const 4)))(i32.const -1))
                        
                        (local.set $tmp___f3__s19d (call $wax::arr_get (local.get $edges__s18e) (local.get $k__s198)))
                        (i32.store (i32.add (local.get $tmp___f3__s19d) (i32.mul (i32.const 1) (i32.const 4)))(i32.const -1))
                      ))
                      
                      (local.set $tmp___f4__s199 (i32.add (local.get $k__s198) (i32.const 1)))
                      (local.set $k__s198 (local.get $tmp___f4__s199))
                      (call $wax::pop_stack)

                      (br $tmp__lp_1bb)
                    ))
                  end
                  end
                ))
                
                (local.set $tmp___f5__s196 (i32.add (local.get $j__s195) (i32.const 1)))
                (local.set $j__s195 (local.get $tmp___f5__s196))
                (call $wax::pop_stack)

                (br $tmp__lp_1ba)
              ))
            end
            end
          ))
          (if (i32.const 1) (then
            
            (local.set $j__s19e (i32.const 0))
            block $tmp__block_0000000000BCEF80
            loop $tmp__lp_1bc
              (if (i32.const 1) (then
              
                (call $wax::push_stack)
                
                
                
                (local.set $tmp___f8__s19f (call $wax::arr_length (local.get $edges__s18e)))
                (local.set $tmp___f7__s19f (i32.lt_s (local.get $j__s19e) (local.get $tmp___f8__s19f)))
                (local.set $tmp___f6__s19f (local.get $tmp___f7__s19f))
                (if (local.get $tmp___f6__s19f) (then
                
                )(else
                  (call $wax::pop_stack)
                  (br $tmp__block_0000000000BCEF80)
                ))
                
                
                
                
                (local.set $tmp___fc__s19f (call $wax::arr_get (local.get $edges__s18e) (local.get $j__s19e)))
                (local.set $tmp___fb__s19f (i32.load (i32.add (local.get $tmp___fc__s19f) (i32.mul (i32.const 0) (i32.const 4)))))
                (local.set $tmp___fa__s19f (i32.lt_s (local.get $tmp___fb__s19f) (i32.const 0)))
                
                (local.set $tmp___fd__s19f (i32.eq (local.get $tmp___fa__s19f) (i32.const 0)))
                (if (local.get $tmp___fd__s19f) (then
                  
                  
                  
                  (local.set $tmp___100__s1a0 (call $wax::arr_get (local.get $edges__s18e) (local.get $j__s19e)))
                  (local.set $tmp___ff__s1a0 (i32.load (i32.add (local.get $tmp___100__s1a0) (i32.mul (i32.const 1) (i32.const 4)))))
                  (local.set $tmp___fe__s1a0 (i32.lt_s (local.get $tmp___ff__s1a0) (i32.const 0)))
                  (local.set $tmp___fa__s19f (local.get $tmp___fe__s1a0))
                ))
                (local.set $tmp___f9__s19f (i32.ne (local.get $tmp___fa__s19f) (i32.const 0)))
                (if (local.get $tmp___f9__s19f) (then
                
                )(else
                  
                  (local.set $tmp___101__s1a1 (call $wax::arr_length (local.get $v)))
                  
                  
                  
                  (local.set $tmp___104__s1a1 (call $wax::arr_get (local.get $edges__s18e) (local.get $j__s19e)))
                  (local.set $tmp___103__s1a1 (i32.load (i32.add (local.get $tmp___104__s1a1) (i32.mul (i32.const 0) (i32.const 4)))))
                  
                  
                  (local.set $tmp___106__s1a1 (call $wax::arr_get (local.get $edges__s18e) (local.get $j__s19e)))
                  (local.set $tmp___105__s1a1 (i32.load (i32.add (local.get $tmp___106__s1a1) (i32.mul (i32.const 1) (i32.const 4)))))
                  (local.set $tmp___102__s1a1 (call $w__vec_lit3 (local.get $tmp___103__s1a1) (local.get $tmp___105__s1a1) (local.get $i__s18d)))
                  (call $wax::arr_insert (local.get $v) (local.get $tmp___101__s1a1) (local.get $tmp___102__s1a1))
                  
                  (local.set $tmp___107__s1a1 (call $wax::arr_length (local.get $complete)))
                  (call $wax::arr_insert (local.get $complete) (local.get $tmp___107__s1a1) (i32.const 0))
                ))
                
                (local.set $tmp___108__s19f (call $wax::arr_get (local.get $edges__s18e) (local.get $j__s19e)))
                (call $wax::free (local.get $tmp___108__s19f))
                
                (local.set $tmp___109__s19f (i32.add (local.get $j__s19e) (i32.const 1)))
                (local.set $j__s19e (local.get $tmp___109__s19f))
                (call $wax::pop_stack)

                (br $tmp__lp_1bc)
              ))
            end
            end
          ))
          (call $wax::arr_free (local.get $edges__s18e))
          
          (local.set $tmp___10a__s18e (i32.add (local.get $i__s18d) (i32.const 1)))
          (local.set $i__s18d (local.get $tmp___10a__s18e))
          (call $wax::pop_stack)

          (br $tmp__lp_1b8)
        ))
      end
      end
    ))
    (if (i32.const 1) (then
      
      
      
      (local.set $tmp___10c__s1a2 (call $wax::arr_length (local.get $v)))
      (local.set $tmp___10b__s1a2 (i32.sub (local.get $tmp___10c__s1a2) (i32.const 1)))
      (local.set $i__s1a3 (local.get $tmp___10b__s1a2))
      block $tmp__block_0000000000BD2880
      loop $tmp__lp_1bd
        (if (i32.const 1) (then
        
          (call $wax::push_stack)
          
          
          (local.set $tmp___10e__s1a4 (i32.ge_s (local.get $i__s1a3) (i32.const 0)))
          (local.set $tmp___10d__s1a4 (local.get $tmp___10e__s1a4))
          (if (local.get $tmp___10d__s1a4) (then
          
          )(else
            (call $wax::pop_stack)
            (br $tmp__block_0000000000BD2880)
          ))
          
          
          
          
          
          (local.set $tmp___113__s1a4 (call $wax::arr_get (local.get $v) (local.get $i__s1a3)))
          (local.set $tmp___112__s1a4 (i32.load (i32.add (local.get $tmp___113__s1a4) (i32.mul (i32.const 0) (i32.const 4)))))
          (local.set $tmp___111__s1a4 (i32.ge_s (local.get $tmp___112__s1a4) (local.get $nv)))
          
          (local.set $tmp___114__s1a4 (i32.eq (local.get $tmp___111__s1a4) (i32.const 0)))
          (if (local.get $tmp___114__s1a4) (then
            
            
            
            (local.set $tmp___117__s1a5 (call $wax::arr_get (local.get $v) (local.get $i__s1a3)))
            (local.set $tmp___116__s1a5 (i32.load (i32.add (local.get $tmp___117__s1a5) (i32.mul (i32.const 1) (i32.const 4)))))
            (local.set $tmp___115__s1a5 (i32.ge_s (local.get $tmp___116__s1a5) (local.get $nv)))
            (local.set $tmp___111__s1a4 (local.get $tmp___115__s1a5))
          ))
          (local.set $tmp___110__s1a4 (i32.ne (local.get $tmp___111__s1a4) (i32.const 0)))
          
          (local.set $tmp___118__s1a4 (i32.eq (local.get $tmp___110__s1a4) (i32.const 0)))
          (if (local.get $tmp___118__s1a4) (then
            
            
            
            (local.set $tmp___11b__s1a6 (call $wax::arr_get (local.get $v) (local.get $i__s1a3)))
            (local.set $tmp___11a__s1a6 (i32.load (i32.add (local.get $tmp___11b__s1a6) (i32.mul (i32.const 0) (i32.const 4)))))
            (local.set $tmp___119__s1a6 (i32.ge_s (local.get $tmp___11a__s1a6) (local.get $nv)))
            (local.set $tmp___110__s1a4 (local.get $tmp___119__s1a6))
          ))
          (local.set $tmp___10f__s1a4 (i32.ne (local.get $tmp___110__s1a4) (i32.const 0)))
          (if (local.get $tmp___10f__s1a4) (then
            
            (local.set $tmp___11c__s1a7 (call $wax::arr_get (local.get $v) (local.get $i__s1a3)))
            (call $wax::free (local.get $tmp___11c__s1a7))
            (call $wax::arr_remove (local.get $v) (local.get $i__s1a3) (i32.const 1))
          ))
          
          (local.set $tmp___11d__s1a4 (i32.add (local.get $i__s1a3) (i32.const -1)))
          (local.set $i__s1a3 (local.get $tmp___11d__s1a4))
          (call $wax::pop_stack)

          (br $tmp__lp_1bd)
        ))
      end
      end
    ))
    (call $wax::arr_free (local.get $complete))
    (call $wax::free (local.get $xcycr))
    (call $wax::pop_stack)
    (local.get $v)
    return
    (call $wax::pop_stack)
  )
  (func $comparex (export "comparex") (param $v1 i32) (param $v2 i32) (result i32)
    (local $tmp___120 f32)
    (local $tmp___11f f32)
    (local $tmp___11e i32)
    (local $tmp___122__s1a8 f32)
    (local $tmp___123__s1a8 f32)
    (local $tmp___121__s1a8 i32)
    

    (call $wax::push_stack)
    
    
    (local.set $tmp___11f (f32.load (i32.add (local.get $v1) (i32.mul (i32.const 0) (i32.const 4)))))
    
    (local.set $tmp___120 (f32.load (i32.add (local.get $v2) (i32.mul (i32.const 0) (i32.const 4)))))
    (local.set $tmp___11e (f32.lt (local.get $tmp___11f) (local.get $tmp___120)))
    (if (local.get $tmp___11e) (then
      (call $wax::pop_stack)
      (i32.const -1)
      return
    )(else
      
      
      (local.set $tmp___122__s1a8 (f32.load (i32.add (local.get $v1) (i32.mul (i32.const 0) (i32.const 4)))))
      
      (local.set $tmp___123__s1a8 (f32.load (i32.add (local.get $v2) (i32.mul (i32.const 0) (i32.const 4)))))
      (local.set $tmp___121__s1a8 (f32.gt (local.get $tmp___122__s1a8) (local.get $tmp___123__s1a8)))
      (if (local.get $tmp___121__s1a8) (then
        (call $wax::pop_stack)
        (i32.const 1)
        return
      ))
    ))
    (call $wax::pop_stack)
    (i32.const 0)
    return
    (call $wax::pop_stack)
  )
  (func $sortbyx (export "sortbyx") (param $A i32) (param $lo i32) (param $hi i32)
    (local $tmp___125 i32)
    (local $tmp___134__s1ac i32)
    (local $tmp___124 i32)
    (local $tmp___135__s1ac i32)
    (local $tmp___136__s1ac i32)
    (local $tmp___131__s1ab i32)
    (local $tmp___130__s1ab i32)
    (local $tmp___133__s1ac i32)
    (local $tmp___129__s1aa i32)
    (local $tmp___128__s1aa i32)
    (local $tmp___12d__s1ab i32)
    (local $tmp___12e__s1ab i32)
    (local $tmp___12f__s1ab i32)
    (local $tmp___12c__s1aa i32)
    (local $tmp___12b__s1aa i32)
    (local $tmp___12a__s1aa i32)
    (local $tmp___127__s1a9 i32)
    (local $tmp___126__s1a9 i32)
    (local $left i32)
    (local $tmp___132__s1a9 i32)
    (local $right i32)
    (local $tmp__s1ac i32)
    (local $pivot i32)
    

    (call $wax::push_stack)
    
    (local.set $tmp___124 (i32.ge_s (local.get $lo) (local.get $hi)))
    (if (local.get $tmp___124) (then
      (call $wax::pop_stack)
      
      return
    ))
    
    
    (local.set $tmp___125 (call $wax::arr_get (local.get $A) (local.get $lo)))
    (local.set $pivot (local.get $tmp___125))
    
    (local.set $left (local.get $lo))
    
    (local.set $right (local.get $hi))
    block $tmp__block_0000000000BF99D0
    loop $tmp__lp_1be
      (if (i32.const 1) (then
      
        (call $wax::push_stack)
        
        
        (local.set $tmp___127__s1a9 (i32.le_s (local.get $left) (local.get $right)))
        (local.set $tmp___126__s1a9 (local.get $tmp___127__s1a9))
        (if (local.get $tmp___126__s1a9) (then
        
        )(else
          (call $wax::pop_stack)
          (br $tmp__block_0000000000BF99D0)
        ))
        block $tmp__block_0000000000BFACD0
        loop $tmp__lp_1bf
          (if (i32.const 1) (then
          
            (call $wax::push_stack)
            
            
            
            
            (local.set $tmp___12b__s1aa (call $wax::arr_get (local.get $A) (local.get $left)))
            (local.set $tmp___12a__s1aa (call $comparex (local.get $tmp___12b__s1aa) (local.get $pivot)))
            (local.set $tmp___129__s1aa (i32.lt_s (local.get $tmp___12a__s1aa) (i32.const 0)))
            (local.set $tmp___128__s1aa (local.get $tmp___129__s1aa))
            (if (local.get $tmp___128__s1aa) (then
            
            )(else
              (call $wax::pop_stack)
              (br $tmp__block_0000000000BFACD0)
            ))
            
            (local.set $tmp___12c__s1aa (i32.add (local.get $left) (i32.const 1)))
            (local.set $left (local.get $tmp___12c__s1aa))
            (call $wax::pop_stack)

            (br $tmp__lp_1bf)
          ))
        end
        end
        block $tmp__block_0000000000BF3AD0
        loop $tmp__lp_1c0
          (if (i32.const 1) (then
          
            (call $wax::push_stack)
            
            
            
            
            (local.set $tmp___130__s1ab (call $wax::arr_get (local.get $A) (local.get $right)))
            (local.set $tmp___12f__s1ab (call $comparex (local.get $tmp___130__s1ab) (local.get $pivot)))
            (local.set $tmp___12e__s1ab (i32.gt_s (local.get $tmp___12f__s1ab) (i32.const 0)))
            (local.set $tmp___12d__s1ab (local.get $tmp___12e__s1ab))
            (if (local.get $tmp___12d__s1ab) (then
            
            )(else
              (call $wax::pop_stack)
              (br $tmp__block_0000000000BF3AD0)
            ))
            
            (local.set $tmp___131__s1ab (i32.sub (local.get $right) (i32.const 1)))
            (local.set $right (local.get $tmp___131__s1ab))
            (call $wax::pop_stack)

            (br $tmp__lp_1c0)
          ))
        end
        end
        
        (local.set $tmp___132__s1a9 (i32.le_s (local.get $left) (local.get $right)))
        (if (local.get $tmp___132__s1a9) (then
          
          
          (local.set $tmp___133__s1ac (call $wax::arr_get (local.get $A) (local.get $left)))
          (local.set $tmp__s1ac (local.get $tmp___133__s1ac))
          
          (local.set $tmp___134__s1ac (call $wax::arr_get (local.get $A) (local.get $right)))
          (call $wax::arr_set (local.get $A) (local.get $left) (local.get $tmp___134__s1ac))
          (call $wax::arr_set (local.get $A) (local.get $right) (local.get $tmp__s1ac))
          
          (local.set $tmp___135__s1ac (i32.add (local.get $left) (i32.const 1)))
          (local.set $left (local.get $tmp___135__s1ac))
          
          (local.set $tmp___136__s1ac (i32.sub (local.get $right) (i32.const 1)))
          (local.set $right (local.get $tmp___136__s1ac))
        ))
        (call $wax::pop_stack)

        (br $tmp__lp_1be)
      ))
    end
    end
    (call $sortbyx (local.get $A) (local.get $lo) (local.get $right))
    (call $sortbyx (local.get $A) (local.get $left) (local.get $hi))
    (call $wax::pop_stack)
  )
  (func $render_svg (export "render_svg") (param $w i32) (param $h i32) (param $pxyz i32) (param $triangles i32) (result i32)
    (local $tmp___14c__s1b0 i32)
    (local $tmp___15b__s1b0 i32)
    (local $tmp___14b__s1b0 i32)
    (local $tmp___15c__s1b0 f32)
    (local $tmp___14a__s1b0 i32)
    (local $tmp___137 i32)
    (local $tmp___15a__s1b0 i32)
    (local $tmp___141__s1ae f32)
    (local $tmp___15f__s1b0 i32)
    (local $tmp___140__s1ae i32)
    (local $tmp___14f__s1b0 i32)
    (local $tmp___143__s1ae i32)
    (local $tmp___14e__s1b0 i32)
    (local $tmp___15d__s1b0 i32)
    (local $tmp___142__s1ae i32)
    (local $tmp___14d__s1b0 f32)
    (local $tmp___15e__s1b0 i32)
    (local $tmp___138 i32)
    (local $tmp___139 i32)
    (local $tmp___13b__s1ae i32)
    (local $tmp___152__s1b0 f32)
    (local $tmp___161__s1b0 f32)
    (local $tmp___13c__s1ae i32)
    (local $tmp___153__s1b0 i32)
    (local $tmp___160__s1b0 i32)
    (local $tmp___150__s1b0 i32)
    (local $tmp___163__s1b0 i32)
    (local $tmp___13a__s1ae i32)
    (local $tmp___151__s1b0 i32)
    (local $tmp___162__s1b0 i32)
    (local $tmp___13f__s1ae i32)
    (local $tmp___147__s1b0 i32)
    (local $tmp___156__s1b0 i32)
    (local $tmp___165__s1b0 i32)
    (local $tmp___146__s1b0 i32)
    (local $tmp___157__s1b0 f32)
    (local $tmp___164__s1b0 i32)
    (local $tmp___13d__s1ae i32)
    (local $tmp___145__s1b0 i32)
    (local $tmp___154__s1b0 i32)
    (local $tmp___13e__s1ae f32)
    (local $tmp___144__s1b0 i32)
    (local $tmp___155__s1b0 i32)
    (local $tmp___149__s1b0 i32)
    (local $tmp___158__s1b0 i32)
    (local $tmp___148__s1b0 f32)
    (local $tmp___159__s1b0 i32)
    (local $i__s1af i32)
    (local $i__s1ad i32)
    (local $s i32)
    

    (call $wax::push_stack)
    
    
    (local.set $tmp___137 (call $wax::str_new (i32.const 4)))
    (local.set $s (local.get $tmp___137))
    (call $wax::print (local.get $s))
    
    (local.set $tmp___138 (call $wax::int2str (local.get $w)))
    (local.set $s (call $wax::str_cat (local.get $s) (local.get $tmp___138)))
    (local.set $s (call $wax::str_cat (local.get $s) (i32.const 71)))
    
    (local.set $tmp___139 (call $wax::int2str (local.get $h)))
    (local.set $s (call $wax::str_cat (local.get $s) (local.get $tmp___139)))
    (local.set $s (call $wax::str_cat (local.get $s) (i32.const 84)))
    (if (i32.const 1) (then
      
      (local.set $i__s1ad (i32.const 0))
      block $tmp__block_0000000000C08290
      loop $tmp__lp_1c1
        (if (i32.const 1) (then
        
          (call $wax::push_stack)
          
          
          
          (local.set $tmp___13c__s1ae (call $wax::arr_length (local.get $pxyz)))
          (local.set $tmp___13b__s1ae (i32.lt_s (local.get $i__s1ad) (local.get $tmp___13c__s1ae)))
          (local.set $tmp___13a__s1ae (local.get $tmp___13b__s1ae))
          (if (local.get $tmp___13a__s1ae) (then
          
          )(else
            (call $wax::pop_stack)
            (br $tmp__block_0000000000C08290)
          ))
          (local.set $s (call $wax::str_cat (local.get $s) (i32.const 88)))
          
          
          
          (local.set $tmp___13f__s1ae (call $wax::arr_get (local.get $pxyz) (local.get $i__s1ad)))
          (local.set $tmp___13e__s1ae (f32.load (i32.add (local.get $tmp___13f__s1ae) (i32.mul (i32.const 0) (i32.const 4)))))
          (local.set $tmp___13d__s1ae (call $wax::flt2str (local.get $tmp___13e__s1ae)))
          (local.set $s (call $wax::str_cat (local.get $s) (local.get $tmp___13d__s1ae)))
          (local.set $s (call $wax::str_cat (local.get $s) (i32.const 102)))
          
          
          
          (local.set $tmp___142__s1ae (call $wax::arr_get (local.get $pxyz) (local.get $i__s1ad)))
          (local.set $tmp___141__s1ae (f32.load (i32.add (local.get $tmp___142__s1ae) (i32.mul (i32.const 1) (i32.const 4)))))
          (local.set $tmp___140__s1ae (call $wax::flt2str (local.get $tmp___141__s1ae)))
          (local.set $s (call $wax::str_cat (local.get $s) (local.get $tmp___140__s1ae)))
          (local.set $s (call $wax::str_cat (local.get $s) (i32.const 111)))
          
          (local.set $tmp___143__s1ae (i32.add (local.get $i__s1ad) (i32.const 1)))
          (local.set $i__s1ad (local.get $tmp___143__s1ae))
          (call $wax::pop_stack)

          (br $tmp__lp_1c1)
        ))
      end
      end
    ))
    (if (i32.const 1) (then
      
      (local.set $i__s1af (i32.const 0))
      block $tmp__block_0000000000BEA070
      loop $tmp__lp_1c2
        (if (i32.const 1) (then
        
          (call $wax::push_stack)
          
          
          
          (local.set $tmp___146__s1b0 (call $wax::arr_length (local.get $triangles)))
          (local.set $tmp___145__s1b0 (i32.lt_s (local.get $i__s1af) (local.get $tmp___146__s1b0)))
          (local.set $tmp___144__s1b0 (local.get $tmp___145__s1b0))
          (if (local.get $tmp___144__s1b0) (then
          
          )(else
            (call $wax::pop_stack)
            (br $tmp__block_0000000000BEA070)
          ))
          (local.set $s (call $wax::str_cat (local.get $s) (i32.const 125)))
          
          
          
          
          
          (local.set $tmp___14b__s1b0 (call $wax::arr_get (local.get $triangles) (local.get $i__s1af)))
          (local.set $tmp___14a__s1b0 (i32.load (i32.add (local.get $tmp___14b__s1b0) (i32.mul (i32.const 0) (i32.const 4)))))
          (local.set $tmp___149__s1b0 (call $wax::arr_get (local.get $pxyz) (local.get $tmp___14a__s1b0)))
          (local.set $tmp___148__s1b0 (f32.load (i32.add (local.get $tmp___149__s1b0) (i32.mul (i32.const 0) (i32.const 4)))))
          (local.set $tmp___147__s1b0 (call $wax::flt2str (local.get $tmp___148__s1b0)))
          (local.set $s (call $wax::str_cat (local.get $s) (local.get $tmp___147__s1b0)))
          (local.set $s (call $wax::str_cat (local.get $s) (i32.const 137)))
          
          
          
          
          
          (local.set $tmp___150__s1b0 (call $wax::arr_get (local.get $triangles) (local.get $i__s1af)))
          (local.set $tmp___14f__s1b0 (i32.load (i32.add (local.get $tmp___150__s1b0) (i32.mul (i32.const 0) (i32.const 4)))))
          (local.set $tmp___14e__s1b0 (call $wax::arr_get (local.get $pxyz) (local.get $tmp___14f__s1b0)))
          (local.set $tmp___14d__s1b0 (f32.load (i32.add (local.get $tmp___14e__s1b0) (i32.mul (i32.const 1) (i32.const 4)))))
          (local.set $tmp___14c__s1b0 (call $wax::flt2str (local.get $tmp___14d__s1b0)))
          (local.set $s (call $wax::str_cat (local.get $s) (local.get $tmp___14c__s1b0)))
          (local.set $s (call $wax::str_cat (local.get $s) (i32.const 139)))
          
          
          
          
          
          (local.set $tmp___155__s1b0 (call $wax::arr_get (local.get $triangles) (local.get $i__s1af)))
          (local.set $tmp___154__s1b0 (i32.load (i32.add (local.get $tmp___155__s1b0) (i32.mul (i32.const 1) (i32.const 4)))))
          (local.set $tmp___153__s1b0 (call $wax::arr_get (local.get $pxyz) (local.get $tmp___154__s1b0)))
          (local.set $tmp___152__s1b0 (f32.load (i32.add (local.get $tmp___153__s1b0) (i32.mul (i32.const 0) (i32.const 4)))))
          (local.set $tmp___151__s1b0 (call $wax::flt2str (local.get $tmp___152__s1b0)))
          (local.set $s (call $wax::str_cat (local.get $s) (local.get $tmp___151__s1b0)))
          (local.set $s (call $wax::str_cat (local.get $s) (i32.const 142)))
          
          
          
          
          
          (local.set $tmp___15a__s1b0 (call $wax::arr_get (local.get $triangles) (local.get $i__s1af)))
          (local.set $tmp___159__s1b0 (i32.load (i32.add (local.get $tmp___15a__s1b0) (i32.mul (i32.const 1) (i32.const 4)))))
          (local.set $tmp___158__s1b0 (call $wax::arr_get (local.get $pxyz) (local.get $tmp___159__s1b0)))
          (local.set $tmp___157__s1b0 (f32.load (i32.add (local.get $tmp___158__s1b0) (i32.mul (i32.const 1) (i32.const 4)))))
          (local.set $tmp___156__s1b0 (call $wax::flt2str (local.get $tmp___157__s1b0)))
          (local.set $s (call $wax::str_cat (local.get $s) (local.get $tmp___156__s1b0)))
          (local.set $s (call $wax::str_cat (local.get $s) (i32.const 144)))
          
          
          
          
          
          (local.set $tmp___15f__s1b0 (call $wax::arr_get (local.get $triangles) (local.get $i__s1af)))
          (local.set $tmp___15e__s1b0 (i32.load (i32.add (local.get $tmp___15f__s1b0) (i32.mul (i32.const 2) (i32.const 4)))))
          (local.set $tmp___15d__s1b0 (call $wax::arr_get (local.get $pxyz) (local.get $tmp___15e__s1b0)))
          (local.set $tmp___15c__s1b0 (f32.load (i32.add (local.get $tmp___15d__s1b0) (i32.mul (i32.const 0) (i32.const 4)))))
          (local.set $tmp___15b__s1b0 (call $wax::flt2str (local.get $tmp___15c__s1b0)))
          (local.set $s (call $wax::str_cat (local.get $s) (local.get $tmp___15b__s1b0)))
          (local.set $s (call $wax::str_cat (local.get $s) (i32.const 147)))
          
          
          
          
          
          (local.set $tmp___164__s1b0 (call $wax::arr_get (local.get $triangles) (local.get $i__s1af)))
          (local.set $tmp___163__s1b0 (i32.load (i32.add (local.get $tmp___164__s1b0) (i32.mul (i32.const 2) (i32.const 4)))))
          (local.set $tmp___162__s1b0 (call $wax::arr_get (local.get $pxyz) (local.get $tmp___163__s1b0)))
          (local.set $tmp___161__s1b0 (f32.load (i32.add (local.get $tmp___162__s1b0) (i32.mul (i32.const 1) (i32.const 4)))))
          (local.set $tmp___160__s1b0 (call $wax::flt2str (local.get $tmp___161__s1b0)))
          (local.set $s (call $wax::str_cat (local.get $s) (local.get $tmp___160__s1b0)))
          (local.set $s (call $wax::str_cat (local.get $s) (i32.const 149)))
          
          (local.set $tmp___165__s1b0 (i32.add (local.get $i__s1af) (i32.const 1)))
          (local.set $i__s1af (local.get $tmp___165__s1b0))
          (call $wax::pop_stack)

          (br $tmp__lp_1c2)
        ))
      end
      end
    ))
    (local.set $s (call $wax::str_cat (local.get $s) (i32.const 217)))
    (call $wax::pop_stack)
    (local.get $s)
    return
    (call $wax::pop_stack)
  )
  (func $main (export "main") (result i32)
    (local $tmp___16c__s1b2 f32)
    (local $tmp___17f__s1b6 i32)
    (local $tmp___16b__s1b2 f32)
    (local $tmp___172 i32)
    (local $tmp___16a__s1b2 i32)
    (local $tmp___17d__s1b6 i32)
    (local $tmp___173 i32)
    (local $tmp___17e__s1b6 i32)
    (local $tmp___174 i32)
    (local $tmp___17b__s1b6 i32)
    (local $tmp___175 i32)
    (local $tmp___16f__s1b2 f32)
    (local $tmp___17a__s1b4 i32)
    (local $tmp___17c__s1b6 i32)
    (local $tmp___16e__s1b2 f32)
    (local $tmp___166 i32)
    (local $tmp___16d__s1b2 f32)
    (local $pxyz i32)
    (local $tmp___170__s1b2 f32)
    (local $tmp___176__s1b4 i32)
    (local $tmp___171__s1b2 i32)
    (local $tmp___177__s1b4 i32)
    (local $tmp___167__s1b2 i32)
    (local $tmp___169__s1b2 i32)
    (local $tmp___168__s1b2 i32)
    (local $tmp___178__s1b4 i32)
    (local $tmp___179__s1b4 i32)
    (local $h i32)
    (local $s i32)
    (local $w i32)
    (local $i__s1b1 i32)
    (local $i__s1b3 i32)
    (local $i__s1b5 i32)
    (local $triangles i32)
    

    (call $wax::push_stack)
    
    
    (local.set $tmp___166 (call $wax::arr_new (i32.const 0)))
    (local.set $pxyz (local.get $tmp___166))
    
    (local.set $w (i32.const 400))
    
    (local.set $h (i32.const 400))
    (if (i32.const 1) (then
      
      (local.set $i__s1b1 (i32.const 0))
      block $tmp__block_0000000000C39410
      loop $tmp__lp_1c3
        (if (i32.const 1) (then
        
          (call $wax::push_stack)
          
          
          (local.set $tmp___168__s1b2 (i32.lt_s (local.get $i__s1b1) (i32.const 5)))
          (local.set $tmp___167__s1b2 (local.get $tmp___168__s1b2))
          (if (local.get $tmp___167__s1b2) (then
          
          )(else
            (call $wax::pop_stack)
            (br $tmp__block_0000000000C39410)
          ))
          
          (local.set $tmp___169__s1b2 (call $wax::arr_length (local.get $pxyz)))
          
          
          
          (local.set $tmp___16c__s1b2 (call $random))
          
          (local.set $tmp___16d__s1b2 (f32.convert_i32_s (local.get $w)))
          (local.set $tmp___16b__s1b2 (f32.mul (local.get $tmp___16c__s1b2) (local.get $tmp___16d__s1b2)))
          
          
          (local.set $tmp___16f__s1b2 (call $random))
          
          (local.set $tmp___170__s1b2 (f32.convert_i32_s (local.get $h)))
          (local.set $tmp___16e__s1b2 (f32.mul (local.get $tmp___16f__s1b2) (local.get $tmp___170__s1b2)))
          (local.set $tmp___16a__s1b2 (call $w__vec_lit2 (i32.reinterpret_f32 (local.get $tmp___16b__s1b2)) (i32.reinterpret_f32 (local.get $tmp___16e__s1b2))))
          (call $wax::arr_insert (local.get $pxyz) (local.get $tmp___169__s1b2) (local.get $tmp___16a__s1b2))
          
          (local.set $tmp___171__s1b2 (i32.add (local.get $i__s1b1) (i32.const 1)))
          (local.set $i__s1b1 (local.get $tmp___171__s1b2))
          (call $wax::pop_stack)

          (br $tmp__lp_1c3)
        ))
      end
      end
    ))
    
    
    (local.set $tmp___173 (call $wax::arr_length (local.get $pxyz)))
    (local.set $tmp___172 (i32.sub (local.get $tmp___173) (i32.const 1)))
    (call $sortbyx (local.get $pxyz) (i32.const 0) (local.get $tmp___172))
    
    
    (local.set $tmp___174 (call $delaunaytriangulate (local.get $pxyz)))
    (local.set $triangles (local.get $tmp___174))
    
    
    (local.set $tmp___175 (call $render_svg (local.get $w) (local.get $h) (local.get $pxyz) (local.get $triangles)))
    (local.set $s (local.get $tmp___175))
    (call $wax::print (local.get $s))
    (if (i32.const 1) (then
      
      (local.set $i__s1b3 (i32.const 0))
      block $tmp__block_0000000000C3FA30
      loop $tmp__lp_1c4
        (if (i32.const 1) (then
        
          (call $wax::push_stack)
          
          
          
          (local.set $tmp___178__s1b4 (call $wax::arr_length (local.get $triangles)))
          (local.set $tmp___177__s1b4 (i32.lt_s (local.get $i__s1b3) (local.get $tmp___178__s1b4)))
          (local.set $tmp___176__s1b4 (local.get $tmp___177__s1b4))
          (if (local.get $tmp___176__s1b4) (then
          
          )(else
            (call $wax::pop_stack)
            (br $tmp__block_0000000000C3FA30)
          ))
          
          (local.set $tmp___179__s1b4 (call $wax::arr_get (local.get $triangles) (local.get $i__s1b3)))
          (call $wax::free (local.get $tmp___179__s1b4))
          
          (local.set $tmp___17a__s1b4 (i32.add (local.get $i__s1b3) (i32.const 1)))
          (local.set $i__s1b3 (local.get $tmp___17a__s1b4))
          (call $wax::pop_stack)

          (br $tmp__lp_1c4)
        ))
      end
      end
    ))
    (if (i32.const 1) (then
      
      (local.set $i__s1b5 (i32.const 0))
      block $tmp__block_0000000000C41910
      loop $tmp__lp_1c5
        (if (i32.const 1) (then
        
          (call $wax::push_stack)
          
          
          
          (local.set $tmp___17d__s1b6 (call $wax::arr_length (local.get $pxyz)))
          (local.set $tmp___17c__s1b6 (i32.lt_s (local.get $i__s1b5) (local.get $tmp___17d__s1b6)))
          (local.set $tmp___17b__s1b6 (local.get $tmp___17c__s1b6))
          (if (local.get $tmp___17b__s1b6) (then
          
          )(else
            (call $wax::pop_stack)
            (br $tmp__block_0000000000C41910)
          ))
          
          (local.set $tmp___17e__s1b6 (call $wax::arr_get (local.get $pxyz) (local.get $i__s1b5)))
          (call $wax::free (local.get $tmp___17e__s1b6))
          
          (local.set $tmp___17f__s1b6 (i32.add (local.get $i__s1b5) (i32.const 1)))
          (local.set $i__s1b5 (local.get $tmp___17f__s1b6))
          (call $wax::pop_stack)

          (br $tmp__lp_1c5)
        ))
      end
      end
    ))
    (call $wax::arr_free (local.get $pxyz))
    (call $wax::free (local.get $s))
    (call $wax::arr_free (local.get $triangles))
    (call $wax::pop_stack)
    (i32.const 0)
    return
    (call $wax::pop_stack)
  )
(data (i32.const 4) "<svg version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\" width=\"")
(data (i32.const 71) "\" height=\"")
(data (i32.const 84) "\">")
(data (i32.const 88) "<circle cx=\"")
(data (i32.const 102) "\" cy=\"")
(data (i32.const 111) "\" r=\"2\" />")
(data (i32.const 125) "<path d=\"M")
(data (i32.const 137) ",")
(data (i32.const 139) " L")
(data (i32.const 142) ",")
(data (i32.const 144) " L")
(data (i32.const 147) ",")
(data (i32.const 149) " z\" fill=\"rgba(0,0,0,0.1)\" stroke-width=\"1\" stroke=\"black\"/>")
(data (i32.const 217) "</svg>")
(func $w__vec_lit2 (param $_0 i32) (param $_1 i32)(result i32)
  (local $a i32) (local.set $a (call $wax::malloc (i32.const 8)))
  (i32.store (i32.add (local.get $a) (i32.const 0)) (local.get $_0))
  (i32.store (i32.add (local.get $a) (i32.const 4)) (local.get $_1))
  (return (local.get $a))
)
(func $w__vec_lit3 (param $_0 i32) (param $_1 i32) (param $_2 i32)(result i32)
  (local $a i32) (local.set $a (call $wax::malloc (i32.const 12)))
  (i32.store (i32.add (local.get $a) (i32.const 0)) (local.get $_0))
  (i32.store (i32.add (local.get $a) (i32.const 4)) (local.get $_1))
  (i32.store (i32.add (local.get $a) (i32.const 8)) (local.get $_2))
  (return (local.get $a))
)
(global $wax::min_addr (mut i32) (i32.const 224))
;;=== User Code            END   ===;;

;;=== WAX Standard Library BEGIN ===;;
;;========================================================;;
;;     BASELINE MALLOC WITH HANDWRITTEN WEBASSEMBLY       ;;
;;========================================================;;
;; 32-bit implicit-free-list first-fit baseline malloc    ;;
;;--------------------------------------------------------;;

;; IMPLICIT FREE LIST:
;; Worse utilization and throughput than explicit/segregated, but easier
;; to implement :P
;;
;; HEAP LO                                                         HEAP HI
;; +---------------------+---------------------+...+---------------------+
;; | HDR | PAYLOAD | FTR | HDR | PAYLOAD | FTR |...+ HDR | PAYLOAD | FTR |
;; +----------^----------+---------------------+...+---------------------+
;;            |_ i.e. user data
;;           
;; LAYOUT OF A BLOCK:
;; Since memory is aligned to multiple of 4 bytes, the last two bits of
;; payload_size is redundant. Therefore the last bit of header is used to
;; store the is_free flag.
;; 
;; |---- HEADER (4b)----
;; |    ,--payload size (x4)--.     ,-is free?
;; | 0b . . . . . . . . . . . . 0  0
;; |------ PAYLOAD -----
;; |
;; |  user data (N x 4b)
;; |
;; |---- FOOTER (4b)---- (duplicate of header)
;; |    ,--payload size (x4)--.     ,-is free?
;; | 0b . . . . . . . . . . . . 0  0
;; |--------------------
;;
;; FORMULAS:
;; (these formulas are used throughout the code, so they're listed here
;; instead of explained each time encountered)
;;
;; payload_size = block_size - (header_size + footer_size) = block_size - 8
;; 
;; payload_pointer = header_pointer + header_size = header_pointer + 4
;;
;; footer_pointer = header_pointer + header_size + payload_size
;;                = (header_pointer + payload_size) + 4
;;
;; next_header_pointer = footer_pointer + footer_size = footer_pointer + 4
;;
;; prev_footer_pointer = header_pointer - footer_size = header_pointer - 4

(memory $wax::mem 1)                                ;; start with 1 page (64K)
(export "mem" (memory $wax::mem))
;;// (global $wax::min_addr (mut i32) (i32.const 0))  ;; set by wax compiler depending on data section size
(global $wax::max_addr (mut i32) (i32.const 65536)) ;; initial heap size (64K)
(global $wax::heap_did_init (mut i32) (i32.const 0))     ;; init() called?

;; helpers to pack/unpack payload_size/is_free from header/footer
;; by masking out bits

;; read payload_size from header/footer given pointer to header/footer
(func $wax::hdr_get_size (param $ptr i32) (result i32)
  (i32.and (i32.load (local.get $ptr)) (i32.const 0xFFFFFFFC))
)
;; read is_free from header/footer
(func $wax::hdr_get_free (param $ptr i32) (result i32)
  (i32.and (i32.load (local.get $ptr)) (i32.const 0x00000001))
)
;; write payload_size to header/footer
(func $wax::hdr_set_size (param $ptr i32) (param $n i32) 
  (i32.store (local.get $ptr) (i32.or
    (i32.and (i32.load (local.get $ptr)) (i32.const 0x00000003))
    (local.get $n)
  ))
)
;; write is_free to header/footer
(func $wax::hdr_set_free (param $ptr i32) (param $n i32)
  (i32.store (local.get $ptr) (i32.or
    (i32.and (i32.load (local.get $ptr)) (i32.const 0xFFFFFFFE))
    (local.get $n)
  ))
)
;; align memory by 4 bytes
(func $wax::align4 (param $x i32) (result i32)
  (i32.and
    (i32.add (local.get $x) (i32.const 3))
    (i32.const -4)
  )
)

;; initialize heap
;; make the whole heap a big free block
;; - automatically invoked by first malloc() call
;; - can be manually called to nuke the whole heap
(func $wax::init_heap
  (i32.store (i32.const 0) (global.get $wax::min_addr) )
  ;; write payload_size to header and footer
  (call $wax::hdr_set_size (global.get $wax::min_addr) 
    (i32.sub (i32.sub (global.get $wax::max_addr) (global.get $wax::min_addr)) (i32.const 8))
  )
  (call $wax::hdr_set_size (i32.sub (global.get $wax::max_addr) (i32.const 4))
    (i32.sub (i32.sub (global.get $wax::max_addr) (global.get $wax::min_addr)) (i32.const 8))
  )
  ;; write is_free to header and footer
  (call $wax::hdr_set_free (global.get $wax::min_addr) (i32.const 1))
  (call $wax::hdr_set_free (i32.sub (global.get $wax::max_addr) (i32.const 4)) (i32.const 1))

  ;; set flag to tell malloc() that we've already called init()
  (global.set $wax::heap_did_init (i32.const 1)) 
)

;; extend (grow) the heap (to accomodate more blocks)
;; parameter: number of pages (64K) to grow
;; - automatically invoked by malloc() when current heap has insufficient free space
;; - can be manually called to get more space in advance
(func $wax::extend (param $n_pages i32)
  (local $n_bytes i32)
  (local $ftr i32)
  (local $prev_ftr i32)
  (local $prev_hdr i32)
  (local $prev_size i32)

  (local.set $prev_ftr (i32.sub (global.get $wax::max_addr) (i32.const 4)) )

  ;; compute number of bytes from page count (1page = 64K = 65536bytes)
  (local.set $n_bytes (i32.mul (local.get $n_pages) (i32.const 65536)))

  ;; system call to grow memory (`drop` discards the (useless) return value of memory.grow)
  (drop (memory.grow (local.get $n_pages) ))

  ;; make the newly acquired memory a big free block
  (call $wax::hdr_set_size (global.get $wax::max_addr) (i32.sub (local.get $n_bytes) (i32.const 8)))
  (call $wax::hdr_set_free (global.get $wax::max_addr) (i32.const 1))

  (global.set $wax::max_addr (i32.add (global.get $wax::max_addr) (local.get $n_bytes) ))
  (local.set $ftr (i32.sub (global.get $wax::max_addr) (i32.const 4)))

  (call $wax::hdr_set_size (local.get $ftr)
    (i32.sub (local.get $n_bytes) (i32.const 8))
  )
  (call $wax::hdr_set_free (local.get $ftr) (i32.const 1))

  ;; see if we can join the new block with the last block of the old heap
  (if (i32.eqz (call $wax::hdr_get_free (local.get $prev_ftr)))(then)(else

    ;; the last block is free, join it.
    (local.set $prev_size (call $wax::hdr_get_size (local.get $prev_ftr)))
    (local.set $prev_hdr
      (i32.sub (i32.sub (local.get $prev_ftr) (local.get $prev_size)) (i32.const 4))
    )
    (call $wax::hdr_set_size (local.get $prev_hdr)
      (i32.add (local.get $prev_size) (local.get $n_bytes) )
    )
    (call $wax::hdr_set_size (local.get $ftr)
      (i32.add (local.get $prev_size) (local.get $n_bytes) )
    )
  ))

)

;; find a free block that fit the request number of bytes
;; modifies the heap once a candidate is found
;; first-fit: not the best policy, but the simplest
(func $wax::find (param $n_bytes i32) (result i32)
  (local $ptr i32)
  (local $size i32)
  (local $is_free i32)
  (local $pay_ptr i32)
  (local $rest i32)

  ;; loop through all blocks
  (local.set $ptr (global.get $wax::min_addr))
  loop $search
    ;; we reached the end of heap and haven't found anything, return NULL
    (if (i32.lt_u (local.get $ptr) (global.get $wax::max_addr))(then)(else
      (i32.const 0)
      return
    ))

    ;; read info about current block
    (local.set $size    (call $wax::hdr_get_size (local.get $ptr)))
    (local.set $is_free (call $wax::hdr_get_free (local.get $ptr)))
    (local.set $pay_ptr (i32.add (local.get $ptr) (i32.const 4) ))

    ;; check if the current block is free
    (if (i32.eq (local.get $is_free) (i32.const 1))(then

      ;; it's free, but too small, move on
      (if (i32.gt_u (local.get $n_bytes) (local.get $size))(then
        (local.set $ptr (i32.add (local.get $ptr) (i32.add (local.get $size) (i32.const 8))))
        (br $search)

      ;; it's free, and large enough to be split into two blocks
      )(else(if (i32.lt_u (local.get $n_bytes) (i32.sub (local.get $size) (i32.const 8)))(then
        ;; OLD HEAP
        ;; ...+-------------------------------------------+...
        ;; ...| HDR |              FREE             | FTR |...
        ;; ...+-------------------------------------------+...
        ;; NEW HEAP
        ;; ...+---------------------+---------------------+...
        ;; ...| HDR | ALLOC   | FTR | HDR |  FREE   | FTR |...
        ;; ...+---------------------+---------------------+...

        ;; size of the remaining half
        (local.set $rest (i32.sub (i32.sub (local.get $size) (local.get $n_bytes) ) (i32.const 8)))

        ;; update headers and footers to reflect the change (see FORMULAS)

        (call $wax::hdr_set_size (local.get $ptr) (local.get $n_bytes))
        (call $wax::hdr_set_free (local.get $ptr) (i32.const 0))

        (call $wax::hdr_set_size (i32.add (i32.add (local.get $ptr) (local.get $n_bytes)) (i32.const 4))
          (local.get $n_bytes)
        )
        (call $wax::hdr_set_free (i32.add (i32.add (local.get $ptr) (local.get $n_bytes)) (i32.const 4))
          (i32.const 0)
        )
        (call $wax::hdr_set_size (i32.add (i32.add (local.get $ptr) (local.get $n_bytes)) (i32.const 8))
          (local.get $rest)
        )
        (call $wax::hdr_set_free (i32.add (i32.add (local.get $ptr) (local.get $n_bytes)) (i32.const 8))
          (i32.const 1)
        )
        (call $wax::hdr_set_size (i32.add (i32.add (local.get $ptr) (local.get $size)) (i32.const 4))
          (local.get $rest)
        )

        (local.get $pay_ptr)
        return

      )(else
        ;; the block is free, but not large enough to be split into two blocks 
        ;; we return the whole block as one
        (call $wax::hdr_set_free (local.get $ptr) (i32.const 0))
        (call $wax::hdr_set_free (i32.add (i32.add (local.get $ptr) (local.get $size)) (i32.const 4))
          (i32.const 0)
        )
        (local.get $pay_ptr)
        return
      ))))
    )(else
      ;; the block is not free, we move on to the next block
      (local.set $ptr (i32.add (local.get $ptr) (i32.add (local.get $size) (i32.const 8))))
      (br $search)
    ))
  end

  ;; theoratically we will not reach here
  ;; return NULL
  (i32.const 0)
)


;; malloc - allocate the requested number of bytes on the heap
;; returns a pointer to the block of memory allocated
;; returns NULL (0) when OOM
;; if heap is not large enough, grows it via extend()
(func $wax::malloc (param $n_bytes i32) (result i32)
  (local $ptr i32)
  (local $n_pages i32)

  ;; call init() if we haven't done so yet
  (if (i32.eqz (global.get $wax::heap_did_init)) (then
    (call $wax::init_heap)
  ))

  ;; payload size is aligned to multiple of 4
  (local.set $n_bytes (call $wax::align4 (local.get $n_bytes)))

  ;; attempt allocation
  (local.set $ptr (call $wax::find (local.get $n_bytes)) )

  ;; NULL -> OOM -> extend heap
  (if (i32.eqz (local.get $ptr))(then
    ;; compute # of pages from # of bytes, rounding up
    (local.set $n_pages
      (i32.div_u 
        (i32.add (local.get $n_bytes) (i32.const 65527) )
        (i32.const 65528)
      )
    )
    (call $wax::extend (local.get $n_pages))

    ;; try again
    (local.set $ptr (call $wax::find (local.get $n_bytes)) )
  ))
  (local.get $ptr)
)

;; free - free an allocated block given a pointer to it
(func $wax::free (param $ptr i32)
  (local $hdr i32)
  (local $ftr i32)
  (local $size i32)
  (local $prev_hdr i32)
  (local $prev_ftr i32)
  (local $prev_size i32)
  (local $prev_free i32)
  (local $next_hdr i32)
  (local $next_ftr i32)
  (local $next_size i32)
  (local $next_free i32)
  
  ;; step I: mark the block as free

  (local.set $hdr (i32.sub (local.get $ptr) (i32.const 4)))
  (local.set $size (call $wax::hdr_get_size (local.get $hdr)))
  (local.set $ftr (i32.add (i32.add (local.get $hdr) (local.get $size)) (i32.const 4)))

  (call $wax::hdr_set_free (local.get $hdr) (i32.const 1))
  (call $wax::hdr_set_free (local.get $ftr) (i32.const 1))

  ;; step II: try coalasce

  ;; coalasce with previous block

  ;; check that we're not already the first block
  (if (i32.eq (local.get $hdr) (global.get $wax::min_addr)) (then)(else

    ;; read info about previous block
    (local.set $prev_ftr (i32.sub (local.get $hdr) (i32.const 4)))
    (local.set $prev_size (call $wax::hdr_get_size (local.get $prev_ftr)))
    (local.set $prev_hdr 
      (i32.sub (i32.sub (local.get $prev_ftr) (local.get $prev_size)) (i32.const 4))
    )

    ;; check if previous block is free -> merge them
    (if (i32.eqz (call $wax::hdr_get_free (local.get $prev_ftr))) (then) (else
      (local.set $size (i32.add (i32.add (local.get $size) (local.get $prev_size)) (i32.const 8)))
      (call $wax::hdr_set_size (local.get $prev_hdr) (local.get $size))
      (call $wax::hdr_set_size (local.get $ftr) (local.get $size))

      ;; set current header pointer to previous header
      (local.set $hdr (local.get $prev_hdr))
    ))
  ))

  ;; coalasce with next block

  (local.set $next_hdr (i32.add (local.get $ftr) (i32.const 4)))

  ;; check that we're not already the last block
  (if (i32.eq (local.get $next_hdr) (global.get $wax::max_addr)) (then)(else
    
    ;; read info about next block
    (local.set $next_size (call $wax::hdr_get_size (local.get $next_hdr)))
    (local.set $next_ftr 
      (i32.add (i32.add (local.get $next_hdr) (local.get $next_size)) (i32.const 4))
    )

    ;; check if next block is free -> merge them
    (if (i32.eqz (call $wax::hdr_get_free (local.get $next_hdr))) (then) (else
      (local.set $size (i32.add (i32.add (local.get $size) (local.get $next_size)) (i32.const 8)))
      (call $wax::hdr_set_size (local.get $hdr) (local.get $size))
      (call $wax::hdr_set_size (local.get $next_ftr) (local.get $size))
    ))

  ))

)
;; copy a block of memory over, from src pointer to dst pointer
;; WebAssembly seems to be planning to support memory.copy
;; until then, this function uses a loop and i32.store8/load8
(func $wax::memcpy (param $dst i32) (param $src i32) (param $n_bytes i32)
  (local $ptr i32)
  (local $offset i32)
  (local $data i32)

  (if (i32.eqz (local.get $n_bytes))(then
    return
  ))

  (local.set $offset (i32.const 0))

  loop $cpy
    (local.set $data (i32.load8_u (i32.add (local.get $src) (local.get $offset))))
    (i32.store8 (i32.add (local.get $dst) (local.get $offset)) (local.get $data))

    (local.set $offset (i32.add (local.get $offset) (i32.const 1)))
    (br_if $cpy (i32.lt_u (local.get $offset) (local.get $n_bytes)))
  end
)

;; reallocate memory to new size
;; currently does not support contraction
;; nothing will happen if n_bytes is smaller than current payload size
(func $wax::realloc (param $ptr i32) (param $n_bytes i32) (result i32)
  (local $hdr i32)
  (local $next_hdr i32)
  (local $next_ftr i32)
  (local $next_size i32)
  (local $ftr i32)
  (local $size i32)
  (local $rest_hdr i32)
  (local $rest_size i32)
  (local $new_ptr i32)

  (local.set $hdr (i32.sub (local.get $ptr) (i32.const 4)))
  (local.set $size (call $wax::hdr_get_size (local.get $hdr)))

  (if (i32.gt_u (local.get $n_bytes) (local.get $size)) (then) (else
    (local.get $ptr)
    return
  ))

  ;; payload size is aligned to multiple of 4
  (local.set $n_bytes (call $wax::align4 (local.get $n_bytes)))

  (local.set $next_hdr (i32.add (i32.add (local.get $hdr) (local.get $size)) (i32.const 8)))

  ;; Method I: try to expand the current block

  ;; check that we're not already the last block
  (if (i32.lt_u (local.get $next_hdr) (global.get $wax::max_addr) )(then
    (if (call $wax::hdr_get_free (local.get $next_hdr)) (then

      (local.set $next_size (call $wax::hdr_get_size (local.get $next_hdr)))
      (local.set $rest_size (i32.sub 
        (local.get $next_size)
        (i32.sub (local.get $n_bytes) (local.get $size))
      ))
      (local.set $next_ftr (i32.add (i32.add (local.get $next_hdr) (local.get $next_size)) (i32.const 4)))

      ;; next block is big enough to be split into two
      (if (i32.gt_s (local.get $rest_size) (i32.const 0) ) (then
        
        (call $wax::hdr_set_size (local.get $hdr) (local.get $n_bytes))
        
        (local.set $ftr (i32.add (i32.add (local.get $hdr) (local.get $n_bytes) ) (i32.const 4)))
        (call $wax::hdr_set_size (local.get $ftr) (local.get $n_bytes))
        (call $wax::hdr_set_free (local.get $ftr) (i32.const 0))

        (local.set $rest_hdr (i32.add (local.get $ftr) (i32.const 4) ))
        (call $wax::hdr_set_size (local.get $rest_hdr) (local.get $rest_size))
        (call $wax::hdr_set_free (local.get $rest_hdr) (i32.const 1))

        (call $wax::hdr_set_size (local.get $next_ftr) (local.get $rest_size))
        (call $wax::hdr_set_free (local.get $next_ftr) (i32.const 1))

        (local.get $ptr)
        return

      ;; next block is not big enough to be split, but is
      ;; big enough to merge with the current one into one
      )(else (if (i32.gt_s (local.get $rest_size) (i32.const -9) ) (then
      
        (local.set $size (i32.add (i32.add (local.get $size) (i32.const 8) ) (local.get $next_size)))
        (call $wax::hdr_set_size (local.get $hdr) (local.get $size))
        (call $wax::hdr_set_size (local.get $next_ftr) (local.get $size))
        (call $wax::hdr_set_free (local.get $next_ftr) (i32.const 0))

        (local.get $ptr)
        return
      ))))

    ))
  ))

  ;; Method II: allocate a new block and copy over

  (local.set $new_ptr (call $wax::malloc (local.get $n_bytes)))
  (call $wax::memcpy (local.get $new_ptr) (local.get $ptr) (local.get $size))
  (call $wax::free (local.get $ptr))
  (local.get $new_ptr)

)

(func $wax::calloc (param $n_bytes i32) (result i32)
  (local $ptr i32)
  (local $offset i32)
  (local.set $ptr (call $wax::malloc (local.get $n_bytes)))
  (local.set $offset (i32.const 0))
  loop $zero
    (if (i32.lt_u (local.get $offset) (local.get $n_bytes)) (then
      (i32.store8 (i32.add (local.get $offset) (local.get $ptr) ) (i32.const 0))
      (local.set $offset (i32.add (local.get $offset) (i32.const 1)))
      (br $zero)
    ))
  end
  (local.get $ptr)
  return
)

(func $wax::memmove (param $dst i32) (param $src i32) (param $n_bytes i32)
  (local $ptr i32)
  (local $offset i32)
  (local $data i32)

  (if (i32.eqz (local.get $n_bytes))(then
    return
  ))
  
  (if (i32.gt_u (local.get $dst) (local.get $src)) (then
    (local.set $offset (i32.sub (local.get $n_bytes) (i32.const 1)))
    loop $cpy_rev
      (local.set $data (i32.load8_u (i32.add (local.get $src) (local.get $offset))))
      (i32.store8 (i32.add (local.get $dst) (local.get $offset)) (local.get $data))

      (local.set $offset (i32.sub (local.get $offset) (i32.const 1)))
      (br_if $cpy_rev (i32.gt_s (local.get $offset) (i32.const -1)))
    end
  
  )(else
    (local.set $offset (i32.const 0))
    loop $cpy
      (local.set $data (i32.load8_u (i32.add (local.get $src) (local.get $offset))))
      (i32.store8 (i32.add (local.get $dst) (local.get $offset)) (local.get $data))

      (local.set $offset (i32.add (local.get $offset) (i32.const 1)))
      (br_if $cpy (i32.lt_u (local.get $offset) (local.get $n_bytes)))
    end
  ))
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                  ;;
;;                                  ;;
;;               STACK              ;;
;;                                  ;;
;;                                  ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; poor man's stack
;; malloc a block of memory and pretend it's the stack, because of the apparent lack(?) of stack address in webassembly

(global $wax::stack_indices_ptr (mut i32) (i32.const 0))
(global $wax::stack_content_ptr (mut i32) (i32.const 0))
(global $wax::stack_count   (mut i32) (i32.const 32))
(global $wax::stack_size    (mut i32) (i32.const 128))
(global $wax::stack_index   (mut i32) (i32.const 0))
(global $wax::stack_now     (mut i32) (i32.const 0))
(global $wax::stack_did_init(mut i32) (i32.const 0))

(func $wax::init_stack
  (global.set $wax::stack_indices_ptr (call $wax::calloc (i32.mul (global.get $wax::stack_count) (i32.const 4))))
  (global.set $wax::stack_content_ptr (call $wax::malloc (global.get $wax::stack_size)))
  (global.set $wax::stack_index (i32.const 0))
  (global.set $wax::stack_did_init (i32.const 1))
)
(func $wax::stack_index_offset (result i32)
  (i32.add (global.get $wax::stack_indices_ptr) (i32.mul (global.get $wax::stack_index) (i32.const 4)))
)
(func $wax::push_stack

  (if (i32.eqz (global.get $wax::stack_did_init)) (then (call $wax::init_stack) ))

  (global.set $wax::stack_index (i32.add (global.get $wax::stack_index) (i32.const 1) ))

  (if (i32.ge_u (global.get $wax::stack_index) (global.get $wax::stack_count)) (then
    (global.set $wax::stack_count (i32.add (global.get $wax::stack_count) (i32.const 128)))
    (global.set $wax::stack_indices_ptr (call $wax::realloc 
      (global.get $wax::stack_indices_ptr) 
      (i32.mul (global.get $wax::stack_count) (i32.const 4))
    ))
  ))

  (i32.store (call $wax::stack_index_offset) (global.get $wax::stack_now) )

)
(func $wax::pop_stack

  (global.set $wax::stack_now (i32.load (call $wax::stack_index_offset) ))
  (global.set $wax::stack_index (i32.sub (global.get $wax::stack_index) (i32.const 1) ))
  
)
(func $wax::alloca (param $n_bytes i32) (result i32)
  (local $inc i32)
  (if (i32.ge_u (i32.add (global.get $wax::stack_now) (local.get $n_bytes) ) (global.get $wax::stack_size)) (then
    (local.set $inc (i32.const 512))
    (if (i32.gt_u (local.get $n_bytes) (local.get $inc)) (then
      (local.set $inc (call $wax::align4 (local.get $n_bytes)))
    ))
    (global.set $wax::stack_size (i32.add (global.get $wax::stack_size) (local.get $inc) ))
    (global.set $wax::stack_content_ptr
      (call $wax::realloc (global.get $wax::stack_content_ptr) (global.get $wax::stack_size))
    )
  ))

  ;; repurpose $inc for ret val
  (local.set $inc (i32.add (global.get $wax::stack_content_ptr ) (global.get $wax::stack_now)))

  (global.set $wax::stack_now (i32.add (global.get $wax::stack_now) (local.get $n_bytes)))

  (local.get $inc)
  return
)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                  ;;
;;                                  ;;
;;              STRING              ;;
;;                                  ;;
;;                                  ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(func $wax::fmod (param $x f32) (param $y f32) (result f32)
  (f32.sub (local.get $x) (f32.mul (local.get $y) (f32.trunc (f32.div (local.get $x) (local.get $y)) )))
)

(func $wax::str_new (param $ptr i32) (result i32)
  (if (i32.eqz (local.get $ptr))(then
    (call $wax::calloc (i32.const 1))
    return
  ))
  (call $wax::str_slice (local.get $ptr) (i32.const 0) (call $wax::str_len (local.get $ptr)) )
  return
)

(func $wax::str_get (param $ptr i32) (param $i i32) (result i32)
  (i32.load8_s (i32.add (local.get $ptr) (local.get $i)))
  return
)

(func $wax::str_add (param $ptr i32) (param $c i32) (result i32)
  (local $l i32)
  (local.set $l (call $wax::str_len (local.get $ptr)))
  (local.set $ptr (call $wax::realloc (local.get $ptr) (i32.add (local.get $l) (i32.const 2) ) ) )
  (i32.store8 (i32.add (local.get $ptr) (local.get $l)) (local.get $c)  )
  (i32.store8 (i32.add (i32.add (local.get $ptr) (local.get $l)) (i32.const 1)) (i32.const 0)  )

  (local.get $ptr)
  (return)
)

(func $wax::str_cat (param $s0 i32) (param $s1 i32) (result i32)
  (local $l0 i32)
  (local $l1 i32)
  (local.set $l0 (call $wax::str_len (local.get $s0)))
  (local.set $l1 (call $wax::str_len (local.get $s1)))

  (local.set $s0 (call $wax::realloc (local.get $s0) (i32.add (i32.add (local.get $l0) (local.get $l1) ) (i32.const 1)) ))

  (call $wax::memcpy (i32.add (local.get $s0) (local.get $l0)) (local.get $s1) (local.get $l1) )
  (i32.store8 (i32.add (i32.add (local.get $s0) (local.get $l0)) (local.get $l1)) (i32.const 0)  )
  (local.get $s0)
  return
)

(func $wax::str_cmp (param $s0 i32) (param $s1 i32) (result i32)
  (local $offset i32)
  (local $x i32)
  (local $y i32)
  (local.set $offset (i32.const 0))
  loop $cmp
    (local.set $x (i32.load8_u (i32.add (local.get $s0) (local.get $offset))) )
    (local.set $y (i32.load8_u (i32.add (local.get $s1) (local.get $offset))) )

    (if (i32.eq (local.get $x) (local.get $y)) (then
      (if (i32.eqz (local.get $x)) (then
        (i32.const 1)
        return
      ))
    )(else
      (i32.const 0)
      return
    ))

    (local.set $offset (i32.add (local.get $offset) (i32.const 1)))
    (br $cmp)
  end
  (i32.const 0) ;;impossible, just shut compiler up
  return
)

(func $wax::str_len (param $ptr i32) (result i32)
  (local $offset i32)
  (local.set $offset (i32.const 0))
  loop $zero
    (if (i32.load8_u (i32.add (local.get $ptr) (local.get $offset))) (then
      (local.set $offset (i32.add (local.get $offset) (i32.const 1)))
      (br $zero)
    ))
  end
  (local.get $offset)
  return
)

(func $wax::str_slice (param $ptr i32) (param $i i32) (param $n i32) (result i32)
  (local $nptr i32)
  (local.set $nptr (call $wax::malloc (i32.add (local.get $n) (i32.const 1))))
  (call $wax::memcpy 
    (local.get $nptr) 
    (i32.add (local.get $ptr) (local.get $i)) 
    (local.get $n)
  )
  (i32.store8 (i32.add (local.get $nptr) (local.get $n) ) (i32.const 0))
  (local.get $nptr)
  return
)

(func $wax::print (param $ptr i32)
  (local $len i32)
  (local.set $len (call $wax::str_len (local.get $ptr)))
  (call $wax::js::console.log (local.get $ptr) (local.get $len))
)

(func $wax::int2str (param $x i32) (result i32)
  (local $ptr i32)
  (local $rem i32)
  (local $isneg i32)
  (local $str i32)

  (local.set $str (call $wax::alloca (i32.const 16)))
  (local.set $ptr (i32.add (local.get $str) (i32.const 15)))
  (i32.store8 (local.get $ptr) (i32.const 0))
  
  (local.set $isneg (i32.const 0))
  (if (i32.lt_s (local.get $x) (i32.const 0)) (then
    (local.set $isneg (i32.const 1))
    (local.set $x (i32.sub (i32.const 0) (local.get $x) ))
  ))

  loop $digits
    (local.set $ptr (i32.sub (local.get $ptr) (i32.const 1)))

    (local.set $rem (i32.rem_u (local.get $x) (i32.const 10)))
    (i32.store8 (local.get $ptr) (i32.add (local.get $rem) (i32.const 48)))

    (local.set $x (i32.div_u (local.get $x) (i32.const 10)))

    (if (i32.eqz (i32.eqz (local.get $x))) (then
      (br $digits)
    ))
  end

  (if (local.get $isneg) (then
    (local.set $ptr (i32.sub (local.get $ptr) (i32.const 1)))
    (i32.store8 (local.get $ptr) (i32.const 45)) ;; '-'
  ))

  (local.get $ptr)
  return
)

(func $wax::fint2str (param $x f32) (result i32)
  (local $ptr i32)
  (local $rem i32)
  (local $isneg i32)
  (local $str i32)
  (local.set $x (f32.trunc (local.get $x)))

  (local.set $str (call $wax::alloca (i32.const 48)))
  (local.set $ptr (i32.add (local.get $str) (i32.const 47)))
  (i32.store8 (local.get $ptr) (i32.const 0))
  
  (if (f32.lt (local.get $x) (f32.const 0)) (then
    (local.set $isneg (i32.const 1))
    (local.set $x (f32.sub (f32.const 0) (local.get $x) ))
  ))

  loop $digits
    (local.set $ptr (i32.sub (local.get $ptr) (i32.const 1)))

    (local.set $rem (i32.trunc_f32_s (call $wax::fmod (local.get $x) (f32.const 10.0))))
    (i32.store8 (local.get $ptr) (i32.add (local.get $rem) (i32.const 48)))

    (local.set $x (f32.div (local.get $x) (f32.const 10.0)))

    (if (f32.gt (local.get $x) (f32.const 0.99999994) ) (then ;;nextafterf(1.00000001,0.0);
      (br $digits)
    ))
  end

  (if (local.get $isneg) (then
    (local.set $ptr (i32.sub (local.get $ptr) (i32.const 1)))
    (i32.store8 (local.get $ptr) (i32.const 45)) ;; '-'
  ))

  (local.get $ptr)
  return
)




(func $wax::flt2str (param $x f32) (result i32)
  (local $ptr0 i32)
  (local $ptr i32)
  (local $rem i32)
  (local $isneg i32)
  (local $str i32)

  (local.set $ptr0 (call $wax::fint2str (local.get $x)))

  (if (f32.lt (local.get $x) (f32.const 0)) (then
    (local.set $x (f32.sub (f32.const 0.0) (local.get $x)))
  ))
  (local.set $x (f32.sub (local.get $x) (f32.trunc (local.get $x))))
  
  (local.set $str (call $wax::alloca (i32.const 16)))
  (i32.store8 (i32.sub (local.get $str) (i32.const 1)) (i32.const 46)  )
  (local.set $ptr (local.get $str))
  
  loop $digits
    
    (local.set $rem (i32.trunc_f32_s (f32.mul (local.get $x) (f32.const 10.0)) ))
    (i32.store8 (local.get $ptr) (i32.add (local.get $rem) (i32.const 48)))

    (local.set $x (f32.sub (f32.mul (local.get $x) (f32.const 10.0)) (f32.convert_i32_s (local.get $rem))) )

    (local.set $ptr (i32.add (local.get $ptr) (i32.const 1)))

    (if (i32.and
      (f32.gt (local.get $x) (f32.const 1.1920928955078126e-7) ) ;; floating-point epsilon
      (i32.lt_s (i32.sub (local.get $ptr) (local.get $str)) (i32.const 15))
    )(then
      (br $digits)
    ))
  end
  (i32.store8 (local.get $ptr) (i32.const 0))

  (local.get $ptr0)
  return

)

(func $wax::str2int (param $s i32) (result i32)
  (local $x i32)
  (local $ptr i32)
  (local $d i32)
  (local $sign i32)
  (local.set $x (i32.const 0))

  (local.set $ptr (local.get $s))

  (local.set $sign (i32.const 1))
  (if (i32.eq (i32.load8_s (local.get $ptr) ) (i32.const 45) ) (then ;;'-'
    (local.set $sign (i32.const -1))
    (local.set $ptr (i32.add (local.get $ptr) (i32.const 1)))
  )(else(if (i32.eq (i32.load8_s (local.get $ptr) ) (i32.const 43) ) (then ;;'+'
    (local.set $ptr (i32.add (local.get $ptr) (i32.const 1))) ;;redundant
  ))))

  loop $digits
    (local.set $d (i32.load8_s (local.get $ptr) ))
    (if (i32.or
      (i32.lt_s (local.get $d) (i32.const 48))
      (i32.gt_s (local.get $d) (i32.const 57))
    )(then
      (i32.mul (local.get $sign) (local.get $x))
      return
    ))
    
    (local.set $x (i32.mul (local.get $x) (i32.const 10)))
    (local.set $x (i32.add (local.get $x) (i32.sub (local.get $d) (i32.const 48))))
    
    (local.set $ptr (i32.add (local.get $ptr) (i32.const 1)))
    (br $digits)
  end

  (i32.mul (local.get $sign) (local.get $x))
  return
)

(func $wax::str2flt (param $s i32) (result f32)
  (local $x f32)
  (local $ptr i32)
  (local $d i32)
  (local $sign f32)
  (local $mlt f32)

  (local.set $x (f32.const 0.0))

  (local.set $ptr (local.get $s))


  (local.set $sign (f32.const 1.0))
  (if (i32.eq (i32.load8_s (local.get $ptr) ) (i32.const 45) ) (then ;;'-'
    (local.set $sign (f32.const -1))
    (local.set $ptr (i32.add (local.get $ptr) (i32.const 1)))
  )(else(if (i32.eq (i32.load8_s (local.get $ptr) ) (i32.const 43) ) (then ;;'+'
    (local.set $ptr (i32.add (local.get $ptr) (i32.const 1))) ;;redundant
  ))))

  block $out
  loop $digits
    (local.set $d (i32.load8_s (local.get $ptr) ))
    (if (i32.eq (local.get $d) (i32.const 46)) (then ;; '.'
      (local.set $ptr (i32.add (local.get $ptr) (i32.const 1)))
      (br $out)
    ))
    (if (i32.or
      (i32.lt_s (local.get $d) (i32.const 48))
      (i32.gt_s (local.get $d) (i32.const 57))
    )(then
      (f32.mul (local.get $sign) (local.get $x))
      return
    ))
    
    (local.set $x (f32.mul (local.get $x) (f32.const 10.0)))
    (local.set $x (f32.add (local.get $x) (f32.convert_i32_s (i32.sub (local.get $d) (i32.const 48)))))
    
    (local.set $ptr (i32.add (local.get $ptr) (i32.const 1)))
    (br $digits)
  end
  end

  (local.set $mlt (f32.const 0.1))
  loop $fracs
    (local.set $d (i32.load8_s (local.get $ptr) ))

    (if (i32.or
      (i32.lt_s (local.get $d) (i32.const 48))
      (i32.gt_s (local.get $d) (i32.const 57))
    )(then
      (f32.mul (local.get $sign) (local.get $x))
      return
    ))
    (local.set $x (f32.add
      (local.get $x)
      (f32.mul (f32.convert_i32_s (i32.sub (local.get $d) (i32.const 48))) (local.get $mlt))
    ))
    (local.set $mlt (f32.mul (local.get $mlt) (f32.const 0.1)))
    
    (local.set $ptr (i32.add (local.get $ptr) (i32.const 1)))

    (br $fracs)
  end

  (f32.mul (local.get $sign) (local.get $x))
  return
)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                  ;;
;;                                  ;;
;;               ARRAY              ;;
;;                                  ;;
;;                                  ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; addapted from https://github.com/LingDong-/wasm-fun

;;   Continous, resizable storage for a sequence of values,
;;   similar to C++ vector<T>
;;
;;   +--------------------+
;;   |data|length|capacity|
;;   +-|------------------+
;;     |        +---------------------------
;;     `------> |elem 0|elem 1|elem 2|......
;;              +---------------------------

;; struct arr {
;;   i32/f32/(void*) data
;;   int length
;;   int capacity
;; }

(global $wax::DEFAULT_CAPACITY (mut i32) (i32.const 8))

;; (internal) getter/setters for arr struct fields

(func $wax::_arr_set_data (param $ptr i32) (param $data i32)
  (i32.store (local.get $ptr) (local.get $data))
)
(func $wax::_arr_set_length (param $ptr i32) (param $length i32)
  (i32.store (i32.add (local.get $ptr) (i32.const 4)) (local.get $length))
)
(func $wax::_arr_set_capacity (param $ptr i32) (param $capacity i32)
  (i32.store (i32.add (local.get $ptr) (i32.const 8)) (local.get $capacity))
)
(func $wax::_arr_get_data (param $ptr i32) (result i32)
  (i32.load (local.get $ptr))
)
(func $wax::_arr_get_capacity (param $ptr i32) (result i32)
  (i32.load (i32.add (local.get $ptr) (i32.const 8)))
)

;; returns length of an array given an arr pointer
(func $wax::arr_length (param $ptr i32) (result i32)
  (i32.load (i32.add (local.get $ptr) (i32.const 4)) )
)

;; initialize a new arr, returns a pointer to it
;; elem_size: size of each element, in bytes
(func $wax::arr_new (param $len i32) (result i32)
  (local $ptr i32)
  (local $cap i32)
  (local $data i32)
  (if (i32.lt_u (local.get $len) (global.get $wax::DEFAULT_CAPACITY)) (then
    (local.set $cap (global.get $wax::DEFAULT_CAPACITY))
  )(else
    (local.set $cap (local.get $len))
  ))
  (local.set $ptr (call $wax::malloc (i32.const 12)))
  (local.set $data (call $wax::calloc (i32.mul (local.get $cap) (i32.const 4))))
  (call $wax::_arr_set_data (local.get $ptr) (local.get $data))
  (call $wax::_arr_set_length (local.get $ptr) (local.get $len))
  (call $wax::_arr_set_capacity (local.get $ptr) (local.get $cap))
  (local.get $ptr)
)

;; free allocated memory given an arr pointer
(func $wax::arr_free (param $a i32)
  (call $wax::free (call $wax::_arr_get_data (local.get $a)))
  (call $wax::free (local.get $a))
)



;; get ith element of an array
(func $wax::arr_get (param $a i32) (param $i i32) (result i32)
  (local $data i32)
  (local $elem_size i32)
  (local.set $data (call $wax::_arr_get_data (local.get $a)))
  (local.set $elem_size (i32.const 4))
  (i32.load (i32.add (i32.mul (local.get $i) (local.get $elem_size)) (local.get $data)))
)

;; set ith element of an array
(func $wax::arr_set (param $a i32) (param $i i32) (param $v i32)
  (local $data i32)
  (local $elem_size i32)
  (local.set $data (call $wax::_arr_get_data (local.get $a)))
  (local.set $elem_size (i32.const 4))
  (i32.store (i32.add (i32.mul (local.get $i) (local.get $elem_size)) (local.get $data)) (local.get $v))
)

;; remove n elements from an array starting at index i
(func $wax::arr_remove (param $a i32) (param $i i32) (param $n i32)
  (local $data i32)
  (local $elem_size i32)
  (local $length i32)
  (local $offset i32)

  (local.set $length (call $wax::arr_length (local.get $a)))
  (local.set $data (call $wax::_arr_get_data (local.get $a)))
  (local.set $elem_size (i32.const 4))

  (local.set $offset 
    (i32.add (local.get $data) (i32.mul (local.get $i) (local.get $elem_size) ))
  )

  (call $wax::memmove 
    (local.get $offset)
    (i32.add (local.get $offset) (i32.mul (local.get $n) (local.get $elem_size)))
    (i32.mul (i32.sub (local.get $length) (i32.add (local.get $i) (local.get $n)) ) (local.get $elem_size))
  )
  (call $wax::_arr_set_length  (local.get $a) (i32.sub (local.get $length) (local.get $n) ))
)


;; add an element to the end of the array
;; does not write the element, instead, returns a pointer
;; to the new last element for the user to write at
(func $wax::arr_push (param $a i32) (result i32)
  (local $length i32)
  (local $capacity i32)
  (local $data i32)
  (local $elem_size i32)

  (local.set $length (call $wax::arr_length (local.get $a)))
  (local.set $capacity (call $wax::_arr_get_capacity (local.get $a)))
  (local.set $data (call $wax::_arr_get_data (local.get $a)))
  (local.set $elem_size (i32.const 4))

  (if (i32.lt_u (local.get $length) (local.get $capacity) ) (then) (else
    (local.set $capacity (i32.add
      (i32.add (local.get $capacity) (i32.const 1))
      (local.get $capacity)
    ))
    (call $wax::_arr_set_capacity (local.get $a) (local.get $capacity))

    (local.set $data 
      (call $wax::realloc (local.get $data) (i32.mul (local.get $elem_size) (local.get $capacity) ))
    )
    (call $wax::_arr_set_data (local.get $a) (local.get $data))
  ))
  (call $wax::_arr_set_length (local.get $a) (i32.add (local.get $length) (i32.const 1)))
  
  ;; (i32.store (i32.add (local.get $data) (i32.mul (local.get $length) (local.get $elem_size))) (i32.const 0))

  (i32.add (local.get $data) (i32.mul (local.get $length) (local.get $elem_size)))
)

;; insert into an array at given index
(func $wax::arr_insert (param $a i32) (param $i i32) (param $v i32)
  (local $data i32)
  (local $elem_size i32)
  (local $length i32)
  (local $offset i32)

  (local.set $length (call $wax::arr_length (local.get $a)))

  (drop (call $wax::arr_push (local.get $a)))

  (local.set $data (call $wax::_arr_get_data (local.get $a)))
  (local.set $elem_size (i32.const 4))

  (local.set $offset 
    (i32.add (local.get $data) (i32.mul (local.get $i) (local.get $elem_size) ))
  )

  (call $wax::memmove
    (i32.add (local.get $offset) (local.get $elem_size))
    (local.get $offset)
    (i32.mul 
      (i32.sub (local.get $length) (local.get $i) ) 
      (local.get $elem_size)
    )
  )

  (i32.store (local.get $offset) (local.get $v))

)

;; slice an array, producing a copy of a range of elements 
;; i = starting index (inclusive), j = stopping index (exclusive)
;; returns pointer to new array
(func $wax::arr_slice (param $a i32) (param $i i32) (param $n i32) (result i32)
  (local $a_length i32)
  (local $length i32)
  (local $elem_size i32)
  (local $ptr i32)
  (local $data i32)
  (local $j i32)

  (local.set $j (i32.add (local.get $i) (local.get $n)))

  (local.set $a_length (call $wax::arr_length (local.get $a)))

  (if (i32.lt_s (local.get $i) (i32.const 0) )(then
    (local.set $i (i32.add (local.get $a_length) (local.get $i)))
  ))
  (if (i32.lt_s (local.get $j) (i32.const 0) )(then
    (local.set $j (i32.add (local.get $a_length) (local.get $j)))
  ))

  (local.set $length (i32.sub (local.get $j) (local.get $i)))
  (local.set $elem_size (i32.const 4))

  (local.set $ptr (call $wax::malloc (i32.const 12)))
  (local.set $data (call $wax::malloc (i32.mul (local.get $length) (local.get $elem_size))))
  (call $wax::_arr_set_data (local.get $ptr) (local.get $data))
  (call $wax::_arr_set_length (local.get $ptr) (local.get $length))
  (call $wax::_arr_set_capacity (local.get $ptr) (local.get $length))

  (call $wax::memcpy (local.get $data) 
    (i32.add
      (call $wax::_arr_get_data (local.get $a))
      (i32.mul (local.get $i) (local.get $elem_size))
    )
    (i32.mul (local.get $length) (local.get $elem_size))
  )

  (local.get $ptr)
)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                  ;;
;;                                  ;;
;;                MAP               ;;
;;                                  ;;
;;                                  ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; adapted from https://github.com/LingDong-/wasm-fun

;;   Hash table (separate chaining with linked lists)
;;   similar to C++ map<T,T>.
;;
;;   Entire key is stored in map node; val is 32 bit int/float/pointer
;;
;;   Functions involving keys have two versions, *_i and *_h.
;;   _i takes an i32 as key directly (for simple small keys), 
;;   while _h versions read the key from the heap given a 
;;   pointer and a byte count (for larger keys)
;;
;;   +-----------+
;;   |num_buckets|          ,----------------------.
;;   |-----------|        +-|-------------------+  |  +---------------------+
;;   | bucket 0  |------->|next|key_size|key|val|  `->|next|key_size|key|val|
;;   |-----------|        +---------------------+     +---------------------+
;;   | bucket 1  |
;;   |-----------|        +---------------------+
;;   | bucket 2  |------->|next|key_size|key|val|
;;   |-----------|        +---------------------+
;;   | ......... |


;; struct map{
;;   int num_buckets;
;;   int length;
;;   mapnode* bucket0;
;;   mapnode* bucket1;
;;   mapnode* bucket2;
;;   ...
;; }
;; struct mapnode{
;;   mapnode* next;
;;   int key_size;
;;   key_t key;
;;   int val;
;; }

;; (internal) getters and setters for map struct

(func $wax::_map_get_num_buckets (param $m i32) (result i32)
  (i32.load (local.get $m))
)
(func $wax::_map_set_num_buckets (param $m i32) (param $num_buckets i32)
  (i32.store (local.get $m) (local.get $num_buckets))
)
(func $wax::map_length (param $m i32) (result i32)
  (i32.load (i32.add (local.get $m) (i32.const 4)))
)
(func $wax::_map_inc_length (param $m i32) (param $dx i32)
  (local $l i32)
  (local $o i32)
  (local.set $o (i32.add (local.get $m) (i32.const 4)))
  (local.set $l (i32.load (local.get $o)))
  (i32.store (local.get $o) (i32.add (local.get $l) (local.get $dx)))
)
(func $wax::_map_get_bucket (param $m i32) (param $i i32) (result i32)
  (i32.load (i32.add 
    (i32.add (local.get $m) (i32.const 8)) 
    (i32.mul (local.get $i) (i32.const 4))
  ))
)
(func $wax::_map_set_bucket (param $m i32) (param $i i32) (param $ptr i32)
  (i32.store (i32.add 
    (i32.add (local.get $m) (i32.const 8)) 
    (i32.mul (local.get $i) (i32.const 4))
  ) (local.get $ptr) )
)

;; (internal) getters and setters for map node struct

(func $wax::_mapnode_get_next (param $m i32) (result i32)
  (i32.load (local.get $m))
)
(func $wax::_mapnode_get_key_size (param $m i32) (result i32)
  (i32.load (i32.add (local.get $m) (i32.const 4)))
)
(func $wax::_mapnode_get_key_ptr (param $m i32) (result i32)
  (i32.add (local.get $m) (i32.const 8))
)
(func $wax::_mapnode_get_val_ptr (param $m i32) (result i32)
  (local $key_size i32)
  (local.set $key_size (call $wax::_mapnode_get_key_size (local.get $m)))
  (i32.add (i32.add (local.get $m) (i32.const 8)) (local.get $key_size))
)

(func $wax::_mapnode_set_next (param $m i32) (param $v i32)
  (i32.store (local.get $m) (local.get $v))
)
(func $wax::_mapnode_set_key_size (param $m i32) (param $v i32)
  (i32.store (i32.add (local.get $m) (i32.const 4)) (local.get $v))
)

(func $wax::_mapnode_set_key_h (param $m i32) (param $key_ptr i32) (param $key_size i32)
  (local $ptr i32)
  (local $i i32)
  (local.set $ptr (call $wax::_mapnode_get_key_ptr (local.get $m)))
  loop $loop_mapnode_set_key_h
    (i32.store8 
      (i32.add (local.get $ptr) (local.get $i))
      (i32.load8_u (i32.add (local.get $key_ptr) (local.get $i)))
    )
    (local.set $i (i32.add (local.get $i) (i32.const 1)))
    (br_if $loop_mapnode_set_key_h (i32.lt_u (local.get $i) (local.get $key_size) ))
  end
)
(func $wax::_mapnode_set_key_i (param $m i32) (param $key i32)
  (i32.store
    (call $wax::_mapnode_get_key_ptr (local.get $m))
    (local.get $key) 
  )
)

;; Hash functions

;; hash an integer with SHR3
(func $wax::_map_hash_i (param $num_buckets i32) (param $key i32) (result i32)
  (local.set $key (i32.xor (local.get $key) (i32.shl   (local.get $key) (i32.const 17))))
  (local.set $key (i32.xor (local.get $key) (i32.shr_u (local.get $key) (i32.const 13))))
  (local.set $key (i32.xor (local.get $key) (i32.shl   (local.get $key) (i32.const 5 ))))
  (i32.rem_u (local.get $key) (local.get $num_buckets))
)

;; hash a sequence of bytes by xor'ing them into an integer and calling _map_hash_i
(func $wax::_map_hash_h (param $num_buckets i32) (param $key_ptr i32) (param $key_size i32) (result i32)
  (local $key i32)
  (local $i i32)
  (local $byte i32)

  (local.set $i (i32.const 0))
  loop $loop_map_hash_h
    (local.set $byte (i32.load8_u (i32.add (local.get $key_ptr) (local.get $i))))
    
    (local.set $key
      (i32.xor (local.get $key) 
        (i32.shl (local.get $byte) (i32.mul (i32.const 8) (i32.rem_u (local.get $i) (i32.const 4))))
      )
    )
    (local.set $i (i32.add (local.get $i) (i32.const 1)))
    (br_if $loop_map_hash_h (i32.lt_u (local.get $i) (local.get $key_size) ))
  end

  (call $wax::_map_hash_i (local.get $num_buckets) (local.get $key))
)

;; initialize a new map, given number of buckets
;; returns a pointer to the map
(func $wax::map_new (param $num_buckets i32) (result i32)
  (local $m i32)
  (local $i i32)
  (local.set $m (call $wax::malloc (i32.add (i32.mul (local.get $num_buckets) (i32.const 4)) (i32.const 8)) ))
  (call $wax::_map_set_num_buckets (local.get $m) (local.get $num_buckets))

  (local.set $i (i32.const 0))
  loop $loop_map_new_clear
    (call $wax::_map_set_bucket (local.get $m) (local.get $i) (i32.const 0))
    (local.set $i (i32.add (local.get $i) (i32.const 1)))
    (br_if $loop_map_new_clear (i32.lt_u (local.get $i) (local.get $num_buckets) ))
  end
  (local.get $m)
)

;; compare the key stored in a node agianst a key on the heap
(func $wax::_map_cmp_key_h (param $node i32) (param $key_ptr i32) (param $key_size i32) (result i32)
  (local $key_ptr0 i32)
  (local $key_size0 i32)
  (local $i i32)
  (local.set $key_ptr0 (call $wax::_mapnode_get_key_ptr (local.get $node)))
  (local.set $key_size0 (call $wax::_mapnode_get_key_size (local.get $node)))
  (if (i32.eq (local.get $key_size0) (local.get $key_size))(then
    (local.set $i (i32.const 0))
    loop $loop_map_cmp_key_h

      (if (i32.eq 
        (i32.load8_u (i32.add (local.get $key_ptr0) (local.get $i)))
        (i32.load8_u (i32.add (local.get $key_ptr ) (local.get $i)))
      )(then)(else
        (i32.const 0)
        return
      ))
      (local.set $i (i32.add (local.get $i) (i32.const 1)))
      (br_if $loop_map_cmp_key_h (i32.lt_u (local.get $i) (local.get $key_size) ))
    end
    (i32.const 1)
    return
  ))
  (i32.const 0)
  return
)

;; compare the key stored in a node agianst a key passed directly as i32 argument
(func $wax::_map_cmp_key_i (param $node i32) (param $key i32) (result i32)
  (local $key_ptr0 i32)
  (local $key_size0 i32)
  (local.set $key_ptr0 (call $wax::_mapnode_get_key_ptr (local.get $node)))
  (local.set $key_size0 (call $wax::_mapnode_get_key_size (local.get $node)))

  (if (i32.eq (local.get $key_size0) (i32.const 4))(then
    (i32.eq (i32.load (local.get $key_ptr0))  (local.get $key) )
    return
  ))
  (i32.const 0)
  return
)

;; insert a new entry to the map, taking a key stored on the heap
;; m : the map
;; key_ptr: pointer to the key on the heap
;; key_size: size of the key in bytes
;; returns pointer to the value inserted in the map for the user to write at

(func $wax::map_set_h (param $m i32) (param $key_ptr i32) (param $val i32)
  (local $num_buckets i32)
  (local $hash i32)
  (local $it i32)
  (local $node_size i32)
  (local $prev i32)
  (local $key_size i32)
  (local.set $key_size (i32.add (call $wax::str_len (local.get $key_ptr)) (i32.const 1)))

  (local.set $num_buckets (call $wax::_map_get_num_buckets (local.get $m)))
  (local.set $hash (call $wax::_map_hash_h (local.get $num_buckets) (local.get $key_ptr) (local.get $key_size)))
  
  (local.set $it (call $wax::_map_get_bucket (local.get $m) (local.get $hash)))
  (local.set $node_size (i32.add (local.get $key_size) (i32.const 12) ))


  (if (i32.eqz (local.get $it))(then
    (local.set $it (call $wax::malloc (local.get $node_size)))

    (call $wax::_mapnode_set_key_size (local.get $it) (local.get $key_size))
    (call $wax::_mapnode_set_next (local.get $it) (i32.const 0))
    (call $wax::_mapnode_set_key_h (local.get $it) (local.get $key_ptr) (local.get $key_size))

    (call $wax::_map_set_bucket (local.get $m) (local.get $hash) (local.get $it))

    (i32.store (call $wax::_mapnode_get_val_ptr (local.get $it)) (local.get $val))
    (call $wax::_map_inc_length (local.get $m) (i32.const 1))
    return
  )(else
    (local.set $prev (i32.const 0))
    loop $loop_map_set_h
      (if (i32.eqz (local.get $it))(then)(else
        (if (call $wax::_map_cmp_key_h (local.get $it) (local.get $key_ptr) (local.get $key_size) )(then
          (local.set $it (call $wax::realloc (local.get $it) (local.get $node_size)))

          (if (i32.eqz (local.get $prev)) (then
            (call $wax::_map_set_bucket (local.get $m) (local.get $hash) (local.get $it))
          )(else
            (call $wax::_mapnode_set_next (local.get $prev) (local.get $it))
          ))
          (i32.store (call $wax::_mapnode_get_val_ptr (local.get $it)) (local.get $val))
          return
        ))
        (local.set $prev (local.get $it))
        (local.set $it (call $wax::_mapnode_get_next (local.get $it)))
        (br $loop_map_set_h)
      ))
    end
    (local.set $it (call $wax::malloc (local.get $node_size)))
    (call $wax::_mapnode_set_key_size (local.get $it) (local.get $key_size))
    (call $wax::_mapnode_set_next (local.get $it) (i32.const 0))
    (call $wax::_mapnode_set_key_h (local.get $it) (local.get $key_ptr) (local.get $key_size))

    (call $wax::_mapnode_set_next (local.get $prev) (local.get $it))
    (i32.store (call $wax::_mapnode_get_val_ptr (local.get $it)) (local.get $val))
    (call $wax::_map_inc_length (local.get $m) (i32.const 1))
    return
  ))

)

;; insert a new entry to the map, taking a key passed directly as i32 argument
;; m : the map
;; key: the key
;; returns pointer to the value inserted in the map for the user to write at

(func $wax::map_set_i (param $m i32) (param $key i32)  (param $val i32)
  (local $num_buckets i32)
  (local $hash i32)
  (local $it i32)
  (local $node_size i32)
  (local $prev i32)

  (local.set $num_buckets (call $wax::_map_get_num_buckets (local.get $m)))
  (local.set $hash (call $wax::_map_hash_i (local.get $num_buckets) (local.get $key)))
  
  (local.set $it (call $wax::_map_get_bucket (local.get $m) (local.get $hash)))
  (local.set $node_size (i32.const 16) )


  (if (i32.eqz (local.get $it))(then
    (local.set $it (call $wax::malloc (local.get $node_size)))

    (call $wax::_mapnode_set_key_size (local.get $it) (i32.const 4))
    (call $wax::_mapnode_set_next (local.get $it) (i32.const 0))
    (call $wax::_mapnode_set_key_i (local.get $it) (local.get $key))

    (call $wax::_map_set_bucket (local.get $m) (local.get $hash) (local.get $it))

    (i32.store (call $wax::_mapnode_get_val_ptr (local.get $it)) (local.get $val))
    (call $wax::_map_inc_length (local.get $m) (i32.const 1))
    return
  )(else
    (local.set $prev (i32.const 0))
    loop $loop_map_set_i
      (if (i32.eqz (local.get $it))(then)(else
        (if (call $wax::_map_cmp_key_i (local.get $it) (local.get $key) )(then
          (local.set $it (call $wax::realloc (local.get $it) (local.get $node_size)))

          (if (i32.eqz (local.get $prev)) (then
            (call $wax::_map_set_bucket (local.get $m) (local.get $hash) (local.get $it))
          )(else
            (call $wax::_mapnode_set_next (local.get $prev) (local.get $it))
          ))
          (i32.store (call $wax::_mapnode_get_val_ptr (local.get $it)) (local.get $val))
          return
        ))
        (local.set $prev (local.get $it))
        (local.set $it (call $wax::_mapnode_get_next (local.get $it)))
        (br $loop_map_set_i)
      ))
    end
    (local.set $it (call $wax::malloc (local.get $node_size)))
    (call $wax::_mapnode_set_key_size (local.get $it) (i32.const 4))
    (call $wax::_mapnode_set_next (local.get $it) (i32.const 0))
    (call $wax::_mapnode_set_key_i (local.get $it) (local.get $key))

    (call $wax::_mapnode_set_next (local.get $prev) (local.get $it))
    (i32.store (call $wax::_mapnode_get_val_ptr (local.get $it)) (local.get $val))
    (call $wax::_map_inc_length (local.get $m) (i32.const 1))
    return
  ))

)

;; lookup a key for its value in the map, taking a key stored on the heap
;; m : the map
;; key_ptr: pointer to the key on the heap
;; key_size: size of the key in bytes
;; returns pointer to the value in the map, NULL (0) if not found.

(func $wax::map_get_h (param $m i32) (param $key_ptr i32) (result i32)
  (local $num_buckets i32)
  (local $hash i32)
  (local $it i32)
  (local $key_size i32)
  (local.set $key_size (i32.add (call $wax::str_len (local.get $key_ptr)) (i32.const 1)))

  (local.set $num_buckets (call $wax::_map_get_num_buckets (local.get $m)))
  (local.set $hash (call $wax::_map_hash_h (local.get $num_buckets) (local.get $key_ptr) (local.get $key_size)))
  (local.set $it (call $wax::_map_get_bucket (local.get $m) (local.get $hash)))

  loop $loop_map_get_h
    (if (i32.eqz (local.get $it))(then)(else
      (if (call $wax::_map_cmp_key_h (local.get $it) (local.get $key_ptr) (local.get $key_size) )(then
        (i32.load (call $wax::_mapnode_get_val_ptr (local.get $it)))
        return
      ))
      (local.set $it (call $wax::_mapnode_get_next (local.get $it)))
      (br $loop_map_get_h)
    ))
  end

  (i32.const 0)
)

;; lookup a key for its value in the map, taking a key passed directly as i32 argument
;; m : the map
;; key : the key
;; returns pointer to the value in the map, NULL (0) if not found.

(func $wax::map_get_i (param $m i32) (param $key i32) (result i32)
  (local $num_buckets i32)
  (local $hash i32)
  (local $it i32)

  (local.set $num_buckets (call $wax::_map_get_num_buckets (local.get $m)))
  (local.set $hash (call $wax::_map_hash_i (local.get $num_buckets) (local.get $key)))
  (local.set $it (call $wax::_map_get_bucket (local.get $m) (local.get $hash)))

  loop $loop_map_get_i
    (if (i32.eqz (local.get $it))(then)(else
      (if (call $wax::_map_cmp_key_i (local.get $it) (local.get $key) )(then
        (i32.load (call $wax::_mapnode_get_val_ptr (local.get $it)))
        return
      ))
      (local.set $it (call $wax::_mapnode_get_next (local.get $it)))
      (br $loop_map_get_i)
    ))
  end

  (i32.const 0)
)

;; remove a key-value pair from the map, given a key stored on the heap
;; m : the map
;; key_ptr: pointer to the key on the heap
;; key_size: size of the key in bytes

(func $wax::map_remove_h (param $m i32) (param $key_ptr i32) (param $key_size i32)
  (local $num_buckets i32)
  (local $hash i32)
  (local $it i32)
  (local $prev i32)
  (local $next i32)

  (local.set $num_buckets (call $wax::_map_get_num_buckets (local.get $m)))
  (local.set $hash (call $wax::_map_hash_h (local.get $num_buckets) (local.get $key_ptr) (local.get $key_size)))
  (local.set $it (call $wax::_map_get_bucket (local.get $m) (local.get $hash)))
  
  (local.set $prev (i32.const 0))

  loop $loop_map_remove_h
    (if (i32.eqz (local.get $it))(then)(else
      (if (call $wax::_map_cmp_key_h (local.get $it) (local.get $key_ptr) (local.get $key_size) )(then
        (local.set $next (call $wax::_mapnode_get_next (local.get $it)))

        (if (i32.eqz (local.get $prev)) (then
          (call $wax::_map_set_bucket (local.get $m) (local.get $hash) (local.get $next))
        )(else
          (call $wax::_mapnode_set_next (local.get $prev) (local.get $next))
        ))
        (call $wax::free (local.get $it))
        (call $wax::_map_inc_length (local.get $m) (i32.const -1))
        return
      ))
      (local.set $prev (local.get $it))
      (local.set $it (local.get $next))
      (br $loop_map_remove_h)
    ))
  end
)

;; remove a key-value pair from the map, given a key passed directly as i32 argument
;; m : the map
;; key : the key
(func $wax::map_remove_i (param $m i32) (param $key i32)
  (local $num_buckets i32)
  (local $hash i32)
  (local $it i32)
  (local $prev i32)
  (local $next i32)

  (local.set $num_buckets (call $wax::_map_get_num_buckets (local.get $m)))
  (local.set $hash (call $wax::_map_hash_i (local.get $num_buckets) (local.get $key)))
  (local.set $it (call $wax::_map_get_bucket (local.get $m) (local.get $hash)))
  
  (local.set $prev (i32.const 0))

  loop $loop_map_remove_i
    (if (i32.eqz (local.get $it))(then)(else
      (if (call $wax::_map_cmp_key_i (local.get $it) (local.get $key) )(then
        (local.set $next (call $wax::_mapnode_get_next (local.get $it)))

        (if (i32.eqz (local.get $prev)) (then
          (call $wax::_map_set_bucket (local.get $m) (local.get $hash) (local.get $next))
        )(else
          (call $wax::_mapnode_set_next (local.get $prev) (local.get $next))
        ))
        (call $wax::free (local.get $it))
        (call $wax::_map_inc_length (local.get $m) (i32.const 1))
        return
      ))
      (local.set $prev (local.get $it))
      (local.set $it (local.get $next))
      (br $loop_map_remove_i)
    ))
  end
)


;; generate a new iterator for traversing map pairs
;; in effect, this returns a pointer to the first node
(func $wax::map_iter_new  (param $m i32) (result i32)
  (local $num_buckets i32)
  (local $i i32)
  (local $node i32)

  (local.set $num_buckets (call $wax::_map_get_num_buckets (local.get $m)))

  (local.set $i (i32.const 0))
  loop $loop_map_iter_new
    (local.set $node (call $wax::_map_get_bucket (local.get $m) (local.get $i)))
    (if (i32.eqz (local.get $node))(then)(else
      (local.get $node)
      return
    ))
    (local.set $i (i32.add (local.get $i) (i32.const 1)))
    (br_if $loop_map_iter_new (i32.lt_u (local.get $i) (local.get $num_buckets) ))
  end
  (i32.const 0)
  return
)

;; increment an interator for traversing map pairs
;; in effect, this finds the next node of a given node, by first looking
;; at the linked list, then re-hashing the key to look through the rest of the hash table
(func $wax::map_iter_next (param $m i32) (param $iter i32) (result i32)
  (local $next i32)
  (local $num_buckets i32)
  (local $node i32)
  (local $i i32)
  
  (local.set $num_buckets (call $wax::_map_get_num_buckets (local.get $m)))

  (local.set $next (call $wax::_mapnode_get_next (local.get $iter)))

  (if (i32.eqz (local.get $next))(then

    (local.set $i (i32.add (call $wax::_map_hash_h
      (local.get $num_buckets)
      (call $wax::_mapnode_get_key_ptr  (local.get $iter))
      (call $wax::_mapnode_get_key_size (local.get $iter))
    ) (i32.const 1)))

    
    (if (i32.eq (local.get $i) (local.get $num_buckets)) (then
      (i32.const 0)
      return
    ))
    
    loop $loop_map_iter_next
      (local.set $node (call $wax::_map_get_bucket (local.get $m) (local.get $i)))
      (if (i32.eqz (local.get $node))(then)(else
        (local.get $node)
        return
      ))
      (local.set $i (i32.add (local.get $i) (i32.const 1)))
      (br_if $loop_map_iter_next (i32.lt_u (local.get $i) (local.get $num_buckets) ))
    end

    (i32.const 0)
    return

  )(else
    (local.get $next)
    return
  ))
  (i32.const 0)
  return
)

;; given a map iterator, get a pointer to the key stored
(func $wax::map_iter_key_h (param $iter i32) (result i32)
  (call $wax::_mapnode_get_key_ptr (local.get $iter))
)
;; given a map iterator, read the key stored as an int
;; only works if your key is an i32
(func $wax::map_iter_key_i (param $iter i32) (result i32)
  (i32.load (call $wax::_mapnode_get_key_ptr (local.get $iter)))
)
;; given a map iterator, get a pointer to the value stored
(func $wax::map_iter_val (param $iter i32) (result i32)
  (i32.load (call $wax::_mapnode_get_val_ptr (local.get $iter)))
)

;; remove all key-values in the map
(func $wax::map_clear (param $m i32)
  (local $num_buckets i32)
  (local $hash i32)
  (local $it i32)

  (local $next i32)

  (local.set $num_buckets (call $wax::_map_get_num_buckets (local.get $m)))

  (local.set $hash (i32.const 0))

  loop $loop_map_clear_buckets

    (local.set $it (call $wax::_map_get_bucket (local.get $m) (local.get $hash)))

    loop $loop_map_clear_nodes
      (if (i32.eqz (local.get $it))(then)(else
        (local.set $next (call $wax::_mapnode_get_next (local.get $it)))

        (call $wax::free (local.get $it))

        (local.set $it (local.get $next))
        (br $loop_map_clear_nodes)
      ))
    end

    (call $wax::_map_set_bucket (local.get $m) (local.get $hash) (i32.const 0))

    (local.set $hash (i32.add (local.get $hash) (i32.const 1)))
    (br_if $loop_map_clear_buckets (i32.lt_u (local.get $hash) (local.get $num_buckets)))

  end  
)

;; free all allocated memory for a map
(func $wax::map_free (param $m i32)
  (call $wax::map_clear (local.get $m))
  (call $wax::free (local.get $m))
)
;;=== WAX Standard Library END   ===;;

)
