module EngineB
  class Engine < ::Rails::Engine
    isolate_namespace EngineB

    # Autoload app/lib for V2Lms and other libs
    initializer "engine_b.autoload_lib" do |app|
      lib_path = root.join("app", "lib")
      Rails.autoloaders.main.push_dir(lib_path, namespace: EngineB) if lib_path.exist?

      forms_path = root.join("app", "forms")
      Rails.autoloaders.main.push_dir(forms_path) if forms_path.exist?
    end

    # Use the main app's migrations directory for Engine B migrations
    initializer "engine_b.append_migrations" do |app|
      unless app.root.to_s.match?(root.to_s)
        config.paths["db/migrate"].expanded.each do |path|
          app.config.paths["db/migrate"] << path
        end
      end
    end
  end
end
