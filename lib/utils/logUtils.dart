/*
 * Created by caowencheng on 2019-07-09
 * @Email 845982120@qq.com
 * @Website https://www.caowencheng.com
 */

class LogUtils {

    static const String _TAG_DEF = "###log_utils###";

    static bool debuggable = true; //是否是debug模式,true: log v 不输出.
    static String TAG = _TAG_DEF;

    static void init({bool isDebug = false, String tag = _TAG_DEF}) {
        debuggable = isDebug;
        tag = tag;
    }

    static void e(Object object, {String tag}) {
        _printLog(tag, '  e  ', object);
    }

    static void v(Object object, {String tag}) {
        if (debuggable) {
            _printLog(tag, '  v  ', object);
        }
    }

    static void _printLog(String tag, String stag, Object object) {
        String da = object.toString();
        String _tag = (tag == null || tag.isEmpty) ? TAG : tag;
        while (da.isNotEmpty) {
            if (da.length > 512) {
                print("$_tag $stag ${da.substring(0, 512)}");
                da = da.substring(512, da.length);
            } else {
                print("$_tag $stag $da");
                da = "";
            }
        }
    }
}