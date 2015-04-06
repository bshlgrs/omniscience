$(function () {
  var Location = window.Location = function (lat, lon) {
    this.lat = lat;
    this.lon = lon;
  };

  Location.prototype.toArray = function () {
    return [this.lon, this.lat];
  };

  // returns meters
  Location.prototype.distance = function (other) {
    return getDistanceFromLatLonInKm(this.lat, this.lon, other.lat, other.lon) * 1000;
  };

  var getDistanceFromLatLonInKm = function (lat1,lon1,lat2,lon2) {
    var R = 6371; // Radius of the earth in km
    var dLat = deg2rad(lat2-lat1);  // deg2rad below
    var dLon = deg2rad(lon2-lon1); 
    var a = 
      Math.sin(dLat/2) * Math.sin(dLat/2) +
      Math.cos(deg2rad(lat1)) * Math.cos(deg2rad(lat2)) * 
      Math.sin(dLon/2) * Math.sin(dLon/2)
      ; 
    var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a)); 
    var d = R * c; // Distance in km
    return d;
  }

  var deg2rad = function (deg) {
    return deg * (Math.PI/180)
  }

  var events = [];

  $.get("./history-03-22-2015.kml", function (data) {
    var $data = $(data);
    var whens = $data.find("when");
    var coords = $data.find("coord");

    for (var i = 0; i < whens.length; i++) {
      var dateTime = new Date($(whens[i]).text());
      var placeText = $(coords[i]).text().split(" ")
      events.push({ 
        dateTime: dateTime, 
        location: new Location(Number(placeText[0]), Number(placeText[1]))
      });
    };
  
    // $.get("./computer_log", function (log) {
    //   debugger;
    // })
    initializeMaps();
  });

  var initializeMaps = function () {
    var firstLocation = events[0].location;
    // create a map in the "map" div, set the view to a given place and zoom
    
    var map = L.map('map').setView(firstLocation.toArray(), 10);

    // add an OpenStreetMap tile layer
    L.tileLayer('http://{s}.tile.osm.org/{z}/{x}/{y}.png', {
        attribution: '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors'
    }).addTo(map);

    var latLngs = _(events).map(function(x) {
      return x.location.toArray();
    });

    // L.marker(events[0].location.toArray()).bindPopup("hello").addTo(map);

    for (var i = 1; i < events.length; i++) {
      var thisOne = events[i];
      var previousOne = events[i-1];
      var distance = thisOne.location.distance(previousOne.location); // in meters
      var dt = (thisOne.dateTime - previousOne.dateTime) / 1000; // in seconds
      var speed = distance / dt

      L.marker(thisOne.location.toArray()).bindPopup("<p>dx="+distance+", dt="+dt+", speed="+speed+"</p>").addTo(map);
    };


    var polyline = L.polyline(latLngs, {color: 'red'}).addTo(map);
    map.fitBounds(polyline.getBounds());
  }
});