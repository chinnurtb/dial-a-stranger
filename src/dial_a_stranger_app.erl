%% @author author <author@example.com>
%% @copyright YYYY author.

%% @doc Callbacks for the dial_a_stranger application.

-module(dial_a_stranger_app).
-author('author <author@example.com>').

-behaviour(application).
-export([start/2,stop/1]).


%% @spec start(_Type, _StartArgs) -> ServerRet
%% @doc application start callback for dial_a_stranger.
start(_Type, _StartArgs) ->
    dial_a_stranger_sup:start_link().

%% @spec stop(_State) -> ServerRet
%% @doc application stop callback for dial_a_stranger.
stop(_State) ->
    ok.
