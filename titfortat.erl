%%% Paul Cavallaro's Tit for Tat Erlang module to participate in the Prisoner's
%%% Dilemma tournament.
%%%
%%% Little bit of a mess to follow, but it should retaliate quickly and
%%% forgive fast.

-module(titfortat).
-export([init/0, play/2, result/2, stop/1]).

init() ->
    dict:new().

play(Opponent, _State) ->
    play_lookup(dict:find(Opponent, _State), Opponent, _State).

play_lookup(error, Opponent, _State) ->
    {cooperate, dict:store(Opponent, {0,0,0}, _State)};
play_lookup({ok,{_, OpponentDefects, TotalGames}}, _, _State) ->
    choose(random:uniform(), OpponentDefects / TotalGames, _State).

choose(N, Probability, _State) when N =< Probability ->
    {defect, _State};
choose(N, Probability, _State) when N > Probability ->
    {cooperate, _State}.

result({_Opponent, _OwnChoice, _OpponentChoice}, _State) ->
    dict:store(_Opponent, calculate(_OpponentChoice, dict:fetch(_Opponent, _State)), _State).

%%% When I'm not about to fall asleep, I should look into if there's a more
%%% idiomatic way to do this with map and destructuring
calculate(cooperate, {_OpponentCooperations, _OpponentDefects, _TotalGames}) ->
    {decay(_OpponentCooperations) + 1, decay(_OpponentDefects), decay(_TotalGames) + 1};
calculate(defect, {_OpponentCooperations, _OpponentDefects, _TotalGames}) ->
    {decay(_OpponentCooperations),decay(_OpponentDefects) + 1, decay(_TotalGames) + 1}.

decay(N) ->
    N * math:pow(2, -2).

stop(_State) ->
    ok.
