let get name t =
  Js.Opt.get
    (Js.Opt.bind ( Dom_html.document##getElementById(Js.string name) )
		 t)
    (fun () -> Error.error "can't find element %s" name)

let get_textfield name =
  get name Dom_html.CoerceTo.textarea

let get_image name =
    get name Dom_html.CoerceTo.img

let get_canvas name =
    get name Dom_html.CoerceTo.canvas

let get_p name =
    get name Dom_html.CoerceTo.p

let get_td name =
  get name Dom_html.CoerceTo.td

let get_table name =
  get name Dom_html.CoerceTo.table
			    
module Canvas =
  struct
    let context_2d c = c##getContext (Dom_html._2d_)
    let get_image c (x, y, width, height)  =(context_2d c)##getImageData (x, y, width, height)
    let put_image c (data, x, y) = (context_2d c)##putImageData (data,x,y)
  end
