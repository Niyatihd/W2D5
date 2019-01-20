require 'byebug'

class MaxIntSet

  attr_reader :max, :store

  def initialize(max)
    @max = max
    @store = Array.new(max + 1) { false }
  end

  def insert(num)
    if is_valid?(num)
      @store[num] = true
    else
      validate!
    end
  end
  
  def remove(num)
    if self.include?(num) 
      @store[num] = false 
    else
      validate!
    end
  end
  
  def include?(num)
    @store[num] == true 
  end
  
  private
  
  def is_valid?(num)
    if num <= max && num >= 0
      return true
    else
      return false
    end
  end

  def validate!
    raise "Out of bounds"
  end
end


class IntSet
  def initialize(num_buckets = 20)
    @store = Array.new(num_buckets) { Array.new }
  end

  def insert(num)
    if !include?(num)
      @store[num % 20] << num
    end
  end

  def remove(num)
    if include?(num)
      @store[num % 20].delete(num)
    end
  end

  def include?(num)
    bucket = num % 20
    @store[bucket].any? { |el| el == num } 
  end

  private

  # def [](num)
  #   # optional but useful; return the bucket corresponding to `num`
  #   @store[num % 20]
  # end

  def num_buckets
    @store.length
  end
end

class ResizingIntSet
  attr_reader :count

  def initialize(num_buckets = 20)
    @store = Array.new(num_buckets) { Array.new }
    @count = 0
  end

  def insert(num)
    resize! if count >= num_buckets
    if !include?(num)
      @store[num % num_buckets] << num
      @count += 1
    end
  end

  def remove(num)
    if include?(num)
      @store[num % num_buckets].delete(num)
      @count -= 1
    end
  end

  def include?(num)
    @store[num % num_buckets].any? { |el| el == num } 
  end

  # private

  def [](num)
    # optional but useful; return the bucket corresponding to `num`
  end

  def num_buckets
    @store.length
  end

  def resize!
    # if @count > num_buckets
    #   debugger
    #   resized = Array.new(num_buckets * 2) { Array.new }
    #   @store.concat(resized)
    #   @store.each do |sub_arr|
    #     sub_arr.each do |el|
    #       self.insert(el)
    #     end
    #   end
    # end
    prev_store = @store
    @store = Array.new(num_buckets * 2) { Array.new }
    @count = 0
    prev_store.each do |sub_arr|
      sub_arr.each do |el|
        self.insert(el)
      end
    end
  end
end
