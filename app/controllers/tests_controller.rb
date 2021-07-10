class TestsController < Simpler::Controller

  def index
    #render plain: 'Plain text response'

    # status 404

    # headers['Content-Type'] = 'text/plain'
    
    @time = Time.now
  end

  def show
    id = params[:id].to_i
    @test = Test.all.find { |t| t[:id] == id }
  end

end
