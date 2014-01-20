class Link
  attr_accessor :src
  attr_accessor :dest
  attr_accessor :n
  def initialize(src, dest) #src word and dest word
    @src = src
    @dest = dest
  end
  
  def == (another_link)
    self.src == another_link.src && self.dest == another_link.dest
  end
end

def isAlpha (letter)
  return 'a' <= letter && letter <= 'z' || '0' <= letter && letter <= '9'
end

fileName = "alex"
counter = 1
file = File.new(fileName, "r")
doc = []
punctuation = ['.', ',', '!', '?', ':', ';', '(', ')', '\'', '\"']
while line = file.gets(' ')
  openBracket = ""
  pre = ""
  word = line.tr("\n",' ').strip
  post = ""
  closeBracket = ""
  if word.length == 0 || word == "\n"
    next
  end
  lowercase = word.downcase
 
  while lowercase.length > 0 && !isAlpha(lowercase.chars[0])
    pre = pre + lowercase.chars[0]
    lowercase = lowercase.slice(1, lowercase.length-1)
    word = word.slice(1, word.length-1)
  end 
  while pre.length > 0 && pre.chars[0] == '('
    openBracket = openBracket + '('
    pre = pre.slice(1, pre.length-1)
  end
  while lowercase.length > 0 && !isAlpha(lowercase.chars[lowercase.length-1])
    post = lowercase.chars[lowercase.length-1] + post
    lowercase = lowercase.slice(0, lowercase.length-1)
    word = word.slice(0, word.length-1)
  end
  while post.length > 0 && post.chars[0] == ')'
    closeBracket = ')' + closeBracket
    post = post.slice(1, post.length-1)
  end
  while post.length > 0 && post.chars[post.length-1] == ')'
    closeBracket = closeBracket + ')'
    post = post.slice(0, post.length-1)
  end
  
  if (openBracket.length > 0)
    doc.push(openBracket)
  end
  if (pre.length > 0)
    doc.push(pre)
  end
 
  if (word.length > 0)
    doc.push(word)
  end  
  if (closeBracket.length > 0)
    doc.push(closeBracket)
  end
  if (post.length > 0)
    doc.push(post)
  end
end #doc is now filled

=begin
doc.each { |word|
  puts word
  }
=end

#now we need to create all of the links, making sure that they are unique and can update properly
links = []
starters = []
hash = Hash.new(0)
for i in 0...(doc.length-1)
  if ('A' <= doc[i].chars[0] && doc[i].chars[0] <= 'Z')
    starters.push(doc[i])
  end
  link = Link.new(doc[i], doc[i+1])
  flag = 0
  for j in 0...(links.length)    
    if (link == links[j])
      hash[links[j]] += 1
      flag = 1
      break;
    end
  end
  if (flag == 0)
    links.push(link)
    hash[link] = 1
  end
end #Done creating links.
#The loop below will show the count on each link.
#hash.each_key { |key| puts ("(" + key.src + ", " + key.dest + "): " + "#{hash[key]}") }

#start the sentence
sentence = [] #sentence empty to start
r = rand(starters.size) #choose a random starting word
sentence.push(starters[r])
numWords = 1
lastWord = sentence[numWords-1]

singleQuote = 0
doubleQuote = 0
bracket = 0
sentenceEnders = ['.', '!', '?']

until (sentenceEnders.include?(lastWord) && singleQuote == 0 && doubleQuote == 0 && bracket == 0) || numWords > 200
roulette = []
rouletteWords = []
rouletteSum = 0
count = 0
hash.keys.each { |key| # generate roulette
  if key.src == lastWord
    rouletteSum += hash[key]
    roulette[count] = rouletteSum
    rouletteWords[count] = key.dest    
    count += 1
  end
#puts ("(" + key.src + " " + key.dest + ")" + ": " + "#{hash[key]}")
  }

r = rand(rouletteSum)

for i in 0...count #see which word in the roulette will follow the current word
  if r <= roulette[i]
    #puts count
    sentence.push(rouletteWords[i])
    #puts lastWord + " " + rouletteWords[i]
    if ['('].include?(rouletteWords[i])
      bracket += 1
    end
    if [')'].include?(rouletteWords[i])
      bracket -= 1
    end
    if (rouletteWords[i] == '\'')
      singleQuote += 1
      singleQuote = singleQuote % 2
    end
    if (rouletteWords[i] == '\"')
      doubleQuote += 1
      doubleQuote = doubleQuote % 2
    end
    numWords += 1
    lastWord = sentence[numWords-1]
    #puts "#{bracket}, #{singleQuote}, #{doubleQuote}"
    break
  end
end
end #ends the sentence building

=begin
for i in 0...sentence.size
  puts sentence[i] + "/"
end
=end

#=begin
print "\n"
noSpaceBefore = ['.', ',', ';', '!', '?', ':', ')']
needSpaceBefore = ['(']
noSpaceAfter = ['(']
for i in 0...sentence.size
  preSpace = 1
  firstChar = sentence[i].downcase.chars[0]
  if i == 0
    preSpace = 0
  else
    if noSpaceBefore.include?(firstChar) || noSpaceAfter.include?(sentence[i-1].downcase.chars[0])
      preSpace = 0
    end
    if needSpaceBefore.include?(firstChar)
      preSpace = 1
    end
    preSpace.times do
      print " "
    end
  end
  print sentence[i]
end
print "\n"
#=end

file.close