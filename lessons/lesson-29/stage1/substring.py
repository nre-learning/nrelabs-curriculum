def is_a_substring(str1, str2):
	if str1 not in str2:
		raise Exception("{} is not a substring of {}".format(str1,str2))
