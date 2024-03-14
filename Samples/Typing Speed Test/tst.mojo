from python import Python
from time import now
from collections.vector import DynamicVector

fn main():
    alias wordCount: Int = 22  # Number of words
    var words = DynamicVector[String]()
    try:
        with open("sample_words.txt", "r") as f:
            # Split words by SPACE
            words = f.read().split(' ')
    except:
        print('Error opening "sample_words" text file.')
        return
    random.seed()  # Seed to generate random numbers each time
    var randNums = DynamicVector[UInt64]()  # Chosen random words' indexes
    for i in range(wordCount):
        var randNum: UInt64 = random.random_ui64(0, 849)  # Generate an unsigned random number between 0 to 849
        for j in range(len(randNums)):
            # Check if it's already chosen
            if randNums[j] == randNum:
                i -= 1
                break
        randNums.append(randNum)

    var txt: String = ""

    for i in range(wordCount):
        txt += words[randNums[i].to_int()]
        if i != wordCount - 1:
            txt += " "
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
        var wpm: Int = math.round((letterCount / 5) / (t / 60)).to_int()
        var acc: Int = math.round(score / txtSize * 100).to_int()
        print ("WPM:", wpm)
        print ("Accuracy: " + str(acc) + "%")
    except:
        print('Error importing modules!')