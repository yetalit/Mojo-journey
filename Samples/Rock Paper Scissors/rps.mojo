from python import Python
from sys import exit

fn main():
	random.seed()  # Seed to generate random numbers each time
	print('Rock, Paper, Scissors - Shoot!')
	try:
		var py = Python.import_module('builtins')
		
		alias choices = List[String]('r', 'p', 's')
		
		while True:
			var user_choice = str(py.input('Choose your weapon'
							   ' [r]ock, [p]aper, or [s]cissors: '))
			
			if not user_choice in choices:
				print('Please choose one of these letters:')
				print('[r]ock, [p]aper, or [s]cissors')
				continue

			print('You chose:', user_choice)

			var randNum = int(random.random_ui64(0, 2))  # Generate an unsigned random number between 0 to 2
			var opp_choice = choices[randNum]
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

			while True:
				var response = str(py.input('Do you wish to play again? [y/n]: '))
				if response == 'y':
					break
				elif response == 'n':
					print('Thanks for playing!')
					exit(0)
				print('y or n only')
	except:
		print('Error importing modules!')
