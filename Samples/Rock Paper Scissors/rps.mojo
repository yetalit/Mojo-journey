from python import Python

fn check_play_status() -> Bool:
	while True:
		try:
			var py = Python.import_module('builtins')
			var response: String = str(py.input('Do you wish to play again? [y/n]: '))
			if response != 'y' and response != 'n':
				print('y or n only')
				continue

			if response == 'y':
				return True
			else:
				return False
		except:
			print('Error importing modules!')


fn main():
	var play: Bool = True
	random.seed()  # Seed to generate random numbers each time
	print('Rock, Paper, Scissors - Shoot!')
	try:
		var py = Python.import_module('builtins')
		var np = Python.import_module('numpy')
		
		while play:
			var user_choice: String = str(py.input('Choose your weapon'
							   ' [r]ock, [p]aper, or [s]cissors: '))
			
			if user_choice != 'r' and user_choice != 'p' and user_choice != 's':
				print('Please choose one of these letters:')
				print('[r]ock, [p]aper, or [s]cissors')
				continue

			print('You chose:', user_choice)

			var randNum: UInt64 = random.random_ui64(0, 2)  # Generate an unsigned random number between 0 to 2
			var choices = np.array(['r', 'p', 's'])
			var opp_choice: String = choices[randNum]
			print('I chose:', choices[randNum])

			if opp_choice == user_choice:
				print('Tie!')
			elif opp_choice == 'r' and user_choice == 's':
				print('Rock beats scissors, I win!')
			elif opp_choice == 's' and user_choice == 'p':
				print('Scissors beats paper! I win!')
			elif opp_choice == 'p' and user_choice == 'r':
				print('Paper beats rock, I win!')
			else:
				print('You win!')
			play = check_play_status()
	except:
		print('Error importing modules!')
		
		
	print('Thanks for playing!')