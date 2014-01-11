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
          dest: 'spec/dist/',
          ext: '.js'
        }]
      },
      helpers : {
        files: [{
          expand: true,
          cwd: 'spec//helpers/',
          src: '*.coffee',
          dest: 'spec/dist/helpers/',
          ext: '.js'
        }]
      }
    },
    jasmine : {
      src     : ['dist/*.js','!js/*.min.js'],
      options : {
        specs   : 'spec/dist/*.js',
        helpers : 'spec/dist/helpers/*.js',
        vendor : [
          "node_modules/jquery/dist/jquery.min.js",
          "node_modules/jasmine-jquery/lib/jasmine-jquery.js",
        ]
      }
    },
    watch : {
      files: [
        'src/*.coffee', 
        'spec/**/*.coffee'
      ],
      tasks: ['coffee', 'growl:coffee', 'jasmine', 'growl:jasmine']
    },
    growl : {
      coffee : {
        title   : 'CoffeeScript',
        message : 'Compiled successfully'
      },
      jasmine : {
        title   : 'Jasmine',
        message : 'Tests passed successfully'
      }
    },
    clean: ["dist", "spec/dist"]
  });

  // Lib tasks.
  grunt.loadNpmTasks('grunt-growl');
  grunt.loadNpmTasks('grunt-contrib-jasmine');
  grunt.loadNpmTasks('grunt-contrib-coffee');
  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-contrib-uglify');
  grunt.loadNpmTasks('grunt-contrib-clean');

  // Default and Build tasks
  mainTasks = ['coffee', 'growl:coffee', 'jasmine', 'growl:jasmine']
  grunt.registerTask('default', mainTasks);
  grunt.registerTask('build', mainTasks.concat(['uglify']));

  // Travis CI task.
  grunt.registerTask('travis', ['coffee', 'jasmine']);
};
