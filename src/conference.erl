-module(conference).

-export([start_link/0, new_call/1, end_call/1]).

-behaviour(gen_server).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
	 terminate/2, code_change/3]).

-record(state, {
	  room :: none | {integer(), integer(), integer()},
	  calls :: dict() % maps sids to rooms
	 }).

% --- api ---

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

new_call(Sid) ->
    gen_server:call(?MODULE, {new_call, Sid}).

end_call(Sid) ->
    gen_server:call(?MODULE, {end_call, Sid}).

% --- gen_server callbacks ---

init([]) ->
    {ok, #state{room=none, calls=dict:new()}}.

handle_call({new_call, Sid}, _From, State=#state{room=Room, calls=Calls}) ->
    case Room of
	none ->
	    Order = first,
	    Sid_room = now(),
	    Room2 = Sid_room;
	_ ->
	    Order = second,
	    Sid_room = Room,
	    Room2 = none
    end,
    Calls2 = dict:store(Sid, Sid_room, Calls),
    {reply, {Order, Sid_room}, State#state{room=Room2, calls=Calls2}};
handle_call({end_call, Sid}, _From, State=#state{room=Room, calls=Calls}) ->
    {ok, Sid_room} = dict:find(Sid, Calls),
    Calls2 = dict:erase(Sid, Calls),
    if 
	Room == Sid_room ->
	    {reply, ok, State#state{room=none, calls=Calls2}};
	true ->
	    {reply, ok, State#state{calls=Calls2}}
    end.

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.
