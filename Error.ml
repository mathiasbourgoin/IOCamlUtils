open Js

let error f =
  Printf.ksprintf (fun s ->
		   Firebug.console##error (Js.string s);
		   failwith s) f
		  
