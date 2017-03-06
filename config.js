if (typeof(APPLIS) == "undefined") {
  var APPLIS = [];
}
if (typeof(MODELS) == "undefined") {
  var MODELS = [];
}
if (typeof(LIBS) == "undefined") {
  var LIBS = [];
}

function array_unique(arr) {
  var result = [];
  for (var i = 0; i < arr.length; i++) {
    if (result.indexOf(arr[i]) == -1) {
      result.push(arr[i]);
    }
  }
  return result;
}

APPLIS = array_unique(APPLIS);
console.log(APPLIS)
MODELS = array_unique(MODELS);
LIBS = array_unique(LIBS);

var config = {
  host: '127.0.0.1',
  user_port: '8888',
  admin_port: '8889',
}
