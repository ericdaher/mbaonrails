# Exercício: HtmlBuilder com tags aninhadas 

# Objetivo: 
# Modificar a classe HtmlBuilder vista em aula a fim de 
# permitir a construção de HTMLs mais complexos. 

class HtmlBuilder 
  def initialize(&block) 
    @html = "" 
    instance_eval(&block) if block_given? 
  end 

  def div(content = '', &block) 
    return @html << "<div>\n#{HtmlBuilder.new(&block).result}</div>\n" if block_given?

    @html << "<div>#{content}</div>\n" 
  end

  def span(content) 
    @html << "<span>#{content}</span>\n" 
  end

  def result 
    @html 
  end 
end

builder = HtmlBuilder.new do
  div do
    div "Conteúdo em div" 
    span "Nota em div" 
    div do
      span "Dentro da div"
    end
  end
  span "Nota de rodapé" 
end
puts builder.result