require 'socket'
require 'colorize'

class Server
  def initialize(ip, port)
    @server = TCPServer.open(ip, port)
    @connections = {}
    @rooms = {}
    @clients = {}
    initialize_connections
    run
  end

  def initialize_connections
    @connections[:server] = @server
    @connections[:rooms] = @rooms
    @connections[:clients] = @clients
  end

  def run
    loop do
      Thread.start(@server.accept) do |client|
        username = client.gets.chomp.to_sym

        @connections[:clients].each do |other_name, other_client|
          if username == other_name || client == other_client
            client.puts "Sorry, but this username already exits".red
            Thread.kill self
          end
        end

        puts "#{username} #{client}"
        @connections[:clients][username] = client
        client.puts "Connection established. Thank you for joining! Happy chatting.".ligth_blue
        listen_user_messages(username, client)
      end
    end
  end

  def listen_user_messages(username, client)
    loop do
      msg = client.gets.chomp
      @connection[:clients].each do |other_name, other_client|
        other_client.puts "#{username.to_s}: #{msg}".green.on_black unless other_name == username
      end
    end
  end
end

Server.new(ARGV[0], ARGV[1])
