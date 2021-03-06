# Ariete
# Copyright (c) 2014 Moza USANE
# This software is released under the MIT License.
# http://opensource.org/licenses/mit-license.php

require "stringio"

module Ariete
  ["stdout", "stderr"].each do |name|
    define_method("capture_#{name}") do |*args, &block|
      original = eval("$#{name}")
      eval("$#{name} = StringIO.new")

      begin
        block.call(*args)
      ensure
        ret_str = eval("$#{name}").string
        eval("$#{name} = original")
      end

      ret_str
    end

    module_function "capture_#{name}"
  end
end

RSpec::Matchers.define :be_output do |expect|
  match do |actual|
    Ariete.capture_stdout { actual.call } == expect.to_s
  end
end

RSpec::Matchers.define :be_output_to_stderr do |expect|
  match do |actual|
    Ariete.capture_stderr { actual.call } == expect.to_s
  end
end
