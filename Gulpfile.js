var gulp = require('gulp');
var concat = require('gulp-concat');
var uglify = require('gulp-minify-css');

gulp.task('css', function(){
  gulp.src('./css/*.css')
    .pipe(uglify())
    .pipe(concat('blog.min.css'))
    .pipe(gulp.dest('./css/'));
});
