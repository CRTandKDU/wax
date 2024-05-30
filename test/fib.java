/*****************************************
 * fib                                   *
 *****************************************/
/* Compiled by WAXC (Version May 25 2024)*/

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

public class fib{
/*=== WAX Standard Library BEGIN ===*/
public static <T> void w_arrRemove(ArrayList<T> a, int i, int n){a.subList(i,i+n).clear();}
public static <T> ArrayList<T> w_arrSlice(ArrayList<T> a, int i, int n){return new ArrayList<T>(a.subList(i,i+n));}
public static String w_strSlice(String a, int i, int n){return a.substring(i,i+n);}
public static <K,V> V w_mapGet(HashMap<K,V> map, K key, V defaultValue) {V v;return (((v = map.get(key)) != null) || map.containsKey(key))? v: defaultValue;}
public static boolean w_BOOL(int x){return x!=0;}
public static int w_INT(boolean x){return x?1:0;}
public static int w_NOT(int x){return (x==0)?1:0;}
/*=== WAX Standard Library END   ===*/

/*=== User Code            BEGIN ===*/
  public static int fib(int i){
    if(w_BOOL(w_INT((int)(i)<=(int)(1)))){
      return i;
    };
    return ((fib(((i)-(1))))+(fib(((i)-(2)))));
  };
  public static int main_(){
    int x=0;
    x=fib(9);
    System.out.println(String.valueOf(x));
    return 0;
  };
/*=== User Code            END   ===*/
  public static void main(String[] args){
    System.exit(main_());
  }
}