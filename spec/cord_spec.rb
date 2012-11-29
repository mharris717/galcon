require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Galcon" do
  let(:start) do
    [2,1].to_cord
  end
  let(:finish) do
    [5,7].to_cord
  end
  
  it 'to_s' do
    start.to_s.should == '2,1'
  end
  
  it 'distance' do
    exp = (9 + 36)**0.5
    start.dist(finish).should == exp
  end
  
  it 'to_cord returns self' do
    start.to_cord.should == start
  end
  
  describe 'moving' do
    let(:perc_per) { 1.0/(45**0.5) }
    describe 'forward' do
      let(:first_move) do
        start.move_toward(finish)
      end
      it 'x' do
        exp = 2 + perc_per*3.0
        first_move.x.should == exp.round(5)
      end
      it 'y' do
        exp = 1 + perc_per*6.0
        first_move.y.should == exp.round(5)
      end
    end
    
    describe 'backwards' do
      let(:first_move) do
        finish.move_toward(start)
      end
      it 'x' do
        exp = 5 - perc_per*3.0
        first_move.x.should == exp.round(5)
      end
      it 'y' do
        exp = 7 - perc_per*6.0
        first_move.y.should == exp.round(5)
      end
    end
    
    describe 'horizontal' do
      let(:start) { [2,2].to_cord }
      let(:finish) { [2,5].to_cord }
      let(:first_move) do
        start.move_toward(finish)
      end
      
      it 'dist' do
        start.dist(finish).should == 3
      end
      it 'x' do
        first_move.x.should == 2
      end
      it 'y' do
        first_move.y.should == 3
      end
    end
    
    describe 'horizontal backwards' do
      let(:start) { [2,2].to_cord }
      let(:finish) { [2,5].to_cord }
      let(:first_move) do
        finish.move_toward(start)
      end
      
      it 'dist' do
        start.dist(finish).should == 3
      end
      it 'x' do
        first_move.x.should == 2
      end
      it 'y' do
        first_move.y.should == 4
      end
    end
    
    describe 'vertical' do
      let(:start) { [2,2].to_cord }
      let(:finish) { [5,2].to_cord }
      let(:first_move) do
        start.move_toward(finish)
      end
      
      it 'dist' do
        start.dist(finish).should == 3
      end
      it 'x' do
        first_move.x.should == 3
      end
      it 'y' do
        first_move.y.should == 2
      end
    end
    
    describe 'partial' do
      let(:start) { [2,2].to_cord }
      let(:finish) { [3,3].to_cord }
      let(:first_move) do
        start.move_toward(finish).move_toward(finish)
      end
      
      it 'dist' do
        start.dist(finish).should == 2**0.5
      end
      it 'x' do
        first_move.x.should == 3
      end
      it 'y' do
        first_move.y.should == 3
      end
    end
  end
end








