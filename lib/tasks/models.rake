namespace :models do
    task get: :environment do
        exclusiones = ["DirectUpload", "ImportUser", "I18nContent", "I18nContentTranslation"]
        tables = []
        Dir.glob(Rails.root.join('app/models/**/*.rb')).each do |x|
            begin

                model =  x.gsub('.rb','').gsub(Rails.root.join('app/models/').to_s, '').gsub('custom/','').singularize.classify
                if exclusiones.exclude?(model.to_s) && !model["Concern"] && !model["Abilities"]
                    tables << [model.constantize.model_name.human, model.constantize.model_name]
                end
            rescue
            end

        end
       
        puts "="*20
        puts tables.uniq.sort
        puts "="*20
    end

   

end