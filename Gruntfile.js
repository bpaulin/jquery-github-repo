/*global module:false*/
module.exports = function(grunt) {
  // Project configuration.
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    uglify: {
      plugin: {
        files: [{
          expand: true,
          cwd: 'dist/',
          src: '*.js',
          dest: 'dist/',
          ext: '.min.js'
        }],
        options: {
          banner : '/*! <%= pkg.title || pkg.name %> - v<%= pkg.version %> - ' +
            '<%= grunt.template.today("yyyy-mm-dd") %>\n' +
            '<%= pkg.homepage ? "* " + pkg.homepage + "\\n" : "" %>' +
            '* Copyright (c) <%= grunt.template.today("yyyy") %> <%= pkg.author.name %>;' +
            ' Licensed <%= _.pluck(pkg.licenses, "type").join(", ") %> */\n'
        }
      }
    },
    coffee : {
      plugin : {
        files: [{
          expand: true,
          cwd: 'src/',
          src: '*.coffee',
          dest: 'dist/',
          ext: '.js'
        }]
      },
      specs : {
        files: [{
          expand: true,
          cwd: 'spec/',
          src: '*.coffee',
          dest: 'spec/javascripts/',
          ext: '.js'
        }]
      },
      helpers : {
        files: [{
          expand: true,
          cwd: 'spec//helpers/',
          src: '*.coffee',
          dest: 'spec/javascripts/helpers/',
          ext: '.js'
        }]
      }
    },
    jasmine : {
      src     : ['dist/*.js','!dist/*.min.js'],
      options : {
        specs   : 'spec/javascripts/*.js',
        helpers : [
          'spec/javascripts/helpers/*.js',
          "node_modules/jquery/dist/jquery.min.js"
          ],
        vendor : [
          "node_modules/jquery/dist/jquery.min.js",
          "node_modules/jasmine-jquery/lib/jasmine-jquery.js",
        ]
      }
    },
    watch : {
      files: [
        'src/*.coffee',
        'spec/**/*.coffee',
        'spec/javascripts/fixtures/**/*'
      ],
      tasks: ['default']
    },
    growl : {
      coffeelint : {
        title   : 'Coffee Lint',
        message : 'Coffee linted successfully'
      },
      coffee : {
        title   : 'CoffeeScript',
        message : 'Compiled successfully'
      },
      jasmine : {
        title   : 'Jasmine',
        message : 'Tests passed successfully'
      }
    },
    clean: {
      files: ['dist/**/*.js', 'spec/**/*.js']
    },
    coffeelint: {
      app: ['src/**/*.coffee', 'spec/**/*.coffee']
    }
  });

  // Lib tasks.
  grunt.loadNpmTasks('grunt-growl');
  grunt.loadNpmTasks('grunt-contrib-jasmine');
  grunt.loadNpmTasks('grunt-contrib-coffee');
  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-contrib-uglify');
  grunt.loadNpmTasks('grunt-contrib-clean');
  grunt.loadNpmTasks('grunt-coffeelint');

  // Default and Build tasks
  mainTasks = ['clean', 'coffeelint', 'coffee', 'jasmine']
  grunt.registerTask('default', mainTasks.concat(['uglify']));

  // Travis CI task.
  grunt.registerTask('test', mainTasks);
};
