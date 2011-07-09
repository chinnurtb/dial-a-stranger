-module(end_call_resource).
-export([init/1, content_types_provided/2, to_xml/2]).

-include_lib("webmachine/include/webmachine.hrl").

init([]) -> {ok, undefined}.

content_types_provided(ReqData, Context) ->
   {[{"text/xml", to_xml}], ReqData, Context}.

to_xml(ReqData, State) ->
    Args = wrq:req_qs(ReqData),
    From = proplists:lookup("From", Args),
    conference:end_call(From),
    {"", ReqData, State}.
