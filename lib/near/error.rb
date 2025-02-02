# This is free and unencumbered software released into the public domain.

class NEAR::Error < StandardError
  class InvalidBlock < NEAR::Error
    def initialize(block_height = nil)
      @block_height = block_height.to_i if block_height
      super(block_height ?
        "Block height ##{block_height.to_i} does not exist" :
        "Block height does not exist")
    end

    attr_reader :block_height
  end # NEAR::Error::InvalidBlock

  class TemporaryProblem < NEAR::Error; end

  class UnexpectedProblem < NEAR::Error; end
end # NEAR::Error
