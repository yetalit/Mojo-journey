from python import Python
from python import PythonObject

fn check_play_status(borrowed py: PythonObject) raises -> Bool:
	while True:
		var response: String = str(py.input('Do you wish to play again? [y/n]: '))
		if response != 'y' and response != 'n':
			print('y or n only')
			continue

		if response == 'y':
			return True
		else:
			return False


fn main():
	var play: Bool = True
	random.seed()  # Seed to generate random numbers each time
	print('Rock, Paper, Scissors - Shoot!')
	try:
		var py = Python.import_module('builtins')
		var np = Python.import_module('numpy')
		
		var choices = np.array(['r', 'p', 's'])
		
		while play:
			var user_choice: String = str(py.input('Choose your weapon'
							   ' [r]ock, [p]aper, or [s]cissors: '))
			
			if user_choice != 'r' and user_choice != 'p' and user_choice != 's':
				print('Please choose one of these letters:')
				print('[r]ock, [p]aper, or [s]cissors')
				continue

			print('You chose:', user_choice)

			var randNum: UInt64 = random.random_ui64(0, 2)  # Generate an unsigned random number between 0 to 2
			var opp_choice: String = choices[randNum]
			print('I chose:', opp_choice)

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
			play = check_play_status(py)
	except:
		print('Error importing modules!')
		
		
	print('Thanks for playing!')