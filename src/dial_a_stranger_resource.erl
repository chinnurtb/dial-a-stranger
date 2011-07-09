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
    {"<Response><Say>Hello</Say></Response>", ReqData, State}.
