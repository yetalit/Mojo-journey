from python import Python

fn main():
	try:
		var py = Python.import_module('builtins')

		random.seed()  # Seed to generate random numbers each time
		var randNum: UInt64 = random.random_ui64(1, 10)  # Generate an unsigned random number between 1 to 10
		var guess: UInt64 = 0

		print("Guess a number between 1 and 10")
		while randNum != guess:
			try:
				guess = atol(str(py.input()))  # Convert user input to String then to int
				print("You guessed: " + str(guess))

				if guess < randNum:
					print(guess, "is too low!")  
				elif guess > randNum:  
					print(guess, "is too high!")  
				else:
					print("You guessed correct!")
			except:
				print("Please Enter a number...")
	except:
		print('Error importing modules!')