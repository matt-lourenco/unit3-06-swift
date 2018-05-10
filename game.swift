//
//  game.swift
//  This program simulates a game of Tic Tac Toe
//
//  Created by Matthew Lourenco on 10/05/18.
//  Copyright © 2018 MTHS. All rights reserved.
//

// Extension retrieved from this source:
// https://stackoverflow.com/questions/45497705/subscript-is-unavailable-cannot-subscript-string-with-a-countableclosedrange
extension String {
    subscript (bounds: CountableClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start...end])
    }

    subscript (bounds: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start..<end])
    }
}

enum Shapes: Int {
	case VOID = 0
	case O = -1
	case X = 1
}

public class Game {
	
	
	
	/** This is a grid of shapes used in a Tic Tac Toe game. The computer is
	 * O and the user is X. x is vertical and positive in the downward
	 * direction. y is horizontal and positive in the right direction. */
	var grid: [[Shapes]] = [[],[],[]]
	
	
	/** This array keeps track of the chances to win when choosing
	 *  Each tile on the grid.*/
	var winChances: [[Int]] = [[],[],[]]
	
	
	init() {
		//Default constructor
		
		//Fill grid with void and chances with 0
		for row in 0...2 {
			for _ in 0...2 {
				grid[row].append(.VOID)
				winChances[row].append(0)
			}
		}
	}
	
	func playGame() {
		//Play a game of Tic Tac Toe
		
		printGrid(grid: grid)
		placeShape()
		
		var filledTiles: Int = 1
		var cpuTurn: Bool = true
		
		while findWinner(grid: grid) == Shapes.VOID && filledTiles < 9 {
			
			if cpuTurn  {
				startGen(grid: cloneGrid(grid: grid))
				choosePlay()
			} else {
				printGrid(grid: grid)
				placeShape()
			}
			filledTiles += 1
			cpuTurn = !cpuTurn
		}
		
		printGrid(grid: grid)
		
		if findWinner(grid: grid) == Shapes.VOID {
			print("You tied!")
		} else if findWinner(grid: grid) == Shapes.O  {
			print("You lost. Too bad.")
		} else {
			print("You wont ever see this because it's impossible to win but hey, congrats.")
		}
	}
	
	func cloneGrid(grid: [[Shapes]]) -> [[Shapes]] {
		//Create a clone of the inputted grid
		
		var gridClone: [[Shapes]] = [[],[],[]]
		
		for row in 0...2 {
			for tile in 0...2 {
				gridClone[row].append(grid[row][tile])
			}
		}
		
		return gridClone
	}
	
	func placeShape() {
		//Ask the user where they want to place a shape and try to place it.
		var x: Int = 0
		var y: Int = 0
		
		while true {
			print("Input coordinates of your next shape: (Two separated numbers)")
			
			//Get user input
			let input: String? = readLine(strippingNewline: true)
			
			if input != nil {
				if input!.count == 3 {
					if Int(String(input![0...0])) != nil && Int(String(input![2...2])) != nil {
						x = Int(String(input![0...0]))!
						y = Int(String(input![2...2]))!
						
						if x > 0 && x < 4 && y > 0 && y < 4 {
							//Edit coordinate input to conform to setup of grid
							if grid[-1*y + 3][x - 1] == Shapes.VOID {
								break
							} else {
								print("That square is already filled")
							}
						} else {
							print("Enter integers between 1 and 3")
						}
					}
				} else {
				print("Enter two separated numbers")
				}
			}
		}
		
		//Edit coordinate input to conform to setup of grid
		grid[-1*y + 3][x - 1] = Shapes.X
	}
	
	func findWinner(grid: [[Shapes]]) -> Shapes {
		//Finds the winner on the board
		
		if grid[0][0] == grid[0][1] && grid[0][0] == grid[0][2] && grid[0][0] != Shapes.VOID {
			return grid[0][0]
		} else if grid[1][0] == grid[1][1] && grid[1][0] == grid[1][2] && grid[1][0] != Shapes.VOID {
			return grid[1][0]
		} else if grid[2][0] == grid[2][1] && grid[2][0] == grid[2][2] && grid[2][0] != Shapes.VOID {
			return grid[2][0]
		} else if grid[0][0] == grid[1][0] && grid[0][0] == grid[2][0] && grid[0][0] != Shapes.VOID {
			return grid[0][0]
		} else if grid[0][1] == grid[1][1] && grid[0][1] == grid[2][1] && grid[0][1] != Shapes.VOID {
			return grid[0][1]
		} else if grid[0][2] == grid[1][2] && grid[0][2] == grid[2][2] && grid[0][2] != Shapes.VOID {
			return grid[0][2]
		} else if grid[0][0] == grid[1][1] && grid[0][0] == grid[2][2] && grid[0][0] != Shapes.VOID {
			return grid[0][0]
		} else if grid[0][2] == grid[1][1] && grid[0][2] == grid[2][0] && grid[0][2] != Shapes.VOID {
			return grid[0][2]
		} else {
			return Shapes.VOID
		}
	}
	
