-module(main_new_call_resource).
-export([init/1, content_types_provided/2, to_xml/2]).

-include_lib("webmachine/include/webmachine.hrl").

init([]) -> {ok, undefined}.

content_types_provided(ReqData, Context) ->
   {[{"text/xml", to_xml}], ReqData, Context}.

to_xml(ReqData, State) ->
    Args = wrq:req_qs(ReqData),
    {"CallSid", Sid} = proplists:lookup("CallSid", Args),
    {Order, Room} = conference:new_call(Sid),
    Say = 
	case Order of
	    first ->
		"Wait here for the next stranger.";
	    second ->
		"A stranger is waiting for you. Say hi."
	end,
    Response = io_lib:format("<Response><Say>~s</Say><Dial><Conference waitUrl=\"\" startConferenceOnEnter=\"true\" endConferenceOnExit=\"true\">~w</Conference></Dial><Say>Your stranger has left you. Goodbye.</Say></Response>", [Say, Room]),
    {Response, ReqData, State}.
