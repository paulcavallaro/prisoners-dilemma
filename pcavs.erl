%%% Paul Cavallaro's Erlang module to participate in the Prisoner's Dilemma
%%% tournament.
%%%
%%% Little bit of a mess to follow, but it should defect proportionally often
%%% as its opponent has defected no matter this bots decision

-module(pcavs).
-export([init/0, play/2, result/2, stop/1]).

init() ->
    dict:new().

play({ok,{_, OpponentDefects, TotalGames}}, _State) ->
    play(random:uniform(), OpponentDefects / TotalGames, _State);
play(Opponent, _State) ->
    play(dict:find(Opponent, _State), Opponent, _State).

play(error, Opponent, _State) ->
    {cooperate, dict:store(Opponent, {0,0,0}, _State)};
play(N, Probability, _State) when N > Probability ->
    {cooperate, _State};
play(N, Probability, _State) when N =< Probability ->
    {defect, _State}.

result({_Opponent, _OwnChoice, _OpponentChoice}, _State) ->
    dict:store(_Opponent, calculate(_OpponentChoice, dict:fetch(_Opponent, _State)), _State).

calculate(cooperate, {_OpponentCooperations, _OpponentDefects, _TotalGames}) ->
    {_OpponentCooperations + 1, _OpponentDefects, _TotalGames + 1};
calculate(defect, {_OpponentCooperations, _OpponentDefects, _TotalGames}) ->
    {_OpponentCooperations, _OpponentDefects + 1, _TotalGames + 1}.

stop(_State) ->
    ok.
