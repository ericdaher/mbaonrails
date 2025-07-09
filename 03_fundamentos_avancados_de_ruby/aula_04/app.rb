# Exercício: ThreadPool dinâmica com fila de prioridade 

# Contexto: 
# Você está desenvolvendo um sistema de processamento de tarefas em background que deve lidar com múltiplas 
# prioridades. Para isso, deseja implementar sua própria ThreadPool dinâmica, capaz de: 
# - Executar tarefas concorrentes com múltiplas Threads. 
# - Usar filas de prioridade (:high, :medium, :low) para gerenciar a ordem de execução 
# - Permitir o aumento ou redução do número de Threads ativamente consumindo tarefas 

# Objetivo: 
# Implemente as seguintes classes: 
# 1. PriorityQueue 
# Uma classe thread-safe que: 
# - Mantém várias filas (Queue) associadas a diferentes prioridades 
# - Permite adicionar tarefas com prioridade específica 
# - Retorna a próxima tarefa disponível com a mais alta prioridade disponível 
# 2. DynamicThreadPool 
# Uma classe com: 
# - Um número inicial de Threads (ex: 2). 
# - Capacidade de crescer até um número máximo de Threads (ex: até 10) dinamicamente 
# - Acesso a métodos como schedule(priority = :medium, &block) para adicionar tarefas. 
# - Remoção de threads mortas dinamicamente 
# Exemplo de uso: 
# pool = DynamicThreadPool.new(max_threads: 3) 
# 10.times do |i| 
#   pool.schedule(:default) { sleep 1; puts "Tarefa padrão #{i} concluída" } 
# end 
# 5.times do |i| 
#   pool.schedule(:high) { sleep 0.5; puts "Tarefa prioritária #{i} concluída" } 
# end 
# pool.shutdown  # => termina a execução de todas as Threads

class PriorityQueue
  PRIORITIES = %i(high default low)

  def initialize
    @internal_queues = {}
    PRIORITIES.each { |priority| @internal_queues[priority] = Queue.new }
    @mutex = Mutex.new
  end

  def add(priority, &task)
    @internal_queues[priority.to_sym].push(task)
  end

  def next_task
    @mutex.synchronize do
      task = if !@internal_queues[:high].empty?
        @internal_queues[:high].pop
      elsif !@internal_queues[:default].empty?
        @internal_queues[:default].pop
      elsif !@internal_queues[:low].empty?
        @internal_queues[:low].pop
      end

      return 'No task to run' if task.nil?
      task.yield
    end
  end
end

# priority_queue = PriorityQueue.new

# priority_queue.add(:default) { puts 'Normal task' }
# priority_queue.add(:high) { puts 'This should run first' }
# priority_queue.add(:low)  { puts 'This should run last' }

# priority_queue.next_task # This should run first
# priority_queue.next_task # Normal task
# priority_queue.next_task # This should run last
# priority_queue.next_task # No task to run

class DynamicThreadPool
  MIN_THREADS = 2

  def initialize(max_threads:)
    @max_threads = max_threads
    @used_threads = []
    @queue = PriorityQueue.new

    MIN_THREADS.times { start_thread }
  end

  def schedule(priority = :default, &block)
    @queue.add(priority, &block)
    puts @used_threads
    start_thread if @used_threads.count <= @max_threads
  end

  def shutdown
    @used_threads.each(&:kill)
    @used_threads.each(&:join)
  end

  private

  def start_thread
    thread = Thread.new do
      while true
        task = @queue.next_task

        if task && task != 'No task to run'
          task.call
        else
          sleep 0.5
        end
      end
    end

    @used_threads << thread
  end
end

pool = DynamicThreadPool.new(max_threads: 10) 
10.times do |i| 
  pool.schedule(:default) { sleep 1; puts "Tarefa padrão #{i} concluída" } 
end 
5.times do |i| 
  pool.schedule(:high) { sleep 0.5; puts "Tarefa prioritária #{i} concluída" } 
end
