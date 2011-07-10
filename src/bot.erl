-module(bot).

-include("conf.hrl").
-include("log.hrl").

-export([start_link/0, recv/2]).

-behaviour(gen_server).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
	 terminate/2, code_change/3]).

-record(state, {
	  bots :: dict(), % maps phone numbers to active bots
	  numbers :: dict() % maps active bots to phone numbers
	 }).

% --- api ---

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

recv(Number, Body) ->
    gen_server:cast(?MODULE, {recv, Number, Body}).

% --- gen_server callbacks ---

init([]) ->
    {ok, #state{bots=dict:new(), numbers=dict:new()}}.

handle_call(_Msg, _Number, State) ->
    {noreply, State}.

handle_cast({recv, Number, Body}, State=#state{bots=Bots, numbers=Numbers}) ->
    case dict:find(Number, Bots) of
	error ->
	    ?INFO([recv, {number, Number}, new_bot]),
	    Bot = open_port({spawn, "./bots/eliza.py"},[{packet, 2}]),
	    Bots2 = dict:store(Number, Bot, Bots),
	    Numbers2 = dict:store(Bot, Number, Numbers);
	{ok, Value} ->
	    ?INFO([recv, {number, Number}, {bot, Value}]),
	    Bot = Value,
	    Bots2 = Bots,
	    Numbers2 = Numbers
    end,
    port_command(Bot, Body),
    {noreply, State#state{bots=Bots2, numbers=Numbers2}}.

handle_info({Bot, {data, Data}}, State=#state{numbers=Numbers}) ->
    {ok, Number} = dict:find(Bot, Numbers),
    ?INFO([send, {number, Number}, {bot, Bot}, {data, Data}]),
    twilio:send_sms(Number, ?BotNumber, Data),
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.
