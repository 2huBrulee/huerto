require 'rubyserial'

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
            #sendMlab
        end
    end

    def readCamera(unix_time)
        file_name = "img_#{unix_time}.jpg";
        pwd = Dir.pwd
        system( "fswebcam #{pwd}/photos/#{file_name}" )
        
    end

    def loop
        while true
            unix_time = Time.now.to_i
            self.readCamera(unix_time)
            self.readSerial
            sleep(5.minutes)
        end
    end
end

