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


module Canvas =
  struct
    let context_2d c = c##getContext (Dom_html._2d_)
    let get_image c =(context_2d c)##getImageData
    let put_image c = (context_2d c)##putImageData 
  end
