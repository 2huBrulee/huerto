require 'rubyserial'
require 'sender_reading'
require 'sender_average'

class Listener
    def initialize
        @arduino = Serial.new '/dev/ttyACM0'
    end

    def readSerial
        @lectura = @arduino.read(256)
        if @lectura.nil?
            puts 'No ha mandado nada el arduino'
        else
            #parse data
        end
    end

    def readCamera(unix_time)
        file_name = "img_#{unix_time}.jpg";
        pwd = Dir.pwd
        system( "fswebcam #{pwd}/photos/#{file_name}" )
        file_name
    end

    def loop
        while true
            unix_time = Time.now.to_i
            fn = self.readCamera(unix_time)
            self.readSerial

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

