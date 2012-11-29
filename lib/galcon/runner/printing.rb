module Galcon
  module Runner
    class Printing < Base
      def write_state!
        File.append "tmp/state.html",to_html
      end
      def before_run
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
        write_state!
      end
      def after_turn
        write_state!
      end
      def after_run
        File.append "tmp/state.html", "</body></html>"
      end
      def to_html
        Table.new(:world => world).to_s
      end
      
      
    end
  end
end
