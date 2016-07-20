let example_application =
  Reactjs.make_class_spec
    ~component_will_receive_props:(fun this props ->
        Firebug.console##log props;
        print_endline "Component about to receive props";
      )
    (fun this ->
       let elapsed = Js.math##round this##.props##.elapsed /. 100.0 in
       let seconds = elapsed /. 10.0 in
       let message = Printf.sprintf
           "React has been successfully running for %f seconds" seconds
       in
       Reactjs.DOM.make ~tag:`p (`Text_nodes [message])
    )
  |> Reactjs.create_class

let _ =
  let example_app_factory = Reactjs.create_factory example_application in
  let start = (new%js Js.date_now)##getTime in
  Reactjs.set_interval
    ~f:(fun () ->
        try
          let with_new_props = example_app_factory ~props:(object%js
              val elapsed = (new%js Js.date_now)##getTime -. start
            end)
          in
          Reactjs.render with_new_props (Reactjs.get_elem ~id:"container")
        with Js.Error e ->
          Firebug.console##log e;
    ) ~every:5000.0