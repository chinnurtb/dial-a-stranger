-module(new_call_resource).
-export([init/1, content_types_provided/2, to_xml/2]).

-include_lib("webmachine/include/webmachine.hrl").

init([]) -> {ok, undefined}.

content_types_provided(ReqData, Context) ->
   {[{"text/xml", to_xml}], ReqData, Context}.

to_xml(ReqData, State) ->
    Args = wrq:req_qs(ReqData),
    Sid = proplists:lookup("CallSid", Args),
    {Order, Room} = conference:new_call(Sid),
    Say = 
	case Order of
	    first ->
		"Wait here for the next stranger.";
	    second ->
		"Someone is already waiting in this room. Say hi."
	end,
    Response = io_lib:format("<Response><Say>~s</Say><Dial><Conference>~w</Conference></Dial></Response>", [Say, Room]),
    {Response, ReqData, State}.
