var gulp = require('gulp');
var jshint = require('gulp-jshint');
var concat = require('gulp-concat');
var rename = require('gulp-rename');
var uglify = require('gulp-uglify');
var csso = require('gulp-csso');

var js_files = ['../../SharedResources/scripts/modernizr.js',
                '../../SharedResources/lof/js/nb.build.js',
                '../../CashTracker/classic/js/src-api/*.js',
                './js/*.js',
				'!./js/statistics.js',
				'!./js/*.build.js',
				'!./js/*.min.js'];

var css_files = ['../../SharedResources/css/normalize.css',
                 '../../CashTracker/classic/css/*.css',
                 './css/*.css',
 				 '!../../CashTracker/classic/css/all.min.css',
 				 '!./css/all.min.css'];

gulp.task('lint', function() {
	gulp.src(js_files).pipe(jshint()).pipe(jshint.reporter('default'));
});

gulp.task('minify_js', function() {
	gulp.src(js_files)
		.pipe(concat('app.build.js'))
		.pipe(gulp.dest('./js'))
		.pipe(rename('app.min.js'))
		.pipe(uglify())
		.pipe(gulp.dest('./js'));
});

gulp.task('minify_css', function() {
	gulp.src(css_files)
		.pipe(concat('all.min.css'))
		.pipe(csso())
		.pipe(gulp.dest('./css'));
});

gulp.task('default', function() {
	gulp.run('minify_js', 'minify_css');

	gulp.watch(js_files, function(event) {
		gulp.run('minify_js');
	});

	gulp.watch(css_files, function(event) {
		gulp.run('minify_css');
	});
});
