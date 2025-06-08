# Exercício: Registro Dinâmico de Configurações 

# Objetivo: 
# Criar uma classe Settings que permita o registro e a leitura dinâmica de configurações, utilizando 
# define_method, method_missing, respond_to_missing? e send.

class Settings
  def initialize
    @available = {}
  end

  def add(key, value, *args)
    add_setter_and_getter(key, value, args)
    add_alias(key, args.first[:alias]) if args.is_a?(Array) && args.first.is_a?(Hash) && args.first.keys.include?(:alias)
  end

  def method_missing(name)
    "Configuração '#{name}' não existe."
  end

  def respond_to_missing?(name, include_private = false)
    @available.keys.include?(name) || super
  end

  def all = @available

  private 

  def add_setter_and_getter(key, value, args)
    @available[key] = value
    self.class.define_method(key.to_s) { value }
    self.class.define_method("#{key}=") do |new_value|
      if args.is_a?(Array) && args.first.is_a?(Hash) && args.first[:readonly]
        puts "Erro: configuração '#{key}' é somente leitura"
      else
        @available[key] = new_value
        self.class.remove_method(key)
        self.class.define_method(key.to_s) { new_value }
      end
    end
  end

  def add_alias(key, other_key)
    self.class.define_method(other_key) { send("#{key}") }
    self.class.define_method("#{other_key}=") { |arg| send("#{key}=", arg) }
  end
end

settings = Settings.new 

# Definindo configurações dinamicamente 
settings.add(:timeout, 30) 
settings.add(:mode, "production") 

# Acessando configurações via método 
puts settings.timeout   # => 30 
puts settings.mode      # => "production" 

# Tentando acessar configuração inexistente 
puts settings.retry     # => "Configuração 'retry' não existe." 

# Checando se um método está disponível 
puts settings.respond_to?(:timeout)   # => true 
puts settings.respond_to?(:retry)     # => false

# BÔNUS

settings = Settings.new 

# Permita definir um alias para uma configuração, de modo que múltiplos 
# métodos retornem o mesmo valor:

settings.add(:timeout, 30, alias: :espera)
settings.add(:mode, "production")
puts settings.timeout  # => 30 
puts settings.espera   # => 30

# Permita que certas configurações sejam marcadas como somente leitura (read-only), 
# e causem erro se alguém tentar sobrescrevê-las:

settings.add(:api_key, "SECRET", readonly: true) 
settings.api_key = "HACKED"  # => Erro: configuração 'api_key' é somente leitura 

# Adicione um método all que retorna um hash com todas as 
# configurações definidas:

puts settings.all  # => { timeout: 30, mode: "production", api_key: "SECRET" } 

# Opcionalmente, permita alterar valores por setters dinâmicos (settings.timeout = 60), 
# exceto se o campo for read-only: 

settings.timeout = 60 
puts settings.timeout  # => 60 