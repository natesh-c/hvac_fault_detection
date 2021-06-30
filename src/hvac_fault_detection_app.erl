%%%-------------------------------------------------------------------
%% @doc hvac_fault_detection public API
%% @end
%%%-------------------------------------------------------------------

-module(hvac_fault_detection_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    io:format("Starting Pubsub ws  ~n"),
    Dispatch = cowboy_router:compile([
        {'_',[
            {"/ws/[...]",ws_req_handler,[]}
        ]}
    ]),
    Res = cowboy:start_http(websocket,10,[{port,8585}],
        [{env,[{dispatch,Dispatch}]}]),
    case Res of
        {ok, _Pid} ->
%%          Need to start any local level cache db (ETS)
            hvac_fault_detection_sup:start_link();
        {error,Reason} -> {error,Reason};
        Error -> {error,Error}
    end.


stop(_State) ->
    ok.

%% internal functions
