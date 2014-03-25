require 'socket'
require 'colorize'

class Client
  def initialize(server)
    @server = server
    @request = nil
    @response = nil
    listen
    send
    @request.join
    @response.join
  end

  def listen
    @response = Thread.new do
      loop do
        msg = @server.gets.chomp
        puts "MESSAGE: #{msg}"
      end
    end
  end

  def send
    puts "Enter the username:".red.on_blue.underline
    @request = Thread.new do
      loop do
        msg = $stdin.gets.chomp
        @server.puts(msg)
      end
    end
  end
end

Client.new(TCPSocket.open(ARGV[0], ARGV[1]))
