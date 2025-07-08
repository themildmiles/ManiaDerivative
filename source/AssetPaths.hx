
/**
    A simple path system. Inspired by Psych Engine's path system but for assets only.
**/
class AssetPaths {
    static public function font(fontPath:String):String
        return 'assets/fonts/$fontPath';
}