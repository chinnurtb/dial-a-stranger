%% @author author <author@example.com>
%% @copyright YYYY author.
%% @doc Example webmachine_resource.

-module(dial_a_stranger_resource).
-export([init/1, content_types_provided/2, to_xml/2]).

-include_lib("webmachine/include/webmachine.hrl").

init([]) -> {ok, undefined}.

content_types_provided(ReqData, Context) ->
   {[{"text/xml", to_xml}], ReqData, Context}.

to_xml(ReqData, State) ->
    Room = conference:assign_room(),
    Response = io_lib:format("<Response><Dial><Conference beep="false" waitUrl="" startConferenceOnJoin="true" endConferenceOnExit="true">~p</Conference></Dial></Response>", [Room]),
    {Response, ReqData, State}.
