def b_insert(target, arr)

  left = right = []

  if target >= arr.last
    return arr << target
  elsif target < arr.first
    return arr.unshift(target)
  end

  mid = arr.length/2
  
  if arr[mid] == target 
    return arr.insert(mid, target)
  end

  if target < arr[mid]
    left = b_insert(target, arr[0...mid])
  else
    right = b_insert(target, arr[mid..-1])
  end
  
  target_idx = (left+right).index(target)
  target_idx += arr.length/2 if left.empty?
  arr.insert(target_idx, target)

end

#uses b_insert to insert any num greater than the min of the 100 highest numbers to that point
#takes 8.6s to run through 100M numbers and 83s to run through 1B -- slowest of 3.

def biggest_hundred(n)

  hundred = n[0..99]
  hundred.sort!
  min = hundred.first
  

  n[100..-1].each do |num|
    if num > min 
      hundred.shift
      b_insert(num, hundred)
      min = hundred.first
    end
  end

  hundred.sort!

end

#Keeps a cache of up to 100 numbers larger than the min of the highest hundred;
#also keeps track of the current min (min_hundred) still on the highest hundred, and
#shifts it off if a higher number is reached (the test keeps lower numbers, because these could
#be between the min and lowest of the hundred but still in the highest hundred (e.g., if min = 10, 
#and min of the hundred was 50, 49 still might be within the highest hundred even though it is
#lower than the lowest in the current hundred array (which has been shifted several times).

#When the cache reaches 100 (size doesn't seem to affect performance much -- but it is slightly
#faster than sorting every replacement) or the length of the hundred array is down to 1, 
#the test and hundred arrays are combined and sorted and the variables are reset.

#This takes about 7.2 seconds for 100M digits and 71.2 for 1B -- slightly faster than 1 and 3 (below). 
def biggest_hundred_two(n)

  hundred = n[0..99]
  hundred.sort!
  min = hundred.first
  min_hundred = min 
  min_test = 0
  test = []
  test_length = 0
  
  n[100..-1].each do |num|
    if num > min 
      test << num 
      test_length += 1

      if hundred.first && num > min_hundred
        hundred.shift
        min_hundred = hundred.first
      end
      
      if test_length == 100 || hundred.length == 1
        hundred = (test + hundred).sort![-100..-1]
        test = []
        test_length = 0
        min = hundred.first 
        min_hundred = min
      end

    end
  end

  hundred = (test + hundred).sort![-100..-1]

end

#A "naive" implementation that sorts every time a number is replaced.  It is a bit slower than two
#for 100M (7.7s) and 1B (75.3s), but faster than one.

def biggest_hundred_three(n)

  hundred = n[0..99]
  hundred.sort!
  min = hundred.first
  
  n[100..-1].each do |num|
    if num > min 
      hundred[0] = num 
      hundred.sort!
      min = hundred.first 
    end
  end

  hundred 

end

random_billion = (1..1000000).to_a.shuffle

#tests 

# 100.times do 
#   puts biggest_hundred(random_billion).last
# end

# 100.times do 
#   puts biggest_hundred_two(random_billion).last
# end

# 100.times do 
#   puts biggest_hundred_three(random_billion).last
# end


