import sys

practical = {
	"progra": 	[8, 0],
	"dsal":		[8, 0],
	"dbis":		[6, 0],
	"swt":		[6, 0]
}

theoretical = {
	"fosap":	[6, 0],
	"buk":		[7, 0],
	"malo":		[7, 0]
}

math = {
	"ds":		[6, 0],
	"afi":		[8, 0],
	"la":		[6, 0],
	"stocha":	[6, 0]
}

technical = {
	"ti":		[6, 0],
	"bus":		[6, 0],
	"datkom":	[6, 0]
}

misc = {
	"prosem":	[3, 0],
	"sem":		[5, 0]
}

app = {
	
}

groups = [["practical", practical], ["theoretical", theoretical], ["math", math], ["technical", technical], ["misc", misc], ["app", app]]

greeting = "please enter the grades you received for the following classes"
divider = "-------------------------------------------------------------- \n"
infoLength = len(greeting)

def divider(length, text):	
	if (length < len(text)):
		print(text + "\n")
		return

	out = text
	for x in range(0, (length-len(text))):
		out += "-"
	
	print(out + "\n")

def formatOutputString(name, decimal):
	return "%*s: %*f"%(15, name, 5, decimal)


def cutOffDecimalPlaces(number):
	return int(number * 10) / 10.0


def groupResult(group):
	weightedGrades = 0.0
	cpGroup = 0.0
	for key in group[1]:
		cpGroup += group[1][key][0]
		weightedGrades += group[1][key][0] * group[1][key][1]
	print("%*s: empty" %(15, group[0])) if group[1] == {} or cpGroup == 0 else print(formatOutputString(group[0], cutOffDecimalPlaces(weightedGrades / cpGroup)))
	return (cpGroup, weightedGrades)


def main():
	print(greeting + "\n")
	print("please enter 0 if there's no grade yet or if you want to delete notes\n")
	for group in groups:
		divider(infoLength, group[0])
		for key in group[1]:
			while True:
				try:
					print(key + ": ")
					group[1][key][1] = float(input())
				except Exception as e:
					divider(infoLength, "please enter a valid float")
				else:
					break

			if group[1][key][1] == 0:
				group[1][key][0] = 0		

	print("enter additional grades and cp like \"cp,grade\"")
	print("to stop, enter 0")
	gradeID = 0
	while True:
		userInput = str(input()).split(',', 1)
		if userInput[0] == "0":
			break
		try:
			app[gradeID] = [int(userInput[0]), float(userInput[1])]
		except Exception as e:
			print("please enter new entry like \"cp,grade\" or enter 0 to stop")	
		
		gradeID += 1

	divider(infoLength, "results")
	cpGlobal = 0
	weightedGradesGlobal = 0
	for group in groups:
		res = groupResult(group)	
		cpGlobal += res[0]
		weightedGradesGlobal += res[1]
		
	
	print(formatOutputString("global", (cutOffDecimalPlaces(weightedGradesGlobal / cpGlobal))))
	


main()