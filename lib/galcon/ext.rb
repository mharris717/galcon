class Object
  def klass
    self.class
  end
end

class Numeric
  def ia_round(n)
    if self == to_i
      self
    else
      round(n)
    end
  end
end

class Object
  def copy_method(existing,new_meth)
    send(:extend,Forwardable) unless respond_to?(:def_delegator)
    def_delegator :self, existing,new_meth
    def_delegator :self, "#{existing}=","#{new_meth}=" 
  end
end

class Array
  def sum
    inject(0) do |s,i|
      raise "bad sum array" if i.nil?
      s + i
    end
  end
end