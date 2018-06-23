require 'rubyserial'
require 'serialport'
require './sender_reading'
require './sender_average'

class Listener
    def initialize
        #@arduino = Serial.new '/dev/ttyACM0'

        @port_str = "/dev/ttyACM0"
        @baud_rate = 9600
        @data_bits = 8
        @stop_bits = 1
        @parity = SerialPort::NONE
        @sp = SerialPort.new(@port_str, @baud_rate, @data_bits, @stop_bits, @parity)

        @sp.flush()
    end

    def readSerial
        #@lectura = @arduino.read(256)
        #if @lectura.nil?
        #    puts 'No ha mandado nada el arduino'
        #else
        #    puts @lectura
            #parse data
        #end

        @sp.flush()
        if (i = @sp.gets.chomp)
            puts i
            lectura = i
        end

        lectura
    end

    def readCamera(unix_time)
        file_name = "img_#{unix_time}.jpg";
        pwd = Dir.pwd
        system( "fswebcam #{pwd}/photos/#{file_name}" )
        file_name
    end

    def looper
        loop do
            unix_time = Time.now.to_i
            fn = self.readCamera(unix_time)
            l = self.readSerial
            puts "l:#{l}"

            s = SenderReading.new(:unix_time => unix_time, :file_name => fn)
            link = s.sendDrive()
            s.sendmlab(:link => link)

            sa = SenderAverage.new(:unix_time => unix_time)
            sa.getDaily
            sa.sendmlab

            sleep(5.minutes)
        end
    end
end

l = Listener.new
l.looper