open Spoc
type space = Col | Row


let row_from_vector to_string v bound =
  let r = ref "" in
  for i = 0 to bound do
    r := (!r^"<td>"^to_string (Mem.get v i)^"</td>")
  done;
  !r
	 
				   
				    
let as_table ?(bound:int option) ?(titles:string list option) s to_string v =
  let bound =
    match bound with
      None -> Vector.length (List.hd v) -1
    | Some i -> min i (Vector.length (List.hd v) -1)
  in
  let fst =  
    match titles with
    | Some l ->
       (List.fold_left (fun a b -> a^"<td>"^b^"</td>") "<tr>" l)^"</tr>"
    | None -> ""
  in
  let res =
    match s with
    | Col  ->
       begin
	 let res = ref "" in
	 for i = 0 to bound do
	   res := !res^
		    "<tr>"^
		      (List.fold_left
			 (fun a vi -> (a^"<td>"^
					 (to_string (Mem.get vi i))^
					   "</td>"))
			 "" v)^"</tr>\n"
	 done;
	 !res
       end
    | Row ->
       begin
	 let rec to_row acc v = 
	   match v with
	   | h::t ->
	      to_row  (acc^("<tr>"^row_from_vector to_string h bound ^"</tr>\n")) t
	   | [] -> acc
	 in to_row "" v
       end
  in
  let dots = ref "" in
  if bound <> Vector.length (List.hd v) -1 then
      (dots:= "<tr>";
       for i = 0 to List.length  v - 1 do
	 dots:= !dots^ "<td>...</td>"
       done;
       dots := !dots ^"</tr>");
    fst^ res ^ (!dots)  
		 
		   

