sentinences
===========

A fun little program I wrote in Ruby to generate random sentences out of my brother's Grade 10 history essay.

Next steps:
  * To reduce possibility for error, a separate script will take the raw input and produce a new file that would contain each string token (word, punctuation) separated by spaces. This will save the main script from having to repeatedly parse the input.
  * To take this one step further, the same script can instead generate the link information, listing all generated links in a file in the form: <source> <destination> <link_strength>, so the main program also does not have to generate links (operation is O(n^2))
  * I would also like to one day implement this into a web application.
