

PARSE_TARGET = [
	int, 'tests', 'completed,', int, 'failed'
]

def get_pass_rate(log):
	split_by_line = log.split('\n')
	collected = []
	#iterate over the lines
	for line in split_by_line:
		split_by_space = line.split(' ')
		# print(split_by_space)
		# print()
		if(len(split_by_space) == 5 and split_by_space[1] == "BUILD" and split_by_space[2] == "SUCCESSFUL"):
			collected.append('success')
		#checking if it's the right amount of words
		if len(split_by_space) != len(PARSE_TARGET)+1:
			continue
		
		#temporary collection, if the word loop never breaks, this list will be dumped into the main collection
		temp_collected = []
		
		#because im using continue, I started the iterator at -1 and incremented it by one before the loop body
		i = -1
		#iterate over the words
		for word in split_by_space[1:]:
			i += 1
			#if the current element in the PARSE_TARGET is a function, meaning data extraction
			if callable(PARSE_TARGET[i]):
				#making sure the current word parses correctly
				try:
					temp_collected.append(
						PARSE_TARGET[i](word)
					)
				except:
					#if it doesn't parse correctly this means it's not a valid integer or whatever
					break
				continue
			#getting here means it's not callable so therefore it must be a word to match
			if word == PARSE_TARGET[i]:
				continue
			#this means it's not callable and the word didn't match
			break
		#if it was run the correct number of times (didn't break)
		if i == len(PARSE_TARGET) - 1:
			for e in temp_collected:
				collected.append(e)
	
	return collected
