library utils;

abstract class OAuth1Utils {


  /**
   * Return new Map object removed elements that have key equals keys elements from map.
   */
  static Map _differenceMapKeys(Map map, List keys) {
    Set keysDifference = map.keys.toSet().difference(keys.toSet());
    return new Map.fromIterable(keysDifference, value: (item) => map[item]);
  }
}
