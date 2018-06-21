require 'mongoid'
require "google_drive"
Mongoid.load!('mongoid.yml', :production)
Mongoid.raise_not_found_error = false

class Average
    include Mongoid::Document
    field :ha
    field :ht
    field :tm
    field :lm
    field :ps
    field :unix
    field :nlecturas
    store_in collection: 'average'
end

class Sender
    
    def initialize
        @today = Date.today.to_time.to_i
    end
    
    def getDaily
        @data = Average.find_by(unix: @today)
        puts @data.ha
        puts @data.nlecturas
    end

    def sendmlab
        if @data.nil?
            dato = Average.new(
            ha: 1.0,
            ht: 2.0,
            tm: 3.0,
            lm: 4.0,
            ps: 5.0,
            unix: @today,
            nlecturas: 1
            )

            dato.save!

        else
            nnlecturas = @data.nlecturas + 1
            nha = (@data.ha * @data.nlecturas + 3.0 ) *1.0 / nnlecturas
            nht = (@data.ht * @data.nlecturas + 4.0 ) *1.0 / nnlecturas
            ntm = (@data.tm * @data.nlecturas + 5.0 ) *1.0 / nnlecturas
            nlm = (@data.lm * @data.nlecturas + 6.0 ) *1.0 / nnlecturas
            nps = (@data.ps * @data.nlecturas + 7.0 ) *1.0 / nnlecturas
            
            Average.where(unix: @today).update({
                ha: nha,
                ht: nht,
                tm: ntm,
                lm: nlm,
                ps: nps,
                unix: @today,
                nlecturas: @data.nlecturas+1
            })
        end
    end
end

s = Sender.new
s.getDaily
s.sendmlab
