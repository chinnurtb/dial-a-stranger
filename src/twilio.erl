-module(twilio).

-include("auth.hrl").

-export([send_sms/3]).

send_sms(To, From, Body) ->
    Path = io_lib:format("/2010-04-01/Accounts/~s/SMS/Messages", [?AccountSid]),
    post(Path, [{"to", To}, {"from", From}, {"body", Body}]).

% --- internal ---

base_url() ->
    io_lib:format("https://~s:~s@api.twilio.com", [?AccountSid, ?AuthToken]).

% from ibrowse
url_encode(Str) when is_list(Str) ->
    url_encode_char(lists:reverse(Str), []).
url_encode_char([X | T], Acc) when X >= $0, X =< $9 ->
    url_encode_char(T, [X | Acc]);
url_encode_char([X | T], Acc) when X >= $a, X =< $z ->
    url_encode_char(T, [X | Acc]);
url_encode_char([X | T], Acc) when X >= $A, X =< $Z ->
    url_encode_char(T, [X | Acc]);
url_encode_char([X | T], Acc) when X == $-; X == $_; X == $. ->
    url_encode_char(T, [X | Acc]);
url_encode_char([32 | T], Acc) ->
    url_encode_char(T, [$+ | Acc]);
url_encode_char([X | T], Acc) ->
    url_encode_char(T, [$%, d2h(X bsr 4), d2h(X band 16#0f) | Acc]);
url_encode_char([], Acc) ->
    Acc.
d2h(N) when N<10 -> N+$0;
d2h(N) -> N+$a-10.

post(Path, Args) ->
    Body = lists:foldl(fun ({Key, Value}, Acc) -> url_encode(Key) ++ "=" ++ url_encode(Value) ++ "&" ++ Acc end, "", Args),
    {ok, {Code, Result}} = 
	httpc:request(
	  post, 
	  {base_url() ++ Path, [], "application/x-www-form-urlencoded", Body}, 
	  [], 
	  [{full_result, false}]
	 ),
    {Code, Result}.
