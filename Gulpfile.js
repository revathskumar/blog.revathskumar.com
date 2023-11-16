var gulp = require("gulp");
var concat = require("gulp-concat");
var cleanCSS = require("gulp-clean-css");

gulp.task("css", function (done) {
  gulp
    .src(["./css/main.css"])
    .pipe(cleanCSS())
    .pipe(concat("blog.min.css"))
    .pipe(gulp.dest("./css/"));
  done();
});
