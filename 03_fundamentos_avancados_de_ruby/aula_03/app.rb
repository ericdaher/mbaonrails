# Objetivo: 

# Implemente uma classe SalesReport que recebe uma lista de 
# vendas no formato abaixo: 
# sales = [ 
#   { product: "Notebook", category: "Eletrônicos", amount: 3000 }, 
#   { product: "Celular", category: "Eletrônicos", amount: 1500 }, 
#   { product: "Cadeira", category: "Móveis", amount: 500 }, 
#   { product: "Mesa", category: "Móveis", amount: 1200 }, 
#   { product: "Headphone", category: "Eletrônicos", amount: 300 }, 
#   { product: "Armário", category: "Móveis", amount: 800 } 
# ] 

# Implemente a classe com as seguintes responsabilidades: 
# 1. Incluir Enumerable e implementar #each para iterar sobre as vendas. 
# 2. Um método #total_by_category que retorna um hash com o total de vendas por categoria. 
# 3. Um método #top_sales(n) que retorna os n maiores valores de venda. 
# 4. Um método #grouped_by_category que retorna um hash com os produtos agrupados por categoria. 
# 5. Um método #above_average_sales que retorna as vendas cujo valor está acima da média geral.

class SalesReport 
  include Enumerable

  def initialize(sales)
    @sales = sales.sort_by { |sale| -sale[:amount] }
    @sales_average = @sales.sum { |sale| sale[:amount] }.to_f / @sales.size
  end

  def each
    @sales.each { |sale| yield sale }
  end

  def total_by_category
    @sales.map { |sale| sale[:category] }.tally
  end

  def top_sales(n)
    @sales.lazy.first(n)
  end

  def grouped_by_category
    @sales.reduce(Hash.new) do |result, sale|
      result[sale[:category]] = [] if result[sale[:category]].nil?
      result[sale[:category]] << sale[:product]
      result
    end
  end

  def above_average_sales
    @sales.select { |sale| sale[:amount] > @sales_average }
  end
end

sales = [ 
  { product: "Notebook", category: "Eletrônicos", amount: 3000 }, 
  { product: "Celular", category: "Eletrônicos", amount: 1500 }, 
  { product: "Cadeira", category: "Móveis", amount: 500 }, 
  { product: "Mesa", category: "Móveis", amount: 1200 }, 
  { product: "Headphone", category: "Eletrônicos", amount: 300 }, 
  { product: "Armário", category: "Móveis", amount: 800 } 
] 

sales_report = SalesReport.new(sales)
sales_report.each { |sale| puts sale[:amount] }
puts sales_report.total_by_category # {"Eletrônicos"=>3, "Móveis"=>3}
puts sales_report.top_sales(3) # {:product=>"Notebook", :category=>"Eletrônicos", :amount=>3000}, {:product=>"Celular", :category=>"Eletrônicos", :amount=>1500}. {:product=>"Mesa", :category=>"Móveis", :amount=>1200}
puts sales_report.grouped_by_category # {"Eletrônicos"=>["Notebook", "Celular", "Headphone"], "Móveis"=>["Cadeira", "Mesa", "Armário"]}
puts sales_report.above_average_sales # {:product=>"Notebook", :category=>"Eletrônicos", :amount=>3000}, {:product=>"Celular", :category=>"Eletrônicos", :amount=>1500}