	func userClose(grid: [[Shapes]]) -> Bool {
		//Finds if the winner a turn away from winning
		
		if grid[0][0].rawValue + grid[0][1].rawValue + grid[0][2].rawValue == 2 {
			return true
		} else if grid[1][0].rawValue + grid[1][1].rawValue + grid[1][2].rawValue == 2 {
			return true
		} else if grid[2][0].rawValue + grid[2][1].rawValue + grid[2][2].rawValue == 2 {
			return true
		} else if grid[0][0].rawValue + grid[1][0].rawValue + grid[2][0].rawValue == 2 {
			return true
		} else if grid[0][1].rawValue + grid[1][1].rawValue + grid[2][1].rawValue == 2 {
			return true
		} else if grid[0][2].rawValue + grid[1][2].rawValue + grid[2][2].rawValue == 2 {
			return true
		} else if grid[0][0].rawValue + grid[1][1].rawValue + grid[2][2].rawValue == 2 {
			return true
		} else if grid[0][2].rawValue + grid[1][1].rawValue + grid[2][0].rawValue == 2 {
			return true
		} else {
			return false
		}
	}
	
	func printGrid(grid: [[Shapes]]) {
		//Prints the grid
		print("+---+---+---+")
		
		for row in 0...2 {
			print("| ", terminator:"")
			for shape in grid[row] {
				if shape == Shapes.VOID { //Print a space if blank
					print("  | ", terminator:"")
				} else {
					print("\(shape) | ", terminator:"")
				}
			}
			print("\n+---+---+---+")
		}
	}
	
	func startGen(grid: [[Shapes]]) {
		//Start the recursive generation every possible state of the board
		
		for row in 0...2 {
			for tile in 0...2 {
				
				winChances[row][tile] = 0 //Return win chances to zero
				
				if grid[row][tile] == Shapes.VOID {
					var gridClone: [[Shapes]] = cloneGrid(grid: grid)
					gridClone[row][tile] = Shapes.O
					genPossibilities(grid: gridClone, tilesFilled: 2, cpuTurn: false, originalX: row, originalY: tile)
				}
			}
		}
	}
	
	func genPossibilities(grid: [[Shapes]], tilesFilled: Int, cpuTurn: Bool, originalX: Int, originalY: Int) {
		//Recursively generate every state of the board
		
		//Check if a winner was decided
		if tilesFilled == 9 && findWinner(grid: grid) == Shapes.VOID {
			return
		}
		//return if cpu wins
		if findWinner(grid: grid) == Shapes.O {
			return
		}
		//reduced win chances if user wins
		if findWinner(grid: grid) == Shapes.X {
			winChances[originalX][originalY] -= 9 - tilesFilled
			return
		}
		//prioritize blocking the user
		if userClose(grid: grid) && cpuTurn {
			winChances[originalX][originalY] += 9 - tilesFilled
		}
		
		//If no winner has been decided, clone the grid and check the next move
		for row in 0...2 {
			for tile in 0...2 {
				if grid[row][tile] == Shapes.VOID {
					
					var gridClone: [[Shapes]] = cloneGrid(grid: grid)
					if cpuTurn {
						gridClone[row][tile] = Shapes.O
					} else {
						gridClone[row][tile] = Shapes.X
					}
					
					genPossibilities(grid: gridClone, tilesFilled: tilesFilled + 1, cpuTurn: !cpuTurn, originalX: originalX, originalY: originalY);
				}
			}
		}
	}
	
	func choosePlay() {
		//Chooses the play that has the highest chance of success
		
		var chance = [0, 0]
		
		//Find the best possible move
		for row in 0...2 {
			for tile in 0...2 {
				//Find a valid empty space to start checking
				if grid[chance[0]][chance[1]] != Shapes.VOID {
					chance[0] = row
					chance[1] = tile
				}
				if grid[row][tile] == Shapes.VOID && winChances[row][tile] > winChances[chance[0]][chance[1]] {
					chance[0] = row
					chance[1] = tile
				}
			}
		}
		
		//Place a shape
		if grid[chance[0]][chance[1]] == Shapes.VOID {
			grid[chance[0]][chance[1]] = Shapes.O
		}
	}
}

let game = Game()
game.playGame()