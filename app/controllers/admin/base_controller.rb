module Admin
  class BaseController < ApplicationController
    include RecordNotFoundRescue
  end
end
