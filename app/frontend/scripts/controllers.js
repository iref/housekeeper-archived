'use strict';

var controllers = angular.module("housekeeperControllers", []);

controllers.controller('UserController', function ($scope, $window, ProfileService) {

    $scope.disconnect = function () {
        ProfileService.disconnect().then(function () {
            $scope.userProfile = {};
            $scope.hasUserProfile = false;
            $scope.isSignedIn = false;
            $scope.immediateFailed = true;
        });
    };

    $scope.signedIn = function (profile) {
        $scope.userProfile = profile;
        $scope.hasUserProfile = true;
        $scope.isSignedIn = true;
        $scope.immediateFailed = false;

        // Save user access token to session
        $window.sessionStorage.token = profile.token
    };

    $scope.signIn = function (authData) {
        $scope.$apply(function () {
            $scope.processAuthentication(authData);
        });
    }

    $scope.processAuthentication = function (authResults) {
        $scope.immediateFailed = false;
        if ($scope.isSignedIn) {
            return;
        }

        if (authResults["access_token"]) {
            // authorize on server and create session
            ProfileService.connect(authResults).then(function (profile) {
                $scope.signedIn(profile);
            });
        } else if (authResults["error"] === 'immediate_failed') {
            $scope.immediateFailed = true;
        } else {
            $('#notifier').addClass("error").html("Oopps!! Something went wrong. Please, try again!!");
        }
    }

    $scope.renderSignInButton = function () {
        gapi.signin.render('gsignin', {
            "callback": $scope.signIn,
            "clientid": "541401950578.apps.googleusercontent.com",
            "theme": "dark",
            "cookiepolicy": "single_host_origin",
            "scope": "https://www.googleapis.com/auth/plus.login email profile"            
        });
    }

    function init() {
        $scope.userProfile = {};
        $scope.hasUserProfile = false;
        $scope.isSignedIn = false;
        $scope.hideImmediately = true;

        $scope.renderSignInButton();
    };

    init();
});
