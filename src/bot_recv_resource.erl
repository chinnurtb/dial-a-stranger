-module(bot_recv_resource).
-export([init/1, content_types_provided/2, to_xml/2]).

-include_lib("webmachine/include/webmachine.hrl").

init([]) -> {ok, undefined}.

content_types_provided(ReqData, Context) ->
   {[{"text/xml", to_xml}], ReqData, Context}.

to_xml(ReqData, State) ->
    Args = wrq:req_qs(ReqData),
    {"From", From} = proplists:lookup("From", Args),
    {"Body", Body} = proplists:lookup("Body", Args),
    bot:recv(From, Body),
    {"<Response></Response>", ReqData, State}.
