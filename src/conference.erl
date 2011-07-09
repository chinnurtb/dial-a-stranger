-module(conference).

-export([start_link/0, new_call/1, end_call/1]).

-behaviour(gen_server).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
	 terminate/2, code_change/3]).

-record(state, {
	  room :: none | {integer(), integer(), integer()},
	  callers :: dict() % maps callers to rooms
	 }).

% --- api ---

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

new_call(Caller) ->
    gen_server:call(?MODULE, {new_call, Caller}).

end_call(Caller) ->
    gen_server:call(?MODULE, {end_call, Caller}).

% --- gen_server callbacks ---

init([]) ->
    {ok, #state{room=none, callers=dict:new()}}.

handle_call({new_call, Caller}, _From, State=#state{room=Room, callers=Callers}) ->
    case Room of
	none ->
	    Order = first,
	    Caller_room = now(),
	    Room2 = Caller_room;
	_ ->
	    Order = second,
	    Caller_room = Room,
	    Room2 = none
    end,
    Callers2 = dict:store(Caller, Caller_room, Callers),
    {reply, {Order, Caller_room}, State#state{room=Room2, callers=Callers2}};
handle_call({end_call, Caller}, _From, State=#state{room=Room, callers=Callers}) ->
    {ok, Caller_room} = dict:find(Caller, Callers),
    Callers2 = dict:erase(Caller, Callers),
    if 
	Room == Caller_room ->
	    {reply, ok, State#state{room=none, callers=Callers2}};
	true ->
	    {reply, ok, State#state{callers=Callers2}}
    end.

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.
