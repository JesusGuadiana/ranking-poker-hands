
class HandEvaluator
	def getSimbol(hand)
		simbol = {"S" => 1, "D" => 2, "H" => 3, "C" => 4} #Values for the simbol of the card

		parsedSimbol = Array.new

		(0..4).each do |i|
			#Gets the second char of the card and searches the equivalence in the dictionary and insert it to the array
   			parsedSimbol[i] = simbol[hand[i].slice(1)]
		end
		return parsedSimbol	
	end


	def getCardValue(hand)
		#Value of each available card in the deck
		value = {"2" => 2, "3" => 3, "4" => 4, "5" => 5, "6" => 6, "7" => 7, "8" => 8, "9" => 9,"T" => 10,"J" => 11, "Q" => 12, "K" => 13,"A" => 14}
		
		parsedValue = Array.new

		(0..4).each do |i|
			#Gets the first char of the card and searches the equivalence in the dictionary to insert it to the array
   			parsedValue[i] = value[hand[i].slice(0)]
		end
		return parsedValue
	end


	def hasPair(hand)
		sortedHand = hand.sort
		#Compare the ordered cards by pairs of 2 looking for a pair in the hand
		if sortedHand[0] == sortedHand[1]
			return true
		elsif sortedHand[1] == sortedHand[2]
			return true
		elsif sortedHand[2] == sortedHand[3]
			return true
		elsif sortedHand[3] == sortedHand[4]
			return true
		else
			return false
		end
	end


	def hasTwoPairs(hand)
		
		sortedHand = hand.sort
		#Check for pairs in the positions 0,1 and 2,3 or 0,1 and 3,4
		if sortedHand[0] == sortedHand[1] && sortedHand[2] == sortedHand[3] || sortedHand[0] == sortedHand[1] && sortedHand[3] == sortedHand[4]
			return true
		else
			return false
		end

	end


	def hasThreeOfAKind(hand)
		sortedHand = hand.sort
		#Compare every group of 3 cards looking for a three of a kind
		if sortedHand[0] == sortedHand[1] && sortedHand[1] == sortedHand[2]
			return true
		elsif sortedHand[1] == sortedHand[2] && sortedHand[2] == sortedHand[3]
			return true
		elsif sortedHand[2] == sortedHand[3] && sortedHand[3] == sortedHand[4]
			return true
		else
			return false
		end
	end


	def hasStraigth(hand)
		sortedHand = hand.sort

		#If the hand contains an Ace and the 4th card is a 5 make ace value a 1 to create the straigth (a,2,3,4,5)
		if sortedHand[4] == 14 && sortedHand[3] == 5
			sortedHand[4] = 1
		end
		#If the cards are secuential its a Straight
		if sortedHand[0] == sortedHand[1] - 1 && sortedHand[1] == sortedHand[2] - 1 && sortedHand[2] == sortedHand[3] - 1 && sortedHand[3] == sortedHand[4] - 1
			return true
		else
			return false
		end
	end


	def hasFlush(hand)

		sortedSimbols = hand.sort
		#Because the string is order by simbols if the first simbol == the last simbol we have a Flush
		if sortedSimbols[0] == sortedSimbols[4]
			return true
		else 
			return false
		end
	end


	def hasFullHouse(hand)
		sortedValues = hand.sort
		#Look for a three of a kind and pair
		if sortedValues[0] == sortedValues[2] && sortedValues[3] == sortedValues[4] || sortedValues[0] == sortedValues[1] && sortedValues[2] == sortedValues[4]
			return true
		else
			return false
		end
	end


	def hasFourOfAKind(hand)
		sortedValues = hand.sort
		#Look for 4 of the same card the extra card should be in the beggining or end of the array
		if sortedValues[0] == sortedValues[3] || sortedValues[1] == sortedValues[4]
			return true
		else
			return false
		end
	end



	def return_points(hand)
		#Seperate the hand simbols and values to send as parameters depending on the operation
		value = getCardValue(hand)
		simbol = getSimbol(hand)
		#Return score from 0 to 800 depending on strength of hand
		if hasStraigth(value) && hasFlush(simbol)
			return 800
		elsif hasFourOfAKind(value)
			return 700
		elsif hasFullHouse(value)
			return 600
		elsif hasFlush(simbol)
			return 500
		elsif hasStraigth(value)
			return 400
		elsif hasThreeOfAKind(value)
			return 300
		elsif hasTwoPairs(value)
			return 200
		elsif hasPair(value)
			return 100
		else
			return 1
		end
	end

	def kickerValue (hand)
		#Sort the recieved hand and return the last element of the array (Strongest card or kicker)
		value = getCardValue(hand).sort
		simbol = getSimbol(hand).sort

		if hasStraigth(value) && hasFlush(simbol)
			#Straight Flushes decided their kicker by highest card
			return value[4].to_i
		elsif hasFourOfAKind(value)
			#The middle card is always part of the Four of a kind so we use as a kicker
			return value[2].to_i
		elsif hasFullHouse(value)
			#We add a card of the pair and a card of the three of a kind to get the best full house
			return value[1].to_i + value[3].to_i
		elsif hasFlush(simbol)
			#The kicker can be the greates card of the deck
			return value[4].to_i
		elsif hasStraigth(value)
			#The kicker will be the greatest card of the deck
			return value[4].to_i
		elsif hasThreeOfAKind(value)
			#A card representing the tree of a kind will always be in position 2 of the array so we use as a kicker for other three of a kind
			return value[2].to_i 
		elsif hasTwoPairs(value)
			#The card in the position 3 of the array will always be the kicker by default?????????
			return value[3].to_i + value[0].to_i
		elsif hasPair(value) 
			#The pair with the greates card wins
			return value[4].to_i
		else
			return 0
		end

	end

	def return_stronger_hand(left, right)
		#Get the score for each of the hands
		pointsLeft = return_points(left)
		pointsRight = return_points(right)

		#If its a tie call kicker function to add the kickercard score for each
		if pointsRight == pointsLeft
			pointsLeft += kickerValue(left)
			pointsRight += kickerValue(right)
		end

		sortedLeftHand = left.sort
		sortedRightHand = right.sort
		#Special get highest pair in the case of TwoPairs and add 1 to the score to solve the tie
		if hasTwoPairs(getCardValue(left)) && hasTwoPairs(getCardValue(right))
			if sortedLeftHand[3] > sortedRightHand[3]
				pointsLeft += 1
			else
				pointsRight += 1
			end
		end

		#Compare the scores of each hand and decide a winner deck
		if pointsRight > pointsLeft
			return right
		else 
			return left	
		end
	end
end
