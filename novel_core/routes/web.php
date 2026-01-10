<?php

/** @var \Laravel\Lumen\Routing\Router $router */

/*
|--------------------------------------------------------------------------
| Application Routes
|--------------------------------------------------------------------------
|
| Here is where you can register all of the routes for an application.
| It is a breeze. Simply tell Lumen the URIs it should respond to
| and give it the Closure to call when that URI is requested.
|
*/

$router->get('/', function () use ($router) {
    return $router->app->version();
});

// Public Routes (Read Only)
$router->get('/novels', 'NovelController@index');
$router->get('/novels/{id}', 'NovelController@show');
$router->get('/chapters/{id}', 'ChapterController@show');

// Admin Routes (Protected)
$router->group(['middleware' => 'auth'], function () use ($router) {
    $router->post('/novels', 'NovelController@store');
    $router->put('/novels/{id}', 'NovelController@update');
    $router->delete('/novels/{id}', 'NovelController@destroy');

    $router->post('/novels/{novelId}/chapters', 'ChapterController@store');
    $router->put('/chapters/{id}', 'ChapterController@update');
});
