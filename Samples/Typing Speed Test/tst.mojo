from python import Python
from time import now
import math

fn main():
    alias wordCount: Int = 22  # Number of words
    var words = List[String]()
    var txt: String = ""
    try:
        with open("sample_words.txt", "r") as f:
            # Split words by SPACE
            words = f.read().split(' ')
    except:
        print('Error opening "sample_words" text file.')
        return
    random.seed()  # Seed to generate random numbers each time
    var iter: Int = 0
    var prevIndex: UInt64 = 0
    while iter < wordCount:
        var randNum: UInt64 = random.random_ui64(0, 849)  # Generate an unsigned random number between 0 to 849
        # Skip if chosen index and previous index are the same
        if iter > 0 and randNum == prevIndex:
            continue
        prevIndex = randNum
        # Add word to the text
        txt += words[int(randNum)]
        if iter != wordCount - 1:
            txt += " "
        iter += 1

    var txtSize: Int = len(txt)
    try:
        var py = Python.import_module('builtins')
        var score: Int = 0
        print ("-------------------------")
        print(txt)
        _ = py.input('PRESS ENTER THEN START TYPING...')
        var t: Float64 = now()  # Get current time
        var input: String = str(py.input())
        t = (now() - t) / 1000000000.0  # Calculate elapsed time
        for i in range(len(input)):
            if txt[i] == input[i]:
                score += 1
            if i == txtSize - 1:
                break
        var letterCount: Int = math.min(len(input), txtSize)
        var wpm: Int = int(math.round((letterCount / 5) / (t / 60)))
        var acc: Int = int(math.round(score / txtSize * 100))
        print ("WPM:", wpm)
        print ("Accuracy: " + str(acc) + "%")
    except:
        print('Error importing modules!')
