App.Parbudget = 
    add_center: (select, counter) ->
        data_content = JSON.parse($(select).val())
        #[
        # 0    self.id,
        # 1    self.denomination,
        # 2    self.code,
        # 3    self.code_section,
        # 4    self.code_program,
        # 5    self.responsible,
        # 6    self.government_area,
        # 7    self.general_direction
        # ]
        if ($("#center_#{data_content[0]}").length == 0)
            $(counter).append(
                "<div class='small-12 column'>"+
                "<fieldset id='center_#{data_content[0]}' style=\"border: 1px solid grey;margin: 1em 0;padding: 1em;\">"+
                "<input id=\"parbudget_project_parbudget_center_ids[]\" name=\"parbudget_project[parbudget_center_ids][]\" type=\"hidden\" value=\"#{data_content[0]}\">"+
                "<div  class='small-12 medium-6 column'>"+
                "<p><b>Área de gobierno</b></p>"+
                "<p>#{data_content[6]}</p>"+
                "</div>"+
                "<div  class='small-12 medium-6 column'>"+
                "<p><b>Dirección general</b></p>"+
                "<p>#{data_content[7]}</p>"+
                "</div>"+
                "<div  class='small-12 medium-6 column'>"+
                "<p><b>Denominación</b></p>"+
                "<p>#{data_content[1]}</p>"+
                "</div>"+
                "<div  class='small-12 medium-6 column'>"+
                "<p><b>Responsable</b></p>"+
                "<p>#{data_content[5]}</p>"+
                "</div>"+
                "<div  class='small-12 medium-4 column'>"+
                "<p><b>Código centro</b></p>"+
                "<p>#{data_content[2]}</p>"+
                "</div>"+
                "<div  class='small-12 medium-4 column'>"+
                "<p><b>Código sección</b></p>"+
                "<p>#{data_content[3]}</p>"+
                "</div>"+
                "<div  class='small-12 medium-4 column'>"+
                "<p><b>Código programa</b></p>"+
                "<p>#{data_content[4]}</p>"+
                "</div>"+
                "<div  class='small-12 column clear text-right'>"+
                "<a href='#' class='button alert' onclick=\"App.Parbudget.remove_center('#center_#{data_content[0]}')\">Borrar</a>"+
                "</div>"+
                "</fieldset></div>")

    
    remove_center: (element) ->
        $(element).empty()
        $(element).remove()



