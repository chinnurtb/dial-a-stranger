%% @author author <author@example.com>
%% @copyright YYYY author.

%% @doc dial_a_stranger startup code

-module(dial_a_stranger).
-author('author <author@example.com>').
-export([start/0, start_link/0, stop/0]).

ensure_started(App) ->
    case application:start(App) of
        ok ->
            ok;
        {error, {already_started, App}} ->
            ok
    end.

%% @spec start_link() -> {ok,Pid::pid()}
%% @doc Starts the app for inclusion in a supervisor tree
start_link() ->
    ensure_started(inets),
    ensure_started(crypto),
    ensure_started(public_key),
    ensure_started(ssl),
    ensure_started(mochiweb),
    application:set_env(webmachine, webmachine_logger_module, 
                        webmachine_logger),
    ensure_started(webmachine),
    dial_a_stranger_sup:start_link().

%% @spec start() -> ok
%% @doc Start the dial_a_stranger server.
start() ->
    ensure_started(inets),
    ensure_started(crypto),
    ensure_started(public_key),
    ensure_started(ssl),
    ensure_started(mochiweb),
    application:set_env(webmachine, webmachine_logger_module, 
                        webmachine_logger),
    ensure_started(webmachine),
    application:start(dial_a_stranger).

%% @spec stop() -> ok
%% @doc Stop the dial_a_stranger server.
stop() ->
    Res = application:stop(dial_a_stranger),
    application:stop(webmachine),
    application:stop(mochiweb),
    application:stop(public_key),
    application:stop(ssl),
    application:stop(crypto),
    application:stop(inets),
    Res.
