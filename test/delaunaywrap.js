const wrapper = require("../tools/waxwasmwrap.js");
wrapper("delaunay.wasm",function(lib){
  lib.main();
});
