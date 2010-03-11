module Net # :nodoc:
  module DNS
    class RR
      
      #------------------------------------------------------------
      # RR type SRV
      #------------------------------------------------------------
      class SRV < RR
        
        attr_reader :priority, :weight, :port, :host
        
        private
        
        def build_pack
          @srv_pack = [@priority].pack("n") + [@weight].pack("n") + [@port].pack("n") + pack_name(@host)
          @rdlength = @srv_pack.size
        end
        
        def get_data
          @srv_pack
        end
        
        def get_inspect
          "#@priority #@weight #@port #@host"
        end
        
        def subclass_new_from_binary(data,offset)
          off_end = offset + @rdlength
          @priority, @weight, @port = data.unpack("@#{offset} n n n")
          offset+=6

          @host=[]
          while offset < off_end
            len = data.unpack("@#{offset} C")[0]
            offset += 1
            str = data[offset..offset+len-1]
            offset += len
            @host << str
          end
          @host=@host.join(".")
          return offset
        end
        
        private
        
          def set_type
            @type = Net::DNS::RR::Types.new("SRV")
          end
        
      end
    end
        
  end
end
