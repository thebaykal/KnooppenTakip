// Waypoints (lat, lon, id)
import Toybox.WatchUi;
import Toybox.Position;
import Toybox.Attention;
import Toybox.Graphics;
import Toybox.Math;

class KnooppenTakipView extends WatchUi.DataField {

    var nodes = [
        [51.489794, 5.50473, "8"],
        [51.504822, 5.496548, "9"],
        [51.511186, 5.493475, "43"],
        [51.521049, 5.502811, "40"],
        [51.530119, 5.489888, "51"],
        [51.54212, 5.50178, "52"],
        [51.555115, 5.525308, "23"],
        [51.54065, 5.567451, "68"],
        [51.517727, 5.594812, "71"],
        [51.51357, 5.606901, "63"],
        [51.515099, 5.623788, "93"],
        [51.509674, 5.637694, "59"],
        [51.512587, 5.651264, "44"],
        [51.504051, 5.652927, "7"],
        [51.496261, 5.652529, "5"],
        [51.494295, 5.640171, "6"],
        [51.474951, 5.632843, "3"],
        [51.490679, 5.610991, "61"],
        [51.483892, 5.604456, "62"],
        [51.467134, 5.608515, "47"],
        [51.454487, 5.594117, "82"],
        [51.448141, 5.603509, "83"],
        [51.445603, 5.577208, "36"],
        [51.431613, 5.541073, "77"],
        [51.445758, 5.536803, "75"],
        [51.450448, 5.527617, "99"],
        [51.460378, 5.529921, "35"],
        [51.467913, 5.520593, "81"],
        [51.470928, 5.514684, "80"],
        [51.468183, 5.506216, "98"]
    ];

    var currentIndex = 0;
    var displayNode = "1";
    var currentLat = 0.0;
    var currentLon = 0.0;
    var lastDistance = 0.0;
    var matchBlink = false;

    function initialize() {
        DataField.initialize();
    }

    function compute(info) {

        var posInfo = Position.getInfo();
        if (posInfo != null && posInfo.position != null) {

            var pos = posInfo.position.toDegrees();
            currentLat = pos[0];
            currentLon = pos[1];

            if (currentIndex < nodes.size()) {

                var target = nodes[currentIndex];
                lastDistance = calculateDist(currentLat, currentLon, target[0], target[1]);

                if (lastDistance < 10) {
                    matchBlink = !matchBlink;
                    Attention.vibrate([ new Attention.VibeProfile(100, 800) ]);
                    currentIndex++;

                    if (currentIndex < nodes.size()) {
                        displayNode = nodes[currentIndex][2];
                    } else {
                        displayNode = "DONE";
                    }
                }
            }
        }

        return lastDistance;
    }

function onUpdate(dc) {
    var w = dc.getWidth();
    var h = dc.getHeight();

    // Arka plan siyah
    dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
    dc.clear();

    // Yazılar beyaz
    dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);

    // LAT / LON (üstte küçük)
    dc.drawText(w/2, h*0.05, Graphics.FONT_XTINY,
                "LAT: " + currentLat.format("%0.6f"),
                Graphics.TEXT_JUSTIFY_CENTER);

    dc.drawText(w/2, h*0.15, Graphics.FONT_XTINY,
                "LON: " + currentLon.format("%0.6f"),
                Graphics.TEXT_JUSTIFY_CENTER);

    // NEXT waypoint
    dc.drawText(w/2, h*0.35, Graphics.FONT_MEDIUM,
                "NEXT: " + displayNode,
                Graphics.TEXT_JUSTIFY_CENTER);

    // Mesafe
    dc.drawText(w/2, h*0.55, Graphics.FONT_LARGE,
                lastDistance.format("%0.0f") + " m",
                Graphics.TEXT_JUSTIFY_CENTER);

    // MATCH göstergesi
    if (matchBlink) {
        dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
        dc.drawText(w/2, h*0.80, Graphics.FONT_MEDIUM,
                    "MATCH",
                    Graphics.TEXT_JUSTIFY_CENTER);
    }
}



    function calculateDist(lat1, lon1, lat2, lon2) {
        var dx = 111320.0 * (lon1 - lon2) * Math.cos(lat1 * 0.01745);
        var dy = 111132.0 * (lat1 - lat2);
        return Math.sqrt(dx * dx + dy * dy);
    }
}
