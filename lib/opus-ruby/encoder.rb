module Opus
  class Encoder
    attr_reader :sample_rate, :frame_size, :channels

    def initialize(sample_rate, frame_size, channels)
      @sample_rate = sample_rate
      @frame_size = frame_size
      @channels = channels

      @encoder = Opus.opus_encoder_create sample_rate, channels, Constants::OPUS_APPLICATION_VOIP, nil
    end

    def destroy
      Opus.opus_encoder_destroy @encoder
    end

    def encode(data, size)
      out = FFI::MemoryPointer.new :char, data.size + 1
      buf = FFI::MemoryPointer.new :char, data.size + 1
      buf.put_string 0, data
      len = Opus.opus_encode @encoder, buf, @frame_size, out, size
      out.read_string_length len
    end
  end
end
