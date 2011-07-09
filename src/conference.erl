-module(conference).

-export([start_link/0, assign_room/0]).

-behaviour(gen_server).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
	 terminate/2, code_change/3]).

-record(state, {
	  room :: none | {integer(), integer(), integer()}
	 }).

% --- api ---

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

assign_room() ->
    gen_server:call(?MODULE, assign_room).

% --- gen_server callbacks ---

init([]) ->
    {ok, #state{room=none}}.

handle_call(assign_room, _From, State = #state{room=Room}) ->
    case Room of
	none ->
	    Room2 = now(),
	    {reply, {first, Room2}, State#state{room=Room2}};
	_ ->
	    {reply, {second, Room}, State#state{room=none}}
    end.

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.
