class Result
   include DataMapper::Resource
   property :id,        Serial                       
   property :lecture,     String,  :required => true   
   property :nr, Integer,  :required => true  
   property :hw_possible,Integer
   property :hw_result, Integer, :default => 0
   property :on_possible, Integer, :default => 0
   property :on_result, Integer, :default => 0
   
   def hw_percentage
     return (@hw_result.to_f/@hw_possible.to_f * 100.0).round
   end
   def on_percentage
     return (@on_result.to_f/@on_possible.to_f * 100.0).round
   end
 end
class Total
  include DataMapper::Resource
  property :id,        Serial
  property :lecture,     String,  :required => true  
  property :possible, Integer
  property :result, Integer, :default => 0
end