class Dotenv
  QUOTES = ["\"", "'"]
  COMMAND_REGEXP = /\$\((.+)\)/

  def initialize
    @loaded_vars = {} of String => String
  end

  def run
    load_dotenv(file)
    load_dotenv(env_file)
    load_dotenv(".env.local")
    load_dotenv(local_env_file)
    add_loaded_environment_variables

    if command != ""
      system(command)
    else
      puts "dotenv: exec needs a command to run"
    end
  end

  def command
    return "" if ARGV.empty?

    if file_passed?
      if exec_arg?(2)
        args_from(3)
      else
        args_from(2)
      end
    elsif env_passed?
      if exec_arg?(1)
        args_from(2)
      else
        args_from(1)
      end
    else
      if exec_arg?(0)
        args_from(1)
      else
        args_from(0)
      end
    end
  end

  def file
    file_passed? ? ARGV[1] : ".env"
  end

  def current_env
    return ARGV[0] if env_passed?

    ENV["RAILS_ENV"]? || ENV["ENV"]? || "development"
  end

  def env_file
    ".env.#{current_env}"
  end

  def local_env_file
    "#{env_file}.local"
  end

  def add_loaded_environment_variables
    @loaded_vars.each { |key, value| ENV[key] = value }
  end

  def file_passed?
    ARGV[0]? == "-f"
  end

  def env_passed?
    allowed_envs.includes?(ARGV[0]?)
  end

  def allowed_envs
    Dir.glob(".env.*", match_hidden: true).map{ |x| x.gsub(/\.local$/, "").gsub(/^\.env\./, "") }.uniq
  end

  def args_from(index)
    ARGV[index..-1].join(" ")
  end

  def exec_arg?(index)
    ARGV[index] == "exec"
  end

  def load_dotenv(file)
    return unless file
    return unless File.exists?(file)

    text = File.read(file)

    text.lines.each do |line|
      line = line.gsub("\n", "").gsub("export ", "")

      next if line.empty? || line.starts_with?("#")
      splitted = line.split("=")
      key = splitted.first
      value = splitted.size == 1 ? "" : splitted[1..-1].join("=")
      value = strip_quotes(value)
      value = substitute_commands(value)

      @loaded_vars[key] = value || ""
    end
  end

  def strip_quotes(value)
    result = value

    strip_quote!(result, 0)
    strip_quote!(result, value.size - 1)

    result
  end

  def strip_quote!(value, position)
    return if value.empty?
    return unless QUOTES.includes?(value[position])

    value.delete_at(position)
  end

  def substitute_commands(value)
    commands = value.scan(COMMAND_REGEXP).flatten
    result = value

    commands.each do |command|
      command = command[1]
      key = "$(#{command})"
      command_output = `#{command}`.gsub("\n", "")
      result = result.gsub(key, command_output)
    end

    result
  end
end

Dotenv.new.run
