let run f =
  let start_ = Unix.gettimeofday () in
  let res = f () in
  let end_ = Unix.gettimeofday () in
  res,(end_ -. start_)
