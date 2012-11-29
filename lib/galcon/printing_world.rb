module Galcon
  class PrintingWorld
    include FromHash
    attr_accessor :world
    def method_missing(sym,*args,&b)
      world.send(sym,*args,&b)
    end
    def to_html
      Table.new(:world => self).to_s + Time.now.to_s
    end
    
    def run!(n=nil)
      styles = (0...40).map do |gr|
        s = gr * 5 + 10
        "<style type='text/css'>.size-#{gr} {min-height: #{s}px; min-width: #{s}px; max-height: #{s}px; max-width: #{s}px; height: #{s}px; width: #{s}px;}</style>"
      end.join("\n")
      File.create("tmp/state.html",'<html><head>
      <style type="text/css">td {height: 60px; width: 60px; font-size: 65%; text-align: center; }</style>
      <style type="text/css">div {vertical-align: middle; }</style>
      <style type="text/css">.red {background-color:red;}</style>
      <style type="text/css">.blue {background-color:blue;}</style>
      <style type="text/css">.gray {background-color:gray;}</style>
      <style type="text/css">.grid {float: left; margin:30px; border-style: solid; border-width: 1px; border:color: black; }</style>' + styles + '
      </head><body>')
      File.append "tmp/state.html",to_html
      if n
        n.times do
          advance!
          File.append "tmp/state.html",to_html
        end
      else
        i = 0
        while active?
          advance!
          #puts "appending #{Time.now}"
          File.append "tmp/state.html",to_html
          #sleep(0.1)
          i += 1
          raise "end" if i > 200
        end
        puts "Last turn #{i} #{winner}"
      end
      File.append "tmp/state.html", "Done</body></html>"
    end
  end
end