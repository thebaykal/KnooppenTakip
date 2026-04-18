import Toybox.Application;
import Toybox.WatchUi;

class KnooppenTakipApp extends Application.AppBase {

    function initialize() {
        Application.AppBase.initialize();
    }

    function getInitialView() {
        return [ new KnooppenTakipView() ];
    }
}
